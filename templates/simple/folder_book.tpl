{* $Id: folder_book.tpl,v 1.3 2005/02/27 19:42:05 glen Exp $
** displays folder contents as a book table of contents
*}
{assign var=page value=$items[item]}
{if $smarty.section.item.first}<p>{/if}
<a href="{$page.url}">{$page.page_title}</a><br/>
{if $smarty.section.item.last}</p>{/if}