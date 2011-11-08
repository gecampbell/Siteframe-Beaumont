<?php
// $Id: RSSfeed.class.inc,v 1.12 2006/05/03 01:31:48 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.

class RSSfeed extends DataObject
{
public $table = 'rss';
public $key = 'rss_id';
public $owner = 'rss_user_id';
public $obj_props = 'rss_props';
public $created = 'rss_created';
public $modified = 'rss_modified';
public $fulltext = array('rss_url','rss_text');
public $metadata = array(
    'rss_id' => array(
        'col' => TRUE,
        'type' => 'integer',
        'internal' => TRUE,
        'auto_increment' => TRUE,
    ),
    'rss_user_id' => array(
        'col' => TRUE,
        'type' => 'integer',
        'required' => TRUE,
        'index' => TRUE,
        'references' => 'User.user_id',
        'internal' => TRUE,
    ),
    'rss_ttl' => array(
        'col' => TRUE,
        'type' => 'number',
        'required' => TRUE,
        'index' => FALSE,
        'value' => 60, // default 60 min; can be overridden by feed
        'internal' => TRUE,
    ),
    'rss_created' => array(
        'col' => TRUE,
        'type' => 'datetime',
        'required' => TRUE,
        'internal' => TRUE,
        'noupdate' => TRUE,
        'index' => TRUE,
    ),
    'rss_modified' => array(
        'col' => TRUE,
        'type' => 'datetime',
        'required' => TRUE,
        'internal' => TRUE,
    ),
    'rss_url' => array(
        'col' => TRUE,
        'type' => 'text',
        'size' => 40,
        'maxlength' => 250,
        'minlength' => 1,
        'required' => TRUE,
        'value' => 'http://',
        'unique' => TRUE,
    ),
    'rss_version' => array(
        'col' => FALSE,
        'type' => 'text',
        'maxlength' => 10,
        'internal' => TRUE,
    ),
    'rss_title' => array(
        'col' => FALSE,
        'type' => 'text',
        'maxlength' => 250,
        'required' => FALSE,
        'internal' => TRUE,
    ),
    'rss_copyright' => array(
        'col' => FALSE,
        'type' => 'text',
        'maxlength' => 250,
        'required' => FALSE,
        'internal' => TRUE,
    ),
    'rss_link' => array(
        'col' => FALSE,
        'type' => 'text',
        'maxlength' => 250,
        'required' => FALSE,
        'internal' => TRUE,
    ),
    'rss_description' => array(
        'col' => FALSE,
        'type' => 'text',
        'maxlength' => 250,
        'required' => FALSE,
        'internal' => TRUE,
    ),
    'rss_language' => array(
        'col' => FALSE,
        'type' => 'text',
        'maxlength' => 250,
        'required' => FALSE,
        'internal' => TRUE,
    ),
    'rss_webmaster' => array(
        'col' => FALSE,
        'type' => 'text',
        'maxlength' => 250,
        'required' => FALSE,
        'internal' => TRUE,
    ),
    'rss_generator' => array(
        'col' => FALSE,
        'type' => 'text',
        'maxlength' => 250,
        'required' => FALSE,
        'internal' => TRUE,
    ),
    'rss_lastbuilddate' => array(
        'col' => FALSE,
        'type' => 'datetime',
        'required' => FALSE,
        'internal' => TRUE,
    ),
    'rss_image' => array(
        'col' => FALSE,
        'type' => 'text',
        'maxlength' => 250,
        'required' => FALSE,
        'internal' => TRUE,
    ),
    'rss_text' => array(        // the RAW XML
        'col' => TRUE,
        'type' => 'textarea',
        'internal' => TRUE,
    ),
    'rss_array' => array(       // the parsed result array
        'col' => TRUE,
        'type' => 'textarea',
        'internal' => TRUE,
    ),
);

public function __construct($id=0, $arr=array())
{
    $DB = Database::getReader();

    if ((!is_numeric($id)) && ($id != ''))
    {
        $q = sprintf("SELECT %s FROM %s WHERE rss_url='%s'",
            $this->key, $this->table_name(), addslashes($id));
        $r = $DB->query($q);
        check_db($DB);
        // if nothing's there, then create it
        if ($r->num_rows == 0)
        {
            parent::__construct();
            $this->set('rss_url', $id);
            $this->add();
        }
        else
            parent::__construct($id);
    }
    else
        parent::__construct($id, $arr);
    
    // update if necessary
    if ($this->id() && (($this->get('rss_modified') == '') ||
        (time() > 
         (strtotime($this->get('rss_modified'))+(60*$this->get('rss_ttl'))))))
    {
        $this->fetch_raw_feed();
        $this->parse_raw_feed();
        $this->update();
        $this->set('rss_modified', strftime('%Y-%m-%d %H:%M:%S'));
    }
}

public function add()
{
    $this->fetch_raw_feed();
    $this->parse_raw_feed();
    parent::add();
}

// set - allow raw text
public function set($name, $value)
{
    switch($name)
    {
    case 'rss_ttl':
        if (!$value)
            $value = 60;
        parent::set($name, $value);
        break;
    case 'rss_text':
    case 'rss_array':
        $this->metadata[$name]['value'] = $value;
        break;
    default:
        parent::set($name, $value);
    }
}

// get_all() - return all properties
public function get_all()
{
    $arr = parent::get_all();
    $arr['items'] = unserialize($this->get('rss_array'));
    return $arr;
}

// fetch_raw_feed - get the raw XML feed
private function fetch_raw_feed()
{
    global $AUDIT;

    // log message
    $AUDIT->message('Fetching RSS feed %s', $this->get('rss_url'));
    
    // open the remote file, check for errors
    $fp = @fopen($this->get('rss_url'), 'r');
    if (!$fp)
    {
        $this->add_error(lang('err_rss_open'), $this->get('rss_url'));
        return;
    }
    
    // contents holds the result of the read
    $contents = '';
    
    // read all the data
    while (!feof($fp))
    {
        $contents .= fread($fp, 8192);
    }
    
    // and store it in rss_text
    $this->set('rss_text', $contents);
}

// parse_raw_feed - create an array structure from the feed
private function parse_raw_feed()
{
    global $AUDIT;

    // log message
    $AUDIT->message('Parsing RSS feed %s', $this->get('rss_url'));
    
    if (($xml = simplexml_load_string($this->get('rss_text'))) === FALSE)
    {
        $this->add_error(lang('err_rss_parse'));
        return;
    }
    $this->set('rss_version',       (float) $xml['version']);
    $this->set('rss_title',         (string) $xml->channel->title);
    $this->set('rss_copyright',     (string) $xml->channel->copyright);
    $this->set('rss_link',          (string) $xml->channel->link);
    $this->set('rss_modified',      strtotime((string) $xml->channel->lastBuildDate));
    $this->set('rss_description',   (string) $xml->channel->description);
    $this->set('rss_language',      (string) $xml->channel->language);
    $this->set('rss_ttl',           (string) $xml->channel->ttl);
    $this->set('rss_webmaster',     (string) $xml->channel->webMaster);
    $this->set('rss_generator',     (string) $xml->channel->generator);
    $this->set('rss_image',         (string) $xml->channel->image);
    foreach($xml->channel->item as $item)
    {
        $items[] = array(
            'title'         => (string) $item->title,
            'description'   => (string) $item->description,
            'guid'          => (string) $item->guid,
            'link'          => (string) $item->link,
            'category'      => is_array($item->category) ?
                               implode(', ', $item->category) :
                               (string) $item->category,
            'image'         => (string) $item->image,
            'pubdate'       => strftime('%Y-%m-%d %H:%I:%S',
                                ((string) $item->pubDate == '') ?
                                time() : 
                                strtotime((string) $item->pubDate)),
        );
    }
    $this->set('rss_array', serialize($items));
}

// get_title()
public function get_title()
{
    return $this->get('rss_title');
}

} // end class RSSfeed

?>
