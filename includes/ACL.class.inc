<?php
// $Id: ACL.class.inc,v 1.3 2005/12/11 22:30:54 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.

class ACL extends DataObject
{
public $table = 'folder_access_list';
public $metadata = array(
    'acl_folder_id' => array(
        'col' => TRUE,
        'type' => 'integer',
        'required' => TRUE,
        'internal' => TRUE,
        'index' => TRUE,
        'references' => 'Folder.folder_id',
    ),
    'acl_user_id' => array(
        'col' => TRUE,
        'type' => 'integer',
        'required' => TRUE,
        'internal' => TRUE,
        'index' => TRUE,
        'references' => 'User.user_id',
    ),
);

} // end class ACL

?>