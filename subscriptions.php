<?php
// $Id: subscriptions.php,v 1.4 2006/05/03 01:31:48 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.

require_once 'siteframe.inc';

$PAGE->assign('page_title', lang('page_title_subscriptions'));

// check to see that the user is logged in
if (is_object($_SESSION['user']) && $_SESSION['user']->id())
    ;
else {
    header(sprintf(
        'Location: %s/login.php?rd=%s',
        config('site_url'),
        urlencode($_SERVER['REQUEST_URI'])
    ));
    exit;
}

// retrieve the user
$user = new User($_GET['user']);

// are we authorized?
if (!$user->authorized())
{
    $PAGE->assign('error', lang('err_notauth'));
    $PAGE->display();
    exit;
}

// retrieve subscription information
$sub = new Subscription;
$f = new Folder;
$q = sprintf(
    "SELECT sub_id FROM %s JOIN %s ON (%s.sub_folder_id=%s.folder_id) ".
    "WHERE sub_user_id=%d ORDER BY folder_title",
    $sub->table_name(),
    $f->table_name(),
    $sub->table_name(),
    $f->table_name(),
    $user->id());
$DB = Database::getReader();


$result = $DB->query($q);
check_db($DB);

// return array
$arr = array();

// get all the data
while(list($id) = $result->fetch_row())
{
    $sub = new Subscription($id);
    $arr[] = $sub->get_all();
}
$PAGE->assign('sub', $arr);

$PAGE->display();

?>