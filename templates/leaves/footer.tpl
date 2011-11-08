{* $Id: footer.tpl,v 1.7 2005/12/23 17:12:12 glen Exp $
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
<p class="action">{menu name="action" sep=" &bull; "}</p>
	<div id="footer">
	<p>{$site_copyright} 
	| Powered by <a href="http://siteframe.org">Siteframe</a>&trade; {$VERSION}
	| Design by <a href="http://smallpark.org">SmallPark</a>
    {if $content_link_about ne ""}
        | <a href="{textlink name=$content_link_about}">About</a>
    {/if}
    {if $content_link_tos ne ""}
        | <a href="{textlink name=$content_link_tos}">Terms of Service</a>
    {/if}
    {if $content_link_privacy ne ""}
        | <a href="{textlink name=$content_link_privacy}">Privacy Policy</a>
    {/if}
    {if $content_link_contact ne ""}
        | <a href="{textlink name=$content_link_contact}">Contact Us</a>
    {/if}
    {if $content_link_help ne ""}
        | <a href="{textlink name=$content_link_help}">Help</a>
    {/if}
    {if $content_link_abuse ne ""}
        | <a href="{textlink name=$content_link_abuse}">Abuse</a>
    {/if}
	</p>
  </div>{* id="footer" *}
</div>{* id="container" *}
</body>
</html>
