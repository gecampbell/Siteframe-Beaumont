<?php
// $Id: tag.php,v 1.11 2006/01/06 03:57:09 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.

require_once 'siteframe.inc';

$p = new Page;
$r = new TagPageRel;
$t = new Tag($_GET['tag']);
$q = sprintf(
    "SELECT page.page_id FROM %s page ".
    "INNER JOIN %s rel ON (page.page_id=rel.page_id) ".
    "INNER JOIN %s tag ON (rel.tag_id=tag.tag_id) ".
    "WHERE tag_name='%s' ".
    "ORDER BY page_created DESC",
    $p->table_name(),
    $r->table_name(),
    $t->table_name(),
    $_GET['tag']);

// create a new query
$myquery = new Query('Page', $q);

// ready our output array
$arr = array();

// fetch all the pages that match the tag
while($page = $myquery->get_all())
    $arr[] = $page;

// assign them all and then display
$PAGE->assign($t->get_all());
$PAGE->assign('item_template', $TEMPLATES['index_item']);
$PAGE->assign('tag_pages', $arr);
$PAGE->assign('page_title', $t->get_title());

$PAGE->display();
?>
