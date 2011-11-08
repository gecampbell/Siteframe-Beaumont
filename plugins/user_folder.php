<?php
// $Id: user_folder.php,v 1.2 2005/03/01 12:50:58 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.
//
// This plugin, if enabled, will automatically create a user folder
// for each new user.

Plugin::add_event('User', 'add', 'user_folder_auto_create');

// this is the function that automatically creates the user's folder
function user_folder_auto_create(&$user)
{
    // build the folder
    $f = new Folder;
    $f->set('folder_user_id', $user->id());
    $f->set('folder_title', $user->get('user_name'));
    $f->set('folder_view', 'blog');
    $f->set('folder_theme', config('default_site_templates'));
    
    // return errors to the user object
    $f->add();
    if (!$f->is_valid())
        $user->add_error($f->get_errors());
}
?>
