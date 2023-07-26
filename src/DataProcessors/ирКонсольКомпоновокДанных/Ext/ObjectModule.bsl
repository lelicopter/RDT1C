﻿//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирКлиент Экспорт;

Перем мПлатформа Экспорт;
Перем мРежимРедактора Экспорт;
Перем мИмяРедактируемойСхемы Экспорт;
Перем мВнешниеНаборыДанных Экспорт;
// только для передачи схемы как параметра при открытии формы
Перем мСхемаКомпоновкиДанных Экспорт;
Перем мМакетКомпоновкиДанных Экспорт; 
Перем мМенеджерВременныхТаблиц Экспорт;
Перем _мЗапроситьОткрытиеКонсолиЗапросовПриОткрытии Экспорт;

Функция РеквизитыДляСервера(Параметры) Экспорт  
	
	Результат = ирОбщий.РеквизитыОбработкиЛкс(ЭтотОбъект,, Истина);
	Возврат Результат;
	
КонецФункции

Функция ВывестиРезультат(Параметры) Экспорт 
	КоллекцияВывода = Параметры.КоллекцияВывода;
	МакетКомпоновкиДанных = Параметры.МакетКомпоновкиДанных;
	СтруктураВнешниеНаборыДанных = Параметры.СтруктураВнешниеНаборыДанных;
	МенеджерВременныхТаблиц = Параметры.МенеджерВременныхТаблиц;
	ЛиОтладка = Параметры.ЛиОтладка;
	Предпросмотр = Параметры.Предпросмотр;
	АдресДанныхРасшифровки = Параметры.АдресДанныхРасшифровки;
	мЭлементыРезультата = Параметры.мЭлементыРезультата;
	ВыполнятьПредварительныйЗапрос = Параметры.ВыполнятьПредварительныйЗапрос;
	РезультатВывода = ирОбщий.СкомпоноватьОтчетВКонсолиЛкс(КоллекцияВывода, МакетКомпоновкиДанных, СтруктураВнешниеНаборыДанных, Автофиксация, Параметры.МодальныйРежим, ЛиОтладка, АдресДанныхРасшифровки,
		ВыполнятьНаСервере И Не Предпросмотр, мЭлементыРезультата, ВыполнятьПредварительныйЗапрос, МенеджерВременныхТаблиц, ДлительностьВыполненияМакета);
	Результат = Новый Структура;
	Результат.Вставить("Результат", РезультатВывода);
	Результат.Вставить("АдресДанныхРасшифровки", АдресДанныхРасшифровки);
	Результат.Вставить("КоллекцияВывода", КоллекцияВывода);
	Результат.Вставить("Предпросмотр", Предпросмотр);
	Результат.Вставить("ИндексТекущейСтроки", Параметры.ИндексТекущейСтроки);
	Результат.Вставить("ИмяЭУВывода", Параметры.ИмяЭУВывода);
	Возврат Результат;
КонецФункции

#Если Клиент Тогда

Функция ОткрытьПоОбъектуМетаданных(ПолноеИмяМД, Отбор = Неопределено) Экспорт
	
	мСхемаКомпоновкиДанных = ирОбщий.СоздатьСхемуКомпоновкиПоОбъектуМДЛкс(ПолноеИмяМД);
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(мСхемаКомпоновкиДанных));
	КорневойТип = ирОбщий.ПервыйФрагментЛкс(ПолноеИмяМД);
	НаборПолейВыбора = Новый Массив();
	НаборПолейПорядка = Новый Массив();
	МассивФрагментов = ирОбщий.СтрРазделитьЛкс(ПолноеИмяМД);
	ОбъектМД = ирКэш.ОбъектМДПоПолномуИмениЛкс(ПолноеИмяМД);
	#Если Сервер И Не Сервер Тогда
		ОбъектМД = Метаданные.ВнешниеИсточникиДанных.ВнешнийИсточникДанных1.Таблицы.Таблица1;
	#КонецЕсли
	Если Истина
		И МассивФрагментов.Количество() = 3
		И МассивФрагментов[2] = "Изменения"
	Тогда
		Построитель = Новый ПостроительЗапроса("ВЫБРАТЬ Т.* ИЗ " + ПолноеИмяМД + " КАК Т");
		Построитель.ЗаполнитьНастройки();
		Для Каждого ДоступноеПоле Из Построитель.ДоступныеПоля Цикл
			НаборПолейВыбора.Добавить(ДоступноеПоле.ПутьКДанным);
			НаборПолейПорядка.Добавить(ДоступноеПоле.ПутьКДанным);
		КонецЦикла; 
	ИначеЕсли ирОбщий.ЛиМетаданныеСсылочногоОбъектаЛкс(ОбъектМД) Тогда
		НаборПолейВыбора.Добавить("Ссылка");
		НаборПолейПорядка.Добавить("Ссылка");
	ИначеЕсли ирОбщий.ЛиМетаданныеРегистраЛкс(ОбъектМД) Тогда
		НаборЗаписей = ирОбщий.ОбъектБДПоКлючуЛкс(ирКэш.ИмяТаблицыИзМетаданныхЛкс(ПолноеИмяМД),,, Ложь).Методы;
		Для Каждого ЭлементОтбора Из НаборЗаписей.Отбор Цикл
			НаборПолейВыбора.Добавить(ЭлементОтбора.ПутьКДанным);
			НаборПолейПорядка.Добавить(ЭлементОтбора.ПутьКДанным);
		КонецЦикла; 
	КонецЕсли; 
	Для Каждого Поле Из НаборПолейВыбора Цикл
		ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(КомпоновщикНастроек.Настройки.Выбор, Поле);
	КонецЦикла; 
	Для Каждого Поле Из НаборПолейПорядка Цикл
		ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(КомпоновщикНастроек.Настройки.Порядок, Поле);
	КонецЦикла; 
	ирОбщий.НайтиДобавитьЭлементСтруктурыГруппировкаКомпоновкиЛкс(КомпоновщикНастроек.Настройки.Структура);
	Если Отбор <> Неопределено Тогда
		Для Каждого КлючИЗначение Из Отбор Цикл
			ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(КомпоновщикНастроек.Настройки.Отбор, КлючИЗначение.Ключ, КлючИЗначение.Значение);
		КонецЦикла; 
	КонецЕсли; 
	Форма = ЭтотОбъект.ПолучитьФорму();
	Форма.Открыть();
	Возврат Форма;
	
