<?php
// $Id: links.php,v 1.4 2006/02/11 23:43:30 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.
// Displays a user's links

require_once 'siteframe.inc';

// the u= parameter is required
$id = get_user_id_from_username($_GET['u']);
if (!$id && is_object($_SESSION['user']))
    $id = $_SESSION['user']->id();
if (!$id) {
    $PAGE->assign('error', sprintf(lang('err_nousername'), htmlentities($_GET['u'])));
    $PAGE->display();
    exit;
}

// build the user object
$u = new User($id);

// retrieve the links
$link = new Link;
$q = sprintf(
    "SELECT link_id FROM %s WHERE link_user_id=%d ORDER BY %s",
    $link->table_name(),
    $u->id(),
    $_GET['s'] ? $_GET['s'] : 'link_text');
$myquery = new Query('Link', $q);

// empty array to hold results
$arr = array();
while($link_item = $myquery->get_all())
    $arr[] = $link_item;

$PAGE->assign('links', $arr);
$PAGE->assign('user', $u->get_all());
$PAGE->assign('page_title', sprintf(lang('page_title_links'), $u->get_title()));
$PAGE->display();
?>