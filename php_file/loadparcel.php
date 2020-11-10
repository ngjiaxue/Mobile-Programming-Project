<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$status = $_POST['status'];
$trackingno = $_POST['trackingno'];

if(isset($trackingno)){
    $sql = "SELECT * FROM PARCEL WHERE EMAIL = '$email' AND STATUS = '$status' AND SHOWTOUSER = '1' AND TRACKINGNO LIKE '%$trackingno%' ORDER BY PARCELID DESC";
}else{
    $sql = "SELECT * FROM PARCEL WHERE EMAIL = '$email' AND STATUS = '$status' AND SHOWTOUSER = '1' ORDER BY PARCELID DESC";
}

$result = $conn->query($sql);
if ($result->num_rows > 0) {
    $response["parcel"] = array();
    while ($row = $result ->fetch_assoc()){
        $parcellist = array();
        $parcellist[trackingno] = $row["TRACKINGNO"];
        $parcellist[status] = $row["STATUS"];
        $parcellist[date] = date_format(date_create($row["DATE"]), 'd/m/Y H:i:s');
        array_push($response["parcel"], $parcellist);    
    }
    echo json_encode($response);
}else{
    echo "no data";
}
?>