{* $Id: rss_list.tpl,v 1.3 2005/11/07 06:50:32 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** generates the user information page
*}
{include file="preamble.tpl"}
{include file="html_head.tpl" head_type="page" rte_enable=0}

<h1>{$page_title}</h1>

<div class="content">

<h1>{$page_title}</h1>
{if $error ne ""}<p class="error">{$error}</p>{/if}

{menu name="action" link="$site_path/edit.php?c=RSSfeed" text="New RSS Feed"}
<table class="list">
<tr><th>URL </th><th>Ver </th><th>Title </th><th>Date </th><th> TTL</th><th>Description </th><th>Owner </th></tr>
{section name=cur loop=$rss_feeds}
<tr onmouseover="javascript:highlight_tr(this,true)" onmouseout="javascript:highlight_tr(this,false)" class="{cycle values="odd,even"}">
<td><a href="{$rss_feeds[cur].url}">{$rss_feeds[cur].rss_url}</a> </td>
<td style="text-align:right;"> {$rss_feeds[cur].rss_version|string_format:"%.2f"} </td>
<td>{$rss_feeds[cur].rss_title} </td>
<td style="white-space:nowrap;">{$rss_feeds[cur].rss_modified|date_format:"%Y-%m-%d %H:%I%Z"}
</td>
<td style="text-align:right;"> {$rss_feeds[cur].rss_ttl} </td>
<td>{$rss_feeds[cur].rss_description|strip_tags|truncate} </td>
<th><a href="{$rss_feeds[cur].user.url}">{$rss_feeds[cur].user.user_name}</a> </td>
</tr>
{/section}
</table>

</div><!-- class="content" -->

{include file="footer.tpl"}
