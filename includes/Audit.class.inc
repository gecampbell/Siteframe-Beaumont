<?php
// $Id: Audit.class.inc,v 1.10 2006/05/17 05:23:38 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.
//
// The Audit class creates an audit trail. Note that this is normally used as
// a class function, and not as an object:
//    Audit::message('Added user %s', $user_name);

class Audit extends DataObject
{
public $table = 'audit_log';
public $key = 'log_id';
public $metadata = array(
    'log_id' => array(
        'col' => true,
        'type' => 'integer',
        'auto_increment' => true,
        'required' => true,
        'internal' => true
    ),
    'log_time' => array(
        'col' => true,
        'type' => 'datetime',
        'required' => true,
        'internal' => true
    ),
    'log_user' => array(
        'col' => true,
        'type' => 'integer',
        'required' => true,
        'internal' => true,
        'index' => true,
    ),
    'log_ip' => array(
        'col' => true,
        'type' => 'text',
        'maxlength' => 15,
        'required' => true,
        'index' => true,
    ),
    'log_module' => array(
        'col' => true,
        'type' => 'text',
        'maxlength' => 30,
        'required' => true,
        'internal' => true,
        'index' => true,
    ),
    'log_msg' => array(
        'col' => true,
        'type' => 'text',
        'maxlength' => 250,
        'required' => true,
        'internal' => true,
    ),
);

// message - write a message to the audit log
function message($text, $p1='', $p2='', $p3='', $p4='', $p5='')
{
    if (is_object($_SESSION['user']))
        $user = $_SESSION['user']->id();
    else
        $user = 0;
    $outmsg = sprintf($text, $p1, $p2, $p3, $p4, $p5);
	if ($fname = config('audit_log_file'))
	{
		$fp = fopen($fname, 'a');
		if (!fp) abort('Unable to open audit log file [%s]', $fname);
		$msg = sprintf(
			"%s:%d:%s:%s:%s\n",
			date('Y-m-d H:I:S'),
			$user,
			$_SERVER['REMOVE_ADDR'],
			basename($_SERVER['SCRIPT_NAME']),
			$outmsg
		);
		fwrite($fp, $msg);
		fclose($fp);
	}
	else 
	{
	    $DB = Database::getWriter();
	    $q = sprintf(
	        "INSERT INTO %s (log_time,log_user,log_ip,log_module,log_msg) VALUES ".
	        "(NOW(), %d, '%s', '%s', '%s')",
	        self::table_name(),
	        $user,
	        $_SERVER['REMOTE_ADDR'],
	        basename($_SERVER['SCRIPT_NAME']),
	        addslashes($outmsg)
	    );
	    $DB->query($q);
	    if ($DB->errno)
	        abort($DB->error);
	}
}

// get_all() - add user info
public function get_all()
{
    $arr = parent::get_all();
    $u = new User($this->get('log_user'));
    $arr['user'] = $u->get_all();
    return $arr;
}

} // end class Audit

?>
