{* $Id: excerpt.tpl,v 1.2 2006/01/15 02:12:48 glen Exp $
** This generates the page excerpt used on index & folder pages
*}
{if $script eq "index.php"}
<h1>{$page.title}</h1>
{else}
<h2>{$page.title}</h2>
{/if}
<p>
{if $page.num_images}
{section name=i loop=$page.associated_files max=1}
{if $page.associated_files[i].file_mime_type eq "image"}
<a href="{$page.url}"><img src="{thumbnail file=$page.associated_files[i].file_path type=$page.associated_files[i].file_type maxw=154 center=0}" alt="" class="blog_image" /></a>
<br />
{/if}
{/section}
{/if}
{$page.page_text|strip_tags|truncate:350}<br />
<span class="info">
<a href="{$page.url}" title="View this page">Link</a>
({numcomments id=$page.id} comments)
&rsaquo; by <a href="{$page.user.url}" title="View this user">{$page.user.title}</a>
&rsaquo; in <a href="{$page.folder.url}" title="View this folder">{$page.folder.title}</a>
&rsaquo; {$page.page_created|ydate:"$date_format $time_format"}</span></p>
