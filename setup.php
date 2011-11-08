<?php
// $Id: setup.php,v 1.53 2006/05/03 01:31:48 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.
// The setup program validates the configuration (siteframe.ini) and
// constructs database tables.

$_ABOUT = <<<ENDABOUT
<p><b>BEAUMONT, TEXAS.</b> Beaumont, the county seat of Jefferson County, is in the northeast part of the county, at 30&deg;05' north latitude, and 94&deg;06' west longitude, on the west bank of the Neches River and Interstate Highway 10, eighty-five miles east of Houston and twenty-five air miles north of the Gulf of Mexico. With nearby Port Arthur and Orange, it forms the Golden Triangle, a major industrial area on the Gulf Coast. Beaumont developed around the farm of Noah and Nancy Tevis, who settled on the Neches in 1824. The small community that grew up around the farm was known as Tevis Bluff or Neches River Settlement. Together with the nearby community of Santa Anna, it became the townsite for Beaumont when, in 1835, Henry Millard and partners Joseph Pulsifer and Thomas B. Hulingq began planning a town on land purchased from the Tevises. The most credible account of how the town was named is that Millard gave it his wife's maiden name, Beaumont. At Millard's urging, the First Congress of the Republic of Texas made Beaumont the seat of the newly formed Jefferson County and granted it a charter in 1838. Under a second charter municipal government was organized in 1840, but it was soon abandoned. Another attempt at municipal government in 1860 was short-lived. Continuous municipal government dates from incorporation under a general statute in 1881. Beaumont was a small center for cattle raisers and farmers in its early years, and, with an active riverport by the late 1800s, it became an important lumber and rice-milling town. The Beaumont Rice Mill, founded in 1892, was the first commercial rice mill in Texas. Beaumont's lumber boom, which reached its peak in the late 1800s, was due in large part to the rebuilding and expansion of the railroads after the Civil War. By the early 1900s the city was served by the Southern Pacific, Kansas City Southern, Atchison, Topeka, and Santa Fe, and Missouri Pacific railroad systems. The population grew from 3,296 in 1890 to 9,427 in 1900.</p>
<p>The Spindletop oil gusher of 1901 produced a boom that left Beaumont with a doubled population (20,640 in 1910), great wealth, and a petroleum-based economy that expanded as refineries and pipelines were built and new fields discovered nearby. Three major oil companies&mdash;the Texas Company (later Texaco), Gulf Oil Corporation, and Humble (later Exxon)&mdash;were formed in Beaumont during the first year of the boom. The Magnolia Refinery became the city's largest employer; by 1980 it was Mobil's largest manufacturing plant. Beaumont became a major seaport (variously second or third in tonnage in Texas in the 1970s) after the Neches was channelized to Port Arthur in 1908. By 1916 the channel was deepened, a turning basin dredged, and a shipyard constructed. The Gulf States Utilities Company, which serves southeast Texas and southwest Louisiana, made its headquarters in Beaumont. Discovery of a new oilfield at Spindletop in 1925 brought another burst of growth. The population of Beaumont was 40,422 in 1920 and 57,732 in 1930. This era also had its darker side: in the 1920s the Ku Klux Klan gained strength in Beaumont, and from 1922 to 1924 it controlled local politics. By the end of the 1920s, however, it had lost much of its membership and consequently its power. Though stagnant through the Great Depression, Beaumont's economy prospered during World War II with shipbuilding and oil refining. With the new boom came overcrowding, which may have contributed to the Beaumont race riot of 1943, in which interracial violence led to the declaration of martial law and the virtual shut-down of the city in June.</p>
<p>Beaumont's economy grew with petrochemicals and synthetic rubber in the post-war era and reached a plateau about 1960, when the growth slowed. In the mid-1950s the city, which had been segregated since Reconstruction, saw the civil rights movement begin to gain momentum, as the local chapter of the NAACP won two consecutive desegregation suits, one of them at Lamar State College. In the early 1960s an inquiry by the General Investigating Committee of the Texas House of Representatives resulted in three days of public hearings on Beaumont's illegal prostitution and gambling district, a boomtown byproduct; the police department was subsequently reorganized. Beaumont had 94,014 residents in 1950 and 119,175 in 1960; by 1964 it was the sixth-largest city in Texas. By 1970 its population had fallen to 115,919, in part because of the automation of the petrochemical industry that had begun in the early 1960s. Though by 1980 Beaumont's population had risen to 118,102, the city had fallen to the twelfth-largest in the state. The 1980 population was 61.2 percent white and 36.6 percent black and included large Italian and Cajun and small Hispanic and Asian elements. Religious groups include Catholics, various Protestant denominations, and Jews. In the early 1980s major cultural organizations included a symphony orchestra, a civic opera, a ballet, several art museums, and a community playhouse. Medical facilities included one neurological and at least three general hospitals. The main campus of Lamar University is in Beaumont. The city's two independent school districts were united in 1983. In 1985 Beaumont had one newspaper, the Beaumont Enterprise, two television stations, and several local radio stations. Under its present charter (1947) Beaumont has a council-manager government. The Ninth Court of Civil Appeals, the federal district court, and the Lower Neches Valley Authority are located in Beaumont. Jefferson County Airport in Nederland provides the area with commuter and general aviation facilities; Beaumont is also served by its own municipal airport. Annual events in Beaumont include the South Texas State Fair, the Neches River Festival, and the Kaleidoscope Arts and Crafts Festival. The city park system comprises over thirty community and neighborhood parks and the Babe Didrikson Zaharias Museum. Major historical restorations include the John J. French Museum, the Tyrell Historical Library, and the McFaddin-Ward House. Among the city's museums are the Gladys City Boom Town Museum, a full-scale replica of the Spindletop boomtown, and the Texas Energy Museum. Beginning in the early 1980s the Beaumont area, because of its reliance on the depressed heavy-industry and petrochemical markets, became the slowest-growing in the state and consistently had the highest unemployment on the Texas Gulf Coast. In 1990 Beaumont had a population of 114,323, and the early 1990s witnessed a number of important revitalization projects in the downtown area.</p>
ENDABOUT;

