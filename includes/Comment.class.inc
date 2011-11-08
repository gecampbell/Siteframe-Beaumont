<?php
// $Id: Comment.class.inc,v 1.26 2006/05/03 01:31:48 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.

class Comment extends DataObject
{
public $table = 'comments';
public $key = 'comment_id';
public $owner = 'comment_user_id';
public $obj_props = 'comment_props';
public $created = 'comment_created';
public $modified = 'comment_modified';
public $fulltext = array('comment_subject', 'comment_text');
public $metadata = array(
    'comment_id' => array(
        'col' => TRUE,
        'type' => 'integer',
        'auto_increment' => TRUE,
        'required' => TRUE,
        'hidden' => TRUE,
    ),
    'comment_user_id' => array(
        'col' => TRUE,
        'type' => 'integer',
        'required' => TRUE,
        'hidden' => TRUE,
        'index' => TRUE,
        'references' => 'User.user_id',
    ),
    'comment_page_id' => array(
        'col' => TRUE,
        'type' => 'integer',
        'required' => TRUE,
        'hidden' => TRUE,
        'references' => 'Page.page_id',
    ),
    'comment_reply_to' => array(
        'col' => TRUE,
        'type' => 'integer',
        'index' => TRUE,
        'hidden' => TRUE
    ),
    'comment_created' => array(
        'col' => TRUE,
        'type' => 'datetime',
        'required' => TRUE,
        'internal' => TRUE,
        'noupdate' => TRUE,
        'index' => TRUE,
    ),
    'comment_modified' => array(
        'col' => TRUE,
        'type' => 'datetime',
        'required' => TRUE,
        'internal' => TRUE,
    ),
    'comment_subject' => array(
        'col' => TRUE,
        'type' => 'text',
        'maxlength' => 250,
        'required' => TRUE,
        'size' => 30,
    ),
    'comment_text' => array(
        'col' => FALSE,
        'type' => 'textarea',
        'formatted' => TRUE,
        'rows' => 10,
    ),
);
public $querystring='';

// optimized constructor
public function __construct($id=0, $row=array())
{
    if ($id)
    {
        $u = new User;
        $this->querystring = sprintf(
            "SELECT * FROM %s cmt ".
            "LEFT OUTER JOIN %s user ON (cmt.comment_user_id=user.user_id) ".
            "WHERE comment_id=%d",
            $this->table_name(),
            $u->table_name(),
            $id
        );
    }
    parent::__construct($id, $row);
}

// specialized form
public function form()
{
    global $PAGE;
    $PAGE->assign("class", get_class($this));
    return parent::form(
        'commentform',
        $this->get_edit_url(),
        'post',
        lang('prompt_save_comment')
    );
}

// add() - notify owner of comments
public function add()
{
    global $PAGE;
    parent::add();
    
    // send notification e-mail
    if ($this->is_valid())
    {
        // send notification e-mail
        $obj = new Page($this->get('comment_page_id'));
        // get object owner
        $u = new User($obj->owner());
        if ($u->get('email_comments') || (config('comment_email_addr') != ''))
        {
            // assign all properties
            $PAGE->assign($this->get_all());
            $PAGE->assign('class', $class);
            $PAGE->assign($obj->get_all());
            // build and send the e-mail
            $em = new HtmlEmail($this->get('comment_subject'));
            if ($u->get('email_comments'))
                $em->to($u->get('user_email'));
            if (config('comment_email_addr') != '')
                $em->to(config('comment_email_addr'));
            $em->send_template(site_template('comment_notice'));
        }
    }
}

// delete - needs to update threaded comments
public function delete()
{
    $DB = Database::getWriter();
    
    $q = sprintf(
        "UPDATE %s SET comment_reply_to=%d WHERE comment_reply_to=%d",
        $this->table_name(),
        $this->get('comment_reply_to'),
        $this->id());
    $DB->query($q);
    check_db($DB);
    
    parent::delete();
}

// get_url() - the URL is of the page
public function get_url()
{
    $obj = new Page($this->get('comment_page_id'));
    return $obj->get_url();
}

// title
public function get_title()
{
    return $this->get('comment_subject');
}

} // end class File

?>