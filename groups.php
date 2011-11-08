<?php
// $Id: groups.php,v 1.2 2006/05/03 01:31:48 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.

require_once 'siteframe.inc';

// select page
if (isset($_GET['page']))
    $page = $_GET['page'];
else
    $page = 1;

// find the total number of pages
$gr = new Group;
$q = sprintf("SELECT COUNT(*) FROM %s", $gr->table_name());
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

// define the query
$u = new User;
if ($_GET['o'])
    $orderby = $_GET['o'];
else
    $orderby = 'group_name';
$q = sprintf("SELECT * FROM %s a JOIN %s b ON (a.group_user_id=b.user_id) ".
             "ORDER BY %s", 
             $gr->table_name(), 
             $u->table_name(),
             $orderby);
$myquery = new Query('Group', $q, $start, $rpp);

// set up our template variable
$arr = array();
while($grolder = $myquery->get_all())
    $arr[] = $grolder;

// save the folder variable
$PAGE->assign('groups', $arr);
$PAGE->assign('page', $page);
$PAGE->assign('num_pages', intval($total/$rpp+1));

// display the current page
$PAGE->assign('page_title', lang('page_title_groups'));
$PAGE->display();

?>