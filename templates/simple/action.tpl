{* $Id: action.tpl,v 1.8 2005/04/24 20:05:26 glen Exp $
** Copyright (c)2005, Glen Campbell. All rights reserved.
**
** This creates an "action menu" for the current page
*}
{if $cuser.user_id}
    {if $folder_id}
    {menu name="action"
          link="$site_path/edit.php?c=Page&amp;page_folder_id=$folder_id"
          text="New Page"}
    {/if}
    {if $_editor }
    {menu name="action"
          link="$edit_url"
          text="Edit"}
    {if $delete_url ne ""}
        {menu name="action"
              link="$delete_url"
              text="Delete"}
    {/if}
    {/if}
    {if $cuser.user_admin}
    {menu name="action"
          link="$site_path/admin.php"
          text="Admin"}
    {/if}
    <p class="menu">{menu name="action" sep=" | "}</p>
{/if}