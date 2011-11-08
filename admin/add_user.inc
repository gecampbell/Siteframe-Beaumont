<?php
// $Id: add_user.inc,v 1.1 2005/12/05 20:11:11 glen Exp $
// Copyright(c)2005, Glen Campbell. All rights reserved.
// MODULE(Add New User)

$PAGE->assign('page_title', 'Add New User');

// create a new user object
$u = new User;

// set error flag
$errflag = FALSE;

// handle form submissions
if ($_POST['_submitted'])
{
    $u->set_post($_POST);
    $u->add();
    if (!$u->is_valid())
    {
        ++$errflag;
        $PAGE->assign('error', $u->get_errors());
    }
    else
        $PAGE->assign('error', 'User added');
}

if (!$errflag)
    $u = new User;

$PAGE->assign('admin_content', 
    $u->form(
        'newuser',
        $_SERVER['REQUEST_URI'],
        'post',
        'Add User'));
?>