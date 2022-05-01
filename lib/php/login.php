<?php 
	$db = mysqli_connect('localhost','root','','flutter');

	$username = $_POST['name'];
	$password = $_POST['password'];

	$sql = "SELECT * FROM users WHERE id = '".$username."' AND password = '".$password."'";
	$db_data = array();

	$result = mysqli_query($db,$sql);
	$count = mysqli_num_rows($result);

	$db_data = array();
	$result2 = $db->query($sql);
    	if($result2->num_rows > 0){
        	while($row = $result->fetch_assoc()){
           		 $db_data[] = $row;
        }
	

	if ($count == 1) {
		echo json_encode($db_data);
	}else{
		echo json_encode("Close");
	}

?>