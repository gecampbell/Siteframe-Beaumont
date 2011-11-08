{* $Id: subscriptions.tpl,v 1.1 2005/11/24 19:00:06 glen Exp $
** Copyright (c)2005, Glen Campbell. All rights reserved.
**
** Displays a user's subscriptions
*}
{include file="top.tpl"}

<div id="mightylinks">
<p><strong>Subscriptions</strong></p>
<p>&nbsp;</p>
</div>

<div class="text"
<h1>{$page_title}</h1>

<table class="list">
<tr><th>Folder </th><th>Created </th><th>Action </th></tr>
{section name=i loop=$sub}
<tr onmouseover="this.style.backgroundColor='lemonchiffon'" onmouseout="this.style.backgroundColor='white'" class="{cycle values="odd,even"}">
    <td><a href="{$sub[i].folder.url}">{$sub[i].folder.folder_title}</a> </td>
    <td style="white-space:nowrap;">{$sub[i].sub_created|date_format:"$date_format $time_format"} </td>
    <td><a href="{$sub[i].delete_url}" title="Delete this subscription"><img src="{$site_path}/images/icon_delete.jpg" alt="" /></a> </td>
</tr>
{/section}
</table>
</div>{* class="text" *}

{include file="bottom.tpl"}
