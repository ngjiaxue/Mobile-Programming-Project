<?php
error_reporting(0);
include_once("dbconnect.php");
$userid = $_GET['userid'];
$mobile = $_GET['mobile'];
$amount = $_GET['amount'];
$orderid = $_GET['orderid'];
$option = $_GET['option'];

$paymentid; //taking from payment table adding to parcel table 
$oldamount; //taking from user table adding to user table again to accumulate

$data = array(
    'id' =>  $_GET['billplz']['id'],
    'paid_at' => $_GET['billplz']['paid_at'] ,
    'paid' => $_GET['billplz']['paid'],
    'x_signature' => $_GET['billplz']['x_signature']
);

$paidstatus = $_GET['billplz']['paid'];
if ($paidstatus=="true"){
    $paidstatus = "Success";
}else{
    $paidstatus = "Failed";
}
$receiptid = $_GET['billplz']['id'];
$signing = '';
foreach ($data as $key => $value) {
    $signing.= 'billplz'.$key . $value;
    if ($key === 'paid') {
        break;
    } else {
        $signing .= '|';
    }
}
 
 
$signed= hash_hmac('sha256', $signing, 'S-DTJIAs2KjbSn_6pF2QM-_w');
if ($signed === $data['x_signature']) {

    if($paidstatus == "Success" && $option == "makepayment"){
        $sqlinsert = "INSERT INTO PAYMENT(ORDERID ,BILLPLZID, AMOUNT, EMAIL) VALUES ('$orderid', '$receiptid', '$amount', '$userid')";
        $conn->query($sqlinsert);
        $sql = "SELECT * FROM PAYMENT WHERE EMAIL = '$userid' ORDER BY PAYMENTID DESC LIMIT 1";
        $result = $conn->query($sql);
        while($row = $result->fetch_assoc()){
            $paymentid = $row['PAYMENTID'];
        }
        $sqlupdate = "UPDATE PARCEL SET PAID = '1', PAYMENTID = '$paymentid' WHERE EMAIL = '$userid' AND STATUS = 'Delivered' AND PAID = '0'";
        $conn->query($sqlupdate);
    }else if($paidstatus == "Success" && $option == "topupcredit"){
        $sqlinsert = "INSERT INTO CREDIT(ORDERID ,BILLPLZID, AMOUNT, EMAIL) VALUES ('$orderid', '$receiptid', '$amount', '$userid')";
        $conn->query($sqlinsert);
        $sql = "SELECT * FROM USER WHERE EMAIL = '$userid'";
        $result = $conn->query($sql);
        while($row = $result->fetch_assoc()){
            $oldamount = $row['CREDIT'];
        }
        $totalamount = $oldamount + $amount;
        $sqlupdate = "UPDATE USER SET CREDIT = '$totalamount' WHERE EMAIL = '$userid'";
        $conn->query($sqlupdate);
    }
        echo '<br><br><style>body{background-image: url("https://parceldaddy2020.000webhostapp.com/images/background.jpg");}</style><body><div><h2><br><br><center>Receipt</center></h1><table border=1 width=80% align=center><tr><td>Order id</td><td>'.$orderid.'</td></tr><tr><td>Receipt ID</td><td>'.$receiptid.'</td></tr><tr><td>Email to </td><td>'.$userid. ' </td></tr><td>Amount </td><td>RM '.$amount.'</td></tr><tr><td>Payment Status </td><td>'.$paidstatus.'</td></tr><tr><td>Date </td><td>'.date("d/m/Y").'</td></tr><tr><td>Time </td><td>'.date("h:i a").'</td></tr></table></div></body>';
    }else {
        echo 'Not Match!';
    }
?>