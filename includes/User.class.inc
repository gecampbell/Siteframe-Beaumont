<?php
// $Id: User.class.inc,v 1.78 2006/05/03 01:31:48 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.

class User extends DataObject
{
public $table = 'user_info';
public $key = 'user_id';
public $owner = 'user_id';
public $obj_props = 'user_properties';
public $created = 'user_created';
public $modified = 'user_modified';
public $sort = 'user_name';
public $fulltext = array('user_name','user_firstname','user_lastname',
                         'user_properties');
public $sortfield = 'user_name';
public $tag = 'user_name';
public $metadata = array(
    'user_id' => array(
        'col' => TRUE,
        'type' => 'integer',
        'auto_increment' => TRUE,
        'required' => TRUE,
        'hidden' => TRUE,
    ),
    'user_admin' => array(
        'col' => TRUE,
        'type' => 'checkbox',
        'rval' => 1,
        'required' => TRUE,
        'internal' => TRUE,
        'index' => TRUE,
        'secret' => TRUE, // not in XML
    ),
    'user_status' => array(
        'col' => TRUE,
        'type' => 'select',
        'sqltype' => 'INTEGER',
        'required' => TRUE,
        'internal' => TRUE,
        'index' => TRUE,
    ),
    'user_created' => array(
        'col' => TRUE,
        'type' => 'datetime',
        'required' => TRUE,
        'internal' => TRUE,
        'noupdate' => TRUE,
        'index' => TRUE,
    ),
    'user_modified' => array(
        'col' => TRUE,
        'type' => 'datetime',
        'required' => TRUE,
        'internal' => TRUE,
    ),
    'user_hash' => array(       // holds sha1() hash for registration
        'col' => TRUE,
        'type' => 'text',
        'maxlength' => 50,
        'internal' => TRUE,
        'required' => TRUE,
        'unique' => TRUE,
        'noupdate' => TRUE,
        'secret' => TRUE, // not included in XML
    ),
    'user_name' => array(
        'col' => TRUE,
        'type' => 'text',
        'maxlength' => 50,
        'minlength' => 4,
        'pattern' => '/^[a-zA-Z][a-zA-Z0-9_]+$/',
        'unique' => TRUE,
        'required' => TRUE,
        'noupdate' => TRUE,
        'size' => 30,
    ),
    'user_firstname' => array(
        'col' => TRUE,
        'type' => 'text',
        'maxlength' => 250,
        'minlength' => 0,
        'pattern' => '/^[^0-9]*/',
        'size' => 20,
    ),
    'user_lastname' => array(
        'col' => TRUE,
        'type' => 'text',
        'maxlength' => 250,
        'minlength' => 1,
        'required' => TRUE,
        'pattern' => '/^[^0-9].+$/',
        'size' => 20,
    ),
    'user_email' => array(
        'col' => TRUE,
        'type' => 'text',
        'maxlength' => 250,
        'minlength' => 3,
        'pattern' => '/.+\@.+/',
        'required' => TRUE,
        'unique' => TRUE,
        'size' => 30,
        'secret' => TRUE, // not included in email
    ),
    'user_email2' => array(
        'type' => 'text',
        'size' => 30,
        'virtual' => TRUE
    ),
    'user_password' => array(
        'col' => TRUE,
        'type' => 'password',
        'maxlength' => 250,
        'minlength' => 6,
        'required' => TRUE,
        'size' => 40,
        'crypt' => TRUE,
        'noupdate' => TRUE,
    ),
    'user_password2' => array(
        'type' => 'password',
        'size' => 40,
        'virtual' => TRUE,
    ),
    'user_timezone' => array(
        'type' => 'select',
        'options' => array(),
        'advanced' => TRUE,
    ),
    'user_language' => array(
        'type' => 'select',
        'options' => array(),
        'advanced' => TRUE,
    ),
    'user_photo' => array(
        'col' => FALSE,
        'type' => 'file',
        'advanced' => TRUE,
    ),
    'user_photo_type' => array(
        'col' => FALSE,
        'type' => 'text',
        'internal' => TRUE,
    ),
    'v_user_photo_delete' => array(
        'type' => 'checkbox',
        'rval' => 1,
        'virtual' => TRUE,
        'advanced' => TRUE,
    ),
    'user_info' => array(
        'col' => FALSE,
        'type' => 'textarea',
        'formatted' => TRUE,
        'advanced' => TRUE,
    ),
    'rows_per_page' => array(
        'col' => FALSE,
        'type' => 'select',
        'options' => array( 10 => '10', 20 => '20', 30 => '30', 50 => '50', 75 => '75',
                            100 => '100' ),
        'advanced' => TRUE,
    ),
    'email_comments' => array(
        'col' => FALSE,
        'type' => 'checkbox',
        'rval' => 1,
        'value' => 1,
        'advanced' => TRUE,
    ),
    'sub_newsletter' => array(
        'col' => FALSE,
        'type' => 'checkbox',
        'rval' => 1,
        'value' => 1,
        'advanced' => TRUE,
    ),
    'last_login' => array(      // holds the UNIX time of last login
        'type' => 'number',
        'internal' => 'TRUE',
    ),
    'inv_id' => array(          // relates user to invitation
        'type' => 'integer',
        'col' => FALSE,
        'hidden' => TRUE,
    ),
    'alt_template' => array(
        'col' => FALSE,
        'type' => 'select',
        'options' => array( '' => 'Use default template'),
        'advanced' => TRUE,
    ),
    'user_api_limit' => array(
        'type' => 'number',
        'internal' => TRUE,
        'secret' => TRUE,
    ),
);
private $old_email = '';        // to detect changes

// constructor - create a new user
public function __construct($id=0, $row=array())
{
    // if the current user is admin, enable the user_admin field
    if (is_object($_SESSION['user']) && $_SESSION['user']->get('user_admin'))
    {
        $this->metadata['user_admin']['internal'] = FALSE;
        $this->metadata['user_status']['internal'] = FALSE;
        $this->metadata['user_status']['options'] = array(
            0 => lang('user_status_pending'),
            1 => lang('user_status_active'));
    }
    $status = !config('confirm_email');
    $this->metadata['user_status']['value'] = $status+0;
    
    // set default options
    $this->metadata['user_timezone']['value'] = config('default_timezone', -8);
    $this->metadata['user_language']['value'] = config('lang_default');
    $this->metadata['rows_per_page']['value'] = config('rows_per_page');
    $this->metadata['user_api_limit']['value'] = config('api_limit_day');
    
    // fetch the user 
    parent::__construct($id, $row);
    
    // are we real?
    if ($this->id())
    {
        unset($this->metadata['user_email2']);
        unset($this->metadata['user_password']);
        unset($this->metadata['user_password2']);
        $this->metadata['user_name']['disabled'] = TRUE;
        $this->old_email = $this->get('user_email');
    }
}

// form - get info
public function form($name, $action, $method, $submit="Save", $reset="Reset")
{
    $this->metadata['user_timezone']['options'] = get_timezones();
    $this->metadata['user_language']['options'] = $this->get_languages();
    return parent::form($name, $action, $method, $submit, $reset);
}
// set(name,value) - set a value
public function set($name, $value)
{
    global $_FILES;

    switch($name)
    {
    case 'user_photo':
        if (is_array($_FILES[$name]))
        {
            if ($_FILES[$name]['error'] == 0)
            {
                // @unlink($this->get($name));
                $path = sprintf('%s/%s',
                        config('dir_files'),
                        $this->get('user_name'));
                @mkdir($path);
                $newname = "$path/".$_FILES[$name]['name'];
                move_uploaded_file($_FILES[$name]['tmp_name'], $newname);
                parent::set($name, $newname);
                parent::set("{$name}_type", $_FILES[$name]['type']);
            }
            else if ($_FILES[$name]['error'] != 4)
            {
                $this->add_error(lang('err_user_photo', $_FILES[$name]['error']));
            }
            else if ($value != '')
                parent::set($name, $value);
        }
        else
            parent::set($name, $value);
        break;
    case 'v_user_photo_delete':
        if ($value)
        {
            @unlink($this->get('user_photo'));
            parent::set('user_photo', '');
            parent::set('user_photo_type', '');
        }
        break;
    case 'user_email2':
        if ($value != $this->get('user_email'))
            $this->add_error(lang('err_nomatch'),lang("prompt_$name"));
        break;
    case 'user_password2':
        if ($value != $this->get('user_password'))
            $this->add_error(lang('err_nomatch'),lang("prompt_$name"));
        break;
    default:
        parent::set($name, $value);
    }
}

// add() - define internal properties
public function add()
{
    $DB = Database::getWriter();

    // are we ok
    if (!$this->is_valid())
        return;

    // clean up stuff
    unset($this->metadata['user_password2']);
    $this->set('user_hash', sha1(microtime()));
    
    parent::add();
    
    // confirm e-mail if necessary
    if ($this->is_valid() && config('confirm_email') && !$this->get('user_status'))
    {
        send_user_confirmation_email($this);
        $this->add_error(lang('msg_confirm_email'));
        unset($this->metadata['user_email2']);
    }
    $this->reset_session_data();
}

// update_password(old, new) - updates a user's password
public function update_password($old='', $new)
{
    $DB = Database::getWriter();

    if ($old != '')
        $q = sprintf(
            "UPDATE %s SET user_password=%s('%s') WHERE ".
            "user_id=%d AND user_password=%s('%s')",
            $this->table_name(),
            config('crypt_function'),
            addslashes($new),
            $this->id(),
            config('crypt_function'),
            addslashes($old));
    else
        $q = sprintf(
            "UPDATE %s SET user_password=%s('%s') WHERE user_id=%d",
            $this->table_name(),
            config('crypt_function'),
            addslashes($new),
            $this->id());
    $DB->query($q);
    check_db($DB);
    if ($DB->affected_rows != 1)
        $this->add_error(lang('err_nopwset'));
}

// update()
public function update()
{
    $reconfirm = FALSE;
    
    // if we change e-mail addresses, we need to reconfirm
    if (config('confirm_email') && 
        ($this->old_email != $this->get('user_email')))
    {
        $this->set('user_status', 0);
        $this->metadata['user_status']['internal'] = FALSE;
        $reconfirm = TRUE;
    }
    
    // perform the update
    parent::update();
    
    // we do this AFTER the update because the error message
    // prevents the update from occurring
    if ($reconfirm)
    {
        $this->metadata['user_status']['internal'] = TRUE;
        send_user_confirmation_email($this);
        $this->add_error(lang('msg_confirm_email'));
        logout();
    }
    else
    {
        // reset the session data
        $this->reset_session_data();
    }
}

// delete() - must also logout
public function delete()
{
    // remove all content
    $this->delete_array(array(
        'Favorite' => 'fav_user_id',
        'Memo' => 'memo_to_user_id',
    ));
    $this->delete_array(array(
        'ACL' => 'acl_user_id',
        'Subscription' => 'sub_user_id',
        'Folder' => 'folder_user_id',
        'TagUserRel' => 'user_id',
        'TagView' => 'view_user_id',
        'Rating' => 'rate_user_id',
        'Comment' => 'comment_user_id',
        'File' => 'file_user_id',
        'Page' => 'page_user_id',
        'Favorite' => 'user_id',
        'GroupUserRel' => 'r_user_id',
        'Group' => 'group_user_id',
        'Invitation' => 'inv_user_id',
        'Link' => 'link_user_id',
        'Memo' => 'memo_from_user_id',
        'Quote' => 'quote_user_id',
        'RSSfeed' => 'rss_user_id',
        'Template' => 'tpl_user_id',
    ));
    
    parent::delete();
    
    // logoff
    unset($_SESSION['user']);
}

// get_url() - returns URL for user
public function get_url()
{
    if (config('url_rewriting'))
        return sprintf('%s/u/%s',
                config('site_path'),
                $this->get('user_name'));
    else
        return parent::get_url();
}

// get_rss_url()
public function get_rss_url()
{
    if (config('url_rewriting'))
        $sstr = '%s/rss/u/%s';
    else
        $sstr = '%s/rss.php?user=%s';
    return sprintf($sstr, config('site_url'), $this->get($this->tag));
}

// get_title() - return display name
function get_title()
{
    return $this->get('user_name');
}

// reset_session_data - only if we're the logged-in user
private function reset_session_data()
{
    if (!is_object($_SESSION['user']))
        return;
    if ($_SESSION['user']->get('user_id') != $this->get('user_id'))
        return;
    foreach ($this->metadata as $name => $info)
        $_SESSION['user']->set($name, $this->get($name));
}

// this loads the languages array
private function get_languages()
{
    $arr = array();
    foreach(glob(config('dir_lang').'/*.ini') as $filename)
    {
        $code = str_replace('.ini', '', basename($filename));
        $language = parse_ini_file($filename);
        $arr[$code] = $language['language_name'];
    }
    return $arr;
}

} // end class User

