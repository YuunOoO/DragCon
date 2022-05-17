<?php 
  $return["error"] = false;
  $return["message"] = "";

  $link = mysqli_connect('localhost','root','','flutter');
  //connecting to database server

  $val = isset($_POST["id"]) && isset($_POST["password"]) && isset($_POST["admin"]) && isset($_POST["email"]);

  if($val){
       //checking if there is POST data

       $id = $_POST["id"]; //grabing the data from headers
       $password = $_POST["password"];
       $admin = $_POST["admin"];
       $email = $_POST["email"];
       //validation name if there is no error before
       if($return["error"] == false && strlen($id) < 3){
           $return["error"] = true;
           $return["message"] = "Enter name up to 3 characters.";
       }
       //add more validations here
       //if there is no any error then ready for database write
       if($return["error"] == false){
            $id = mysqli_real_escape_string($link, $id);
            $password = mysqli_real_escape_string($link, $password); 
            $admin = mysqli_real_escape_string($link, $admin);
            $email = mysqli_real_escape_string($link, $email);
            //escape inverted comma query conflict from string
            $sql = "INSERT INTO users VALUES (DEFAULT,'$id','$password','$admin','$email',NULL)";
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