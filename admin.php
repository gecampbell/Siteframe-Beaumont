<?php
// $Id: admin.php,v 1.12 2005/12/21 22:59:16 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.

require_once 'siteframe.inc';
require config('dir_includes')."/dbfunc.inc";

// are we logged on?
if (!is_object($_SESSION['user']))
{
    header(sprintf(
        'Location: %s/login.php?rd=%s',
        config('site_url'),
        urlencode($_SERVER['REQUEST_URI'])
    ));
    exit;
}

// are we an administrator
if (!$_SESSION['user']->get('user_admin'))
{
    //abort("No cookie for you! Only administrators can use this page.");
    $PAGE->assign('error', lang('err_notadmin'));
    $PAGE->display();
    exit;
}

// set the page title
$PAGE->assign('page_title', lang('page_title_admin'));

// if module= is set, then load the corresponding module
if (isset($_GET['module']))
{
    require "admin/".basename($_GET['module']);
    if (isset($TEMPLATES[basename($_GET['module'])]))
    {
        $out = $PAGE->fetch($TEMPLATES[basename($_GET['module'])]);
        $PAGE->assign('admin_content', $out);
    }
}
else    // construct a menu
{
    foreach(glob("admin/*.inc") as $filename)
    {
        $module = basename($filename);
        $string = file_get_contents($filename);
        preg_match('/MODULE\(([^)]+)\)/', $string, $match);
        $selection[$module] = $match[1];
    }
    $out = "<ul>\n";
    foreach($selection as $module => $title)
        $out .= sprintf(
            '<li><a href="%s/admin.php?module=%s">%s</a></li>'."\n",
            config('site_path'),
            $module,
            $title
        );
    $out .= "</ul>\n";
    $PAGE->assign('admin_content', $out);
}

$PAGE->display();

?>
