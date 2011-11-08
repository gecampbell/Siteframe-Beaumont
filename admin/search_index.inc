<?php
// $Id: search_index.inc,v 1.1 2005/03/07 03:54:51 glen Exp $
// Copyrigth (c)2005, Glen Campbell. All rights reserved.
//
// MODULE(Rebuild search index)

$PAGE->assign('page_title', 'Rebuild Search Index');
if ($_GET['go'])
{
    header(sprintf("Location: %s/search.php?rebuild=1", config('site_path')));
    exit;
}
else
{
    $out = "<p>You are about to rebuild your full-text search index. ".
           "This process might take some time. Click Continue to proceed.</p>";
    $out .= sprintf('<p><a href="%s&amp;go=1">Continue</a></p>',
                    $_SERVER['REQUEST_URI']);
    $PAGE->assign('admin_content', $out);
}

?>