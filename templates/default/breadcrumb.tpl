{* breadcrumb trail *}
{if $use_subfolders}
{if $page_id}
  {assign var=folder_id value=$page_folder_id}
{/if}
<div class="breadcrumb">
<a href="{$site_path}/">{$site_name}</a>
{folder_path folder=$folder_id}
/&nbsp;<a href="{$folder.url}">{$folder.folder_title}</a>
{/folder_path}
{if $breadcrumb_final ne ""}/&nbsp;{$breadcrumb_final}{/if}
</div>
{/if}