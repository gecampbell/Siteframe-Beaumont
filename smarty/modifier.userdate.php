<?php
// $Id: modifier.userdate.php,v 1.2 2005/12/24 22:56:28 glen Exp $
// Copyright (c)2004, Glen Campbell. All rights reserved.
// See license.txt for details.

// this is a modified function that converts the specified date to the
// current user's timezone
function smarty_modifier_userdate($timestamp, $format_string)
{
    $CURUSER = $_SESSION['user'];

    // we'll accept the time as either a UNIX timestamp or a
    // formatted value. If numeric, we assume that it's a timestamp;
    // otherwise, we attempt to convert it to one.
    if (trim($timestamp) == '')
        return '';

    $timestamp = strtotime($timestamp);

    // we check for the feature being enabled, the existence of a user,
    // and finally a user timezone setting.
    if (is_object($CURUSER) && (is_numeric($CURUSER->get('user_timezone'))))
    {
        // this gets the user's timezone setting (-12 to +12)
        $user_tz = $CURUSER->get('user_timezone');

        // this computes the differentiated time value
        $user_timestamp = 
            $timestamp + 
            round(($user_tz-config('default_timezone',-8))*3600);
    }
    else
        $user_timestamp = $timestamp;
    
    return strftime($format_string, $user_timestamp);
}
?>