$_CREDITS = <<<ENDCREDITS
<p>Siteframe&trade; is a product that could not have happened without the support and assistance of numerous people, and I'm sure that I can't thank them all here. First, to the many members of <a href="http://contaxg.com">the Contax G Pages</a> who provided inspiration and motivation over the years. Next, a special thank-you to Richard Sintchak, who was one of my single most persistent early supporters.</p>
<p>A special note of thanks to Coby Leuschke, who pushed me through alpha and finally got the beta out the door.</p>
<p>Finally, here's a bunch of other people who all provided some sort of support:
Cristiana Dinculescu, 
Ryosuke Nakahara, 
Chris Harpham, 
Nicolas Fischer,
Ricardo Lamego,
Scott Spencer,
Wilfred van der Wegte,
Charez Golvalez,
Anita Campbell,
Elam Campbell,
Dennis Adams,
Ted Campbell,
Mitsuhiro Yoshida,
Steve Danforth,
Portia Shao,
M Anowar,
Bob Michaels,
Chad Drayer,
Robin Kleb,
Jimmy Pierre,
Jerome Belthrop,
Julie Mia,
Knut Skjaerven,
Mark Megerle,
John McMaster,
Peter Vallecillo,
Kenji Tezen,
Aaron Gniewek,
and a whole host of other folks. If I've left your name off, please let me know and I'll make sure you get in the next release. If this product is of a high quality, it
is because of the participation of these people and others like them. 
Any errors or bugs that remain are entirely my own fault.</p>
<p><i>Glen Campbell</i></p>
<p style="line-height:120%;"><small>
Broadpool&trade;, Siteframe&trade;, Blogframe&trade;, and Sn00t&trade; are trademarks or service marks of Glen Campbell, and may not be used without permission. Siteframe&trade; is released under a <a href="http://creativecommons.org/licenses/by-sa/2.0/">Creative Commons license</a>; follow the link for complete details.</small></p>
ENDCREDITS;

$_HELP = <<<ENDHELP
<p>The site administrator should edit this page appropriately.</p>
ENDHELP;

