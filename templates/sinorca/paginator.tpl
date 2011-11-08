{* $Id: paginator.tpl,v 1.1 2006/01/12 04:33:16 glen Exp $
** Copyright (c)2005, Glen Campbell. All rights reserved.
** This file generates a "paginator" (page navigator) based on
** these input parameters:
**      url         = the URL of the current page
**      sep         = either "?" or "&amp;"
**      curpage     = the current page number
**      numpages    = the total number of pages
*}
{if $numpages gt 1}
{if !$sep}{assign var=sep value="?"}{/if}
<div class="paginator">
<span style="float:right;">Page {$curpage} of {$numpages}</span>
{if $curpage gt 1}<a href="{$url}{$sep}page={$curpage-1}">Prev</a> {else}Prev {/if}
{if $curpage gt 4}<a href="{$url}">1</a> {if $curpage gt 5}...{/if} {/if}
{if $curpage gt 3}<a href="{$url}{$sep}page={$curpage-3}">{$curpage-3}</a> {/if}
{if $curpage gt 2}<a href="{$url}{$sep}page={$curpage-2}">{$curpage-2}</a> {/if}
{if $curpage gt 1}<a href="{$url}{$sep}page={$curpage-1}">{$curpage-1}</a> {/if}
[{$curpage}]
{if $numpages ge $curpage+1}<a href="{$url}{$sep}page={$curpage+1}">{$curpage+1}</a> {/if}
{if $numpages ge $curpage+2}<a href="{$url}{$sep}page={$curpage+2}">{$curpage+2}</a> {/if}
{if $numpages ge $curpage+3}<a href="{$url}{$sep}page={$curpage+3}">{$curpage+3}</a> {/if}
{if $numpages ge $curpage+4} {if $numpages ge $curpage+5}...{/if} <a href="{$url}{$sep}page={$numpages}">{$numpages}</a> {/if}
{if $curpage lt $numpages}<a href="{$url}{$sep}page={$curpage+1}">Next</a> {else}Next {/if}
</div>
{/if}{* end if numpages > 1 *}
