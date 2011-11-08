<?php
// $Id: function.numcomments.php,v 1.3 2006/05/03 01:31:48 glen Exp $
// Copyright (c)2004, Glen Campbell. All rights reserved.
//
// usage:
//  {num_comments class=Page id=12}

// smarty_function_numcomments - returns the number of comments for a page
function smarty_function_numcomments($parms)
{
    $DB = Database::getReader();

    extract($parms);

    $c = new Comment;
    $q = sprintf(
        "SELECT COUNT(*) FROM %s ".
        "WHERE comment_page_id=%d",
        $c->table_name(),
        $id);
    $result = $DB->query($q);
    check_db($DB);
    list ($num) = $result->fetch_row();
    return $num;
}

?>