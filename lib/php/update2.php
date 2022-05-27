<?php
    $conn = mysqli_connect('localhost','root','','flutter');
    $table = $_POST['table'];
    $ekipa_id = $_POST['ekipa_id'];
    $key_id = $_POST['key_id'];
	if($table == "users"){
	$sql="UPDATE users SET ekipa_id='$ekipa_id' WHERE key_id='$key_id' ;" ;
	}else{
		$sql="UPDATE tools SET ekipa_id='$ekipa_id' WHERE tool_id='$key_id' ;" ;
	}
    $result = $conn->query($sql);
    echo json_encode($result);
    echo json_encode($sql);
    $conn->close();
    return;
?>
