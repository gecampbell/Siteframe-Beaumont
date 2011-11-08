<?php
// $Id: block.user_images.php,v 1.3 2006/01/30 14:14:58 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.
//
// user_images: a text block that displays all of a users images
// usage:
//      {user_images user=N [start=N end=N]}
//      .. image context
//      {/user_images}

// smarty_block_user_images()
// this is the function that implements the block
function smarty_block_user_images($parm, $content, &$smarty, &$repeat)
{
    static $myquery;

    if (!isset($content))           // first pass through block
    {
        $f = new File;
        $q = sprintf(
            "SELECT file_id FROM %s WHERE file_mime_type='image' ".
            "AND file_user_id=%d ".
            "ORDER BY file_name",
            $f->table_name(),
            $parm['user']
        );
        $myquery = new Query('File', $q, $parm['start'], $parm['end']);
    }
    else
    {
        echo $content;
    }
    
    // fetch values, determine whether or not to repeat
    $arr = $myquery->get_all();
    if (count($arr)) {
        $smarty->assign('file', $arr);
        $repeat = true;
    }
    else
        $repeat = false;
}
?>