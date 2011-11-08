{* $Id: subscriptions.tpl,v 1.3 2005/11/22 06:03:27 glen Exp $
** Copyright (c)2005, Glen Campbell. All rights reserved.
**
** Displays a user's subscriptions
*}
{include file="preamble.tpl"}
<html>
<head>
{include file="html_head.tpl" rte_enable=0}
</head>
<body>
<div id="content">
{include file="header.tpl"}

<h1>{$page_title}</h1>

<div id="main">
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
</div>{* id="main" *}

{include file="footer.tpl"}
</div>
</body>
</html>