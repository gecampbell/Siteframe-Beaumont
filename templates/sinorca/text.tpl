{* $Id: text.tpl,v 1.1 2006/01/12 04:33:16 glen Exp $ *}
{include file="header.tpl" title=$site_name}

<div id="right-column">
{include file="searchbox.tpl"}
</div>{* id="right-column" *}

<div id="main-copy">
<h1>{$page_title}</h1>
{if $error ne ""}<p class="error">{$error}</p>{/if}
{eval var=$text_body}
</div>{* id="main-copy" *}

{include file="footer.tpl"}