{* $Id: quotes.tpl,v 1.3 2005/12/31 04:32:12 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** generates the user information page
*}
{include file="preamble.tpl"}
{include file="html_head.tpl"}

<h1>{$page_title}</h1>

<div class="content">

{if $error ne ""}<p class="error">{$error}</p>{/if}

{menu name="action" text="New Quote" link="$site_path/edit.php?c=Quote"}

<table class="list">
<tr><th>Quotation </th><th>User </th><th>Created </th>
{if $cuser.id}<th>Action </th>{/if}
</tr>
{section name=i loop=$quotes}
<tr onmouseover="javascript:highlight_tr(this,true)" onmouseout="javascript:highlight_tr(this,false)" class="{cycle values="odd,even"}">
<td>{$quotes[i].quote_text} </td>
<td><a href="{$quotes[i].user.url}">{$quotes[i].user.title}</a> </td>
<td style="white-space:nowrap;">{$quotes[i].quote_created|ydate:"$date_format $time_format"} </td>
{if $cuser.id}
<td class="action" style="white-space:nowrap;">
    {if $cuser.id eq $quotes[i].user.user_id}
    <a href="{$quotes[i].edit_url}">Edit</a>
    <a href="{$quotes[i].delete_url}">Delete</a>
    {/if}
</td>
{/if}
</tr>
{/section}
</table>

</div><!-- content -->

{include file="paginator.tpl" curpage=$page numpages=$num_pages url="$site_path/quotes.php"}

{include file="footer.tpl"}
