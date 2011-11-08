{menu name="action" text="Forgot your password?" link="$site_path/pwreset.php"}
{include file="header.tpl"}

<div id="right-column">
{* form help text *}
{if $help_class ne ""}
    <p>
    {if $script eq "delete.php"}
        {lang name="help_delete"}
    {else}
        {lang name="help_$help_class"}
    {/if}
    </p>
{/if}
{if $help_text ne ""}<p>{$help_text}</p>{/if}
</div>

<div id="main-copy">
<h1>{$page_title|default:"Sign On"}</h1>
{if $error ne ""}<p class="error">{$error}</p>{/if}
{$login_form}
</div>

{include file="footer.tpl"}