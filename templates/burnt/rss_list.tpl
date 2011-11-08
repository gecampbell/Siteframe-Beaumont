{* $Id: rss_list.tpl,v 1.1 2005/11/24 19:00:06 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** generates the user information page
*}
{include file="top.tpl"}

<div id="mightylinks">
<p><strong>RSS</strong></p>
<p>RSS stands for Really Simple Syndication.</p>
</div>

<div class="text">
<h1><strong>{$page_title}</strong></h1>
<p>&nbsp;</p>
{if $error ne ""}<p class="error">{$error}</p>{/if}

{menu name="action" link="$site_path/edit.php?c=RSSfeed" text="New RSS Feed"}

{section name=cur loop=$rss_feeds}
<p class="blog_item"><big><a href="{$rss_feeds[cur].url}">{$rss_feeds[cur].rss_title}</a></big>
{$rss_feeds[cur].rss_description|strip_tags|truncate}
<span class="info">
/ <a href="{$rss_feeds[cur].user.url}">{$rss_feeds[cur].user.user_name}</a>
/ {$rss_feeds[cur].rss_modified|ydate:"$date_format $time_format"}
</span></p>
{/section}
</div>{* class="text" *}

{include file="bottom.tpl"}