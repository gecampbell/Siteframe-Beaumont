<?php
// $Id: list_texts.inc,v 1.2 2005/04/24 15:13:35 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.
// this is a loadable admin module
// MODULE(List ad hoc pages)

$PAGE->assign('page_title', lang('page_title_texts'));

$t = new Text;
$q = sprintf(
    "SELECT * FROM %s ".
    "ORDER BY text_name",
    $t->table_name());

$arr = array();
$query = new Query('Text', $q);
while($item = $query->get_all())
    $arr[] = $item;

$PAGE->assign('text_blocks', $arr);
?>