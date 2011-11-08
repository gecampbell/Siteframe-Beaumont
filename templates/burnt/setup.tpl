{* $Id: setup.tpl,v 1.1 2005/11/24 19:00:06 glen Exp $
** Copyright (c)2005, Glen Campbell. All rights reserved.
** This template is used to generate the setup page
*}
{include file="top.tpl" setup=1}

<div id="mightylinks">
    {if $error eq "" && $setup_pass eq 1}
    <p>Congratulations! If you've reached this far, it means that the
    <code>siteframe.ini</code> file has been set up correctly and we're able
    to connect to the database. Next, we need to create the database tables
    and an administrator's account.</p>
    {elseif $error ne ""}
    <p>Errors were detected; please correct them and try again.</p>
    {/if}
    {if $setup_pass eq 1}
    <p>Enter the information to create an
    administrator's account using the form, and then press the
    "Continue with setup" button. This will proceed to create the necessary
    tables.</p>
    {/if}
    {if $setup_pass eq 2}
    <p>Please check the output very carefully for errors, which
    are indicated using <span style="color:red;">red</span> text.</p>
    {/if}
</div>{* id="mightylinks" *}

<div class="text">
<h1><strong>{$page_title}</strong></h1>
<p>&nbsp;</p>

{if $error ne ""}<p class="error">{$error}</p>{/if}

{if $setup_pass eq 1}
    {$setup_form}
{else}
    {$setup_output}
{/if}
</div>{* class="text" *}

{include file="bottom.tpl"}