КонецФункции 

Функция ОткрытьПоТаблицеЗначений(Знач ТаблицаЗначений, Знач НастройкаКомпоновки = Неопределено) Экспорт
	
	мСхемаКомпоновкиДанных = ирОбщий.СоздатьСхемуПоТаблицамЗначенийЛкс(Новый Структура("Основной", ТаблицаЗначений),,, Истина);
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(мСхемаКомпоновкиДанных));
	Если НастройкаКомпоновки <> Неопределено Тогда
		КомпоновщикНастроек.ЗагрузитьНастройки(НастройкаКомпоновки);
	Иначе
		ирОбщий.УстановитьПараметрыВыводаКомпоновкиПоУмолчаниюЛкс(КомпоновщикНастроек.Настройки);
		Для Каждого Колонка Из ТаблицаЗначений.Колонки Цикл
			ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(КомпоновщикНастроек.Настройки.Выбор, Колонка.Имя);
		КонецЦикла;
	КонецЕсли;
	мВнешниеНаборыДанных = Новый Структура("Основной", ТаблицаЗначений);
	ирОбщий.НайтиДобавитьЭлементСтруктурыГруппировкаКомпоновкиЛкс(КомпоновщикНастроек.Настройки.Структура);
	Форма = ЭтотОбъект.ПолучитьФорму();
	Форма.Открыть();
	Возврат Форма;
	
КонецФункции 

Функция ОткрытьПоЗапросу(Знач Запрос, Отбор = Неопределено) Экспорт
	
	мСхемаКомпоновкиДанных = ирОбщий.СоздатьСхемуКомпоновкиПоЗапросу(Запрос);
	Попытка
		КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(мСхемаКомпоновкиДанных));
	Исключение
		ирОбщий.СообщитьЛкс(ОписаниеОшибки());
	КонецПопытки; 
	Для Каждого ДоступноеПоле Из КомпоновщикНастроек.Настройки.ДоступныеПоляВыбора.Элементы Цикл
		Если Не ДоступноеПоле.Папка Тогда
			ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(КомпоновщикНастроек.Настройки.Выбор, ДоступноеПоле.Поле);
			ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(КомпоновщикНастроек.Настройки.Порядок, ДоступноеПоле.Поле);
		КонецЕсли; 
	КонецЦикла;
	//Для Каждого ЗначениеПараметра Из КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы Цикл
	//	ЗначениеПараметра.Использование = Истина;
	//КонецЦикла;
	Если Отбор <> Неопределено Тогда
		Для Каждого КлючИЗначение Из Отбор Цикл
			ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(КомпоновщикНастроек.Настройки.Отбор, КлючИЗначение.Ключ, КлючИЗначение.Значение);
		КонецЦикла; 
	КонецЕсли; 
	ирОбщий.НайтиДобавитьЭлементСтруктурыГруппировкаКомпоновкиЛкс(КомпоновщикНастроек.Настройки.Структура);
	ирОбщий.УстановитьПараметрыВыводаКомпоновкиПоУмолчаниюЛкс(КомпоновщикНастроек.Настройки);
	Форма = ЭтотОбъект.ПолучитьФорму();
	Форма.Открыть();
	Возврат Форма;
	
КонецФункции 

