<?php
error_reporting(0);
include_once ("dbconnect.php");
$trackingno = $_POST['trackingno'];
$email = $_POST['email'];

$sqlinsert = "INSERT INTO PARCEL(TRACKINGNO,EMAIL) VALUES ('$trackingno','$email')";

if ($conn->query($sqlinsert) === true){
    $conn->query("INSERT INTO NOTIFICATION (MESSAGE, EMAIL) VALUES ('$trackingno is pending to arrive.','$email')");
    echo "success";
}else{
    echo "failed";
}
?>