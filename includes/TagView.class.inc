<?php
// $Id: TagView.class.inc,v 1.1 2005/08/05 21:29:52 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.

class TagView extends DataObject
{
public $table = 'tag_views';
public $created = 'tag_created';
public $metadata = array(
        'view_tag_id' => array(
            'col' => true,
            'type' => 'integer',
            'required' => true,
            'hidden' => true,
            'references' => 'Tag.tag_id',
            'index' => true,
        ),
        'view_user_id' => array(
            'col' => true,
            'type' => 'integer',
            'required' => true,
            'hidden' => true,
            'references' => 'User.user_id',
            'index' => true,
        ),
        'view_created' => array(
            'col' => true,
            'type' => 'datetime',
            'required' => true,
            'internal' => true,
            'noupdate' => true,
            'index' => true,
        ),
);

} // end class Tag

?>