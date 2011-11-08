<?php
// $Id: function.page_views.php,v 1.2 2006/05/03 01:31:48 glen Exp $
// Copyright (c)2004, Glen Campbell. All rights reserved.
//
// usage:
//  {page_views days=N}

// smarty_function_page_views - returns the number of page views in the N most recent days
function smarty_function_page_views($parms)
{
    $DB = Database::getReader();

    extract($parms);

    $log = new UserLog;
    $q = sprintf(
        "SELECT COUNT(*) FROM %s ".
        "WHERE log_created>DATE_SUB(NOW(),INTERVAL %d DAY)",
        $log->table_name(),
        $days ? $days : 1);
    $result = $DB->query($q);
    check_db($DB);
    list ($num) = $result->fetch_row();
    return number_format($num);
}

?>