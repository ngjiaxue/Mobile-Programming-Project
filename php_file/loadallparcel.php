<?php
error_reporting(0);
include_once("dbconnect.php");
$status = $_POST['status'];
$trackingnoorname = $_POST['trackingnoorname'];

if(isset($trackingnoorname)){
    $sql = "SELECT * FROM PARCEL INNER JOIN USER ON PARCEL.EMAIL = USER.EMAIL WHERE STATUS = '$status' AND SHOWTOUSER = '1' AND NAME LIKE '%$trackingnoorname%' OR STATUS = '$status' AND SHOWTOUSER = '1' AND TRACKINGNO LIKE '%$trackingnoorname%' ORDER BY PARCELID DESC";
}else{
     $sql = "SELECT * FROM PARCEL INNER JOIN USER ON PARCEL.EMAIL = USER.EMAIL WHERE STATUS = '$status' AND SHOWTOUSER = '1' ORDER BY PARCELID DESC";
}

$result = $conn->query($sql);
if ($result->num_rows > 0) {
    $response["parcel"] = array();
    while ($row = $result ->fetch_assoc()){
        $parcellist = array();
        $parcellist[trackingno] = $row["TRACKINGNO"];
        $parcellist[status] = $row["STATUS"];
        $parcellist[name] = $row["NAME"];
        $parcellist[email] = $row["EMAIL"];
        array_push($response["parcel"], $parcellist);    
    }
    echo json_encode($response);
}else{
    echo "no data";
}
?>