<?php
// $Id: TagPageRel.class.inc,v 1.14 2005/11/05 05:21:55 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.
//
// this class defines a Tag-Page relationship

class TagPageRel extends DataObject
{
public $table = 'page_tag_link';
public $key = 'rel_id';
public $created = 'rel_created';
public $metadata = array(
    'rel_id' => array(
        'col' => TRUE,
        'type' => 'integer',
        'require' => TRUE,
        'hidden' => TRUE,
        'auto_increment' => TRUE,
    ),
    'tag_id' => array(
        'col' => TRUE,
        'type' => 'integer',
        'required' => TRUE,
        'hidden' => TRUE,
        'index' => TRUE,
        'references' => 'Tag.tag_id',
    ),
    'page_id' => array(
        'col' => TRUE,
        'type' => 'integer',
        'required' => TRUE,
        'hidden' => TRUE,
        'index' => TRUE,
        'references' => 'Page.page_id',
    ),
    'rel_created' => array(
        'col' => TRUE,
        'type' => 'datetime',
        'internal' => TRUE,
        'index' => TRUE,
        'required' => TRUE,
    ),
);

// create_indexes() - need a unique index on the two columns
public function create_indexes()
{
    $arr = array();
    $arr[] = sprintf(
        "CREATE UNIQUE INDEX tag_page_ndx ON %s (tag_id, page_id)",
        $this->table_name());
    return $arr;
}

// get_title() - return a title
public function get_title()
{
    $tag = new Tag($this->get('tag_id'));
    $page = new Page($this->get('page_id'));
    return sprintf("Tag %s on %s", $tag->get('tag_name'), $page->get_title());
}

} // end class TagPageRel

?>