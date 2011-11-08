<?php
// $Id: Property.class.inc,v 1.3 2005/04/01 12:55:59 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.

class Property extends DataObject
{
public $table = 'properties';
public $key = 'name';
public $metadata = array(
    'name' => array(
        'col' => true,
        'type' => 'text',
        'maxlength' => 50,
        'required' => true,
        'internal' => false,
        'unique' => true,
    ),
    'value' => array(
        'col' => true,
        'type' => 'textarea',
        'required' => false,
        'internal' => false,
    ),
);

// constructor should do nothing
public function __construct() { }

} // end class Property

?>