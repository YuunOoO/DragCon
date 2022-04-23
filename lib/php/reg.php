<?php
	$db = mysqli_connect('localhost','root','','flutter');
	if (!$db) {
		echo "Database connection faild";
	}

	$username = $_POST['name'];
	$password = $_POST['password'];
	$admin = $_POST['admin'];

	$sql = "SELECT id FROM users WHERE id = '".$username."'";

	$result = mysqli_query($db,$sql);
	$count = mysqli_num_rows($result);

	if ($count == 1) {
		echo json_encode("Error");
	}else{
		$insert = "INSERT INTO users(key_id,id,password,admin)VALUES(DEFAULT,'".$username."','".$password."','".$admin."')";
		$query = mysqli_query($db,$insert);
		if ($query) {
			echo json_encode("Success");
		}
	}

?>