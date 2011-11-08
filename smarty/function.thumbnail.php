<?php
// $Id: function.thumbnail.php,v 1.3 2005/12/24 22:56:28 glen Exp $
// Copyright (c)2004, Glen Campbell. All rights reserved.

// smarty_function_thumbnail(parms)
// returns the name of a thumbnail image
function smarty_function_thumbnail($parms)
{
    global $PAGE;

    extract($parms); // file= and size= and type= and rotate=

    if (!file_exists($parms['file']))
        abort('image file [%s] does not exist', $parms['file']);
    else
    {
        // check for size
        if (!isset($size))
        {
            list($w,$h,$oldtype,$attr) = GetImageSize($file);
            if (!isset($maxw))
                $maxw = $w;
            if (!isset($maxh))
                $maxh = $h;
            // for a vertical picture
            if ($w > $h)
            {
                if ((($maxh/$h)*$w) > $maxw)
                    $size = $maxw;
                else
                    $size = round(($maxh/$h)*$w);
            }
            else
            {
                if ((($maxw/$w)*$h) > $maxh)
                    $size = $maxh;
                else
                    $size = round(($maxw/$w)*$h);
            }
        }
        // resize the file
        $thumbnail = resize_image($file, $type, $size, $rotate, $center);
        
        // set params
        $size = GetImageSize($thumbnail);
        $PAGE->assign('im_w', $size[0]);
        $PAGE->assign('im_h', $size[1]);

        return sprintf('%s/%s', config('site_path'), $thumbnail);
    }
}

?>