Процедура ОткрытьПоТабличномуПолю(Знач ТабличноеПоле, Знач СхемаКомпоновки = Неопределено, Знач НастройкаКомпоновки = Неопределено, Знач ВнешниеНаборыДанных = Неопределено) Экспорт
	
	Если НастройкаКомпоновки = Неопределено Тогда
		НастройкаКомпоновки = Новый НастройкиКомпоновкиДанных;
		ирОбщий.УстановитьПараметрыВыводаКомпоновкиПоУмолчаниюЛкс(НастройкаКомпоновки);
	КонецЕсли; 
	Если ВнешниеНаборыДанных = Неопределено Тогда
		ДанныеТабличногоПоля = ТабличноеПоле.Значение;
		Если ТипЗнч(ДанныеТабличногоПоля) <> Тип("ТаблицаЗначений") Тогда
			ДанныеТабличногоПоля = ДанныеТабличногоПоля.Выгрузить();
			ирОбщий.ТрансформироватьОтборВОтборКомпоновкиЛкс(НастройкаКомпоновки.Отбор, ТабличноеПоле.ОтборСтрок);
		КонецЕсли; 
		ВнешниеНаборыДанных = Новый Структура("Основной", ДанныеТабличногоПоля);
	КонецЕсли;
	Если СхемаКомпоновки = Неопределено Тогда
		мСхемаКомпоновкиДанных = ирОбщий.СоздатьСхемуПоТаблицамЗначенийЛкс(ВнешниеНаборыДанных,,,,,, Истина);
	Иначе
		мСхемаКомпоновкиДанных = СхемаКомпоновки;
	КонецЕсли; 
	Попытка
		КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(мСхемаКомпоновкиДанных));
	Исключение
		ирОбщий.СообщитьЛкс(ОписаниеОшибки());
	КонецПопытки; 
	КомпоновщикНастроек.ЗагрузитьНастройки(НастройкаКомпоновки);
	Если КомпоновщикНастроек.Настройки.Структура.Количество() = 0 Тогда
		ирОбщий.НайтиДобавитьЭлементСтруктурыГруппировкаКомпоновкиЛкс(КомпоновщикНастроек.Настройки.Структура);
	КонецЕсли; 
	Если КомпоновщикНастроек.Настройки.Выбор.Элементы.Количество() = 0 Тогда
		Для Каждого КолонкаТП Из ТабличноеПоле.Колонки Цикл
			ПутьКДаннымКолонки = ирОбщий.ПутьКДаннымКолонкиТабличногоПоляЛкс(ТабличноеПоле, КолонкаТП);
			Если ЗначениеЗаполнено(ПутьКДаннымКолонки) Тогда
				ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(КомпоновщикНастроек.Настройки.Выбор, ПутьКДаннымКолонки);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
    ОткрытьДляОтладки(мСхемаКомпоновкиДанных, КомпоновщикНастроек.Настройки, ВнешниеНаборыДанных);
	
КонецПроцедуры

Функция ОткрытьДляОтладки(Знач СхемаИлиМакетКомпоновки = Неопределено, Знач Настройки = Неопределено, Знач ВнешниеНаборыДанных = Неопределено,
	Модально = Ложь, АктивироватьСтраницуНастроек = Неопределено, СразуВыполнитьКомпоновку = Ложь, МенеджерВременныхТаблиц = Неопределено) Экспорт
	
	мИмяРедактируемойСхемы = Неопределено;
	Форма = ЭтотОбъект.ПолучитьФорму();
	Форма.АктивироватьСтраницуНастроекПриОткрытии = АктивироватьСтраницуНастроек;
	Форма.ВыполнитьКомпоновкуПриОткрытии = СразуВыполнитьКомпоновку;
	Если Настройки <> Неопределено Тогда
		ирОбщий.ВосстановитьОтборыКомпоновкиПослеДесериализацииЛкс(Настройки);
		КомпоновщикНастроек.ЗагрузитьНастройки(Настройки);
	КонецЕсли;
	Если ТипЗнч(СхемаИлиМакетКомпоновки) = Тип("СхемаКомпоновкиДанных") Тогда
		мСхемаКомпоновкиДанных = ирОбщий.КопияОбъектаЛкс(СхемаИлиМакетКомпоновки);
		//Если Настройки <> Неопределено Тогда
		//	// Делаем очевидным использование скрытых значений параметров https://partners.v8.1c.ru/forum/t/690982/m/691114
		//	Для Каждого ПараметрСхемы Из мСхемаКомпоновкиДанных.Параметры Цикл
		//		Если Не ПараметрСхемы.ОграничениеИспользования Тогда 
		//			Продолжить;
		//		КонецЕсли;
		//		ЗначениеПараметра = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных(ПараметрСхемы.Имя));
		//		Если Истина
		//			И ЗначениеПараметра <> Неопределено
		//			И ЗначениеПараметра.Использование
		//		Тогда 
		//			//ПараметрСхемы.ОграничениеИспользования = Ложь;
		//			//ирОбщий.СообщитьЛкс("Для используемого в настройках скрытого параметра """ + ПараметрСхемы.Имя + """ выполнено снятие ограничения использования в схеме компоновки.");
		//			ирОбщий.СообщитьЛкс("В настройках компоновки для недоступного пользователю параметра """ + ПараметрСхемы.Имя + """ обнаружено использование значения.");
		//		КонецЕсли;
		//	КонецЦикла;
		//КонецЕсли;
		Попытка
			КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(мСхемаКомпоновкиДанных));
		Исключение
			ирОбщий.СообщитьЛкс(ОписаниеОшибки());
		КонецПопытки; 
	ИначеЕсли ТипЗнч(СхемаИлиМакетКомпоновки) = Тип("МакетКомпоновкиДанных") Тогда
		мМакетКомпоновкиДанных = ирОбщий.КопияОбъектаЛкс(СхемаИлиМакетКомпоновки);
	Иначе
		мСхемаКомпоновкиДанных = Новый СхемаКомпоновкиДанных;
	КонецЕсли;
	мМенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	мВнешниеНаборыДанных = ВнешниеНаборыДанных;
	Если мВнешниеНаборыДанных = Неопределено Тогда
		мВнешниеНаборыДанных = Новый Структура;
	КонецЕсли;
	Если Модально Тогда
		Возврат Форма.ОткрытьМодально();
	Иначе
		Форма.Открыть();
	КонецЕсли;
	
КонецФункции

