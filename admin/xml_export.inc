<?php
// $Id: xml_export.inc,v 1.4 2006/05/03 01:31:48 glen Exp $
// Copyright(c)2005, Glen Campbell. All rights reserved.
// MODULE(XML export all objects)

$xml = sprintf("<?xml version=\"1.0\" encoding=\"%s\" ?>\n", config('charset'));
$xml .= sprintf("<siteframe version=\"%s\">\n", SITEFRAME_VERSION);
$xml .= "<configuration>\n";
foreach($CONFIG as $name => $value)
{
    $xml .= sprintf("  <%s>", $name);
    if (is_numeric($value))
        $xml .= $value;
    else
        $xml .= '<![CDATA[' . htmlentities($value) . ']]>';
    $xml .= sprintf("</%s>\n", $name);
}
$xml .= "</configuration>\n";
$xml .= "<objects>\n";
foreach($ALL_CLASSES as $class)
{
    $obj = new $class;
    $q = sprintf("SELECT * FROM %s", $obj->table_name());
    $DB = Database::getReader();
    $result = $DB->query($q);
    check_db($DB);
    while($arr = $result->fetch_assoc())
    {
        $o = new $class(0, $arr);
        $xml .= $o->xml();
    }
}
$xml .= "</objects>\n";
$xml .= "</siteframe>\n";

// save the output to a file
$filename = config('dir_files')."/siteframe_export.xml";
file_put_contents($filename, $xml);

$PAGE->assign('page_title', 'XML Export');
$PAGE->assign('error', 'XML export is in '.$filename);
$PAGE->assign('admin_content',
    sprintf('</p><a href="%s/%s">Click here to download</a></p>',
        config('site_path'),
        $filename));
?>