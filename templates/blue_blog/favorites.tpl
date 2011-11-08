{* $Id: favorites.tpl,v 1.2 2006/01/05 16:45:14 glen Exp $ *}
{include file="header.tpl"}

<div id="right-column">
<h3>Favorite Users</h3>
<ul>
{section name=u loop=$users}
<li><a href="{$users[u].url}">{$users[u].user_name}</a></li>
{sectionelse}
<li>No favorite users.</li>
{/section}
</ul>
</div>{* id="right-column" *}

<div id="content">
<h1>{$page_title}</h1>
{if $error ne ""}<p class="error">{$error}</p>{/if}
{section name=item loop=$fav_recent}
{include file="excerpt.tpl" page=$fav_recent[item]}
{sectionelse}
<p>No recent activity by favorite users.</p>
{/section}
</div>{* id="content" *}

{include file="footer.tpl"}