<?php
// $Id: TopRatedPages.class.inc,v 1.1 2006/01/03 05:13:32 glen Exp $
// Copyright (c)2006, Glen Campbell. All rights reserved.
// See LICENSE.txt for details
//
// TopRatedPages returns a list of the N top-rated pages in a specified date
// range (begin and end dates)

final class TopRatedPages extends Query
{

// build the query
public function __construct($num=20, $begin="'2001-01-01 00:00'", $end="'2031-12-31 23:59'")
{
    $rat = new Rating;
    $pag = new Page;
    $q = sprintf(
        'SELECT rate_page_id,AVG(rate_rating) 
         FROM %s JOIN %s ON (rate_page_id=page_id)
         WHERE page_created BETWEEN %s AND %s
         GROUP BY rate_page_id
         ORDER BY 2 DESC, page_id
         LIMIT %d',
        $rat->table_name(),
        $pag->table_name(),
        $begin,
        $end,
        $num
    );
    parent::__construct('Page', $q);
}

} // end class TopRatedPages

?>