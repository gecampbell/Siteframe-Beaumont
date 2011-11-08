<?php
// $Id: email_all_content.php,v 1.7 2005/11/17 08:11:04 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.
//
// This plugin, if enabled, allows the site administrator to designate an
// e-mail address to which all site content is delivered. (This would normally
// be a mailing list address.) Well, not "all" content, just pages.
//
// Configuration (siteframe.ini):
//  email_all_content_enable = On           ; to turn this plugin on
//  email_all_content = "something@domain"  ; address to send everything

Plugin::add_event('Page', 'add', 'email_all_content_fcn');

$_CONTENT_EMAIL = <<<ENDCONTENT
%s
<p><a href="%s">%s</a></p>
<p>by %s</p>
<hr/>
<p><small>Sent from %s<br/>
<a href="%s">%s</a></small></p>
ENDCONTENT;

// this is the function that does the e-mailing
function email_all_content_fcn(&$page)
{
    global $_CONTENT_EMAIL;
    
    // don't publish hidden things
    if ($page->get('page_hidden'))
        return;

    // get the e-mail address
    $to = config('email_all_content');
    if (trim($to) == '') 
        abort("Error: plugin <email_all_content> is enabled, but no e-mail address has been supplied");
    
    // get author info
    $u = new User($page->get('page_user_id'));
    
    // write e-mail
    $em = new HtmlEmail($page->get_title());
    $em->to($to);
    $msg = sprintf(
        $_CONTENT_EMAIL,
        stripslashes($page->get('page_text')),
        config('site_url_base').$page->get_url(),
        config('site_url_base').$page->get_url(),
        $u->get('user_name'),
        config('site_name'),
        config('site_url'),
        config('site_url')
    );
    $em->send($msg);
}
