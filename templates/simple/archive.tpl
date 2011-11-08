{* $Id: archive.tpl,v 1.12 2005/11/26 00:19:21 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** this displays a folder
*}
{include file="preamble.tpl"}
{include file="html_head.tpl"}

{if $archive_type eq 'year'}
    <h1>{$year}{if $folder}: {$folder.title}{/if}</h1>
{elseif $archive_type eq 'month'}
    <h1>{$unixtime|date_format:"%B, %Y"}{if $folder}: {$folder.title}{/if}</h1>
{else}
    <h1>{$unixtime|date_format:"%B %e, %Y"}{if $folder}: {$folder.title}{/if}</h1>
{/if}

{include file="paginator.tpl" curpage=$page numpages=$num_pages url="$url"}

<div class="content">

<div class="main">
{if $error ne ""}<p class="error">{$error}</p>{/if}
<div class="items">
{section name=item loop=$items}
{include file=$item_template page=$items[item]}
{/section}
</div><!-- class="items" -->
</div><!-- class="main" -->

<div class="pagemenu">
{calendar year=$year month=$month folder=$folder.id}
<div class="heading">{if $folder}Folder {/if}Archives</div>
<p>
{archives folder=$folder.id}
<a href="{$site_path}/archive.php?y={$year}&amp;m={$month}{if $folder}&amp;f={$folder.id}{/if}">{$archive_date|date_format:"%B, %Y"}</a><br />
{/archives}
</div><!-- class="pagemenu" -->

</div><!-- class="content" -->

{include file="paginator.tpl" curpage=$page numpages=$num_pages url="$url"}

{include file="footer.tpl"}
