{* $Id: footer.tpl,v 1.3 2006/01/15 02:12:48 glen Exp $
** Page footer *}

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
{/if}

<p class="action">{menu name="action" sep=" &rsaquo; "}</p>
	<div id="footer">
	{$site_copyright} 
	&rsaquo; Powered by <a href="http://siteframe.org">Siteframe</a>&trade; {$VERSION}
    </div>{* id="footer" *}
</div>{* id="container" *}
</body>
</html>
