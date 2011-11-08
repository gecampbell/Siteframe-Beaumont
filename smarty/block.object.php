<?php
// $Id: block.object.php,v 1.2 2005/12/24 22:56:28 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.
//
// fetches a single object

// smarty_block_object()
// this is the function that implements the block
function smarty_block_object($parm, $content, &$smarty, &$repeat)
{
    static $myquery;

    if (!isset($content))           // first pass through block
    {
        $class = trim($parm['class']);
        if ($class == '')
        {
            echo "Must provide class= ";
            $repeat = FALSE;
            return;
        }
        $obj = new Class($parm['id']);
    }
    else
    {
        echo $content;
    }
    
    // fetch values, determine whether or not to repeat
    $smarty->assign($obj->get_all());
    $repeat = false;
}
?>