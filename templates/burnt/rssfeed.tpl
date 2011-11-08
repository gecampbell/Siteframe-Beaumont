{* $Id: rssfeed.tpl,v 1.3 2005/12/10 21:30:19 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
**
** This template is used to generate the overall home page for the entire
** site (not just a weblog or photo album).
*}
{include file="top.tpl"}

<div id="mightylinks">
<ul>
<li><strong>RSS Info</strong></li>
<li>{$rss_description}</li>
{*<li>{$rss_url}</li>*}
<li>{$rss_copyright}</li>
<li>Language: {$rss_language}</li>
<li>TTL: {$rss_ttl}</li>
<li>{$rss_webmaster}</li>
<li>{$rss_generator}</li>
</ul>
<ul>
<li>Last updated</li>
<li>{$rss_modified|ydate:"$date_format"}</li>
</ul>
</div>{* id="mightylinks" *}

<div class="text">
<h1><strong>{$page_title}</strong></h1>
<p>&nbsp;</p>
{if $error ne ""}<p class="error">{$error}</p>{/if}
{menu name="action" text="All RSS Feeds" link="$site_path/feeds.php"}
{section name=i loop=$items}
<p class="blog_item"><big><a href="{$items[i].link}">{$items[i].title}</a></big>
{$items[i].description}
<span class="info">/ <a href="{$items[i].link}">Link</a>
/ {$items[i].pubdate|ydate:"$date_format"}</span></p>
{/section}
</div>{* class="text" *}

{include file="bottom.tpl"}