<?php
// $Id: function.userrating.php,v 1.2 2006/05/03 01:31:48 glen Exp $
// Copyright (c)2004, Glen Campbell. All rights reserved.
//
// This defines the Smarty extension function {config name=XX}, which
// returns the value of the configuration variable XX

// smarty_function_userrating - retrieves a user rating for an object
function smarty_function_userrating($parms)
{
    global $PAGE;

    $r = new Rating;
    $q = sprintf(
        "SELECT rate_id, rate_rating FROM %s ".
        "WHERE rate_page_id=%d AND ".
        "rate_user_id=%d",
        $r->table_name(),
        $parms['id'],
        $_SESSION['user']->id());

	$DB = Database::getReader();
    $result = $DB->query($q);
    check_db($DB);
    list ($rate_id, $rating) = $result->fetch_row();
    
    // if rate_id= is set, return the rate_id
    if (isset($parms['rate_id']))
        $PAGE->assign($parms['rate_id'], $rate_id);
    
    // if var= is set, set the variable, other wise return the value
    if (isset($parms['var']))
    {
        $PAGE->assign($parms['var'], $rating);
        return '';
    }
    else
        return sprintf('%d', $rating);
}
?>