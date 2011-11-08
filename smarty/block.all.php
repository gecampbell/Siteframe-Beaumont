<?php
// $Id: block.all.php,v 1.4 2005/12/31 23:26:28 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.
//
// fetches N recent items of class "class"

// smarty_block_all()
// this is the function that implements the block
function smarty_block_all($parm, $content, &$smarty, &$repeat)
{
    static $_block_all_myquery;

    // the class= parameter is required
    if (!isset($parm['class']))
    {
        echo "{all:No class}";
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
        if (isset($parm['folder']))
        {
            if ($class == 'Page')
                $where[] = sprintf('page_folder_id=%d', $parm['folder']);
            else
                $where[] = sprintf('folder_id=%d', $parm['folder']);
        }
        if (isset($parm['parent']))
            $where[] = sprintf('folder_parent_id=%d', $parm['parent']);
        if (isset($parm['image']))
            $where[] = sprintf('is_image=%d', $parm['image']);
        if (isset($parm['page']) && ($class == 'Trackback'))
            $where[] = sprintf('tb_page_id=%d', $parm['page']);
        if (isset($parm['page']) && ($class == 'File'))
            $where[] = sprintf('file_page_id=%d', $parm['page']);
        
        // build the query
        $q = sprintf(
            "SELECT * FROM %s %s %s ".
            "ORDER BY %s",
            $obj->table_name(),
            count($where) ? "WHERE" : "",
            count($where) ? implode(" AND ", $where) : "",
            $obj->sortfield
        );
        $_block_all_myquery = new Query($class, $q,
            $parm['num'] ? $parm['num'] : config('recent_items', 20));
    }
    else
    {
        echo $content;
    }
    
    // fetch values, determine whether or not to repeat
    $arr = array();
    $arr = $_block_all_myquery->get_all();
    if (count($arr)) {
        $smarty->assign(strtolower($parm['class']), $arr);
        $repeat = TRUE;
    }
    else
        $repeat = FALSE;
}
?>