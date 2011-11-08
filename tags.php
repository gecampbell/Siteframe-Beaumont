<?php
// $Id: tags.php,v 1.11 2006/05/03 01:31:48 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.
//
// query strings
//  ?al=1   to sort alphabetically instead of numerically

require_once 'siteframe.inc';

$r = new TagPageRel;
$t = new Tag;

// user tags or all?
if (isset($_GET['u']))
{
    $p = new Page;
    $u = new User;
    $q = sprintf(
        "SELECT tag.tag_id, COUNT(*) ".
        "FROM %s tag INNER JOIN %s rel ON (tag.tag_id=rel.tag_id) ".
        "WHERE rel.page_id IN ".
        "  (SELECT page_id FROM %s WHERE page_user_id=(SELECT user_id FROM %s WHERE user_name='%s')) ".
        "GROUP BY tag.tag_id ".
        "ORDER BY %s",
        $t->table_name(),
        $r->table_name(),
        $p->table_name(),
        $u->table_name(),
        $_GET['u'],
        ($_GET['f']) ? "2 DESC" : "tag_name" );
    $PAGE->assign('rss_url', config('site_url').'/tags.php?rss=1&amp;u='.htmlentities($_GET['u']));
    $PAGE->assign('page_title', htmlentities($_GET['u']).': '.lang('page_title_tags'));
}
else
{
    $q = sprintf(
        "SELECT tag.tag_id, COUNT(*) ".
        "FROM %s tag INNER JOIN %s rel ON (tag.tag_id=rel.tag_id) ".
        "GROUP BY tag.tag_id ".
        "ORDER BY %s",
        $t->table_name(),
        $r->table_name(),
        ($_GET['f']) ? "2 DESC" : "tag_name" );
    $PAGE->assign('rss_url', config('site_url').'/tags.php?rss=1');
    $PAGE->assign('page_title', lang('page_title_tags'));
}

// execute query
$DB = Database::getReader();
$result = $DB->query($q);
check_db($DB);

// establish array to hold return pages
$arr = array();
$rss = array();

// max will hold the greatest count
$max = 0;

// fetch all the tags
while(list($id,$num) = $result->fetch_row())
{
    $tag = new Tag($id);
    $item = $tag->get_all();
    $item['num_pages'] = $num;
    $arr[] = $item;
    
    $rss[] = array(
        'title' => $item['tag_name'],
        'description' => sprintf('%d page%s', $num, ($num>1)?'s':''),
        'date' => '',
        'link' => $item['url'],
    );

    // compute new MAX value
    if ($num > $max)
        $max = $num;
}

// assign them all and then display
$PAGE->assign('all_tags', $arr);
$PAGE->assign('tag_count_max', $max);
if ($_GET['f'])
    $PAGE->assign('tag_sort', 'count');
else
    $PAGE->assign('tag_sort', 'alpha');

if ($_GET['rss'])
{
    $PAGE->assign('rss_items', $rss);
    $PAGE->assign('rss_title', sprintf('%s - Tags', config('site_name')));
    $PAGE->assign('rss_description', '');
    $PAGE->load_new('');
    header("Content-Type: text/xml");
    echo $PAGE->fetch(site_template('rssgeneric'));
}
else
    $PAGE->display();
?>
