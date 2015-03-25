# Local Notification Example

Пример локальных уведомлений в приложении. Включает в себя:

 1. Регистрация локальных нотификаций. (реализована в методе ```registerUserNotificationSettings:```)
 2. Регистрация локальных нотификаций с действиями. (реализована в методе ```registrActionNotif:```)
 3. Отправка локальных нотификаций по таймеру. (методы ```addNotification:``` и ```addActionNotif:```)
 4. Обработка открытия приложения из уведомления. (метод ```application:didReceiveLocalNotification:```)
 5. Обработка нажатия кнопки на нотификации. (методы ```application:handleActionWithIdentifier:```)
 6. Отмена локальных уведомлений из приложения. (пример в методе ```viewDidLoad``` в классе ```ViewController```)

Пример написан по [этой статье](http://www.appcoda.com/local-notifications-ios8/).
