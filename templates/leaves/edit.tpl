{include file="header.tpl" rte_enable=1}

<div id="sidebar">
<p>{$help_text}</p>
</div>

<div id="content">
<h2>{$page_title|default:"Sign On"}</h2>
{if $error ne ""}<p class="error">{$error}</p>{/if}
{$edit_form}
</div>

{include file="footer.tpl"}