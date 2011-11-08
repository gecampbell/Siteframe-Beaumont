{* $Id: register.tpl,v 1.10 2005/11/10 22:10:20 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** generates the user registration page
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
{$user_form}
</div>
{include file="footer.tpl"}
</div>
</body>
</html>
