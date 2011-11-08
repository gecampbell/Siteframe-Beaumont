{* subfolders for $folder_id *}
{if $folder_allow_subfolders && $use_subfolders}
<div class="heading">Subfolders</div>
<p>
{all class="Folder" parent=$folder_id}
<a href="{$folder.url}">{$folder.folder_title}</a><br/>
{/all}
</p>
{/if}