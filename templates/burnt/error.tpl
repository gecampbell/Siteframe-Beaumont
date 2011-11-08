{* $Id: error.tpl,v 1.2 2005/11/27 16:47:19 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** generates the user information page
*}
{include file="top.tpl"}

<div id="mightylinks">
<p><strong>Error code</strong></p>
<p>{$error_code}</p>
</div>

<div class="text">
<h1><strong>{$page_title}</strong></h1>
<p>&nbsp;</p>

{$error_help}
<ul>
<li>Requested URI: {$REQUEST_URI}</li>
<li>Request Method: {$REQUEST_METHOD}</li>
<li>Remote IP Address: {$REMOTE_ADDR}</li>
<li>Referer: {$HTTP_REFERER}</li>
<li>User Agent: {$HTTP_USER_AGENT}</li>
</ul>
</div>{* class="text" *}

{include file="bottom.tpl"}