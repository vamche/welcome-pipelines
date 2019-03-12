<?php

/**
 * Performs a simple version check for php extensions.
 *
 * IMPORTANT! This file isn't being used right now. It will eventually become
 * a replacement for the check-versions.sh and check-php-extensions-versions
 * .php files.
 */
function get_php_ext_versions() {
  $extensions = array(
    'gd' => '2.1.0',
    'pdo_mysql' => '5.0.11-dev - 20120503 - $Id: 3c688b6bbc30d36af3ac34fdd4b7b5b787fe5555',
    'mcrypt' => '2.5.8',
    'gmp' => '6.0.0',
    'zip' => 'c203148334b6f80d27bc5d23fad5ec3ca7dcf444',
    'mysqli' => '5.0.11-dev - 20120503 - $Id: 3c688b6bbc30d36af3ac34fdd4b7b5b787fe5555',
  );

  foreach ($extensions as $extension => $version) {
    ob_start();
    $ext = new ReflectionExtension($extension);
    $ext->info();
    $ext_info = ob_get_contents();
    ob_end_clean();

    $version_matches = strpos($ext_info, $version);
    if ($version_matches === FALSE) {
      printf("Version check failed for %s. Expected %s, got %s.\n", $extension, $version, $ext_info);
      exit(1);
    }
    else {
      printf("Version check completed successfully for %s. Version: %s.\n", $extension, $version);
    }
  }
  printf('Version check completed successfully for all php extensions.');
}

function verify_tool_versions() {
  $tools = array(
    'composer' => '1.0-dev\s(a54f84f05f915c6d42bed94de0cdcb4406a4707b',
    'ruby' => '2.1.5',
    'ssh' => 'OpenSSH_6.7p1',
    'rsync' => '3.1.1',
    'nodejs' => 'v0.12.7',
    'git' => '2.1.4',
    'unzip' => '6.00',
    'unzip' => '1.0.6',
    'gem' => '2.4.8',
    'compass' => '1.0.3',
    'npm' => '2.11.3',
    'grunt' => 'v0.1.13',
    'bower' => '1.5.3',
    'drush' => '6.6.0',
  );
}

get_php_ext_versions();
