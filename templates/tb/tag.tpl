{* $Id: tag.tpl,v 1.8 2005/12/31 04:25:03 glen Exp $
** Copyright (c)2005, Glen Campbell. All rights reserved.
**
** This template displays all the pages that match a given tag
*}
{include file="preamble.tpl"}
<html>
<head>
{include file="html_head.tpl" rte_enable=1}
</head>
<body>
<div id="content">
{include file="header.tpl"}

{menu name="action" text="View All Tags" link="$site_path/tags.php"}

<h1>{$page_title|default:"No Tag Defined"}</h1>

{if $error ne ""}<p class="error">{$error}</p>{/if}

<div id="main">
{foreach item=page from=$tag_pages}
{include file="blog_item.tpl"}
{/foreach}
</div>

<div id="menu">
{include file="minisearch.tpl"}
<p><a href="{$rss_url}" title="RSS 2.0"><img src="{$site_path}/images/feed-icon16x16.png" alt="" /></a></p>
</div>

{include file="footer.tpl"}
</div>{* id="content" *}
</body>
</html>
