<?php
// $Id: register.php,v 1.43 2006/05/03 01:31:48 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.

require_once 'siteframe.inc';

$PAGE->assign('page_title', lang('page_title_register'));

// do not allow logged-in users
if (is_object($_SESSION['user']) && $_SESSION['user']->id())
{
    $PAGE->assign('error', lang('err_register_login'));
    $PAGE->display();
    exit;
}

// do we allow registrations?
// create a new user
$u = new User;

// if submitted, then process the registration
if ($_POST['_submitted'])
{
    // validate captcha
    if (config('register_captcha',TRUE))
    {
        if ($_SESSION['v_captcha'] != $_POST['v_captcha'])
        {
            $PAGE->assign('error', lang('err_badcaptcha'));
            $PAGE->display();
            exit;
        }
    }
    $u->set_post($_POST);
    if ($u->is_valid())
    {
        // handle invitations
        if ($u->get('inv_id'))
        {
            $inv = new Invitation($u->get('inv_id'));
            if ($u->get('user_email') == $inv->get('inv_email'))
                $u->set('user_status', 1);
            $inv->set('inv_accepted', 1);
        }
        
        // add the user's record
        $u->add();
        
        // check for errors
        if (!$u->is_valid())
            $PAGE->assign('error', $u->get_errors());
        else
        {
            if ($u->get('inv_id'))
            {
                // indicate that the invitation was accepted
                $inv->set('friend_user_id', $u->id());
                $inv->update();
                
                // and log the user in
                setcookie(
                    config('login_cookie'),
                    $u->get('user_hash'),
                    0,
                    config('site_path')
                );
                
                // redirect
                header("Location: ".config('site_url', '/'));
                exit;
            }
            $PAGE->assign('error', lang('msg_registered'));
            $PAGE->display();
            exit;
        }
    }
    else
    {
        $PAGE->assign('error', $u->get_errors());
    }
}
else if ($_GET['i'])
    ; // ok with invitation
else if (!config('open_registration'))
{
    if (is_object($_SESSION['user']) && $_SESSION['user']->get('user_admin'))
        ; // this is ok
    else
    {
        $PAGE->assign('error', lang('err_noregister'));
        $PAGE->display();
        exit;
    }
}

$DB = Database::getReader();

// was there an invitation?
if (isset($_GET['i']))
{
    $inv = new Invitation;
    $q = sprintf(
        "SELECT inv_id FROM %s WHERE inv_hash='%s' AND inv_accepted=0",
        $inv->table_name(),
        $_GET['i']);
    $result = $DB->query($q);
    check_db($DB);
    list($id) = $result->fetch_row();
    if (!$id)
        $PAGE->assign('error', lang('err_noinvite'));
    else
    {
        $inv = new Invitation($id);
        $u->set('inv_id', $id);
        $u->set('user_firstname', $inv->get('inv_firstname'));
        $u->set('user_lastname',  $inv->get('inv_lastname'));
        $u->set('user_email',     $inv->get('inv_email'));
        $u->set('user_email2',    $inv->get('inv_email'));
    }
}

// construct the new input form
$u->reset_errors();

// build the captcha
if (config('register_captcha',TRUE))
{
    $captcha = rand(0,20) .
        (rand(0,1)?' + ':' - ') . 
        rand(0,10) . 
        (rand(0,1)?' + ':' - ') . 
        rand(0, 30);
    @eval('$answer='.$captcha.';');
    $_SESSION['v_captcha'] = $answer;
    $u->metadata = array_merge(
        array(
            'v_captcha' => array(
            'type' => 'text',
            'size' => 4,
            'prompt' => 'What is ('.$captcha.') ?',
            )
        ),
        $u->metadata
    );
}
$PAGE->assign('help_text', lang('help_register'));
$PAGE->assign('user_form',
    $u->form('user_form',
        $_SERVER['SCRIPT_NAME'],
        'POST',
        lang('prompt_register'),
        lang('prompt_reset')
    ));

$PAGE->display();
?>
