<?php
// $Id: photoinfo.php,v 1.1 2005/04/03 21:47:14 glen Exp $
// Copyright (c)2005, Glen Campbell. All rights reserved.
// This plugin adds a number of optional properties to the File object:
//  camera
//  lens
//  flash
//  camera type (film, digital)
//  film type
//  film speed
//  exposure time
//  exposure f/stop
//  digital enhancements
//  darkroom enhancements

Plugin::add_property('File', 'info_camera', array(
    'type' => 'text',
    'maxlength' => 50,
    'prompt' => 'Camera',
    'help' => 'Enter the manufacturer and model of camera used',
));
Plugin::add_property('File', 'info_lens', array(
    'type' => 'text',
    'maxlength' => 50,
    'prompt' => Lens,
    'help' => 'Enter the manufacturer, model, and aperture of the lens used',
));
Plugin::add_property('File', 'info_flash', array(
    'type' => 'checkbox',
    'rval' => 1,
    'prompt' => 'Flash used',
    'help' => 'Check if a flash was used when taking this photograph',
));
Plugin::add_property('File', 'info_flash_settings', array(
    'type' => 'text',
    'maxlength' => 50,
    'prompt' => 'Flash Settings',
    'help' => 'If flash was used, describe the flash settings here.',
));
Plugin::add_property('File', 'info_exposure', array(
    'type' => 'select',
    'options' => array(
        'N/R' => 'Not recorded',
        'B' => 'Bulb',
        '1"' => '1 second',
        '1/2"' => '1/2 second',
        '1/4"' => '1/4 second',
        '1/8"' => '1/8 second',
        '1/16"' => '1/16 second',
        '1/30"' => '1/30 second',
        '1/60"' => '1/60 second',
        '1/90"' => '1/90 second',
    ),
    'prompt' => 'Exposure',
    'help' => 'Select the exposure time from the list',
));
Plugin::add_property('File', 'info_aperture', array(
    'type' => 'select',
    'options' => array(
        '1.0' => 'f1.0',
        '1.4' => 'f1.4',
        '1.8' => 'f1.8',
        '2.0' => 'f2.0',
    ),
    'prompt' => 'Aperture',
    'help' => 'Select the aperture (f/stop) from the list'
));

?>