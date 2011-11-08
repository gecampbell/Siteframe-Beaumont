{* $Id: register.tpl,v 1.1 2005/12/21 18:49:44 glen Exp $ *}
{include file="header.tpl"}

<div id="sidebar">
Use this page to create a new account on this website.
</div>{* id="sidebar" *}

<div id="content">
<h2>{$page_title}</h2>
{if $error ne ""}<p class="error">{$error}</p>{/if}
{$user_form}
</div>{* id="content" *}

{include file="footer.tpl"}