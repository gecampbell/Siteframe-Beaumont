<?php
// $Id: function.menu.php,v 1.1 2005/11/22 22:33:30 glen Exp $
// Copyright (c)2004, Glen Campbell. All rights reserved.
//
// The menu function operates in two modes:
// 1. adding items to a menu:
//    {menu name="menuname" link="link" text="text"}
// 2. inserting the menu:
//    {menu name="menuname" [ sep="separator" sort=true ] }
// in other words, if param "item" is present, it adds the item
// to the menu. In any other situation, it inserts the current menu

// smarty_function_menu - retrieve a menuuage string for the templates
function smarty_function_menu($parms)
{
    global $_SMARTY_MENU_ITEMS;

    // the name= parameter is required
    if (!isset($parms['name']))
        return lang('err_nomenuname');
    
    // if text=, then add to list
    if (isset($parms['text']))
    {
        $_SMARTY_MENU_ITEMS[$parms['name']][$parms['text']] = array(
            'link' => $parms['link'],
            'onclick' => $parms['onclick'],
            'title' => $parms['title'],
        );
        return '';
    }
    else if (is_array($_SMARTY_MENU_ITEMS[$parms['name']]))
    {
        $menu = $_SMARTY_MENU_ITEMS[$parms['name']];
        if ($parms['sort'])
            $menu = ksort($menu);
        foreach($menu as $text => $info)
        {
            if ($info['image'] == '')
                $img = '';
            else
                $img = sprintf(
                    '<img src="%s" alt="%s" />',
                    $info['image'],
                    $text);
            if ($info['link'] == '')
                $outmenu[] = sprintf('%s%s%s', 
                    $parms['prefix'], $text, $parms['suffix']);
            else
                $outmenu[] = sprintf('%s<a href="%s"%s>%s</a>%s', 
                    $parms['prefix'], $info['link'], 
                    (($info['onclick'] ? sprintf(' onclick="%s"', $info['onclick']) : '').
                     ($info['title'] ? sprintf(' title="%s"', $info['title']) : '')
                    ),
                    $text, $parms['suffix']);
        }
        return implode(isset($parms['sep']) ? $parms['sep'] : ' ', $outmenu);
    }
    else
        return '';
}
?>