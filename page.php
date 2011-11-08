<?php
// $Id: page.php,v 1.34 2006/05/03 01:31:48 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.

require_once 'siteframe.inc';

// retrieve tag
$p = new Page;
$q = sprintf(
    "SELECT * FROM %s WHERE page_name='%s'",
    $p->table_name(),
    $_GET['tag']
);
$DB = Database::getReader();
$result = $DB->query($q);
if ($DB->errno)
    abort(lang('err_db'), $DB->error);
if (!$result->num_rows)
{
    header("HTTP/1.1 404 Not Found");
    header(sprintf('Location: %s/error.php?code=404', config('site_url')));
    exit;
}
$arr = $result->fetch_assoc();
$p = PageFactory::getPage(0, $arr);

// 404 if we don't have a real page
if (!$p->id())
{
    header("HTTP/1.1 404 Not Found");
    header(sprintf('Location: %s/error.php?code=404', config('site_url')));
    exit;
}
else
{
    // do we have a rating?
    if (is_object($_SESSION['user']) && $_SESSION['user']->id() && isset($_GET['rate']))
    {
        $r = new Rating;
        $r->set('rate_user_id', $_SESSION['user']->id());
        $r->set('rate_page_id', $p->id());
        $r->set('rate_rating', strip_tags($_GET['rate']));
        $r->add();
    }
    // assign folder template set to page
    if (config('allow_folder_theme', TRUE))
    {
        $f = new Folder($p->get('page_folder_id'));
        $arr = load_template_ini(config('dir_templates').'/'.$f->get('folder_theme'));
        if (count($arr))
            $TEMPLATES = $arr;
        $PAGE->load_new($f->get('folder_theme'));
    }

    // assign all the page properties
    $PAGE->assign($p->get_all());
    if (strpos($p->get_url(), '?'))
        $PAGE->assign('sep', '&amp;');
    else
        $PAGE->assign('sep', '?');
    
    // get the comments
    if ($p->get('allow_comments'))   // are comments allowed?
    {
        // display comments
        if (config('threaded_comments'))
            $clist = $p->get_threaded_comments();
        else
            $clist = $p->get_comments();
        $PAGE->assign('comments', $clist);
        $PAGE->assign('num_comments', count($clist));

        // now, create a comment form
        $c = new Comment;
        $c->set('comment_page_id', $p->id());
        $PAGE->assign('comment_form', $c->form());
    }
    
    // count the trackbacks
    $tb = new Trackback;
    $q = sprintf(
        "SELECT COUNT(*) FROM %s WHERE tb_page_id=%d",
        $tb->table_name(),
        $p->id());
    $res = $DB->query($q);
    check_db($DB);
    list($num) = $res->fetch_array();
    $PAGE->assign('num_trackbacks', $num);
}

$PAGE->display($p->get('alt_template'));
?>
