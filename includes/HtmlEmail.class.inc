<?php
// $Id: HtmlEmail.class.inc,v 1.12 2005/11/21 05:18:50 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.
//
// The HtmlEmail class extends the basic e-mail class by adding HTML 
// e-mail support

class HtmlEmail extends Email
{
private $boundary;      // a MIME boundary

// constructor - prepare for MIME encoding
public function __construct($subject)
{
    $this->boundary = uniqid("SiteframeHtmlEmail");
    parent::__construct($subject);
    $this->header("MIME-Version: 1.0");
    $this->header("Content-Type: multipart/alternative" .
                  "; boundary = ".$this->boundary);
}

// send(msg) - assume HTML-formatted message
public function send($msg)
{
    global $PAGE;

    if (!config('send_html_email'))
        parent::send($msg);
    else
    {
        $tpl = clone $PAGE;
        $tpl->template_dir = config('dir_templates');
        $tpl->compile_dir = config('dir_files').'/compile';
        $tpl->assign('mail_body', $msg);
        $tpl->assign('mail_body_base64', chunk_split(base64_encode($msg)));
        $tpl->assign('mime_boundary', $this->boundary);
        if (config('send_html_email'))
            $newmsg = $tpl->fetch(site_template('htmlemail'));
        else
            $newmsg = $tpl->fetch(site_template('mail'));
        parent::send($newmsg);
    }
}

} // end class HtmlEmail

?>
