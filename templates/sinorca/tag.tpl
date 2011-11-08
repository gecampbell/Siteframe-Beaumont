{* $Id: tag.tpl,v 1.1 2006/01/12 04:33:16 glen Exp $ *}
{include file="header.tpl"}
{menu name="action" text="View All Tags" link="$site_path/tags.php"}

<div id="right-column">
<p><a href="{$rss_url}" title="RSS 2.0"><img src="{$site_path}/images/feed-icon16x16.png" alt="" /></a></p>
</div>{* id="right-column" *}

<div id="main-copy">
<h1>{$page_title}</h1>
{if $error ne ""}<p class="error">{$error}</p>{/if}
{foreach item=page from=$tag_pages}
{include file="excerpt.tpl"}
{/foreach}
</div>{* id="main-copy" *}

{include file="footer.tpl"}