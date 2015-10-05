# [AFNetworking](https://github.com/MagicalPanda/MagicalRecord)

В данном примере добавлены примеры и рекомендованные форматы для выполнения GET, POST, PATCH или DELETE запросов. Также присутствуют примеры для создания сериализаторов для запросов и ответов в форматах JSON и XML. 

# APIManager

Класс является singleton. В нём мы создаем необходимый нам AFHTTPRequestOperationManager с настройками:
* requestSerializer(для сериализации нашего Dictionary в необходимый формат) и responseSerializer(для сериализации из NSData в формат Dictionary);
* baseURL (если мы имеем общий endpoint)
* securityPolicy (проводить ли валидацию ssl сертификатов или нет)

Далее в этом модуле добавляем расширения протоколов для AFHTTPRequestOperationManager и реализуем вызовы endpoint, где в success блоке мы возвращаем всегда operation и сериализованный объект, а в failure - operation, errorDescription с уже готовым описанием ошибки, errorType для распознания типа ошибки и isCancelled, если запрос был отменен. 

#ErrorHandler

С помощью этого класса мы определяем основные типы ошибок и возвращаем описание. К примеру, если у нас отсутствует интернет - возвращается сообщение Please check your internet connection и тип ошибки - NoInternetConnection. Реализованые основные ошибки:
* Отсутсвие интернет соединения
* Сервер не отвечает
* 401
* 404
* 422. Парсинг ошибок реализован для формата https://flatstack.atlassian.net/wiki/display/DEV/REST+API+design.

Если мы хотим обработать ошибку по своему, то есть метод customErrorHandler для этого.


```
    let errorHandler = ErrorHandler(failureRequestOperation: operation)
    errorHandler.customErrorHandler = {(operation, error) -> String? in

        switch (operation.response.statusCode)
        {
        case 422:
            return operation.responseString

        default:
            return nil
        }
    }
```

#CoreDataHelper

Используется по желанию, но может сократить количество кода и помочь избежать ошибок при сериализации и импорта данных. 

# Реализация endpoint для объектов

Рекомендуется создавать доступ к endpoint в таком порядке:

1. Создается общий метод для возврата стерилизованного объекта или описания ошибки в модуле APIManager для каждого отдельного объекта отдельным extension. 
2. В модуле конкретного объекта создавать уже нужный case для выполнения метода. 

Такой подход бывает необходим, когда например нужно в зависимости от случая подгружать данные по разному через один и тот же endpoint или же к примеру, для создания шаблонов нескольких вариантов обращения к endpoint зависимости от входных параметров.

Пример реализации можно увидеть в проекте:

1. В модуле ```APIManager``` реализован доступ к endpoint ```object.php``` и обработка ошибки.

```
//MARK: - Object
    extension AFHTTPRequestOperationManager {

        func OBJECT_GET(parameters: Dictionary<String, AnyObject>?, success: ((operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void)?, failure: ((operation: AFHTTPRequestOperation!, errorDescription: String!, errorType: ErrorType!, isCancelled: Bool) -> Void)?) -> AFHTTPRequestOperation? {
            
            let operation =
            self.GET("object.php", parameters: parameters, success: success) { (operation, error) -> Void in
                
                let errorHandler = ErrorHandler(failureRequestOperation: operation)
                errorHandler.customErrorHandler = {(operation, error) -> String? in

                    switch (operation.response.statusCode)
                    {
                    case 422:
                        return operation.responseString

                    default:
                        return nil
                    }
                }
                
                let errorData = errorHandler.errorData()
                failure?(operation: operation, errorDescription: errorData.description, errorType: errorData.type, isCancelled: errorHandler.isCancelled)
            }
            
            return operation
        }
    }
```

2. В модуле объекта ```AFObject```реализовано уже сохранение данных и передача конкретных параметров.

