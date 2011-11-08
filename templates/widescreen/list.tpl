{* $Id: list.tpl,v 1.2 2005/11/20 03:02:58 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** generates the user information page
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

<div id="main">
{if $error ne ""}<p class="error">{$error}</p>{/if}
<ul>
{section name=cur loop=$items}
<li><a href="{$items[cur].url}">{$items[cur].title}</a>
&bull;
{if $class ne "User"}
    <a href="{$items[cur].user.url}">{$items[cur].user.user_name}</a>
{/if}
</li>
{/section}
</ul>
{include file="paginator.tpl" curpage=$page numpages=$num_pages url="$site_path/list.php?c=$class"}
</div>{* id="main" *}

{include file="footer.tpl"}
</div>
</body>
</html>
