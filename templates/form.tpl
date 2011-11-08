{* $Id: form.tpl,v 1.4 2005/12/06 18:58:18 glen Exp $
** Copyright (c)2004, Glen Campbell. All rights reserved.
** This template displays an input form
*}
<form id="{$form_name}" action="{$form_action}" method="{$form_method|default:"post"}" class="defaultform" {if $form_enctype}enctype="{$form_enctype|default:"multipart/form-data"}"{/if}>
{section name=item loop=$form_elements}

{if $form_elements[item].advanced && !$_adv}
    {assign var=_adv value=true}
    <p class="adv">
    &raquo;&nbsp;<a href="#adv" name="adv" onClick="toggle('form_advanced');">Click to display additional settings</a></p>
    <div id="form_advanced" style="display:none;">
{/if}

    {if $form_elements[item].hidden}
        <input type="hidden" name="{$form_elements[item].name}" value="{$form_elements[item].value}" />
    {else}{* these require prompts and wrappers *}
        <label>{$form_elements[item].prompt}{if $form_elements[item].required}<span style="color:red;">*</span>{/if}</label>
        <div class="item">
        {if ($form_elements[item].type eq "text")||($form_elements[item].type eq "number")}
            <input type="text" name="{$form_elements[item].name}"
            {if $form_elements[item].type eq "number" || $form_elements[item].value ne ""}value="{$form_elements[item].value|escape}"{/if}
            {if $form_elements[item].size ne ""}size="{$form_elements[item].size}"{/if}
            {if $form_elements[item].maxlength ne ""}maxlength="{$form_elements[item].maxlength}"{/if}
            {if $form_elements[item].disabled ne ""}disabled="disabled"{/if}
            />
            
        {elseif $form_elements[item].type eq "password"}
            <input type="password" name="{$form_elements[item].name}"
            {if $form_elements[item].size ne ""}size="{$form_elements[item].size}"{/if}
            {if $form_elements[item].maxlength ne ""}maxlength="{$form_elements[item].maxlength}"{/if}
            {if $form_elements[item].disabled ne ""}disabled="disabled"{/if}
            />
            
        {elseif $form_elements[item].type eq "textarea"}
            <textarea name="{$form_elements[item].name}"
            {if $form_elements[item].rows ne 0}rows="{$form_elements[item].rows}"{/if}
            {if $form_elements[item].cols ne 0}cols="{$form_elements[item].cols}"{/if}
            {if $form_elements[item].disabled ne ""}disabled="disabled"{/if}
            {if $form_elements[item].formatted}class="widgEditor"{/if}
            >{$form_elements[item].value|escape:"html"}</textarea>
            
        {elseif $form_elements[item].type eq "checkbox"}
            <input type="checkbox" name="{$form_elements[item].name}" value="{$form_elements[item].rval}"
            {if $form_elements[item].value}checked="checked"{/if}/>
            
        {elseif ($form_elements[item].type eq "select")||($form_elements[item].type eq "category")}
            <select
                {if $form_elements[item].multiple}name="{$form_elements[item].name}[]" multiple
                {else}name="{$form_elements[item].name}"
                {/if}
                {if $form_elements[item].onchange}onChange="{$form_elements[item].onchange}"{/if}
                {if $form_elements[item].size}size="{$form_elements[item].size}"{/if}>
            {*if !$form_elements[item].multiple}
                <option label="[none]" value=""> &nbsp; -none- &nbsp; </option>
            {/if*}
            {html_options options=$form_elements[item].options
                          selected=$form_elements[item].value}
            </select>
            
        {elseif $form_elements[item].type eq "date"}
            {html_select_date
                prefix=$form_elements[item].name
                start_year=-50
                end_year=+20
                month_empty="Month"
                day_empty="Day"
                year_empty="Year"
                time=$form_elements[item].value
                }
                
        {elseif $form_elements[item].type eq "datetime"}
            {if $form_elements[item].checkbox ne ""}
            <input type="checkbox" name="{$form_elements[item].checkbox}" value="1"
                {if $form_elements[item].checkbox_value}checked="checked"{/if}/>
            {/if}
            {html_select_date
                prefix=$form_elements[item].name
                start_year=-50
                end_year=+20
                month_empty="Month"
                day_empty="Day"
                year_empty="Year"
                time=$form_elements[item].value
                }
            {html_select_time
                prefix=$form_elements[item].name
                time=$form_elements[item].value
                use_24_hours=true
                }

        {elseif $form_elements[item].type eq "file"}
            <input type="file" name="{$form_elements[item].name}{if $form_elements[item].multiple}[]{/if}"/>
            {if $form_elements[item].caption}
            <label>Caption:</label>
            <input type="text" name="{$form_elements[item].name}_caption{if $form_elements[item].multiple}[]{/if}" size="20"/>
            {/if}
        
        {else}
            Unsupported data type {$form_elements[item].type}
        {/if}
        {if $form_elements[item].help ne ""}
        <p class="help">{$form_elements[item].help}</p>
        {/if}
    </div>{* class="item" *}
    
    {/if}
    
{/section}
{if $_adv}
</div>
{/if}

{* handle file attachments/detachments *}
{if is_array($obj) && is_array($obj.associated_files)}
<label>{lang name="prompt_file_attachments"}</label>
{section name=i loop=$obj.associated_files}
<div class="item"><input type="checkbox" name="del_file[]" value="{$obj.associated_files[i].file_id}" />
{$obj.associated_files[i].file_path|basename}</div>
{/section}
<p class="help">{lang name="help_file_attachments"}</p>
{/if}

<input type="submit" value="{$form_submit}" onClick="form.submit(); swap('{$form_name}','wait');"/>
<input type="reset" value="{$form_reset}" />
</form>

<div id="wait" style="display:none;">
{if $script ne "setup.php"}
    {random class="Quote"}
    <p class="quotation">{$quote.quote_text}
    <br />
    <small>(submitted by {$quote.user.user_name})</small>
    </p>
    {/random}
{/if}
<p>One moment, please....</p>
</div>
