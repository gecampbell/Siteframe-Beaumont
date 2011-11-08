{* $Id: edit.tpl,v 1.5 2005/12/02 05:09:24 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** This template displays an input form
*}
{include file="top.tpl" rte_enable=TRUE}
{if $obj.id}
{menu name="action" text="Return to \"<a href=\"`$obj.url`\">`$obj.title`</a>\""}
{/if}

<div id="mightylinks">
<p>{$help_text}</p>
</div>

<div class="text">
<h1><strong>{$page_title|default:"Register"}</strong></h1>
<p>&nbsp;</p>
{if $error ne ""}<p class="error">{$error}</p>{/if}
{$edit_form}
</div>{* class="text" *}

{include file="bottom.tpl"}