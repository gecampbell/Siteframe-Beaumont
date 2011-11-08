<?php 
// $Id: siteframe.inc,v 1.128 2007/09/04 18:11:57 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.
//
// This is the core include file for Siteframe. It defines all the
// standard constants etc.
//
$PAGE_START = microtime(TRUE);
define('INI_FILE', 'siteframe.ini');            // configuration
define('SMARTY_CLASS', 'Smarty.class.php');     // template library

// other defaults
define('SITEFRAME_VERSION', '%%VERSION%%');
define('USER_STATUS_PENDING',  0);
define('USER_STATUS_NORMAL', 1);
define('DEFAULT_FILE_PERMS', 0777);             // default permissions
define('BEAUMONT_COOKIE', 'bc');                // user cookie

// all the defined classes
$ALL_CLASSES = array(
    'Audit', 'User', 'Folder', 'Page', 'File', 'Comment', 'Tag',
    'TagPageRel', 'TagUserRel', 'Rating', 'SearchText', 'Text',
    'Property', 'Invitation', 'Subscription', 'Memo', 'Favorite',
    'Quote', 'Template', 'UserLog', 'ACL', 'Link', 'LinkPageRel',
    'Group', 'GroupUserRel', 'TagView', 'RSSfeed', 'Trackback');

// load the configuration file
if (!file_exists(INI_FILE))
    abort('Siteframe has not been properly installed. Read the installation '.
          'instructions and set up your <code>siteframe.ini</code> '.
          'file before proceeding.');
$CONFIG = parse_ini_file(INI_FILE);
$urlinfo = parse_url(config('site_url'));
foreach($urlinfo as $item => $value)
    $CONFIG["site_url_$item"] = $value;
$CONFIG['site_path'] = $CONFIG['site_url_path'];
$CONFIG['site_url_base'] = str_replace(config('site_path'), '', config('site_url'));

// optional include
@include config('optional_include');

// start the session
session_name('sssiteframe');
session_start();

// __autoload to load include files
function __autoload($classname)
{
    $file = sprintf('%s/%s.class.inc', config('dir_includes'), $classname);
    if (!file_exists($file))
        abort('Internal error: file [%s] does not exist', $file);
    else
        require_once($file);
}

// start_time() - returns the start time of page generation
function start_time()
{
    global $PAGE_START;
    return $PAGE_START;
}

