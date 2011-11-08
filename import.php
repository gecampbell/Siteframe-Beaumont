<?php
// $Id: import.php,v 1.3 2005/11/17 07:43:20 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.

require_once 'siteframe.inc';

$PAGE->assign('page_title', lang('page_title_import'));

// check to see that the user is logged in
if (is_object($_SESSION['user']) && $_SESSION['user']->id())
    ;
else {
    header('Location: login.php?rd='.urlencode($_SERVER['REQUEST_URI']));
    exit;
}

if ($_POST['_submitted'])
{
    $file = $_FILES['xml_file'];
    switch($file['error'])
    {
    case 0: // file is valid!
        if ($file['size'] == 0)
            $PAGE->assign('error', sprintf(lang('err_upload_empty'), $file['name']));
        else
        {
            $xml = simplexml_load_file($file['tmp_name']);
            foreach($xml->objects as $obj)
            {
                $class = (string) $obj->object->class;
                $newobj = new $class();
                foreach($obj->object->properties->children() as $name => $value)
                    $newobj->set($name, $value);
                $newobj->set('page_folder_id', $_POST['import_folder_id']);
                $newobj->add();
                if (!$newobj->is_valid())
                {
                    $PAGE->assign('error', $newobj->get_errors());
                    ++$errors;
                    break;
                }
                else
                    $success[] = $class.': '.$newobj->get_title();
            }
        }
        if (!$errors)
            $PAGE->assign('error', "Imported: <br />\n".
                implode("<br />\n", $success));
        break;
    case 1:
        $PAGE->assign('error', sprintf(lang('err_upload_ini_max'), $file['name']));
        break;
    case 2:
        $PAGE->assign('error', sprintf(lang('err_upload_max'), $file['name']));
        break;
    case 3:
        $PAGE->assign('error', sprintf(lang('err_upload_partial'), $file['name']));
        break;
    case 4:
        $PAGE->assign('error', sprintf(lang('err_upload_nofile'), $file['name']));
        break;
    case 6:
        $PAGE->assign('error', sprintf(lang('err_upload_notemp'), $file['name']));
        break;
    }
}

// create the input form
$p = new Page;
$inf = new InputForm(
    'edit_form',                   // name of form
    $_SERVER['SCRIPT_NAME'],    // action
    'post',                     // method
    lang('prompt_import')       // main Submit prompt
);
$inf->add_item('xml_file', array(
    'type' => 'file',
    'required' => TRUE,
));
$inf->add_item('import_folder_id', array(
    'type' => 'select',
    'options' => $p->get_folder_list()
));
$inf->enctype = 'multipart/form-data';
$PAGE->assign('edit_form', $inf->get_form());

// display the page
$PAGE->display();
?>