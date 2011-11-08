<?php
// $Id: email_memoranda.php,v 1.4 2005/11/20 22:44:08 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.
//
// This plugin, if enabled, allows the site administrator to designate an
// e-mail address to which all site content is delivered. (This would normally
// be a mailing list address.) Well, not "all" content, just pages.
//
// Configuration (siteframe.ini):
//  email_memoranda_enable = On           ; to turn this plugin on

Plugin::add_property('User', 'email_memoranda', array(
    'type' => 'checkbox',
    'rval' => 1,
    'prompt' => 'E-mail Memo?',
    'help' => 'If checked, you\'ll receive an e-mail copy of all memos.',
    'value' => 1,
    'advanced' => true,
));
Plugin::add_event('Memo', 'add', 'email_memoranda_fcn');

// this is the function that does the e-mailing
function email_memoranda_fcn(&$memo)
{
    global $PAGE;
    
    $to_user = new User($memo->get('memo_to_user_id'));
    if (!$to_user->get('email_memoranda'))
        return;
    
    $em = new HtmlEmail(
        lang('class_Memo') . ': ' .
        $memo->get('memo_subject'));
    $em->to(sprintf('%s <%s>', $to_user->get_title(), 
        $to_user->get('user_email')));
    $em->send($memo->get('memo_body'));
}

?>
