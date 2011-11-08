<?php
// $Id: folder.php,v 1.28 2006/05/03 01:31:48 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.

require_once 'siteframe.inc';

$select = <<<ENDSELECT
SELECT page_id
FROM %s
WHERE page_folder_id=%d
  AND page_hidden=0
ORDER BY %s
ENDSELECT;

// retrieve tag
$f = new Folder;
$q = sprintf(
    "SELECT folder_id FROM %s WHERE folder_name='%s'",
    $f->table_name(),
    $_GET['tag']
);

$DB = Database::getReader();
$result = $DB->query($q);
if ($DB->errno)
    abort(lang('err_db'), $DB->error);
list($id) = $result->fetch_row();
$f = new Folder($id);

if (!$f->id())
{
    $_GET['template'] = 'error.php';
    $_GET['code'] = 404;
    include('error.php');
    exit;
}
else {
    if (config('allow_folder_theme', TRUE))
    {
        $arr = load_template_ini(config('dir_templates').'/'.$f->get('folder_theme'));
        if (count($arr))
            $TEMPLATES = $arr;
        $PAGE->load_new($f->get('folder_theme'));
    }

    // assign all folder properties to the page
    $PAGE->assign($f->get_all());

    // get pagination info
    // select page
    if (isset($_GET['page']))
        $page = $_GET['page'];
    else
        $page = 1;
    
    // find the total number of pages
    $p = new Page;
    $q = sprintf(
        "SELECT COUNT(*) FROM %s WHERE page_folder_id=%d", 
        $p->table_name(), 
        $f->id());
    $result = $DB->query($q);
    check_db($DB);
    list($total) = $result->fetch_row();
    
    // determine start and end
    if (is_object($_SESSION['user']))
        $rpp = $_SESSION['user']->get('rows_per_page');
    if (!$rpp)
        $rpp = config('rows_per_page');
    $start = ($page-1)*$rpp;
    
    // fetch all the pages for the time period selected
    $items = array();
    $q = sprintf($select,
            $p->table_name(),
            $f->get('folder_id'),
            $f->get('folder_orderby') ? $f->get('folder_orderby') : 'page_id DESC');
    $myquery = new Query('Page', $q, $start, $rpp);
    while($obj = $myquery->get_all())
        $items[] = $obj;
    $PAGE->assign('items', $items);
    $PAGE->assign('page', $page);
    $PAGE->assign('num_pages', intval($total/$rpp)+(($total%$rpp)?1:0));
    $PAGE->assign('url', $f->get_url());
    if (config('url_rewriting'))
        $PAGE->assign('sep', '?');
    else
        $PAGE->assign('sep', '&amp;');
}

$PAGE->assign('item_template', $TEMPLATES['index_item']);
$PAGE->assign('page_title', $f->get_title());
$PAGE->display($f->get('alt_template'));
?>
