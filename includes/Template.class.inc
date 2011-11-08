<?php
// $Id: Template.class.inc,v 1.23 2005/12/01 23:04:08 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.

class Template extends DataObject
{
public $table = 'templates';
public $key = 'tpl_id';
public $owner = 'tpl_user_id';
public $created = 'tpl_created';
public $modified = 'tpl_modified';
public $obj_props = 'tpl_properties';
public $sortfield = 'tpl_name';
public $tag = 'tpl_name';
public $metadata = array(
    'tpl_id' => array(
        'col' => TRUE,
        'type' => 'integer',
        'required' => TRUE,
        'hidden' => TRUE,
        'auto_increment' => TRUE,
    ),
    'tpl_user_id' => array(
        'col' => TRUE,
        'type' => 'integer',
        'required' => TRUE,
        'hidden' => TRUE,
        'index' => TRUE,
        'references' => 'User.user_id',
    ),
    'tpl_public' => array(
        'col' => TRUE,
        'type' => 'checkbox',
        'rval' => 1,
        'required' => TRUE,
        'advanced' => TRUE,
        'index' => TRUE,
    ),
    'tpl_created' => array(
        'col' => TRUE,
        'type' => 'datetime',
        'require' => TRUE,
        'internal' => TRUE,
        'noupdate' => TRUE,
        'index' => TRUE,
    ),
    'tpl_modified' => array(
        'col' => TRUE,
        'type' => 'datetime',
        'require' => TRUE,
        'internal' => TRUE,
        'index' => TRUE,
    ),
    'tpl_class' => array(
        'col' => TRUE,
        'type' => 'select',
        'options' => array(
            'Folder' => 'Folder',
            'Page' => 'Page',
            'File' => 'File',
            'User' => 'User',
            'Group' => 'Group',
        ),
        'sqltype' => 'VARCHAR(15)',
        'index' => TRUE,
        'required' => TRUE,
    ),
    'tpl_name' => array(
        'col' => TRUE,
        'type' => 'text',
        'size' => 30,
        'maxlength' => 250,
        'unique' => TRUE,
        'pattern' => '/^[A-Za-z][A-Za-z0-9_\.]+$/',
        'required' => TRUE,
    ),
    'tpl_descr' => array(
        'col' => FALSE,
        'type' => 'textarea',
        'rows' => 4,
    ),
    'tpl_text' => array(
        'col' => FALSE,
        'type' => 'textarea',
        'formatted' => FALSE,
        'rows' => 30,
        'required' => TRUE,
    ),
);

// create an HTML form
public function form($fname='tpl_form', 
    $action, $method, $submit="Save Template", $reset="Reset")
{
    foreach($this->metadata['tpl_class']['options'] as $name => $prompt)
        $this->metadata['tpl_class']['options'][$name] = lang("class_$name");
    return parent::form($fname, $action, $method, $submit, $reset);
}

// set a value
public function set($name, $value)
{
    switch($name)
    {
    case 'tpl_text':
        // don't strip HTML tags on templates
        $this->metadata[$name]['formatted'] = TRUE;
        parent::set($name, $value);
        $this->metadata[$name]['formatted'] = FALSE;
        break;
    default:
        parent::set($name, $value);
    }
}

// make up a title
public function get_title()
{
    return $this->get('tpl_name');
}

// return URL
public function get_url()
{
    return sprintf("%s/templates.php", config('site_path'));
}

} // end class Template

?>