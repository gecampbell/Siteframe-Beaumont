<?php
// $Id: Plugin.class.inc,v 1.5 2005/03/11 03:11:45 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.
//
// The Plugin class defines an API for extending the base functionality
// of Siteframe Beaumont. Note that a "plugin" object is not created; the
// class methods are used instead:
//
// Plugin::add_property(class, name, definition)

class Plugin
{

// constructor not allowed - causes a fatal error
public function __construct()
{
    abort(lang('err_noplugin'));
}

// add_property(class, name, definition)
// adds a new property 'name' to 'class' with 'definition'
public function add_property($class, $name, $definition)
{
    global $__PROPERTIES;
    $__PROPERTIES[$class][$name] = $definition;
}

// get_properties(class)
// returns an array of properties for class
public function get_properties($class)
{
    global $__PROPERTIES;
    if (is_array($__PROPERTIES[$class]))
        return $__PROPERTIES[$class];
    else
        return array();
}

// add_event(class, event, function)
public function add_event($class, $event, $function)
{
    global $__EVENTS;
    $__EVENTS[$class][$event][] = $function;
}

// do_events(obj, event)
public function do_events(&$obj, $event)
{
    global $__EVENTS;
    $class = get_class($obj);
    if (is_array($__EVENTS[$class][$event]))
        foreach($__EVENTS[$class][$event] as $function)
            $function($obj);
}

// add_filter(class, field, function)
public function add_filter($class, $field, $function)
{
    global $__FILTERS;
    $__FILTERS[$class][$field][] = $function;
}

// register_template_function
// this adds a smarty template function
public function register_template_function($name, $function)
{
    global $PAGE;
    $PAGE->register_function($name, $function);
}

// register_template_block
public function register_template_block($name, $function)
{
    global $PAGE;
    $PAGE->register_block($name, $function);
}

// do_filters(obj, field, value)
public function do_filters(&$obj, $field, $value)
{
    $filt = $__FILTERS[get_class($obj)][$field];
    
    // if not set, just return the original value
    if (!is_array($filt))
        return $value;

    // if it is an array, process each function
    foreach($filt as $fcn)
    {
        if (!function_exists($fcn))
            abort(lang('err_nofilter'), $field, $fcn);
        $value = $fcn($value);
    }
    return $value;
}

} // end class Plugin

?>