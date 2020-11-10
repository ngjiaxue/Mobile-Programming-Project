<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];
$password = sha1($_POST['password']);

$sql = "UPDATE USER SET PASSWORD = '$password' WHERE EMAIL = '$email'";

if ($conn->query($sql) === true){
    echo "success";
}else{
    echo "failed";
}
?>