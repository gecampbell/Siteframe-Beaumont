{* $Id: favorite.tpl,v 1.2 2006/01/03 00:44:10 glen Exp $
** Copyright (c)2005, Glen Campbell. All rights reserved.
**
** This module allows users to specify another user as a favorite.
*}
{if $cuser.id && ($cuser.id ne $user.id)}
<script type="text/javascript">
var xml=newxmlobj();
var myrate=0;
{if $url_rewriting}
    {assign var=furl value="$site_path/api/V1/Favorite?key=`$cuser.user_hash`"}
{else}
    {assign var=furl value="$site_path/api.php?v=1&r=Favorite&key=`$cuser.user_hash`"}
{/if}
{if $fav_id}
    {menu name="action" text="Remove from Favorites" link="javascript:rmfav();"}
    function rmfav() {ldelim}
        xml.onreadystatechange=redisplay;
        xml.open('DELETE', '{$furl}&id={$fav_id}');
        xml.send(null);
    {rdelim}
{else}
    {menu name="action" text="Add to Favorites" link="javascript:addfav();"}
    function addfav() {ldelim}
        xml.onreadystatechange=redisplay;
        xml.open('POST', '{$furl}');
        xml.setRequestHeader('Content-Type', 
            'application/x-www-form-urlencoded; multipart/form-data; charset=utf-8');
        xml.send('user_id={$cuser.id}&fav_user_id={$user.id}');
    {rdelim}
{/if}
function redisplay() {ldelim}
    if (xml.readyState == 4) {ldelim}
        if (xml.status != 200) {ldelim}
            var response = xml.responseXML.documentElement;
            alert(response.getElementsByTagName('Message')[0].firstChild.data);
        {rdelim}
        document.location='{$user.url}';
    {rdelim}
{rdelim}
</script>
{/if}