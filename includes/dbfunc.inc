<?php
// $Id: dbfunc.inc,v 1.3 2005/09/18 15:35:50 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.
// various database creation support functions

// create_table() returns a CREATE TABLE statement for the object
function create_table($obj)
{
    global $SQL;
    if ($obj->key != '')
        $q = sprintf("CREATE TABLE %s (\n%s ,\nPRIMARY KEY (%s)",
                $obj->table_name(),
                create_cols($obj),
                create_primary($obj));
    else
        $q = sprintf("CREATE TABLE %s (\n%s",
                $obj->table_name(),
                create_cols($obj));
    $u = create_indices($obj);
    if ($u != '')
        $q .= ",\n".$u;
    $f = implode(",\n",$obj->foreign_keys());
    if ($f != '')
        $q .= ",\n".$f;
    $q .= ")\n";
    $q .= "ENGINE=".$obj->engine."\n";
    $q .= "DEFAULT CHARSET=".$obj->charset;
    $SQL .= $q . ";\n\n";
    return $q;
}

// create_cols()  - column part of CREATE TABLE
function create_cols($obj)
{
    $list = array();
    foreach($obj->metadata as $name => $info)
    { 
        if ($info['col'])
        {
            $list[] = column_def($name, $info);
        }
    }
    if ($obj->obj_props != '')
        $list[] = sprintf('  %-20s %s', $obj->obj_props, 'TEXT');
    return(implode(",\n",$list));
}

// column_def - given a metadata structure, return the column def
function column_def($name, $info)
{
    $item = '  '.$name.' ';
    $item = sprintf('  %-20s ', $name);
    switch($info['type'])
    {
    case 'file':
        $info['maxlength'] = 250;
    case 'text':
    case 'password':
        $item .= "VARCHAR({$info['maxlength']}) ";
        break;
    case 'xml':
    case 'textarea':
        $item .= "TEXT ";
        break;
    case 'checkbox':
    case 'integer':
    case 'number':
        $item .= "INTEGER ";
        if ($info['auto_increment'])
            $item .= "AUTO_INCREMENT ";
        break;
    case 'datetime':
        $item .= "DATETIME ";
        break;
    case 'date':
        $item .= "DATE ";
        break;
    case 'file':
    case 'select':
        $item .= $info['sqltype'].' ';
        break;
    default:
        abort('Unrecognized data type /%s/ for %s', $info['type'], $name);
    }
    if ($info['required'])
        $item .= "NOT NULL ";
    return $item;
}

// create_primary() - create a primary key definition
function create_primary($obj)
{
    return $obj->key;
}

// create_indices() - returns string of unique indices
function create_indices($obj)
{
    $list = array();
    foreach($obj->metadata as $name => $info)
    {
        if ($info['unique'])
            $list[] = "UNIQUE INDEX ($name)";
        else if ($info['index'])
            $list[] = "INDEX ($name)";
    }
    if (count($list))
        return implode(",\n", $list);
    else
        return "";
}

?>