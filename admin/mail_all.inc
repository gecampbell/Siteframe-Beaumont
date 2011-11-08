<?php
// $Id: mail_all.inc,v 1.5 2006/05/03 01:31:48 glen Exp $
// Copyrigth (c)2005, Glen Campbell. All rights reserved.
//
// MODULE(Send e-mail to all users)

$PAGE->assign('page_title', 'Send e-mail to all users');
if ($_POST['_submitted'])
{
    $footer = sprintf(
        "\n<hr/><p><small>Sent from %s<br/>\n<a href=\"%s\">%s</a></small></p>\n",
        config('site_name'),
        config('site_url'),
        config('site_url'));
    $em = new HtmlEmail($_POST['mail_subject']);
    $em->to(config('site_email'));
    $u = new User;
    $q = sprintf("SELECT user_email FROM %s", $u->table_name());
    $DB = Database::getReader();
    $result = $DB->query($q);
    check_db($DB);
    while(list($email) = $result->fetch_row())
        $em->bcc($email);
    $em->send($_POST['mail_text'] . $footer);
    if ($em->is_valid()) {
        $PAGE->assign('error', 'Message sent');
        $PAGE->display();
        exit;
     }
}

$inf = new InputForm('mailall', $_SERVER['REQUEST_URI'], "post", "Send e-mail");
$inf->add_item('mail_subject', array(
    'type' => 'text',
    'size' => 40,
    'maxlength' => 250,
    'prompt' => 'Subject',
    'help' => 'The subject line of your e-mail',
    'value' => $_POST['mail_subject'],
));
$inf->add_item('mail_text', array(
    'type' => 'textarea',
    'formatted' => TRUE,
    'prompt' => 'Message',
    'rows' => 15,
    'help' => 'The text of your message',
    'value' => $_POST['mail_text']
));
$PAGE->assign('admin_content', $inf->get_form());

?>