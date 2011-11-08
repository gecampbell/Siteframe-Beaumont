<?php
// $Id: edit_file.inc,v 1.1 2005/11/21 03:09:18 glen Exp $
// Copyrigth (c)2005, Glen Campbell. All rights reserved.
//
// MODULE(Edit file)

$PAGE->assign('page_title', 'Text File Editor');

// if submitted, then save the file changes
if ($_POST['_submitted']) // file is modified
{
    // save 3 old versions of a file
    @unlink($_GET['file'].'.3');
    @rename($_GET['file'].'.2', $_GET['file'].'.3');
    @rename($_GET['file'].'.1', $_GET['file'].'.2');
    @rename($_GET['file'], $_GET['file'].'.1');
    $numbytes = @file_put_contents($_GET['file'], $_POST['body']);
    if ($numbytes != strlen($_POST['body']))
        $PAGE->assign('error', 'Error writing file; probably permissions');
}

// if file is specified, edit it, otherwise request the file
if ($_GET['file'])
{
    if (!$_POST['_submitted'])
        $PAGE->assign('error', 'Editing '.$_GET['file']);
    $inf = new InputForm('editor', $_SERVER['REQUEST_URI'], 'post', 'Save');
    $inf->add_item('body', array(
        'type' => 'textarea',
        'rows' => 30,
        'prompt' => $_GET['file'],
        'help' => 'Please be careful; it\'s possible to damage your website with this.',
        'value' => @file_get_contents($_GET['file']),
    ));
    $PAGE->assign('help_text', 
        "This feature is provided as an emergency measure only, and should
        not be a substitute for offline editing and testing. Please be very
        careful, since it is possible to severely damage your site by editing
        files in this manner. Please note that, to use this editor, your
        webserver process (e.g., apache, nobody) must be able to write to
        the files and directories in use. The last three versions of files
        edited are saved in case you need to recover from an error that you
        yourself caused.");
}
else
{
    $inf = new InputForm('editfile', $_SERVER['REQUEST_URI'], 'get', 'Select');
    $inf->add_item('module', array(
        'type' => 'text',
        'hidden' => TRUE,
        'value' => __FILE__
    ));
    $inf->add_item('file', array(
        'type' => 'text',
        'size' => 40,
        'prompt' => 'File name',
        'help' => 'Enter the name of the file to be edited, relative to the site root directory',
    ));
    $PAGE->assign('help_text', 
        'Enter the name of a file to edit, relative to the root directory of
        this website.');
}

$PAGE->assign('admin_content', $inf->get_form());
?>