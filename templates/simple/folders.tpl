{* $Id: folders.tpl,v 1.3 2005/04/04 04:32:38 glen Exp $
** Copyright (c)2005, Glen Campbell. All rights reserved.
** This page displays all folders
*}
{include file="preamble.tpl"}
{include file="html_head.tpl"}

<h1>{$page_title}</h1>

<div class="content">
<table class="list">
<tr>
    <th><a href="{$site_path}/folders.php">Folder</a> </th>
    <th><a href="{$site_path}/folders.php?o=user_name">Owner</a> </th>
    <th><a href="{$site_path}/folders.php?o=folder_created">Created</a> </th>
</tr>
{section name=cur loop=$folders}
<tr onmouseover="javascript:highlight_tr(this,true)" onmouseout="javascript:highlight_tr(this,false)" class="{cycle values="odd,even"}">
<td><a href="{$folders[cur].url}">{$folders[cur].folder_title}</a><br />
{$folders[cur].folder_text|strip_tags|truncate:100}</td>
<td><a href="{$folders[cur].user.url}">{$folders[cur].user.user_name}</a></td>
<td style="white-space:nowrap;">{$folders[cur].folder_created|ydate:"$date_format $time_format"}</td>
{/section}
</table>
</div><!-- content -->

{include file="paginator.tpl" curpage=$page numpages=$num_pages url="$site_path/folders.php"}

{include file="footer.tpl"}
