<?php
 
// Git flow settings.php template
 
$databases = array (
  'default' =>
  array (
    'default' =>
    array (
      'database' => '_placeholder_',
      'username' => 'org_admin',
      'password' => 'pr0Ab2lu',
      'host' => 'localhost',
      'port' => '',
      'driver' => 'mysql',
      'prefix' => '',
    ),
  ),
);
 
# development settings include. If you got custom settings, put em in here.
if (file_exists('sites/default/dev.settings.php')) {
  include('sites/default/dev.settings.php');
}
