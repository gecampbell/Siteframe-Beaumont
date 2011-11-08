<?php
// $Id: Siteframe.class.inc,v 1.10 2005/02/26 20:38:47 glen Exp $
// Copyright (c)2004, Glen Campbell. All rights reserved.
//
// Siteframe is the base class from which all other classes are defined.
// It provides mechanisms for setting and validating properties as well as
// error-handling.

class Siteframe
{
private $errors = array();        // error messages
private $properties = array();    // name-value pairs

    // __construct() - create a new one
    public function __construct()
    {
        $this->set('__version__', SITEFRAME_VERSION);
    }

    // the object is valid if it has no errors
    function is_valid()
    {
        return !count($this->errors);
    }

    // add_error(msg[, parameters...])
    public function add_error($msg, $p1='', $p2='', $p3='', $p4='', $p5='')
    {
        $this->errors[] = sprintf($msg, $p1, $p2, $p3, $p4, $p5);
    }

    // get_errors() - returns all error messages
    public function get_errors($sep="<br />\n")
    {
        return implode($sep, $this->errors);
    }

    // num_errors() - returns count of errors
    public function num_errors()
    {
        return count($this->errors);
    }

    // set(name, value) - set a property
    public function set($name, $value='')
    {
        if (is_array($name))
            foreach($name as $n => $v)
                $this->properties[$n] = $v;
        else
            $this->properties[$name] = $value;
    }

    // get(name) - return a property value
    public function get($name)
    {
        return $this->properties($name);
    }

    // get_all() - returns array of all properties
    public function get_all()
    {
        return $this->properties;
    }

    // reset_errors() - clear error list
    public function reset_errors()
    {
        $this->errors = array();
    }

} // end class Siteframe
?>
