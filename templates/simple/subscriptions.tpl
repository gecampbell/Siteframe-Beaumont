{* $Id: subscriptions.tpl,v 1.1 2005/03/16 20:08:33 glen Exp $
** Copyright (c)2005, Glen Campbell. All rights reserved.
**
** Displays a user's subscriptions
*}
{include file="preamble.tpl"}
{include file="html_head.tpl"}

<h1>{$page_title}</h1>

<div class="content">
<table class="list">
<tr><th>Folder </th><th>Created </th><th>Action </th></tr>
{section name=i loop=$sub}
<tr onmouseover="javascript:highlight_tr(this,true)" onmouseout="javascript:highlight_tr(this,false)" class="{cycle values="odd,even"}">
    <td><a href="{$sub[i].folder.url}">{$sub[i].folder.folder_title}</a> </td>
    <td style="white-space:nowrap;">{$sub[i].sub_created|date_format:"$date_format $time_format"} </td>
    <td>[<a href="{$sub[i].delete_url}">Delete</a>] </td>
</tr>
{/section}
</table>

</div><!-- class="content" -->

{include file="footer.tpl"}
