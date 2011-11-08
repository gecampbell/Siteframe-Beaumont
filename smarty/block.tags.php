<?php
// $Id: block.tags.php,v 1.5 2006/05/03 01:31:48 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.
//
// context for fetching most popular tags
// example:
//   {tags num=50}
//   <a href="{$tag.url}">{$tag.tag_name}</a>
//   {/tags}

// smarty_block_tags()
// this is the function that implements the block
function smarty_block_tags($parm, $content, &$smarty, &$repeat)
{
    static $_block_tags_query;
    static $total_num;
    static $tags;
    static $cur;
    static $max;
    
    $DB = Database::getReader();

    if (!isset($content))           // first pass through block
    {
        $t = new Tag;
        $rel = new TagPageRel;
        // sort=count / sort=anything (name)
        $q = sprintf(
            "SELECT tag.tag_id,COUNT(*) AS NUM
              FROM %s tag JOIN %s rel ON (tag.tag_id=rel.tag_id)
              %s
              GROUP BY tag.tag_id
              ORDER BY %s
              LIMIT %d",
            $t->table_name(),
            $rel->table_name(),
            (isset($parm['days']) ? 
                sprintf('WHERE rel_created>DATE_SUB(NOW(),INTERVAL %d DAY)',
                    $parm['days']) :
                ''),
            '2 DESC',
            isset($parm['num']) ? $parm['num'] : config('recent_items', 20)
        );
        // once through to get stats
        $result = $DB->query($q);
        check_db($DB);
        $total_num = 0;
        while(list($tagid,$count) = $result->fetch_array())
        {
            $tag_count[$tagid] = $count;
            $total_num += $count;
        }
        
        // handle no tags
        if ($total_num != 0)
        {
            // get the num= most popular tags
            $i = 0;
            $max = 1;
            $min = 999999;
            foreach($tag_count as $id => $num)
            {
                $t = new Tag($ix);
                $tags[$id] = $num;
                $ids[] = $id;
                $min = min($num, $min);
                $max = max($num, $max);
            }
            $cur = 0;
            
            // define the REAL query
            $q = sprintf(
                "SELECT tag.tag_id,COUNT(*) AS NUM
                  FROM %s tag JOIN %s rel ON (tag.tag_id=rel.tag_id)
                  WHERE tag.tag_id IN (%s)
                  GROUP BY tag.tag_id
                  HAVING COUNT(*) >= %d
                  ORDER BY %s",
                $t->table_name(),
                $rel->table_name(),
                implode(',',$ids),
                $min,
                ($parm['sort']=='count') ? '2 DESC, tag_name' : 'tag_name'
            );
            $_block_tags_query = new Query('Tag', $q);
        }
    }
    else
    {
        echo $content;
    }
    
    if (!is_object($_block_tags_query))
        $repeat = FALSE;
    else
    {
        // fetch values, determine whether or not to repeat
        $arr = $_block_tags_query->get_all();
        if (count($arr)) {
            $smarty->assign('tag', $arr);
            $smarty->assign('count', $tags[$arr['id']]);
            $smarty->assign('total', $total_num);
            $smarty->assign('percent', $tags[$arr['id']] / $max);
            ++$cur;
            $repeat = TRUE;
        }
        else
            $repeat = FALSE;
    }
}
?>