{* $Id: excerpt.tpl,v 1.7 2005/12/23 15:17:31 glen Exp $
** This generates the page excerpt used on index & folder pages
*}
<h3>{$page.title}</h3>
{if $page.num_images}
<div class="blog_images">
{section name=i loop=$page.associated_files max=1}
{if $page.associated_files[i].file_mime_type eq "image"}
<a href="{$page.url}"><img src="{thumbnail file=$page.associated_files[i].file_path type=$page.associated_files[i].file_type size=64 center=1}" alt="" class="blog_image" /></a>
{/if}
{/section}
</div>
{/if}
<p>{$page.page_text|strip_tags|truncate:350}<br />
<span class="info">
<a href="{$page.url}" title="View this page">Link</a>
({numcomments id=$page.id} comments)
&bull; by <a href="{$page.user.url}" title="View this user">{$page.user.title}</a>
&bull; in <a href="{$page.folder.url}" title="View this folder">{$page.folder.title}</a>
&bull; {$page.page_created|ydate:"$date_format $time_format"}</span></p>
