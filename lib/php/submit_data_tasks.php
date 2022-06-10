<?php 
  $return["error"] = false;
  $return["message"] = "";

  $link = mysqli_connect('localhost','root','','flutter');


  $val = isset($_POST["about"]) && isset($_POST["location"]) && isset($_POST["type"]) && isset($_POST["priority"]) && isset($_POST["ekipa_id"]);

  if($val){

       $about = $_POST["about"]; 
       $location = $_POST["location"];
       $priority = $_POST["priority"];
       $type = $_POST["type"]; 
       $ekipa_id = $_POST["ekipa_id"];

       if($return["error"] == false && strlen($about) < 3){
           $return["error"] = true;
           $return["message"] = "Enter name up to 3 characters.";
       }

       if($return["error"] == false){
            $about = mysqli_real_escape_string($link, $about);
            $location = mysqli_real_escape_string($link, $location); 
            $priority = mysqli_real_escape_string($link, $priority);
            $type = mysqli_real_escape_string($link, $type); 
            $ekipa_id = mysqli_real_escape_string($link, $ekipa_id);

            $sql = "INSERT INTO tasks VALUES (DEFAULT,'$about','$location',CURDATE(),CURTIME(),NULL,NULL,'$type','$priority','$ekipa_id')";

            $res = mysqli_query($link, $sql);
            if($res){
            }else{
                $return["error"] = true;
                $return["message"] = "Database error";
            }
       }
  }else{
      $return["error"] = true;
      $return["message"] = 'Send all parameters.';
  }
  mysqli_close($link); 
  header('Content-Type: application/json');
  echo json_encode($return);
?>