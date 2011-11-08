{* $Id: setup.tpl,v 1.2 2005/11/06 03:26:33 glen Exp $
** Copyright (c)2005, Glen Campbell. All rights reserved.
** This template is used to generate the setup page
*}
{include file="preamble.tpl"}
<html>
<head>
{include file="html_head.tpl" rte_enable=0}
</head>
<body>
<div id="content">
{include file="header.tpl"}
<h1>{$page_title}</h1>

{if $error ne ""}<p class="error">{$error}</p>{/if}

<div id="main">
{if $setup_pass eq 1}
    {$setup_form}
{else}
    {$setup_output}
{/if}
</div>{* id="main" *}

<div id="menu">
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
</div>{* id="menu" *}

{include file="footer.tpl"}
</div>{* id="content" *}
</body>
</html>