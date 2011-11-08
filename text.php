<?php
// $Id: text.php,v 1.12 2006/05/03 01:31:48 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.

require_once 'siteframe.inc';

// get a database reader
$DB = Database::getReader();

if ($_GET['id'] != '')
{
    if (is_numeric($_GET['id']))
        $stat = new Text($_GET['id']);
    else {
        $tex = new Text;
        $q = sprintf("SELECT text_id FROM %s WHERE text_name='%s'", 
                $tex->table_name(), $_GET['id']);
        $result = $DB->query($q);
        check_db($DB);
        list($id) = $result->fetch_row();
        $stat = new Text($id);
    }
    if ($stat->get('text_name') == '')
        $PAGE->assign('error', sprintf(lang('err_notext'), htmlentities($_GET['id'])));
}
else
{
    $PAGE->assign('error', lang('err_noid'));
    $PAGE->display();
    exit;
}

if ($stat->get('text_title') != '')
    $PAGE->assign('page_title', $stat->get('text_title'));
else
    $PAGE->assign('page_title', $stat->get('text_name'));
$PAGE->assign($stat->get_all());

$PAGE->display();
?>