<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$amount = $_POST['amount'];
$paymentid; //taking from payment table adding to parcel table

$sqlinsert = "INSERT INTO PAYMENT(ORDERID ,BILLPLZID, AMOUNT, EMAIL) VALUES ('payment-with-CREDIT', 'payment-with-CREDIT', '$amount', '$email')";
        $conn->query($sqlinsert);
        $sql = "SELECT * FROM PAYMENT WHERE EMAIL = '$email' ORDER BY PAYMENTID DESC LIMIT 1";
        $result = $conn->query($sql);
        while($row = $result->fetch_assoc()){
            $paymentid = $row['PAYMENTID'];
        }
        $sqlupdate = "UPDATE PARCEL SET PAID = '1', PAYMENTID = '$paymentid' WHERE EMAIL = '$email' AND STATUS = 'Delivered' AND PAID = '0'";
        $conn->query($sqlupdate);

$sqlupdate = "UPDATE USER SET CREDIT = (CREDIT - $amount) WHERE EMAIL = '$email'";
if($conn->query($sqlupdate)){
    echo "success";
}else{
    echo "failed";
}
?>