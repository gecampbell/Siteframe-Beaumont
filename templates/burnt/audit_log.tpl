{* $Id: audit_log.tpl,v 1.1 2005/11/24 19:00:06 glen Exp $
** Copyright (c)2005, Glen Campbell. All rights reserved.
** This displays the audit log
*}
<table class="list">
<tr><th>Date </th><th>User </th><th>IP Addr </th><th>Module </th><th>Message </th></tr>
{section name=i loop=$log}
<tr onmouseover="this.style.backgroundColor='lemonchiffon'" onmouseout="this.style.backgroundColor='white'" class="{cycle values="odd,even"}">
    <td style="white-space:nowrap;">{$log[i].log_time|date_format:"%Y-%m-%d %H:%I:%S %Z"} </td>
    <td><a href="{$log[i].user.url}">{$log[i].user.user_name}</a> </td>
    <td>{$log[i].log_ip} </td>
    <td>{$log[i].log_module} </td>
    <td>{$log[i].log_msg} </td>
</tr>
{/section}
</table>

{include file="paginator.tpl" curpage=$page numpages=$num_pages url="$url"}
