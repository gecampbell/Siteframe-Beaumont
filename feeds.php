<?php
// $Id: feeds.php,v 1.2 2005/12/10 04:23:33 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.
// this is a loadable admin module

require_once 'siteframe.inc';

$PAGE->assign('page_title', lang('page_title_feeds'));

$rss = new RSSfeed;
$q = sprintf(
    "SELECT * FROM %s ".
    "ORDER BY rss_url",
    $rss->table_name());

$arr = array();
$query = new Query('RSSfeed', $q);
while($item = $query->get_all())
    $arr[] = $item;

$PAGE->assign('rss_feeds', $arr);
$PAGE->display();
?>