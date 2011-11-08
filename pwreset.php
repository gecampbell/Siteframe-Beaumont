<?php
// $Id: pwreset.php,v 1.10 2006/05/03 01:31:48 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.
//
// this form is used to generate a new password for a user

require_once 'siteframe.inc';

$PAGE->assign('page_title', lang('page_title_pwreset'));

// process submitted form
if ($_POST['_submitted'])
{
    $u = new User;
    $q = sprintf("SELECT user_id FROM %s WHERE user_email='%s'",
            $u->table_name(),
            $_POST['reset_email']);
    $DB = Database::getReader();
    $result = $DB->query($q);
    check_db($DB);
    list($id) = $result->fetch_row();
    if (!$id)
        $PAGE->assign('error', 
            sprintf(lang('err_noemail'), $_POST['reset_email']));
    else
    {
        // create a new password
        $newpw = substr(sha1(microtime()), 3, 16);
        
        // save it in the user
        $user = new User($id);
        $user->update_password('', $newpw);
        
        if (!$user->is_valid())
            $PAGE->assign('error', $user->get_errors());
        else {
            $PAGE->assign('new_passphrase', $newpw);
            $em = new HtmlEmail(lang('pw_reset'));
            $em->to($user->get('user_email'));
            $em->send_template(config('pwreset_teplate','pwreset_email.tpl'));
            $PAGE->assign('error', lang('msg_pwreset'));
            $PAGE->display();
            exit;
        }
    }
}

// build the input form

$inf = new InputForm('pwreset', $_SERVER['SCRIPT_NAME'], 'post', lang('submit_pwreset'));
$inf->add_item('reset_email', array(
    'type' => 'text',
    'value' => $_POST['reset_email'],
));

$PAGE->assign('edit_form', $inf->get_form());
$PAGE->display();
?>
