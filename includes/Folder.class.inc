<?php
// $Id: Folder.class.inc,v 1.50 2006/05/03 01:31:48 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.

class Folder extends DataObject
{
public $table = 'folders';
public $key = 'folder_id';
public $owner = 'folder_user_id';
public $obj_props = 'folder_props';
public $created = 'folder_created';
public $modified = 'folder_modified';
public $fulltext = array('folder_title','folder_text');
public $sortfield = 'folder_title';
public $tag = 'folder_name';
public $metadata = array(
    'folder_id' => array(
        'col' => TRUE,
        'type' => 'integer',
        'auto_increment' => TRUE,
        'required' => TRUE,
        'hidden' => TRUE,
    ),
    'folder_user_id' => array(
        'col' => TRUE,
        'type' => 'integer',
        'required' => TRUE,
        'internal' => TRUE,
        'index' => TRUE,
        'references' => 'User.user_id',
    ),
    // provided for future compatibility (hierarchical folders)
    'folder_parent_id' => array(
        'col' => TRUE,
        'type' => 'select',
        'sqltype' => 'INTEGER',
        'options' => array(),
        'internal' => TRUE,
        'index' => TRUE,
    ),
    // another field for future compatibility
    'folder_allow_subfolders' => array(
        'col' => TRUE,
        'type' => 'checkbox',
        'rval' => 1,
        'internal' => TRUE,
        'index' => TRUE,
        'advanced' => TRUE,
    ),
    'folder_public' => array(
        'col' => TRUE,
        'type' => 'checkbox',
        'rval' => 1,
        'index' => TRUE,
        'advanced' => TRUE,
    ),
    'folder_acl' => array(
        'virtual' => TRUE,
        'type' => 'textarea',
        'rows' => 2,
        'advanced' => TRUE,
    ),
    'folder_limit' => array(
        'col' => TRUE,
        'type' => 'number',
        'size' => 4,
        'pattern' => '/^-?[0-9]*$/',
        'advanced' => TRUE,
        'value' => 0,
    ),
    'folder_created' => array(
        'col' => TRUE,
        'type' => 'datetime',
        'required' => TRUE,
        'internal' => TRUE,
        'noupdate' => TRUE,
        'index' => TRUE,
    ),
    'folder_modified' => array(
        'col' => TRUE,
        'type' => 'datetime',
        'required' => TRUE,
        'internal' => TRUE,
    ),
    'folder_title' => array(
        'col' => TRUE,
        'type' => 'text',
        'size' => 50,
        'maxlength' => 250,
        'minlength' => 3,
        'required' => TRUE,
    ),
    'folder_orderby' => array(
        'col' => TRUE,
        'type' => 'select',
        'sqltype' => 'VARCHAR(50)',
        'options' => array(),
        'maxlength' => 50,
        'required' => TRUE,
    ),
    'folder_name' => array(
        'col' => TRUE,
        'type' => 'text',
        'maxlength' => 50,
        'unique' => TRUE,
        'required' => TRUE,
        'internal' => TRUE,
    ),
    'folder_text' => array(
        'col' => TRUE,
        'type' => 'textarea',
        'formatted' => TRUE,
        'rows' => 6,
    ),
    'recent_items' => array(
        'col' => FALSE,
        'type' => 'number',
        'size' => 2,
        'maxlength' => 2,
        'advanced' => TRUE,
        'value' => 20,
    ),
    'folder_rss_enable' => array(
        'col' => FALSE,
        'type' => 'checkbox',
        'rval' => 1,
        'advanced' => TRUE,
        'value' => TRUE,
    ),
    'folder_theme' => array(
        'col' => FALSE,
        'type' => 'select',
        'options' => array(), // set in constructor
        'required' => TRUE,
        'advanced' => TRUE,
    ),
    'alt_template' => array(
        'col' => FALSE,
        'type' => 'select',
        'options' => array( '' => 'Use default template'),
        'advanced' => TRUE,
    ),
);
public $querystring='';
public $rawdata=array();
private $acl_string='';

// constructor
public function __construct($id=0, $row=array())
{
    // subfolders?
    $this->metadata['folder_parent_id']['internal'] = !config('use_subfolders');
    $this->metadata['folder_allow_subfolders']['internal'] = !config('use_subfolders');
        
    // defaults
    $this->set('folder_public', config('default_folder_public'));
    $this->metadata['folder_theme']['value'] = 
        config('default_site_templates');
    
    // optimize the query string
    if (is_numeric($id) && $id)
    {
        $u = new User;
        $this->querystring = sprintf(
            "SELECT * FROM %s folder ".
            "LEFT JOIN %s user ON (folder.folder_user_id=user.user_id) ".
            "WHERE folder_id=%d",
            $this->table_name(),
            $u->table_name(),
            $id
        );
    }
  
    // construct it
    parent::__construct($id, $row);
    
    // set some defaults
    if ($this->get('folder_orderby') == '')
        $this->set('folder_orderby', 'page_created DESC');
}

// set - check for virtual values
public function set($name, $value)
{
    switch($name)
    {
    case 'folder_parent_id':
        if (config('use_subfolders') && config('top_folder_admin_only') && ($value==0))
        {
            if (is_object($_SESSION['user']) && $_SESSION['user']->get('user_admin'))
                parent::set($name, $value);
            else
                $this->add_error(lang('err_top_folder_admin'));
        }
        else
            parent::set($name, $value);
        break;
    case 'folder_acl':
        $this->acl_string = trim($value);
        break;
    default:
        parent::set($name, $value);
    }
}

// form() - build list for hierarchical folders
public function form($name, $action, $method, $submit="Submit", $reset="Reset")
{
    // build list for orderby
    $this->metadata['folder_orderby']['options'] = array(
        'page_created DESC' => lang('prompt_folder_sort_date_desc'),
        'page_created' => lang('prompt_folder_sort_date'),
        'page_title' => lang('prompt_folder_sort_title')
    );
            
    // build list for themes
    if (config('allow_folder_theme', TRUE))
    {
        $this->metadata['folder_theme']['options'] = $this->get_themes();
        $this->metadata['folder_theme']['help'] =
            lang('help_folder_theme').' '.
            sprintf('<a href="#" '.
                    'onClick="window.open(\'%s/themes.php\',\'preview\');">%s</a>',
                config('site_path'),
                lang('help_folder_theme_preview'));
    }
    else
        $this->metadata['folder_theme']['disabled'] = TRUE;

    // build list for hierarchical folders
    $this->metadata['folder_parent_id']['options'] = $this->get_parent_folders();
    
    // get the access control list
    $this->metadata['folder_acl']['value'] = $this->get_acl();
    
    // build the form
    return parent::form($name, $action, $method, $submit, $reset);
}

// add() - save the folder
public function add()
{
    $this->set('folder_name',
        $this->get_unique_name($this->get('folder_title'), 'folder_name'));
    $ret = parent::add();
    $this->set_acl($this->acl_string);
    return $ret;
}

// update() - modify
public function update()
{
    $ret = parent::update();
    $this->set_acl($this->acl_string);
    return $ret;
}

// delete() - delete child things
public function delete()
{
    // delete files
    $this->delete_all('Folder', 'folder_parent_id', $this->id());

    // delete pages
    $this->delete_all('Page', 'page_folder_id', $this->id());

    // delete this stuff
    parent::delete();
}

// get_title()
public function get_title()
{
    if ($this->get('folder_id'))
        return $this->get('folder_title');
    else
        return lang('folder');
}

// get_url()
public function get_url()
{
    if (config('url_rewriting'))
        return sprintf('%s/%s', config('site_path'), $this->get('folder_name'));
    else
        return sprintf('%s/folder.php?tag=%s',
                config('site_path'),
                $this->get('folder_name'));
}

// get_rss_url()
public function get_rss_url()
{
    if (config('url_rewriting'))
        $sstr = '%s/rss/%s';
    else
        $sstr = '%s/rss.php?folder=%s';
    return sprintf($sstr, config('site_url'), $this->get('folder_name'));
}

// get_themes() - return list of template sets
public function get_themes()
{
    $arr = array();
    foreach(glob(config('dir_templates').'/*/template.ini') as $filename)
    {
        $temp = parse_ini_file($filename);
        $val = str_replace('/template.ini', '', $filename);
        $val = str_replace(config('dir_templates').'/', '', $val);
        $arr['value'][$val] = $temp['title'];
    }
    return $arr;
}

// get_parent_folders() - returns a select-formatted array of possible
// parent folders
private function get_parent_folders()
{
    $DB = Database::getReader();
    
    // establish return array
    $arr = array();
    $arr[0] = lang('folder_no_parent');
    
    // build the query
    $q = sprintf(
        "SELECT folder_id, folder_public, folder_title ".
        "FROM %s ".
        "WHERE folder_id != %d AND ".
        " (((folder_user_id=%d) AND (folder_allow_subfolders>0)) OR ".
        " ((folder_public>0) AND (folder_allow_subfolders>0))) ".
        "ORDER BY folder_public, folder_title",
        $this->table_name(),
        $this->id(),
        $this->owner()
    );
    $result = $DB->query($q);
    check_db($DB);
    
    // fetch the rows
    while(list($id,$pub,$title) = $result->fetch_row())
    {
        if ($pub)
            $arr[$id] = sprintf("%s%s%s",
                        config('folder_public_prefix', '*'),
                        $title,
                        config('folder_public_suffix', ''));
        else
            $arr[$id] = $title;
    }
    return $arr;
}

// get_acl() - builds the access control list for the folder
private function get_acl()
{
    // build the return array
    $arr = array();
    
    // fetch rows from the ACL table
    $acl = new ACL;
    $u = new User;
    $q = sprintf("
        SELECT acl_user_id 
        FROM %s JOIN %s ON (acl_user_id=user_id)
        WHERE acl_folder_id=%d
        ORDER BY user_name",
        $acl->table_name(),
        $u->table_name(),
        $this->id());
    $query = new Query('User', $q);
    while($u = $query->get_all())
    {
        $arr[] = $u['user_name'];
    }
    return implode(' ', $arr);
}

// set_acl() - constructs the ACL table
private function set_acl($list)
{
    $DB = Database::getWriter();

    $names = explode(' ', $list);
    
    // delete existing
    $acl = new ACL;
    $q = sprintf("
        DELETE FROM %s WHERE acl_folder_id=%d",
        $acl->table_name(),
        $this->id());
    $DB->query($q);
    check_db($DB);
    
    // return if empty
    if (trim($list) == '') return;
    
    // now, construct the new one
    $u = new User;
    foreach($names as $username)
    {
        $q = sprintf("
            SELECT user_id
            FROM %s
            WHERE user_name='%s'",
            $u->table_name(),
            addslashes($username));
        $DBR = Database::getReader();
        $result = $DBR->query($q);
        check_db($DBR);
        list($uid) = $result->fetch_array();
        if ($uid)
        {
            $acl = new ACL;
            $acl->set('acl_folder_id', $this->id());
            $acl->set('acl_user_id', $uid);
            $acl->add();
            $this->add_error($acl->get_errors());
        }
        else
            $this->add_error(lang('err_nousername'), $username);
    }
}

// create_indexes - create indices
public function create_indexes()
{
    $arr[] = sprintf(
        "CREATE UNIQUE INDEX %s_title_ndx ON %s (folder_parent_id, folder_title)",
        $this->table_name(),
        $this->table_name());
    return $arr;
}

// get_folder_pages()
// returns an array of Page ID's for this folder
public function get_folder_pages()
{
    $DB = Database::getReader();

    $arr = array();
    $p = new Page;
    $q = sprintf(
        "SELECT page_id FROM %s WHERE %s=%d ORDER BY %s",
        $p->table_name(),
        $this->key,
        $this->id(),
        $this->get('folder_orderby'));
    $result = $DB->query($q);
    check_db($DB);
    while(list($fid) = $result->fetch_array())
        $arr[] = $fid;
    return $arr;
}

} // end class Folder

?>
