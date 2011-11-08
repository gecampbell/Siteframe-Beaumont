<?php
// $Id: Query.class.inc,v 1.12 2006/05/03 01:31:48 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.
//
// This implements a mechanism for querying defined Siteframe(tm) object.

class Query extends ReadOnly
{
private $result;    // the query result set
private $class;     // the type of object to build
private $count = 0; // row counter
public $metadata = array(
    'Results' => array(
        'type' => 'array',
        'value' => array(),
    ),
);

// build a new query
public function __construct($class, $sql, $lim1=0, $lim2=0)
{
    $DB = Database::getReader();
    
    // save the class
    $this->class = $class;
    
    // add LIMIT, if necessary
    if ($lim2)
        $sql .= sprintf(" LIMIT %d, %d", $lim1, $lim2);
    else if ($lim1)
        $sql .= sprintf(" LIMIT %d", $lim1);
        
    // execute query
    $this->result = $DB->query($sql);
    check_db($DB);
    
    // build the constructor
    parent::__construct();
}

// num_rows()
// returns the number of rows in the result set
public function num_rows()
{
    return $this->result->num_rows;
}

// get_all() 
// return all the properties for the specified class
public function get_all()
{
    // increment counter
    ++$this->count;
    
    // fetch the next row
    list($row) = $this->result->fetch_row();
    if (!$row)
        return array();
    $class = $this->class;
    if (count($row) == 1)
        $obj = new $class($row);
    else
        $obj = new $class(0, $row);
    
    // abort on object errors
    if (!$obj->is_valid())
    {
        //abort($obj->get_errors());
    }
    
    // get values
    $arr = $obj->get_all();

    // add the counter
    $arr['_row_'] = $this->count;
    if ($this->count % 2)
        $arr['_row_class_'] = 'odd';
    else
        $arr['_row_class_'] = 'even';
    
    return $arr;
}

// id() - this is needed
public function id() { return ''; }

// xml()
public function xml() { 
    $this->metadata['Results']['value'] = $this->get_all();
 //print_r($this);
    return parent::xml();
}

// get_url()
public function get_url()
{
    if (config('url_rewriting'))
        return config('site_path').'/list/'.get_class($this);
    else
        return config('site_path').'/list.php?c='.get_class($this);
}

} // end class Query

?>
