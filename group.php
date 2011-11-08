<?php
// $Id: group.php,v 1.9 2006/05/03 01:31:48 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.

require_once 'siteframe.inc';

// make a new Group object
$group = new Group($_GET['id']);

// did it work?
if ((!$_GET['id']) || (!$group->id()))
{
    $_GET['template'] = 'error.php';
    $_GET['code'] = 404;
    include('error.php');
    exit;
}
else {    
    // bulk-adds
    if (isset($_GET['add']) && $group->authorized())
    {
        foreach(explode(' ', $_GET['add']) as $uname)
        {
            $u = new User;
            $q = sprintf("SELECT user_id FROM %s WHERE user_name='%s'",
                $u->table_name(),
                addslashes($uname));
            $DB = Database::getReader();
            $res = $DB->query($q);
            check_db($DB);
            list($id) = $res->fetch_array();
            $err = '';
            if ($id)
            {
                $rel = new GroupUserRel;
                $rel->set('r_group_id', $group->id());
                $rel->set('r_user_id', $id);
                $rel->add();
                if (!$rel->is_valid())
                    $err .= $rel->get_errors();
            }
        }
        $PAGE->assign('error', $err);
    }

    $rel = new GroupUserRel;

    // process joins/leaves first
    if (is_object($_SESSION['user']) && isset($_GET['op']))
    {
        $rel->set('r_user_id', $_SESSION['user']->id());
        $rel->set('r_group_id', $group->id());
        
        switch($_GET['op'])
        {
        case 'join':
            $rel->add();
            break;
        case 'leave':
            $rel->delete();
            break;
        default:
            $PAGE->assign('error', 'Invalid op=');
        }
    }
    
    // now build the user list
    $usr = new User;
    $q = sprintf(
        "SELECT user_id FROM %s JOIN %s ON (r_user_id=user_id)
        WHERE r_group_id=%d
        ORDER BY user_name",
        $rel->table_name(),
        $usr->table_name(),
        $group->id());
    $myquery = new Query('User', $q);
    $arr = array();
    while($user = $myquery->get_all())
        $arr[] = $user;
    $PAGE->assign('users', $arr);
}

// get recent activity by favorite users
$p = new Page;
$rel = new GroupUserRel;
$q = sprintf(
    "SELECT * FROM %s WHERE page_user_id IN
        (SELECT r_user_id FROM %s WHERE r_group_id=%d)
    ORDER BY page_id DESC
    LIMIT %d",
    $p->table_name(),
    $rel->table_name(),
    $group->id(),
    config('recent_items', 20)
);
$myquery = new Query('Page', $q);
$arr = array();
while ($row = $myquery->get_all())
    $arr[] = $row;
$PAGE->assign('group_recent', $arr);
if (config('url_rewriting'))
    $PAGE->assign('sep', '?');
else
    $PAGE->assign('sep', '&amp;');
$PAGE->assign('page_title', $group->get_title());
$PAGE->assign($group->get_all());
$PAGE->assign('userinfo', $group->get('group_text'));
$PAGE->display($group->get('alt_template'));

?>