Процедура ПредложитьЗаменуЗапросовПустышек(Схема) Экспорт 
	Если ЛиВКонфигурацииЕстьМеханизмЗаменыЗапросовПустышек() Тогда
		Если Найти(ирОбщий.ОбъектВСтрокуXMLЛкс(Схема), "ПОМЕСТИТЬ Представления_") > 0 Тогда
			Ответ = Вопрос("Хотите выполнить замену запросов-пустышек (представлений)?", РежимДиалогаВопрос.ДаНет);
			Если Ответ = КодВозвратаДиалога.Да Тогда
				ЗаменитьЗапросыПустышки(Схема);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция ЛиВКонфигурацииЕстьМеханизмЗаменыЗапросовПустышек() Экспорт 
	
	Попытка
		МодульЗарплатаКадрыОбщиеНаборыДанных = Вычислить("ЗарплатаКадрыОбщиеНаборыДанных");
		Результат = ирОбщий.МетодРеализованЛкс(МодульЗарплатаКадрыОбщиеНаборыДанных, "ЗаполнитьОбщиеИсточникиДанныхОтчета");
	Исключение
		Результат = Ложь;
	КонецПопытки;
	Возврат Результат;

КонецФункции

Процедура ЗаменитьЗапросыПустышки(Знач Схема) Экспорт 
	
	МодульЗарплатаКадрыОбщиеНаборыДанных = Вычислить("ЗарплатаКадрыОбщиеНаборыДанных");
	#Если Сервер И Не Сервер Тогда
		МодульЗарплатаКадрыОбщиеНаборыДанных = ЗарплатаКадрыОбщиеНаборыДанных;
	#КонецЕсли
	МодульЗарплатаКадрыОбщиеНаборыДанных.ЗаполнитьОбщиеИсточникиДанныхОтчета(Новый Структура("СхемаКомпоновкиДанных", Схема));

КонецПроцедуры

Функция РедактироватьСтруктуруСхемы(Знач ВладелецФормы, СтруктураСхемы, Модально = Ложь) Экспорт

	мИмяРедактируемойСхемы = Неопределено;
	мРежимРедактора = Истина;
	мСхемаКомпоновкиДанных = СтруктураСхемы.СхемаКомпоновки;
	#Если Сервер И Не Сервер Тогда
		мСхемаКомпоновкиДанных = Новый СхемаКомпоновкиДанных;
	#КонецЕсли
	Попытка
		КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(мСхемаКомпоновкиДанных));
	Исключение
		ирОбщий.СообщитьЛкс(ОписаниеОшибки());
	КонецПопытки; 
	Если СтруктураСхемы.Свойство("Настройки") Тогда
		НастройкаКомпоновки = СтруктураСхемы.Настройки;
	Иначе
		НастройкаКомпоновки = мСхемаКомпоновкиДанных.НастройкиПоУмолчанию;
	КонецЕсли;
	КомпоновщикНастроек.ЗагрузитьНастройки(НастройкаКомпоновки);
	Если СтруктураСхемы.Свойство("Имя") Тогда
		мИмяРедактируемойСхемы = СтруктураСхемы.Имя;
	КонецЕсли;
	Форма = ЭтотОбъект.ПолучитьФорму("Форма", ВладелецФормы);
	Если СтруктураСхемы.Свойство("РазрешитьРедактироватьСхему") Тогда
		Форма.ЭлементыФормы.ДеревоОтчетов.ТолькоПросмотр = Не СтруктураСхемы.РазрешитьРедактироватьСхему;
	КонецЕсли; 
	Если Модально Тогда
		Результат = Форма.ОткрытьМодально();
	Иначе
		Форма.Открыть();
	КонецЕсли; 
	Возврат Результат;
	
КонецФункции

#КонецЕсли

Функция ПолучитьПутьСтрокиОтчета(Строка) Экспорт

	ПутьСтроки = Неопределено;

	Если Строка <> Неопределено Тогда
		ТС = Строка;
		Пока ТС <> Неопределено Цикл
			Если ПутьСтроки = Неопределено Тогда
				ПутьСтроки = ТС.ИмяОтчета;
			Иначе
				ПутьСтроки = ТС.ИмяОтчета + Символы.ПС + ПутьСтроки;
			КонецЕсли;
			ТС = ТС.Родитель;
		КонецЦикла;
	КонецЕсли;

	Возврат ПутьСтроки;

КонецФункции

Функция НайтиСтрокуОтчетаПоПути(Путь) Экспорт

	ТекущаяСтрокаДерева = Неопределено;
	Если Путь <> Неопределено Тогда
		Для НомерСтроки = 1 По СтрЧислоСтрок(Путь) Цикл
			ТекущееИмяОтчета = СтрПолучитьСтроку(Путь, НомерСтроки);
			Если ТекущаяСтрокаДерева = Неопределено Тогда 
				Строки = ДеревоОтчетов.Строки;
			Иначе
				Строки = ТекущаяСтрокаДерева.Строки;
			КонецЕсли;
			Найдено = Ложь;
			Для Каждого СтрокаДерева Из Строки Цикл
				Если СтрокаДерева.ИмяОтчета = ТекущееИмяОтчета Тогда
					// Нашли текущее имя
					Найдено = Истина;
					ТекущаяСтрокаДерева = СтрокаДерева;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Если Не Найдено Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	Возврат ТекущаяСтрокаДерева;

КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Вывод макета компоновки в табличный документ