// abort(msg[, p1...]) - die with an error message
function abort($msg, $p1='', $p2='', $p3='', $p4='', $p5='')
{
    $out = sprintf($msg, $p1, $p2, $p3, $p4, $p5);
    $html = <<<ENDHTML
<html>
<head>
<title>Fatal Internal Error</title>
<style type="text/css">
body { width:600px; font-family:arial,helvetica,sans-serif; margin-left:auto; margin-right:auto; }
strong { color:red; }
p { line-height:150%; }
</style>
</head>
<body>
<h1>Fatal Internal Error</h1>
<p>&rarr; <strong>$out</strong></p>
<p>If you're not currently developing templates, tools, or Siteframe code, then
first let me offer my apologies; this error should never really occur in a live
environment. Second, could you please let me know about how and when this error
occurred? Send an email to 
<a href="mailto:feedbackREMOVE@THISsiteframe.org">Siteframe Feedback</a>
(you'll need to edit the email address)
and include your site, the URL of this page, and a brief description as to
what you were doing at the time this error occurred.</p>
</body>
</html>
ENDHTML;
    die($html);
}

// config - return the value of a configuration parameter
// if the config doesn't exist, return the default value
function config($parm, $default='')
{
    global $CONFIG;
    if (isset($CONFIG[$parm]))
        return $CONFIG[$parm];
    else
        return $default;
}

// load_template_ini - loads a template file
// also loads custom.ini if it exists
function load_template_ini($template_set)
{
    $dir = './'.$template_set;
    if ($template_set != '')
        $dir .= '/';
    $arr = parse_ini_file($dir.'template.ini');
    if (file_exists($dir.'custom.ini'))
        $arr = array_merge($arr, parse_ini_file($dir.'custom.ini'));
    return $arr;
}

// lang - return the value of a language token
function lang($parm)
{
    global $LANG;

    if (!isset($LANG[$parm]))
        return $parm;
    else
        return str_replace('qq', '"', $LANG[$parm]);
}

// site_template() - return the name of a site template
function site_template($name)
{
    global $_SITE_TEMPLATES;
    
    if (!is_array($_SITE_TEMPLATES))
        $_SITE_TEMPLATES = load_template_ini(config('dir_templates'));
    
    if (isset($_SITE_TEMPLATES[$name]))
        return $_SITE_TEMPLATES[$name];
    else
        return $name . '.tpl';
}

// debug - output a debug message
function debug($msg, $p1='', $p2='', $p3='', $p4='', $p5='')
{
    global $FDEBUG;
    if (!$FDEBUG)
    {
        $FDEBUG = fopen('/tmp/debug', 'w');
        if (!$FDEBUG) die('cannot write to /tmp/debug');
        fwrite($FDEBUG, sprintf("DEBUG initialized %s\n",date('Y-m-d')));
    }
    fwrite($FDEBUG, sprintf("$msg\n", $p1, $p2, $p3, $p4, $p5));
}

// logout - terminate session
function logout()
{
    global $PAGE;
    $_SESSION['user'] = 0;
    setcookie(config('login_cookie'), "", time()-3600, config('site_path'));
    $PAGE->assign('cuser', 0);
}

// login - create a new session
function login($hash)
{
    global $AUDIT, $_SESSION;

    $DB = Database::getReader();
    $u = new User;
    $q = sprintf(
        "SELECT user_id FROM %s WHERE user_hash='%s'",
        $u->table_name(),
        addslashes(strip_tags($_COOKIE[config('login_cookie')])));
    $result = $DB->query($q);
    if ($DB->errno == 1146)
        header(sprintf('Location: %s/setup.php', config('site_url')));
    else if ($DB->errno)
        abort(lang('err_db'), $DB->error);
    if ($result->num_rows == 1)
    {
        list($uid) = $result->fetch_row();
        $u = new User($uid);
        if ($u->get('user_id'))
        {
            $u->set('last_login', strftime('%Y-%m-%d %H:%M:%S'));
            $u->update();
            $_SESSION['user'] = $u;
            $AUDIT->message('%s logged in', $_SESSION['user']->get('user_name'));
        }
    }
}

// require_login - used to ensure that a person is logged in
function require_login()
{
    if (is_object($_SESSION['user']) && $_SESSION['user']->id())
        return;
    else {
        header(sprintf('Location: %s/login.php?rd=%s',
                config('site_url'),
                urlencode($_SERVER['REQUEST_URI'])));
        exit;
    }    
}

// check_db - checks for bad database return value
function check_db($DB)
{
    if ($DB->errno)
        abort(lang('err_db'), $DB->error, $DB->errno);
}

// sends a user confirmation email
function send_user_confirmation_email($user)
{
    $em = new HtmlEmail(lang('msg_register_subject'));
    $em->to($user->get('user_email'));
    $em->set($user->get_all());
    $em->send_template(site_template('register'));
}

// set_property(name, value) update a value
function set_property($name, $value)
{
    $DB = Database::getWriter();
    $prop = new Property;
    $q = sprintf("DELETE FROM %s WHERE name='%s'", 
            $prop->table_name(), 
            addslashes(strtolower($name)));
    $DB->query($q);
    check_db($DB);
    $q = sprintf("INSERT INTO %s VALUES ('%s', '%s')",
            $prop->table_name(), 
            addslashes(strtolower($name)), 
            addslashes($value));
    $DB->query($q);
    check_db($DB);
}

// get_property(name) - return a value
function get_property($name, $default='')
{
    $DB = Database::getReader();
    $prop = new Property;
    $q = sprintf("SELECT value FROM %s WHERE name='%s'",
            $prop->table_name(), addslashes($name));
    $result = $DB->query($q);
    check_db($DB);
    if ($result->num_rows == 0)
        return $default;
    list($value) = $result->fetch_row();
    return stripslashes($value);
}

// get_user_list() returns a list of all users for HTML SELECT
function get_user_list()
{
    $DB = Database::getReader();

    $arr = array();
    $u = new User;
    $q = sprintf("SELECT user_id FROM %s ORDER BY user_name", $u->table_name());
    $result = $DB->query($q);
    check_db($DB);
    while(list($id) = $result->fetch_row())
    {
        $user = new User($id);
        $arr[$id] = $user->get_title();
    }
    return $arr;
}

// get_user_id_from_username(name) - does what it says
function get_user_id_from_username($name)
{
    $DB = Database::getReader();

    $u = new User;
    $q = sprintf(
        "SELECT user_id FROM %s WHERE user_name='%s'",
        $u->table_name(),
        $name);
    $r = $DB->query($q);
    check_db($DB);
    list ($id) = $r->fetch_array();
    return $id;
}

// strtrunc - split string on a word boundary, no longer than num characters
function strtrunc($str, $num)
{
    $str = strip_tags($str);
    $initlen = strlen($str);
    $str = trim(substr($str, 0, $num));
    if (strlen($str) >= $num) 
    {
        $lpos = strrpos($str, ' ');
        $str = substr($str, 0, $lpos).'...';
    }
    return $str;
}

// resize_image()
// creates a scaled-down version of an image
// returns the new file name
function resize_image($filename, $mimetype, $res, $rotate=0, $center=0)
{
    // derive the new filename
    $resized_file = preg_replace(
        '/\.([^\.]+)$/',
        sprintf('-%04d%03d%s.\1',$res, $rotate, $center ? 'c' : 'n'),
        $filename
    );
    if (file_exists($resized_file))
        return $resized_file;

    // increase memory size
    ini_set("memory_limit", "64M");

    // set image quality
    $IMAGE_QUALITY = config('image_quality', 90);

    // check the size of the original image
    $size = GetImageSize($filename);
    $width = $size[0];
    $height = $size[1];

    // if either is 0, something's wrong
    if ($width==0||$height==0)
        abort('problem in image file [%s], h=%d w=%d', $filename, $height, $width);

    // if both the with and the height are less than the
    // requested resolution, then just return the original image
    if (($width <= $res) && ($height <= $res))
        return $filename;

    // check the mime type and construct a mental image
    switch($mimetype) {
    case 'image/pjpeg':
    case 'image/jpeg':
        $im = ImageCreateFromJPEG($filename);
        break;
    case 'image/gif':
        $im = ImageCreateFromGIF($filename);
        break;
    case 'image/x-png':
    case 'image/png':
        $im = ImageCreateFromPNG($filename);
        break;
    default:
        return sprintf('unsupported MIME type for thumbnail [%s]', $mimetype);
    }

    // finally, resize everything
    $x = ImageSX($im);      // x=width
    $y = ImageSY($im);      // y=height
    
    // if x > y, then horizontal format
    if ($x > $y)
        $scale = $res / $x;
    else
        $scale = $res / $y;
    
    // scale determines how much smaller the image is
    $new_w = $x * $scale;
    $new_h = $y * $scale;
    
    // if scale >= 1, then no sizing should take place
    if ($scale > 1) {
        return $filename;
    }
    else {
        // generate the new filename
        if ($center)
        {
            if ($x > $y)    // horizontal
            {
                $new_w = $new_h = $res;
                $out = ImageCreateTrueColor($new_w, $new_h);
                ImageCopyResampled($out,$im,0,0,($x-$y)/2,0,$new_w,$new_h,$y,$y);
            }
            else            // vertical
            {
                $new_h = $new_w = $res;
                $out = ImageCreateTrueColor($new_w, $new_h);
                ImageCopyResampled($out,$im,0,0,0,($y-$x)/2,$new_w,$new_h,$x,$x);
            }
        }
        else
        {
            $out = ImageCreateTrueColor($new_w,$new_h);
            ImageCopyResampled($out,$im,0,0,0,0,$new_w,$new_h,$x,$y);
        }
        
        // rotate image if necessary
        if ($rotate)
            $out = ImageRotate($out, $rotate, 0xFFFFFF);
        
        // interlace it
        ImageInterlace($out, 1);

        // save the file
        switch($mimetype) {
        case "image/gif":
            ImageGIF($out, $resized_file);
            break;
        case "image/x-png":
        case "image/png":
            ImagePNG($out, $resized_file);
            break;
        default:
            ImageJPEG($out, $resized_file, $IMAGE_QUALITY);
        }
        //chmod($resized_file,0777);
        ImageDestroy($out);
    }
    ImageDestroy($im);

    // finally, return the new filename
    return $resized_file;
}

// ============================================================================

// set the language
$USER_LANG = config('lang_default');
// $LANG = parse_ini_file(config('dir_lang').'/'.$USER_LANG.'.ini');

// load the default templates
$USER_TPL = config('default_site_templates');
$tpl_dir = config('dir_templates').'/'.$USER_TPL;
if (!file_exists($tpl_dir.'/template.ini'))
{
    $USER_TPL = 'default';
    $tpl_dir = config('dir_templates')."/default";
    if (!is_dir($tpl_dir))
        abort("No template directory [$USER_TPL]; no fallback template set [default]. ".
              "Am unable to continue. Frightfully sorry for the inconvenience, ".
              "but it appears that there is an extremely serious configuration ".
              "error.");
}
$TEMPLATES = load_template_ini($tpl_dir);

// create an audit trail
$AUDIT = new Audit;

// load Smarty
require(config('dir_smarty').SMARTY_CLASS);

// initialize the page template
$PAGE = new SiteframeTemplate($USER_TPL);
$PAGE->assign($CONFIG);
$PAGE->assign('lang', $LANG);
$PAGE->assign('VERSION', SITEFRAME_VERSION);
$PAGE->assign('BUILD', '%%BUILD%%');
$PAGE->assign('script', basename($_SERVER['SCRIPT_NAME']));

// check for auto-login
$script = basename($_SERVER['SCRIPT_NAME']);

// check to see if we've been installed
if ($script != 'setup.php')
{
	$DB = Database::getReader();
    $result = @$DB->query(sprintf('SELECT * FROM %s LIMIT 1', $AUDIT->table_name()));
    if ($DB->errno == 1146)
    {
        header(sprintf('Location: %s/setup.php', config('site_url')));
        exit;
    }
}

// perform login
if (is_object($_SESSION['user']) && $_SESSION['user']->get('user_id'))
    ;   // already logged in
else if ($script == 'setup.php')
    ;   // do nothing
else if (isset($_COOKIE[config('login_cookie')]))
    login($_COOKIE[config('login_cookie')]);
else if ($script == 'login.php')
    ;   // do nothing - these are ok
else if (config('public_xml') && ($script == 'rss.php'))
    ;   // allow public XML
else if (config('open_registration') && ($script == 'register.php'))
    ;   // let people register if open
else if (config('login_required'))
    header(sprintf('Location: %s/login.php', config('site_url')));

// fetch user properties
if (is_object($_SESSION['user']) && $_SESSION['user']->get('user_id'))
{
    $PAGE->assign('cuser', $_SESSION['user']->get_all());
    if (($lang = $_SESSION['user']->get('user_language')) != '')
        $USER_LANG = $lang;
}

// load the user's language
// check for old versions
if ($USER_LANG == 'en_us')
    $USER_LANG = 'en-US';
$LANG = parse_ini_file(config('dir_lang').'/'.strtolower($USER_LANG).'.ini');

// set a cookie to track all visitors (with cookies)
if (!isset($_COOKIE[BEAUMONT_COOKIE]))
    setcookie(BEAUMONT_COOKIE, sha1(microtime()), 2147483647, config('site_path'));
$PAGE->assign('beaumont_cookie', strip_tags($_COOKIE[BEAUMONT_COOKIE]));

// assign some other values
$PAGE->assign('HTTP_REFERER',     htmlentities($_SERVER['HTTP_REFERER']));
$PAGE->assign('HTTP_USER_AGENT',  htmlentities($_SERVER['HTTP_USER_AGENT']));
$PAGE->assign('REQUEST_URI',      htmlentities($_SERVER['REQUEST_URI']));
$PAGE->assign('REQUEST_METHOD',   htmlentities($_SERVER['REQUEST_METHOD']));
$PAGE->assign('REMOTE_ADDR',      htmlentities($_SERVER['REMOTE_ADDR']));

// at this point, we know we've been installed, and we know
// that we are not in setup.php; log the page view
if (($script != 'setup.php') && config('user_log_enable'))
{
    $log = new UserLog;
    $log->add();
}

// generate some properties for the page
if (config('url_rewriting'))
    $PAGE->assign('site_rss_url', config('site_url').'/rss');
else
    $PAGE->assign('site_rss_url', config('site_url').'/rss.php');

// load plugins
foreach(glob(config('dir_plugins').'/*.php') as $filename)
{
    $name = str_replace('.php', '', basename($filename));
    if (config("${name}_enable"))
        require_once($filename);
}

?>
