{* $Id: templates.tpl,v 1.1 2005/12/21 20:44:19 glen Exp $ *}
{include file="header.tpl"}
{menu name="action" text="New Template" link="$site_path/edit.php?c=Template"}

<div id="sidebar">
</div>{* id="sidebar" *}

<div id="content">
<h2>{$page_title}</h2>
{if $error ne ""}<p class="error">{$error}</p>{/if}
{include file="paginator.tpl" curpage=$page numpages=$num_pages url="$site_path/users.php"}
<table class="list">
<tr><th>P </th><th>Template </th><th>Description </th><th>Object </th><th>Owner </th><th>Last Modified </th><th>Action </th></tr>
{section name=i loop=$templates}
<tr onmouseover="this.style.backgroundColor='lemonchiffon'" onmouseout="this.style.backgroundColor='white'" class="{cycle values="odd,even"}">
<td>{if $templates[i].tpl_public}*{else}&nbsp;{/if} </td>
<td><b>{$templates[i].tpl_name}</b> </td>
<td>{$templates[i].tpl_descr} </td>
<td>{$templates[i].tpl_class} </td>
<td><a href="{$templates[i].user.url}">{$templates[i].user.title}</a> </td>
<td style="white-space:nowrap;">{$templates[i].tpl_modified|ydate:"$date_format"} </td>
<td style="white-space:nowrap;">
<input type="button" onClick="window.location='{$templates[i].edit_url}';" value="Edit" class="minibutton" />
<input type="button" onClick="window.location='{$templates[i].delete_url}';" value="Delete" class="minibutton" /> </td>
</tr>
{/section}
</table>
</div>{* id="content" *}

{include file="footer.tpl"}