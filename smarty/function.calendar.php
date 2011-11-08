<?php
// $Id: function.calendar.php,v 1.2 2006/05/03 01:31:48 glen Exp $
// Copyright (c)2004, Glen Campbell. All rights reserved.
//
// parameters
//      year=       (required)
//      month=      (required)
//      folder=     (optional; otherwise site-wide)

// smarty_function_calendar - retrieve a language string for the templates
function smarty_function_calendar($parms)
{
    $DB = Database::getReader();
    
    // fetch/set year
    if (isset($parms['year']))
        $year = $parms['year'];
    else
        $year = strftime('%Y');
    
    // fetch/set month
    if (isset($parms['month']))
        $month = $parms['month'];
    else
        $month = strftime('%m');
    
    $start = strtotime($datestring = sprintf("%04d-%02d-01 00:00:00", $year, $month));
    $dow = date('w', $start);   // 0=sunday, 6=saturday
    $ndays = date('t', $start);
    
    // get optional folder
    $folder = $parms['folder'];
    if ($folder) 
        $extra_WHERE = sprintf(" AND page_folder_id=%d ", $folder);
    else
        $extra_WHERE = "";
    
    // get optional user
    $userid = $parms['user'];
    if ($userid)
        $extra_WHERE .= sprintf(" AND page_user_id=%d ", $userid);

    // get counts of pages
    $p = new Page;
    $q = sprintf(
        "SELECT DATE_FORMAT(page_created,'%%Y-%%c-%%d'),COUNT(*) ".
        "FROM %s ".
        "WHERE page_created BETWEEN '%s' AND DATE_ADD('%s',INTERVAL 1 MONTH) ".
        $extra_WHERE .
        "GROUP BY 1",
        $p->table_name(),
        $datestring,
        $datestring);
    $result = $DB->query($q);
    check_db($DB);
    while(list($date,$count) = $result->fetch_row())
    {
        $day = date('d', strtotime($date));
        $pages[$day+0] = $count;
    }
    
    // start constructing the table
    $out  = "<div class=\"calendar\">\n";
    $out .= date('F, Y', $start)."\n";
    $out .= "<table class=\"calendar\"><tr><th>";
    $out .= implode("</th><th>", explode(":", lang("calendar_days")));
    $out .= "</th></tr>\n";
    $out .= "<tr>";
    for($i=0; $i<$dow; $i++)
        $out .= "<td>&nbsp;</td>";
    
    $wday = $dow;
    for($i=1; $i<=$ndays; $i++)
    {
        if ($wday == 0)
            $out .= "<tr>";
        $wday++;
        if ($pages[$i])
            $out .= sprintf(
                '<td><a href="%s/archive.php?y=%d&amp;m=%d&amp;d=%d">%d</a></td>',
                config('site_path'),
                $year,
                $month,
                $i,
                $i);
        else
            $out .= "<td>".$i."</td>";
        if ($wday == 7)
        {
            $out .= "</tr>\n";
            $wday = 0;
        }
    }
    for($i=$wday; $i<7; $i++)
        $out .= "<td>&nbsp;</td>";
    $out .= "</tr>\n</table>\n</div>";
    return $out;
}
?>