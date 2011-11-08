<?php
// $Id: SiteframeTemplate.class.inc,v 1.8 2005/11/30 02:49:55 glen Exp $
// Copyright (c)2004, Glen Campbell. All rights reserved.

class SiteframeTemplate extends Smarty
{

// constructor
public function __construct($template_set)
{
    parent::Smarty();
    $this->load_new($template_set);
}

// load_new($template_set)
public function load_new($template_set)
{
    $tpl_dir = config('dir_templates').'/'.$template_set;
    
    // assign directories
    $this->template_dir = $tpl_dir;
    $this->plugins_dir  = array(
                            'plugins',
                            config('dir_smarty_plugins','smarty')
                          );
    $this->compile_dir  = config('dir_files').'/compile/'.$template_set;
    $this->cache_dir    = config('dir_files').'/cache/'.$template_set;

    // recursively create compile directory
    @mkdir($this->compile_dir, DEFAULT_FILE_PERMS, true);
    @mkdir($this->cache_dir,   DEFAULT_FILE_PERMS, true);

    // assign a property
    parent::assign('template_dir', $this->template_dir);
}

// display - displays the current filename
public function display($alt='')
{
    global $TEMPLATES, $PAGE_START;
    if (isset($_GET['template']))
        $tpl = $TEMPLATES[$_GET['template']];
    else if ($alt != '')
    {
        $this->assign('alt_template', $alt);
        // define allowable directories
        $this->secure_dir = array(config('dir_templates'));
        // enable security
        $this->security = false;
        // don't permit {php}{/php} tags
        $this->security_settings['PHP_TAGS'] = false;
        // fetch the custom template
        $tpl = $TEMPLATES['custom'];
    }
    else
        $tpl = $TEMPLATES[basename($_SERVER['SCRIPT_NAME'])];
    
    
    // abort if we don't have a valid template
    if ($tpl == '')
        abort('No template is currently available for this page. Sorry.');

    // show the template
    parent::display($tpl);
    
    // add trailer for debugging
    printf("\n<!-- %s/%.4f secs -->\n",
       basename($_SERVER['SCRIPT_NAME']),
       microtime(true) - $PAGE_START
     );
}

} // end class SiteframeTemplate
?>
