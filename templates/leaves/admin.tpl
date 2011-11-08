{* $Id: admin.tpl,v 1.1 2005/12/20 05:59:13 glen Exp $ *}
{include file="header.tpl"}

<div id="sidebar">
</div>{* id="sidebar" *}

<div id="content">
<h2>{$page_title}</h2>
{if $error ne ""}<p class="error">{$error}</p>{/if}
{$admin_content}
</div>{* id="content" *}

{include file="footer.tpl"}