// check for database error()
function check_db_error($conn='')
{
    global $DB;
    if (!$conn)
    	$conn = $DB;
    if ($conn->errno)
    {
        $out = sprintf("<p style=\"color:red;\">%s</p>\n", $conn->error);
    }
    else
    {
        $out = "<p style=\"color:green;\">Completed OK</p>\n";
    }
    return $out;
}

// ------- EXECUTION STARTS HERE --------

// check the PHP version
if (phpversion() < 5.0)
    die("FATAL ERROR: ".
        "This version of Siteframe requires PHP version 5.0 or higher; ".
        "you are currently running version ".phpversion());

// check for mysqli extension
if (!function_exists('mysqli_init'))
    die("FATAL ERROR: ".
        "This version of Siteframe requires the mysqli extension to ".
        "access the MySQL database; this does not appear to be ".
        "installed.");

require_once 'siteframe.inc';
require config('dir_includes')."/dbfunc.inc";

logout();

// $SQL holds a copy of the SQL used to create the database
$SQL = sprintf("/*\n** Siteframe %s\n** Generated: %s\n** Site: %s\n** URL: %s\n*/\n\n",
        SITEFRAME_VERSION,
        strftime(config('date_format').' '.config('time_format').' %Z'),
        config('site_name'),
        config('site_url'));

$PAGE->assign('page_title', 'Setup');

// if the "user" table exists, we have already installed
$u = new User;
$DB = Database::getReader();
@$DB->query(sprintf('SELECT COUNT(*) FROM %s', $u->table_name()));
if ($DB->errno == 1146)
{
    // everything's ok - the table doesn't exist
}
else if ($DB->errno)
{
    abort('Unexpected error %d: %s', $DB->errno, $DB->error);
}
else
{
    abort('Siteframe (beaumont) appears to be already installed');
}

// get a database WRITE connection
$DBWRITE = Database::getWriter();

// if submitted, process the submit
if ($_POST['_submitted'])
{
    $PAGE->assign('setup_pass', 2);

    // validate admin user
    $admin = new User;
    $admin->set('user_name',        $_POST['admin_name']);
    $admin->set('user_firstname',   'Site');
    $admin->set('user_lastname',    'Administrator');
    $admin->set('user_email',       $_POST['admin_email']);
    $admin->set('user_password',    $_POST['admin_passwd_1']);
    if ($_POST['admin_passwd_1'] != $_POST['admin_passwd_2'])
        $admin->add_error('Passphrases do not match');
    $PAGE->assign('error', $admin->get_errors());
    if ($admin->is_valid())
    {
        $PAGE->assign('page_title', 'Setup - creating tables');
        // save output in $out
        $out = '';
        $errc = 0;

        foreach($ALL_CLASSES as $class)
        {
            $obj = new $class;
            $create = create_table($obj);
            $out .= "<pre>\n".$create."\n</pre>\n";

            $DBWRITE->query($create);
            $out .= check_db_error();

            // create indices
            foreach ($obj->create_indexes() as $statement)
            {
                $SQL .= $statement . ";\n\n";
                $out .= "<pre>\n".$statement."\n</pre>\n";
                $DBWRITE->query($statement);
                $out .= check_db_error();
            }
        }

        // if everything's ok so far, create the admin user
        if ($admin->is_valid() && !$errc)
        {
            $admin->set('user_status', USER_STATUS_NORMAL);
            $admin->set('user_admin', 1);
            $CONFIG['confirm_email'] = 0;
            $admin->add();
            if ($admin->is_valid())
            {
                $out .= "<p style=\"color:green;\">Administrator user created</p>\n";
            }
            else
                $out .= "<p style=\"color:red;\">".$admin->get_errors()."</p>\n";
        }
        
        // save a copy of the SQL
        file_put_contents(config('dir_files').'/setup.sql', $SQL);
        $out .= sprintf("<p>A copy of the SQL used to create the database has been saved in %s/setup.sql</p>\n", config('dir_files'));
        
        // registration email
$REGISTER_EMAIL = <<<ENDREGISTEREMAIL
Siteframe Version = %s
Site Name = %s
Site URL = %s
Site Email = %s
Administrator Name = %s
Administrator Email = %s
Date = %s
ENDREGISTEREMAIL;

        if ($_POST['register_site'])
        {
            $em = new Email('Siteframe Product Registration');
            $em->to('register@siteframe.org');
            $em->to($admin->get('user_email'));
            $msg = sprintf($REGISTER_EMAIL,
                    SITEFRAME_VERSION,
                    config('site_name'),
                    config('site_url'),
                    config('site_email'),
                    $admin->get('user_name'),
                    $admin->get('user_email'),
                    strftime('%Y-%m-%d %H:%I %Z', time())
            );
            $em->send($msg);
            $out .= "<p>Registration e-mail was sent</p>";
        }
        
        // add some static text blocks
        $tex = new Text();
        $tex->set('text_name', 'about');
        $tex->set('text_title', 'About Beaumont');
        $tex->set('text_body', $_ABOUT);
        $tex->add();
        $tex = new Text();
        $tex->set('text_name', 'credits');
        $tex->set('text_title', 'Credits');
        $tex->set('text_body', $_CREDITS);
        $tex->add();
        $tex = new Text();
        $tex->set('text_name', 'help');
        $tex->set('text_title', 'Help');
        $tex->set('text_body', $_HELP);
        $tex->add();
        
        // assign some persistent properties
        set_property('version', SITEFRAME_VERSION);
        set_property('date_installed', strftime('%Y-%m-%d %H:%I:%S %Z'));

        // display the output
        $PAGE->assign('setup_output', $out);
        $PAGE->display();
        exit;
    }
}

