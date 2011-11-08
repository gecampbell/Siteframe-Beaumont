<?php
// $Id: Ping.class.inc,v 1.4 2005/12/19 04:30:32 glen Exp $
// Copyright(c)2005, Glen Campbell. All rights reserved.
// See LICENSE.txt for details.
//
// This is a class for testing the API interface

class Ping extends ReadOnly
{
public $key = "id";
public $metadata = array(
    'id' => array(
        'type' => 'text',
    ),
    'Status' => array(
        'type' => 'integer',
        'value' => 1,
    ),
    'LocalTime' => array(
        'typt' => 'text',
    ),
    'Message' => array(
        'type' => 'text',
        'value' => 'Service is active'
    ),
);

public function __construct($id='')
{
    $this->set('id', $id);
    $this->set('Message', $id);
    $this->set('LocalTime', strftime('%Y-%m-%d %H:%I:%S %Z'));
    $this->set('__version__', SITEFRAME_VERSION);
}

// no URL
public function get_url() { return ''; }

} // end class Ping
?>