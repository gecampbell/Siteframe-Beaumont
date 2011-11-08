{* $Id: footer.tpl,v 1.1 2006/01/12 04:33:16 glen Exp $
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
    <!-- ##### Footer ##### -->

    <div id="footer">
      <div class="left">
      {menu name="action" sep=" &rsaquo; "}
      </div>

      <br class="doNotDisplay doNotPrint" />

      <div class="right">
        {$site_copyright} 
        &rsaquo; Powered by <a href="http://siteframe.org">Siteframe</a>&trade; {$VERSION}
      </div>
    </div>
  </body>
</html>