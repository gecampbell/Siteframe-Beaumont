<?php
// $Id: block.recent.php,v 1.7 2006/01/26 06:20:06 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.
//
// fetches N recent items of class "class"

// smarty_block_recent()
// this is the function that implements the block
function smarty_block_recent($parm, $content, &$smarty, &$repeat)
{
    static $_block_recent_myquery;

    // the class= parameter is required
    if (!isset($parm['class']))
    {
        echo "{recent:No class}";
        $repeat = FALSE;
        return;
    }
    $class = $parm['class'];

    if (!isset($content))           // first pass through block
    {
        $obj = new $class();
        
        // construct where clause
        $where = array();
        if (isset($parm['user']))
            $where[] = sprintf('%s=%d', $obj->owner, $parm['user']);
        if (isset($parm['folder']) && $parm['folder'])
        {
            if ($class == 'Page')
                $where[] = sprintf('page_folder_id=%d', $parm['folder']);
            else
                $where[] = sprintf('folder_id=%d', $parm['folder']);
        }
        if (isset($parm['image']))
            $where[] = "file_mime_type='image' ";
        
        // build the query
        $q = sprintf(
            "SELECT * FROM %s %s %s ".
            "ORDER BY %s DESC",
            $obj->table_name(),
            count($where) ? "WHERE" : "",
            count($where) ? implode(" AND ", $where) : "",
            $obj->created
        );
        $_block_recent_myquery = new Query($class, $q,
            $parm['num'] ? $parm['num'] : config('recent_items', 20));
    }
    else
    {
        echo $content;
    }
    
    // fetch values, determine whether or not to repeat
    $arr = array();
    $arr = $_block_recent_myquery->get_all();
    if (count($arr)) {
        $smarty->assign(strtolower($parm['class']), $arr);
        $repeat = TRUE;
    }
    else
        $repeat = FALSE;
}
?>