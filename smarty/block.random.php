<?php
// $Id: block.random.php,v 1.4 2006/06/18 03:43:22 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.
// Modified CGL 2006/6/17 to add same parms as recent

// smarty_random()
// this is the function that implements the block
function smarty_block_random($parm, $content, &$smarty, &$repeat)
{
    static $static_random_myquery;
    // the class= parameter is required
    if (!isset($parm['class']))
    {
        echo "{random:No class}";
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
            "ORDER BY RAND() LIMIT %d",
            $obj->table_name(),
            count($where) ? "WHERE" : "",
            count($where) ? implode(" AND ", $where) : "",
            isset($parm['num']) ? $parm['num'] : 1
        );
        $static_random_myquery = new Query($class, $q);
    }
    else
    {
        echo $content;
    }

    // fetch values, determine whether or not to repeat
    $arr = $static_random_myquery->get_all();
    if (count($arr)) {
        $smarty->assign(strtolower($class), $arr);
        $repeat = TRUE;
    }
    else
        $repeat = FALSE;
}
?>
