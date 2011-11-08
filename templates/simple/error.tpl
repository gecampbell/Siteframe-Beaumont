{* $Id: error.tpl,v 1.1 2005/04/26 02:27:47 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** generates the user information page
*}
{include file="preamble.tpl"}
{include file="html_head.tpl"}

<h1>{$page_title}</h1>

<div class="content">
<div style="width:auto; float:right; font-size:1in; color:blue; line-height:.5in;">{$error_code}</div>
{$error_help}
<ul>
<li>Requested URI: {$REQUEST_URI}</li>
<li>Request Method: {$REQUEST_METHOD}</li>
<li>Remote IP Address: {$REMOTE_ADDR}</li>
<li>Referer: {$HTTP_REFERER}</li>
<li>User Agent: {$HTTP_USER_AGENT}</li>
</ul>
</div><!-- class="content" -->

{include file="footer.tpl"}
