<?php
// $Id: memos.php,v 1.6 2006/05/03 01:31:48 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.

require_once 'siteframe.inc';

// select page
if (isset($_GET['page']))
    $page = $_GET['page'];
else
    $page = 1;

// check to see that the user is logged in
if (is_object($_SESSION['user']) && $_SESSION['user']->id())
    ;
else {
    header('Location: login.php?rd='.urlencode($_SERVER['REQUEST_URI']));
    exit;
}

// retrieve the user
if ($_GET['user'])
    $user = new User($_GET['user']);
else
    $user = new User($_SESSION['user']->id());

// are we authorized?
if (!$user->authorized())
{
    $PAGE->assign('error', lang('err_notauth'));
    $PAGE->display();
    exit;
}

$m = new Memo;

// determine total number
$q = sprintf("SELECT COUNT(*) FROM %s WHERE memo_to_user_id=%d", 
        $m->table_name(),
        $user->id());
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
    "SELECT * FROM %s WHERE memo_to_user_id=%d ORDER BY memo_read, memo_created",
    $m->table_name(),
    $user->id());
$myquery = new Query('Memo', $q, $start, $rpp);

$arr = array();     // output values
while($row = $myquery->get_all())
{
    $arr[] = $row;
    $m2 = new Memo($row['memo_id']);
    $m2->set('memo_read', 1);
    $m2->update();
}

// assign output variables
if ($_GET['msg'])
    $PAGE->assign('error', htmlentities($_GET['msg']));
$PAGE->assign('memos', $arr);
$PAGE->assign('page', $page);
$PAGE->assign('num_pages', intval($total/$rpp)+(($total%$rpp)?1:0));
$PAGE->assign('page_title', lang('page_title_memos'));
$PAGE->display();
?>