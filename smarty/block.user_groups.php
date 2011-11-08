<?php
// $Id: block.user_groups.php,v 1.2 2006/01/31 17:44:31 glen Exp $
// @author Coby Leuschke
// block.user_groups.php ver 1.0 CGL
// user_groups: a block that displays all of a users groups
// usage:
//      {user_groups user=N}
//      .. results ..
//      {/user_groups}

// smarty_block_user_groups()
// this is the function that implements the block
function smarty_block_user_groups($parm, $content, &$smarty, &$repeat)
{
    static $myquery;

    if (!isset($content))           // first pass through block
    {
        $g = new Group;
        $r = new GroupUserRel;
        $q = sprintf(
               "SELECT * FROM %s JOIN %s ON (group_id = r_group_id)
               WHERE r_user_id=%d
               ORDER BY group_name",
               $g->table_name(),
               $r->table_name(),
                       $parm['user']
                       );

        $myquery = new Query('Group', $q);

    }
    else
    {
        echo $content;
    }

    // fetch values, determine whether or not to repeat
    $arr = $myquery->get_all();
    if (count($arr)) {
        $smarty->assign('groups', $arr);
        $repeat = true;
    }
    else
        $repeat = false;
}

?>
