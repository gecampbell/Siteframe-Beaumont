<?php
// $Id: block.rss.php,v 1.2 2005/12/24 22:56:28 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.
//
// iterates through an RSS feed

// smarty_block_rss()
// this is the function that implements the block
function smarty_block_rss($parm, $content, &$smarty, &$repeat)
{
    static $myquery;

    if (!isset($content))           // first pass through block
    {
        $rss = new RSSfeed($parm['source']);
        
        // build the query
        $q = sprintf(
            "SELECT %s FROM %s WHERE rss_url='%s'",
            $rss->key,
            $rss->table_name(),
            $parm['source']
        );
        $myquery = new Query('RSSfeed', $q);
    }
    else
    {
        echo $content;
    }
    
    // fetch values, determine whether or not to repeat
    $arr = $myquery->get_all();
    if (count($arr)) {
        $smarty->assign('rss', $arr);
        $repeat = true;
    }
    else
        $repeat = false;
}
?>