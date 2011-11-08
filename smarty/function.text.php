<?php
// $Id: function.text.php,v 1.3 2006/05/03 01:31:48 glen Exp $
// Copyright (c)2004, Glen Campbell. All rights reserved.
//
// This defines the Smarty extension function {text name=XX}, which
// returns the value of the text block XX

//$PAGE->register_function('text', 'smarty_text');

// smarty_function_text - retrieve a staticuage string for the templates
function smarty_function_text($parms)
{
    $DB = Database::getReader();
    $s = new Text;
    $q = sprintf(
        "SELECT text_id FROM %s WHERE text_name='%s'",
        $s->table_name(),
        $parms['name']);
    $result = $DB->query($q);
    if ($DB->errno)
        abort(lang('err_db'), $DB->error);
    if ($result->num_rows)
    {
        list($id) = $result->fetch_row();
        $t = new Text($id);
        $text = $t->get('text_body');
    }
    else if (isset($parms['default']))
        $text = $parms['default'];
    else
        $text = sprintf("Text block [%s] not found", $parms['name']);
    return stripslashes($text);
}
?>