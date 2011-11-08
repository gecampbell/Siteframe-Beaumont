{* $Id: archive.tpl,v 1.1 2005/12/20 21:42:52 glen Exp $ *}
{include file="header.tpl"}

<div id="sidebar">
{calendar year=$year month=$month folder=$folder.id}
<ul>
<li><big>{if $folder}Folder {/if}Archives</big></li>
{archives folder=$folder.id}
<li><a href="{$site_path}/archive.php?y={$year}&amp;m={$month}{if $folder}&amp;f={$folder.id}{/if}">{$archive_date|date_format:"%B, %Y"}</a></li>
{/archives}
</ul>
</div>{* id="sidebar" *}

<div id="content">
{if $archive_type eq 'year'}
    <h2>{$year}{if $folder}: {$folder.title}{/if}</h2>
{elseif $archive_type eq 'month'}
    <h2>{$unixtime|date_format:"%B, %Y"}{if $folder}: {$folder.title}{/if}</h2>
{else}
    <h2>{$unixtime|date_format:"%B %e, %Y"}{if $folder}: {$folder.title}{/if}</h2>
{/if}
{if $error ne ""}<p class="error">{$error}</p>{/if}
{include file="paginator.tpl" curpage=$page numpages=$num_pages url="$url"}
{section name=item loop=$items}
{include file=$item_template page=$items[item]}
{/section}
</div>{* id="content" *}

{include file="footer.tpl"}