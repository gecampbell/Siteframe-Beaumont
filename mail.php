<?php
// $Id: mail.php,v 1.16 2006/02/23 17:43:38 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.
// This script allows the current user to send e-mail to another user.

require_once 'siteframe.inc';

// check to see that the user is logged in
if (is_object($_SESSION['user']) && $_SESSION['user']->id())
    ;
else {
    header('Location: login.php?rd='.urlencode($_SERVER['REQUEST_URI']));
    exit;
}

$PAGE->assign('page_title', sprintf(lang('page_title_mail'), 'User'));

if (isset($_GET['to']))
{
    $to = new User($_GET['to']);
    if ($to->get('user_id') != $_GET['to'])
    {
        $PAGE->assign('error', sprintf(lang('err_nouserid'), htmlentities($_GET['to'])));
        $PAGE->display();
        exit;
    }
    $PAGE->assign('page_title', sprintf(lang('page_title_mail'), $to->get('user_name')));
}
else if (isset($_GET['group']))
{
    $group = new Group($_GET['group']);
    if ($group->id() != $_GET['group'])
    {
        $PAGE->assign('error', sprintf(lang('err_nogroupid'), htmlentities($_GET['group'])));
        $PAGE->display();
        exit;
    }
    $PAGE->assign('page_title', sprintf(lang('page_title_mail'), $group->get_title()));
}

if (isset($_POST['_submitted']))
{
    $em = new HtmlEmail($_POST['mail_subject']);
    if (!$_POST['mail_hide'])
        $em->from($_SESSION['user']->id());
    if (isset($_GET['to']))
        $em->to($to->get('user_email'));
    else
        $em->to_group($group->id());
    $PAGE->assign('message', strip_tags($_POST['mail_body'], config('allowed_html')));
    $em->send_template(site_template('mail'));
    if ($em->is_valid())
    {
        $PAGE->assign('error', lang('msg_sent'));
        if ($_GET['to'])
            header('Location: '.$to->get_url());
        else
            header('Location: '.$group->get_url());
    }
    else
        $PAGE->assign('error', $em->get_errors());
}
else
{
    $inf = new InputForm(
        'mail', 
        $_SERVER['REQUEST_URI'], 
        'post', 
        lang('submit_mail'));
    $inf->add_item('mail_subject', array(
        'type' => 'text',
        'size' => 40,
        'maxlength' => 250,
        'value' => $_GET['subj'],
    ));
    $inf->add_item('mail_body', array(
        'type' => 'textarea',
        'formatted' => config('send_html_email'),
        'value' => $_GET['text'],
    ));
    $inf->add_item('mail_hide', array(
        'type' => 'checkbox',
        'rval' => 1,
    ));
    $PAGE->assign('help_text', lang('help_mail'));
    $PAGE->assign('edit_form', $inf->get_form());
}

$PAGE->display();
?>
