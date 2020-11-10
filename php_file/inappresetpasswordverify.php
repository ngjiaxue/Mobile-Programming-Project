<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];
$oldpassword = sha1($_POST['oldpassword']);

$sql = "SELECT * FROM USER WHERE EMAIL = '$email' AND PASSWORD = '$oldpassword'";

$result = $conn->query($sql);

if ($result->num_rows === 1){
    echo "success";
}else{
    echo "failed";
}
?>