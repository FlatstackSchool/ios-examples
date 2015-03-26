# Compare [Magical Record](https://github.com/MagicalPanda/MagicalRecord) and [Mantle](https://github.com/Mantle/Mantle).

В данном примере проекта описывается пример сериализации из JSON и маппинга данных в _CoreData_ через библиотеки **Mantle** и **Magical Record**. В корне проекта есть папки с _.xcdatamodeld_ и _Entities_ для каждого библиотеки отдельно. С помощью препроцессорной константы ```TEST_MAGICAL_RECORD``` можно переключаться между их логикой работы (для включения _Magical Record_ установить значение _1_ и для _Mantle_ - _0_). В _AppDelegate_ происходит запись или обновление записей, в _MasterViewController_ отображаются данные и управление ими и в _DetailViewController_ отображается описание выбранного объекта.

# Magical Record

Для **Magical Record** сгенерированы 2 модели - **Person** и **Address**. Для сериализации присутствуют 4 разных JSON с одинаковыми ключами. **Attributes** у **Person** мапятся с помощью ключа **mappedKeyName**(может быть несколько и описывается, как **mappedKeyName.[0-9]**), где _value_ - ключ в самом JSON. Для **Enitites** у **Person** есть ключ **relatedByAttribute**, которое указывает, каким будет уникальное property у класса (может быть только одно) и по нему мы будем проверять _NSManagedObject_ объекты на уникальность. Для мапинга **relationship** **Address** у **Person** также используется ключ **mappedKeyName** и для указания уникальности объекта также по ключу **relatedByAttribute**.
В _AppDelegate_ создается стек ```[MagicalRecord setupAutoMigratingCoreDataStack]```б данные сохраняются и парсятся из четырех разных JSON:
* конкретного объекта (разница в значении по ключу _age_):

```- (void)johnSmith``` - _age_ = 25

```- (void)updatedJohnSmith``` - _age_ = 27

* массива из объектов (разница в структуре JSON):

```- (void)registerUsers``` - JSON с массивом объектов

```- (void)registerUsersViaOtherEndpoint``` - JSON из массива объектов по ключу _persons_

# Mantle

Для **Mantle** сгенерированы 4 модели - **Issue**, унаследованные от неё **Bug** и **Question**, **User**. 
Эта библиотека для сериализации и мапинга использует паттерн _Adapter_ и для сериализации используются классы **MTLJSONAdapter** и наследники от **MTLModel**, которые должны реализовать протокол **MTLJSONSerializing**. В этом протоколе для наследника от класса **MTLModel** мы описываем «карту» для сериализации методом:

```+ (NSDictionary *)JSONKeyPathsByPropertyKey```. 

Также мы можем указать, как конвертировать конкретное JSON значение с помощью **NSValueTransformer** и метода:

```+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key```

Класс, который должен быть создан через метод (это удобно, если мы имеем много наследников от одного абстрактного класса):

```+ (Class)classForParsingJSONDictionary:(NSDictionary *)JSONDictionary```

Используя **MTLJSONAdapter** делаем сериализацию данных: 
* для конкретного объекта:

```+ (id)modelOfClass:(Class)modelClass fromJSONDictionary:(NSDictionary *)JSONDictionary error:(NSError **)error```

* для массива объектов:

```+ (NSArray *)modelsOfClass:(Class)modelClass fromJSONArray:(NSArray *)JSONArray error:(NSError **)error```

Для получения **NSManagedObject** с помощью **MTLManagedObjectAdapter** нужно использовать метод:

```+ (id)managedObjectFromModel:(MTLModel<MTLManagedObjectSerializing> *)model insertingIntoContext:(NSManagedObjectContext *)context error:(NSError **)error```

С помощью отдельно написанного singleton **CoreDataManager** создается стек для _CoreData_ и главного контекста _managedObjectContext_. Пример сохранения данных описан в _AppDelegate_ в методе:

```- (void)registerIssues```