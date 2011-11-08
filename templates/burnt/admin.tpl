{* $Id: admin.tpl,v 1.3 2005/12/06 20:00:24 glen Exp $
** Copyright (c)2005, Glen Campbell. All rights reserved.
**
** This page is used for administrator functions
*}
{include file="top.tpl" rte_enable=1}

<div id="mightylinks">
Administrators only.
</div>

<div class="text">
<h1>{$page_title}</h1>
<p>&nbsp;</p>
{if $error ne ""}<p class="error">{$error}</p>{/if}
{$admin_content}
</div>{* class="text" *}

{include file="bottom.tpl"}