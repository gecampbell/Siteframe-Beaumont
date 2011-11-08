<?php
// $Id: Group.class.inc,v 1.12 2006/05/03 01:31:48 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.

define('MAX_group_name_LENGTH', 50);

class Group extends DataObject
{
public $table = 'groups';
public $key = 'group_id';
public $created = 'group_created';
public $modified = 'group_modified';
public $owner = 'group_user_id';
public $fulltext = array('group_title', 'group_text');
public $sortfield = 'group_title';
public $obj_props = 'group_properties';
public $tag = 'group_name';
public $metadata = array(
    'group_id' => array(
        'col' => TRUE,
        'type' => 'integer',
        'required' => TRUE,
        'internal' => TRUE,
        'auto_increment' => TRUE,
    ),
    'group_open' => array(
        'col' => TRUE,
        'type' => 'checkbox',
        'rval' => 1,
        'value' => 1,
        'index' => TRUE,
    ),
    'group_user_id' => array(
        'col' => TRUE,
        'type' => 'integer',
        'required' => TRUE,
        'internal' => TRUE,
        'index' => TRUE,
        'references' => 'User.user_id',
    ),
    'group_created' => array(
        'col' => TRUE,
        'type' => 'datetime',
        'required' => TRUE,
        'internal' => TRUE,
    ),
    'group_modified' => array(
        'col' => TRUE,
        'type' => 'datetime',
        'required' => TRUE,
        'internal' => TRUE,
    ),
    'group_name' => array(
        'col' => TRUE,
        'type' => text,
        'minlength' => 3,
        'maxlength' => MAX_group_name_LENGTH,
        'unique' => TRUE,
        'required' => TRUE,
        'pattern' => '/^[A-Za-z0-9_]+/',
        'internal' => TRUE,
    ),
    'group_title' => array(
        'col' => TRUE,
        'type' => 'text',
        'maxlength' => 250,
        'minlength' => 4,
        'size' => 50,
        'unique' => TRUE,
        'required' => TRUE,
        'pattern' => '/^[A-Za-z0-9]/',
    ),
    'group_text' => array(
        'type' => 'textarea',
        'rows' => 10,
        'formatted' => TRUE,
    ),
    'alt_template' => array(
        'col' => FALSE,
        'type' => 'select',
        'options' => array( '' => 'Use default template'),
        'advanced' => TRUE,
    ),
);

// constructor - set the tag to be visible
public function __construct($id=0, $arr=array())
{
    parent::__construct($id, $arr);
    if ($this->id())
        $this->metadata['group_name']['disabled'] = TRUE;
}

// add() - create a unique tag for the group
public function add()
{
    // create a unique tag
    $this->set('group_name',
        $this->get_unique_name($this->get('group_title'), 'group_name'));

    parent::add();
}

// get_title() - returns name
public function get_title()
{
    return $this->get('group_title');
}

// get_url() - returns URL
public function get_url()
{
    if (!config('url_rewriting'))
        return sprintf('%s/group.php?id=%s', config('site_path'), $this->get($this->tag));
    else
        return sprintf('%s/group/%s', config('site_path'), $this->get($this->tag));
}

// get_rss_url() - RSS feed for group
public function get_rss_url()
{
    if (config('url_rewriting'))
        $sstr = '%s/rss/group/%s';
    else
        $sstr = '%s/rss.php?group=%s';
    return sprintf($sstr, config('site_url'), $this->get($this->tag));
}

// members() - returns an array of all group members (user object)
public function members()
{
    $DB = Database::getReader();

    $rel = new GroupUserRel;
    $q = sprintf(
        "SELECT r_user_id FROM %s WHERE r_group_id=%d",
        $rel->table_name(),
        $this->id()
    );
    $result = $DB->query($q);
    check_db($DB);
    $arr = array();
    while(list($id) = $result->fetch_array())
    {
        $u = new User($id);
        $arr[] = $u;
    }
    return $arr;
}

} // end class Group

?>
