<?php
// $Id: Page.class.inc,v 1.102 2006/05/03 01:31:48 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.

class Page extends DataObject
{
public $table = 'pages';
public $key = 'page_id';
public $owner = 'page_user_id';
public $obj_props = 'page_props';
public $created = 'page_created';
public $modified = 'page_modified';
public $fulltext = array('page_title','page_text');
public $sortfield = 'page_title';
public $tag = 'page_name';
public $metadata = array(
    'page_id' => array(
        'col' => TRUE,
        'type' => 'integer',
        'auto_increment' => TRUE,
        'required' => TRUE,
        'hidden' => TRUE,
        'noexport' => TRUE,
    ),
    'page_user_id' => array(
        'col' => TRUE,
        'type' => 'integer',
        'required' => TRUE,
        'internal' => TRUE,
        'index' => TRUE,
        'references' => 'User.user_id',
        'noexport' => TRUE,
    ),
    'page_folder_id' => array(
        'col' => TRUE,
        'type' => 'select',
        'options' => array(),
        'sqltype' => 'INTEGER',
        'required' => TRUE,
        'index' => TRUE,
        'advanced' => TRUE,
        'references' => 'Folder.folder_id',
        'noexport' => TRUE,
    ),
    'page_hidden' => array(
        'col' => TRUE,
        'type' => 'checkbox',
        'rval' => 1,
        'required' => TRUE,
        'index' => TRUE,
        'advanced' => TRUE,
    ),
    'page_created' => array(
        'col' => TRUE,
        'type' => 'datetime',
        'required' => TRUE,
        'internal' => TRUE,
        'noupdate' => TRUE,
        'index' => TRUE,
    ),
    'page_modified' => array(
        'col' => TRUE,
        'type' => 'datetime',
        'required' => TRUE,
        'internal' => TRUE,
    ),
    'page_class' => array(
        'col' => TRUE,
        'type' => 'text',
        'minlength' => 3,
        'maxlength' => 20,
        'internal' => TRUE,
        'index' => TRUE,
        'noupdate' => TRUE,
    ),
    'page_title' => array(
        'col' => TRUE,
        'type' => 'text',
        'size' => 50,
        'minlength' => 1,
        'maxlength' => 250,
        'required' => TRUE,
    ),
    'page_name' => array(
        'col' => TRUE,
        'type' => 'text',
        'size' => 30,
        'maxlength' => 50,
        'required' => TRUE,
        'unique' => TRUE,
        'internal' => TRUE,
        'noexport' => TRUE, // set on importing machine
    ),
    'page_text' => array(
        'col' => TRUE,
        'type' => 'textarea',
        'formatted' => TRUE,
        'required' => TRUE,
        'rows' => 15,
    ),
    'v_page_file' => array(
        'col' => FALSE,
        'type' => 'file',
        'virtual' => TRUE,
        'required' => FALSE,
        'multiple' => TRUE,
        'caption' => TRUE,
    ),
    'page_tags' => array(
        'col' => FALSE,
        'type' => 'text',
        'maxlength' => 250,
        'size' => 40,
        'virtual' => TRUE,
    ),
    'allow_comments' => array(
        'col' => FALSE,
        'type' => 'checkbox',
        'rval' => 1,
        'advanced' => TRUE,
    ),
    'allow_ratings' => array(
        'col' => FALSE,
        'type' => 'checkbox',
        'rval' => 1,
        'advanced' => TRUE,
    ),
    'alt_template' => array(
        'col' => FALSE,
        'type' => 'select',
        'options' => array( '' => 'Use default template'),
        'advanced' => TRUE,
    ),
    'associated_files' => array(
        'type' => 'filelist',
        'virtual' => TRUE,
        'internal' => TRUE,
    ),
);

public  $querystring='';            // this gets reset
public  $rawdata=array();           // cached data

// private data
private $titles = array();          // titles for file attachments
private $tags = "";                 // tags
private $import=FALSE;
private $files = array();           // file attachments

// constructor
public function __construct($id=0, $row=array())
{
    // assign some defaults from config
    $this->set('allow_comments', config('default_allow_comments',1));
    $this->set('allow_ratings', config('default_allow_ratings',1));
    // save the class
    $this->set('page_class', get_class($this));
    // build the query string
    if (is_numeric($id) && $id && ($this->querystring==''))
    {
        $f = new Folder;
        $u = new User;
        $this->querystring = sprintf(
            "SELECT * FROM %s page ".
            "LEFT JOIN %s user ON (page.page_user_id=user.user_id) ".
            "LEFT JOIN %s folder ON (page.page_folder_id=folder.folder_id) ".
            "WHERE page_id=%d",
            $this->table_name(),
            $u->table_name(),
            $f->table_name(),
            $id
        );
    }
    
    // call the constructor
    parent::__construct($id, $row);
    
    // derived options
    $this->metadata['page_folder_id']['advanced'] = 
        $this->metadata['page_folder_id']['value'] > 0;
    if ($this->id())
    {
        $this->metadata['page_tags']['value'] = 
            $this->get_tag_names();
        $this->metadata['associated_files']['value'] = 
            $this->get_associated_files();
    }
}

// form - get info
public function form($name, $action, $method, $submit="Save", $reset="Reset")
{
    $folders = $this->get_folder_list();
    if (!count($folders))
        $this->add_error(lang('err_nofolder'));
    $this->metadata['page_folder_id']['options'] = $folders;
    if (!count($this->metadata['page_folder_id']['options']))
        $this->add_error(lang('err_nofolder'));
    return parent::form($name, $action, $method, $submit, $reset);
}

// add() - save the page
public function add()
{
    // validate folder limit
    $f = new Folder($this->get('page_folder_id'));
    if ($f->get('folder_limit'))
    {
        $q = sprintf(
            'SELECT COUNT(*) FROM %s WHERE page_folder_id=%d',
            $this->table_name(),
            $this->get('page_folder_id'));
        $DB = Database::getReader();
        $r = $DB->query($q);
        check_db($DB);
        list($num) = $r->fetch_array();
        if ($num >= $f->get('folder_limit'))
            $this->add_error(lang('err_folder_limit'));
    }

    // create a unique name
    $this->set('page_name',
        $this->get_unique_name($this->get('page_title'), 'page_name'));

    parent::add();
    
    // if attached file(s), then update
    if (count($this->files))
        $this->update();
    
    // add tags
    make_page_tags($this->id(), $this->tags);
    
    // send subscription notifications
    $this->notify_subscribers();
}

// update() - modify to validate attachments
public function update()
{
    // add file attachments
    foreach($this->files as $f)
    {
        $f->set('file_page_id', $this->id());
        $f->add();
        if (!$f->is_valid())
            $this->add_error($f->get_errors());
    }
    $this->metadata['associated_files']['value'] = 
        $this->get_associated_files();
    
    // update base document
    parent::update();
    
    // add tags
    make_page_tags($this->id(), $this->tags);
    $this->metadata['page_tags']['value'] = $this->get_tag_names();
}

// delete() - remove foreign key references first
public function delete()
{
    global $AUDIT;
    
    // remove Trackbacks
    $this->delete_all('Trackback', 'tb_page_id', $this->id());
    
    // remove ratings
    $this->delete_all('Rating', 'rate_page_id', $this->id());
    
    // remove tags
    $this->delete_all('TagPageRel', 'page_id', $this->id());
    
    // remove related links
    $this->delete_all('LinkPageRel', 'page_id', $this->id());
    
    // delete comments
    $this->delete_all('Comment', 'comment_page_id', $this->id());
    
    // delete files
    $this->delete_all('File', 'file_page_id', $this->id());
    
    // delete us
    parent::delete();
}

// set_post(_POST) - set from _POST
public function set_post($_POST)
{
    // check to delete associated files
    if (is_array($_POST['del_file']))
        foreach($_POST['del_file'] as $fid)
        {
            $f = new File($fid);
            $f->delete();
            $this->metadata['associated_files']['value'] = 
                $this->get_associated_files();
            if (!$f->is_valid())
                $this->add_error($f->get_errors());
        }

    // check for appended tags
    if (isset($_POST['new_tags']))
        $this->set('page_tags', $this->get_tag_names().' '.$_POST['new_tags']);

    // otherwise, handle everything else normally
    parent::set_post($_POST);
}

// set() - check values
public function set($name, $value)
{
    global $_FILES;
    switch($name)
    {
    case 'v_page_file':
        if (is_array($_FILES[$name]['name']))
        {
            foreach($_FILES[$name]['name'] as $ix => $val)
            {
                $myfiles['name'] = $_FILES[$name]['name'][$ix];
                $myfiles['type'] = $_FILES[$name]['type'][$ix];
                $myfiles['size'] = $_FILES[$name]['size'][$ix];
                $myfiles['tmp_name'] = $_FILES[$name]['tmp_name'][$ix];
                $myfiles['error'] = $_FILES[$name]['error'][$ix];
                switch($myfiles['error'])
                {
                case 0:
                    $f = new File(0,0,$myfiles);
                    $f->set('file_user_id', $this->get('page_user_id'));
                    $f->set('file_original_name', $myfiles['name']);
                    $f->set('file_caption', $_POST[$name."_caption"][$ix]);
                    $this->files[] = $f;
                    break;
                case 4:
                    // this is ok, no file specified
                    break;
                default:
                    $this->add_error("File error %d", $myfiles['error']);
                }
            }
        }
        break;
        
    case 'page_folder_id':
        if (!$value)
            $this->add_error(lang('err_folder'));
        else
            parent::set($name, $value);
        break;
        
    case 'page_tags':
        $this->tags = $value;
        break;
        
    default:
        parent::set($name, $value);
    }
}

// get_title()
public function get_title()
{
    if ($this->get('page_id'))
        return $this->get('page_title');
    else
        return lang('page');
}

// get_url()
public function get_url()
{
    if (config('url_rewriting'))
        return sprintf('%s/p/%s',
                config('site_path'),
                $this->get('page_name'));
    else
        return sprintf('%s/page.php?tag=%s',
                config('site_path'),
                $this->get('page_name'));
}

// get_all() - add folder, user info
public function get_all()
{
    $arr = parent::get_all();
    
    // add some useful information
    $arr['page_length'] = strlen($arr['page_text']);

    // add folder info
    if (isset($this->rawdata['folder_id']))
        $f = new Folder(0, $this->rawdata);
    else
        $f = new Folder($this->get('page_folder_id'));
    $arr['folder'] = $f->get_all();

    // add tags
    $arr['tags'] = $this->get_tags();

    // associated files
    $arr['num_attachments'] = count($this->metadata['associated_files']['value']);
    $n = 0;
    if (is_array($arr['associated_files']))
        foreach($arr['associated_files'] as $file)
            if ($file['is_image'])
                $n++;
    $arr['num_images'] = $n;
    
    // can current user rate something?
    if (!$arr['allow_ratings'])
        $arr['allow_user_rating'] = FALSE;
    else if (!is_object($_SESSION['user']))
        $arr['allow_user_rating'] = FALSE;
    else if (!$_SESSION['user']->id())
        $arr['allow_user_rating'] = FALSE;
    else if ($_SESSION['user']->id() != $this->owner())
        $arr['allow_user_rating'] = TRUE;
    else if (config('allow_self_rating'))
        $arr['allow_user_rating'] = TRUE;
    else
        $arr['allow_user_rating'] = FALSE;

    return $arr;
}

// get_folder_list() - returns array of possible folders for the page
public function get_folder_list()
{
    // our return array
    $arr = array();

    // we need a folder object
    $f = new Folder;
    
    // we need an ACL object
    $acl = new ACL;

    // there are three sets of possible folders:
    // 1. those we own, and
    // 2. those that are public
    // 3. those whose access list we are in
    $q = sprintf("
        SELECT folder_id, folder_title, folder_public
        FROM %s
        WHERE folder_user_id=%d 
           OR folder_public>0
           OR folder_id IN
              (SELECT acl_folder_id FROM %s WHERE acl_user_id=%d)
        ORDER BY folder_public, folder_title",
        $f->table_name(),
        $this->get('page_user_id'),
        $acl->table_name(),
        $_SESSION['user']->id()
    );
    
    $DB = Database::getReader();
    $result = $DB->query($q);
    check_db($DB);

    while(list($id,$name,$pub) = $result->fetch_row())
    {
        $arr[$id] = ($pub ? '* ' : '') . $name;
    }

    // we're done
    return $arr;
}

// get_tag_names() - return a string of just the tag words
private function get_tag_names()
{
    return implode(' ', $this->get_tags(TRUE));
}

// get_associated_files()
// get all files linked with this page
private function get_associated_files()
{       
    // establish the return array
    $arr = array();

    // select the appropriate data
    $f = new File;
    $q = sprintf(
        "SELECT file_id FROM %s WHERE file_page_id=%d ORDER BY file_id",
        $f->table_name(), $this->id());
        
    // execute the query
    $myquery = new Query("File", $q);
        
    // fetch all the data
    while($file = $myquery->get_all())
        $arr[] = $file;

    return $arr;
}

// get_tags() - return all tags for the page
private function get_tags($nameonly=FALSE)
{
    $arr = array();
    $rel = new TagPageRel;
    $tag = new Tag;
    $q = sprintf(
        "SELECT %s.tag_id ".
        "FROM %s LEFT JOIN %s ON (%s.tag_id=%s.tag_id) ".
        "WHERE page_id=%d ORDER BY tag_name",
        $tag->table_name(),
        $rel->table_name(),
        $tag->table_name(),
        $rel->table_name(),
        $tag->table_name(),
        $this->id());
    $myquery = new Query('Tag', $q);
    while($item = $myquery->get_all())
    {
        if ($nameonly)
            $arr[] = $item['tag_name'];
        else
            $arr[] = $item;
    }
    return $arr;
}

// xml() - display page XML
public function xml()
{
    $metadata = $this->metadata;
    $metadata['tags'] = array(
        'type' => 'array',
        'item' => 'tag',
        'value' => $this->get_tags(TRUE)
    );
    return parent::xml($metadata);
}

// get_comments() - return all comments for the page
public function get_comments()
{
    return CommentList::comments($this->id());
}

// get threaded_comments - return all comments in threaded fashion
public function get_threaded_comments()
{
    return CommentList::threaded_comments($this->id());
}

// notify subscribers
private function notify_subscribers()
{
    global $PAGE;
    
    // create our mailing
    $em = new HtmlEmail(lang('subj_notify'));
    
    // build the subscriber list
    $sub = new Subscription;
    $q = sprintf(
        "SELECT sub_user_id FROM %s WHERE sub_folder_id=%d",
        $sub->table_name(),
        $this->get('page_folder_id'));
    $DB = Database::getReader();
    $result = $DB->query($q);
    check_db($DB);
    
    // fetch everything
    $count = 0;
    while(list($id) = $result->fetch_row())
    {
        $u = new User($id);
        $em->bcc($u->get('user_email'));
        $count++;
    }
    
    // send the message
    if ($count)
    {
        $PAGE->assign('page', $this->get_all());
        $em->send_template(site_template('notification'));
    }
}

// import_file(srcfile, filetype)
// loads an existing file
public function import_file($srcfile, $mimetype)
{
    $f = new File;
    $f->new_uploaded_file(
        array(
            'tmp_name' => $srcfile,
            'name' => basename($srcfile), 
            'size' => filesize($srcfile),
            'type' => $mimetype,
            'error' => 0
        ),
        TRUE
    );

    $f->set('file_user_id', $this->get('page_user_id'));
    $f->set('file_original_name', basename($srcfile));
    $f->set('file_caption', basename($srcfile));
    $this->files[] = $f;
}

} // end class Page

