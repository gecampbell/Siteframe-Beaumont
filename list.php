<?php
// $Id: list.php,v 1.5 2006/05/03 01:31:48 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.

require_once 'siteframe.inc';

// select page
if (isset($_GET['page']))
    $page = $_GET['page'];
else
    $page = 1;

// determine the class of things to list
if (isset($_GET['c']))
    $class = $_GET['c'];
else
{
    $PAGE->assign('error', lang('err_no_class'));
    $PAGE->assign('page_title', 'Error');
    $PAGE->display();
    exit;
}

$obj = new $class();
$p = new Page;
if ($obj->table_name() == $p->table_name())
    $where = sprintf(" WHERE page_class='%s'", get_class($obj));
else
    $where = '';

// determine total number
$q = sprintf("SELECT COUNT(*) FROM %s %s", $obj->table_name(), $where);
$DB = Database::getReader();
$result = $DB->query($q);
check_db($DB);
list($total) = $result->fetch_row();

// determine start and end
if (is_object($_SESSION['user']))
    $rpp = $_SESSION['user']->get('rows_per_page');
if (!$rpp)
    $rpp = config('rows_per_page');
$start = ($page-1)*$rpp;

// execute query
$q = sprintf(
    "SELECT * FROM %s %s ORDER BY %s",
    $obj->table_name(),
    $where,
    $obj->sortfield);
$myquery = new Query($class, $q, $start, $rpp);

$arr = array();     // output values
while($row = $myquery->get_all())
{
    $arr[] = $row;
}
$PAGE->assign('items', $arr);
$PAGE->assign('page', $page);
$PAGE->assign('num_pages', intval($total/$rpp)+(($total%$rpp)?1:0));
$PAGE->assign('page_title', lang("page_title_$class"));
$PAGE->assign('class', $class);
$PAGE->display();

?>
