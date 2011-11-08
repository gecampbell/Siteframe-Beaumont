<?php
// $Id: edit.php,v 1.31 2006/04/25 18:54:02 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.

require_once 'siteframe.inc';

$PAGE->assign('page_title', lang('page_title_edit'));

// the ?c= parameter contains the class of the object to create or edit
if (!isset($_GET['c']))
{
    $PAGE->assign('error', lang('err_badqstring'));
    $PAGE->display();
    exit;
}
else
    $class = strip_tags($_GET['c']);

// create a new object
$obj = new $class(strip_tags($_GET['id']));

// require login
require_login();

// set _GET properties
foreach($_GET as $name => $value)
{
    switch($name)
    {
    case 'c':       // don't set these
    case 'id':
        break;
    default:
        $obj->set($name, $value);
    }
}

// check for valid object
if (($obj->get($obj->key)+0) != (strip_tags($_GET['id'])+0))
{
    $PAGE->assign('error', 'No object with that class/ID'); // TODO: use lang
    $PAGE->display();
    exit;
}

// reset title for existing objects
if ($obj->get($obj->key))
    $PAGE->assign('page_title', 
        sprintf(lang('page_title_edit'), $obj->get_title()));
else
    $PAGE->assign('page_title', 
        sprintf(lang('page_title_new'), lang("class_$class")));

// are we authorized?
if (!$obj->authorized())
{
    $PAGE->assign('error', lang('err_notauth'));
    $PAGE->display();
    exit;
}
else if ($_POST['_submitted'])
{
    // first, clear any existing errors
    // (these can prevent fixes from being saved)
    $obj->reset_errors();
    
    // assign all the POSTed variables to the object
    $obj->set_post($_POST);

    // check to see if we have an ID (update)
    if ($obj->id())
        $obj->update();
    else
        $obj->add();
    
    // now, check for validity
    if (!$obj->is_valid())
        $PAGE->assign('error', $obj->get_errors());
    else 
        header(sprintf('Location: %s%s', 
                config('site_url_base'), 
                $obj->get_url()));
}

if (!$obj->is_valid())
    $PAGE->assign('error', $obj->get_errors());

$PAGE->assign('obj', $obj->get_all());
$PAGE->assign('help_text', lang('help_'.get_class($obj)));
$PAGE->assign('class', get_class($obj));
$PAGE->assign('edit_form', $obj->form(
    'edit',
    $obj->get_edit_url(),
    'post'));

$PAGE->display();
?>
