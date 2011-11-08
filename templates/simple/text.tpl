{* $Id: text.tpl,v 1.5 2005/11/27 16:07:48 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** generates the user information page
*}
{include file="preamble.tpl"}
{include file="html_head.tpl"}

<h1>{$page_title}</h1>

<div class="content">
{if $error ne ""}<p class="error">{$error}</p>{/if}

{eval var=$text_body}

</div><!-- class="content" -->

{include file="footer.tpl"}