<?php
// $Id: File.class.inc,v 1.37 2006/05/03 01:31:48 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.

class File extends DataObject
{
public $table = 'files';
public $key = 'file_id';
public $owner = 'file_user_id';
public $obj_props = 'file_props';
public $created = 'file_created';
public $modified = 'file_modified';
public $fulltext = array('file_path');
public $metadata = array(
    'file_id' => array(
        'col' => TRUE,
        'type' => 'integer',
        'auto_increment' => TRUE,
        'required' => TRUE,
        'hidden' => TRUE,
    ),
    'file_user_id' => array(
        'col' => TRUE,
        'type' => 'integer',
        'required' => TRUE,
        'internal' => TRUE,
        'index' => TRUE,
        'references' => 'User.user_id',
    ),
    'file_page_id' => array(
        'col' => TRUE,
        'type' => 'integer',
        'required' => TRUE,
        'internal' => TRUE,
        'index' => TRUE,
        'references' => 'Page.page_id',
    ),
    'file_size' => array(
        'col' => TRUE,
        'type' => 'integer',
        'internal' => TRUE,
    ),
    'file_created' => array(
        'col' => TRUE,
        'type' => 'datetime',
        'required' => TRUE,
        'internal' => TRUE,
        'noupdate' => TRUE,
        'index' => TRUE,
    ),
    'file_modified' => array(
        'col' => TRUE,
        'type' => 'datetime',
        'required' => TRUE,
        'internal' => TRUE,
    ),
    'file_mime_type' => array(
        'col' => TRUE,
        'type' => 'text',
        'maxlength' => 30,
        'minlength' => 1,
        'required' => TRUE,
        'index' => TRUE,
        'internal' => TRUE
    ),
    'file_mime_subtype' => array(
        'col' => TRUE,
        'type' => 'text',
        'maxlength' => 50,
        'minlength' => 1,
        'required' => TRUE,
        'index' => TRUE,
        'internal' => TRUE
    ),
    'file_path' => array(
        'col' => TRUE,
        'type' => 'file',
        'sqltype' => 'VARCHAR(250)',
        'required' => TRUE,
        'unique' => TRUE,
        'internal' => TRUE,
    ),
    'file_original_name' => array(
        'col' => FALSE,
        'type' => 'text',
        'maxlength' => 250,
        'internal' => TRUE,
    ),
    'file_caption' => array(
        'col' => FALSE,
        'type' => 'textarea',
        'formatted' => FALSE,
    ),
    'alt_template' => array(
        'col' => FALSE,
        'type' => 'select',
        'options' => array( '' => 'Use default template'),
        'advanced' => TRUE,
    ),
);
public  $querystring='';
public  $rawdata=array();
public  $import=FALSE;
private $uploaded_file=FALSE;

// constructor
// if the $_FILES parameter is supplied, the the File object is created
// from the specified struct (see www.php.net for documentation).
public function __construct($id=0, $row=array(), $fileinfo=FALSE)
{
    // if the $fileinfo is specified, save it
    if (is_array($fileinfo))
    {
        $this->uploaded_file = $fileinfo;
        $this->set_mime_type($fileinfo['type']);
    }
    // invoke the parent constructor
    parent::__construct($id, $row);
}

// after the add, move the uploaded file
public function add()
{
    $DB = Database::getWriter();

    // turn OFF autocommit
    $DB->autocommit(FALSE);

    // add the record
    parent::add();

    // check for errors
    if (!$this->is_valid())
    {
        $DB->rollback();
        return;
    }

    // update with the new info
    if (is_array($this->uploaded_file))
        $this->update();

    if ($this->is_valid())
        $DB->commit();
    else
        $DB->rollback();
    
    // restore autocommit
    $DB->autocommit(TRUE);
}

// update - and save file
public function update()
{
    // if necessary, move the uploaded file
    if ($this->uploaded_file)
        $this->new_uploaded_file($this->uploaded_file);

    // exit if we're still not valid
    if (!$this->is_valid())
        return;

    // finally, perform the update
    parent::update();
    
    // reset the noupdate flag
    $this->metadata['file_path']['noupdate'] = FALSE;
}

// delete() must also remove the files
public function delete()
{
    // determine the path of the file
    $path = dirname($this->get('file_path'));

    // delete the database entry
    parent::delete();

    // if ok, then delete all the file(s)
    // (remember, there may be multiple resized versions there)
    if ($this->is_valid())
    {
        foreach(glob($path.'/*') as $name)
            @unlink($name);
        @rmdir($path);
    }
}

// handle uploaded files
public function set($name, $value, $fileinfo=array())
{
    global $_FILES; // holds uploaded file information
    
    switch($name)
    {
    case 'file_path':
        if ($this->id() && ($value == ''))
            $this->metadata[$name]['noupdate'] = TRUE;
        else if (count($fileinfo))
            $this->check_upload($name, $fileinfo);
        else
            parent::set($name, $value);
        break;
    default:
        parent::set($name, $value);
    }
}

// get all properties
public function get_all()
{
    $arr = parent::get_all();
    $arr['is_image'] = ($this->get('file_mime_type') == 'image');
    $arr['file_type'] =
        $this->get('file_mime_type') . '/' .
        $this->get('file_mime_subtype');
    return $arr;
}

// new_uploaded_file(filestruct)
// this moves an uploaded file (represented by the PHP $_FILES filestruct)
// to create this file
public function new_uploaded_file($filestruct, $use_copy=FALSE)
{
    // save uploaded file
    if ($filestruct['name'] != '')
    {
        // delete any existing file
        @unlink($this->get('file_path'));
        
        // validate new filename
        $newname = basename($filestruct['name']);
        $newname = preg_replace('/[^A-Za-z0-9\.\_\-]+/', '_', $newname);
        $newname = strtolower($newname);

        // create the new filename
        $newfile = sprintf(
            '%s/%d/%d/%s',
            config('dir_files'),
            $this->get('file_user_id'),
            $this->get('file_id'),
            $newname
        );
        
        // set the MIME type
        $this->set_mime_type($filestruct['type']);

        // save the path
        $this->metadata['file_path']['value'] = $newfile;
        
        // save the size
        $this->set('file_size', $filestruct['size']);

        // make the target directory
        @mkdir(dirname($newfile), DEFAULT_FILE_PERMS, TRUE);

        if ($use_copy)
            $cpfcn = 'copy';
        else
            $cpfcn = 'move_uploaded_file';
        if (!$cpfcn($filestruct['tmp_name'], $newfile))
            $this->add_error(lang('err_upload_problem'), $newfile);

        // get some image information
        if ($this->get('file_mime_type') == 'image') {
            $info = getimagesize($newfile);
            $this->set('image_x', $info[0]);
            $this->set('image_y', $info[1]);
            // exif information
            if (function_exists('exif_read_data'))
            {
                if ($ex = exif_read_data($newfile))
                    foreach($ex as $item => $data)
                        if (!is_array($data))
                            $this->set("exif_$item", $data);
            }
        }
    }
    
}

// set the MIME type
private function set_mime_type($type)
{
    list($type,$subtype) = explode('/', $type);
    $this->set('file_mime_type', $type);
    $this->set('file_mime_subtype', $subtype);
}

// check_upload() - upload a file
private function check_upload($name, $file)
{
    // check for file upload errors
    switch($file['error'])
    {
    case 0:
        // ok
        break;
    case 1:
        $this->add_error(lang('err_upload_ini_max'), $file['name']);
        break;
    case 2:
        $this->add_error(lang('err_upload_max'), $file['name']);
        break;
    case 3:
        $this->add_error(lang('err_upload_partial'), $file['name']);
        break;
    case 4:
        if ($this->id())    // if the file exists, this is ok
            return;
        $this->add_error(lang('err_upload_nofile'), $file['name']);
        break;
    case 6:
        $this->add_error(lang('err_upload_notemp'), $file['name']);
        break;
    default:
        return;
    }
    
    // check for illegal file extensions
    $badext = explode(' ', config('bad_file_extensions'));
    $name = strtolower($file['name']);
    foreach($badext as $ext)
    {
        $pattern = sprintf('/%s$/', $ext);
        if (preg_match($pattern, $name))
            $this->add_error(lang('err_badext'), $file['name']);
    }

    // return if there are problems
    if (!$this->is_valid())
        return;

    // set values for later processing (after add())
    parent::set('file_type', $file['type']);
    parent::set('file_size', $file['size']);
    parent::set('file_original_name', $file['name']);
    $this->uploaded_file = $file;
}

// get_title()
public function get_title()
{
    return $this->get('file_original_name');
}

} // end class File

?>