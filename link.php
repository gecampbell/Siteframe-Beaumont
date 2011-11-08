<?php
// $Id: link.php,v 1.2 2005/08/26 05:30:24 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.
//
// Simple redirector; tracks links

require_once 'siteframe.inc';

$link = new Link($_GET['id']);
$link->set('link_num_visits', $link->get('link_num_visits')+1);
$link->update();
if ($link->is_valid())
    header("Location: ".$link->get('link_url'));
else
    abort($link->get_errors());
?>