<?php
// $Id: rssfeed.php,v 1.5 2005/12/10 05:46:29 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.

require_once 'siteframe.inc';

// make a new RSSfeed object
$feed = new RSSfeed($_GET['id']);

// did it work?
if (!$_GET['id'] || ($feed->id() != $_GET['id']))
{
    $_GET['template'] = 'error.php';
    $_GET['code'] = 404;
    include('error.php');
    exit;
}

$PAGE->assign('page_title', $feed->get_title());
$PAGE->assign('error', $feed->get_errors());
$PAGE->assign($feed->get_all());
$PAGE->display();

?>