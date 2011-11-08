{* $Id: archive.tpl,v 1.4 2005/11/26 00:19:21 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** this displays a folder
*}
{include file="top.tpl"}

<div id="mightylinks">
{calendar year=$year month=$month folder=$folder.id}
<p>&nbsp;</p>

<p><strong>{if $folder}Folder {/if}Archives</strong></p>
{archives folder=$folder.id}
<p><a href="{$site_path}/archive.php?y={$year}&amp;m={$month}{if $folder}&amp;f={$folder.id}{/if}">{$archive_date|date_format:"%B, %Y"}</a></p>
{/archives}
</div>{* id="mightylinks" *}

<div class="text">
{if $archive_type eq 'year'}
    <h1>{$year}</h1>
{elseif $archive_type eq 'month'}
    <h1>{$unixtime|date_format:"%B %Y"}</h1>
{else}
    <h1>{$unixtime|date_format:"%B %e, %Y"}</h1>
{/if}
{if $folder}<h2>Folder: {$folder.title}</h2>{/if}
<p>&nbsp;</p>

{include file="paginator.tpl" curpage=$page numpages=$num_pages url="$url"}

{if $error ne ""}<p class="error">{$error}</p>{/if}
<div class="items">
{section name=item loop=$items}
{include file=$item_template page=$items[item]}
{/section}
</div>{* class="items" *}
{include file="paginator.tpl" curpage=$page numpages=$num_pages url="$url"}
</div>{* class="text" *}

{include file="bottom.tpl"}