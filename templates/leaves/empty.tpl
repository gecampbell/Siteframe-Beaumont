{* $Id: empty.tpl,v 1.1 2005/12/20 23:34:39 glen Exp $ *}
{include file="header.tpl"}

<div id="sidebar">
</div>{* id="sidebar" *}

<div id="content">
<h2>{$page_title}</h2>
{if $error ne ""}<p class="error">{$error}</p>{/if}

</div>{* id="content" *}

{include file="footer.tpl"}