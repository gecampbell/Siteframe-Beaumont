<?php
// $Id: Link.class.inc,v 1.7 2005/10/08 04:34:54 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.

class Link extends DataObject
{
public $table = 'links';
public $key = 'link_id';
public $owner = 'link_user_id';
public $created = 'link_created';
public $modified = 'link_modified';
public $fulltext = array('link_url', 'link_text');
public $obj_props = 'link_properties';
public $metadata = array(
    'link_id' => array(
        'col' => TRUE,
        'type' => 'integer',
        'required' => TRUE,
        'internal' => TRUE,
        'auto_increment' => TRUE,
    ),
    'link_user_id' => array(
        'col' => TRUE,
        'type' => 'integer',
        'required' => TRUE,
        'internal' => TRUE,
        'index' => TRUE,
        'references' => 'User.user_id',
    ),
    'link_num_visits' => array(
        'col' => TRUE,
        'type' => 'integer',
        'required' => TRUE,
        'internal' => TRUE,
    ),
    'link_created' => array(
        'col' => TRUE,
        'type' => 'datetime',
        'required' => TRUE,
        'internal' => TRUE,
        'index' => TRUE,
    ),
    'link_modified' => array(
        'col' => TRUE,
        'type' => 'datetime',
        'required' => TRUE,
        'internal' => TRUE,
        'index' => TRUE,
    ),
    'link_text' => array(
        'col' => TRUE,
        'type' => 'text',
        'size' => 40,
        'minlength' => 5,
        'maxlength' => 250,
        'index' => TRUE,
    ),
    'link_url' => array(
        'col' => TRUE,
        'type' => 'text',
        'size' => 40,
        'maxlength' => 250,
        'index' => TRUE,
        'value' => 'http://'
    ),
    'link_comment' => array(
        'col' => FALSE,
        'type' => 'textarea',
        'rows' => 5,
    ),
);

// delete - also remove related links from pages
public function delete()
{
    // remove related links
    $this->delete_all('LinkPageRel', 'link_id', $this->id());
    
    // and delete it
    parent::delete();
}

// url is listing page
public function get_url()
{
    $u = new User($this->get('link_user_id'));
    return sprintf('%s/links.php?u=%s',
            config('site_path'),
            $u->get('user_name'));
}

// title is link text
public function get_title()
{
    return $this->get('link_text');
}

// create indices
public function create_indexes()
{
    $arr = array();
    $arr[] = sprintf(
        "CREATE UNIQUE INDEX %s_user_link_ndx ON %s (link_user_id, link_text)",
        $this->table_name(),
        $this->table_name());
    return $arr;
}

} // end class Link

?>