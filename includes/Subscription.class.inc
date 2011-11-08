<?php
// $Id: Subscription.class.inc,v 1.9 2005/04/20 21:23:19 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.

class Subscription extends DataObject
{
public $table = 'subscriptions';
public $key = 'sub_id';
public $owner = 'sub_user_id';
public $obj_props = 'sub_properties';
public $created = 'sub_created';
public $modified = 'sub_modified';
public $metadata = array(
    'sub_id' => array(
        'col' => true,
        'type' => 'integer',
        'hidden' => true,
        'auto_increment' => true,
        'required' => true,
    ),
    'sub_user_id' => array(
        'col' => true,
        'type' => 'integer',
        'hidden' => true,
        'required' => true,
        'index' => true,
        'references' => 'User.user_id',
    ),
    'sub_folder_id' => array(
        'col' => true,
        'type' => 'select',
        'sqltype' => 'INTEGER',
        'required' => true,
        'index' => true,
        'references' => 'Folder.folder_id',
    ),
    'sub_created' => array(
        'col' => true,
        'type' => 'datetime',
        'required' => true,
        'internal' => true,     // does not appear on form
        'noupdate' => true,
    ),
    'sub_modified' => array(
        'col' => true,
        'type' => 'datetime',
        'required' => true,
        'internal' => true,
    ),
);

// add folder list
public function __construct($id=0, $row=array())
{
    $this->metadata['sub_folder_id']['options'] = $this->all_folders();
    parent::__construct($id, $row);
}

// get all properties
public function get_all()
{
    $arr = parent::get_all();
    $f = new Folder($this->get('sub_folder_id'));
    $arr['folder'] = $f->get_all();
    $u = new User($this->get('sub_user_id'));
    $arr['user'] = $u->get_all();
    return $arr;
}

// get_title - display the folder's name
public function get_title()
{
    $f = new Folder($this->get('sub_folder_id'));
    return sprintf(lang("title_subscription"), $f->get_title());
}

// define specialized indices
public function create_indexes()
{
    $arr = array();
    $arr[] = sprintf(
        "CREATE UNIQUE INDEX sub_user_id_ndx ON %s (sub_user_id,sub_folder_id)",
        $this->table_name());
    return $arr;
}

// get base url
public function get_url()
{
    return sprintf("%s/subscriptions.php?user=%d",
            config('site_path'),
            $this->get('sub_user_id'));
}

}
?>
