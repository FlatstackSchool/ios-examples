<?php
    
    $type = $_GET['type'];
    if(isset($type)) {
        if ($type == 'json') {
            header('Content-Type: application/json');
            
            $arr = ['object'=>['id'=>0,'attributes'=>['a'=>1,'b'=>2,'c'=>3,'d'=>4,'e'=>5]]];
            echo json_encode($arr);
            
            return;
        }
        elseif ($type == 'xml') {
            header('Content-Type: application/xml');
            
            $string = '<object><id>1</id><attributes><a><b><c>text</c><c>stuff</c></b><d><c>code</c></d></a></attributes></object>';
            
            $xml = new SimpleXMLElement($string);
            
            echo $xml->asXML();
            
            return;
        } elseif ($type == 'soap') {
            
            header('Content-Type: application/soap+xml');
            
            echo ("");
        }
    }
    
    http_response_code(422);
    die ("Parameter \"type\" is required");
?>