//=============================================================================

// make_page_tags(page_id, string)
// this function takes a space-separated list of tags; the tags are normalized
// and inserted one at a time to the database. Errors are ignored
function make_page_tags($page_id, $taglist)
{    
    // first, delete old tags
    $rel = new TagPageRel;
    $q = sprintf(
        "DELETE FROM %s WHERE page_id=%d",
        $rel->table_name(),
        $page_id);
 	$DB = Database::getWriter();
 	$DB->query($q);
    check_db($DB);
    
    // leave if no tags
    if (trim($taglist) == '')
        return;

    $tag_ids = array();
    
    // reformat things
    $taglist = strtolower($taglist);
    $taglist = preg_replace('/\s+/', ' ', $taglist);

    // make sure all the tags exist
    foreach(explode(' ', $taglist) as $tag)
    {
        $tag = preg_replace('/[^a-z0-9_\.-]+/', '',$tag);
        $t = new Tag();
        $t->set('tag_name', trim($tag));
        $t->add();
        if ($t->is_valid())
            $tag_ids[] = $t->id();
        else // look up the ID
        {
            $q = sprintf(
                "SELECT tag_id FROM %s WHERE tag_name='%s'",
                $t->table_name(),
                $t->get('tag_name'));
            $DBR = Database::getReader();
            $result = $DBR->query($q);
            check_db($DBR);
            list($id) = $result->fetch_row();
            $tag_ids[] = $id;
        }
    }

    // add the relationships
    foreach($tag_ids as $id)
    {
        $rel = new TagPageRel;
        $rel->set('tag_id', $id);
        $rel->set('page_id', $page_id);
        $rel->add();
    }
    
    $DB->commit();  // in case some other transaction's open
}

?>
