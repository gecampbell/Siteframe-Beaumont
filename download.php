<?php
// $Id: download.php,v 1.2 2005/08/26 05:30:24 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.
// This file tracks downloads

require_once 'siteframe.inc';

$f = new File($_GET['id']);
$f->set('num_downloads', $f->get('num_downloads') + 1);
$f->update();

header("Location: ".$f->get('file_path'));

?>