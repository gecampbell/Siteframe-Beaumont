<?php
// $Id: login.php,v 1.17 2006/05/03 01:31:48 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.

require_once 'siteframe.inc';

// first, logout
logout();

// handle alternate logins
if (config('alternate_login')!='')
{
    require config('alternate_login');
    exit;
}

// perform e-mail confirmation
if ($_GET['conf'] != '')
{
    $u = new User;
    $q = sprintf(
        "UPDATE %s SET user_status=%d WHERE user_hash='%s'",
        $u->table_name(),
        USER_STATUS_NORMAL,
        addslashes($_GET['conf'])
    );
    $DBW = Database::getWriter();
    $DBW->query($q);
    if ($DBW->errno)
        abort('err_db', $DBW->error);
    if ($DBW->affected_rows == 1)
        $PAGE->assign('error', lang('msg_confirmed'));
    else
        $PAGE->assign('error', lang('err_unconfirmed'));
}

// handle a submitted form
if ($_POST['_submitted'])
{
    $u = new User;
    $q = sprintf(
        "SELECT user_hash,user_status ".
        "FROM %s WHERE user_name='%s' AND user_password=%s('%s') ",
        $u->table_name(),
        addslashes(strip_tags($_POST['login_user'])),
        config('crypt_function'),
        addslashes($_POST['login_password'])
    );
    $DB = Database::getReader();
    $result = $DB->query($q);
    if ($DB->errno)
        abort(lang('err_db'), $DB->error);
    if ($result->num_rows == 0)
        $PAGE->assign('error', lang('err_login_notfound'));
    else
    {
        list($hash, $status) = $result->fetch_row();
        if (!$status)
            $PAGE->assign('error', lang('err_login_pending'));
        else // if we get here, then everything's ok
        {
            // remember me?
            if ($_POST['login_remember'])
                $expire = time()+(config('login_cookie_days')*60*60*24);
            else
                $expire = 0;
            // set the permanent login cookie
            setcookie(
                config('login_cookie'),     // cookie name
                $hash,                      // user hash
                $expire,
                config('site_path')
            );
            if ($_POST['rd_url'] != '')
                header('Location: '.strip_tags($_POST['rd_url']));
            else
                header('Location: '.config('site_url').'/');
            exit;
        }
    }
}

// if the rd= parameter is set, we're redirecting
if ($_GET['rd'] != '')
    $PAGE->assign('error', lang('msg_redirect'));

// display the login form
$inf = new InputForm('login', $_SERVER['SCRIPT_NAME'], 'post', lang('prompt_login'));
$inf->add_item('login_user', array(
    'type' => 'text',
    'value' => strip_tags($_POST['login_user']),
));
$inf->add_item('login_password', array(
    'type' => 'password',
    'value' => '',
));
$inf->add_item('login_remember', array(
    'type' => 'checkbox',
    'rval' => 1,
    'value' => strip_tags($_POST['login_remember']),
));
$inf->add_item('rd_url', array(
    'type' => 'text',
    'hidden' => true,
    'value' => strip_tags(($_GET['rd'] != '') ? $_GET['rd'] : $_POST['rd_url']),
));
$PAGE->assign('help_text', lang('help_login'));
$PAGE->assign('login_form', $inf->get_form());

$PAGE->display();
?>
