<?php 
  $return["error"] = false;
  $return["message"] = "";

  $link = mysqli_connect('localhost','root','','flutter');


  $val = isset($_POST["id"]) && isset($_POST["password"]) && isset($_POST["admin"]) && isset($_POST["email"]) && isset($_POST["ekipa_id"]);

  if($val){


       $id = $_POST["id"]; 
       $password = $_POST["password"];
       $admin = $_POST["admin"];
       $email = $_POST["email"];
       $ekipa_id = $_POST["ekipa_id"];

       if($return["error"] == false && strlen($id) < 3){
           $return["error"] = true;
           $return["message"] = "Enter name up to 3 characters.";
       }
       if($return["error"] == false){
            $id = mysqli_real_escape_string($link, $id);
            $password = mysqli_real_escape_string($link, $password); 
            $admin = mysqli_real_escape_string($link, $admin);
            $email = mysqli_real_escape_string($link, $email);
            $ekipa_id = mysqli_real_escape_string($link, $ekipa_id);
            $sql = "INSERT INTO users VALUES (DEFAULT,'$id','$password','$admin','$email','$ekipa_id')";

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
  mysqli_close($link); 
  header('Content-Type: application/json');
  echo json_encode($return);
?>