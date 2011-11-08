<?php
// $Id: templates.php,v 1.4 2006/05/03 01:31:48 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.

require_once 'siteframe.inc';

// get a database read connection
$DB = Database::getReader();

// check to see that the user is logged in
if (is_object($_SESSION['user']) && $_SESSION['user']->id())
    ;
else {
    header('Location: login.php?rd='.urlencode($_SERVER['REQUEST_URI']));
    exit;
}

// current user
$cuser = $_SESSION['user'];

// select page
if (isset($_GET['page']))
    $page = $_GET['page'];
else
    $page = 1;

$tpl = new Template;

// determine total number
if ($cuser->get('user_admin'))
    $q = sprintf("SELECT COUNT(*) FROM %s", $tpl->table_name());
else
    $q = sprintf("SELECT COUNT(*) FROM %s WHERE tpl_user_id=%d",
            $tpl->table_name(), $cuser->id());
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
if ($cuser->get('user_admin'))
    $q = sprintf(
        "SELECT * FROM %s ORDER BY tpl_name",
        $tpl->table_name());
else
    $q = sprintf(
        "SELECT * FROM %s WHERE tpl_user_id=%d ORDER BY tpl_name",
        $tpl->table_name(),
        $cuser->id());
$myquery = new Query('Template', $q, $start, $rpp);

$arr = array();     // output values
while($row = $myquery->get_all())
{
    $arr[] = $row;
}

$PAGE->assign('templates', $arr);
$PAGE->assign('page', $page);
$PAGE->assign('num_pages', intval($total/$rpp)+(($total%$rpp)?1:0));
$PAGE->assign('page_title', lang('page_title_templates'));
$PAGE->display();

?>