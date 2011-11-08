{* $Id: folders.tpl,v 1.2 2005/11/05 23:02:07 glen Exp $
** Copyright (c)2005, Glen Campbell. All rights reserved.
** This page displays all folders
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

<div id="main">
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
</div>

{include file="paginator.tpl" curpage=$page numpages=$num_pages url="$site_path/folders.php"}
{include file="footer.tpl"}
</div>
</body>
</html>
