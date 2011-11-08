{* $Id: texts.tpl,v 1.11 2005/11/22 22:33:30 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** generates the user information page
*}
{menu name="action" link="$site_path/edit.php?c=Text" text="New Ad Hoc Page"}
<table class="list">
<tr><th>Name </th><th>Title </th><th>Date </th><th>Excerpt </th></tr>
{section name=cur loop=$text_blocks}
<tr onmouseover="this.style.backgroundColor='lemonchiffon'" onmouseout="this.style.backgroundColor='white'" class="{cycle values="odd,even"}">
<td><a href="{textlink name=`$text_blocks[cur].text_name`}">{$text_blocks[cur].text_name}</a> </td>
<td>{$text_blocks[cur].text_title} </td>
<td style="white-space:nowrap;">{$text_blocks[cur].text_created|date_format:"%Y-%m-%d %H:%I%Z"} </td>
<td>{$text_blocks[cur].text_body|strip_tags|truncate} </td>
</tr>
{/section}
</table>
