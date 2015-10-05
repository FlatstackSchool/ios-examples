<?php
    
    class Image
    {
        private $dbh;
        
        function __construct()
        {
            $user = "root";
            $password = "root";
            $dbname = "imagestest";
            
            //создаем соединение к нашей бд
            $this->dbh = new mysqli("localhost", $user, $password, $dbname);
            
            $mysqliErrorCode = mysqli_connect_errno();
            if($mysqliErrorCode != UPLOAD_ERR_OK) {
                //если не удалось подключиться к бд, отправляем 500 ошибку с номером кода
                http_response_code(500);
                die ("Unable to connect host with error = ".$mysqliErrorCode."");
            }
        }
        
        function __destruct()
        {
            $this->dbh->close();
        }
        
        //методы
        public function try_get($id)
        {
            //формируем запрос для получения из бд
            $query = "SELECT id, bin_data, filename, filetype FROM images_store WHERE id=".$id." ORDER BY filename ASC LIMIT 1";
            if ($result = $this->dbh->query($query)) {
                
                if (mysqli_num_rows($result) == 0) {
                    
                    return false;
                    
                } else {
                    //если запрос выполнен, то формируем JSON ответ с новым объектом
                    while( $row = $result->fetch_array(MYSQLI_ASSOC) ){
                        
                        return Image::json_format($row['id'], $row['filename'], $row['filetype'], $row['bin_data']);
                    }
                }
                
                $result->close();
                
            } else {
                //если не удалось выполнить запрос - отправляем 500 ошибку
                http_response_code(500);
                $result->close();
                die ("Unable to perform SQL select");
            }
        }
        
        public function try_post($image_data)
        {
            //получаем метаданные
            $tmp_name = $image_data['tmp_name'];
            $filetype = $image_data['type'];
            $filename = $_POST['name'];
            
            if (isset($filetype) == false || $filetype == null || is_null($filetype)) {
                //если mime тип не указан, то пытаемся его получить сами
                $filetype = mime_content_type($tmp_name);
            }
            
            if (isset($filename) == false || $filename == null || is_null($filename)) {
                $filename = $image_data['name'];
                if ($filename == null) {
                    //если filename не указан, то генерируем сами
                    $filename = random_string(50);
                }
            }
            
            //загружаем картинку по временному пути
            $fp      = fopen($tmp_name, 'r');
            $content = fread($fp, filesize($tmp_name));
            $content = addslashes($content);
            fclose($fp);
            
            //запрос для добавления картинки
            $query = "INSERT INTO images_store (bin_data, filename, filetype) VALUES ('".$content."','".$filename."','".$filetype."')";
            
            //подготовка запроса и получаем подготовленное выражение
            $stmt = $this->dbh->prepare($query);
            
            if($stmt == false) {
                //если запрос плохой, отправляем 500 ошибку и закрвываем соединения
                http_response_code(500);
                $stmt->close();
                die ("Unable to perform SQL insert");
            }
            
            //исполняем запрос, получаем новый id и закрываем поток
            $stmt->execute();
            $id = $stmt->insert_id;
            $stmt->close();
            
            $fp      = fopen($tmp_name, 'r');
            $content = fread($fp, filesize($tmp_name));
            fclose($fp);
            
           return Image::json_format($id, $filename, $filetype, $content);
        }
        
        public function try_patch($id, $filename, $filetype, $content)
        {
            $result = $this->try_get($id);
            if ($result == null || is_null($result)) {
                die (send422EntityNotFound());
            }
            
            //получаем метаданные
            if ($filetype == null || is_null($filetype)) {
                $filetype = $result['filetype'];
            }
            
            if ($filename == null || is_null($filename)) {
                $filename = $result['filename'];
            }
            
            if (is_null($content) == false) {
                $content = base64_decode($content);
            } else {
                $content = $result['bin_data'];
            }
            
            //запрос для добавления картинки
            $query = "UPDATE images_store SET bin_data = '".$content."', filename = '".$filename."', filetype = '".$filetype."' WHERE id = ".$id."";
            
            //подготовка запроса и получаем подготовленное выражение
            $stmt = $this->dbh->prepare($query);
            
            if($stmt == false) {
                //если запрос плохой, отправляем 500 ошибку и закрвываем соединения
                http_response_code(500);
                $stmt->close();
                die ("Unable to perform SQL update");
            }
            
            //исполняем запрос, получаем новый id и закрываем поток
            $stmt->execute();
            $stmt->close();
            
            return Image::json_format($id, $filename, $filetype, $content);
        }
        
        public function try_delete($id)
        {
            $result = $this->try_get($id);
            
            if ($result == null) {
                die (send422EntityNotFound());
            }
            
            //запрос для добавления картинки
            $query = "DELETE FROM images_store WHERE id = ".$id."";
            
            //подготовка запроса и получаем подготовленное выражение
            $stmt = $this->dbh->prepare($query);
            
            if($stmt == false) {
                //если запрос плохой, отправляем 500 ошибку и закрвываем соединения
                http_response_code(500);
                $stmt->close();
                die ("Unable to perform SQL delete");
            }
            
            //исполняем запрос, получаем новый id и закрываем поток
            $stmt->execute();
            $stmt->close();
            
            $arr = ['result'=>['status'=>200,'message'=>'OK']];
            return json_encode($arr);
        }
        
        //отправка картинки
        static public function json_format($id, $filename, $filetype, $bin_data)
        {
            $arr = ['image'=>['id'=>(int)$id,'filename'=>$filename,'filetype'=>$filetype,'data'=>base64_encode($bin_data)]];
            return json_encode($arr);
        }
    }
    
    //----вспомагательные функции
    //для отправки 422 ошибки
    function send422ValidationError($field) {
        
        header('Content-Type: application/json');
        http_response_code(422);
        
        $arr = ['error'=>['status'=>422,'error'=>'Validation Error','validations'=>[$field=>["can't be blank"]]]];
        return json_encode($arr);
    }
    
    function send422EntityNotFound() {
        
        header('Content-Type: application/json');
        http_response_code(422);
        
        $arr = ['error'=>['status'=>422,'error'=>'Unprocessable Entity']];
        return json_encode($arr);
    }
    
    function send200EntityOK($object) {
        
        header('Content-Type: application/json');
        http_response_code(200);
        
        echo $object;
    }
    
    //случайная строка
    function random_string($length) {
        $key = '';
        $keys = array_merge(range(0, 9), range('a', 'z'));
        
        for ($i = 0; $i < $length; $i++) {
            $key .= $keys[array_rand($keys)];
        }
        
        return $key;
    }
    
    
    //----начало кода
    
    $method = $_SERVER['REQUEST_METHOD'];
    
    $image = new Image();
    
    if ($method === 'GET') {
        
        $id_key = "id";
        
        //проверям id параметр
        $id = $_GET[$id_key];
        
        http_response_code(500);
        if ($id == null) {
            //если его нет, отправляем 422 ошибку
            die (send422ValidationError($id_key));
        }
        
        $result = $image->try_get($id);
        if ($result == false) {
            die (send422EntityNotFound());
        } else {
            die (send200EntityOK($result));
        }
        
    } elseif ($method === 'POST') {
        
        $image_key = "image";
        
        //получаем информацию о картинке
        $image_data = $_FILES[$image_key];
        
        //проверка, была ли ошибка при загрузке картинки
        $downloadingError = $image_data['error'];
        
        if ($downloadingError == UPLOAD_ERR_NO_FILE || is_null($image_data)) {
            //если ее нет, отправляем 422 ошибку
            die (send422ValidationError($image_key));
        }
        
        if ($downloadingError > 0) {
            //если загрузилось с ошибкой - отправляем ошибку 500 с кодом ошибки
            http_response_code(500);
            die ("Failed downloading image ".$filename." with error ".$downloadingError."");
        }
        
        $result = $image->try_post($image_data);
        send200EntityOK($result);

    } elseif ($method === 'PATCH') {
        
        $text = file_get_contents("php://input");
        $array = json_decode($text, true);
        
        $result = $image->try_patch($array['id'], $array['name'], $array['type'], $array['image']);
        send200EntityOK($result);
        
    } elseif ($method === 'DELETE') {
        
        $id_key = "id";
        $id = $_GET[$id_key];
        
        if ($id == null) {
            //если его нет, отправляем 422 ошибку
            die (send422ValidationError($id_key));
        }
        
        $result = $image->try_delete($id);
        send200EntityOK($result);
        
    } else {
        http_response_code(404);
        die ("Not found");
    }
?>
