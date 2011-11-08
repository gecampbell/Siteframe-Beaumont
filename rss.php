<?php
// $Id: rss.php,v 1.29 2006/05/20 14:31:29 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.
// See LICENSE.txt for details.
//
// This script produces an RSS feed of pages (it cannot be used for other
// RSS feeds, such as search results). It can be invoked with several possible
// query string parameters:
//  none                most recent pages on the site
//  folder=x            most recent pages from folder
//  tag=x               all pages with the tag
//  user=x              most recent pages from user
//  user=x&tag=x        all user's pages with tag

require_once 'siteframe.inc';

define('RSS_TIMESTR', '%a, %d %b %Y %H:%M:%S %Z');

// is RSS enabled?
if (!config('rss_enable'))
    die(lang('err_norss'));

$u   = new User;
$t   = new Tag;
$f   = new Folder;
$g   = new Group;
$p   = new Page;
$rel = new TagPageRel;

// set max
if (isset($_GET['num']))
    $num = $_GET['num'];
else
    $num = config('recent_items', 12);

// get number of days
if (isset($_GET['days']))
    $days = sprintf('AND page_created>DATE_SUB(NOW(),INTERVAL %d DAY)', $_GET['days']);
else
    $days = '';

// validate query strings
if (isset($_GET['type']))
{
    switch(strtolower($_GET['type']))
    {
    case 'toprated':
        $r = new Rating;
        $q = sprintf(
            "SELECT page_id,AVG(rate_rating),COUNT(*)
             FROM %s JOIN %s ON (rate_page_id=page_id)
             WHERE 1 %s
             GROUP BY page_id
             HAVING COUNT(*) > 2
             ORDER BY 2 DESC
             LIMIT %d",
            $p->table_name(),
            $r->table_name(),
            $days,
            $num
        );
        $title = lang('rss_title_toprated').' @ '.config('site_name');
        break;
    case 'mostcomments':
        break;
    case 'lowrated':
        break;
    default:
        die(sprintf(lang('err_rss_badtype'), $_GET['type']));
    }
}
else if (isset($_GET['user']) && isset($_GET['tag']))
{
    $q = sprintf(
        "SELECT * FROM %s pages
            JOIN %s rel
            ON pages.page_id=rel.page_id
            JOIN %s tags
            ON rel.tag_id=tags.tag_id
            JOIN %s users
            ON pages.page_user_id=users.user_id
         WHERE tag_name='%s'
           AND user_name='%s'
           %s
         ORDER BY page_created DESC
         LIMIT %d",
         $p->table_name(),
         $rel->table_name(),
         $t->table_name(),
         $u->table_name(),
         addslashes($_GET['tag']),
         addslashes($_GET['user']),
         $days,
         $num
    );
    $obj = new Tag($_GET['tag']);
    $description = FALSE;
}
else if (isset($_GET['tag']))
{
    $q = sprintf(
        "SELECT * FROM %s pages 
         LEFT JOIN %s rel
            ON pages.page_id=rel.page_id
            LEFT JOIN %s tags
            ON rel.tag_id=tags.tag_id
         WHERE tag_name='%s' 
         %s
         ORDER BY page_created DESC
         LIMIT %d",
         $p->table_name(),
         $rel->table_name(),
         $t->table_name(),
         addslashes($_GET['tag']),
         $days,
         $num
    );
    $obj = new Tag($_GET['tag']);
    $description = FALSE;
}
else if (isset($_GET['user']))
{
    $q = sprintf(
        "SELECT * FROM %s pages
            JOIN %s users
            ON pages.page_user_id=users.user_id
         WHERE user_name='%s'
         %s
         ORDER BY page_created DESC
         LIMIT %d",
         $p->table_name(),
         $u->table_name(),
         addslashes($_GET['user']),
         $days,
         $num
    );
    $obj = new User($_GET['user']);
    $description = $obj->get('user_text');
}
else if (isset($_GET['favorites']))
{
    $fav = new Favorite;
    $u = new User($_GET['favorites']);
    $q = sprintf(
        "SELECT * FROM %s WHERE page_user_id IN
            (SELECT fav_user_id FROM %s WHERE user_id=%d)
        %s
        ORDER BY page_created DESC
        LIMIT %d",
        $p->table_name(),
        $fav->table_name(),
        $u->id(),
        $days,
        $num
    );
    $obj = new Favorite;
    $obj->set('user_id', $u->id());
    $description = '';
}
else if (isset($_GET['folder']))
{
    $q = sprintf(
        "SELECT * FROM %s pages
        LEFT JOIN %s folder ON
            pages.page_folder_id=folder.folder_id
        WHERE folder_name='%s'
        %s
        ORDER BY page_created DESC
        LIMIT %d",
        $p->table_name(),
        $f->table_name(),
        addslashes($_GET['folder']),
        $days,
        $num
    );
    $obj = new Folder($_GET['folder']);
    $description = $obj->get('folder_text');
}
else if (isset($_GET['group']))
{
    $grel = new GroupUserRel;
    $q = sprintf(
        "SELECT * FROM %s pages
        WHERE page_user_id
            IN (SELECT r_user_id FROM %s gusers
                JOIN %s groups
                ON gusers.r_group_id=groups.group_id
                WHERE group_name='%s')
        %s
        ORDER BY page_created DESC
        LIMIT %d",
        $p->table_name(),
        $grel->table_name(),
        $g->table_name(),
        addslashes($_GET['group']),
        $days,
        $num
    );
    $obj = new Group($_GET['group']);
    $description = $obj->get('group_text');
}
else
{
    $q = sprintf(
        "SELECT * FROM %s
        %s
        ORDER BY page_created DESC
        LIMIT %d",
        $p->table_name(),
        ($days != '') ? str_replace('AND', 'WHERE', $days) : '',
        $num
    );
    $obj = FALSE;
    $description = config('site_tagline');
}

