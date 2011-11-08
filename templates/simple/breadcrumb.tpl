{* breadcrumb trail *}
{if $use_subfolders}
<div class="breadcrumb">
<a href="{$site_path}/">{$site_name}</a>
{folder_path folder=$folder_id}
&raquo;&nbsp;<a href="{$folder.url}">{$folder.folder_title}</a>
{/folder_path}
{if $breadcrumb_final ne ""}&raquo;&nbsp;{$breadcrumb_final}{/if}
</div>
{/if}