<?php
// $Id: PageFactory.class.inc,v 1.2 2006/05/03 01:31:48 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.
// This is the Page factory class; it creates pages of various types.

class PageFactory
{

    // getPage - retrieves a specified page type
    public function getPage($id, $arr=array())
    {
        $DB = Database::getReader();
        
        // if an ID is specified, we need to query the database
        // otherwise, we use the array
        if ($id)
        {
            $p = new Page;
            $q = sprintf(
                "SELECT * FROM %s WHERE %s=%d",
                $p->table_name(),
                $p->key,
                $id
            );
            $result = $DB->query($q);
            check_db($DB);
            $arr = $result->fetch_assoc();
        }
        $class = $arr['page_class'];
        return new $class(0, $arr);
    }
    
} // end class PageFactory
?>