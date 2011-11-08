<?php
// $Id: function.textlink.php,v 1.2 2005/12/24 22:56:28 glen Exp $
// Copyright (c)2004, Glen Campbell. All rights reserved.

// smarty_function_textlink - build a URL for an adhoc text link
function smarty_function_textlink($parms)
{
    if (config('url_rewriting'))
        return sprintf('%s/adhoc/%s', config('site_path'), $parms['name']);
    else
        return sprintf('%s/text.php?id=%s', config('site_path'), $parms['name']);
}
?>