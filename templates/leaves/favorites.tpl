{* $Id: favorites.tpl,v 1.2 2005/12/20 23:53:34 glen Exp $ *}
{include file="header.tpl"}

<div id="sidebar">
<h3>Favorite Users</h3>
<ul>
{section name=u loop=$users}
<li><a href="{$users[u].url}">{$users[u].user_name}</a></li>
{sectionelse}
<li>No favorite users.</li>
{/section}
</ul>
</div>{* id="sidebar" *}

<div id="content">
<h2>{$page_title}</h2>
{if $error ne ""}<p class="error">{$error}</p>{/if}
{section name=item loop=$fav_recent}
{include file="excerpt.tpl" page=$fav_recent[item]}
{sectionelse}
<p>No recent activity by favorite users.</p>
{/section}
</div>{* id="content" *}

{include file="footer.tpl"}