<?php
error_reporting(0);
include_once ("dbconnect.php");
$oldtrackingno = $_POST['oldtrackingno'];
$newtrackingno = $_POST['newtrackingno'];
$email = $_POST['email'];

$sqlinsert = "UPDATE PARCEL SET TRACKINGNO = '$newtrackingno' WHERE TRACKINGNO = '$oldtrackingno' AND EMAIL = '$email'";

if ($conn->query($sqlinsert) === true){
    $conn->query("INSERT INTO NOTIFICATION (MESSAGE, EMAIL) VALUES ('$oldtrackingno has been successfully changed to $newtrackingno.','$email')");
    echo "success";
}else{
    echo "failed";
}
?>