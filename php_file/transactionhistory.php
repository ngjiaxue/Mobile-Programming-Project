<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];
$option = $_POST['option'];
$date = $_POST['date'];

if(isset($date)){
    $sql = "SELECT * FROM PARCEL WHERE EMAIL = '$email' AND DATE = '$date' ORDER BY PARCELID DESC";
}else{
    if($option == "topupcredit"){
        $sql = "SELECT * FROM CREDIT WHERE EMAIL = '$email' ORDER BY CREDITID DESC";
    }else{
        $sql = "SELECT * FROM PAYMENT WHERE EMAIL = '$email' ORDER BY PAYMENTID DESC";
}
}

$result = $conn->query($sql);

if(isset($date)){
    if ($result->num_rows > 0) {
        while ($row = $result ->fetch_assoc()){
            echo $row['TRACKINGNO'];
            echo ",";
        }
    }else{
        echo "no data";
    }    
}else{
    if ($result->num_rows > 0) {
        $response["transactionhistory"] = array();
        while ($row = $result ->fetch_assoc()){
            $transactionhistorylist = array();
            $transactionhistorylist[orderid] = $row["ORDERID"];
            $transactionhistorylist[billplzid] = $row["BILLPLZID"];
            $transactionhistorylist[amount] = $row["AMOUNT"];
            $transactionhistorylist[date] = date_format(date_create($row["DATE"]), 'd/m/Y H:i:s');
            array_push($response["transactionhistory"], $transactionhistorylist);    
        }
        echo json_encode($response);
    }else{
        echo "no data";
    }
}
?>