// let's get some data, shall we?
$myquery = new Query('Page', $q);

// build the new DOM document
$doc = new DOMDocument('1.0', config('charset'));
$doc->formatOutput = TRUE;

// add a comment
$doc->appendChild($doc->createComment(config('rss_comment',
    ' RSS 2.0 by Siteframe http://siteframe.org ')));

// <rss version="2.0">
$root = $doc->createElement('rss');
$root = $doc->appendChild($root);
$ver  = $doc->createAttribute('version');
$ver  = $root->appendChild($ver);
$text = $doc->createTextNode('2.0');
$text = $ver->appendChild($text);

// add MediaRSS namespace
$root->setAttributeNodeNS($med=$doc->createAttribute('xmlns:media'));
$med->appendChild($doc->createTextNode('http://search.yahoo.com/mrss/'));

// <channel>
$channel = $root->appendChild($doc->createElement('channel'));

// <title>
$channel->appendChild($element = $doc->createElement('title'));
if (isset($title))
    $element->appendChild($doc->createTextNode($title));
else
    $element->appendChild($doc->createTextNode(
        $obj ? 
            ($obj->get_title().' @ '.config('site_name')) : 
            config('site_name')));

// <link>
$channel->appendChild($element = $doc->createElement('link'));
$element->appendChild($doc->createTextNode(
    $obj ? (config('site_url_base').$obj->get_url()) : config('site_url')));

// <descriptiom>
$channel->appendChild($element = $doc->createElement('description'));
$element->appendChild($doc->createTextNode(utf8_encode($description)));

// <language>
$channel->appendChild($element = $doc->createElement('language'));
$element->appendChild($doc->createTextNode(config('lang_default')));

// <copyright>
$channel->appendChild($element = $doc->createElement('copyright'));
$element->appendChild($doc->createTextNode(config('site_copyright')));

// <lastBuildDate> - updated later
$channel->appendChild($builddate = $doc->createElement('lastBuildDate'));

// <generator>
$channel->appendChild($element = $doc->createElement('generator'));
$element->appendChild($doc->createTextNode('Siteframe '.SITEFRAME_VERSION));

// <webMaster>
$channel->appendChild($element = $doc->createElement('webMaster'));
$element->appendChild($doc->createTextNode(config('site_email')));

// <docs>
$channel->appendChild($doc->createElement('docs', 'http://blogs.law.harvard.edu/tech/rss'));

// <ttl>
$channel->appendChild($doc->createElement('ttl', config('rss_ttl', 30)));

