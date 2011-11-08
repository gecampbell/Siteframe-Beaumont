<div class="top_menu">
<span style="float:right;">
    <a href="{$site_path}/login.php">{if $cuser.user_id}{lang name="prompt_logout"
}{else}{lang name="prompt_login"}{/if}</a> |
    {if !$cuser.user_id}
        <a href="{$site_path}/register.php">Register</a> |
    {/if}
    <a href="{$site_path}/">Home</a>
</span>
{if $cuser.user_name ne ""}
    Welcome, <a href="{$cuser.url}">{$cuser.user_name}</a>!
{else}
    Greetings!
{/if}
</div>
