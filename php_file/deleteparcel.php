<?php
error_reporting(0);
include_once ("dbconnect.php");
$trackingno = $_POST['trackingno'];
$email = $_POST['email'];

$sqlinsert = "UPDATE PARCEL SET SHOWTOUSER = '0' WHERE TRACKINGNO = '$trackingno' AND EMAIL = '$email'";

if ($conn->query($sqlinsert) === true){
    $conn->query("INSERT INTO NOTIFICATION (MESSAGE, EMAIL) VALUES ('$trackingno is canceled, please contact admin if this is an error message.','$email')");
    echo "success";
}else{
    echo "failed";
}
?>