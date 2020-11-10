<?php
$servername = "localhost";
$username 	= "id15365845_parceldaddy";
$password 	= "_B+PtJ9q/MEemp/D";
$dbname 	= "id15365845_parcel_daddy";
$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>