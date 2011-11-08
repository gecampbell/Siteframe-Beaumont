<?php
// $Id: file.php,v 1.10 2005/11/17 07:43:20 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.

require_once 'siteframe.inc';

// make a new File object
$f = new File($_GET['id']);

// did it work?
if (!$_GET['id'] || ($f->id() != $_GET['id']))
{
    $_GET['template'] = 'error.php';
    $_GET['code'] = 404;
    include('error.php');
    exit;
}
else {
    $PAGE->assign($f->get_all());
    $PAGE->assign('page_title', $f->get_title());
}

$PAGE->display($f->get('alt_template'));

?>