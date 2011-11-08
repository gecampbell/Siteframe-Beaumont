{* $Id: rssfeed.tpl,v 1.1 2006/01/12 04:33:16 glen Exp $ *}
{include file="header.tpl"}
{menu name="action" text="All RSS Feeds" link="$site_path/feeds.php"}

<div id="right-column">
<h3>RSS Info</h3>
<ul>
<li>{$rss_description}</li>
{*<li>{$rss_url}</li>*}
<li>{$rss_copyright}</li>
<li>Language: {$rss_language}</li>
<li>TTL: {$rss_ttl}</li>
<li>{$rss_webmaster}</li>
<li>{$rss_generator}</li>
</ul>
<h3>Last updated</h3>
<ul>
<li>{$rss_modified|ydate:"$date_format"}</li>
</ul>
</div>{* id="right-column" *}

<div id="main-copy">
<h1>{$page_title}</h1>
{if $error ne ""}<p class="error">{$error}</p>{/if}
{section name=i loop=$items}
<p class="blog_item"><big><a href="{$items[i].link}">{$items[i].title}</a></big>
{$items[i].description}
<span class="info">/ <a href="{$items[i].link}">Link</a>
/ {$items[i].pubdate|ydate:"$date_format"}</span></p>
{/section}
</div>{* id="main-copy" *}

{include file="footer.tpl"}