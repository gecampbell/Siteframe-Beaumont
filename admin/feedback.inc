<?php
// $Id: feedback.inc,v 1.5 2007/06/24 21:20:31 glen Exp $
// Copyright(c)2005, Glen Campbell. All rights reserved.
// MODULE(Submit feedback on Siteframe)

$PAGE->assign('page_title', 'Feedback');

if ($_POST['_submitted'])
{
    $em = new Email($_POST['subject']);
    $em->to('feedback@siteframe.org');
    if ($_POST['copy'])
        $em->to($_SESSION['user']->get('user_email'));
    $PAGE->assign('message', strip_tags($_POST['message'],config('allowed_html')));
    $em->send_template(site_template('feedback'));
    $PAGE->assign('error', 'Feedback was sent');
}
else
{
    $inf = new InputForm('feedback', $_SERVER['REQUEST_URI']);
    $inf->add_item('subject', array(
        'type' => 'select',
        'options' => array(
            'Bug Report' => 'Bug Report',
            'Enhancement Request' => 'Enhancement Request',
            'General Feedback' => 'General Feedback',
            'Other' => 'Other'
        ),
        'prompt' => 'Subject',
        'help' => 'Select a subject from the list'
    ));
    $inf->add_item('message', array(
        'type' => 'textarea',
        'rows' => 10,
        'prompt' => 'Message',
        'help' => 'Message text'
    ));
    $inf->add_item('copy', array(
        'type' => 'checkbox',
        'rval' => 1,
        'value' => 1,
        'prompt' => 'Copy yourself',
        'help' => 'If checked, will send a copy of this to yourself.'
    ));
    $PAGE->assign('admin_content', $inf->get_form());
}

?>
