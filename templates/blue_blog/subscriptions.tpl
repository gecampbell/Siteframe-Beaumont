{* $Id: subscriptions.tpl,v 1.2 2006/01/05 16:45:14 glen Exp $ *}
{include file="header.tpl"}

<div id="right-column">
<p>These are your folder subscriptions.</p>
</div>{* id="right-column" *}

<div id="content">
<h1>{$page_title}</h1>
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