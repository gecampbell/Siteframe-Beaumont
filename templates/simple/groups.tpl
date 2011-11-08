{* $Id: groups.tpl,v 1.3 2005/12/10 06:45:01 glen Exp $
** Copyright (c)2005, Glen Campbell. All rights reserved.
** This page displays all folders
*}
{include file="preamble.tpl"}
{include file="html_head.tpl"}
{menu name="action" link="$site_path/edit.php?c=Group" text="Create New Group"}

<h1>{$page_title}</h1>

<div class="content">
<table class="list">
<tr>
    <th><a href="{$site_path}/folders.php">Group</a> </th>
    <th><a href="{$site_path}/folders.php?o=user_name">Owner</a> </th>
    <th><a href="{$site_path}/folders.php?o=group_created">Created</a> </th>
</tr>
{section name=cur loop=$groups}
<tr onmouseover="javascript:highlight_tr(this,true)" onmouseout="javascript:highlight_tr(this,false)" class="{cycle values="odd,even"}">
<td><a href="{$groups[cur].url}">{$groups[cur].title}</a><br />
{$groups[cur].group_text|strip_tags|truncate:100}</td>
<td><a href="{$groups[cur].user.url}">{$groups[cur].user.user_name}</a></td>
<td style="white-space:nowrap;">{$groups[cur].group_created|ydate:"$date_format $time_format"}</td>
{/section}
</table>
</div><!-- content -->

{include file="paginator.tpl" curpage=$page numpages=$num_pages url="$site_path/folders.php"}

{include file="footer.tpl"}
