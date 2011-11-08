<?php
// $Id: user.php,v 1.17 2006/05/03 01:31:48 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.

require_once 'siteframe.inc';

// get a database read connection
$DB = Database::getReader();

if ($_GET['id'])
{
    $cuser = new User($_GET['id']);
    if (!$cuser->get('user_id'))
    {
        $_GET['template'] = 'error.php';
        $_GET['code'] = 404;
        include('error.php');
        exit;
    }
}
else if ($_GET['name'])
{
    $cuser = new User;
    $q = sprintf(
        "SELECT user_id FROM %s WHERE user_name='%s'",
        $cuser->table_name(),
        addslashes($_GET['name']));
    $result = $DB->query($q);
    if ($DB->errno)
        abort(lang('err_db'), $DB->error);
    list($uid) = $result->fetch_row();
    if (!$uid)
    {
        $_GET['template'] = 'error.php';
        $_GET['code'] = 404;
        include('error.php');
        exit;
    }
    $cuser = new User($uid);
}
else if (is_object($_SESSION['user']))
{
    $cuser = new User($_SESSION['user']->id());
}
else
{
    $PAGE->assign('error', lang('err_nouser'));
    $PAGE->display();
    exit; 
}

$PAGE->assign('page_title', $cuser->get('user_name'));
$PAGE->assign('user', $cuser->get_all());

// let's get some other information
$f = new Folder;
$items = array();
$q = sprintf(
    "SELECT folder_id FROM %s WHERE folder_user_id=%d",
    $f->table_name(),
    $cuser->id());
$result = $DB->query($q);
if ($DB->errno)
    abort(lang('err_db'), $DB->error);
while(list($id) = $result->fetch_row())
{
    $f = new Folder($id);
    $items[] = $f->get_all();
}
$PAGE->assign('user_folders', $items);

// is the user being viewed a Favorite of the currently-logged-in user?
if (is_object($_SESSION['user']) && $_SESSION['user']->id())
{
    $fav = new Favorite;
    $q = sprintf(
        "SELECT fav_id FROM %s WHERE user_id=%d and fav_user_id=%d",
        $fav->table_name(),
        $_SESSION['user']->id(),
        $cuser->id()
    );
    $res = $DB->query($q);
    check_db($DB);
    list($fav_id) = $res->fetch_array();
    $PAGE->assign('is_favorite', ($fav_id>0));
    $PAGE->assign('fav_id', $fav_id);
}

$PAGE->assign('item_template', $TEMPLATES['index_item']);
$PAGE->display($cuser->get('alt_template'));
?>