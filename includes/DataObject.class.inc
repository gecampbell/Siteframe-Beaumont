<?php
// $Id: DataObject.class.inc,v 1.145 2006/05/03 01:31:48 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.
//
// The DataObject abstracts the database layer; any objects that are
// stored in tables in the database use this layer.

abstract class DataObject extends Siteframe
{
public  $table;             // table name
public  $key;               // name of primary key (integer)
public  $owner;             // name of owner field
public  $obj_props;         // object properties (not in column)
public  $metadata;          // holds information on all columns
public  $engine="InnoDB";   // database engine
public  $charset="utf8";    // default character set
public  $fulltext=array();  // columns to include in fulltext index
public  $querystring='';    // alternate query string
public  $rawdata=array();   // raw data storage

// create a new DataObject
public function __construct($id=0, $row=array())
{
    // set version number
    $this->set('__version__', SITEFRAME_VERSION);
    $this->metadata['__version__']['internal'] = TRUE;
    
    // set owner
    if ((get_class($this)!='User') && is_object($_SESSION['user']) && ($this->owner!=''))
        $this->metadata[$this->owner]['value'] = $_SESSION['user']->id();

    // retrieve plugin properties
    foreach(Plugin::get_properties(get_class($this)) as $name => $info)
        $this->metadata[$name] = $info;

    // do plugin "new" event
    Plugin::do_events($this, 'new');

    // retrieve object from database if id= is specified
    $arr = array();
    if ($id || $row[$this->key])
    {
        if ($id)
        {
            if ($this->querystring != '')
                $q = $this->querystring;
            else if (isset($this->tag) && (!is_numeric($id)))
            {
                $q = sprintf("SELECT * FROM %s WHERE %s='%s'",
                        $this->table_name(),
                        $this->tag,
                        addslashes($id));
            }
            else if ($this->metadata[$this->key]['type'] != 'integer')
            {
                $q = sprintf("SELECT * FROM %s WHERE %s='%s'",
                        $this->table_name(),
                        $this->key,
                        addslashes($id));
            }
            else
            {
                $q = sprintf('SELECT * FROM %s WHERE %s=%d',
                        $this->table_name(),
                        $this->key,
                        $id);
            }

			$DB = Database::getReader();
            $result = $DB->query($q);
            check_db($DB);

            if ($result->num_rows == 0)
                $this->add_error(lang('err_nouserid'), $id);
            else
            {
                $this->rawdata = $arr = $result->fetch_assoc();
            }
        }
        else
        {
            $arr = $row;
        }

        foreach($arr as $name => $value)
        {
            if ($name == $this->obj_props)
            {
                // handle serialized data
                $temp = unserialize($value);
                foreach($temp as $tname => $tval)
                    //$this->metadata[$tname]['value'] = stripslashes($tval);
                    //$this->set($tname, stripslashes($tval));
                    $this->set($tname, $tval);
            }
            else if (isset($this->metadata[$name]))
            {
                //$this->metadata[$name]['value'] = stripslashes($value);
                //$this->set($name, stripslashes($value));
                $this->set($name, $value);
            }
        }
    }
}

// form() - builds, displays an input form for the object
// @param name - the name assigned to the form
// @param action - the script to call when the form is processed
// @param method - usually POST, sometimes GET
public function form($name, $action, $method, $submit="Submit", $reset="Reset")
{
    global $TEMPLATES;  // holds current template set

    // set alt_template list, if necessary
    if (is_array($this->metadata['alt_template']))
        $this->metadata['alt_template']['options'] = 
            $this->get_alt_templates(get_class($this));

    // create a new input form
    $inf = new InputForm($name, $action, $method, $submit, $reset);
    $inf = $this->build_form_from_array($inf, $this->metadata);
    return $inf->get_form('form'); // logical template name
}

// build build_form_from_array
private function build_form_from_array($form, $metadata_array, $suffix='')
{
    foreach($metadata_array as $field => $definition)
    {
        // file?
        if ($definition['type'] == 'file')
            $form->enctype = 'multipart/form-data';

        // "internal" fields do not appear on forms
        if ($definition['internal'])
            ;   // do nothing
        else if ($this->get($this->key) && $definition['noupdate'])
            ;   // don't update existing info
        else if (!isset($definition['type']))
            ;   // ignore properties without info
        else if ($definition['type'] == 'group')
        {
            for($i=0; $i<$definition['repeats']; $i++)
                $form = $this->build_form_from_array(
                    $form, 
                    $definition['metadata'], 
                    '[]'
                );
        }
        else if (!$definition['advanced'])
            $form->add_item($field.$suffix, $definition);
    }
    foreach($metadata_array as $field => $definition)
    {
        if ($definition['advanced'] && !$definition['internal'])
            $form->add_item($field, $definition);
    }
    return $form;
}

// set_post() - set values from _POST request
public function set_post($_POST)
{
    foreach($this->metadata as $name => $info)
    {
        if (isset($_POST[$name]) || (!$_POST['partial']))
        {
            // retrieve the value
            //$val = stripslashes($_POST[$name]);
            $val = $_POST[$name];
            // only operate on non-internal fields
            if ($info['internal'])
                ;   // do nothing
            else if ($this->get($this->key) && $info['noupdate'])
                ;   // also do nothing
            else if (($info['type'] == 'date')||($info['type'] == 'datetime'))
            {
                $ds = sprintf('%d-%d-%d',
                        $_POST[$name."Year"],
                        $_POST[$name."Month"],
                        $_POST[$name."Day"]);
                if ($info['type'] == 'datetime')
                    $ds .= sprintf(' %d:%d:%d',
                        $_POST[$name.'Hour'],
                        $_POST[$name.'Minute'],
                        $_POST[$name.'Second']);
                $this->set($name, $ds);
            }
            else
                $this->set($name, $val);
        }
    }
}

// set(name,val) - set a value, with checking
public function set($name, $val)
{
    // this is just shorthand
    $info = $this->metadata[$name];

    // ignore virtual fields
    if ($info['virtual'])
        return;
    
    // check min value
    if (isset($info['min']) && ($val < $info['min']))
        $this->add_error(lang('err_fieldmin'),
            lang("prompt_$name"), $info['min']);

    // check min value
    if (isset($info['max']) && ($val > $info['max']))
        $this->add_error(lang('err_fieldmax'),
            lang("prompt_$name"), $info['max']);

    // check max length
    if ($info['maxlength'] && (strlen(strip_tags($val)) > $info['maxlength']))
        $this->add_error(lang('err_fieldtoolong'),
                lang("prompt_$name"), $info['maxlength']);

    // check min length
    if ($info['minlength'] && (strlen($val) < $info['minlength']))
        $this->add_error(lang('err_fieldtooshort'),
                lang("prompt_$name"), $info['minlength']);

    // check pattern
    if (($info['pattern']!='') && (!preg_match($info['pattern'], $val)))
        $this->add_error(lang('err_badpattern'),
                lang("prompt_$name"));

    // strip html
    if (!strcasecmp($info['formatted'], 'ANY'))
        ; // anything is allowed
    else if ($info['formatted'])
        $val = strip_tags($val, config('allowed_html'));
    else if ($info['type'] != 'xml')
        $val = strip_tags($val);

    // remove extranous spaces
    $val = trim($val);

    // process filters
    if (isset($info['filter']))
        $val = Plugins::do_filters($this, $name, $val);

    // save the value
    if (!isset($this->metadata[$name]))
    {
        $this->metadata[$name]['internal'] = TRUE;
        $this->metadata[$name]['type'] = 'text';
    }
    $this->metadata[$name]['value'] = $val;
}

// set_null(name) set the null indicator on a column
public function set_null($name)
{
    $this->metadata[$name]['null'] = TRUE;
}

// get - retrieve a property
public function get($name)
{
    if (isset($this->metadata[$name]['formatted']) && $this->metadata[$name]['formatted'])
        return $this->textformat($this->metadata[$name]['value']);
    else
        return $this->metadata[$name]['value'];
}

// get_all() - return assoc array of all properties
public function get_all()
{
    $arr = array();
    // first, save a copy of this object
    $arr['obj'] = $this;
    
    // save all the values
    foreach($this->metadata as $name => $info)
        if (isset($info['formatted']) && $info['formatted'])
            $arr[$name] = $this->textformat($info['value']);
        else
            $arr[$name] = $info['value'];

    // extra fields
    $arr['url'] = $this->get_url();
    $arr['urn'] = $this->get_urn();
    $arr['rss_url'] = $this->get_rss_url();
    $arr['api_url'] = $this->get_api_url();
    $arr['edit_url'] = $this->get_edit_url();
    $arr['delete_url'] = $this->get_delete_url();
    $arr['table_name'] = $this->table_name();
    $arr['title'] = $this->get_title();
    $arr['class'] = get_class($this);
    $arr['id'] = $this->get($this->key);
    $arr['_editor'] = $this->authorized();
    $arr['_owner'] = $this->owner();
    if ($this->created != '')
        $arr['created'] = $this->get($this->created);
    if ($this->modified != '')
        $arr['modified'] = $this->get($this->modified);

    // add user info
    if (get_class($this) != 'User')  // we don't need to add owner info for User
    {
        if ($this->owner != '')
        {
            if (isset($this->rawdata['user_id']))
                $u = new User(0, $this->rawdata);
            else
                $u = new User($this->owner());
            $arr['user'] = $u->get_all();
        }
    }

    return $arr;
}

// add() - add object to database
// the audit_log_enable flag, if FALSE, will not log this event to the
// audit log. This is used for page view logging which, since it writes to
// a (different) log table with every page view, does not need to have a
// separate audit log event
public function add($audit_log_enable=TRUE)
{
    global $AUDIT, $PAGE;

    // do plugins
    Plugin::do_events($this, '-add');

    // check for duplicates
    foreach($this->metadata as $name => $info)
    {
        if ($info['unique'])
        {
            $q = sprintf(
                'SELECT COUNT(*) FROM %s WHERE %s=%s',
                $this->table_name(),
                $name,
                $this->get_col_sql($name)
            );
            $DB = Database::getReader();
            $res = $DB->query($q);
            check_db($DB);
            list($num) = $res->fetch_array();
            if ($num)
            {
                $display_name = lang("prompt_$name");
                if ($display_name == "prompt_")
                    $display_name = $name;
                $this->add_error(lang('err_duplicate'), $display_name);
            }
        }
    }
    
    // exit if not valid
    if (!$this->is_valid())
        return;

    // construct an insert statement
    $q = sprintf('INSERT INTO %s (%s) VALUES (%s)',
            $this->table_name(),
            implode(',', $this->all_cols(TRUE)),
            implode(',', $this->all_values(TRUE)));

    // insert the row
    $DBW = Database::getWriter();
    $DBW->query($q);

    // check for errors
    if ($DBW->errno)
    {
        $this->add_error(lang('err_db'), $DBW->error);
        $AUDIT->message('Failed to create %s: %s [%s]',
            get_class($this),
            $this->get_title(),
            $DBW->error);
    }
    else if ($audit_log_enable)
    {
        if ($this->metadata[$this->key]['type'] == 'integer')
            $this->set($this->key, $DBW->insert_id);
        $AUDIT->message('New %s: %s',
            get_class($this),
            $this->get_title());
            
        // add fulltext table data
        $this->add_fulltext_data();
    }
    
    // clear Smarty cache
    $PAGE->clear_all_cache();
    
    // do plugins
    Plugin::do_events($this, 'add');
}

// update() - update existing database object
public function update()
{
    global $AUDIT, $PAGE;
    
    // do plugins
    Plugin::do_events($this, '-update');
    
    // return if not valid
    if (!$this->is_valid())
        return;

    // construct the update statement
    $q = sprintf(
        "UPDATE %s SET %s WHERE %s=%d",
        $this->table_name(),
        implode(",\n", $this->update_cols()),
        $this->key,
        $this->get($this->key)
    );
    $DB = Database::getWriter();
    $result = $DB->query($q);

    if ($DB->errno)
    {
        $this->add_error(lang('err_db'), $DB->error);
        $AUDIT->message('Error updating %s: %s [%s]',
            get_class($this), $this->get_title(), $DB->error);
    }
    else
    {
        $AUDIT->message('Updated %s: %s',
            get_class($this), $this->get_title());
        // update fulltext index row
        if (count($this->fulltext))
        {
            $this->del_fulltext_data();
            $this->add_fulltext_data();
        }
    }
    
    // clear Smarty cache
    $PAGE->clear_all_cache();
    
    // do plugins
    Plugin::do_events($this, 'update');
}

// delete() - delete existing object
public function delete()
{
    global $AUDIT, $PAGE;
    
    // do plugins
    Plugin::do_events($this, '-delete');

    // return if not valid
    /*
    if (!$this->is_valid())
        return;
    */

    $q = $this->get_delete_statement();
    $DB = Database::getWriter();
    $result = $DB->query($q);

    if ($DB->errno)
    {
        $this->add_error(lang('err_db'), $DB->error);
        $AUDIT->message('Error deleting %s %s [%s]',
            get_class($this), $this->get_title(), $DB->error);
    }
    else
    {
        $AUDIT->message('Deleted %s %s',
            get_class($this), $this->get_title());
        
        // update fulltext index row
        if (count($this->fulltext))
        {
            $this->del_fulltext_data();
        }
        
    }
    
    // clear Smarty cache
    $PAGE->clear_all_cache();
    
    // do plugins
    Plugin::do_events($this, 'delete');
}

// generates the SQL to delete an object (can be overridden)
public function get_delete_statement()
{
    // construct the delete statement
    $q = sprintf(
        "DELETE FROM %s WHERE %s=%d",
        $this->table_name(),
        $this->key,
        $this->id()
    );
    return $q;
}

// delete_all() - to delete child rows, this function deletes all of CLASS
// where COLUMN is VALUE
public function delete_all($class, $col, $value)
{
    $DB = Database::getReader();
    
    $obj = new $class();
    $q = sprintf("SELECT * FROM %s WHERE %s=%s",
            $obj->table_name(),
            $col,
            $value);
    $result = $DB->query($q);
    check_db($DB);
    while($values = $result->fetch_assoc())
    {
        $obj = new $class(0, $values);
        $obj->delete();
    }
}

// delete_array() - delete everything in the array
public function delete_array($arr)
{
    foreach($arr as $class => $col)
        $this->delete_all($class, $col, $this->id());
}

// build fulltext data
private function get_fulltext_data()
{
    $text = '';
    foreach($this->fulltext as $name)
        $text .= $this->get($name).' ';
    return trim(strip_tags($text));
}

// del_fulltext_data()
// removes related fulltext data
public function del_fulltext_data()
{
    $DB = Database::getWriter();
    $s = new SearchText;
    $q = sprintf(
        "DELETE FROM %s WHERE obj_class='%s' AND obj_id=%d",
        $s->table_name(),
        get_class($this),
        $this->id());
    $DB->query($q);
    check_db($DB);
}

// add_fulltext_data()
// this is a public function so that it can be invoked by an external utility
public function add_fulltext_data()
{
    // add fulltext index row
    if (count($this->fulltext))
    {
        $search = new SearchText;
        $search->set('obj_class', get_class($this));
        $search->set('obj_id', $this->get($this->key));
        $search->set('obj_text', $this->get_fulltext_data());
        $search->add();
    }
}

// all_cols(add) - return array of all columns
// if $add is TRUE, then the "created" is included
public function all_cols($add=FALSE)
{
    $names = array();
    foreach($this->metadata as $name => $info)
    {
        if ($this->created == $name)
        {
            if ($add)
                $names[] = $name;
        }
        else if ($info['col'])
            $names[] = $name;
    }
    if ($this->obj_props!='')
        $names[] = $this->obj_props;
    return $names;
}

// all_values() - return array of all values
// if $add is TRUE, then the "created" is included
public function all_values($add=FALSE)
{
    $values = array();
    foreach($this->metadata as $name => $info)
    {
        if ($this->created == $name)
        {
            if ($add)
                $values[] = 'NOW()';
        }
        else if ($this->modified == $name)
        {
            $values[] = 'NOW()';
        }
        else if ($info['col'])
        {
            $values[] = $this->get_col_sql($name);
        }
    }
    if ($this->obj_props!='')
        $values[] = "'".addslashes(serialize($this->noncol_values()))."'";
    return $values;
}

// get_col_sql(name) - returns SQL string for column
public function get_col_sql($name)
{
    switch($this->metadata[$name]['type'])
    {
    case 'integer':
        // note the === operator here
        if ($this->metadata[$name]['null'])
            return "NULL";
        else
            return sprintf('%d', $this->metadata[$name]['value']);
        break;
    default:
        $val = sprintf("'%s'", addslashes($this->metadata[$name]['value']));
        if ($this->metadata[$name]['crypt'])
            return config('crypt_function').'('.$val.')';
        else if ($name == $this->modified)
            return "NOW()";
        else
            return $val;
    }
}

// nonkey - return array of the names of all non-key columns
public function nonkey()
{
    $names = array();
    foreach($this->metadata as $name => $info)
    {
        if (($name != $this->key) && $info['col'])
            $names[] = $name;
    }
    if ($this->obj_props!='')
        $names[] = $this->obj_props;
    return $names;
}

// noncol - returns an array of properties that are -not- a table column
public function noncol()
{
    $names = array();
    foreach($this->metadata as $name => $info)
    {
        if (!$info['col'] && !$info['virtual'])
            $names[] = $name;
    }
    return $names;
}

// noncol_values() - return an array of all non-col values
public function noncol_values()
{
    $arr = $this->noncol();
    $values = array();
    foreach($arr as $name)
        $values[$name] = $this->metadata[$name]['value'];
    return $values;
}

// update_cols() - return columns to be updated
public function update_cols()
{
    $arr = array();
    foreach($this->all_cols() as $name)
    {
        $info = $this->metadata[$name];
        if ($info['noupdate'])
            ;   // ignore un-updateable ones
        else if ($name == $this->key)
            ;   // don't update keys
        else if ($name == $this->obj_props)
        {
            $temp = array();
            foreach($this->noncol_values() as $tname => $tval)
                $temp[$tname] = $tval;
            $arr[] = sprintf("%s='%s'", $name, addslashes(serialize($temp)));
        }
        else
            $arr[] = sprintf('%s=%s', $name, $this->get_col_sql($name));
    }
    return $arr;
}

// table_name() - returns the fully-qualified table name
public function table_name()
{
    return config('db_table_prefix').$this->table;
}

// foreign_keys() - defines foreign keys for object
public function foreign_keys()
{
    // create return array
    $arr = array();
    
    // find values with references
    foreach($this->metadata as $field => $info)
        if (isset($info['references']))
        {
            list($class, $column) = explode('.', $info['references']);
            $obj = new $class();
            $fk = sprintf(
                'FOREIGN KEY (%s) REFERENCES %s (%s) ON DELETE RESTRICT',
                $field,
                $obj->table_name(),
                $column);
            $arr[] = $fk;
        }
    
    // return the value
    return $arr;
}

// create_indexes() - array of CREATE INDEX statements for table
public function create_indexes()
{
    return array();
}

// get_url() - returns the url for the object
public function get_url()
{
    return sprintf(
            '%s/%s.php?id=%s',
            config('site_path'),
            strtolower(get_class($this)),
            $this->get($this->key));
}

// get_api_url() - returns the API representation of the object
public function get_api_url()
{
    if (config('url_rewriting'))
        return sprintf(
            '%s/api/V1/%s/%s',
            config('site_url'),
            get_class($this),
            ($this->tag != '') ? $this->get($this->tag) : $this->id()
        );
    else
        return sprintf(
            '%s/api.php?v=1&amp;r=%s&amp;id=%s',
            config('site_url'),
            get_class($this),
            ($this->tag != '') ? $this->get($this->tag) : $this->id()
        );
}

// get_edit_url() - returns edit URL for object
public function get_edit_url()
{
    if (config('url_rewriting'))
    {
        return sprintf(
            '%s/edit/%s%s',
            config('site_path'),
            get_class($this),
            $this->id() ? ('/'.$this->id()) : ''
        );
    }
    else
        return sprintf(
                '%s/edit.php?c=%s&amp;id=%s',
                config('site_path'),
                get_class($this),
                $this->get($this->key));
}

// get_delete_url() - url to delete the object
public function get_delete_url()
{
    return sprintf(
            '%s/delete.php?c=%s&amp;id=%s',
            config('site_path'),
            get_class($this),
            $this->id());
}

// get_title() - get the displayable name of the object
public function get_title()
{
    return sprintf('%s %d', get_class($this), $this->get($this->key));
}

// get unique name
public function get_unique_name($seed, $field)
{
    $val = preg_replace('/[^a-z0-9_-]+/', '-', strtolower($seed));

    $length = $this->metadata[$field]['maxlength'];

    // check for uniqueness
    do {
        $val = trim(substr($val, 0, $length));
        if ($val == '')
            $val = rand(1000,9999);
        $q = sprintf("SELECT COUNT(*) FROM %s WHERE %s='%s'",
                $this->table_name(),
                $field,
                addslashes($val));
        $DB = Database::getReader();
        $result = $DB->query($q);
        if ($DB->errno)
            abort(lang('err_db'), $DB->error);
        list($num) = $result->fetch_row();
        if ($num || is_dir($val))
            $val = '-'.$val;
    } while ($num);
    
    return($val);
}

// id() - return unique ID
public function id()
{
    return $this->get($this->key);
}

// owner() - return the owner of the object
public function owner()
{
    return $this->get($this->owner);
}

// get_urn() - get a unique identifier
public function get_urn()
{
    return sprintf('urn:Siteframe:%s:%s:%s:%s',
        config('site_url_host'),
        config('site_url_path').'/',
        get_class($this),
        $this->id());
}

// get_rss_url() - get the URL of the RSS feed for this object
public function get_rss_url()
{
    return '';
}

// authorized() - returns TRUE if current user is authorized to edit
// the current object
public function authorized()
{
    // if no one is logged in, it's not authorized
    if (!is_object($_SESSION['user']))
        return FALSE;

    // if the user is an administrator, it's always authorized
    if ($_SESSION['user']->get('user_admin'))
        return TRUE;

    // if it's a new object, it's authorized
    if ($this->id() == 0)
        return TRUE;

    // if the user owns the object, it's authorized
    if ($this->owner() == $_SESSION['user']->get('user_id'))
        return TRUE;

    // all else fails, it's not authorized
    return FALSE;
}

// all_folders - returns a list (for SELECT) of all folders
public final function all_folders()
{
    $DB = Database::getReader();
    $arr = array();
    $f = new Folder;
    $q = sprintf(
        "SELECT folder_id,folder_title FROM %s ORDER BY folder_title",
        $f->table_name());
    $result = $DB->query($q);
    check_db($DB);
    while(list($id,$title) = $result->fetch_row())
        $arr[$id] = $title;
    return $arr;
}

// xml() - this creates an XML document from the object
public function xml($metadata=FALSE)
{
    $doc = new DOMDocument('1.0');
    $doc->formatOutput = TRUE;
    $root = $doc->createElement(get_class($this));
    $root = $doc->appendChild($root);
    $ver  = $doc->createAttribute('version');
    $ver  = $root->appendChild($ver);
    $text = $doc->createTextNode($this->get('__version__'));
    $text = $ver->appendChild($text);
    
    // some virtual properties
    // everything has a URN
    $root->appendChild($doc->createElement('urn', $this->get_urn()));
    
    // not everything has a URL
    if ($this->get_url() != '')
        $root->appendChild($doc->createElement('url',
            config('site_url_base').$this->get_url()));
    
    // and we add an RSS URL if it exists
    $rss = $this->get_rss_url();
    if ($rss != '')
        $root->appendChild($doc->createElement('rss_url', $rss));

    // get the owner
    $uid = $this->owner();
    if ($uid && (get_class($this)!='User'))
    {
        $u = new User($uid);
        $root->appendChild($doc->createElement('owner', $u->get('user_name')));
    }

    if (!$metadata)
        $metadata = $this->metadata;
    
    // process metadata array
    $this->array_to_xml($doc, $root, $metadata);
    
    return $doc->saveXML() . "\n";
}

// array_to_xml()
// converts a metadata array to a child of an xml tree
private function array_to_xml(&$doc, $parentnode, $metadata)
{
    foreach($metadata as $name => $info)
    {
        if ($info['type'] == 'array')
        {
            $item = $parentnode->appendChild($doc->createElement($name));
            foreach($info['value'] as $instance)
            {
                $thing = $item->appendChild($doc->createElement($info['item']));
                $thing->appendChild($doc->createTextNode($instance));
            }
        }
        else if (!$info['secret'] && !$info['virtual'] && ($name!='__version__'))
        {
            $item = $doc->createElement($name);
            $item = $parentnode->appendChild($item);
            if ($info['type'] == 'metadata')
                $this->array_to_xml($doc, $item, $info['value']);
            else
            {
                $text = $doc->createTextNode($this->get($name));
                $text = $item->appendChild($text);
            }
        }
    }
}

// get_alt_templates - return a list of alternative templates
public function get_alt_templates($class='')
{
    $DB = Database::getReader();

    // create the return array
    $out = array();
    
    // always have an option to use the default template
    $out[''] = lang('prompt_use_default_template');

    // return if we're not logged in    
    if (!is_object($_SESSION['user']))
        return $out;
    
    // build query to select templates
    $tpl = new Template;    
    $q = sprintf(
        "SELECT tpl_public,tpl_name ".
        "FROM %s ".
        "WHERE (tpl_public>0 OR tpl_user_id=%d) ".
        (($class!='') ? " AND tpl_class='$class' " : "") .
        "ORDER BY tpl_public, tpl_name",
        $tpl->table_name(),
        $_SESSION['user']->id());

    // execute the query
    $result = $DB->query($q);
    check_db($DB);
    
    // retrieve all the data and build output array
    while(list($pub,$name) = $result->fetch_array())
    {
        if ($pub)
            $out["db:$name"] = $name.'*';
        else
            $out["db:$name"] = $name;
    }
    return $out;
}

// textformat(s) - returns a formatted version of string
private function textformat($string)
{
    if (strpos($string, '<') !== FALSE)
        return $string;
    
    // eliminate carriage-returns
    $string = str_replace("\r\n", "\n", $string);
    
    // preformatted
    /* this has problems with line breaks
    $string = preg_replace('/(?<=\n|$)( +.*)\n*(?=\n[^\s])/sU', 
                "<pre>\n\\1\n</pre>", $string);
    */

    // unordered lists
    $string = preg_replace('/^\*\s*(.*)$/m', "<li>\\1</li>", $string);
    $string = preg_replace('/(?<!\<\/li\>\n)(<li>.*<\/li>)(?!\n\<li>)/sU',
                "<ul>\n\\1\n</ul>\n", $string);
    // ordered lists
    $string = preg_replace('/^\#\s*(.*)$/m', "<li>\\1</li>", $string);
    $string = preg_replace('/(?<!\<\/li\>\n|\<ul\>\n)(<li>.*<\/li>)(?!\n\<li>|\n\<\/ul)/sU',
                "<ol>\n\\1\n</ol>\n", $string);
    
    // headings
    $string = preg_replace('/^!!!\s*(.*)$/m', '<h2>\1</h2>', $string);
    $string = preg_replace('/^!!\s*(.*)$/m', '<h3>\1</h3>', $string);
    $string = preg_replace('/^!\s*(.*)$/m', '<h4>\1</h4>', $string);

    // what is a paragraph?
    // it starts with either multiple newlines \n\n+[^<]
    // or a >\n+[^<]
    $string = preg_replace(
            '/(?<=\>\n|\n\n|^)\n*([^<\s].+)\n*(?=\n\n|\n\<|$)/Us',
            "<p>\\1</p>",
            $string);

    // convert http:// to [link] style
    $string = preg_replace(
            '/(?<![\!\[\|])((http|https|ftp|mailto):\/\/[\w\.\+\#\?\/\=\%\-\,\&\;\~]+[\w\+\#\?\/\=\%\-])(?=[\W\'\"\.\,]*\s*)/m',
            '[\1|\1]',
            $string);

    $string = str_replace('!http://', 'http://', $string);
    // replace [URL] type links with [URL|URL]
    $string = preg_replace(
            '/(?<!\[)\[([^\|\]\[]+)\]/mU',
            '[\1|\1]',
            $string);

    // replace [text|URL] type links
    $string = preg_replace(
            '/(?<!\[)\[([^\[].+)\|(.+)\]/mU',
            '<a href="\2">\1</a>',
            $string);
    $string = str_replace('[[', '[', $string);
    
    if ($links_only)
        return $string;
    // double single quotes = italic
    $string = preg_replace(
            '|\'\'(.+)\'\'|mU',
            '<em>\1</em>',
            $string);

    // double underscore = bold
    $string = preg_replace(
            '|__(.+)__|mU',
            '<b>\1</b>',
            $string);

    // line breaks
    $string = preg_replace('/(?<!\>|\n)\n(?!>\>|\n)/', "<br />\n", $string);
    
    return $string;
}

} // end class DataObject

?>
