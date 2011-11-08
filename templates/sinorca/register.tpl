{* $Id: register.tpl,v 1.1 2006/01/12 04:33:16 glen Exp $ *}
{include file="header.tpl"}

<div id="right-column">
Use this page to create a new account on this website.
</div>{* id="right-column" *}

<div id="main-copy">
<h1>{$page_title}</h1>
{if $error ne ""}<p class="error">{$error}</p>{/if}
{$user_form}
</div>{* id="main-copy" *}

{include file="footer.tpl"}