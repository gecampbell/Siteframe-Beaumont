{* recent_images: optional parameter num=xx *}
{if !$num}{assign var="num" value="100"}{/if}

<div class="recent_images">
{recent class="File" image=1 num=$num}
<div class="tinyimage">
  <a href="{$file.url}"><img src="{thumbnail file=$file.file_path type=$file.file_type size=50 center=true}" alt="{$file_name}" /></a>
</div>
{/recent}
</div>
