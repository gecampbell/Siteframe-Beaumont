{* $Id: text.tpl,v 1.3 2005/11/29 04:41:04 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** generates the user information page
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
{if $error ne ""}<p class="error">{$error}</p>{/if}

<div id="main">
{eval var=$text_body}
</div>

<div id="menu">
{include file="minisearch.tpl"}
</div>

{include file="footer.tpl"}
</div>{* id="content" *}
</body>
</html>
