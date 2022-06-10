<?php 
  $return["error"] = false;
  $return["message"] = "";

  $link = mysqli_connect('localhost','root','','flutter');


  $val = isset($_POST["name"]);

  if($val){
       $name = $_POST["name"];
       if($return["error"] == false && strlen($name) < 3){
           $return["error"] = true;
           $return["message"] = "Nazwa ekipy powinna zawierać więcej niż 3 znaki";
       }
       if($return["error"] == false){
            $name = mysqli_real_escape_string($link, $name);
            $sql = "INSERT INTO ekipa VALUES (DEFAULT,0,'$name')";
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