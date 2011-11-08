<?php
// $Id: delete.php,v 1.9 2005/12/02 05:09:24 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.

require_once 'siteframe.inc';

$PAGE->assign('page_title', lang('page_title_delete'));

if (!isset($_GET['c']))
{
    $PAGE->assign('error', lang('err_badqstring'));
    $PAGE->display();
    exit;
}

// create a new object
$class = $_GET['c'];
$obj = new $class($_GET['id']);

$PAGE->assign('page_title', lang('page_title_delete').' '.lang("class_$class"));

// are we authorized?
if (!$obj->authorized())
    $PAGE->assign('error', lang('err_notauth'));
else if ($_POST['_submitted'])
{
    $obj->delete();
    if ($obj->is_valid())
    {
        if ($_POST['r'] != '')
        {
            header('Location: '.$_POST['r']);
            exit;
        }
        $PAGE->assign('error', lang('msg_deleted'));
    }
    else
        $PAGE->assign('error', $obj->get_errors());
    $PAGE->display();
    exit;
}
else
{
    $inf = new InputForm(
        'delete',
        $obj->get_delete_url(),
        'post',
        lang('delete')
    );
    $inf->add_item('obj_id', array(
        'type' => 'number',
        'hidden' => true,
        'value' => $obj->id(),
    ));
    $inf->add_item('obj_title', array(
        'type' => 'text',
        'size' => 40,
        'disabled' => true,
        'value' => $obj->get_title(),
        'prompt' => lang($class),
    ));
    $inf->add_item('r', array(
        'type' => 'text',
        'hidden' => true,
        'value' => $_GET['r']
    ));
    $PAGE->assign('edit_form', $inf->get_form());
}

$PAGE->assign('help_text', lang('help_delete'));
$PAGE->assign('class', $class);
$PAGE->display();
?>