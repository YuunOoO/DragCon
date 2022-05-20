<?php 
  $return["error"] = false;
  $return["message"] = "";

  $link = mysqli_connect('localhost','root','','flutter');
  //connecting to database server

  $val = isset($_POST["type"]) && isset($_POST["amount"])
         && isset($_POST["mark"]);

  if($val){
       //checking if there is POST data

       $type = $_POST["type"]; //grabing the data from headers
       $amount = $_POST["amount"];
       $mark = $_POST["mark"];

       if($return["error"] == false && strlen($type) < 3){
           $return["error"] = true;
           $return["message"] = "Enter name up to 3 characters.";
       }
       //add more validations here
       //if there is no any error then ready for database write
       if($return["error"] == false){
            $type = mysqli_real_escape_string($link, $type);
            $amount = mysqli_real_escape_string($link, $amount); 
            $mark = mysqli_real_escape_string($link, $mark);
            //escape inverted comma query conflict from string
            $sql = "INSERT INTO tools VALUES (DEFAULT,'$type','$amount','$mark',NULL)";

            $res = mysqli_query($link, $sql);
            if($res){
                //write success
            }else{
                $return["error"] = true;
                $return["message"] = "Database error";
            }
       }
  }else{
      $return["error"] = true;
      $return["message"] = 'Send all parameters.';
  }
  mysqli_close($link); //close mysqli
  header('Content-Type: application/json');
  // tell browser that its a json data
  echo json_encode($return);
  //converting array to JSON string
?>
