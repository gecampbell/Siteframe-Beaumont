{* $Id: quotes.tpl,v 1.2 2005/12/31 04:32:12 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** generates the user information page
*}
{include file="top.tpl"}

<div id="mightylinks">
<p><strong>What are quotes?</strong></p>
<p>Quotations are simple pieces of text that can be viewed or shared
with others. It's up to the webmaster to determine how and where 
quotes are used.</p>
</div>{* id="mightylinks" *}

<div class="text">
<h1><strong>{$page_title}</strong></h1>

{if $error ne ""}<p class="error">{$error}</p>{/if}

{menu name="action" text="New Quote" link="$site_path/edit.php?c=Quote"}

<table class="list">
<tr><th>Quotation </th><th>User </th><th>Created </th>
{if $cuser.id}<th>Action </th>{/if}
<tr onmouseover="this.style.backgroundColor='lemonchiffon'" onmouseout="this.style.backgroundColor='white'" class="{cycle values="odd,even"}">
{section name=i loop=$quotes}
<tr>
<td>{$quotes[i].quote_text} </td>
<td><a href="{$quotes[i].user.url}">{$quotes[i].user.title}</a> </td>
<td style="white-space:nowrap;">{$quotes[i].quote_created|ydate:"$date_format $time_format"} </td>
{if $cuser.id}
<td class="action" style="white-space:nowrap;">
    {if $cuser.id eq $quotes[i].user.user_id}
    <a href="{$quotes[i].edit_url}"><img src="{$site_path}/images/icon_pencil.jpg" alt="Edit" title="Edit"/></a>
    <a href="{$quotes[i].delete_url}"><img src="{$site_path}/images/icon_delete.jpg" alt="Delete" title="Delete"/></a>
    {/if}
</td>
{/if}
</tr>
{/section}
</table>
{include file="paginator.tpl" curpage=$page numpages=$num_pages url="$site_path/quotes.php"}
</div>{* class="text" *}

{include file="bottom.tpl"}