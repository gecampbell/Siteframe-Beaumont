<?php
// $Id: function.count.php,v 1.2 2006/05/03 01:31:48 glen Exp $
// Copyright (c)2004, Glen Campbell. All rights reserved.
//
// This defines the Smarty extension function {config name=XX}, which
// returns the value of the configuration variable XX

// smarty_function_count - retrieve a language string for the templates
function smarty_function_count($parms)
{
    $DB = Database::getReader();
    if (!isset($parms['class']))
        return '';
    $class = $parms['class'];
    $obj = new $class();
    $q = sprintf('SELECT COUNT(*) FROM %s', $obj->table_name());
    $result = $DB->query($q);
    check_db($DB);
    list($num) = $result->fetch_array();
    return sprintf('%d', $num);
}
?>