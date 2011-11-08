{if $allow_comments && $num_comments}
<div class="comments">

{section name=i loop=$comments}
<div class="comment">
<div class="comment_subject" style="padding-left:{$comments[i].clevel*12}px;">
    {if $comments[i].user.user_photo ne ""}
    <a href="{$comments[i].user.url}"><img src="{thumbnail file=$comments[i].user.user_photo type=$comments[i].user.user_photo_type size=48}" alt="" style="float:left;" class="cimage" /></a>
    {/if}
    <div class="comment_buttons">
    {if $comments[i]._editor}
    <a href="{$comments[i].edit_url}">Edit</a> /
    <a href="{$comments[i].delete_url}">Delete</a> /
    {/if}
    {if $cuser.user_id}
    <a href="#comment" onClick="javascript:reply_to({$comments[i].comment_id},'Re: {$comments[i].comment_subject|strip|escape:"javascript"}','cform','cprompt')">Reply</a>
    {/if}
    </div>
{$comments[i].comment_subject|default:"&lt;Couldn't be bothered to add a subject&gt;"}</div>

<div class="comment_text" style="padding-left:{$comments[i].clevel*12}px;">

<div class="comment_info">by 
<a href="{$comments[i].user.url}">{$comments[i].user.user_name}</a>
/ {$comments[i].comment_created|ydate:"at $time_format on $date_format"}
</div>

{$comments[i].comment_text}
{if !$comments[i].comment_user_id}
   [<a href="{$comment[i].tb_url}">read entire article</a>]
{/if}
</div>

</div>{* class="comment" *}
{/section}

</div>{* class="comments" *}

{/if}

{if $cuser.user_id && $allow_comments}
    {menu name="action"
          link="javascript:show('cform');focus('commentform');"
          text="New Comment"}
    {assign var="subj" value="Feedback on \"`$page_title`\""}
    {assign var="subjq" value="`$subj`"|escape:"url"}
    {menu name="action"  link="$site_path/edit.php?c=Memo&amp;memo_to_user_id=$page_user_id&memo_subject=$subjq"
    text="Send Feedback"}
    <a name="comment"></a>
    <div id="cform">
    <h2>New Comment</h2>
    {$comment_form}
    </div>
    {literal}
    <script language="javascript">hide('cform');</script>
    {/literal}
{/if}
