<?php
// $Id: folders.php,v 1.5 2006/05/03 01:31:48 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.

require_once 'siteframe.inc';

// select page
if (isset($_GET['page']))
    $page = $_GET['page'];
else
    $page = 1;

// find the total number of pages
$f = new Folder;
$q = sprintf("SELECT COUNT(*) FROM %s", $f->table_name());
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
    $orderby = 'folder_title';
$q = sprintf("SELECT * FROM %s a JOIN %s b ON (a.folder_user_id=b.user_id) ".
             "ORDER BY %s", 
             $f->table_name(), 
             $u->table_name(),
             $orderby);
$myquery = new Query('Folder', $q, $start, $rpp);

// set up our template variable
$arr = array();
while($folder = $myquery->get_all())
    $arr[] = $folder;

// save the folder variable
$PAGE->assign('folders', $arr);
$PAGE->assign('page', $page);
$PAGE->assign('num_pages', intval($total/$rpp+1));

// display the current page
$PAGE->assign('page_title', lang('page_title_folders'));
$PAGE->display();

?>