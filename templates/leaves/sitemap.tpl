{* $Id: sitemap.tpl,v 1.1 2005/12/21 19:47:42 glen Exp $ *}
{include file="header.tpl"}

<div id="sidebar">
This is a map of the folder
structure of the website.
</div>{* id="sidebar" *}

<div id="content">
<h2>{$page_title}</h2>
{if $error ne ""}<p class="error">{$error}</p>{/if}
{section name=i loop=$folders}
    <div style="margin-left:{$folders[i].level}em">
    <strong><a href="{$folders[i].url}">{$folders[i].title}</a></strong>
    {$folders[i].folder_text|strip_tags|truncate}
    </div>
{/section}
</div>{* id="content" *}

{include file="footer.tpl"}