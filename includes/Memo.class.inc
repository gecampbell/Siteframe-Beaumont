<?php
// $Id: Memo.class.inc,v 1.5 2005/04/20 21:23:19 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.

class Memo extends DataObject
{
public $table = 'memoranda';
public $key = 'memo_id';
public $owner = 'memo_from_user_id';
public $obj_props = 'memo_props';
public $created = 'memo_created';
public $modified = 'memo_modified';
public $metadata = array(
    'memo_id' => array(
        'col' => true,
        'type' => 'integer',
        'hidden' => true,
        'auto_increment' => true,
        'required' => true,
    ),
    'memo_read' => array(
        'col' => true,
        'type' => 'integer',
        'required' => true,
        'value' => 0,
        'index' => true,
        'internal' => true,
    ),
    'memo_to_user_id' => array(
        'col' => true,
        'type' => 'select',
        'sqltype' => 'INTEGER',
        'options' => array(),
        'required' => true,
        'index' => true,
        'references' => 'User.user_id',
    ),
    'memo_from_user_id' => array(
        'col' => true,
        'type' => 'integer',
        'required' => true,
        'index' => true,
        'internal' => true,
        'references' => 'User.user_id',
    ),
    'memo_created' => array(
        'col' => true,
        'type' => 'datetime',
        'required' => true,
        'internal' => true,
        'noupdate' => true,
        'index' => true,
    ),
    'memo_modified' => array(
        'col' => true,
        'type' => 'datetime',
        'required' => true,
        'internal' => true,
    ),
    'memo_subject' => array(
        'col' => true,
        'type' => 'text',
        'size' => 40,
        'maxlength' => 250,
        'minlength' => 1,
        'required' => true,
    ),
    'memo_body' => array(
        'col' => false,
        'type' => 'textarea',
        'required' => true,
        'formatted' => true,
        'rows' => 12,
    ),
);

// constructor - determine who the real owner is
public function __construct($id=0, $row=array())
{
    parent::__construct($id, $row);
    if ($this->id())
        $this->owner = 'memo_to_user_id';
}

// get_all - add additional user information
public function get_all()
{
    $arr = parent::get_all();
    $u = new User($this->get('memo_from_user_id'));
    $arr['from'] = $u->get_all();
    return $arr;
}

// form - if necessary, build the user options list
public function form($name, $action, $method, $submit="Send", $reset="Reset")
{
    if ($uid = $this->get('memo_to_user_id'))
    {
        $u = new User($uid);
        $this->metadata['memo_to_user_id']['options'] = 
            array($uid => $u->get_title());
    }
    else
    {
        $this->metadata['memo_to_user_id']['options'] = get_user_list();
    }
    return parent::form($name, $action, $method, $submit, $reset);
}

// get_title()
public function get_title()
{
    return $this->get('memo_subject');
}

// get_url() redirect
public function get_url()
{
    return sprintf("%s/memos.php", config('site_path'));
}

}
?>
