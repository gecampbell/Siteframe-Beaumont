{* $Id: setup.tpl,v 1.4 2005/02/27 19:42:05 glen Exp $
** Copyright (c)2005, Glen Campbell. All rights reserved.
** This template is used to generate the setup page
*}
{include file="preamble.tpl"}
{include file="html_head.tpl"}
<h1>{$page_title}</h1>

{if $error ne ""}<div class="content"><p class="error">{$error}</p></div>{/if}

{if $setup_pass eq 1}
    <div class="content">
    {if $error eq ""}
    <p>Congratulations! If you've reached this far, it means that the
    <code>siteframe.ini</code> file has been set up correctly and we're able
    to connect to the database. Next, we need to create the database tables
    and an administrator's account.</p>
    {else}
    <p>Errors were detected; please correct them and try again.</p>
    {/if}
    <p>Enter the information to create an
    administrator's account using the form below, and then press the
    "Continue with setup" button. This will proceed to create the necessary
    tables.</p>
    </div><!-- class="content" -->
    {$setup_form}
{else}
    <div class="content">
    <p>Please check very carefully below for errors:</p>
    </div><!-- class="content" -->
    {$setup_output}
{/if}
{include file="footer.tpl"}