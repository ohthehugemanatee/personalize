<?php

// 5 Rings customized settings.php

$databases = array (
  'default' => 
  array (
    'default' => 
    array (
      'database' => '5rings_placeholder_',
      'username' => '5ringsdev',
      'password' => '*W!ub8&wr4da',
      'host' => 'localhost',
      'port' => '',
      'driver' => 'mysql',
      'prefix' => '',
    ),
  ),
);

# 5rings settings include. If you got custom settings, put em in here.
if (file_exists('sites/default/5rings.settings.php')) { 
  include('sites/default/5rings.settings.php'); 
}
