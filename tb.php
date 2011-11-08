<?php
// $Id: tb.php,v 1.3 2005/12/31 23:43:26 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.
// This implements a Trackback receiver

require_once 'siteframe.inc';

// returns the response document
function tb_response($code, $msg='')
{
    $doc = new DOMDocument('1.0', 'utf-8');
    $doc->formatOutput = TRUE;
    $root = $doc->appendChild($doc->createElement('response'));
    $code = sprintf('%d', $code);
    $root->appendChild($doc->createElement('error', $code));
    if ($msg!='')
        $root->appendChild($doc->createELement('message', $msg));
    return $doc->saveXML() . "\n";
}

// check for page=
if (!isset($_GET['page']))  
    die(tb_response(1, 'Page ID must be specified'));

$tb = new Trackback;
$tb->set('tb_page_id', $_GET['page']);

if (isset($_REQUEST['title']))
    $tb->set('tb_title', $_REQUEST['title']);

if (isset($_REQUEST['excerpt']))
    $tb->set('tb_excerpt', $_REQUEST['excerpt']);

if (isset($_REQUEST['url']))
    $tb->set('tb_url', $_REQUEST['url']);
else
    die(tb_response(1, 'URL is a required parameter'));

if (isset($_REQUEST['blog_name']))
    $tb->set('tb_blog_name', $_REQUEST['blog_name']);

// save the Trackback item
$tb->add();

// and return
if ($tb->is_valid())
    echo tb_response(0);
else
    echo tb_response(1, $tb->get_errors());
?>