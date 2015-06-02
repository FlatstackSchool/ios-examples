# HealthKit Project Example

Основная работа с HealthKit находится в классе HealthManager

 1. Запрос прав на запись/чтение. (реализована в методе `requestAccess`)
 2. Чтение данных (реализовано в методе `getUserData/readMostRecentSample`)
 3. Запись данных (метод `writeSample`)

Пример написан с помощью этой [статьи](http://www.raywenderlich.com/86336/ios-8-healthkit-swift-getting-started).
(**Некоторые методы в статье уже устарели на момент написания примера**)
