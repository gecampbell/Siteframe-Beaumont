{* $Id: links.tpl,v 1.6 2005/12/12 22:14:20 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** generates the user information page
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

{if $error ne ""}<p class="error">{$error}</p>{/if}

<table class="list">
<tr>
    <th><a href="{$site_path}/links.php?u={$user.user_name}">Link</a> </th>
    <th style="width:3em;"><a href="{$site_path}/links.php?u={$user.user_name}&amp;s=link_num_visits%20DESC">Clicks</a> </th>
    <th><a href="{$site_path}/links.php?u={$user.user_name}&amp;s=link_modified%20DESC">Last Time</a> </th>
{if $cuser.id == $user.id}<th style="width:120px;">Action </th>{/if}
</tr>
{section name=i loop=$links}
<tr onmouseover="this.style.backgroundColor='lemonchiffon'" onmouseout="this.style.backgroundColor='white'" class="{cycle values="odd,even"}">
<td style="padding-left:1em; text-indent:-1em;">
<a href="{$site_path}/link.php?id={$links[i].link_id}">{$links[i].link_text}</a>
{$links[i].link_comment}</td>
<td style="text-align:right;">{$links[i].link_num_visits|string_format:"%d"}&nbsp;&nbsp;</td>
<td style="white-space:nowrap;">{$links[i].link_modified|ydate:"$date_format $time_format"}</td>
{if $cuser.id == $user.id}
<td style="white-space:nowrap;">
    <input type="button" value="Edit" class="minibutton"
           onClick="javascript:window.location='{$links[i].edit_url}';" />
    <input type="button" value="Delete" class="minibutton"
           onClick="javascript:window.location='{$links[i].delete_url}';" />
</td>
{/if}
</tr>
{/section}
</table>

{menu name="action" text="New Link" link="$site_path/edit.php?c=Link"}
{include file="footer.tpl"}
</div>
</body>
</html>
