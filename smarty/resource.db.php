<?php
// $Id: resource.db.php,v 1.3 2006/05/03 01:31:48 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.
// This file creates the "db:" template resource for retrieving 
// templates from the database.

// register resources
/*
$PAGE->register_resource('db', array(
    'db_get_template',
    'db_get_timestamp',
    'db_get_secure',
    'db_get_trusted'
));
*/
    
// gets templates from the database
// smarty_resource_db_source
function smarty_resource_db_source($tpl_name, &$tpl_source, &$smarty_obj)
{
	// get a database connection
    $DB = Database::getReader();

    // query the table
    $tpl = new Template();
    $q = sprintf(
        "SELECT tpl_id FROM %s WHERE tpl_name='%s'",
        $tpl->table_name(),
        $tpl_name
    );
    $result = $DB->query($q);
    check_db($DB);
    if (!$result)
        return false;
    if (!$result->num_rows)
        return false;
    list($id) = $result->fetch_array();
    
    // retrieve the template
    $tpl = new Template($id);
    $tpl_source = $tpl->get('tpl_text');
    return true;
}

// get_timestamp
function smarty_resource_db_timestamp($tpl_name, &$tpl_timestamp, &$smarty_obj)
{
    // get a database connection
    $DB = Database::getReader();

    $tpl = new Template;
    $q = sprintf(
        "SELECT tpl_modified FROM %s WHERE tpl_name='%s'",
        $tpl->table_name(),
        $tpl_name
    );
    $result = $DB->query($q);
    check_db($DB);
    if (!$result)
        return false;
    if (!$result->num_rows)
        return false;
    list($mod) = $result->fetch_array();
    $tpl_timestamp = strtotime($mod);

    return true;
}

// get_secure
function smarty_resource_db_secure($tpl_name, &$smarty_obj)
{
    // assume that none of them are secure
    return true;
}

// get_trusted
function smarty_resource_db_trusted($tpl_name, &$smarty_obj)
{
    // not used
    return true;
}

?>