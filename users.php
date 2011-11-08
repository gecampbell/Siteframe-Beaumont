<?php
// $Id: users.php,v 1.8 2006/05/03 01:31:48 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.

require_once 'siteframe.inc';

// get a database read connection
$DB = Database::getReader();

// select page
if (isset($_GET['page']))
    $page = $_GET['page'];
else
    $page = 1;

$u = new User;

// determine total number
$q = sprintf("SELECT COUNT(*) FROM %s", $u->table_name());
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
    "SELECT * FROM %s ORDER BY user_name",
    $u->table_name());
$myquery = new Query('User', $q, $start, $rpp);

$arr = array();     // output values
while($row = $myquery->get_all())
{
    $arr[] = $row;
}
$PAGE->assign('users', $arr);
$PAGE->assign('page', $page);
$PAGE->assign('num_pages', intval($total/$rpp)+(($total%$rpp)?1:0));
$PAGE->assign('page_title', lang('page_title_users'));
$PAGE->display();

?>