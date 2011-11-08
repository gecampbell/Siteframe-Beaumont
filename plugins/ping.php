<?php
// $Id: ping.php,v 1.10 2006/01/01 00:41:39 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.
//
// This plugin uses XML-RPC to "ping" one or more sites. It requires the PEAR
// XML-RPC library.
//
// To activate this plugin, in siteframe.ini set
//  ping_enable = On
//
// You can provide a list of sites to ping in the configuration variable
// ping_sites; this should be a space-separated list of URLs:
//  ping_sites = "http://ping.blo.gs/ http://rpc.technorati.com/rpc/ping"
//
// This would ping the two sites listed.
//
// TRACKBACK
// If Trackback is enabled (trackback_enable=On in siteframe.ini), then this
// module will automatically perform Trackback autodiscovery and ping sites
// references in URLs in Page objects. Trackback requires the CURL extension
// to PHP

// +++++++++++++++

// this file is provided as part of the PEAR XML-RPC library; you need to make
// sure that this file visible as part of the PHP include_path setting in your
// php.ini file.
require_once "XML/RPC.php";

define('PING_TIMEOUT', 5);  // in seconds

Plugin::add_event('Page', 'add', 'send_all_pings');

// is Trackback on?
if (config('trackback_enable') && function_exists('curl_init'))
    Plugin::add_event('Page', 'add', 'send_trackback_pings');

// this function sends a ping to a single site
function send_ping($host, $path, $port=80)
{
    global $AUDIT;

    
    // create the client
    $client = new XML_RPC_Client($path, $host, $port);
    
    // create the message
    $msg = new XML_RPC_Message('weblogUpdates.ping',
            array(
                new XML_RPC_Value(config('site_name'), 'string'),
                new XML_RPC_Value(config('site_url'), 'string')));

    // send the message and get the response
    $response = $client->send($msg, PING_TIMEOUT);
    
    // check response value
    if (!$response)
        $AUDIT->message("%s: communication error [%s, %s]", 
            basename(__FILE__), $host, $path);
    else if ($response->faultCode())
    {
        $AUDIT->message("%s: h=%s, Fault code=%s, reason=%s",
            basename(__FILE__), 
            $host, 
            $response->faultCode(), 
            $response->faultString());
    }
}

// this sends pings to all the servers specified in ping_sites
function send_all_pings(&$obj)
{
    global $AUDIT;

    $list = config('ping_sites');
    $sites = explode(' ', $list);
    foreach($sites as $site)
    {
        $AUDIT->message("pinging %s...", $site);
        $info = parse_url($site);
        send_ping($info['host'], $info['path']);
    }
}

// send_trackback_pings
function send_trackback_pings(&$obj)
{
    global $AUDIT;

    // get the page text
    $text = $obj->get('page_text');
    
    // look at all URLs
    if (preg_match_all('/\<a\s+href="([^"]+)"/i', $text, $m))
    {
        $fields  = 'url='.urlencode(config('site_url_base').$obj->get_url());
        $fields .= '&title='.urlencode($obj->get_title());
        $fields .= '&blog_name='.urlencode(config('site_name'));
        $fields .= '&excerpt='.urlencode(substr(strip_tags($text), 0, 200));
        foreach($m[1] as $url)
        {
            $remote = @file_get_contents($url);
            if (preg_match('/trackback:ping="([^"]+)"/', $remote, $matches))
            {
                $ping_url = $matches[1];
                $ch = curl_init($ping_url);
                curl_setopt($ch, CURLOPT_POST, TRUE);
                curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);
                curl_setopt($ch, CURLOPT_POSTFIELDS, $fields);
                curl_setopt($ch, CURLOPT_TIMEOUT, 2);
                $result = curl_exec($ch);
                if (curl_errno($ch))
                    $AUDIT->message('%s, Trackback failed: %d/%s',
                        $ping_url,
                        curl_errno($ch), 
                        curl_error($ch));
                else
                    $AUDIT->message('Successful trackback to %s', $ping_url);
            }
        }
    }
}

?>
