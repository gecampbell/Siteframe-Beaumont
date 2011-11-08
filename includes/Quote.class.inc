<?php
// $Id: Quote.class.inc,v 1.6 2005/06/24 05:22:06 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.
//
// this class defines a User-to-user relationship

class Quote extends DataObject
{
public $table = 'quotes';
public $key = 'quote_id';
public $owner = 'quote_user_id';
public $created = 'quote_created';
public $modified = 'quote_modified';
public $obj_props = 'quote_properties';
public $fulltext = array('quote_text', 'quote_url');
public $metadata = array(
    'quote_id' => array(
        'col' => true,
        'type' => 'integer',
        'required' => true,
        'hidden' => true,
        'auto_increment' => true,
    ),
    'quote_user_id' => array(
        'col' => true,
        'type' => 'integer',
        'required' => true,
        'hidden' => true,
        'index' => true,
        'references' => 'User.user_id',
    ),
    'quote_created' => array(
        'col' => true,
        'type' => 'datetime',
        'require' => true,
        'internal' => true,
        'noupdate' => true,
        'index' => true,
    ),
    'quote_modified' => array(
        'col' => true,
        'type' => 'datetime',
        'require' => true,
        'internal' => true,
        'index' => true,
    ),
    'quote_text' => array(
        'col' => false,
        'type' => 'textarea',
        'formatted' => false,
        'rows' => 5,
        'required' => true,
    ),
);

// make up a title
public function get_title()
{
    return $this->get('quote_text');
}

// return URL
public function get_url()
{
    return sprintf("%s/quotes.php", config('site_path'));
}

} // end class TagPageRel

?>