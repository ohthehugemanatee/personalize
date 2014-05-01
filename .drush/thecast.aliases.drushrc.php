<?php
// Site aliases for the cast (thecast)
$aliases['dev'] = array(
  'parent' => '@parent',
  'site' => 'thecast',
  'env' => 'dev',
  'uri' => 'http://the-cast.dev.nodesymphony.com/master',
  'root' => '/var/www/dev.nodesymphony.com/public_html/the-cast/master',
  'remote-host' => 'dev.nodesymphony.com',
  'remote-user' => 'cvertesi',
);
// Site thecast, environment stage
$aliases['stage'] = array(
  'parent' => '@parent',
  'site' => 'thecast',
  'env' => 'stage',
  'root' => '/var/www/staging.the-cast.de/public_html',
  'remote-host' => 'staging.the-cast.de',
  'remote-user' => 'cvertesi',
);
// Site thecast, environment live
$aliases['live'] = array(
  'parent' => '@parent',
  'site' => 'thecast',
  'env' => 'live',
  'root' => '/var/www/the-cast.de/public_html',
  'remote-host' => 'the-cast.de',
  'remote-user' => 'cvertesi',
);
