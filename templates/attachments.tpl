{* $Id: attachments.tpl,v 1.3 2005/12/03 17:05:20 glen Exp $
** This template displays a table of all file attachments
** for a given $page.
*}
{if ($num_attachments-$num_images)}
<h3 style="margin-bottom:0;padding-bottom:0;clear:both;">File Attachments</h3>
<table class="list">
    <tr>
        <th>Download </th>
        <th>Info </th>
        <th style="text-align:right;">Size (bytes)</th>
        <th style="text-align:right;">Downloaded </th>
        <th>Created </th>
    </tr>
    {section name=i loop=$associated_files}
    {if !($associated_files[i].is_image)}
    <tr class="{cycle values="odd,even"}">
        <td><a href="{$site_path}/{$associated_files[i].file_path}" onClick="javascript:document.location='{$site_path}/download.php?id={$associated_files[i].id}';return false;">{$associated_files[i].title}</a></td>
        <td><a href="{$associated_files[i].url}">More Info</a></td>
        <td style="text-align:right;">{$associated_files[i].file_size|number_format} </td>
        <td style="text-align:right;">{$associated_files[i].num_downloads|number_format} </td>
        <td>{$associated_files[i].file_created|userdate:"$date_format $time_format"} </td>
    </tr>
    {/if}
    {/section}
</table>
{/if}
