<?php
error_reporting(0);
include_once("dbconnect.php");
$trackingno = $_POST['trackingno'];
$status = $_POST['status'];
$email = $_POST['email'];

$sqlinsert = "UPDATE PARCEL SET STATUS = '$status' WHERE TRACKINGNO = '$trackingno'";

if ($conn->query($sqlinsert) === true){
    if($status === "Delivering"){
        $conn->query("INSERT INTO NOTIFICATION (MESSAGE, EMAIL) VALUES ('$trackingno has arrived, we will start delivering your parcel.','$email')");
    }else if($status === "Delivered"){
        $conn->query("INSERT INTO NOTIFICATION (MESSAGE, EMAIL) VALUES ('$trackingno has been successfully delivered.','$email')");
    }
    echo "success";
}else{
    echo "failed";
}
?>