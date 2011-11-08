<?php
// $Id: directory.inc,v 1.2 2006/01/05 18:01:19 glen Exp $
// Copyrigth (c)2005, Glen Campbell. All rights reserved.
//
// MODULE(File Directory)

$PAGE->assign('page_title', 'File Directory');

if ($_GET['dir'])
    $dir = $_GET['dir'];
else
    $dir = '.';

// do some validation
$home = realpath('.');
$dir = realpath($dir);
if (substr($dir, 0, strlen($home)) != $home)
    $dir = $home;
$PAGE->assign('error', $dir);

$output = "<p>Click to edit a file or to enter a directory.</p><p>\n";
foreach(scandir($dir) as $name)
{
    $item = '';
    if ($name == '.')
        ; // ignore this
    else if ($name == '..' && (realpath($dir) == realpath('.')))
        ; // ignore at top level
    else if (is_dir($dir.'/'.$name))
    {
        $item = sprintf(
            '[<a href="%s/admin.php?module=directory.inc&amp;dir=%s">%s</a>]',
            config('site_path'),
            urlencode($dir.'/'.$name),
            $name
        );
    }
    else
    {
        $item = sprintf(
            '<a href="%s/admin.php?module=edit_file.inc&amp;file=%s">%s</a>',
            config('site_path'),
            urlencode($dir.'/'.$name),
            $name);
    }
    if (trim($item) != '')
        $output .= $item . "<br />\n";
}
$output .= "</p>\n";

$PAGE->assign('admin_content', "<p>".$output."</p>\n");
?>