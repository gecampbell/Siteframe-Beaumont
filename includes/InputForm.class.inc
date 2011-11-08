<?php
// $Id: InputForm.class.inc,v 1.10 2005/12/02 06:42:30 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.
//
// the InputForm class builds an HTML form from the input metadata

class InputForm extends Siteframe
{
private $elements = array();        // form elements
private $name, $action, $method, $submit, $reset;
public $enctype;

    // create a new form
    public function __construct(
            $fname,
            $action,
            $method='post',
            $submit='Save',
            $freset='Reset')
    {
        $this->name =   $fname;
        $this->action = $action;
        $this->method = $method;
        $this->submit = $submit;
        $this->reset  = $freset;
    }

    // add_item() - adds a new item to the form
    public function add_item($name, $definition)
    {
        $definition['name'] = $name;
        if ($definition['type'] != 'hidden')
        {
            if (!isset($definition['prompt']))
                $definition['prompt'] = lang("prompt_$name");
            if (!isset($definition['help']))
                $definition['help'] = lang("help_$name");
        }
        $this->elements[] = $definition;
    }

    // get_form(template) - returns the HTML for the form
    public function get_form($template='form')
    {
        global $PAGE, $TEMPLATES;
        $this->add_item('_submitted', array(
            'type' => 'integer',
            'hidden' => true,
            'value' => 1,
        ));
        $PAGE->assign('form_name', $this->name);
        $PAGE->assign('form_action', $this->action);
        $PAGE->assign('form_method', $this->method);
        $PAGE->assign('form_elements', $this->elements);
        $PAGE->assign('form_submit', $this->submit);
        $PAGE->assign('form_reset', $this->reset);
        $PAGE->assign('form_enctype', $this->enctype);
        return $PAGE->fetch($TEMPLATES[$template]);
    }

} // end class InputForm

?>
