{* $Id: text.tpl,v 1.2 2005/11/27 16:07:48 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** generates the user information page
*}
{include file="top.tpl"}

<div id="mightylinks">
<p><strong>Other Pages</strong></p>
{all class="Text"}
<p><a href="{$text.url}">{$text.title}</a></p>
{/all}
</div>

<div class="text">
<h1>{$page_title}</h1>
<p>{$text_updated|ydate:"$date_format"}</p>
<p>&nbsp;</p>
{if $error ne ""}<p class="error">{$error}</p>{/if}

{eval var=$text_body}
</div>

{include file="bottom.tpl"}