Функция ПредставлениеМакетовМакетаКомпоновкиДанных(СхемаКомпоновкиДанных = Неопределено, НастройкиКомпоновкиДанных = Неопределено, МакетКомпоновки = Неопределено) Экспорт
	
	Если МакетКомпоновки = Неопределено Тогда
		КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
		МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиКомпоновкиДанных);
	КонецЕсли;
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.НачатьВывод();
	ЭлементРезультата = Новый ЭлементРезультатаКомпоновкиДанных;
	ЭлементРезультата.ТипЭлемента = ТипЭлементаРезультатаКомпоновкиДанных.Начало;
	ЭлементРезультата.РасположениеВложенныхЭлементов = РасположениеВложенныхЭлементовРезультатаКомпоновкиДанных.Вертикально;
	ПроцессорВывода.ВывестиЭлемент(ЭлементРезультата);
	Для Каждого ОписаниеМакетаОбластиМакетаКомпоновкиДанных Из МакетКомпоновки.Макеты Цикл
		Если ТипЗнч(ОписаниеМакетаОбластиМакетаКомпоновкиДанных.Макет) = Тип("МакетОбластиКомпоновкиДанных") Тогда
			ВывестиОписание(ОписаниеМакетаОбластиМакетаКомпоновкиДанных.Имя, ПроцессорВывода);
			ВывестиМакетОбласти(ОписаниеМакетаОбластиМакетаКомпоновкиДанных, ПроцессорВывода, МакетКомпоновки.ЗначенияПараметров);
		КонецЕсли;
	КонецЦикла;
	ЭлементРезультата = Новый ЭлементРезультатаКомпоновкиДанных;
	ЭлементРезультата.ТипЭлемента = ТипЭлементаРезультатаКомпоновкиДанных.Конец;
	ПроцессорВывода.ВывестиЭлемент(ЭлементРезультата);
	ТабличныйДокумент = ПроцессорВывода.ЗакончитьВывод();
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция ПредставлениеТелаМакетаКомпоновкиДанных(СхемаКомпоновкиДанных = Неопределено, НастройкиКомпоновкиДанных = Неопределено, МакетКомпоновки = Неопределено) Экспорт
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	Если МакетКомпоновки = Неопределено Тогда
		КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
		МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиКомпоновкиДанных);
	КонецЕсли;
	ТелоXDTO = СериализаторXDTO.ЗаписатьXDTO(МакетКомпоновки).body;
	ВывестиСписокXDTO(ТелоXDTO, ТабличныйДокумент, 0, 0);
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция ПредставлениеМакетовИТелаМакетаКомпоновкиДанных(СхемаКомпоновкиДанных = Неопределено, НастройкиКомпоновкиДанных = Неопределено, МакетКомпоновки = Неопределено) Экспорт
	
	Если МакетКомпоновки = Неопределено Тогда
		КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
		МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиКомпоновкиДанных);
	КонецЕсли;
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ПредставлениеМакетов = ПредставлениеМакетовМакетаКомпоновкиДанных(СхемаКомпоновкиДанных, НастройкиКомпоновкиДанных, МакетКомпоновки);
	ПредставлениеТела = ПредставлениеТелаМакетаКомпоновкиДанных(СхемаКомпоновкиДанных, НастройкиКомпоновкиДанных, МакетКомпоновки);
	ТабличныйДокумент.Вывести(ПредставлениеТела);
	ТабличныйДокумент.Вывести(ПредставлениеМакетов);
	Возврат ТабличныйДокумент;
	
КонецФункции

Процедура ВывестиСписокXDTO(СписокXDTO, ТабличныйДокумент, НомерСтроки, НомерКолонки)
	
	Линия = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Точечная);
	МаксимальныйНомерСтроки = 0;
	СчетчикЭлементов = 0;
	НомерКолонкиПередВыводом = НомерКолонки;
	КоличествоЭлементов = СписокXDTO.Количество();
	Для Каждого ЭлементСпискаXDTO Из СписокXDTO Цикл
		СчетчикЭлементов = СчетчикЭлементов + 1;
		ТекущийНомерСтроки = НомерСтроки;
		НомерКолонки = НомерКолонки + 1;
		//НомерКолонкиПередВыводом = НомерКолонки;
		Если ТипЗнч(ЭлементСпискаXDTO) = Тип("ОбъектXDTO") Тогда
			ВывестиОбъектXDTO(ЭлементСпискаXDTO, ТабличныйДокумент, НомерСтроки, НомерКолонки);
			МаксимальныйНомерСтроки = Макс(НомерСтроки, МаксимальныйНомерСтроки);
			Если Ложь
				Или ЭлементСпискаXDTO.Тип().Имя = "DataCompositionPartTemplate" 
				Или СписокXDTO.ВладеющееСвойство.Имя <> "body"
			Тогда
				НомерСтроки = ТекущийНомерСтроки;      
			Иначе
				НомерСтроки = МаксимальныйНомерСтроки + 1;
				НомерКолонки = НомерКолонкиПередВыводом;
			КонецЕсли;
		Иначе
			ВывестиОбъект(ЭлементСпискаXDTO, ТабличныйДокумент, НомерСтроки, НомерКолонки);
			МаксимальныйНомерСтроки = Макс(НомерСтроки, МаксимальныйНомерСтроки);
			НомерСтроки = ТекущийНомерСтроки;
		КонецЕсли;
		//Если СчетчикЭлементов < КоличествоЭлементов Тогда
		//	Если НомерКолонки > НомерКолонкиПередВыводом Тогда
		//		ОбластьЯчеек = ТабличныйДокумент.Область(НомерСтроки+1, НомерКолонкиПередВыводом+1, НомерСтроки+1, НомерКолонки);
		//		ОбластьЯчеек.ЦветФона = WebЦвета.СветлоЖелтый;
		//		ОбластьЯчеек.Обвести( , Линия, , Линия);
		//	КонецЕсли;
		//КонецЕсли;
	КонецЦикла;
	//НомерКолонки = НомерКолонкиПередВыводом;
	НомерСтроки = МаксимальныйНомерСтроки;
	
