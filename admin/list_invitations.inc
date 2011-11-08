<?php
// $Id: list_invitations.inc,v 1.2 2006/05/03 01:31:48 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.
// this is a loadable admin module
// MODULE(List invitations)

$PAGE->assign('page_title', 'Invitations');

// select page
if (isset($_GET['page']))
    $page = $_GET['page'];
else
    $page = 1;

$inv = new Invitation;

// find the total number of pages
$q = sprintf("SELECT COUNT(*) FROM %s", $inv->table_name());
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

// build query
$q = sprintf(
    "SELECT inv_id FROM %s ORDER BY inv_created DESC",
    $inv->table_name()
);

$myquery = new Query('Invitation', $q, $start, $rpp);
$arr = array();
while($item = $myquery->get_all())
    $arr[] = $item;

// assign variables
$PAGE->assign('inv', $arr);
$PAGE->assign('page', $page);
$PAGE->assign('num_pages', intval($total/$rpp+1));
$PAGE->assign('sep', '&amp;');
$PAGE->assign('url', 
    config('site_path').'/admin.php?module=list_invitations.inc');
?>
