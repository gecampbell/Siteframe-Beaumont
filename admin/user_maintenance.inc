<?php
// $Id: user_maintenance.inc,v 1.3 2006/05/03 01:31:48 glen Exp $
// Copyright(c)2005, Glen Campbell. All rights reserved.
// MODULE(User Maintenance)

$_HELP_ = <<<ENDHELP
<p>This module allows you to perform routine maintenance operations on your
site users. These functions are performed:</p>
<ul>
<li>A notification e-mail is sent to all unconfirmed users older than 1 day.</li>
<li>Unconfirmed users older than N days (selected below) are deleted.</li>
</ul>
<p>If you have access to a job scheduling system such as cron, you can run
these processes in batch mode with @TODO:batch script.</p>
ENDHELP;

$PAGE->assign('page_title', 'User Maintenance');

if ($_POST['_submitted'])
{
    $u = new User;
    
    // delete old users
    $q = sprintf(
        "DELETE FROM %s WHERE user_status=0 AND ".
        "user_modified<DATE_SUB(NOW(),INTERVAL %d DAY)",
        $u->table_name(),
        $_POST['num_days']);
    $DBW = Database::getWriter();
    $DBW->query($q);
    check_db($DBW);
    
    // send notification e-mails
    $q = sprintf(
        "SELECT * FROM %s WHERE user_status=0 AND ".
        "user_created<DATE_SUB(NOW(),INTERVAL 1 DAY)",
        $u->table_name());
    $DB = Database::getReader();
    $result = $DB->query($q);
    check_db($DB);
    $userlist = array();
    while($arr = $result->fetch_assoc())
    {
        $user = new User(0, $arr);
        $userlist[] = $user->get_title();
        send_user_confirmation_email($user);
    }
    $msg = sprintf("Notification e-mail sent to %s", implode(', ', $userlist));
    if (count($userlist))
    {
        $PAGE->assign('error', $msg);
        $AUDIT->message($msg);
    }
    else
        $PAGE->assign('error', 'Completed');
}
else
{
    $inf = new InputForm('usermaint', $_SERVER['REQUEST_URI'], 'post', 
                'Perform user maintenance');
    $inf->add_item('num_days', array(
        'type' => 'select',
        'options' => array(
            1 => '1 day',
            7 => '1 week',
            30 => '30 days',
            90 => '90 days',
            365 => 'a whole year',
        ),
        'value' => 7,
        'prompt' => 'Delete',
        'help' => 'Delete unconfirmed users older than this many days.'
    ));
    $PAGE->assign('admin_content', $_HELP_.$inf->get_form());
}

?>