{* $Id: rssfeed.tpl,v 1.5 2005/12/10 05:46:29 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
**
** This template is used to generate the overall home page for the entire
** site (not just a weblog or photo album).
*}
{include file="preamble.tpl"}
{include file="html_head.tpl"}
{menu name="action" text="All RSS Feeds" link="$site_path/feeds.php"}

<div class="content">
<h1>{$page_title}</h1>
{if $error ne ""}<p class="error">{$error}</p>{/if}
<ul class="info">
<li>URL: {$rss_url}</li>
<li>Description: {$rss_description}</li>
<li>Copyright: {$rss_copyright}</li>
<li>Language: {$rss_language}</li>
<li>TTL: {$rss_ttl}</li>
<li>Webmaster: {$rss_webmaster}</li>
<li>Generator: {$rss_generator}</li>
</ul>
<ul>
<li>Last updated</li>
<li>{$rss_modified|ydate:"$date_format"}</li>
</ul>
</div>{* class="content" *}

{section name=i loop=$items}
<div class="blog_item">
<h2>{$items[i].title}</h2>
<p>{$items[i].description}</p>
<p><a href="{$items[i].link}">{$items[i].link}</a> - {$items[i].pubdate|ydate:"$date_format"}</p>
</div>
{/section}

{include file="footer.tpl"}
