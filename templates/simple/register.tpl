{* $Id: register.tpl,v 1.2 2005/02/27 19:42:05 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** generates the user registration page
*}
{include file="preamble.tpl"}
{include file="html_head.tpl" rte_enable=1}
<h1>{$page_title}</h1>
{if $error ne ""}<p class="error">{$error}</p>{/if}
{$user_form}
{include file="footer.tpl"}
