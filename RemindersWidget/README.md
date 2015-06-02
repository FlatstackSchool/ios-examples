# Reminders App

* [Today Extension (виджет в центре уведомлений)][1] 
* [Reminders][2] 
* [WatchKit][3] 

## TodayExtension

Файлы Today Extension находится в папке Rems Widget

Ссылки по этой теме:  
 [Статья на русском языке про виджеты][4]

## Reminders

Запрос на доступ к Reminders: `viewDidLoad` в классе [CalendarsViewController][5] 

Взятие EKReminder's по календарю: `viewDidLoad` в классе [RemindersViewController][6]

Ссылки по этой теме:  
 [EventKit][7]

## WatchKit

Пример использования WatchKit. Включает в себя:
- [WatchKit App][8] ( Файлы в папке `App` ) 
- [Glances][9] ( `GlanceController` ) 
- [Notifications][10] ( ` NotificationController ` ) 

Ссылки:  
 [Apple Human Interface Guidelines][11]  
 [WatchKit FAQ][12]  

[1]:	#todayextension
[2]:	#reminders
[3]:	#watchkit
[4]:	http://habrahabr.ru/company/e-Legion/blog/225321/
[5]:	/RemindersWidget/CalendarsViewController.swift
[6]:	/RemindersWidget/RemindersViewController.swift
[7]:	http://www.raywenderlich.com/64513/cookbook-making-calendar-reminder
[8]:	https://developer.apple.com/library/ios/documentation/General/Conceptual/WatchKitProgrammingGuide/CreatingtheUserInterface.html#//apple_ref/doc/uid/TP40014969-CH4-SW1
[9]:	https://developer.apple.com/library/ios/documentation/General/Conceptual/WatchKitProgrammingGuide/ImplementingaGlance.html#//apple_ref/doc/uid/TP40014969-CH5-SW1
[10]:	https://developer.apple.com/library/ios/documentation/General/Conceptual/WatchKitProgrammingGuide/BasicSupport.html
[11]:	https://developer.apple.com/watch/human-interface-guidelines/
[12]:	http://www.raywenderlich.com/94672/watchkit-faq