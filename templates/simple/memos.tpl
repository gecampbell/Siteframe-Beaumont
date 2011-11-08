{* $Id: memos.tpl,v 1.6 2005/03/27 16:35:45 glen Exp $
** Copyright (c)2005, Glen Campbell. All rights reserved.
** This page displays a user's online memos
*}
{include file="preamble.tpl"}
{include file="html_head.tpl"}
<h1>{$page_title}</h1>

<div class="content">

    {if $error ne ""}<p class="error">{$error}</p>{/if}

    <div class="action">
    <a href="{$site_path}/edit.php?c=Memo">Send a new memo</a>
    </div>

<table class="list">
<tr><th>Message </th><th style="width:120px;">Action </th></tr>
{section name=i loop=$memos}
<tr onmouseover="javascript:highlight_tr(this,true)" onmouseout="javascript:highlight_tr(this,false)" class="{cycle values="odd,even"}">
<td style="color:black;">
<strong style="font-size:larger;"><a href="javascript:toggle('memo{$memos[i].memo_id}');">{$memos[i].memo_subject}</a></strong>
<br />
{if !$memos[i].memo_read}<b style="color:red;">New!</b> {/if}
<em style="color:gray;">from 
<a href="{$memos[i].from.url}">{$memos[i].from.user_name}</a>
{$memos[i].memo_created|ydate:"at $time_format on $date_format"}</em><br />
<div id="memo{$memos[i].memo_id}" class="memo" {if $memos[i].memo_read}style="display:none;"{/if}>
{$memos[i].memo_body}
</div>
</td>
<td style="white-space:nowrap;">
<input type="button" value="{lang name="delete"}" onClick="document.location='{$memos[i].delete_url}&r={$memos[i].url|escape:"url"}';" class="minibutton" /> 
<input type="button" value="{lang name="reply"}" onClick="document.location='{$site_path}/edit.php?c=Memo&memo_to_user_id={$memos[i].memo_from_user_id}&memo_subject=Re:%20{$memos[i].memo_subject|escape:"url"}';" class="minibutton"/>
</td>
</tr>
{/section}
</table>

</div>{* end class="content" *}

{include file="paginator.tpl" curpage=$page numpages=$num_pages url="$site_path/users.php"}

{include file="footer.tpl"}
