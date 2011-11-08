<?php
// $Id: TagUserRel.class.inc,v 1.1 2005/09/18 06:17:51 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.
//
// this class defines a Tag-Page relationship

class TagUserRel extends DataObject
{
public $table = 'tag_user_link';
public $created = 'rel_created';
public $metadata = array(
    'tag_id' => array(
        'col' => true,
        'type' => 'integer',
        'required' => true,
        'hidden' => true,
        'index' => true,
        'references' => 'Tag.tag_id',
    ),
    'user_id' => array(
        'col' => true,
        'type' => 'integer',
        'required' => true,
        'hidden' => true,
        'index' => true,
        'references' => 'User.user_id',
    ),
    'rel_created' => array(
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
        "CREATE UNIQUE INDEX tag_user_ndx ON %s (tag_id, user_id)",
        $this->table_name());
    return $arr;
}

// get_title() - return a title
public function get_title()
{
    $tag = new Tag($this->get('tag_id'));
    $user = new Page($this->get('user_id'));
    return sprintf("Tag %s on %s", $tag->get('tag_name'), $user->get_title());
}

} // end class TagUserRel

?>
