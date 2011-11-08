<?php
// $Id: PageRating.class.inc,v 1.3 2006/05/03 01:31:48 glen Exp $
// Copyright(c)2005, Glen Campbell. All rights reserved.
// See LICENSE.txt for details.
//
// This is a class for testing the API interface

class PageRating extends DataObject
{
public $key = "id";
public $metadata = array(
    'id' => array(
        'type' => 'text',
    ),
    'NumRatings' => array(
        'type' => 'integer',
    ),
    'AverageRating' => array(
        'type' => 'text'
    ),
    'MinRating' => array(
        'type' => 'integer',
    ),
    'MaxRating' => array(
        'type' => 'integer',
    ),
    'MyRating' => array(
        'type' => 'integer',
    ),
    '__version__' => array(
        'type' => 'text',
        'value' => SITEFRAME_VERSION,
    ),
);

public function __construct($id='')
{
    $DB = Database::getReader();
    
    // save ID
    $this->set('id', $id);
    
    // get current user ID
    if (is_object($_SESSION['user']))
        $uid = $_SESSION['user']->id();
    else
        $uid = 0;
    
    // compute rating
    $r = new Rating;
    $p = new Page;
    if (is_numeric($id))
    {
        $q = sprintf(
            "SELECT COUNT(*),AVG(rate_rating),MIN(rate_rating),MAX(rate_rating)
             FROM %s
             WHERE rate_page_id=%d",
            $r->table_name(),
            $id);
        $q2 = sprintf(
            "SELECT rate_rating
             FROM %s
             WHERE rate_page_id=%d and rate_user_id=%d",
            $r->table_name(),
            $id,
            $uid);
    }
    else
    {
        $q = sprintf(
            "SELECT COUNT(*),AVG(rate_rating),MIN(rate_rating),MAX(rate_rating)
             FROM %s JOIN %s
             WHERE rate_page_id=page_id
               AND page_name='%s'",
            $r->table_name(),
            $p->table_name(),
            addslashes($id));
        $q2 = sprintf(
            "SELECT rate_rating
             FROM %s JOIN %s
             WHERE rate_page_id=page_id
               AND page_name='%s'
               AND rate_user_id=%d",
            $r->table_name(),
            $p->table_name(),
            addslashes($id),
            $uid);
    }
    $result = $DB->query($q);
    check_db($DB);
    list($num,$avg,$min,$max) = $result->fetch_array();
    $this->set('NumRatings',    sprintf('%d', $num));
    $this->set('AverageRating', sprintf('%.1f', $avg));
    $this->set('MaxRating',     sprintf('%d', $max));
    $this->set('MinRating',     sprintf('%d', $min));
    $result = $DB->query($q2);
    check_db($DB);
    list($rate) = $result->fetch_array();
    $this->set('MyRating',      sprintf('%d', $rate));
}

} // end class PageRating
?>