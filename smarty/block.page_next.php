<?php
// $Id: block.page_next.php,v 1.2 2005/12/24 22:56:28 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.
//
// fetches the next page in the folder represented by the 
// specified page and folder IDs
// EXAMPLE:
// {page_next page=12 folder=32} ... {/page_next}

// smarty_block_page_next()
// this is the function that implements the block
function smarty_block_page_next($parm, $content, &$smarty, &$repeat)
{
    static $myquery;

    if (!isset($content))           // first pass through block
    {

        $f = new Folder($parm['folder']);
        $current = new Page($parm['page']);
        
        // get the sort field
        $field = $f->get('folder_orderby');
        $space = strpos($field, ' ');

        if ($space)
        {
            $fieldname = substr($field, 0, $space);
            $operator = '<';
        }
        else
        {
            $fieldname = $field;
            $operator = '>';
        }
        $cur_val_of_field = $current->get($fieldname);

        // build the query
        $q = sprintf(
            "SELECT * 
             FROM %s page JOIN %s folder 
               ON page.page_folder_id=folder.folder_id
             WHERE page.%s %s '%s' 
               AND page_folder_id=%d
             ORDER BY %s
             LIMIT 1",
             $current->table_name(),
             $f->table_name(),
             $fieldname,
             $operator,
             addslashes($cur_val_of_field),
             $f->id(),
             $f->get('folder_orderby')
        );

        $myquery = new Query('Page', $q);
    }
    else
    {
        echo $content;
    }
    
    // fetch values, determine whether or not to repeat
    $arr = $myquery->get_all();
    if (count($arr))
    {
        $smarty->assign('page', $arr);
        $repeat = TRUE;
    }
    else
        $repeat = FALSE;
}
?>