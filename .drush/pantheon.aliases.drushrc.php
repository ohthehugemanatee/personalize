<?php
/**
 * This is a Pantheon drush alias file. Place it in your ~/.drush directory or
 * the aliases directory of your local Drush home.
 *
 * To see if it's working, try "drush sa" to list available aliases.
 *
 */
$aliases['the-cast.test'] = array(
  'root' => '.',
  'uri' => 'test-the-cast.gotpantheon.com',
  'db-url' => 'mysql://pantheon:138e2c5135604e96a351a46f83cb9517@dbserver.test.536e3a48-66b8-4512-aec5-f18d2b2012cf.drush.in:11412/pantheon',
  'db-allows-remote' => TRUE,
  'remote-host' => 'appserver.test.536e3a48-66b8-4512-aec5-f18d2b2012cf.drush.in',
  'remote-user' => 'test.536e3a48-66b8-4512-aec5-f18d2b2012cf',
  'ssh-options' => '-p 2222 -o "AddressFamily inet"',
  'path-aliases' => array(
    '%files' => 'sites/default/files'
  ),
);
$aliases['the-cast.live'] = array(
  'root' => '.',
  'uri' => 'live-the-cast.gotpantheon.com',
  'db-url' => 'mysql://pantheon:284314020bde4915b8543d1d84b24546@dbserver.live.536e3a48-66b8-4512-aec5-f18d2b2012cf.drush.in:11917/pantheon',
  'db-allows-remote' => TRUE,
  'remote-host' => 'appserver.live.536e3a48-66b8-4512-aec5-f18d2b2012cf.drush.in',
  'remote-user' => 'live.536e3a48-66b8-4512-aec5-f18d2b2012cf',
  'ssh-options' => '-p 2222 -o "AddressFamily inet"',
  'path-aliases' => array(
    '%files' => 'sites/default/files'
  ),
);
$aliases['the-cast.dev'] = array(
  'root' => '.',
  'uri' => 'dev-the-cast.gotpantheon.com',
  'db-url' => 'mysql://pantheon:2b600ce0213641d7a4101077c1aa8764@dbserver.dev.536e3a48-66b8-4512-aec5-f18d2b2012cf.drush.in:11011/pantheon',
  'db-allows-remote' => TRUE,
  'remote-host' => 'appserver.dev.536e3a48-66b8-4512-aec5-f18d2b2012cf.drush.in',
  'remote-user' => 'dev.536e3a48-66b8-4512-aec5-f18d2b2012cf',
  'ssh-options' => '-p 2222 -o "AddressFamily inet"',
  'path-aliases' => array(
    '%files' => 'sites/default/files'
  ),
);
