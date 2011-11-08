<?php
// $Id: Rating.class.inc,v 1.14 2006/05/03 01:31:48 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.

class Rating extends DataObject
{
public $table = 'ratings';
public $key = 'rate_id';
public $owner = "rate_user_id";
public $metadata = array(
    'rate_id' => array(
        'col' => true,
        'type' => 'integer',
        'auto_increment' => true,
        'required' => true,
        'hidden' => true,
    ),
    'rate_page_id' => array(
        'col' => true,
        'type' => 'integer',
        'required' => true,
        'hidden' => true,
        'references' => 'Page.page_id',
    ),
    'rate_user_id' => array(
        'col' => true,
        'type' => 'integer',
        'required' => true,
        'internal' => true,
        'references' => 'User.user_id',
    ),
    'rate_rating' => array(
        'col' => true,
        'type' => 'select',
        'sqltype' => 'INTEGER',
        'options' => array(1=>'1', 2=>'2', 3=>'3', 4=>'4', 5=>'5'),
        'required' => true,
        'min' => 1,
        'max' => 5,
    ),
);

// add()  - only allow one rating per user
public function add()
{
    $this->delete();
    parent::add();
}

// delete
public function delete()
{
    global $AUDIT;
    $DB = Database::getWriter();
    $q = sprintf(
        "DELETE FROM %s WHERE rate_page_id=%d AND rate_user_id=%d",
        $this->table_name(),
        $this->get('rate_page_id'),
        $this->get('rate_user_id'));
    @$DB->query($q);    // we don't care about the result
    $AUDIT->message("Deleted rating: %d/%d",
        $this->get('rate_page_id'),
        $this->get('rate_user_id'));
}

// create_indexes() - build other indexes
public function create_indexes()
{
    $arr[] = sprintf(
        "CREATE UNIQUE INDEX rate_ndx ON %s (rate_page_id, rate_user_id)",
        $this->table_name());
    return $arr;
}

// get a URL
public function get_url()
{
    $obj = new Page($this->get('rate_page_id'));
    return $obj->get_url();
}

} // end class Tag

?>