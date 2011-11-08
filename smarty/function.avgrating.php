<?php
// $Id: function.avgrating.php,v 1.3 2006/05/03 01:31:48 glen Exp $
// Copyright (c)2004, Glen Campbell. All rights reserved.
//
// This returns the average rating of an object

// smarty_function_avgrating - retrieves the average rating for an object
function smarty_function_avgrating($parms)
{
    global $PAGE;

    $r = new Rating;
    $q = sprintf(
        "SELECT AVG(rate_rating),COUNT(*) FROM %s ".
        "WHERE rate_page_id=%d",
        $r->table_name(),
        $parms['id']);

	$DB = Database::getReader();
    $result = $DB->query($q);
    list ($rating,$count) = $result->fetch_row();
    
    if (isset($parms['assign']))
    {
        $PAGE->assign($parms['assign'], $rating*1.0);
        $PAGE->assign($parms['assign'].'_num', $count);
        return '';
    }
    else
        return sprintf('%.1f/%d', $rating, $count);
}
?>