// this loads the timezones array
function get_timezones()
{
    // thanks to Chris Harpham for sorting these out
    $arr['12'] = '(GMT +12:00 hours) Auckland, Fiji, Marshall Island';
    $arr['11'] = '(GMT +11:00 hours) Magadan, New Caledonia';
    $arr['10'] = '(GMT +10:00 hours) Guam, Melbourne,Sydney';
    $arr['9.5'] = '(GMT +9:30 hours) Adelaide, Darwin';
    $arr['9'] = '(GMT +9:00 hours) Osaka, Sapporo, Seoul,Tokyo';
    $arr['8'] = '(GMT +8:00 hours) Beijing, Hong Kong,Singapore';
    $arr['7'] = '(GMT +7:00 hours) Bangkok, Hanoi, Jakarta';
    $arr['6.5'] = '(GMT +6:30 hours) Rangoon';
    $arr['6'] = '(GMT +6:00 hours) Almaty, Colombo,Novosibirsk';
    $arr['5.5'] = '(GMT +5:30 hours) Bombay, Calcutta,New Delhi';
    $arr['5'] = '(GMT +5:00 hours) Islamabad, Karachi,Tashkent';
    $arr['4'] = '(GMT +4:00 hours) Abu Dhabi, Baku, Muscat,Tbilisi';
    $arr['3.5'] = '(GMT +3:30 hours) Tehran';
    $arr['3'] = '(GMT +3:00 hours) Baghdad, Riyadh, Moscow,Nairobi';
    $arr['2'] = '(GMT +2:00 hours) Cairo, Helsinki,South Africa';
    $arr['1'] = '(GMT +1:00 hours) Amsterdam, Berlin, Madrid,Paris';
    $arr['0'] = '(GMT) Casablanca, Dublin, Edinburgh, London,Lisbon';
    $arr['-1'] = '(GMT -1:00 hours) Azores, Cape Verde Islands';
    $arr['-2'] = '(GMT -2:00 hours) Mid-Atlantic, AscensionIs';
    $arr['-3'] = '(GMT -3:00 hours) Buenos Aires,Georgetown';
    $arr['-3.5']= '(GMT -3:30 hours) Newfoundland';
    $arr['-4'] = '(GMT -4:00 hours) Atlantic Time (Canada)';
    $arr['-5'] = '(GMT -5:00 hours) Eastern Time (US & Canada)';
    $arr['-6'] = '(GMT -6:00 hours) Central Time (US & Canada)';
    $arr['-7'] = '(GMT -7:00 hours) Mountain Time (US & Canada)';
    $arr['-8'] = '(GMT -8:00 hours) Pacific Time (US & Canada)';
    $arr['-9'] = '(GMT -9:00 hours) Alaska';
    $arr['-10'] = '(GMT -10:00 hours) Hawaii';
    $arr['-11'] = '(GMT -11:00 hours) Midway Island, Samoa';
    $arr['-12'] = '(GMT -12:00 hours) Eniwetok, Kwajalein';
    return $arr;
}

?>
