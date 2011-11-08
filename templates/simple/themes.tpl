{* $Id: themes.tpl,v 1.3 2006/01/05 14:48:36 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** generates the user information page
*}
{include file="preamble.tpl"}
{include file="html_head.tpl"}

<h1>{$page_title}</h1>

<div class="content">
{if $error ne ""}<p class="error">{$error}</p>{/if}

<table style="border:none;">
{section name=i loop=$themes}
<tr>
    <td>
    <img src="{$site_path}/{$themes[i].template_dir}/{$themes[i].preview}" alt="" style="border:1px gray solid;" width="240px"/>
    </td>
    <td> &nbsp; </td>
    <td>
    <b>{$themes[i].title}</b><br/>
    Revision: {$themes[i].revision}<br/>
    Created by: {$themes[i].created_by}<br/>
    Home page: <a href="{$themes[i].homepage}">{$themes[i].homepage}</a><br/>
    <em>{$themes[i].copyright}</em>
    <p>{$themes[i].notes}</p>
    </td>
</tr>
{/section}
</table>

</div><!-- content -->

{include file="footer.tpl"}
