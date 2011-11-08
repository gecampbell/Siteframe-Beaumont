{* $Id: text.tpl,v 1.2 2006/01/05 16:45:14 glen Exp $ *}
{include file="header.tpl" title=$site_name}

<div id="right-column">
{include file="searchbox.tpl"}
</div>{* id="right-column" *}

<div id="content">
<h1>{$page_title}</h1>
{if $error ne ""}<p class="error">{$error}</p>{/if}
{eval var=$text_body}
</div>{* id="content" *}

{include file="footer.tpl"}