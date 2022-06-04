<?php 
  $return["error"] = false;
  $return["message"] = "";

  $link = mysqli_connect('localhost','root','','flutter');
  //connecting to database server

  $val = isset($_POST["about"]) && isset($_POST["location"]) && isset($_POST["type"]) && isset($_POST["priority"]) && isset($_POST["ekipa_id"]);

  if($val){
       //checking if there is POST data
//grabing the data from headers
       $about = $_POST["about"]; 
       $location = $_POST["location"];
       $priority = $_POST["priority"];
       $type = $_POST["type"]; 
       $ekipa_id = $_POST["ekipa_id"];
       //validation name if there is no error before
       if($return["error"] == false && strlen($about) < 3){
           $return["error"] = true;
           $return["message"] = "Enter name up to 3 characters.";
       }
       //add more validations here
       //if there is no any error then ready for database write
       if($return["error"] == false){
            $about = mysqli_real_escape_string($link, $about);
            $location = mysqli_real_escape_string($link, $location); 
            $priority = mysqli_real_escape_string($link, $priority);
            $type = mysqli_real_escape_string($link, $type); 
            $ekipa_id = mysqli_real_escape_string($link, $ekipa_id);
            //escape inverted comma query conflict from string
            $sql = "INSERT INTO tasks VALUES (DEFAULT,'$about','$location',CURDATE(),CURTIME(),NULL,NULL,'$type','$priority','$ekipa_id')";
            //student_id is with AUTO_INCREMENT, so its value will increase automatically
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