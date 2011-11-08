{* $Id: invitations.tpl,v 1.1 2005/11/24 19:00:06 glen Exp $
** Copyright (c)2005, Glen Campbell. All rights reserved.
** This displays the audit log
*}
<table class="list">
<tr><th>Accepted </th><th>User (inviter) </th><th>E-mail addr </th><th>Created </th><th>Modified </th></tr>
{section name=i loop=$inv}
<tr onmouseover="this.style.backgroundColor='lemonchiffon'" onmouseout="this.style.backgroundColor='white'" class="{cycle values="odd,even"}">
    <td>{if $inv[i].inv_accepted}Y{else}N{/if} </td>
    <td><a href="{$inv[i].user.url}">{$inv[i].user.user_name}</a> </td>
    <td>{$inv[i].inv_email} </td>
    <td style="white-space:nowrap;">{$inv[i].inv_created|ydate:"$date_format $time_format"} </td>
    <td style="white-space:nowrap;">{$inv[i].inv_modified|ydate:"$date_format $time_format"} </td>
</tr>
{/section}
</table>

{include file="paginator.tpl" curpage=$page numpages=$num_pages url="$url"}
