<?php
// $Id: user_editor.php,v 1.1 2005/11/05 04:51:36 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.
// This plugin allows the user to select a specific rich-text editor

Plugin::add_property('User', 'user_editor', array(
    'type' => 'select',
    'options' => array(
        0 => 'Use site default',
        'none' => 'No editor',
        'widg' => 'widgEditor',
        'fck'  => 'fckEdit'
    ),
    'prompt' => 'Rich-Text Editor',
    'advanced' => TRUE,
    'help' => 'Select a rich-text editor for use with formatted text fields',
));

?>