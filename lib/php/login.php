<?php 
	$db = mysqli_connect('localhost','root','','flutter');

	$username = $_POST['name'];
	$password = $_POST['password'];

	$sql = "SELECT * FROM users WHERE id = '".$username."' AND password = '".$password."'";

	$result = mysqli_query($db,$sql);
	$count = mysqli_num_rows($result);

	if ($count == 1) {
		echo json_encode("Open");
	}else{
		echo json_encode("Close");
	}

?>