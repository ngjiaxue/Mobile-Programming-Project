<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];

$sql = "SELECT * FROM NOTIFICATION WHERE EMAIL = '$email' AND COUNT = '1'";

$result = $conn->query($sql);

if ($result->num_rows > 0) {
    echo $result->num_rows;
}else{
    echo 0;
}
?>