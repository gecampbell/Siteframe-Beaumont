{* $Id: admin.tpl,v 1.4 2005/04/21 03:34:01 glen Exp $
** Copyright (c)2005, Glen Campbell. All rights reserved.
**
** This page is used for administrator functions
*}
{include file="preamble.tpl"}
{include file="html_head.tpl" rte_enable=1}
<h1>{$page_title}</h1>
<div class="content">
{if $error ne ""}<p class="error">{$error}</p>{/if}
{$admin_content}
</div><!-- class="content" -->
{include file="footer.tpl"}
