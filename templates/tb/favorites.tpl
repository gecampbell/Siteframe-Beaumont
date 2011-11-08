{* $Id: favorites.tpl,v 1.3 2005/12/11 00:12:45 glen Exp $
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

{menu name="action" text="RSS 2.0" link="$rss_url"}

<h1>{$page_title}</h1>
{if $error ne ""}<p class="error">{$error}</p>{/if}

<div id="main">
{section name=item loop=$fav_recent}
{include file="blog_item.tpl" page=$fav_recent[item]}
{sectionelse}
<p>There has been no recent activity by your favorite users.</p>
{/section}
</div>

<div id="menu">
<ul>
<li><big>Favorite Users</big></li>
{section name=u loop=$users}
<li><a href="{$users[u].url}">{$users[u].user_name}</a></li>
{sectionelse}
<li>You have not selected any favorite users.</li>
{/section}
</ul>
</div>{* id="main" *}

{include file="paginator.tpl" curpage=$page numpages=$num_pages url="$site_path/users.php"}
{include file="footer.tpl"}
</div>
</body>
</html>
