{* $Id: rssfeed.tpl,v 1.8 2005/12/10 21:30:19 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
**
** This template is used to generate the overall home page for the entire
** site (not just a weblog or photo album).
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
{menu name="action" text="All RSS Feeds" link="$site_path/feeds.php"}
<div id="main">
{section name=i loop=$items}
<p class="blog_item"><big><a href="{$items[i].link}">{$items[i].title}</a></big>
{$items[i].description}
<span class="info">/ <a href="{$items[i].link}">Link</a>
/ {$items[i].pubdate|ydate:"$date_format"}</span></p>
{/section}
</div>{* id="main" *}

<div id="menu">
<ul>
<li><big>RSS Info</big></li>
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
</div>{* id="menu" *}

{include file="footer.tpl"}
</div>{* id="content" *}
</body>
</html>
