{* $Id: sitemap.tpl,v 1.1 2005/11/19 22:22:58 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** creates a site map
*}
{include file="preamble.tpl"}
<html>
<head>
{include file="html_head.tpl" rte_enable=1}
</head>
<body>
<div id="content">
{include file="header.tpl"}

<h1>{$page_title}</h1>

<div id="main">
{section name=i loop=$folders}
    <div style="margin-left:{$folders[i].level}em">
    <strong><a href="{$folders[i].url}">{$folders[i].title}</a></strong>
    {$folders[i].folder_text|strip_tags|truncate}
    </div>
{/section}
</div>{* id="main" *}

{include file="footer.tpl"}
</div>{* end id="content" *}
</body>
</html>