// add all the page data
$lastBuild = 0;
while($page = $myquery->get_all())
{
    $channel->appendChild($item = $doc->CreateElement('item'));
    
    // <title>
    $item->appendChild($element = $doc->createElement('title'));
    $element->appendChild($doc->createTextNode($page['page_title']));
    
    // <description>
    // function resize_image($filename, $mimetype, $res, $rotate=0, $center=0)
    $item->appendChild($element = $doc->createElement('description'));
    // get description data
    if (config('rss_fulltext') === TRUE)
        $desc = $page['page_text'];
    else
        $desc = strtrunc($page['page_text'], 300);
    
    // images?
    if (config('rss_images', TRUE))
    {
        // add images to it
        foreach($page['associated_files'] as $file)
        {
            if ($file['is_image'])
            {
                $thumb = resize_image($file['file_path'], 
                    $file['file_type'], config('rss_image_size', 300));
                $size = GetImageSize($thumb);
                $PAGE->assign('im_w', $size[0]);
                $PAGE->assign('im_h', $size[1]);
                $item->appendChild($mcontent = $doc->createElement('media:content'));
                $mcontent->appendChild($url=$doc->createAttribute('url'));
                $url->appendChild($doc->createTextNode(config('site_url').'/'.$thumb));
                $mcontent->appendChild($typ=$doc->createAttribute('type'));
                $typ->appendChild($doc->createTextNode($file['file_type']));
                $mcontent->appendChild($h=$doc->createAttribute('width'));
                $h->appendChild($doc->createTextNode($size[0]));
                $mcontent->appendChild($h=$doc->createAttribute('height'));
                $h->appendChild($doc->createTextNode($size[1]));
                $desc = sprintf(
                    '<center><a href="%s%s">'.
                    '<img src="%s/%s" width="%d" height="%d" alt="%s"/>'.
                    '</a></center><br />%s',
                    config('site_url_base'),
                    $page['url'],
                    config('site_url'),
                    $thumb,
                    $size[0],
                    $size[1],
                    $file['title'],
                    $desc);
                break; // include only one image
            }
        }
    }
    
    // and set the value
    $element->appendChild($doc->createTextNode($desc));
    
    // <pubDate>
    $thisBuild = strtotime($page['page_created']);
    if ($thisBuild > $lastBuild)
        $lastBuild = $thisBuild;
    $item->appendChild($doc->createElement('pubDate',
        $datestr = strftime(RSS_TIMESTR, $thisBuild)));
    
    // <guid>
    $item->appendChild($guid = $doc->createElement('guid', 
        config('site_url_base').$page['url']));
    $guid->appendChild($ispl = $doc->createAttribute('isPermaLink'));
    $ispl->appendChild($doc->createTextNode("true"));
    $item->appendChild($doc->createElement('link', config('site_url_base').$page['url']));
    if (config('rss_author'))
        $item->appendChild($doc->createElement('author',
            $page['user']['user_email'].' ('.$page['user']['user_firstname'].' '.
            $page['user']['user_lastname'].')'));
    
    // add tags as <category>
    foreach($page['tags'] as $tag)
        $item->appendChild($doc->createElement('category', $tag['tag_name']));

    // capture each enclosure
    $num_enc = 0;
    foreach($page['associated_files'] as $file)
    {
        // only one enclosure is permitted.
        if (++$num_enc > 1)
            break;

        $item->appendChild($enc = $doc->createElement('enclosure'));
        $url = $doc->createAttribute('url');
        $url->appendChild($doc->createTextNode(
            config('site_url').'/'.$file['file_path']));
        $enc->appendChild($url);
        $length = $doc->createAttribute('length');
        $length->appendChild($doc->createTextNode($file['file_size']));
        $enc->appendChild($length);
        $type = $doc->createAttribute('type');
        $type->appendChild($doc->createTextNode($file['file_type']));
        $enc->appendChild($type);
    }
}
// set lastBuildDate
if (!$lastBuild)
    $lastBuild = time();
$builddate->appendChild($doc->createTextNode(strftime(RSS_TIMESTR, $lastBuild)));

header('Content-Type: application/xml');
echo $doc->saveXML()."\n";
printf("\n<!-- %s/%.4f secs -->\n",
    basename($_SERVER['SCRIPT_NAME']),
    microtime(true) - $PAGE_START
);
?>