```
//MARK: - API
extension AFObject {
    
    enum TypeParameter {
        case JSON
        case XML
        case XMLCustom
        
        var operationManager : AFHTTPRequestOperationManager? {
            switch self {
            case .JSON :
                return APIManager.manager.operationManagerJSON
                
            case .XML :
                return APIManager.manager.operationManagerXML
                
            case .XMLCustom :
                return APIManager.manager.operationManagerXMLCustom
            }
        }
        
        var parameter : String! {
            switch self {
            case .JSON :
                return "json"
                
            case .XML, .XMLCustom :
                return "xml"
            }
        }
    }
    
    class func GET_OBJECT(type: TypeParameter, success: ((operation: AFHTTPRequestOperation!, object: AFObject!) -> Void)?, failure: ((operation: AFHTTPRequestOperation!, errorDescription: String!, errorType: ErrorType!, isCancelled: Bool) -> Void)?) -> AFHTTPRequestOperation?
    {
        let operationManager = type.operationManager!
        
        let parameters = ["type" : type.parameter]
        
        let operation =
        operationManager.OBJECT_GET(parameters, success: { (operation, responseObject) -> Void in
            
            var responseObjectUpdated: ResponseDictionary! = nil
            if let lResponseObject = responseObject as? ResponseDictionary {
                responseObjectUpdated = lResponseObject
                //if we using AFXMLParserResponseSerializer
            } else if let lResponseObject = responseObject as? NSXMLParser {
                let error: NSError? = nil
                responseObjectUpdated = (try! XMLReader.dictionaryForNSXMLParser(lResponseObject, options: UInt(XMLReaderOptionsResolveExternalEntities))) as! ResponseDictionary
                
                if let lError = error {
                    failure?(operation: operation, errorDescription: lError.localizedDescription, errorType: .Custom, isCancelled: false)
                    return
                }
            }
            let inputParams = FSSerializationInputParamaters(operation: operation!, responseObject: responseObjectUpdated, firstKey: "object")
            AFObject.fs_serializationObject(inputParams, success: { (operation, object) -> Void in
                success?(operation: operation, object: object as! AFObject)
            }, failure: failure)

        }, failure: failure)
        
        return operation
    }
}
```

# Тестирование на локальном сервере

Данный пример можно использовать для создания примеров запросов и ответов на php. Чтобы запустить быстро локальный сервер - скачиваем программу [MAMP](https://www.mamp.info/en/downloads/), где идет FREE и PRO вместе, просто во время установки отключаем PRO версию, так как FREE для поднятия только локальных серверов - что нам и нужно. После запуска заходим в настройки:
* Во вкладке ```Порты``` для Apache - 8888, для Ngnix - 7888, для MySQL - 8889.  
* Во вкладке ```PHP``` выбираем последнюю версию и она должна быть выше 5.0.
* Во вкладке ```Web Server``` выбираем Apache и настраиваем корень документа по желанию. Далее переходим в эту папку и складываем все из папки @Web->php. Переходим по адресу http://localhost:8888 и у нас должен получиться следующий список:

```
    Index of /

        * purchase/
        * requests/
```

Жмем ```OK``` и нажимаем ```Включить сервер```. Отлично, Apache и MySQL сервера запущены. Теперь нужно создать БД для сохранения данных. 

* Открываем phpMyAdmin по ссылке http://localhost:8888/MAMP/index.php?page=phpmyadmin&language=ru.
* Создаем БД с названием ```imagestest```. В этой БД будет храниться таблица с названием ```images_store```, где мы будем сохранять все новые картинки, отправленные через метод POST нашего приложения.
* Переходим в вкладку SQL и создаем новую таблицу. SQL запрос для этого лежит в ```@Web->MysSQL database.txt```. 

Жмем ```Вперед``` и должна создаться новая таблица. Теперь все готово для локального тестирования GET, POST, PATCH и DELETE запросов. При первом запуске наша БД пуста и нужно добавить хотя бы одну картинку через метод ```POST```. Далее мы уже можем получить ее из БД через метод ```GET``` по 0 id. Обновить на новую через метод ```PATCH``` по 0 id и получить через ```GET```, чтобы убедиться, что изменения были сохранены. И удалить ее через метод ```DELETE``` по 0 id. После удаления картинка по этому id больше никогда не будет доступна и всегда будет возвращать ошибку. 