// let's do some sanity checks

// verify site_url and site_path
$struct = parse_url(config('site_url'));
if ($struct['path'] != config('site_path'))
{
    die(sprintf(
        "FATAL ERROR:\nIn siteframe.ini, <b>site_url=%s</b> and 
        <b>site_path=%s</b>; however, I believe that your
        site_path <i>should</i> be <b>%s</b>. Please check your siteframe.ini file.",
        config('site_url'),
        config('site_path'),
        $struct['path']));
}

// check for URL rewriting
if (!file_exists('.htaccess'))
{
    if (config('url_rewriting'))
        $PAGE->assign('error',
            'You have url_rewriting=On but do not have a .htaccess file; this
            may be valid if your rewrite rules are installed elsewhere. If
            not, you should copy _htaccess to .htaccess to utilize the
            provided rewrite rules. Otherwise, proceed with setup.');
    else
        $PAGE->assign('error',
            'You should copy _htaccess to .htaccess if you are using the Apache
            webserver. This file provides additional security constraints for
            your system. If possible, you should also set url_rewriting=On to
            permit cleaner, more friendly URLs.');
}

// build the setup input form
$PAGE->assign('setup_pass', 1);
$f = new InputForm(
    'setup',
    $_SERVER['SCRIPT_NAME'],
    'post',
    'Continue with setup'
);
$f->add_item('admin_name', array(
    'type' => 'text',
    'minlength' => 4,
    'maxlength' => 250,
    'size' => 20,
    'pattern' => '/[a-zA-Z][a-zA-Z0-9_]+/',
    'value' => $_POST['admin_name'] ? $_POST['admin_name'] : 'admin',
));
$f->add_item('admin_email', array(
    'type' => 'text',
    'minlength' => 4,
    'maxlength' => 250,
    'size' => 40,
    'pattern' => '/.+@.+/',
    'value' => $_POST['admin_email'],
));
$f->add_item('admin_passwd_1', array(
    'type' => 'password',
    'minlength' => 8,
    'maxlength' => 250,
    'size' => 30,
));
$f->add_item('admin_passwd_2', array(
    'type' => 'password',
    'minlength' => 8,
    'maxlength' => 250,
    'size' => 30,
));
$f->add_item('register_site', array(
    'type' => 'checkbox',
    'rval' => 1,
    'value' => 1,
));
$PAGE->assign('setup_form', $f->get_form());

$PAGE->display();
?>
