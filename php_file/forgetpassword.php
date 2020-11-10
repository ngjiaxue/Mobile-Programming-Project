<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$password = sha1($_POST['password']);

$sql = "SELECT * FROM USER WHERE EMAIL = '$email' AND VERIFY ='1'";

$result = $conn->query($sql);
if ($result->num_rows > 0) {
     sendEmail($email, $password);
     echo "success";
}else{
    echo "failed";
    
}


function sendEmail($useremail,$userpassword) {
    $to      = $useremail; 
    $subject = 'Verification for Reset Password'; 
    $message = 'https://parceldaddy2020.000webhostapp.com/php/resetpasswordverify.php?email='.$useremail.'&password='.$userpassword; 
    $headers = 'From: noreply@parceldaddy.com' . "\r\n" . 
    'Reply-To: '.$useremail . "\r\n" . 
    'X-Mailer: PHP/' . phpversion(); 
    mail($to, $subject, $message, $headers); 
}
?>