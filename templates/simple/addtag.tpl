{* $Id: addtag.tpl,v 1.10 2005/12/18 05:37:12 glen Exp $
** Copyright (c)2005, Glen Campbell. All rights reserved.
** used to add a new tag to an existing page
**
** used like this: {include file="addtag.tpl" page_id=$id}
*}
{menu name="action" text="Add Tags" 
      link="javascript:show('addtagform');setfocus('tagset');"}
<a name="addtag"></a>
<div id="addtagform" style="display:none;">
{if $url_rewriting}
{assign var="posturl"
        value="$site_path/api/V1/Page/$page_name"}
{else}
{assign var="posturl"
        value="$site_path/api.php?v=1&r=Page&id=$page_name"}
{/if}
<form action="{$posturl}" method="post">
<input type="hidden" name="rd" value="{$site_url_base}{$url}" />
<input type="hidden" name="partial" value="1" />
<input type="hidden" name="key" value="{$cuser.user_hash}" />
New Tags: <input type="text" name="new_tags" id="tagset" />
<input type="submit" value="Go" onclick="swap('addtagform','addtagwait')" /><br/>
<small>Enter tags separated by spaces.</small>
</form>
</div>{* id="addtagform" *}
<div id="addtagwait" style="display:none;">
One moment, please...
</div>
