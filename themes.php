<?php
// $Id: themes.php,v 1.2 2005/08/26 05:30:24 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.

require_once 'siteframe.inc';

$PAGE->assign('page_title', lang('page_title_themes'));

// load theme list
foreach(glob(config('dir_templates').'/*/template.ini') as $filename)
{
    $info = parse_ini_file($filename);
    $info['template_dir'] = dirname($filename);
    $arr[] = $info;
}
$PAGE->assign('themes', $arr);

$PAGE->display();
?>