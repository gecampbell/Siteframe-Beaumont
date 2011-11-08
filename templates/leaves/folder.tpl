{include file="header.tpl" title=$title subtitle=$folder_text}
{menu name="action" link="$site_path/edit.php?c=Subscription&amp;sub_folder_id=$folder_id" text="Subscribe"}

<div id="sidebar">
{if $use_subfolders}
    <h3>Subfolders</h3>
    <ul>
    {all class="Folder" parent=$folder_id}
    <li><a href="{$folder.url}">{$folder.title}</a></li>
    {/all}
    </ul>
{/if}
<p>Owner: <a href="{$user.url}">{$user.title}</a>
</p>
<p><a href="{$rss_url}" title="RSS 2.0"><img src="{$site_path}/images/feed-icon16x16.png" alt="" /></a></p>
</div>{* id="sidebar" *}

<div id="content">
{include file="paginator.tpl" curpage=$page numpages=$num_pages url="$url"}
{section name=current loop=$items}
{include file="excerpt.tpl" page=$items[current]}
{sectionelse}
<p>This folder has no pages.</p>
{/section}
</div>{* id="content" *}

{include file="footer.tpl"}