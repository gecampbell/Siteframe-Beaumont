{* $Id: error.tpl,v 1.1 2006/01/12 04:33:16 glen Exp $ *}
{include file="header.tpl"}

<div id="right-column">
</div>{* id="right-column" *}

<div id="main-copy">
<h1>{$page_title}</h1>
{if $error ne ""}<p class="error">{$error}</p>{/if}
{$error_help}
<ul>
<li>Requested URI: {$REQUEST_URI}</li>
<li>Request Method: {$REQUEST_METHOD}</li>
<li>Remote IP Address: {$REMOTE_ADDR}</li>
<li>Referer: {$HTTP_REFERER}</li>
<li>User Agent: {$HTTP_USER_AGENT}</li>
</ul>
</div>{* id="main-copy" *}

{include file="footer.tpl"}