КонецПроцедуры

Процедура ВывестиОбъектXDTO(ОбъектXDTO, ТабличныйДокумент, НомерСтроки, НомерКолонки)
	
	#Если Сервер И Не Сервер Тогда
		ТабличныйДокумент = Новый ТабличныйДокумент;
		ОбъектXDTO = ФабрикаXDTO.Создать();
	#КонецЕсли
	Линия = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная);
	СвойстваXDTO = ОбъектXDTO.Свойства();
	МаксимальныйНомерКолонки = НомерКолонки;
	ВывестиТип = Истина;
	ТипОбъекта = ОбъектXDTO.Тип();
	БазовыйЦветФона = WebЦвета.СветлоЖелтый;
	Для Каждого СвойствоXDTO Из СвойстваXDTO Цикл
		ИмяСвойства = СвойствоXDTO.Имя;
		ЗначениеСвойства = ОбъектXDTO[ИмяСвойства];
		Если Ложь
			Или ТипЗнч(ЗначениеСвойства) = Тип("ОбъектXDTO")
			Или ЗначениеЗаполнено(ЗначениеСвойства) 
		Тогда
			Если ВывестиТип Тогда
				НомерСтроки = НомерСтроки + 1;
				ТипОбъекта = СериализаторXDTO.ИзXMLТипа(ТипОбъекта.Имя, ТипОбъекта.URIПространстваИмен);
				ОбластьЯчеек = ТабличныйДокумент.Область(НомерСтроки, НомерКолонки);
				ОбластьЯчеек.ШиринаКолонки = 25;
				ОбластьЯчеек.ВысотаСтроки = 11;
				ОбластьЯчеек.ВертикальноеПоложение = ВертикальноеПоложение.Верх;
				ОбластьЯчеек.РазмещениеТекста = ТипРазмещенияТекстаТабличногоДокумента.Переносить;
				ОбластьЯчеек.Обвести(Линия, Линия, Линия, Линия);
				ОбластьЯчеек.Текст = ТипОбъекта;
				ОбластьЯчеек.ЦветФона = ирОбщий.СмещенныйЦветЛкс(БазовыйЦветФона);
				ВывестиТип = Ложь;
			КонецЕсли;
			НомерСтроки = НомерСтроки + 1;
			ОбластьЯчеек = ТабличныйДокумент.Область(НомерСтроки, НомерКолонки);
			ОбластьЯчеек.ШиринаКолонки = 25;
			ОбластьЯчеек.РазмещениеТекста = ТипРазмещенияТекстаТабличногоДокумента.Переносить;
			ОбластьЯчеек.Обвести(Линия, Линия, Линия, Линия);
			Если ТипЗнч(ЗначениеСвойства) = Тип("СписокXDTO") Тогда
				ОбластьЯчеек.Текст = ИмяСвойства;
				ТекущийНомерКолонки = НомерКолонки;
				НомерСтрокиПередВыводом = НомерСтроки;
				ВывестиСписокXDTO(ЗначениеСвойства, ТабличныйДокумент, НомерСтроки, НомерКолонки);
				МаксимальныйНомерКолонки = Макс(НомерКолонки, МаксимальныйНомерКолонки);
				НомерКолонки = ТекущийНомерКолонки;
				ОбластьЯчеек = ТабличныйДокумент.Область(НомерСтрокиПередВыводом, НомерКолонки, НомерСтроки, НомерКолонки);
				ОбластьЯчеек.Объединить();
				ОбластьЯчеек.Обвести(Линия, Линия, Линия, Линия);
				ОбластьЯчеек.ВертикальноеПоложение = ВертикальноеПоложение.Центр;
			Иначе
				ОбластьЯчеек.Текст = ИмяСвойства + " = " + Строка(ЗначениеСвойства);
			КонецЕсли;       
			Если Истина
				И ирОбщий.СтрКончаетсяНаЛкс(ИмяСвойства, "template") 
				И ТипЗнч(ЗначениеСвойства) = Тип("Строка")
			Тогда
				ОбластьЯчеек.ЦветТекста = WebЦвета.ТемноСиний;
			КонецЕсли;
			ОбластьЯчеек.ЦветФона = БазовыйЦветФона;
		КонецЕсли;
	КонецЦикла;
	
	НомерКолонки = МаксимальныйНомерКолонки;
	
КонецПроцедуры

Процедура ВывестиОбъект(ЭлементСпискаXDTO, ТабличныйДокумент, НомерСтроки, НомерКолонки)
	#Если Сервер И Не Сервер Тогда
		ТабличныйДокумент = Новый ТабличныйДокумент;
	#КонецЕсли
	Если ЗначениеЗаполнено(ЭлементСпискаXDTO) Тогда
		НомерСтроки = НомерСтроки + 1;
		ОбластьЯчеек = ТабличныйДокумент.Область(НомерСтроки, НомерКолонки);
		ОбластьЯчеек.ШиринаКолонки = 25;
		ОбластьЯчеек.РазмещениеТекста = ТипРазмещенияТекстаТабличногоДокумента.Переносить;
		Линия = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная);
		ОбластьЯчеек.Обвести(Линия, Линия, Линия, Линия);
		ОбластьЯчеек.Текст = Строка(ЭлементСпискаXDTO);
		ОбластьЯчеек.ЦветФона = WebЦвета.СветлоЖелтый;
	КонецЕсли;
	
