<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];

$conn->query("UPDATE NOTIFICATION SET COUNT = '0' WHERE EMAIL = '$email'");
?>