<?php
// $Id: UserLog.class.inc,v 1.11 2006/06/18 03:44:07 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.
//
// this creates the user_log_raw table - note that this is intended to 
// optimize INSERT performance; none of the columns are NOT NULL, and none
// of them are indexed. This should make INSERT statements run faster than
// they would otherwise.
//
// Usage:
//  $log = new UserLog;
//  $log->add();
//
// The constructor loads all the necessary data

class UserLog extends DataObject
{
public $table = 'user_log_raw';
public $created = "log_created";
public $engine = "ARCHIVE";
public $metadata = array(
    'log_user_id' => array(
        'col' => true,
        'type' => 'integer',
        'internal' => true,
        'required' => TRUE,
    ),
    'log_b_cookie' => array(
        'col' => true,
        'type' => 'text',
        'maxlength' => 40,
    ),
    'log_created' => array(
        'col' => true,
        'type' => 'datetime',
        'internal' => true,
    ),
    'log_script' => array(
        'col' => true,
        'type' => 'text',
        'maxlength' => 250,
        'internal' => true,
    ),
    'log_server_protocol' => array(
        'col' => true,
        'type' => 'text',
        'maxlength' => 10,
        'internal' => true,
    ),
    'log_request_method' => array(
        'col' => true,
        'type' => 'text',
        'maxlength' => 5,
        'internal' => true,
    ),
    'log_referer' => array(
        'col' => true,
        'type' => 'text',
        'maxlength' => 250,
        'internal' => true,
    ),
    'log_user_agent' => array(
        'col' => true,
        'type' => 'text',
        'maxlength' => 250,
        'internal' => true,
    ),
    'log_remote_addr' => array(
        'col' => true,
        'type' => 'text',
        'maxlength' => 15,
        'internal' => true,
    ),
    'log_remote_host' => array(
        'col' => true,
        'type' => 'text',
        'maxlength' => 250,
        'internal' => true,
    ),
    'log_request_uri' => array(
        'col' => true,
        'type' => 'text',
        'maxlength' => 250,
        'internal' => true,
    ),
);

// constructor should load record from $_SERVER
public function __construct()
{
    if (is_object($_SESSION['user']))
        $this->set('log_user_id', $_SESSION['user']->id());
    if (isset($_COOKIE[BEAUMONT_COOKIE]))
        $this->set('log_b_cookie', $_COOKIE[BEAUMONT_COOKIE]);
    $this->set('log_script',            $_SERVER['SCRIPT_NAME']);
    $this->set('log_server_protocol',   $_SERVER['SERVER_PROTOCOL']);
    $this->set('log_request_method',    $_SERVER['REQUEST_METHOD']);
    $this->set('log_referer',           $_SERVER['HTTP_REFERER']);
    $this->set('log_user_agent',        $_SERVER['HTTP_USER_AGENT']);
    $this->set('log_remote_addr',       $_SERVER['REMOTE_ADDR']);
    $this->set('log_remote_host',       $_SERVER['REMOTE_HOST']);
    $this->set('log_request_uri',       $_SERVER['REQUEST_URI']);
}

// add() - add the log record, but without audit logging
public function add()
{
	if ($fname = config('user_log_file'))
	{
		$fp = fopen($fname, 'a');
		$msg = sprintf(
			"%d:%s:%s:%s:%s:%s:%s:%s:%s:%s\n",
			$this->get('log_user_id'),
			$this->get('log_b_cookie'),
			$this->get('log_script'),
			$this->get('log_server_protocol'),
			$this->get('log_request_method'),
			$this->get('log_referer'),
			$this->get('log_user_agent'),
			$this->get('log_remote_addr'),
			$this->get('log_remote_host'),
			$this->get('log_request_uri')
		);
		fwrite($fp, $msg);
		fclose($fp);
	}
    else
    	return parent::add(false);
}

} // end class UserLog

?>
