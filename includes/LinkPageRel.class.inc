<?php
// $Id: LinkPageRel.class.inc,v 1.1 2005/09/01 17:04:31 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.
//
// this class defines a Link-Page relationship

class LinkPageRel extends DataObject
{
public $table = 'page_link_link';
public $created = 'link_rel_created';
public $metadata = array(
    'link_id' => array(
        'col' => true,
        'type' => 'integer',
        'required' => true,
        'hidden' => true,
        'index' => true,
        'references' => 'Link.link_id',
    ),
    'page_id' => array(
        'col' => true,
        'type' => 'integer',
        'required' => true,
        'hidden' => true,
        'index' => true,
        'references' => 'Page.page_id',
    ),
    'link_rel_created' => array(
        'col' => true,
        'type' => 'datetime',
        'internal' => true,
        'index' => true,
        'required' => true,
    ),
);

// create_indexes() - need a unique index on the two columns
public function create_indexes()
{
    $arr = array();
    $arr[] = sprintf(
        "CREATE UNIQUE INDEX link_page_ndx ON %s (link_id, page_id)",
        $this->table_name());
    return $arr;
}

// get_title() - return a title
public function get_title()
{
    $link = new Link($this->get('link_id'));
    $page = new Page($this->get('page_id'));
    return sprintf("Link %s on %s", $link->get_title(), $page->get_title());
}

} // end class LinkPageRel

?>