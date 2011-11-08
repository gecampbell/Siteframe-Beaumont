{* $Id: edit.tpl,v 1.6 2005/12/06 17:17:05 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** This template displays an input form
*}
{include file="preamble.tpl"}
<html>
<head>
{include file="html_head.tpl" rte_enable=1}
</head>
<body>
<div id="content">
{include file="header.tpl"}

<h1>{$page_title}</h1>
{if $error ne ""}<p class="error">{$error}</p>{/if}

<div id="main">

  {$edit_form}

</div>{* id="main" *}

<div id="menu">
<p>{$help_text}</p>
</div>

{if $obj.id}
    {menu name="action" text="Return to \"<a href=\"`$obj.url`\">`$obj.title`</a>\""}
{/if}

{include file="footer.tpl"}
</div>{* id="content" *}
</body>
</html>
