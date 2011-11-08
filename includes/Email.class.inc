<?php
// $Id: Email.class.inc,v 1.25 2005/11/24 20:51:42 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.
//
// This class implements a text-based e-mail object

class Email extends Siteframe
{
private $to = array();
private $cc = array();
private $bcc = array();
private $headers = array();
private $from;
public $subject;

// constructor - set the default from: address
public function __construct($subject)
{
    global $PAGE;
    
    $prefix = '['.config('site_name').']';
    if (strpos($subject, $prefix) === FALSE)
        $this->subject = sprintf(
            "[%s] %s",
            config('site_name'),
            $subject);
    else
        $this->subject = $subject;
    $PAGE->assign('mail_subj', $subject);
    $this->from = sprintf(
        "%s <%s>",
        config('site_name'),
        config('site_email_from')
    );
}

// to(email)
public function to($email)
{
    if (trim($email) != '')
        $this->to[] = $email;
}

// to_group(group_id)
public function to_group($id)
{
    if (!$id)
        return;
    $g = new Group($id);
    foreach($g->members() as $user)
        $this->bcc($user->get('user_email'));
    $this->to(sprintf('%s <%s>', $g->get_title(), config('site_email_from')));
}

// cc(email)
public function cc($email)
{
    $this->cc[] = $email;
}

// bcc(email)
public function bcc($email)
{
    $this->bcc[] = $email;
}

// header - add a header to the e-mail
public function header($string)
{
    $this->headers[] = $string;
}

// from(user)
public function from($user)
{
    if (is_numeric($user))
    {
        $u = new User($user);
        $this->from = sprintf("%s <%s>", $u->get('user_email'), $u->get('user_name'));
    }
    else
        $this->from = $user;
}

// send_template(template)
public function send_template($template)
{
    global $PAGE;

    $tpl = clone $PAGE;
    $tpl->template_dir = config('dir_templates');
    $tpl->compile_dir = config('dir_files').'/compile';
    $tpl->assign($this->get_all());
    if (is_object($_SESSION['user']))
        $tpl->assign('user', $_SESSION['user']->get_all());
    $msg = $tpl->fetch($template);
    if (config('send_html_email'))
        $this->send($msg);
    else
        $this->send(strip_tags($msg));
}

// send - just text
public function send($message)
{
    global $AUDIT, $PAGE;

    $this->header('From: '.$this->from);

    if (count($this->cc))
        $this->header('Cc: '.implode(',', $this->cc));

    if (count($this->bcc))
        $this->header('Bcc: '.implode(',', $this->bcc));

    $ret = mail(
        implode(',', $this->to),
        $this->subject,
        $message,
        implode("\r\n", $this->headers)
    );

    if ($ret)
        $AUDIT->message('E-mail sent to %d recipients from %s',
            count($this->to)+count($this->cc)+count($this->bcc),
            $this->from);
    else
        $AUDIT->message('Failed to send e-mail from %s',
            $this->from);

    return $ret;
}

} // end class Email
?>
