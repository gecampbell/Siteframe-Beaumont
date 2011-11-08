{* $Id: list.tpl,v 1.1 2005/11/24 19:00:06 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** generates the user information page
*}
{include file="top.tpl"}

<div id="mightylinks">
</div>

<div class="text">
<h1>{$page_title}</h1>

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
</div>{* class="text" *}

{include file="bottom.tpl"}