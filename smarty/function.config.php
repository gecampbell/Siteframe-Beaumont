<?php
// $Id: function.config.php,v 1.1 2005/11/22 22:33:30 glen Exp $
// Copyright (c)2004, Glen Campbell. All rights reserved.
//
// This defines the Smarty extension function {config name=XX}, which
// returns the value of the configuration variable XX

// smarty_function_config - retrieve a configuration parameter for the templates
function smarty_function_config($parms)
{
    global $PAGE;
    if (isset($parms['assign'])) {
        $PAGE->assign($parms['assign'], config($parms['name'], $parms['default']));
        return '';
    }
    else
        return config($parms['name'], $parms['default']);
}
?>