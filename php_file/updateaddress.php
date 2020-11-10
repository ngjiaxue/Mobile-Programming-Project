<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$latitude = $_POST['latitude'];
$longitude = $_POST['longitude'];
$address = $_POST['address'];

if(isset($address)){
    $sql = "UPDATE USER SET ADDRESS = '$address' WHERE EMAIL = '$email'";
}else{
    $sql = "UPDATE USER SET LATITUDE = '$latitude', LONGITUDE = '$longitude' WHERE EMAIL = '$email'";
}

if ($conn->query($sql) === true){
    echo "success";
}else{
    echo "failed";
}
?>