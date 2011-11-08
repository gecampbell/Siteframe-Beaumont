<?php
// $Id: block.folder_path.php,v 1.2 2005/12/24 22:56:28 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.

// smarty_block_folder_path()
function smarty_block_folder_path($parm, $content, &$smarty, &$repeat)
{
    static $pos, $pathinfo;

    if (isset($content))           // first pass through block
    {
        echo $content;
    }
    else if (isset($parm['folder']))
    {
        $pathinfo = get_folder_path($parm['folder']);
        $pos = 0;
    }
    
    // fetch values, determine whether or not to repeat
    $arr = $pathinfo[$pos++];
    if (count($arr)) {
        $smarty->assign('folder', $arr);
        $repeat = TRUE;
    }
    else
        $repeat = FALSE;
}

// get_folder_path - recursively determine the folder's path
function get_folder_path($folderid=0)
{
    if ($folderid)
    {
        $f = new Folder($folderid);
        $info[] = $f->get_all();
        $parent = get_folder_path($f->get('folder_parent_id'));
        return array_merge($parent, $info);
    }
    else
        return array();
}
?>