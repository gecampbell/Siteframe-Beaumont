<?php
// $Id: function.lang.php,v 1.1 2005/11/22 22:33:30 glen Exp $
// Copyright (c)2004, Glen Campbell. All rights reserved.
//
// This defines the Smarty extension function {config name=XX}, which
// returns the value of the configuration variable XX

// smarty_function_lang - retrieve a language string for the templates
function smarty_function_lang($parms)
{
    return lang($parms['name']);
}
?>