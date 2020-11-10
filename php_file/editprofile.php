<?php
error_reporting(0);
include_once("dbconnect.php");

$email = $_POST['email'];
$name = $_POST['name'];
$newemail = $_POST['newemail'];
$phone = $_POST['phone'];

if (isset($name) && (!empty($name))){
    $sql = "UPDATE USER SET NAME = '$name' WHERE EMAIL = '$email'";
}else if (isset($newemail)&& (!empty($newemail))){
    $sql = "UPDATE USER SET EMAIL = '$newemail', VERIFY = '0' WHERE EMAIL = '$email'";
    $email = $newemail;
}else if (isset($phone) && (!empty($phone))){
    $sql = "UPDATE USER SET PHONE = '$phone' WHERE EMAIL = '$email'";
}

$usersql = "SELECT * FROM USER WHERE EMAIL = '$email'";

if ($conn->query($sql) === TRUE) {
    $result = $conn->query($usersql);
if ($result->num_rows > 0) {
        while ($row = $result ->fetch_assoc()){
        echo "success,".$row["NAME"].",".$row["EMAIL"].",".$row["PHONE"].",".$row["INASIS"].",".$row["LALUAN"];
        sendEmail($email);
        }
    }else{
        echo "failed,null,null,null,null,null";
    }
} else {
    echo "error";
}

function sendEmail($useremail) {
    $to      = $useremail; 
    $subject = 'Verification for Parcel Daddy';
    $message = 'https://parceldaddy2020.000webhostapp.com/php/verify.php?email='.$useremail; 
    $headers = 'From: noreply@parceldaddy.com' . "\r\n" . 
    'Reply-To: '.$useremail . "\r\n" . 
    'X-Mailer: PHP/' . phpversion(); 
    mail($to, $subject, $message, $headers); 
}
?>
