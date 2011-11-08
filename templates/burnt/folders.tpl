{* $Id: folders.tpl,v 1.2 2005/11/24 23:41:07 glen Exp $
** Copyright (c)2005, Glen Campbell. All rights reserved.
** This page displays all folders
*}
{include file="top.tpl"}

<div id="mightylinks">
<p><strong>What is a folder?</strong></p>
<p>A folder, like a folder on your desktop computer, is a container
for other objects. Typically, a folder holds pages, which contain text
and optional file attachments. A folder can also (optionally) contain 
subfolders.</p>
</div>

<div class="text">
<h1><strong>{$page_title}</strong></h1>
<p>&nbsp;</p>

{section name=cur loop=$folders}
<p class="blog_item">
<big><a href="{$folders[cur].url}">{$folders[cur].folder_title}</a></big>
{$folders[cur].folder_text|strip_tags|truncate:300}
<span class="info">
/ <a href="{$folders[cur].user.url}">{$folders[cur].user.user_name}</a>
/ {$folders[cur].folder_created|ydate:"on $date_format at $time_format"}
</span>
</p>
{/section}
{include file="paginator.tpl" curpage=$page numpages=$num_pages url="$site_path/folders.php"}
</div>{* class="text" *}

{include file="bottom.tpl"}