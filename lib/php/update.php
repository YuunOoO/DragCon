<?php
    $conn = mysqli_connect('localhost','root','','flutter');
 
    $table = $_POST['table'];
    $task_id = $_POST['task_id'];
    $type = $_POST['type'];
 
    $sql = "UPDATE tasks SET type = '$type' WHERE task_id = '$task_id' ;";
    $result = $conn->query($sql);
    echo json_encode($result);
    echo json_encode($sql);
    $conn->close();
    
    return;

?>
