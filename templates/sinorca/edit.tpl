{include file="header.tpl" rte_enable=1}

<div id="main-copy" style="width:580px;background:white;">
<h1>{$page_title|default:"Sign On"}</h1>
{if $error ne ""}<p class="error">{$error}</p>{/if}
<p>{$help_text}</p>
{$edit_form}
</div>

{include file="footer.tpl"}