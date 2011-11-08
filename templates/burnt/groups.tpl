{* $Id: groups.tpl,v 1.3 2005/12/10 06:45:01 glen Exp $
** Copyright (c)2005, Glen Campbell. All rights reserved.
** This page displays all folders
*}
{include file="top.tpl"}

<div id="mightylinks">
&nbsp;
</div>{* id="mightylinks" *}

<div class="text">
{menu name="action" link="$site_path/edit.php?c=Group" text="Create New Group"}
<h1><strong>{$page_title}</strong></h1>
<p>&nbsp;</p>

{section name=cur loop=$groups}
<p class="blog_item">
<big><a href="{$groups[cur].url}">{$groups[cur].title}</a></big>
{$groups[cur].group_text|strip_tags|truncate:300}
<span class="info">
/ <a href="{$groups[cur].user.url}">{$groups[cur].user.user_name}</a>
/ {$groups[cur].group_created|ydate:"on $date_format at $time_format"}
</span>
</p>
{/section}
{include file="paginator.tpl" curpage=$page numpages=$num_pages url="$site_path/groups.php"}
</div>{* class="text" *}

{include file="bottom.tpl"}