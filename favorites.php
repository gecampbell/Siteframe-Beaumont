<?php
// $Id: favorites.php,v 1.7 2006/01/04 00:01:53 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.

require_once 'siteframe.inc';

// check for ID
$u = new User($_GET['id']);
if (!$_GET['id'])
{
    if (is_object($_SESSION['user']) && $_SESSION['user']->id())
        $u = $_SESSION['user'];
    else
    {
        $PAGE->assign('page_title', "Error");
        $PAGE->assign('error', lang('err_noid'));
        $PAGE->display();
        exit;
    }
}
$PAGE->assign('page_title', sprintf(lang('page_title_friends'), $u->get_title()));
$PAGE->assign('user', $u->get_all());

// get list of favorite users
$f = new Favorite;
$f->set('user_id', $u->id());
$q = sprintf(
    "SELECT fav_user_id FROM %s friends LEFT JOIN %s users ".
    "ON (friends.fav_user_id=users.user_id) ".
    "WHERE friends.user_id=%d ".
    "ORDER BY user_name",
    $f->table_name(),
    $u->table_name(),
    $u->id());
$myquery = new Query('User', $q);

$arr = array();     // output values
while($row = $myquery->get_all())
{
    $arr[] = $row;
}
$PAGE->assign('users', $arr);

// get recent activity by favorite users
$p = new Page;
$q = sprintf(
    "SELECT * FROM %s WHERE page_user_id IN
        (SELECT fav_user_id FROM %s WHERE user_id=%d)
    ORDER BY page_id DESC
    LIMIT %d",
    $p->table_name(),
    $f->table_name(),
    $u->id(),
    config('recent_items', 20)
);
$myquery = new Query('Page', $q);
$arr = array();
while ($row = $myquery->get_all())
    $arr[] = $row;
$PAGE->assign('item_template', $TEMPLATES['index_item']);
$PAGE->assign('fav_recent', $arr);
$PAGE->assign('rss_url', $f->get_rss_url());
$PAGE->display();
?>