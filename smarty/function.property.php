<?php
// $Id: function.property.php,v 1.2 2006/05/03 01:31:48 glen Exp $
// Copyright (c)2004, Glen Campbell. All rights reserved.
//
// This defines the Smarty extension function {config name=XX}, which
// returns the value of the configuration variable XX

// smarty_function_property - retrieve a persistent property
function smarty_function_property($parms)
{
    $DB = Database::getReader();
    
    $p = new Property;
    $q = sprintf(
        "SELECT value FROM %s WHERE name='%s'",
        $p->table_name(),
        addslashes($parms['name']));
    $result = $DB->query($q);
    check_db($DB);
    list($value) = $result->fetch_row();
    return $value;
}
?>