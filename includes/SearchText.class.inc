<?php
// $Id: SearchText.class.inc,v 1.4 2006/05/03 01:31:48 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.

class SearchText extends DataObject
{
public $table = 'search_text';
public $metadata = array(
    'obj_class' => array(
        'col' => true,
        'type' => 'text',
        'maxlength' => 10,
        'required' => true,
        'internal' => true,
    ),
    'obj_id' => array(
        'col' => true,
        'type' => 'integer',
        'required' => true,
        'internal' => true,     // does not appear on form
    ),
    'obj_text' => array(
        'col' => true,
        'type' => 'textarea',
        'required' => true,
        'internal' => true,
    ),
);
public $engine = "MyISAM";

// update
public function update()
{
    $DB = Database::getWriter();
    $q = sprintf(
        "UPDATE %s SET obj_text='%s' WHERE obj_class='%s' AND obj_id=%d",
        $this->table_name(),
        addslashes($this->get('obj_text')),
        $this->get('obj_class'),
        $this->get('obj_id')
    );
    $DB->query($q);
    check_db($DB);
}

// delete
public function delete()
{
    $DB = Database::getWriter();
    $q = sprintf(
        "DELETE FROM %s WHERE obj_class='%s' AND obj_id=%d",
        $this->table_name(),
        $this->get('obj_class'),
        $this->get('obj_id')
    );
    $DB->query($q);
    check_db($DB);
}

// create_indexes
public function create_indexes()
{
    $arr = array();
    $arr[] = sprintf("CREATE UNIQUE INDEX search_ndx ON %s (obj_class, obj_id)",
                $this->table_name());
    $arr[] = sprintf("CREATE FULLTEXT INDEX search_full_ndx on %s (obj_text)",
                $this->table_name());
    return $arr;
}

// visible title
public function get_title()
{
    return sprintf("Search text for %s=%d", 
            $this->get('obj_class'),
            $this->get('obj_id'));
}

} // end class Search

?>