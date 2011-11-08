<?php
// $Id: Tag.class.inc,v 1.13 2005/12/11 00:12:45 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.

class Tag extends DataObject
{
public $table = 'tags';
public $key = 'tag_id';
public $created = 'tag_created';
public $fulltext = array('tag_name');
public $sortfield = 'tag_name';
public $tag = 'tag_name';
public $metadata = array(
        'tag_id' => array(
            'col' => true,
            'type' => 'integer',
            'auto_increment' => true,
            'required' => true,
            'hidden' => true,
        ),
        'tag_created' => array(
            'col' => true,
            'type' => 'datetime',
            'required' => true,
            'internal' => true,
            'noupdate' => true,
            'index' => true,
        ),
        'tag_name' => array(
            'col' => true,
            'type' => 'text',
            'size' => 20,
            'maxlength' => 50,
            'minlength' => 3,
            'required' => true,
            'unique' => true,
        ),
);
public $rawdata=array();

// optimized caching constructor
public function __construct($id=0, $row=array())
{
    global $__TAGCACHE;
    if ($id && isset($__TAGCACHE[$id]))
        parent::__construct(0, $__TAGCACHE[$id]);
    else
    {
        parent::__construct($id, $row);
        if ($this->id() && count($this->rawdata))
            $__TAGCACHE[$this->id()] = $this->rawdata;
    }
}

// get_url() - return url
public function get_url()
{
    if (config('url_rewriting'))
        return sprintf("%s/tag/%s", 
                config('site_path'), $this->get('tag_name'));
    else
        return sprintf("%s/tag.php?tag=%s", 
                config('site_path'), $this->get('tag_name'));
}

// get_rss_url()
public function get_rss_url()
{
    if (config('url_rewriting'))
        $sstr = '%s/rss/tag/%s';
    else
        $sstr = '%s/rss.php?tag=%s';
    return sprintf($sstr, config('site_url'), $this->get($this->tag));
}

// get_title() - return a title
public function get_title()
{
    return sprintf(lang('title_tag'), $this->get('tag_name'));
}

} // end class Tag

?>