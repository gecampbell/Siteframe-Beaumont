{* $Id: tag.tpl,v 1.5 2005/12/11 00:12:45 glen Exp $
** Copyright (c)2005, Glen Campbell. All rights reserved.
**
** This template displays all the pages that match a given tag
*}
{include file="top.tpl"}

{menu name="action" text="View All Tags" link="$site_path/tags.php"}
{menu name="action" text="RSS 2.0" link="$rss_url"}

<div class="text">
<h1>{$page_title|default:"No Tag Defined"}</h1>
{if $error ne ""}<p class="error">{$error}</p>{/if}
<p>&nbsp;</p>
{foreach item=page from=$tag_pages}
{include file="blog_item.tpl"}
{/foreach}
</div>

{include file="bottom.tpl"}