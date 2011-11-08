{* $Id: templates.tpl,v 1.3 2005/11/06 22:01:27 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** generates the user information page
*}
{include file="preamble.tpl"}
{include file="html_head.tpl"}

<h1>{$page_title}</h1>

<div class="content">

{if $error ne ""}<p class="error">{$error}</p>{/if}

{menu name="action" text="New Template" link="$site_path/edit.php?c=Template"}

<table class="list">
<tr><th>P </th><th>Template </th><th>Description </th><th>Object </th><th>Owner </th><th>Last Modified </th><th>Action </th></tr>
{section name=i loop=$templates}
<tr onmouseover="javascript:highlight_tr(this,true)" onmouseout="javascript:highlight_tr(this,false)" class="{cycle values="odd,even"}">
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

</div><!-- content -->

{include file="paginator.tpl" curpage=$page numpages=$num_pages url="$site_path/users.php"}

{include file="footer.tpl"}
