<?php

/**
 * Performs a simple version check for php extensions.
 *
 * The versions are hard-coded from container specs.
 */
function get_php_ext_versions() {
  $extensions = array(
    'gd' => '2.1.1',
    'pdo_mysql' => '5.0.12-dev - 20150407 - $Id: 38fea24f2847fa7519001be390c98ae0acafe387',
    'mcrypt' => '2.5.8',
    'gmp' => '6.1.0',
    'zip' => '1.13.5',
    'mysqli' => '5.0.12-dev - 20150407 - $Id: 38fea24f2847fa7519001be390c98ae0acafe387',
    'bz2' => '1.0.6',
    'imagick' => '3.4.3',
    'curl' => '7.47.0',
  );

  foreach ($extensions as $extension => $version) {
    ob_start();
    $ext = new ReflectionExtension($extension);
    $ext->info();
    $ext_info = ob_get_contents();
    ob_end_clean();

    $version_matches = strpos($ext_info, $version);
    if ($version_matches === FALSE) {
      $message = sprintf("Version check failed for %s. Expected %s, got %s.\n", $extension, $version, $ext_info);
      file_put_contents('/tmp/version_check_failure', $message, FILE_APPEND);
    }
    else {
      $message = sprintf("Version check completed successfully for %s. Version: %s.\n", $extension, $version);
      file_put_contents('/tmp/version_check_success', $message, FILE_APPEND);
      print($message);
    }
  }
  printf('Version check completed for all php extensions.');
}

get_php_ext_versions();
