<?php 
  $return["error"] = false;
  $return["message"] = "";

  $link = mysqli_connect('localhost','root','','flutter');


  $val = isset($_POST["ekipa_id"]) && isset($_POST["user_count"]) && isset($_POST["name"]);

  if($val){

       $ekipa_id = $_POST["ekipa_id"]; 
       $user_count = $_POST["user_count"];
       $name = $_POST["name"];
      

       if($return["error"] == false && strlen($name) < 3){
           $return["error"] = true;
           $return["message"] = "Nazwa ekipy powinna zawierać więcej niż 3 znaki";
       }

       if($return["error"] == false){
            $ekipa_id = mysqli_real_escape_string($link, $ekipa_id);
            $user_count = mysqli_real_escape_string($link, $user_count); 
            $name = mysqli_real_escape_string($link, $name);


            $sql = "INSERT INTO tasks VALUES ('$ekipa_id','$user_count','$name')";

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