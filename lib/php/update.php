<?php
    $conn = mysqli_connect('localhost','root','','flutter');
    $table = $_POST['table'];
    $task_id = $_POST['task_id'];
    $type = $_POST['type'];
$backlog = "Backlog";
$process = "In Process";
	
	if($type == $backlog  || $type == $process){
	$sql = "UPDATE tasks SET type = '$type',date_exec=NULL,time_exec=NULL WHERE task_id = '$task_id';" ;
	}else{
		$sql="UPDATE tasks SET type='$type',date_exec=curdate(),time_exec=curtime() WHERE task_id='$task_id' ;" ;
	}

    $result = $conn->query($sql);
    echo json_encode($result);
    echo json_encode($sql);
    $conn->close();
    
    return;

?>
