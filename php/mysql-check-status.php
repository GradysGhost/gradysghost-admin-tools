<?php

$host = "";
$user = "";
$pass = "";
$dbnm = "";
$port = 3306;

$conn = new mysqli($host, $user, $pass, $dbnm, $port);
if ($conn->connect_error) {
	echo "FAIL";
} else {
	echo "OK";
}

?>
