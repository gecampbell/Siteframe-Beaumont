<?php
// $Id: CommentList.class.inc,v 1.5 2006/05/03 01:31:48 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.

class CommentList
{

// comments() - return all comments for the page
public function comments($id)
{
    $DB = Database::getReader();

    $arr = array();

    $c = new Comment;
    $q = sprintf(
        "SELECT comment_id FROM %s ".
        "WHERE AND comment_page_id=%d ".
        "ORDER BY comment_created",
        $c->table_name(),
        $id
    );

    $result = $DB->query($q);
    check_db($DB);

    while(list($id) = $result->fetch_row())
    {
        $c = new Comment($id);
        $arr[] = $c->get_all();
    }

    return $arr;
}

// threaded_comments - return all comments in threaded fashion
public function threaded_comments($page_id, $reply=0, $level=0)
{
    $DB = Database::getReader();
    
    $arr = array();
    
    $c = new Comment;
    $q = sprintf(
        "SELECT comment_id FROM %s ".
        "WHERE comment_page_id=%d ".
        "  AND comment_reply_to=%d ".
        "ORDER BY comment_created",
        $c->table_name(),
        $page_id,
        $reply
    );
    
    $result = $DB->query($q);
    check_db($DB);
    
    while(list($id) = $result->fetch_row())
    {
        $c = new Comment($id);
        $c->set('clevel', $level);
        $arr[] = $c->get_all();
        foreach(CommentList::threaded_comments($page_id, $id, $level+1) as $newc)
            $arr[] = $newc;
    }
    
    return $arr;
}

} // end class CommentList
?>