<?php
// $Id: search.php,v 1.9 2006/05/03 01:31:48 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.

require_once 'siteframe.inc';

// write a line to the screen
function writeln($msg,$p1='',$p2='',$p3='',$p4='',$p5='')
{
    echo sprintf($msg,$p1,$p2,$p3,$p4,$p5)."<br />\n";
}

$DB = Database::getReader();

if ($_GET['rebuild'])       // rebuild search text table
{
    if (is_object($_SESSION['user']) && $_SESSION['user']->get('user_admin'))
        ; // ok
    else {
        writeln("Only administrators can rebuild the search index");
        exit;
    }
    $stext = new SearchText;
    writeln("Rebuilding full-text search index");
    writeln("DO NOT INTERRUPT - this script might take some time to complete");
    set_time_limit(0);      // don't stop
    writeln("Deleting old data");
    $DBW = Database::getWriter();
    $DBW->query(sprintf("TRUNCATE %s", $stext->table_name()));
    foreach($ALL_CLASSES as $class)
    {
        $obj = new $class;
        if (count($obj->fulltext))
        {
            writeln("Processing class %s", $class);
            $q = sprintf("SELECT %s FROM %s", $obj->key, $obj->table_name());
            $result = $DB->query($q);
            check_db($DB);
            while(list($id) = $result->fetch_row())
            {
                writeln("ID = %d", $id);
                if ($class == 'Page')
                    $item = PageFactory::getPage($id);
                else
                    $item = new $class($id);
                $item->add_fulltext_data();
            }
            writeln("Finished class %s", $class);
        }
    }
    writeln("Done");
    exit;
}

$__QUERY = <<<END__QUERY
SELECT
    MATCH(obj_text) AGAINST ('%s' IN BOOLEAN MODE) AS score,
    obj_class,
    obj_id
FROM %s
WHERE MATCH(obj_text) AGAINST('%s' IN BOOLEAN MODE)
ORDER BY score DESC
END__QUERY;

if (isset($_GET['q']))
{
    $PAGE->assign('page_title', lang('page_title_search_results'));

    $pattern = $_GET['q'];
    $PAGE->assign('search_string', htmlentities($_GET['q']));

    // build query
    $stext = new SearchText;
    $q = sprintf(
            $__QUERY, 
            addslashes($_GET['q']),
            $stext->table_name(),
            addslashes($_GET['q'])
    );
    
    $PAGE->assign('sql_query', $q);
    
    // execute query
    $result = $DB->query($q);
    check_db($DB);
    
    // get count
    $PAGE->assign('num_results', $result->num_rows);
    
    // retrieve rows
    $out = array();     // output records
    while(list($score,$class,$key) = $result->fetch_row())
    {
        $obj = new $class($key);
        $obj->set('search_score', $score);
        $out[] = $obj->get_all();
        $rss[] = array(
            'title' => $obj->get_title(),
            'description' => '',
            'date' => $obj->get($obj->created),
            'link' => $obj->get_url(),
        );
    }

    // assign output section
    $PAGE->assign('search_results', $out);
    $PAGE->assign('rss_items', $rss);
    $PAGE->assign('rss_title', 'Search Results');
    $PAGE->assign('rss_description', htmlentities($_GET['q']));
    if ($_GET['rss'])
        $PAGE->assign('rss_url', 
            config('site_url_base').htmlentities($_SERVER['REQUEST_URI']));
    else
        $PAGE->assign('rss_url', sprintf('%s%s&amp;rss=1', 
                                    config('site_url_base'),
                                    htmlentities($_SERVER['REQUEST_URI'])));
}
else
    $PAGE->assign('page_title', lang('page_title_search'));
    
// build the search form
$inf = new InputForm(
    'search',
    $_SERVER['SCRIPT_NAME'],
    'get',
    lang('prompt_search')
);
$inf->add_item('q', array(
    'type' => 'text',
    'size' => '40',
    'value' => $_GET['q']
));
$PAGE->assign('search_form', $inf->get_form());

if ($_GET['rss'])
{
    $PAGE->load_new('');
    header("Content-Type: text/xml");
    echo $PAGE->fetch(site_template('rssgeneric'));
}
else
    $PAGE->display();
?>
