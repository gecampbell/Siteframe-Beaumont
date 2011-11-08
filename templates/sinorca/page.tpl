{include file="header.tpl" title=$folder.folder_title subtitle=$folder.folder_text}
{menu name="action" 
      text="Add a Comment" 
      link="$site_path/edit.php?c=Comment&comment_page_id=$page_id"}

<div id="right-column">
<p>{if $user.user_photo ne ""}
<a href="{$user.url}" title="Go to {$user.title}'s page"><img src="{thumbnail file=$user.user_photo type=$user.user_photo_type maxw=72}" alt="{$user.user_name}"/></a>
<br />
{/if}
by <a href="{$user.url}">{$user.title}</a><br />
in <a href="{$folder.url}">{$folder.title}</a><br />
{$page_created|ydate:"$date_format $time_format"}</p>
{include file="../rating.tpl"}
<h3>Tags</h3>
<ul>
{section name=i loop=$tags}
<li><a href="{$tags[i].url}" rel="tag">{$tags[i].tag_name}</a></li>
{/section}
<li><i><a href="{$site_path}/tags.php">all tags</a></i></li>
</ul>
{include file="addtag.tpl" page_id=$page_id}
</div>{* id="right-column" *}

<div id="main-copy" class="page">
<h1>{$page_title}</h1>

{* handle file attachments *}
{if $num_images eq 1 && $num_attachments eq 1}
    <div class="bigimage">
    {section name=i loop=$associated_files}
    {if $associated_files[i].file_mime_type eq "image"}
    <a href="javascript:popup('{$site_path}/file.php?id={$associated_files[i].file_id}&amp;template=imagepopup','image','height={$associated_files[i].image_y},width={$associated_files[i].image_x}');"  title="Click to view full-sized" ><img src="{thumbnail file=`$associated_files[i].file_path` type=`$associated_files[i].file_type` maxw=300}" alt="{$file_name}" height="{$im_h}" width="{$im_w}" /></a><br />
    {$associated_files[i].file_caption}
    (<a href="{$associated_files[i].url}">more info</a>)
    {/if}
    {/section}
    </div>
{elseif $num_attachments gt 0}
    <div class="attachments">
    {section name=i loop=$associated_files}
    <div class="file">
    <div class="icon">
    {if $associated_files[i].file_mime_type eq "image"}
    <a href="{$associated_files[i].url}"><img src="{thumbnail file=$associated_files[i].file_path type=$associated_files[i].file_type size=72}" alt="{$associated_files[i].file_name}" height="{$im_h}" width="{$im_w}" /></a>
    {elseif $associated_files[i].file_mime_type eq "audio"}
    <a href="{$associated_files[i].url}"><img src="{$site_path}/images/audio.jpg" alt="audio file" /></a>
    {else}
    <a href="{$associated_files[i].url}"><img src="{$site_path}/images/icon_file.jpg" alt="file attachment" /></a>
    {/if}
    </div>{* class="icon" *}
    {$associated_files[i].file_caption|default:$associated_files[i].file_original_name}
    </div>{* class="file" *}
    {/section}
    <br style="clear:left;"/>
    </div>{* class="attachments" *}
{/if}

{$page_text}

<div id="comments">
{section name=i loop=$comments}
<div style="padding-left:{$comments[i].clevel*12}px;">
<div class="comment_buttons">
{if $comments[i]._editor}
<a href="{$comments[i].edit_url}">Edit</a> &bull;
<a href="{$comments[i].delete_url}&amp;r={$url|escape:"url"}">Delete</a> &bull;
{/if}
{if $cuser.user_id}
<a href="{$site_path}/edit.php?c=Comment&comment_page_id={$page_id}&amp;comment_reply_to={$comments[i].id}&amp;comment_subject=Re:%20{$comments[i].comment_subject|escape:"url"}">Reply</a>
{/if}
</div>{* class="comment_buttons" *}
<h4>{$comments[i].comment_subject|default:"NO SUBJET"}</h4>
<p class="info"><a href="{$comments[i].user.url}">{$comments[i].user.user_name}</a>
&bull; {$comments[i].comment_created|ydate:"at $time_format on $date_format"}</p>
{$comments[i].comment_text}
</div>{* anonymous *}
{/section}
</div>{* id="comments" *}
</div>{* id="main-copy" *}

{include file="footer.tpl"}