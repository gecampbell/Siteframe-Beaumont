{* $Id: register.tpl,v 1.3 2005/11/27 04:41:15 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** generates the user registration page
*}
{include file="top.tpl"}

<div id="mightylinks">
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

<div class="text">
<h1><strong>{$page_title|default:"Register"}</strong></h1>
<p>&nbsp;</p>
{if $error ne ""}<p class="error">{$error}</p>{/if}
{$user_form}
</div>{* class="text" *}

{include file="bottom.tpl"}