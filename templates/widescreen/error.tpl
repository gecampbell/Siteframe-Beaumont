{* $Id: error.tpl,v 1.1 2005/11/19 22:22:58 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** generates the user information page
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

<div style="width:auto; float:right; font-size:1in; color:red; line-height:.5in;">{$error_code}</div>
{$error_help}
{include file="minisearch.tpl"}
<ul>
<li>Requested URI: {$REQUEST_URI}</li>
<li>Request Method: {$REQUEST_METHOD}</li>
<li>Remote IP Address: {$REMOTE_ADDR}</li>
<li>Referer: {$HTTP_REFERER}</li>
<li>User Agent: {$HTTP_USER_AGENT}</li>
</ul>

{include file="footer.tpl"}
</div><!-- id="content" -->
</body>
</html>
