<?php
// $Id: quotes.php,v 1.4 2006/05/03 01:31:48 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.

require_once 'siteframe.inc';

// select page
if (isset($_GET['page']))
    $page = $_GET['page'];
else
    $page = 1;

// determine total number
$quote = new Quote;
$q = sprintf("SELECT COUNT(*) FROM %s", $quote->table_name());
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

// sort?
if ($_GET['o'])
    $orderby = $_GET['o'];
else
    $orderby = 'quote_created DESC';

// execute query
$u = new User;
$q = sprintf(
    "SELECT * FROM %s quotes LEFT JOIN %s users ".
    "ON (quotes.quote_user_id=users.user_id) ".
    "ORDER BY ".$orderby,
    $quote->table_name(),
    $u->table_name(),
    $u->id());
$myquery = new Query('Quote', $q, $start, $rpp);

$arr = array();     // output values
while($row = $myquery->get_all())
{
    $arr[] = $row;
}

$PAGE->assign('page_title', lang('page_title_quotes'));
$PAGE->assign('quotes', $arr);
$PAGE->assign('page', $page);
$PAGE->assign('num_pages', intval($total/$rpp)+(($total%$rpp)?1:0));
$PAGE->display();

?>