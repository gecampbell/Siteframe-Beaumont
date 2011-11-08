{* $Id: error.tpl,v 1.2 2005/12/22 06:44:45 glen Exp $ *}
{include file="header.tpl"}

<div id="sidebar">
</div>{* id="sidebar" *}

<div id="content">
<h2>{$page_title}</h2>
{if $error ne ""}<p class="error">{$error}</p>{/if}
{$error_help}
<ul>
<li>Requested URI: {$REQUEST_URI}</li>
<li>Request Method: {$REQUEST_METHOD}</li>
<li>Remote IP Address: {$REMOTE_ADDR}</li>
<li>Referer: {$HTTP_REFERER}</li>
<li>User Agent: {$HTTP_USER_AGENT}</li>
</ul>
</div>{* id="content" *}

{include file="footer.tpl"}