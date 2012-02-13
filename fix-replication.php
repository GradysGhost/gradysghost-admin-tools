<?php

/**
 *  fix-replication.php
 *
 *  aka "The Debbie Necessity"
 *
 *  FOR TALOS'S SAKE, DON'T RUN THIS SCRIPT IF YOU DON'T KNOW *EXACTLY*
 *  WHAT YOU'RE DOING!  IT COULD SERIOUSLY SCREW UP YOUR REPLICATION
 *  CONFIGURATION IF YOU USE IT FOR THE WRONG REASONS!  HERE'S WHEN YOU
 *  *SHOULD* USE IT:
 *
 *  This script is useful for cases when data has become out of sync
 *  between a master and slave in a MySQL replication configuration due
 *  to a table being created in one place and not the other, leading to
 *  a bunch of CREATE, INSERT, UPDATE, and/or DROP queries being run
 *  successfully on the master, but resulting in an unending stream of
 *  errors on the slave.  This script skips through those errors one at
 *  a time until replication works again.
 *
 *  ONCE AGAIN, THIS SCRIPT HAS THE POTENTIAL TO COMPLETELY SCREW UP YOUR
 *  REPLICATION CONFIGURATION!!!  SO DON'T RUN IT IF YOU DON'T KNOW FOR
 *  SURE THAT IT'S WHAT YOU NEED!
 */

$dbhost = "localhost";
$dbport = 3306;
$dbuser = "root";	// Whatever account this is - it needs to be able to run all the queries below.
$dbpass = "your_root_password";
$dbname = "";

$db = new mysqli($dbhost, $dbuser, $dbpass, $dbname, $dbport);
if (!$db) die("Could not connect to the database.\n");
echo "Connected to the database.\n";

$queries_skipped = 0;
$replication_fixed = false;

while (!$replication_fixed) {
  $result = $db->query("SHOW SLAVE STATUS;");
  $row = $result->fetch_assoc();
  if ($row['Slave_SQL_Running'] == "No") {
    echo "Skipping query due to error: {$row['Last_SQL_Error']}\n";
    $db->query("STOP SLAVE;");
    $db->query("SET GLOBAL sql_slave_skip_counter = 1;");
    $db->query("START SLAVE;");
    ++$queries_skipped;
    sleep(1);
  } else {
    echo "Please wait.  Trying to confirm that replication is actually running...\n";
    sleep(2);
    $result = $db->query("SHOW SLAVE STATUS;");
    $row = $result->fetch_assoc();
    if ($row['Slave_SQL_Running'] == "Yes") {
      echo "Yep!  Replication appears to be back online after running for a few seconds.\n";
      echo "You should probably check that manually, though.  You can never be too sure, can you?\n";
      $replication_fixed = true;
    } else {
      echo "False alarm.  Replication still broken.\n";
    }
  }
}

echo "Skipped $queries_skipped queries.\n";

?>