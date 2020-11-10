<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_GET['email'];
$password = $_GET['password'];

$sql = "UPDATE USER SET PASSWORD = '$password' WHERE EMAIL = '$email'";

if ($conn->query($sql) === TRUE) {
    echo "Password successfully changed, you may now login using your new password";
} else {
    echo "failed";
}



$conn->close();
?>