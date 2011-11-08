{* $Id: edit.tpl,v 1.9 2005/12/02 05:09:25 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** This template displays an input form
*}
{include file="preamble.tpl"}
{include file="html_head.tpl" rte_enable=1}

{if $obj.id}
{menu name="action" text="Return to \"<a href=\"`$obj.url`\">`$obj.title`</a>\""}
{/if}

<h1>{$page_title}</h1>
{if $error ne ""}<p class="error">{$error}</p>{/if}
<div class="content">
<p>{$help_text}</p>
{$edit_form}
</div>{* class="content" *}

{include file="footer.tpl"}
