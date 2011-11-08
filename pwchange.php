<?php
// $Id: pwchange.php,v 1.7 2006/01/01 16:26:54 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.
//
// this form is used to generate a new password for a user

require_once 'siteframe.inc';

// check to see that the user is logged in
if (is_object($_SESSION['user']) && $_SESSION['user']->id())
    ;
else 
{
    header(sprintf('Location: %s/login.php?rd=%s', 
    		config('site_url'), 
    		urlencode($_SERVER['REQUEST_URI'])));
    exit;
}

$PAGE->assign('page_title', lang('page_title_pwchange'));

// process submitted form
if ($_POST['_submitted'])
{
    $old = $_POST['pw_old'];
    $new1 = $_POST['pw_new1'];
    $new2 = $_POST['pw_new2'];
    
    $user = clone $_SESSION['user'];

    // initial error checking
    if ($new1 == '')
        $user->add_error(lang('err_fieldtooshort'), lang('prompt_pw_new1'), 6);
    if ($new1 != $new2)
        $user->add_error(lang('err_nomatch'), lang('prompt_pw_new1'));
    
    // attempt to update it
    if ($user->is_valid())
        $user->update_password($old, $new1);
    
    if (!$user->is_valid())
        $PAGE->assign('error', $user->get_errors());
    else
    {
        $PAGE->assign('error', lang('msg_pwchange'));
        logout();
        $PAGE->display();
        exit;
    }
}

// build the input form

$inf = new InputForm(
	'pwchange',
	$_SERVER['SCRIPT_NAME'],
	'post',
	lang('submit_pwchange')
);
$inf->add_item('pw_old', array(
    'type' => 'password',
    'size' => 30,
));
$inf->add_item('pw_new1', array(
    'type' => 'password',
    'size' => 30,
));
$inf->add_item('pw_new2', array(
    'type' => 'password',
    'size' => 30,
));

// assign some help text
$PAGE->assign('help_text', lang('help_pwchange'));
$PAGE->assign('edit_form', $inf->get_form());
$PAGE->display();
?>