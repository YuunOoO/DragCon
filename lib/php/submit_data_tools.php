<?php
  header("Access-Control-Allow-Origin: *");
  $return["error"] = false;
  $return["message"] = "";

  $link = mysqli_connect('localhost','root','','flutter');
  $val = isset($_POST["type"]) && isset($_POST["amount"])
         && isset($_POST["mark"]) && isset($_POST["ekipa_id"]);

  if($val){
       $type = $_POST["type"]; 
       $amount = $_POST["amount"];
       $mark = $_POST["mark"];
       $ekipa_id = $_POST["ekipa_id"];
       if($return["error"] == false && strlen($type) < 3){
           $return["error"] = true;
           $return["message"] = "Narzędzie nie może mieć mniej niż 3 znaki";
       }

       if($return["error"] == false){
            $type = mysqli_real_escape_string($link, $type);
            $amount = mysqli_real_escape_string($link, $amount); 
            $mark = mysqli_real_escape_string($link, $mark);
            $ekipa_id = mysqli_real_escape_string($link, $ekipa_id);
            $sql = "INSERT INTO tools VALUES (DEFAULT,'$type','$amount','$mark','$ekipa_id')";

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
