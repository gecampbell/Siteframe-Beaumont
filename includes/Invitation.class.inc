<?php
// $Id: Invitation.class.inc,v 1.22 2005/11/23 04:41:45 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.

class Invitation extends DataObject
{
public $table = 'invitations';
public $key = 'inv_id';
public $owner = 'inv_user_id';
public $obj_props = "inv_properties";
public $created = 'inv_created';
public $modified = 'inv_modified';
public $metadata = array(
    'inv_id' => array(
        'col' => true,
        'type' => 'integer',
        'required' => true,
        'hidden' => true,
        'auto_increment' => true,
    ),
    'inv_user_id' => array(
        'col' => true,
        'type' => 'integer',
        'required' => true,
        'internal' => true,
        'index' => true,
        'references' => 'User.user_id',
    ),
    'inv_accepted' => array(
        'col' => true,
        'type' => 'integer',
        'required' => true,
        'index' => true,
        'hidden' => true,
    ),
    'inv_created' => array(
        'col' => true,
        'type' => 'datetime',
        'internal' => true,
        'required' => true,
        'noupdate' => true,
    ),
    'inv_modified' => array(
        'col' => true,
        'type' => 'datetime',
        'internal' => true,
        'required' => true,
    ),
    'inv_email' => array(
        'col' => true,
        'type' => 'text',
        'maxlength' => 250,
        'required' => true,
        'pattern' => '/.+\@.+/',
    ),
    'inv_name' => array(
        'col' => false,
        'type' => 'text',
        'virtual' => true,
    ),
    'inv_firstname' => array(
        'col' => false,
        'type' => 'text',
        'internal' => true,
    ),
    'inv_lastname' => array(
        'col' => false,
        'type' => 'text',
        'internal' => true,
    ),
    'inv_hash' => array(
        'col' => true,
        'type' => 'text',
        'maxlength' => 50,
        'unique' => true,
        'required' => true,
        'internal' => true,
     ),
    'inv_message' => array(
        'col' => false,
        'type' => 'textarea',
    ),
    'inv_favorites' => array(
        'type' => 'checkbox',
        'rval' => 1,
        'value' => 1,
    ),
    'friend_user_id' => array(
        'type' => 'integer',
        'internal' => TRUE,
    ),
);

// add() - add the invitation
public function add()
{
    global $PAGE;

    $this->set('inv_hash', sha1(microtime(true)));
    parent::add();
    
    // TODO: send invitation e-mail
    if ($this->is_valid())
    {
        $em = new HtmlEmail(sprintf("An invitation to join %s", config('site_name')));
        $em->to($this->get('inv_email'));
        $PAGE->assign($this->get_all());
        $em->send_template(site_template('invitation'));
    }
}

// update() - notify invitor
public function update()
{
    global $PAGE;
    parent::update();
    
    // tell the invitor that their invitation was accepted
    if ($this->is_valid() && $this->get('inv_accepted'))
    {
        // send the notification
        $u = new User($this->get('inv_user_id'));
        $friend = new User($this->get('friend_user_id'));
        $PAGE->assign('newuser', $friend->get_all());
        $em = new HtmlEmail(lang('subj_inv_accepted'));
        $em->to($u->get('user_email'));
        $em->send_template(site_template('inv_accepted'));
        
        // if inv_favorites, then add the new user to the old user's favorites
        if ($this->get('inv_favorites'))
        {
            $f = new Favorite;
            $f->set('user_id', $u->id());
            $f->set('fav_user_id', $this->get('friend_user_id'));
            $f->add();
        }
    }
}

// get all properties
public function get_all()
{
    $arr = parent::get_all();
    $u = new User($this->get('inv_user_id'));
    $arr['user'] = $u->get_all();
    return $arr;
}

// set a property
public function set($name, $value)
{
    switch($name)
    {
    case 'inv_name':
        list($first,$last) = preg_split('/\s+/', $value, 2);
        parent::set('inv_firstname', $first);
        parent::set('inv_lastname', $last);
        break;
    default:
        parent::set($name, $value);
    }
}

// no URL
public function get_url()
{
    return sprintf("%s/", config('site_path'));
}

// indexes
public function create_indexes()
{
    $arr = array();
    $arr[] = sprintf(
        "CREATE UNIQUE INDEX inv_user_email ON %s (inv_user_id,inv_email)",
        $this->table_name());
    return $arr;
}

} // end class Invitation

?>
