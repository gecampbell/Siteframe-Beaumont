{* $Id: templates.tpl,v 1.1 2005/11/24 19:00:06 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** generates the user information page
*}
{include file="top.tpl"}

{menu name="action" text="New Template" link="$site_path/edit.php?c=Template"}

<div id="mightylinks">
<p><strong>About This Page</strong></p>
<p>Templates are used to customize the appearance of a page.
You should be familiar with Siteframe and Smarty before attempting to
create your own custom template.</p>
</div>

<div class="text">
<h1>{$page_title}</h1>
<p>&nbsp;</p>
{if $error ne ""}<p class="error">{$error}</p>{/if}

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
<td class="action" style="white-space:nowrap;">
    {if $cuser.id eq $templates[i].user.user_id || $cuser.admin}
    <a href="{$templates[i].edit_url}"><img src="{$site_path}/images/icon_pencil.jpg" alt="Edit" title="Edit"/></a>
    <a href="{$templates[i].delete_url}"><img src="{$site_path}/images/icon_delete.jpg" alt="Delete" title="Delete"/></a>
    {/if}
</td>
</tr>
{/section}
</table>
{include file="paginator.tpl" curpage=$page numpages=$num_pages url="$site_path/users.php"}
</div>{* class="text" *}

{include file="bottom.tpl"}