КонецПроцедуры

Процедура ВывестиМакетОбласти(Макет, ПроцессорВывода, МакетКомпоновкиЗначенияПараметров)
	
	ЭлементРезультата = Новый ЭлементРезультатаКомпоновкиДанных;
	ЭлементРезультата.Макет = Макет.Имя;
	ОписаниеМакетаОбластиМакетаКомпоновкиДанных = ЭлементРезультата.Макеты.Добавить();
	ЗаполнитьЗначенияСвойств(ОписаниеМакетаОбластиМакетаКомпоновкиДанных, Макет);
	Если ТипЗнч(Макет.Макет) = Тип("МакетОбластиКомпоновкиДанных") Тогда
		МакетОбластиКомпоновкиДанных = Макет.Макет;
		#Если Сервер И Не Сервер Тогда
			МакетОбластиКомпоновкиДанных = Новый МакетОбластиКомпоновкиДанных;
		#КонецЕсли
		Для Каждого СтрокаТаблицыОбласти Из МакетОбластиКомпоновкиДанных Цикл
			Для Каждого ЯчейкаТаблицыОбластиКомпоновкиДанных Из СтрокаТаблицыОбласти.Ячейки Цикл
				Для Каждого ЗначениеПараметраКомпоновкиДанных Из ЯчейкаТаблицыОбластиКомпоновкиДанных.Оформление.Элементы Цикл
					Если ТипЗнч(ЗначениеПараметраКомпоновкиДанных.Значение) = Тип("ПараметрКомпоновкиДанных") И ЗначениеПараметраКомпоновкиДанных.Использование Тогда
						ЗначениеПараметра = Макет.Параметры.Найти(ЗначениеПараметраКомпоновкиДанных.Значение);
						Если ТипЗнч(ЗначениеПараметра) = Тип("ПараметрОбластиВыражениеКомпоновкиДанных") Тогда
							ИмяПараметра = Строка(ЗначениеПараметраКомпоновкиДанных.Параметр);
							Выражение = ЗначениеПараметра.Выражение;
							ВывестиОписание(ИмяПараметра + " = " + Выражение, ПроцессорВывода);
							ЗначениеПараметраКомпоновкиДанных.Использование = Ложь;
						КонецЕсли;
					КонецЕсли;
				КонецЦикла;
			КонецЦикла; 
			ЯчейкаТаблицыОбластиКомпоновкиДанных = СтрокаТаблицыОбласти.Ячейки.Добавить();
			ОформитьЯчейкуСИменемМакета(ЯчейкаТаблицыОбластиКомпоновкиДанных, Макет.Имя);
		КонецЦикла;
	КонецЕсли;
	Для Каждого ПараметрМакета Из Макет.Параметры Цикл
		НовыйПараметр = ОписаниеМакетаОбластиМакетаКомпоновкиДанных.Параметры.Добавить(ТипЗнч(ПараметрМакета));
		ЗаполнитьЗначенияСвойств(НовыйПараметр, ПараметрМакета);
		ЗначениеПараметраМакетаКомпоновкиДанных = ЭлементРезультата.ЗначенияПараметров.Добавить();
		ЗначениеПараметраМакетаКомпоновкиДанных.Имя = ПараметрМакета.Имя;
		ЗначениеПараметраМакетаКомпоновкиДанных.Значение = ПараметрМакета.Имя;
		Если ТипЗнч(ПараметрМакета) = Тип("ПараметрОбластиВыражениеКомпоновкиДанных") Тогда
			Если Найти(ВРег(ПараметрМакета.Выражение), "УРОВЕНЬ()") > 0 Тогда
				Выражение = ПараметрМакета.Выражение;
				Выражение = СтрЗаменить(Выражение, "Уровень()", "1");
				Выражение = СтрЗаменить(Выражение, "Представление(", "Строка(");
				Попытка
					Выражение = Вычислить(Выражение);
				Исключение
				КонецПопытки;
			Иначе
				Выражение = ПараметрМакета.Выражение;
			КонецЕсли;
			ЗначениеПараметраМакетаКомпоновкиДанных.Значение = Выражение;
		КонецЕсли;
	КонецЦикла;
	ПроцессорВывода.ВывестиЭлемент(ЭлементРезультата);
	
КонецПроцедуры

