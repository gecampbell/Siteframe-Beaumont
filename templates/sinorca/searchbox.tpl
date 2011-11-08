{* $Id: searchbox.tpl,v 1.2 2006/02/16 05:49:22 glen Exp $
 * Search Box for right column
 *}
<div id="searchbox">
    <form action="{$site_path}/search.php" method="get">
        <input name="q" class="text" type="text" value="Search..." onClick="this.value='';this.style.color='black';"/>
        <input type="submit" value="Go" class="button" />
    </form>
</div>
