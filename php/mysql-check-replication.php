<?php

/**
 *  mysql-check-replication.php
 *
 *  This is a Nagios plugin to check if MySQL replication is working.
 *  It works by connecting to a slave server and checking for two
 *  different values returned by SHOW SLAVE STATUS;  If either is "No"
 *  this exits with a CRITICAL error.  Successful replication gives an
 *  OK response.  Failure to connect to the database throws a WARNING
 *  status.  If you get an exit code of 3 (UNKNOWN), something unexpected
 *  has happened.
 *
 *  A good command config for this plugin in your Nagios config looks
 *  like this:
 *
 *  define command{
 *  	command_name    mysql-replication
 *  	command_line    /path/to/php /path/to/nagios/scripts/mysql-check-replication.php
 *  }
 *
 *  Configure the plugin by adjusting the values below.
 */

$db_host = "mysqlslave";
$db_user = "nagios";  // Whatever this account is, it needs SUPER or REPLICATION CLIENT privileges
$db_pass = "nagios_mysql_password";
$db_name = "";  // Leave it blank
$db_port = 3306;

$exit_code = 3;  // Default value: UNKNOWN  !!! DO NOT CHANGE THIS VALUE

// Connect to the database, and exit with a WARNING status if we can't. This suggests a config problem or a host-down problem.
$db = new mysqli($db_host, $db_user, $db_pass, $db_name, $db_port);
if (!$db) exit(1);  // Exit with a warning status suggesting the script has failed

// Run SHOW SLAVE STATUS and see if either of the telltale signs of replication failure are present
$result = $db->query("SHOW SLAVE STATUS;");
$row = $result->fetch_assoc();
if ($row['Slave_IO_Running'] == "No" || $row['Slave_SQL_Running'] == "No") {
	$exit_code = 2;  // Failure - exit with CRITICAL
} else {
	$exit_code = 0;  // Success - exit with OK
}

// Make sure to safely disconnect
$db->close();

exit($exit_code);

?>
