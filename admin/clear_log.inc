<?php
// $Id: clear_log.inc,v 1.2 2006/05/03 01:31:48 glen Exp $
// Copyright(c)2005, Glen Campbell. All rights reserved.
// MODULE(Clear Audit Log)

$PAGE->assign('page_title', 'Clear Audit Log');

if ($_POST['_submitted'])
{
    $n = $_POST['num_days'];
    $a = new Audit;
    $q = sprintf(
        "DELETE FROM %s WHERE log_time<DATE_SUB(NOW(), INTERVAL %d DAY)",
        $a->table_name(),
        $n);
    $DB = Database::getWriter();
    $result = $DB->query($q);
    check_db($DB);
    $PAGE->assign('error', 'Audit log cleared');
    $AUDIT->message("audit log cleared");
}
else
{
    $inf = new InputForm('clear_log', $_SERVER['REQUEST_URI'], 'post', 
                'Clear the log');
    $inf->add_item('num_days', array(
        'type' => 'select',
        'options' => array(
            0 => 'Do not retain any',
            1 => '1 day',
            7 => '1 week',
            30 => '30 days',
            90 => '90 days',
            365 => 'a whole year',
        ),
        'value' => 7,
        'prompt' => 'Retain',
        'help' => 'Select the number of days\'s worth of log entries to retain.'
    ));
    $PAGE->assign('admin_content', $inf->get_form());
}

?>