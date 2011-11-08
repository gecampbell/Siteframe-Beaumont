{* $Id: rte_head_tinymce.tpl,v 1.2 2006/01/15 06:26:23 glen Exp $
** Template to include the TinyMCE rich-text-editor
*}
<!-- tinyMCE -->
<script type="text/javascript" src="{$site_path}/tinymce/jscripts/tiny_mce/tiny_mce.js"></script>
<script type="text/javascript">
    tinyMCE.init({ldelim}
      mode : "exact",
      theme : "simple",
      elements : "{section name=item loop=$form_elements}
    {if $form_elements[item].type eq "textarea" && $form_elements[item].formatted}{$form_elements[item].name},{/if}{/section}"
   {rdelim});
</script>
<!-- /tinyMCE -->
