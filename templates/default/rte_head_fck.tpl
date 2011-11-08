{* $Id: rte_head_fck.tpl,v 1.2 2005/11/10 22:10:20 glen Exp $
** Template to include the FCK rich-text-editor
*}
<script type="text/javascript" src="{$site_path}/fckeditor/fckeditor.js"></script>
<script type="text/javascript">
window.onload = function()
{ldelim}
{section name=item loop=$form_elements}
    {if $form_elements[item].type eq "textarea" && $form_elements[item].formatted}
    var {$form_elements[item].name}_ed = new FCKeditor( '{$form_elements[item].name}' ) ;
    {$form_elements[item].name}_ed.ReplaceTextarea() ;
    {/if}
{/section}
{rdelim}
</script>
