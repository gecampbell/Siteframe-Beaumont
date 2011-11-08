<?php
// $Id: bulk_invite.inc,v 1.1 2005/08/22 22:41:01 glen Exp $
// Copyright(c)2005, Glen Campbell. All rights reserved.
// MODULE(Send bulk invitations)

$PAGE->assign('page_title', 'Bulk Invitations');

if ($_POST['_submitted'])
{
    $inv = new Invitation();
    $inv->set('inv_name', $_POST['name']);
    $inv->set('inv_message', $_POST['message']);
    $addrs = preg_split('/\s+/', $_POST['emails']);
    foreach($addrs as $email)
    {
        $inv->reset_errors();
        $inv->set('inv_id', 0);
        $mail = trim($email);
        if ($mail != '')
        {
            $inv->set('inv_email', $mail);
            $inv->add();
            if ($inv->is_valid())
                $stat = "Sent";
            else
                $stat = $inv->get_errors();
            $out .= sprintf("<div>%s: %s</div>\n", $mail, $stat);
        }
    }
    $PAGE->assign('admin_content', $out);
}
else
{
    $inf = new InputForm('feedback', $_SERVER['REQUEST_URI']);
    $inf->add_item('emails', array(
        'type' => 'textarea',
        'rows' => 10,
        'prompt' => 'E-mail addresses',
        'help' => 'Enter e-mail addresses, one per line'
    ));
    $inf->add_item('name', array(
        'type' => 'text',
        'prompt' => 'Name',
        'help' => 'A name to use for the addressees (e.g., "Valued Customer").'
    ));
    $inf->add_item('message', array(
        'type' => 'textarea',
        'rows' => 5,
        'prompt' => 'Message',
        'help' => 'An optional message to be sent along with the invitations.'
    ));
    $PAGE->assign('admin_content', $inf->get_form());
}

?>