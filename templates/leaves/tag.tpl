{* $Id: tag.tpl,v 1.1 2005/12/21 19:47:42 glen Exp $ *}
{include file="header.tpl"}
{menu name="action" text="View All Tags" link="$site_path/tags.php"}

<div id="sidebar">
<p><a href="{$rss_url}" title="RSS 2.0"><img src="{$site_path}/images/feed-icon16x16.png" alt="" /></a></p>
</div>{* id="sidebar" *}

<div id="content">
<h2>{$page_title}</h2>
{if $error ne ""}<p class="error">{$error}</p>{/if}
{foreach item=page from=$tag_pages}
{include file="excerpt.tpl"}
{/foreach}
</div>{* id="content" *}

{include file="footer.tpl"}