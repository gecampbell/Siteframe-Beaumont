<?php
// $Id: index.php,v 1.25 2007/08/31 05:38:53 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.

require_once 'siteframe.inc';

// turn on caching for index.php
// $PAGE->caching = 1;
$PAGE->cache_lifetime = 600;

// check for new messages
if (is_object($_SESSION['user']) && $_SESSION['user']->id())
{
    $m = new Memo;
    $q = sprintf(
        "SELECT COUNT(*) FROM %s WHERE memo_to_user_id=%d AND memo_read=0",
        $m->table_name(),
        $_SESSION['user']->id());
    $DB = Database::getReader();
    $result = $DB->query($q);
    check_db($DB);
    list($num) = $result->fetch_row();
    $PAGE->assign('unread_msgs', $num);
}

$PAGE->assign('page_title', config('site_name'));

// assign items
$p = new Page;
$q = sprintf("SELECT * FROM %s WHERE page_hidden=0 ".
             "ORDER BY page_created DESC",
             $p->table_name());
$myquery = new Query('Page', $q, config('recent_items',20));

while($parr = $myquery->get_all())
    $items[] = $parr;

$PAGE->assign('items', $items);
$PAGE->assign('item_template', $TEMPLATES['index_item']);
$PAGE->display();
?>
