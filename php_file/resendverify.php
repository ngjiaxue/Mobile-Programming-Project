<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];

    $to      = $email; 
    $subject = 'Verification for Parcel Daddy';
    $message = 'https://parceldaddy2020.000webhostapp.com/php/verify.php?email='.$email; 
    $headers = 'From: noreply@parceldaddy.com' . "\r\n" . 
    'Reply-To: '.$email . "\r\n" . 
    'X-Mailer: PHP/' . phpversion(); 
    mail($to, $subject, $message, $headers); 
?>