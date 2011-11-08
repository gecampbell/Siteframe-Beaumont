{* $Id: archive.tpl,v 1.1 2006/01/12 04:33:16 glen Exp $ *}
{include file="header.tpl"}

<div id="right-column">
{calendar year=$year month=$month folder=$folder.id}
<ul>
<li><big>{if $folder}Folder {/if}Archives</big></li>
{archives folder=$folder.id}
<li><a href="{$site_path}/archive.php?y={$year}&amp;m={$month}{if $folder}&amp;f={$folder.id}{/if}">{$archive_date|date_format:"%B, %Y"}</a></li>
{/archives}
</ul>
</div>{* id="right-column" *}

<div id="main-copy">
{if $archive_type eq 'year'}
    <h1>{$year}{if $folder}: {$folder.title}{/if}</h1>
{elseif $archive_type eq 'month'}
    <h1>{$unixtime|date_format:"%B, %Y"}{if $folder}: {$folder.title}{/if}</h1>
{else}
    <h1>{$unixtime|date_format:"%B %e, %Y"}{if $folder}: {$folder.title}{/if}</h1>
{/if}
{if $error ne ""}<p class="error">{$error}</p>{/if}
{include file="paginator.tpl" curpage=$page numpages=$num_pages url="$url"}
{section name=item loop=$items}
{include file=$item_template page=$items[item]}
{/section}
</div>{* id="main-copy" *}

{include file="footer.tpl"}