{* $Id: sitemap.tpl,v 1.1 2005/11/24 19:00:06 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** creates a site map
*}
{include file="top.tpl"}

<div id="mightylinks">
<p><strong>Site Map</strong></p>
<p>This page displays the structure of the folders on this site.</p>
</div>

<div class="text">
<h1><strong>{$page_title}</strong></h1>
<p>&nbsp;</p>

{section name=i loop=$folders}
    <div style="margin-left:{$folders[i].level}em">
    <strong><a href="{$folders[i].url}">{$folders[i].title}</a></strong>
    {$folders[i].folder_text|strip_tags|truncate}
    </div>
{/section}
</div>{* class="text" *}

{include file="bottom.tpl"}