<?php
// $Id: block.file_pages.php,v 1.2 2005/12/24 22:56:28 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.
//
// This block fetches all the pages that reference a file

// smarty_block_file_pages()
// this is the function that implements the block
function smarty_block_file_pages($parm, $content, &$smarty, &$repeat)
{
    static $myquery;

    if (!isset($content))           // first pass through block
    {
        $f = new File;
        $q = sprintf(
            "SELECT file_page_id FROM %s ".
            "WHERE file_id=%d ".
            "ORDER BY file_page_id",
            $f->table_name(),
            $parm['file']
        );
        $myquery = new Query('Page', $q,
            $parm['num'] ? $parm['num'] : config('recent_items', 20));
    }
    else
    {
        echo $content;
    }
    
    // fetch values, determine whether or not to repeat
    $arr = $myquery->get_all();
    if (count($arr)) {
        $smarty->assign('page', $arr);
        $repeat = true;
    }
    else
        $repeat = false;
}
?>