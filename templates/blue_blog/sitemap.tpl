{* $Id: sitemap.tpl,v 1.2 2006/01/05 16:45:14 glen Exp $ *}
{include file="header.tpl"}

<div id="right-column">
This is a map of the folder
structure of the website.
</div>{* id="right-column" *}

<div id="content">
<h1>{$page_title}</h1>
{if $error ne ""}<p class="error">{$error}</p>{/if}
{section name=i loop=$folders}
    <div style="margin-left:{$folders[i].level}em">
    <strong><a href="{$folders[i].url}">{$folders[i].title}</a></strong>
    {$folders[i].folder_text|strip_tags|truncate}
    </div>
{/section}
</div>{* id="content" *}

{include file="footer.tpl"}