{* $Id: users.tpl,v 1.22 2006/01/02 20:03:05 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** generates the user information page
*}
{include file="preamble.tpl"}
{include file="html_head.tpl"}

<h1>{$page_title}</h1>

<div class="content">

{if $error ne ""}<p class="error">{$error}</p>{/if}

<table class="list">
<tr><th>User </th><th>Full Name </th><th>Joined </th><th>Last Login </th><th>Rating </th>
</tr>
{section name=u loop=$users}
<tr onmouseover="javascript:highlight_tr(this,true)" onmouseout="javascript:highlight_tr(this,false)" class="{cycle values="odd,even"}">
<td><a href="{$users[u].url}">{$users[u].user_name}</a> </td>
<td>{$users[u].user_firstname} {$users[u].user_lastname} </td>
<td>{$users[u].user_created|ydate:"$date_format"} </td>
<td>{$users[u].last_login|ydate:"$date_format"} </td>
<td style="text-align:right;">{avgrating class="User" id=$users[u].id} </td>
</tr>
{/section}
</table>

</div><!-- content -->

{include file="paginator.tpl" curpage=$page numpages=$num_pages url="$site_path/users.php"}

{include file="footer.tpl"}
