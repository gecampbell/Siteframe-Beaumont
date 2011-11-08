{* $Id: sitemap.tpl,v 1.4 2005/11/27 15:18:25 glen Exp $
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
<p>
{section name=i loop=$folders}
    <div style="margin-left:{$folders[i].level}em">
    <strong><a href="{$folders[i].url}">{$folders[i].title}</a></strong>
    {$folders[i].folder_text|strip_tags|truncate}
    </div>
{/section}
</p>
<p>&nbsp;</p>
</div>{* id="main" *}

<div id="menu">
<p>The site map shows the structure of all the folders on the 
site; child folders are indented underneath their parents.
To navigate to a specific folder, simply click on the
folder name.</p>
</div>{* id="menu" *}

{include file="footer.tpl"}
</div>{* end id="content" *}
</body>
</html>