Процедура ВывестиОписание(Описание, ПроцессорВывода)
	
	ЭлементРезультата = Новый ЭлементРезультатаКомпоновкиДанных;
	ЭлементРезультата.Макет = "МакетОписание";
	ОписаниеМакетаОбластиМакетаКомпоновкиДанных = ЭлементРезультата.Макеты.Добавить();
	ОписаниеМакетаОбластиМакетаКомпоновкиДанных.Имя = "МакетОписание";
	
	МакетОбластиКомпоновкиДанных = Новый МакетОбластиКомпоновкиДанных;
	
	// пустая строка
	СтрокаТаблицыОбластиКомпоновкиДанных = МакетОбластиКомпоновкиДанных.Добавить(Тип("СтрокаТаблицыОбластиКомпоновкиДанных"));
	ЯчейкаТаблицыОбластиКомпоновкиДанных = СтрокаТаблицыОбластиКомпоновкиДанных.Ячейки.Добавить();
	ПолеОбластиКомпоновкиДанных = ЯчейкаТаблицыОбластиКомпоновкиДанных.Элементы.Добавить(Тип("ПолеОбластиКомпоновкиДанных"));
	
	// Заголовок области ячеек
	СтрокаТаблицыОбластиКомпоновкиДанных = МакетОбластиКомпоновкиДанных.Добавить(Тип("СтрокаТаблицыОбластиКомпоновкиДанных"));
	ЯчейкаТаблицыОбластиКомпоновкиДанных = СтрокаТаблицыОбластиКомпоновкиДанных.Ячейки.Добавить();
	ОформитьЯчейкуСИменемМакета(ЯчейкаТаблицыОбластиКомпоновкиДанных, Описание);
	
	ОписаниеМакетаОбластиМакетаКомпоновкиДанных.Макет = МакетОбластиКомпоновкиДанных;
	ПроцессорВывода.ВывестиЭлемент(ЭлементРезультата);
	
КонецПроцедуры

Процедура ОформитьЯчейкуСИменемМакета(Знач ЯчейкаТаблицыОбластиКомпоновкиДанных, Знач ИмяОбласти)
	
	#Если Сервер И Не Сервер Тогда
		ЯчейкаТаблицыОбластиКомпоновкиДанных = Новый МакетОбластиКомпоновкиДанных;
		ЯчейкаТаблицыОбластиКомпоновкиДанных = ЯчейкаТаблицыОбластиКомпоновкиДанных.Добавить().Ячейки[0];
	#КонецЕсли
	ПолеОбластиКомпоновкиДанных = ЯчейкаТаблицыОбластиКомпоновкиДанных.Элементы.Добавить(Тип("ПолеОбластиКомпоновкиДанных"));
	ПолеОбластиКомпоновкиДанных.Значение = ИмяОбласти;
	ЯчейкаТаблицыОбластиКомпоновкиДанных.Оформление.УстановитьЗначениеПараметра("Расшифровка", Новый Структура("ИмяОбластиМакета", ИмяОбласти));
	ЯчейкаТаблицыОбластиКомпоновкиДанных.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.ТемноСиний);

КонецПроцедуры

//ирПортативный лФайл = Новый Файл(ИспользуемоеИмяФайла);
//ирПортативный ПолноеИмяФайлаБазовогоМодуля = Лев(лФайл.Путь, СтрДлина(лФайл.Путь) - СтрДлина("Модули\")) + "ирПортативный.epf";
//ирПортативный #Если Клиент Тогда
//ирПортативный 	Контейнер = Новый Структура();
//ирПортативный 	Оповестить("ирПолучитьБазовуюФорму", Контейнер);
//ирПортативный 	Если Не Контейнер.Свойство("ирПортативный", ирПортативный) Тогда
//ирПортативный 		ирПортативный = ВнешниеОбработки.ПолучитьФорму(ПолноеИмяФайлаБазовогоМодуля);
//ирПортативный 		ирПортативный.Открыть();
//ирПортативный 	КонецЕсли; 
//ирПортативный #Иначе
//ирПортативный 	ирПортативный = ВнешниеОбработки.Создать(ПолноеИмяФайлаБазовогоМодуля, Ложь); // Это будет второй экземпляр объекта
//ирПортативный #КонецЕсли
//ирПортативный ирОбщий = ирПортативный.ОбщийМодульЛкс("ирОбщий");
//ирПортативный ирКэш = ирПортативный.ОбщийМодульЛкс("ирКэш");
//ирПортативный ирСервер = ирПортативный.ОбщийМодульЛкс("ирСервер");
//ирПортативный ирКлиент = ирПортативный.ОбщийМодульЛкс("ирКлиент");

мПлатформа = ирКэш.Получить();
мРежимРедактора = Ложь;
мВнешниеНаборыДанных = Новый Структура;

// Создадим структуру дерева отчетов. Типы нужно указывать, чтобы неоправдано не устанавливался признак модифицированности в режиме редактора
ДеревоОтчетов.Колонки.Добавить("ИмяОтчета");
ДеревоОтчетов.Колонки.Добавить("ИД");
ДеревоОтчетов.Колонки.Добавить("СхемаКомпоновкиДанных");
ДеревоОтчетов.Колонки.Добавить("Автофиксация", Новый ОписаниеТипов("Булево"));
ДеревоОтчетов.Колонки.Добавить("НеЗаполнятьРасшифровки", Новый ОписаниеТипов("Булево"));
ДеревоОтчетов.Колонки.Добавить("ПроверятьДоступностьПолей", Новый ОписаниеТипов("Булево"));
ДеревоОтчетов.Колонки.Добавить("УчитыватьОграниченияДоступностиПараметров", Новый ОписаниеТипов("Булево"));
ДеревоОтчетов.Колонки.Добавить("Настройки");
ДеревоОтчетов.Колонки.Добавить("НастройкаДляЗагрузки");
ДеревоОтчетов.Колонки.Добавить("СохранятьНастройкиАвтоматически");
ДеревоОтчетов.Колонки.Добавить("События");
ДеревоОтчетов.Колонки.Добавить("ВнешниеНаборыДанных");
