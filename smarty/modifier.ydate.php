<?php
// $Id: modifier.ydate.php,v 1.2 2005/12/24 22:56:28 glen Exp $
// Copyright (c)2004, Glen Campbell. All rights reserved.
// See license.txt for details.

// this function checks the difference between NOW and the timestamp
// if < 1 minute, returns "about a minute ago"
// if < 1 hour, returns "N minutes ago"
// if < 12 hours, returns "N hours ago"
// otherwise, returns the userdate function
function smarty_modifier_ydate($timestamp, $format_string)
{
    global $PAGE;

    if (trim($timestamp) == '') 
        return '';
    $then = strtotime($timestamp);
    $diff = time() - $then;
    if ($diff < 91)
        return lang('msg_ydate_now');
    else if ($diff < (31*60))
        return sprintf(lang('msg_ydate_minute'), round($diff/60.0));
    else if ($diff < (91*60))
        return lang('msg_ydate_hour');
    else if ($diff < (60*60*12))
        return sprintf(lang('msg_ydate_hours'), round($diff/3600.0));
    else
    {
        require_once $PAGE->_get_plugin_filepath('modifier', 'userdate');
        return smarty_modifier_userdate($timestamp, $format_string);
    }
}
?>