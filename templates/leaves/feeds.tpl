{* $Id: feeds.tpl,v 1.1 2005/12/21 04:55:58 glen Exp $ *}
{include file="header.tpl"}
{menu name="action" link="$site_path/edit.php?c=RSSfeed" text="New RSS Feed"}

<div id="sidebar">
<p>These are the RSS feeds (from outside sources) currently available on
this site.</p>
</div>{* id="sidebar" *}

<div id="content">
<h2>{$page_title}</h2>
{if $error ne ""}<p class="error">{$error}</p>{/if}
{section name=cur loop=$rss_feeds}
<p class="blog_item"><big><a href="{$rss_feeds[cur].url}">{$rss_feeds[cur].rss_title}</a></big>
{$rss_feeds[cur].rss_description|strip_tags|truncate}
<span class="info">
/ <a href="{$rss_feeds[cur].user.url}">{$rss_feeds[cur].user.user_name}</a>
/ {$rss_feeds[cur].rss_modified|ydate:"$date_format $time_format"}
</span></p>
{/section}
</div>{* id="content" *}

{include file="footer.tpl"}