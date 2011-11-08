<?php
// $Id: GroupUserRel.class.inc,v 1.4 2006/05/03 01:31:48 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.

class GroupUserRel extends DataObject
{
public $table = 'group_users';
public $metadata = array(
    'r_group_id' => array(
        'col' => true,
        'type' => 'integer',
        'required' => true,
        'internal' => true,
        'index' => true,
        'references' => 'Group.group_id',
    ),
    'r_user_id' => array(
        'col' => true,
        'type' => 'integer',
        'required' => true,
        'internal' => true,
        'index' => true,
        'references' => 'User.user_id',
    ),
);

// delete member from group
public function delete()
{
    $DB = Database::getWriter();

    $q = sprintf(
        "DELETE FROM %s WHERE r_group_id=%d AND r_user_id=%d",
        $this->table_name(),
        $this->get('r_group_id'),
        $this->get('r_user_id'));
    $DB->query($q);
    check_db($DB);
}

// create unique index on two columns
public function create_indexes()
{
    $arr = array();
    $arr[] = sprintf(
        "CREATE UNIQUE INDEX %s_g_u_ndx ON %s (r_group_id, r_user_id)",
        $this->table_name(),
        $this->table_name());
    return $arr;
}

// get a title
public function get_title()
{
    $g = new Group($this->get('r_group_id'));
    $u = new User($this->get('r_user_id'));
    return sprintf('%s in %s', $u->get_title(), $g->get_title());
}

} // end class GroupUserRel

?>