<?php
// $Id: api.php,v 1.31 2006/05/03 01:31:48 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.
// This page implements the Siteframe Beaumont API

require_once 'siteframe.inc';

// definitions
define('API_VERSION', 1);

// error(#) - returns a standard error message
function error($code, $parm='', $http_status=0)
{
    // build the new DOM document
    $doc = new DOMDocument('1.0', config('charset'));
    $doc->formatOutput = TRUE;

    // compute the error token
    $token = sprintf('api_error_%d', $code);

    // add an <Error> wrapper
    $root = $doc->appendChild($doc->createElement('Error'));
    
    // <Code>
    $num = $root->appendChild($doc->createElement('Code'));
    $num->appendChild($doc->createTextNode($code));
    
    // <Message>
    $msg = $root->appendChild($doc->createElement('Message'));
    $msg->appendChild($doc->createTextNode(sprintf(lang($token), $parm)));
    
    // set status
    if ($http_status)
        header(sprintf('HTTP/1.1 %s', $http_status));
    
    // set Content-Type
    header('Content-Type: application/xml');

    // display error and halt
    die($doc->saveXML()."\n");
}

// set initial header to 500 in case of error
header('HTTP/1.0 500 Internal Server Error');

// is the API enabled?
if (!config('api_enable'))
    error(99, '', '403 Forbidden');

// version=, key=, and resource= are required parameters
if (!isset($_REQUEST['v']))
    error(101);
if ($_REQUEST['v'] != API_VERSION)
    error(102, $_REQUEST['v']);

// API key
if (config('api_key_required',TRUE)||(strtolower($_SERVER['REQUEST_METHOD'])!='get'))
{
    if (!isset($_REQUEST['key']))
        error(103);
    $user = new User;
    $q = sprintf("SELECT * FROM %s WHERE user_hash='%s'", 
            $user->table_name(),
            addslashes($_REQUEST['key']));
    $DB = Database::getReader();
    $r = $DB->query($q);
    check_db($DB);
    $arr = $r->fetch_assoc();
    $user = new User(0, $arr);
    if ((!$user->id()) || (!$user->is_valid()))
        error(104, $_REQUEST['key']);
    // need to track the uses of the key and disallow if over api_default_limit
}

// validate resource
if (!isset($_REQUEST['r']))
    error(105);
$class = $_REQUEST['r'];

// do we have an id= parameter?
if (isset($_REQUEST['id']))
{
    $obj = new $class($_REQUEST['id']);
    if (!$obj->id())
        error(106, $_REQUEST['id'], '404 Not Found');
}
else
    $obj = new $class();
    
// validate request method
$body = ''; // this is the output
switch(strtolower($_SERVER['REQUEST_METHOD']))
{
case 'delete':
    if (!isset($_REQUEST['id']))
        error(109, '', '400 Bad Request');
    $obj->delete();
    if ($obj->is_valid())
        header('HTTP/1.1 200 OK');
    else
        error(111, $obj->get_errors());
    break;

case 'get':
    //if (!isset($_REQUEST['id']))
    //    error(107, '', '400 Bad Request');
    $body = $obj->xml();
    header('HTTP/1.1 200 OK');
    break;

case 'post':
    $obj->set_post($_POST, $_FILES);
    if (isset($_REQUEST['id']))     // if set, we're doing an update
    {
        $obj->update();
        if ($obj->is_valid())
        {
            header('HTTP/1.1 200 OK');
            $body = $obj->xml();
        }
        else
            error(110, $obj->get_errors());
    }
    else                            // otherwise, we're adding the object
    {
        $obj->add();
        if ($obj->is_valid())
        {
            header('HTTP/1.1 200 OK');
            header('Location: '.config('site_url_base').$obj->get_url());
            exit;
        }
        else
            error(110, $obj->get_errors());
    }
    break;

default:
    header('HTTP/1.1 400 Bad Request');
}

if (isset($_REQUEST['rd']))
    header('Location: '.$_REQUEST['rd']);
else
{
    // set Content-Type
    header('Content-Type: application/xml');
    // return the XML
    echo $body;
}
?>
