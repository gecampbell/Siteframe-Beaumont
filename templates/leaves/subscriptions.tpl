{* $Id: subscriptions.tpl,v 1.2 2005/12/22 17:55:54 glen Exp $ *}
{include file="header.tpl"}

<div id="sidebar">
<p>These are your folder subscriptions.</p>
</div>{* id="sidebar" *}

<div id="content">
<h2>{$page_title}</h2>
{if $error ne ""}<p class="error">{$error}</p>{/if}
<table class="list">
<tr><th>Folder </th><th>Created </th><th>Action </th></tr>
{section name=i loop=$sub}
<tr onmouseover="this.style.backgroundColor='lemonchiffon'" onmouseout="this.style.backgroundColor='white'" class="{cycle values="odd,even"}">
    <td><a href="{$sub[i].folder.url}">{$sub[i].folder.folder_title}</a> </td>
    <td style="white-space:nowrap;">{$sub[i].sub_created|date_format:"$date_format $time_format"} </td>
    <td>[<a href="{$sub[i].delete_url}">Delete</a>] </td>
</tr>
{/section}
</table>
</div>{* id="content" *}

{include file="footer.tpl"}