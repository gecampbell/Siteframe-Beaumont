<?php
// $Id: Trackback.class.inc,v 1.3 2006/01/01 01:06:06 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.
// This saves Trackback pings

class Trackback extends DataObject
{
public $table = 'trackbacks';
public $key = 'tb_id';
public $obj_props = 'tb_props';
public $created = 'tb_created';
public $modified = 'tb_modified';
public $fulltext = array('tb_title', 'tb_url', 'tb_blog_name', 'tb_excerpt');
public $sortfield = 'tb_created';
public $metadata = array(
    'tb_id' => array(
        'col' => TRUE,
        'type' => 'integer',
        'auto_increment' => TRUE,
        'required' => TRUE,
        'hidden' => TRUE,
    ),
    'tb_page_id' => array(
        'col' => TRUE,
        'type' => 'integer',
        'required' => TRUE,
        'hidden' => TRUE,
        'references' => 'Page.page_id',
    ),
    'tb_created' => array(
        'col' => TRUE,
        'type' => 'datetime',
        'required' => TRUE,
        'internal' => TRUE,
        'noupdate' => TRUE,
        'index' => TRUE,
    ),
    'tb_modified' => array(
        'col' => TRUE,
        'type' => 'datetime',
        'required' => TRUE,
        'internal' => TRUE,
    ),
    'tb_title' => array(
        'col' => TRUE,
        'type' => 'text',
        'maxlength' => 250,
        'index' => TRUE,
    ),
    'tb_url' => array(
        'col' => TRUE,
        'type' => 'text',
        'maxlength' => 250,
        'index' => TRUE,
        'minlength' => 4,
    ),
    'tb_blog_name' => array(
        'col' => TRUE,
        'type' => 'text',
        'maxlength' => 250,
        'index' => TRUE,
    ),
    'tb_excerpt' => array(
        'col' => FALSE,
        'type' => 'textarea',
        'formatted' => TRUE,
    ),
);

} // end class Trackback

?>