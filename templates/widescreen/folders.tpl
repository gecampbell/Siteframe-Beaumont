{* $Id: folders.tpl,v 1.2 2005/11/20 03:02:58 glen Exp $
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
{include file="paginator.tpl" curpage=$page numpages=$num_pages url="$site_path/folders.php"}
</div>

{include file="footer.tpl"}
</div>
</body>
</html>
