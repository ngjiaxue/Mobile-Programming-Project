<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];

$sql = "SELECT * FROM USER WHERE EMAIL = '$email'";

$result = $conn->query($sql);
    while($row = $result->fetch_assoc()){
        $credit = $row['CREDIT'];
    }

if ($result->num_rows > 0) {
    echo "$credit";
}else{
    echo "no data";
}
?>