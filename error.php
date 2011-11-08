<?php
// $Id: error.php,v 1.7 2005/12/11 16:58:11 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.

require_once 'siteframe.inc';

$code = $_GET['code'];

switch($code)
{
case 401:
    break;
case 403:
    break;
case 404:
    header('HTTP/1.0 404 Not Found');
    break;
case 500:
    break;
}

$PAGE->assign('page_title', lang("page_title_error_$code"));
$PAGE->assign('error_help', lang("help_error_$code"));
$PAGE->assign('error_code', $code);
$PAGE->display();
?>
