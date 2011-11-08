{* $Id: admin.tpl,v 1.2 2005/12/06 20:00:24 glen Exp $
** Copyright (c)2005, Glen Campbell. All rights reserved.
**
** This page is used for administrator functions
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
{if $error ne ""}<p class="error">{$error}</p>{/if}
{$admin_content}
{include file="footer.tpl"}
</div>
</body>
</html>
