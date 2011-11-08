{* $Id: tag.tpl,v 1.10 2005/12/11 00:12:45 glen Exp $
** Copyright (c)2005, Glen Campbell. All rights reserved.
**
** This template displays all the pages that match a given tag
*}
{include file="preamble.tpl"}
{include file="html_head.tpl"}

{menu name="action" text="View All Tags" link="$site_path/tags.php"}
{menu name="action" text="RSS 2.0" link="$rss_url"}

<h1>{$page_title|default:"No Tag Defined"}</h1>

<div class="content">
{if $error ne ""}<p class="error">{$error}</p>{/if}
{foreach item=page from=$tag_pages}
{include file="blog_item.tpl"}
{/foreach}

{include file="footer.tpl"}
