<?php
// $Id: block.archives.php,v 1.4 2006/05/03 01:31:48 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.
//
// This block fetches all the pages that reference a file

// smarty_block_archives()
// this is the function that implements the block
function smarty_block_archives($parm, $content, &$smarty, &$repeat)
{
    static $result;

    if (!isset($content))           // first pass through block
    {
        $where = '';
        if (isset($parm['folder']) && $parm['folder'])
            $where = sprintf('WHERE page_folder_id=%d', $parm['folder']);
        $p = new Page;
        $q = sprintf(
            "SELECT DISTINCT YEAR(page_created),MONTH(page_created) FROM %s ".
            $where .' '.
            "ORDER BY 1, 2",
            $p->table_name()
        );
        $DB = Database::getReader();
        $result = $DB->query($q);
        check_db($DB);
    }
    else
    {
        echo $content;
    }
    
    // fetch values, determine whether or not to repeat
    if (list($year,$month) = $result->fetch_array())
    {
        $smarty->assign('archive_date',
            sprintf('%04d-%02d-01 00:00:00', $year, $month));
        $smarty->assign('year', $year);
        $smarty->assign('month', $month);
        $repeat = true;
    }
    else
        $repeat = false;
}
?>