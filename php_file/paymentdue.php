<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];

$sql = "SELECT * FROM PARCEL WHERE EMAIL = '$email' AND STATUS ='Delivered' AND PAID = '0'";


$result = $conn->query($sql);
if ($result->num_rows > 0) {
    echo "$result->num_rows";
}else{
    echo "no data";
}
?>