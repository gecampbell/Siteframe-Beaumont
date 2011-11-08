<?php
// $Id: Text.class.inc,v 1.19 2005/12/17 15:57:48 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.

class Text extends DataObject
{
public $table = 'text';
public $key = 'text_id';
public $owner = '';
public $obj_props = 'text_props';
public $created = 'text_created';
public $modified = 'text_modified';
public $fulltext = array('text_title','text_body');
public $sortfield = 'text_title';
public $tag = 'text_name';
public $metadata = array(
    'text_id' => array(
        'col' => TRUE,
        'type' => 'integer',
        'hidden' => TRUE,
        'auto_increment' => TRUE,
        'required' => TRUE,
    ),
    'text_created' => array(
        'col' => TRUE,
        'type' => 'datetime',
        'required' => TRUE,
        'internal' => TRUE,     // does not appear on form
        'noupdate' => TRUE,
        'index' => TRUE,
    ),
    'text_modified' => array(
        'col' => TRUE,
        'type' => 'datetime',
        'required' => TRUE,
        'internal' => TRUE,
    ),
    'text_name' => array(
        'col' => TRUE,
        'type' => 'text',
        'maxlength' => 50,
        'minlength' => 1,
        'pattern' => '/^[a-zA-Z][a-zA-Z0-9_]*$/',
        'required' => TRUE,
        'unique' => TRUE,
    ),
    'text_title' => array(
        'col' => TRUE,
        'type' => 'text',
        'maxlength' => 250,
        'size' => 40,
    ),
    'text_body' => array(
        'col' => TRUE,
        'rows' => 15,
        'type' => 'textarea',
        'required' => FALSE,
        'formatted' => 'ANY',
    ),
);

// authorized() - only administrators
public function authorized()
{
    if (!is_object($_SESSION['user']))
        return FALSE;
    if ($_SESSION['user']->get('user_admin'))
        return TRUE;
    else
        return FALSE;
}

// get_title()
public function get_title()
{
    return $this->get('text_title');
}

} // end class Text
?>
