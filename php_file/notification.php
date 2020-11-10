<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$option = $_POST['option'];

if(isset($option) && $option == 'delete'){
    $sql = "UPDATE NOTIFICATION SET SHOWTOUSER = '0' WHERE EMAIL = '$email'";   
}else if(isset($option) && $option == 'recover'){
    $sql = "UPDATE NOTIFICATION SET SHOWTOUSER = '1' WHERE EMAIL = '$email'";
}else{
    $sql = "SELECT * FROM NOTIFICATION WHERE EMAIL = '$email' AND SHOWTOUSER = '1' ORDER BY NOTIFICATIONID DESC";   
}

$result = $conn->query($sql);

if(isset($option)){
    if ($conn->query($sql) === true){
        echo "success";
    } else{
        echo "failed";
    }
}else {
    if ($result->num_rows > 0) {
        $response["notification"] = array();
        while ($row = $result ->fetch_assoc()){
            $notificationlist[message] = $row["MESSAGE"];
            $notificationlist[date] = date_format(date_create($row["DATE"]), 'd/m/Y H:i:s');
            array_push($response["notification"], $notificationlist);   
        }
        echo json_encode($response);
    }else{
        echo "no data";
    }
}
?>