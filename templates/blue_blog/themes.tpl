{* $Id: themes.tpl,v 1.3 2006/01/05 16:45:14 glen Exp $ *}
{include file="header.tpl"}

<div id="right-column">
</div>{* id="right-column" *}

<div id="content">
<h1>{$page_title}</h1>
{if $error ne ""}<p class="error">{$error}</p>{/if}
<table style="border:none;">
{section name=i loop=$themes}
<tr>
    <td>
    <img src="{$site_path}/{$themes[i].template_dir}/{$themes[i].preview}" alt="" style="border:1px silver solid;" width="160px"/>
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
</div>{* id="content" *}

{include file="footer.tpl"}