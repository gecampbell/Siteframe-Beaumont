<?php
// $Id: advanced.php,v 1.1 2005/11/17 08:04:03 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.

require_once 'siteframe.inc';

$PAGE->assign('page_title', lang('page_title_advanced'));

// handle submitted forms
if ($_POST['_submitted'])
{
    $sstr = ''; // search string
    if ($_POST['search_any'] != '')
        $sstr .= $_POST['search_any'];
    if ($_POST['search_all'] != '')
    {
        $words = split(' ', $_POST['search_all']);
        foreach ($words as $word)
            $sstr .= ' +'.$word;
    }
    if ($_POST['search_exact'] != '')
        $sstr .= ' "' . $_POST['search_exact'] . '"';
    if ($_POST['search_exclude'] != '')
    {
        $words = split(' ', $_POST['search_exclude']);
        foreach ($words as $word)
            $sstr .= ' -'.$word;
    }
    $query = sprintf(
        '%s/search.php?q=%s', 
        config('site_path'), 
        urlencode(trim($sstr))
    );
    header('Location: '.$query);
    exit;
}

// build the input form
$inf = new InputForm(
    'asearch', 
    $_SERVER['SCRIPT_NAME'], 
    'post', 
    lang('prompt_search')
);
$inf->add_item('search_any',  array(
    'type' => 'text',
    'size' => 30,
));
$inf->add_item('search_all', array(
    'type' => 'text',
    'size' => 30,
));
$inf->add_item('search_exact',  array(
    'type' => 'text',
    'size' => 30,
));
$inf->add_item('search_exclude',  array(
    'type' => 'text',
    'size' => 30,
));

$PAGE->assign('edit_form', $inf->get_form());
$PAGE->display();
?>