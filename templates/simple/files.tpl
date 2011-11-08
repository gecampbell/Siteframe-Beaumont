{* $Id: files.tpl,v 1.2 2005/02/26 20:38:47 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** generates the user information page
*}
{include file="preamble.tpl"}
{include file="html_head.tpl"}

<h1>{$page_title}</h1>

<div class="content">
{if $error ne ""}<p class="error">{$error}</p>{/if}

<ul>
{section name=i loop=$user_files}
<li><a href="{$user_files[i].url}">{$user_files[i].file_name}</a></li>
{/section}
</ul>

</div><!-- class="content" -->

{include file="footer.tpl"}