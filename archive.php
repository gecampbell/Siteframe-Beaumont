<?php
// $Id: archive.php,v 1.10 2006/05/03 01:31:48 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.

require_once 'siteframe.inc';

$year = $_GET['y'];
$month = $_GET['m'];
$day = $_GET['d'];
$fid = $_GET['f'];

if (!$year && !$month && !$day)
    abort(lang('err_badarchive'));

if ($year && $month && $day)
{
    $PAGE->assign('archive_type', $atype='day');
    $timestr = sprintf("%04d-%02d-%02d", $year, $month, $day);
}
else if ($year && $month)
{
    $PAGE->assign('archive_type', $atype='month');
    $timestr = sprintf("%04d-%02d-%02d", $year, $month, 1);
}
else
{
    $PAGE->assign('archive_type', $atype='year');
    $timestr = sprintf("%04d-%02d-%02d", $year, 1, 1);
}
$PAGE->assign('unixtime', strtotime($timestr.' 00:00:00'));
$PAGE->assign('year', $year);
$PAGE->assign('month', $month);
$PAGE->assign('day', $day);

$url = sprintf("%s/archive.php?", config('site_path'));

switch($atype)
{
case 'day':
    $where = sprintf(
        "page_created BETWEEN '%s' AND '%s'",
        $timestr.' 00:00:00',
        $timestr.' 23:59:59');
    $url .= sprintf('y=%d&amp;m=%d;&amp;d=%d', $year, $month, $day);
    break;
case 'month':
    $where = sprintf(
        "page_created >= '%s' AND page_created < DATE_ADD('%s', INTERVAL 1 MONTH)",
        $timestr.' 00:00:00',
        $timestr.' 00:00:00');
    $url .= sprintf('y=%d&amp;m=%d', $year, $month);
    break;
case 'year':
    $where = sprintf(
        "page_created >= '%s' AND page_created < DATE_ADD('%s', INTERVAL 1 YEAR)",
        $timestr.' 00:00:00',
        $timestr.' 00:00:00');
    $url .= sprintf('y=%d', $year);
    break;
}
if ($fid)
{
    $f = new Folder($fid);
    $where .= sprintf(' AND page_folder_id=%d ', $fid);
    $PAGE->assign('folder', $f->get_all());
}

// get pagination info
// select page
if (isset($_GET['page']))
    $page = $_GET['page'];
else
    $page = 1;

// find the total number of pages
$p = new Page;
$q = sprintf("SELECT COUNT(*) FROM %s WHERE %s", $p->table_name(), $where);
$DB = Database::getReader();
$result = $DB->query($q);
check_db($DB);
list($total) = $result->fetch_row();

// determine start and end
$rpp = config('recent_items');
$start = ($page-1)*$rpp;

// fetch all the pages for the time period selected
$arr = array();
$p = new Page;
$q = sprintf("SELECT page_id FROM %s WHERE %s ORDER BY page_id DESC",
        $p->table_name(), $where);
$myquery = new Query('Page', $q, $start, $rpp);
while($obj = $myquery->get_all())
    $arr[] = $obj;

// assign variables
$PAGE->assign('items', $arr);
$PAGE->assign('item_template', $TEMPLATES['index_item']);
$PAGE->assign('page', $page);
$PAGE->assign('num_pages', intval($total/$rpp)+(($total%$rpp)?1:0));
$PAGE->assign('url', $url);
$PAGE->assign('sep', '&amp;');

// display the page
$PAGE->display();
?>
