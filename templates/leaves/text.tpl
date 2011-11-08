{* $Id: text.tpl,v 1.2 2005/12/23 05:25:53 glen Exp $ *}
{include file="header.tpl" title=$site_name}

<div id="sidebar">
</div>{* id="sidebar" *}

<div id="content">
<h2>{$page_title}</h2>
{if $error ne ""}<p class="error">{$error}</p>{/if}
{eval var=$text_body}
</div>{* id="content" *}

{include file="footer.tpl"}