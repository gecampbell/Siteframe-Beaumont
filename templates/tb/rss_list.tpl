{* $Id: rss_list.tpl,v 1.2 2005/11/07 06:50:32 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** generates the user information page
*}
{include file="preamble.tpl"}
<html>
<head>
{include file="html_head.tpl" rte_enable=0}
</head>
<body>
<div id="content">
{include file="header.tpl"}

<h1>{$page_title}</h1>
{if $error ne ""}<p class="error">{$error}</p>{/if}

{menu name="action" link="$site_path/edit.php?c=RSSfeed" text="New RSS Feed"}

<div id="main">
{section name=cur loop=$rss_feeds}
<p class="blog_item"><big><a href="{$rss_feeds[cur].url}">{$rss_feeds[cur].rss_title}</a></big>
{$rss_feeds[cur].rss_description|strip_tags|truncate}
<span class="info">
/ <a href="{$rss_feeds[cur].user.url}">{$rss_feeds[cur].user.user_name}</a>
/ {$rss_feeds[cur].rss_modified|ydate:"$date_format $time_format"}
</span></p>
{/section}
</div>{* id="main" *}

{include file="footer.tpl"}
</div>{* id="content" *}
</body>
</html>