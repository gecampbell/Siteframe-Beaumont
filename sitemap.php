<?php
// $Id: sitemap.php,v 1.1 2005/11/16 03:59:27 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.
// This script defines a recursive map of the site's folder structure

require_once 'siteframe.inc';

// this function recursively defines the folder structure
function get_folder_children($parent=0, $level=0)
{
    // we need a folder
    $f = new Folder;
    
    // start with an empty array
    $out = array();
    
    // define our SELECT statement
    $q = sprintf(
        "SELECT folder_id 
         FROM %s 
         WHERE folder_parent_id=%d 
         ORDER BY folder_name",
        $f->table_name(),
        $parent
    );
    $myquery = new Query('Folder', $q);
    
    // build the array
    while($fitem = $myquery->get_all())
    {
        $fitem['level'] = $level;
        $out[] = $fitem;
        $out = array_merge($out, get_folder_children($fitem['folder_id'], $level+1));
    }
    return $out;
}

$PAGE->assign('page_title', lang('page_title_tree'));
$PAGE->assign('folders', get_folder_children());
$PAGE->display();
?>