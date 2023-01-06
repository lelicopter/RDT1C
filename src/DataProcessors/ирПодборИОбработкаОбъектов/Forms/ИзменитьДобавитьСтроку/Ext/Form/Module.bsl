﻿//Признак использования настроек
Перем мИспользоватьНастройки Экспорт;
Перем мПоляТаблицыБД Экспорт;
Перем мИменаПредставления;
Перем мНастройка;
Перем мОбъектМД;
Перем мИмяТаблицы;
Перем мОбщиеЗначенияВлияющихРеквизитов;
Перем мОбщиеЗначенияВлияющихРеквизитовВладельца;
Перем мСтруктураВлияющих;

// Сохраняет значения реквизитов формы.
//
// Параметры:
//  Нет.
//
Процедура вСохранитьНастройку() Экспорт

	//Если ПустаяСтрока(ЭлементыФормы.ТекущаяНастройка) Тогда
	//	Предупреждение("Задайте имя новой настройки для сохранения или выберите существующую настройку для перезаписи.");
	//КонецЕсли;
	Если ЭлементыФормы.ТекущаяНастройка.Значение = мИмяНастройкиПоУмолчанию Или Не ЗначениеЗаполнено(ЭлементыФормы.ТекущаяНастройка.Значение) Тогда
		АвтоИмяНастройки = "";
		Для Каждого СтрокаРеквизита Из ЗначенияРеквизитов.НайтиСтроки(Новый Структура("Пометка", Истина)) Цикл
			Если АвтоИмяНастройки <> "" Тогда
				АвтоИмяНастройки = АвтоИмяНастройки + ", ";
			КонецЕсли;
			АвтоИмяНастройки = АвтоИмяНастройки + СтрокаРеквизита.Синоним + " = " + СтрокаРеквизита.Значение;
		КонецЦикла;
		Если ЗначениеЗаполнено(АвтоИмяНастройки) Тогда
			вУстановитьИмяНастройки(АвтоИмяНастройки);
		КонецЕсли; 
	КонецЕсли; 
	СохранитьНастройкуОбработки(ЭтаФорма);

КонецПроцедуры

Функция ПолучитьНастройкуЛкс() Экспорт 
	
	НоваяНастройка = Новый Структура();
	РеквизитыДляСохранения = ЗначенияРеквизитов.Выгрузить(Новый Структура("Пометка", Истина));
	Для каждого РеквизитНастройки из мНастройка Цикл
		Выполнить("НоваяНастройка.Вставить(Строка(РеквизитНастройки.Ключ), " + Строка(РеквизитНастройки.Ключ) + ");");
	КонецЦикла;
	Возврат НоваяНастройка;

КонецФункции

// Восстанавливает сохраненные значения реквизитов формы.
//
// Параметры:
//  Нет.
//
Процедура вЗагрузитьНастройку() Экспорт

	ЭтоНоваяНастройка = ЭтоНоваяНастройка();
	Если ЭтоНоваяНастройка Тогда
		вУстановитьИмяНастройки(мИмяНастройкиПоУмолчанию);
	Иначе
		Если ТекущаяНастройка.Настройка <> Неопределено Тогда
			ирОбщий.СкопироватьУниверсальнуюКоллекциюЛкс(ТекущаяНастройка.Настройка, мНастройка);
		КонецЕсли;
	КонецЕсли;

	ЗначенияРеквизитов.Очистить();
	Для каждого РеквизитНастройки из мНастройка Цикл
		Значение = мНастройка[РеквизитНастройки.Ключ];
		Если НЕ Значение = Неопределено Тогда
			Выполнить(Строка(РеквизитНастройки.Ключ) + " = Значение;");
		КонецЕсли;
	КонецЦикла;

	Если РеквизитыДляСохранения.Количество() > 0 Тогда
		ЗначенияРеквизитов.Загрузить(РеквизитыДляСохранения);
	КонецЕсли;
	ОбновитьТаблицуРеквизитов();
	
КонецПроцедуры

Функция ЭтоНоваяНастройка()
	
	ЭтоНоваяНастройка = Ложь
		Или ТекущаяНастройка = Неопределено
		Или ТекущаяНастройка.Родитель = Неопределено;
	Возврат ЭтоНоваяНастройка;

КонецФункции //вЗагрузитьНастройку()

// Устанавливает значение реквизита "ТекущаяНастройка" по имени настройки или произвольно.
//
// Параметры:
//  ИмяНастройки   - произвольное имя настройки, которое необходимо установить.
//
Процедура вУстановитьИмяНастройки(ИмяНастройки = "") Экспорт

	Если ПустаяСтрока(ИмяНастройки) Тогда
		Если ТекущаяНастройка = Неопределено Тогда
			ЭлементыФормы.ТекущаяНастройка.Значение = "";
		Иначе
			ЭлементыФормы.ТекущаяНастройка.Значение = ТекущаяНастройка.Обработка;
		КонецЕсли;
	Иначе
		ЭлементыФормы.ТекущаяНастройка.Значение = ИмяНастройки;
	КонецЕсли;

КонецПроцедуры // вУстановитьИмяНастройки()

// Позволяет создать описание типов на основании строкового представления типа.
//
// Параметры: 
//  ТипСтрокой     - Строковое представление типа.
//
// Возвращаемое значение:
//  Описание типов.
//
Функция вОписаниеТипа(ТипСтрокой) Экспорт

	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип(ТипСтрокой));
	ОписаниеТипов = Новый ОписаниеТипов(МассивТипов);

	Возврат ОписаниеТипов;

КонецФункции // вОписаниеТипа()

// Процедура - обработчик события "ПередОткрытием" формы.
//
Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)

	Если мИспользоватьНастройки Тогда
		вУстановитьИмяНастройки();
		вЗагрузитьНастройку();
	Иначе
		ЭлементыФормы.ТекущаяНастройка.Доступность = Ложь;
		ЭлементыФормы.ОсновныеДействияФормы.Кнопки.СохранитьНастройку.Доступность = Ложь;
		ОбновитьТаблицуРеквизитов();
	КонецЕсли;
	ТабличноеПолеСтрокДляОбработки = ВладелецФормы.ЭлементыФормы.СтрокиДляОбработки;
	Если Истина
		И ЭтоНоваяНастройка()
		И Не МноготабличнаяВыборка
		И ТабличноеПолеСтрокДляОбработки.ТекущаяСтрока <> Неопределено 
	Тогда
		СтруктураКлюча = ирОбщий.СтруктураКлючаТаблицыБДЛкс(ОбластьПоиска);
		ЗаполнитьЗначенияСвойств(СтруктураКлюча, ТабличноеПолеСтрокДляОбработки.ТекущаяСтрока); 
		СтрокаРезультата = ирОбщий.СтрокаТаблицыБДПоКлючуЛкс(ирКэш.ИмяТаблицыИзМетаданныхЛкс(ОбластьПоиска), СтруктураКлюча);
		Если СтрокаРезультата <> Неопределено Тогда
			Для Каждого СтрокаРеквизита Из ЗначенияРеквизитов Цикл
				Если ирОбщий.ЛиИмяПеременнойЛкс(СтрокаРеквизита.Идентификатор) Тогда
					СтрокаРеквизита.Значение = СтрокаРезультата[СтрокаРеквизита.Идентификатор];
				КонецЕсли; 
			КонецЦикла; 
		КонецЕсли; 
	КонецЕсли; 
	Если ТабличноеПолеСтрокДляОбработки.ТекущаяКолонка <> Неопределено Тогда
		НоваяТекущаяСтрока = ЗначенияРеквизитов.Найти(ТабличноеПолеСтрокДляОбработки.ТекущаяКолонка.Данные, "Идентификатор");
		Если НоваяТекущаяСтрока <> Неопределено Тогда
			ЭлементыФормы.ЗначенияРеквизитов.ТекущаяСтрока = НоваяТекущаяСтрока;
		КонецЕсли; 
	КонецЕсли; 
	ЭлементыФормы.ЗначенияРеквизитов.Колонки.Использование.Видимость = Истина
		И мОбъектМД <> Неопределено
		И ирОбщий.ЛиМетаданныеОбъектаСГруппамиЛкс(мОбъектМД);
	УстановитьПереключательИмяСиноним();
	
	ТипТаблицы = ирОбщий.ТипТаблицыБДЛкс(ОбластьПоиска);
	ЭлементыФормы.КоманднаяПанельРеквизиты.Кнопки.ЗагрузитьИзОбъекта.Доступность = Ложь
		Или ТипТаблицы = "ТабличнаяЧасть"
		Или ирОбщий.ЛиКорневойТипСсылочногоОбъектаБДЛкс(ТипТаблицы)
		Или ирОбщий.ЛиКорневойТипРегистраБДЛкс(ТипТаблицы);

КонецПроцедуры // ПередОткрытием()

Процедура ОбновитьТаблицуРеквизитов()

	Если ВладелецФормы <> Неопределено Тогда
		ИскомыйОбъект = ВладелецФормы.мИскомыйОбъект;
	КонецЕсли; 
	мИмяТаблицы = "";
	ОписаниеТиповОбъекта = ПолучитьОписаниеТиповОбрабатываемогоЭлементаИлиОбъекта(ИскомыйОбъект,, мИмяТаблицы);
	Типы = ОписаниеТиповОбъекта.Типы();
	Если Типы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли; 
	мОбъектМД = Метаданные.НайтиПоТипу(Типы[0]);
	#Если Сервер И Не Сервер Тогда
		мОбъектМД = Метаданные.Справочники.ирАлгоритмы;
	#КонецЕсли
	Если Не ЗначениеЗаполнено(мИмяТаблицы) Тогда
		мИмяТаблицы = ирКэш.ИмяТаблицыИзМетаданныхЛкс(мОбъектМД.ПолноеИмя());
	КонецЕсли; 
	СписокВыбораТЧ = ЭлементыФормы.ИмяТабличнойЧасти.СписокВыбора;
	СписокВыбораТЧ.Очистить();
	ТабличныеЧастиОбъекта = ирОбщий.ТабличныеЧастиОбъектаЛкс(мОбъектМД);
	Для Каждого КлючИЗначение Из ТабличныеЧастиОбъекта Цикл
		СписокВыбораТЧ.Добавить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
	Если СписокВыбораТЧ.НайтиПоЗначению(ИмяТабличнойЧасти) = Неопределено Тогда
		ЭтаФорма.ИмяТабличнойЧасти = "";
	КонецЕсли; 
	Если ЗначениеЗаполнено(ИмяТабличнойЧасти) Тогда
		мИмяТаблицы = мИмяТаблицы + "." + ИмяТабличнойЧасти;
	КонецЕсли; 
	ЭлементыФормы.ЗначенияРеквизитов.Колонки.КлючПоиска.ТолькоПросмотр = Не ЗначениеЗаполнено(ИмяТабличнойЧасти); 
	ЭлементыФормы.ЗначенияРеквизитов.Колонки.КлючПоиска.Видимость = ЗначениеЗаполнено(ИмяТабличнойЧасти); 
	ЭлементыФормы.ОбрабатыватьСуществующую.Доступность = ЗначениеЗаполнено(ИмяТабличнойЧасти);
	ЭтоНезависимыйРегистр = ирОбщий.ЛиМетаданныеНезависимогоРегистраЛкс(мОбъектМД);
	СтруктураКлюча = ирОбщий.СтруктураКлючаТаблицыБДЛкс(мИмяТаблицы);
	мПоляТаблицыБД = ирКэш.ПоляТаблицыБДЛкс(мИмяТаблицы);
	#Если Сервер И Не Сервер Тогда
		мПоляТаблицыБД = НайтиПоСсылкам().Колонки;
	#КонецЕсли
	Для Каждого ПолеТаблицыБД Из мПоляТаблицыБД Цикл
		Если ПолеТаблицыБД.ТипЗначения.СодержитТип(Тип("ТаблицаЗначений")) Тогда
			Продолжить;
		КонецЕсли;
		Если Истина
			И СтруктураКлюча.Свойство(ПолеТаблицыБД.Имя)
			И Не ЭтоНезависимыйРегистр
		Тогда
			Продолжить;
		КонецЕсли; 
		СтрокаРеквизита = ЗначенияРеквизитов.Найти(ПолеТаблицыБД.Имя, "Идентификатор");
		Если СтрокаРеквизита = Неопределено Тогда
			СтрокаРеквизита = ЗначенияРеквизитов.Добавить();
			СтрокаРеквизита.Идентификатор = ПолеТаблицыБД.Имя;
			СтрокаРеквизита.Значение = ПолеТаблицыБД.ТипЗначения.ПривестиЗначение();
			СтрокаРеквизита.ТипИзменения = "УстановитьЗначение";
		КонецЕсли; 
		СтрокаРеквизита.Синоним = ПолеТаблицыБД.Заголовок;
		Если СтруктураКлюча.Свойство(ПолеТаблицыБД.Имя) Тогда
			СтрокаРеквизита.Синоним = СтрокаРеквизита.Синоним + " (Измерение)";
		КонецЕсли; 
		Если ирОбщий.ЛиКорневойТипКонстантыЛкс(ИскомыйОбъект.ТипТаблицы) Тогда
			СтрокаРеквизита.Синоним = "Значение";
		КонецЕсли; 
		СтрокаРеквизита.Использование = ирОбщий.ПеревестиВРусский(Метаданные.СвойстваОбъектов.ИспользованиеРеквизита.ДляГруппыИЭлемента);
		Если мОбъектМД <> Неопределено И Не ЗначениеЗаполнено(ИмяТабличнойЧасти)  Тогда
			Если ирОбщий.ЛиМетаданныеОбъектаСГруппамиЛкс(мОбъектМД) Тогда
				МетаРеквизит = мОбъектМД.Реквизиты.Найти(СтрокаРеквизита.Идентификатор);
				#Если Сервер И Не Сервер Тогда
					МетаРеквизит = Метаданные.Справочники.ирАлгоритмы.Реквизиты.ДатаИзменения;
				#КонецЕсли
				Если МетаРеквизит <> Неопределено Тогда
					СтрокаРеквизита.Использование = ирОбщий.ПеревестиВРусский(МетаРеквизит.Использование);
				КонецЕсли;
			КонецЕсли; 
		КонецЕсли;
		МетаРеквизит = ПолеТаблицыБД.Метаданные;
		Если МетаРеквизит <> Неопределено Тогда
			#Если Сервер И Не Сервер Тогда
				МетаРеквизит = Метаданные.Справочники.ирАлгоритмы.Реквизиты.ДатаИзменения;
			#КонецЕсли
			СтрокаРеквизита.СвязиПараметровВыбора = ирОбщий.ПредставлениеСвязейПараметровВыбораЛкс(МетаРеквизит);
			СтрокаРеквизита.Подсказка = МетаРеквизит.Подсказка;
		КонецЕсли;
	КонецЦикла;
	МассивКУдалению = Новый Массив();
	Для Каждого СтрокаРеквизита Из ЗначенияРеквизитов Цикл
		ПолеТаблицыБД = мПоляТаблицыБД.Найти(СтрокаРеквизита.Идентификатор, "Имя");
		Если ПолеТаблицыБД <> Неопределено Тогда
			Если Истина
				И СтруктураКлюча.Свойство(ПолеТаблицыБД.Имя)
				И (Ложь
					Или Не ЭтоНезависимыйРегистр
					Или (Истина
						И ЭтоНезависимыйРегистр 
						И Не ИзменятьИзмерения))
			Тогда
				ПолеТаблицыБД = Неопределено;
			КонецЕсли;
		КонецЕсли; 
		СтрокаРеквизита.Сопоставлен = ПолеТаблицыБД <> Неопределено;
		Если Не СтрокаРеквизита.Сопоставлен Тогда
			СтрокаРеквизита.Использование = "ОтсутствуетВДанных";
			СтрокаРеквизита.Пометка = Ложь;
			СтрокаРеквизита.СвязиПараметровВыбора = "";
		КонецЕсли; 
		ОбновитьТипЗначенияВСтрокеТаблицы(СтрокаРеквизита);
	КонецЦикла;
	Если ирОбщий.ЛиМетаданныеСсылочногоОбъектаЛкс(мОбъектМД) Тогда
		ТипСсылки = Тип(ирОбщий.ИмяТипаИзПолногоИмениМДЛкс(мОбъектМД));
		СписокСвойств = ирОбщий.ДопРеквизитыБСПОбъектаЛкс(Новый(ТипСсылки));
		Для Каждого Свойство Из СписокСвойств Цикл
			#Если Сервер И Не Сервер Тогда
				Свойство = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.ПустаяСсылка();
			#КонецЕсли
			СтрокаРеквизита = ЗначенияРеквизитов.Добавить();
			СтрокаРеквизита.ТипЗначения = Свойство.ТипЗначения;
			СтрокаРеквизита.Значение = Свойство.ТипЗначения.ПривестиЗначение();
			СтрокаРеквизита.ТипИзменения = "УстановитьЗначение";
			СтрокаРеквизита.Синоним = Свойство.Наименование;
			СтрокаРеквизита.Использование = ирОбщий.ПеревестиВРусский(Метаданные.СвойстваОбъектов.ИспользованиеРеквизита.ДляГруппыИЭлемента);
			СтрокаРеквизита.Сопоставлен = Истина;
			СтрокаРеквизита.Подсказка = Свойство.Подсказка;
			СтрокаРеквизита.ДопРеквизит = Свойство;
			СтрокаРеквизита.Идентификатор = "[" + СтрокаРеквизита.Синоним + "]";
		КонецЦикла;
	КонецЕсли; 
	ЗначенияРеквизитов.Сортировать("Сопоставлен Убыв, " + ПолучитьИмяКолонкиПредставления());
	НастроитьЭлементыФормы();

КонецПроцедуры

// Обработчик действия "НачалоВыбораИзСписка" реквизита "ТекущаяНастройка".
//
Процедура ТекущаяНастройкаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)

	Элемент.СписокВыбора.Очистить();

	Если ТекущаяНастройка.Родитель = Неопределено Тогда
		КоллекцияСтрок = ТекущаяНастройка.Строки;
	Иначе
		КоллекцияСтрок = ТекущаяНастройка.Родитель.Строки;
	КонецЕсли;

	Для каждого Строка из КоллекцияСтрок Цикл
		Элемент.СписокВыбора.Добавить(Строка, Строка.Обработка);
	КонецЦикла;

КонецПроцедуры // ТекущаяНастройкаНачалоВыбораИзСписка()

// Обработчик действия "ОбработкаВыбора" реквизита "ТекущаяНастройка".
//
Процедура ТекущаяНастройкаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	Если Истина
		И НЕ ТекущаяНастройка = ВыбранноеЗначение
		И Элемент.СписокВыбора.НайтиПоЗначению(ВыбранноеЗначение) <> Неопределено
	Тогда

		Если ЭтаФорма.Модифицированность Тогда
			Если Вопрос("Сохранить текущую настройку?", РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Да) = КодВозвратаДиалога.Да Тогда
				вСохранитьНастройку();
			КонецЕсли;
		КонецЕсли;

		ТекущаяНастройка = ВыбранноеЗначение;
		вУстановитьИмяНастройки();

		вЗагрузитьНастройку();

	КонецЕсли;

КонецПроцедуры // ТекущаяНастройкаОбработкаВыбора()

// Обработчик действия "Выполнить" командной панели "ОсновныеДействияФормы".
//
Процедура ОсновныеДействияФормыВыполнить(Кнопка)

	вВыполнитьОбработку(Кнопка);

КонецПроцедуры

Процедура вВыполнитьОбработку(Кнопка = Неопределено) Экспорт 
	
	Если Истина
		И Кнопка <> Неопределено 
		И Кнопка.Картинка <> ирКэш.КартинкаПоИмениЛкс("ирОстановить") 
	Тогда
		Если Не МноготабличнаяВыборка И СвязиИПараметрыВыбора Тогда
			ПрочитатьВлияющиеРеквизиты();
			Для Каждого СтрокаРеквизита Из ПомеченныеРеквизитыУстановкиЗначения() Цикл
				Если ПроверитьСвязиПараметровВыбора(СтрокаРеквизита, Ложь) = "Запрещено" Тогда 
					Возврат;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		Если РежимОбходаДанных = "Строки" И Не ЗначениеЗаполнено(ИмяТабличнойЧасти) Тогда
			Для каждого СтрокаРеквизита из ЗначенияРеквизитов Цикл
				Если Истина
					И СтрокаРеквизита.Пометка 
					И СтрокиДляОбработки.Колонки.Найти(СтрокаРеквизита.Идентификатор) = Неопределено
				Тогда
					ВыбранноеПоле = ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(Компоновщик.Настройки.Выбор, СтрокаРеквизита.Идентификатор);
					ВыбранноеПоле.Использование = Истина;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли; 
	ВыполнитьЗаданиеГрупповойОбработки(ЭтаФорма, Кнопка);

КонецПроцедуры

Функция ПомеченныеРеквизитыУстановкиЗначения()
	
	Возврат ЗначенияРеквизитов.НайтиСтроки(Новый Структура("Пометка, ТипИзменения", Истина, "УстановитьЗначение"));

КонецФункции

Функция ИмяПоляВлияющегоРеквизита(ВлияющийРеквизит)
	
	ПолноеИмяПоля = ирОбщий.ПоследнийФрагментЛкс(ВлияющийРеквизит);
	Если ЛиТЧ() И Найти(ВлияющийРеквизит, ".") = 0 Тогда
		ПолноеИмяПоля = "Ссылка." + ВлияющийРеквизит;
	КонецЕсли;
	Возврат ПолноеИмяПоля;

КонецФункции

Процедура ВыполнитьОбработкуЗавершение(СостояниеЗадания = Неопределено, РезультатЗадания = Неопределено) Экспорт 
	Если Ложь
		Или СостояниеЗадания = Неопределено
		Или СостояниеЗадания = СостояниеФоновогоЗадания.Завершено 
	Тогда
		ВернутьПараметрыПослеОбработки(РезультатЗадания, ВладелецФормы);
	КонецЕсли; 
КонецПроцедуры

// Предопределеный метод
Процедура ПроверкаЗавершенияФоновыхЗаданий() Экспорт 
	
	ирОбщий.ПроверитьЗавершениеФоновыхЗаданийФормыЛкс(ЭтаФорма);
	
КонецПроцедуры

// Обработчик действия "СохранитьНастройку" командной панели "ОсновныеДействияФормы".
//
Процедура ОсновныеДействияФормыСохранитьНастройку(Кнопка)

	вСохранитьНастройку();

КонецПроцедуры

// Обработчик действия "НачалоВыбора" поля ввода "Значение" табличного поля "Реквизиты".
//
Процедура РеквизитыЗначениеНачалоВыбора(Элемент, СтандартнаяОбработка)

	ТипыФильтра = ЭлементыФормы.ЗначенияРеквизитов.ТекущаяСтрока.Тип;
	МассивТипов = ТипыФильтра.Типы();
	Если МассивТипов.Количество() = 1 Тогда
		Элемент.ВыбиратьТип = Ложь;
	Иначе
		Элемент.ОграничениеТипа = ТипыФильтра;
		Элемент.ВыбиратьТип = Истина;
	КонецЕсли;

КонецПроцедуры // РеквизитыЗначениеНачалоВыбора()

// Обработчик действия "ОбработкаВыбора" поля ввода "Значение" табличного поля "ЗначенияРеквизитов".
//
Процедура РеквизитыЗначениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	ЭлементыФормы.ЗначенияРеквизитов.ТекущиеДанные.Пометка = Истина;

КонецПроцедуры // РеквизитыЗначениеОбработкаВыбора()

// Обработчик действия "ОкончаниеВводаТекста" поля ввода "Значение" табличного поля "ЗначенияРеквизитов".
//
Процедура РеквизитыЗначениеОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)

	ЭлементыФормы.ЗначенияРеквизитов.ТекущиеДанные.Пометка = Истина;

КонецПроцедуры

Функция ПолучитьОписаниеТиповРеквизита(СтрокаРеквизита)
	
	ПолеТаблицыБД = мПоляТаблицыБД.Найти(СтрокаРеквизита.Идентификатор, "Имя");
	Если ПолеТаблицыБД <> Неопределено Тогда
		Возврат ПолеТаблицыБД.ТипЗначения;
	КонецЕсли; 
	Возврат Новый ОписаниеТипов();
	
КонецФункции

// Обработчик действия "ПриНачалеРедактирования" табличного поля "ЗначенияРеквизитов".
//
Процедура РеквизитыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	#Если Сервер И Не Сервер Тогда
		Элемент = ЭлементыФормы.ЗначенияРеквизитов;
	#КонецЕсли
	ОписаниеТиповРеквизита = ПолучитьОписаниеТиповРеквизита(Элемент.ТекущаяСтрока);
	#Если Сервер И Не Сервер Тогда
	    ОписаниеТиповРеквизита = Новый ОписаниеТипов;
	#КонецЕсли
	Элемент.Колонки.ТипИзменения.ЭлементУправления.Доступность = Ложь
		Или ОписаниеТиповРеквизита.СодержитТип(Тип("Дата"))
		Или ОписаниеТиповРеквизита.СодержитТип(Тип("Булево"))
		Или (Истина
			И ОписаниеТиповРеквизита.СодержитТип(Тип("Число")) 
			И ОписаниеТиповРеквизита.КвалификаторыЧисла.РазрядностьДробнойЧасти > 0);
	КвалификаторыЧисла = ОписаниеТиповРеквизита.КвалификаторыЧисла;
	Если Элемент.ТекущаяСтрока.ТипИзменения = "УстановитьВремя" Тогда 
		ОписаниеТипов = Новый ОписаниеТипов("Дата",,,,, Новый КвалификаторыДаты(ЧастиДаты.Время));
	ИначеЕсли Элемент.ТекущаяСтрока.ТипИзменения = "УстановитьДату" Тогда
		ОписаниеТипов = Новый ОписаниеТипов("Дата",,,,, Новый КвалификаторыДаты(ЧастиДаты.Дата));
	ИначеЕсли Элемент.ТекущаяСтрока.ТипИзменения = "УстановитьДробнуюЧасть" Тогда 
		ОписаниеТипов = Новый ОписаниеТипов("Число",,, Новый КвалификаторыЧисла(0, КвалификаторыЧисла.РазрядностьДробнойЧасти, ДопустимыйЗнак.Неотрицательный));
	ИначеЕсли Элемент.ТекущаяСтрока.ТипИзменения = "УстановитьЦелуюЧасть" Тогда
		ОписаниеТипов = Новый ОписаниеТипов("Число",,, 
			Новый КвалификаторыЧисла(КвалификаторыЧисла.Разрядность - КвалификаторыЧисла.РазрядностьДробнойЧасти, 0, КвалификаторыЧисла.ДопустимыйЗнак));
	ИначеЕсли Элемент.ТекущаяСтрока.ТипИзменения = "УстановитьЗначение" Тогда
		ОписаниеТипов = ОписаниеТиповРеквизита;
	КонецЕсли;
	Если ОписаниеТипов <> Неопределено Тогда
		Элемент.Колонки.Значение.ЭлементУправления.ОграничениеТипа = ОписаниеТипов;
		Элемент.ТекущаяСтрока.Значение = ОписаниеТипов.ПривестиЗначение(Элемент.ТекущаяСтрока.Значение);
	КонецЕсли; 
	ЭлементыФормы.ЗначенияРеквизитов.Колонки.ТипИзменения.ЭлементУправления.СписокВыбора = ДоступныеТипыИзмененияРеквизита(ОписаниеТиповРеквизита);
	
КонецПроцедуры

Функция ДоступныеТипыИзмененияРеквизита(Знач ОписаниеТиповРеквизита)
	
	СписокВыбора = Новый СписокЗначений;
	Если ОписаниеТиповРеквизита.СодержитТип(Тип("Дата")) Тогда
		СписокВыбора.Добавить("УстановитьЗначение", "Установить значение");
		Если ОписаниеТиповРеквизита.КвалификаторыДаты.ЧастиДаты = ЧастиДаты.ДатаВремя Тогда
			СписокВыбора.Добавить("УстановитьВремя", "Установить только время");
			СписокВыбора.Добавить("УстановитьДату", "Установить только дату");
		КонецЕсли; 
		Если ОписаниеТиповРеквизита.КвалификаторыДаты.ЧастиДаты <> ЧастиДаты.Дата Тогда
			СписокВыбора.Добавить("СдвинутьВКонецДня", "Сдвинуть в конец дня");
			СписокВыбора.Добавить("СдвинутьВНачалоДня", "Сдвинуть в начало дня");
		КонецЕсли; 
		Если ОписаниеТиповРеквизита.КвалификаторыДаты.ЧастиДаты <> ЧастиДаты.Время Тогда
			СписокВыбора.Добавить("СдвинутьВКонецМесяца", "Сдвинуть в конец месяца");
			СписокВыбора.Добавить("СдвинутьВНачалоМесяца", "Сдвинуть в начало месяца");
			СписокВыбора.Добавить("СдвинутьВКонецГода", "Сдвинуть в конец года");
			СписокВыбора.Добавить("СдвинутьВНачалоГода", "Сдвинуть в начало года");
		КонецЕсли;
	ИначеЕсли ОписаниеТиповРеквизита.СодержитТип(Тип("Булево")) Тогда
		СписокВыбора.Добавить("УстановитьЗначение", "Установить значение");
		СписокВыбора.Добавить("ИнвертироватьЗначение", "Инвертировать значение");
	ИначеЕсли ОписаниеТиповРеквизита.СодержитТип(Тип("Число")) Тогда
		СписокВыбора.Добавить("УстановитьЗначение", "Установить значение");
		Если ОписаниеТиповРеквизита.КвалификаторыЧисла.РазрядностьДробнойЧасти > 0 Тогда
			СписокВыбора.Добавить("УстановитьДробнуюЧасть", "Установить дробную часть");
			СписокВыбора.Добавить("УстановитьЦелуюЧасть", "Установить целую часть");
			СписокВыбора.Добавить("Округлить", "Округлить");
		КонецЕсли;
	КонецЕсли;
	Возврат СписокВыбора;

КонецФункции

// Обработчик действия "ПриВыводеСтроки" табличного поля "ЗначенияРеквизитов".
//
Процедура РеквизитыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки, ЭлементыФормы.КоманднаяПанельРеквизиты.Кнопки.Идентификаторы,,,,, "Значение");
	Если ДоступныеТипыИзмененияРеквизита(ПолучитьОписаниеТиповРеквизита(ДанныеСтроки)).Количество() < 2 Тогда 
		ОформлениеСтроки.Ячейки.ТипИзменения.УстановитьТекст("");
	КонецЕсли;
	ОформлениеСтроки.Ячейки.Значение.ТолькоПросмотр = Истина
		И ДанныеСтроки.ТипИзменения <> "УстановитьЗначение"
		И ДанныеСтроки.ТипИзменения <> "УстановитьВремя"
		И ДанныеСтроки.ТипИзменения <> "УстановитьДату"
		И ДанныеСтроки.ТипИзменения <> "УстановитьДробнуюЧасть"
		И ДанныеСтроки.ТипИзменения <> "УстановитьЦелуюЧасть";
	ОформлениеСтроки.Ячейки.КлючПоиска.ТолькоПросмотр = Истина
		И ДанныеСтроки.ТипИзменения <> "УстановитьЗначение";
	//ОформлениеСтроки.Ячейки.Значение.Текст = Строка(ДанныеСтроки.Тип.ПривестиЗначение(ОформлениеСтроки.Ячейки.Значение.Значение));
	Если Не ДанныеСтроки.Сопоставлен Тогда
		ОформлениеСтроки.ЦветФона = ирОбщий.ЦветФонаОшибкиЛкс();
		ОформлениеСтроки.Ячейки.Пометка.ТолькоПросмотр = Истина;
	КонецЕсли;
	Если ЗначениеЗаполнено(ДанныеСтроки.ДопРеквизит) Тогда
		ирОбщий.ОформитьСтрокуДопРеквизитаБСПЛкс(ОформлениеСтроки);
	КонецЕсли;
	//ПредставлениеТипаИзменения = ЭлементыФормы.ЗначенияРеквизитов.Колонки.ТипИзменения.ЭлементУправления.СписокВыбора.НайтиПоЗначению(ДанныеСтроки.ТипИзменения).Представление;
	//ОформлениеСтроки.Ячейки.ТипИзменения.УстановитьТекст(ПредставлениеТипаИзменения);
	ирОбщий.ТабличноеПолеОтобразитьФлажкиЛкс(ОформлениеСтроки, "Значение");
	ирОбщий.ТабличноеПолеОтобразитьПиктограммыТиповЛкс(ОформлениеСтроки, "Значение");
	ОписаниеТипов = ПолучитьОписаниеТиповРеквизита(ДанныеСтроки);
	ирОбщий.ОформитьЯчейкуСРасширеннымЗначениемЛкс(ОформлениеСтроки.Ячейки.ОписаниеТипов, ОписаниеТипов,, Ложь);

КонецПроцедуры

Процедура ЗначенияРеквизитовЗначениеПриИзменении(Элемент)
	
	Если ЭлементыФормы.ЗначенияРеквизитов.ТекущаяСтрока.Сопоставлен Тогда
		ЭлементыФормы.ЗначенияРеквизитов.ТекущаяСтрока.Пометка = Истина;
	КонецЕсли; 
	ОбновитьТипЗначенияВСтрокеТаблицы();
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, КлючИсторииВыбораЗначенияРеквизита());
	
КонецПроцедуры

Процедура ОбновитьТипЗначенияВСтрокеТаблицы(СтрокаТаблицы = Неопределено)
	
	Если СтрокаТаблицы = Неопределено Тогда
		СтрокаТаблицы = ЭлементыФормы.ЗначенияРеквизитов.ТекущиеДанные;
	КонецЕсли; 
	ОписаниеТипов = ПолучитьОписаниеТиповРеквизита(СтрокаТаблицы);
	ирОбщий.ОбновитьТипЗначенияВСтрокеТаблицыЛкс(СтрокаТаблицы,, ОписаниеТипов,,, Метаданные().ТабличныеЧасти.ЗначенияРеквизитов.Реквизиты);

КонецПроцедуры

Процедура ОбновитьКолонки()
	
	СтараяТекущаяКолонка = ЭлементыФормы.ЗначенияРеквизитов.ТекущаяКолонка;
	ЭлементыФормы.ЗначенияРеквизитов.Колонки.Синоним.Видимость = Не мИменаПредставления;
	ЭлементыФормы.ЗначенияРеквизитов.Колонки.Идентификатор.Видимость = мИменаПредставления;
	Если СтараяТекущаяКолонка <> Неопределено Тогда
		Если Не СтараяТекущаяКолонка.Видимость Тогда
			Если СтараяТекущаяКолонка = ЭлементыФормы.ЗначенияРеквизитов.Колонки.Идентификатор Тогда
				ЭлементыФормы.ЗначенияРеквизитов.ТекущаяКолонка = ЭлементыФормы.ЗначенияРеквизитов.Колонки.Синоним;
			Иначе
				ЭлементыФормы.ЗначенияРеквизитов.ТекущаяКолонка = ЭлементыФормы.ЗначенияРеквизитов.Колонки.Идентификатор;
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 

КонецПроцедуры

Функция ПолучитьИмяКолонкиПредставления()

	Если Не мИменаПредставления Тогда
		Результат = "Синоним";
	Иначе
		Результат = "Идентификатор";
	КонецЕсли;
	Возврат Результат;
	
КонецФункции

Процедура КоманднаяПанельРеквизитыИменаПредставления(Кнопка)
	
	УстановитьПереключательИмяСиноним(Не Кнопка.Пометка);
	
КонецПроцедуры

Процедура УстановитьПереключательИмяСиноним(Знач НоваяПометка = Неопределено)
	
	Если НоваяПометка <> Неопределено Тогда
		мИменаПредставления = НоваяПометка;
	КонецЕсли;
	ЭлементыФормы.КоманднаяПанельРеквизиты.Кнопки.ИменаПредставления.Пометка = мИменаПредставления;
	ОбновитьКолонки();

КонецПроцедуры

Процедура КоманднаяПанельРеквизитыТолькоПомеченные(Кнопка)
	
	Кнопка.Пометка = Не Кнопка.Пометка;
	ЭлементОтбора = ЭлементыФормы.ЗначенияРеквизитов.ОтборСтрок.Пометка;
	ЭлементОтбора.Значение = Истина;
	ЭлементОтбора.ВидСравнения = ВидСравнения.Равно;
	ЭлементОтбора.Использование = Кнопка.Пометка;
	
КонецПроцедуры

Процедура ЗначенияРеквизитовПриИзмененииФлажка(Элемент, Колонка)
	
	ирОбщий.ТабличноеПолеПриИзмененииФлажкаЛкс(ЭтаФорма, Элемент, Колонка, ЭлементыФормы.КоманднаяПанельРеквизиты.Кнопки.ТолькоПомеченные);

КонецПроцедуры

Процедура ЗначенияРеквизитовЗначениеНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ОбщиеЗначенияВлияющихРеквизитовВладельцаТЧ = ПроверитьСвязиПараметровВыбора(ЭлементыФормы.ЗначенияРеквизитов.ТекущаяСтрока);
	Если ОбщиеЗначенияВлияющихРеквизитовВладельцаТЧ = "Запрещено" Тогда
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;
	УспехВыбора = ирОбщий.ПолеВводаКолонкиЗначенияРеквизита_НачалоВыбораЛкс(ЭтаФорма, ЭлементыФормы.ЗначенияРеквизитов, мИмяТаблицы, "Идентификатор", , СвязиИПараметрыВыбора, СтандартнаяОбработка,,
		ОбщиеЗначенияВлияющихРеквизитовВладельцаТЧ);
	Если УспехВыбора Тогда 
		ОбновитьТипЗначенияВСтрокеТаблицы();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ЗначенияРеквизитовЗначениеНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	Если СвязиИПараметрыВыбора Тогда
		ОбщиеЗначенияВлияющихРеквизитовВладельцаТЧ = ПроверитьСвязиПараметровВыбора(ЭлементыФормы.ЗначенияРеквизитов.ТекущаяСтрока);
		Если ОбщиеЗначенияВлияющихРеквизитовВладельцаТЧ = "Запрещено" Тогда
			СтандартнаяОбработка = Ложь;
			Возврат;
		КонецЕсли;
		ОтборВыбора = ирОбщий.ПолеВводаКолонкиЗначенияРеквизита_ОтборВыбораЛкс(ЭлементыФормы.ЗначенияРеквизитов, мИмяТаблицы, "Идентификатор",,, ОбщиеЗначенияВлияющихРеквизитовВладельцаТЧ);
	КонецЕсли; 
	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, КлючИсторииВыбораЗначенияРеквизита(),, ОтборВыбора);

КонецПроцедуры

Функция ПроверитьСвязиПараметровВыбора(Знач СтрокаРеквизита, Знач ДляВыбора = Истина)
	Если Не СвязиИПараметрыВыбора Тогда
		Возврат Неопределено;
	КонецЕсли;
	СвязиПараметровВыбораРеквизита = СтрокаРеквизита.СвязиПараметровВыбора;
	Если Не ЗначениеЗаполнено(СвязиПараметровВыбораРеквизита) Тогда
		Возврат Неопределено;
	КонецЕсли;
	ОбщиеЗначенияВлияющихРеквизитов = ОбщиеЗначенияВлияющихРеквизитов();
	Если ОбщиеЗначенияВлияющихРеквизитов <> Неопределено Тогда
		Для Каждого СвязьПараметров Из ирОбщий.ПоляТаблицыБДЛкс(мИмяТаблицы).Найти(СтрокаРеквизита.Идентификатор, "Имя").Метаданные.СвязиПараметровВыбора Цикл
			#Если Сервер И Не Сервер Тогда
				СвязьПараметров = Новый СвязьПараметраВыбора;
			#КонецЕсли
			ИмяРеквизитаОтбора = СвязьПараметров.Имя;
			Если Не ирОбщий.СтрНачинаетсяСЛкс(ИмяРеквизитаОтбора, "Отбор.") Тогда
				Продолжить;
			КонецЕсли;
			ИмяРеквизитаОтбора = СтрЗаменить(ИмяРеквизитаОтбора, "Отбор.", "");
			Если Не ирОбщий.ЕстьСвойствоОбъектаЛкс(СтрокаРеквизита.Значение, ИмяРеквизитаОтбора) Тогда
				Продолжить;
			КонецЕсли;
			ВлияющееПоле = СвязьПараметров.ПутьКДанным;
			СтрокаВлияющегоРеквизита = ЗначенияРеквизитов.Найти(ирОбщий.ПоследнийФрагментЛкс(ВлияющееПоле), "Идентификатор");
			Если Истина
				И СтрокаВлияющегоРеквизита <> Неопределено
				И СтрокаВлияющегоРеквизита.Пометка 
				И СтрокаВлияющегоРеквизита.ТипИзменения = "УстановитьЗначение"
			Тогда
				Если Не ДляВыбора И ОбщиеЗначенияВлияющихРеквизитов[ВлияющееПоле] <> СтрокаРеквизита.Значение[ИмяРеквизитаОтбора] Тогда
					ирОбщий.СообщитьЛкс(ирОбщий.СтрШаблонЛкс("Изменяемое поле ""%1"" не согласовано с влияющим изменяемым полем ""%2"" при включенных связях параметров выбора.",
						СтрокаРеквизита.Идентификатор, ВлияющееПоле), СтатусСообщения.Внимание);
					Возврат "Запрещено";
				КонецЕсли;
			Иначе 
				Если ОбщиеЗначенияВлияющихРеквизитов[ВлияющееПоле] = Неопределено Тогда
					ирОбщий.СообщитьЛкс(ирОбщий.СтрШаблонЛкс("В таблице строк для обработки поле ""%1"", влияющее на изменяемое поле ""%2"", имеет более одного значения при включенных связях параметров выбора.",
						ВлияющееПоле, СтрокаРеквизита.Идентификатор), СтатусСообщения.Внимание);
					Возврат "Запрещено";
				ИначеЕсли Не ДляВыбора И ОбщиеЗначенияВлияющихРеквизитов[ВлияющееПоле] <> СтрокаРеквизита.Значение[ИмяРеквизитаОтбора] Тогда
					ирОбщий.СообщитьЛкс(ирОбщий.СтрШаблонЛкс("В таблице строк для обработки влияющее поле ""%1"" имеет несогласованное значение с изменяемым полем ""%2"" при включенных связях параметров выбора", 
						ВлияющееПоле, СтрокаРеквизита.Идентификатор), СтатусСообщения.Внимание);
					Возврат "Запрещено";
				КонецЕсли;
				СтрокаВлияющегоРеквизита.Значение = ОбщиеЗначенияВлияющихРеквизитов[ВлияющееПоле];
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	Возврат мОбщиеЗначенияВлияющихРеквизитовВладельца;
КонецФункции

Функция ОбщиеЗначенияВлияющихРеквизитов()
	Если Истина
		И мОбщиеЗначенияВлияющихРеквизитов = Неопределено 
		И Не МноготабличнаяВыборка 
		И СвязиИПараметрыВыбора
	Тогда
		ПрочитатьВлияющиеРеквизиты();
		мОбщиеЗначенияВлияющихРеквизитов = Новый Соответствие;
		мОбщиеЗначенияВлияющихРеквизитовВладельца = Новый Структура;
		ПомеченныеСтрокиДляОбработки = ВладелецФормы.СтрокиДляОбработки;
		Если ВладелецФормы.СтрокиДляОбработки.Найти(Ложь, мИмяКолонкиПометки) <> Неопределено Тогда
			ПомеченныеСтрокиДляОбработки = ПомеченныеСтрокиДляОбработки.Скопировать(Новый Структура(мИмяКолонкиПометки, Истина));
		КонецЕсли;
		Для Каждого КлючИЗначение Из мСтруктураВлияющих Цикл
			ИмяКолонки = ирОбщий.НайтиЭлементКоллекцииЛкс(мСхемаКолонок, "Значение", КлючИЗначение.Значение).Ключ;
			РазличныеЗначенияКолонки = ирОбщий.РазличныеЗначенияКолонкиТаблицыЛкс(ПомеченныеСтрокиДляОбработки, ИмяКолонки);
			Если РазличныеЗначенияКолонки.Количество() = 1 Тогда
				ЗначениеПоля = РазличныеЗначенияКолонки[0];
				мОбщиеЗначенияВлияющихРеквизитов.Вставить(КлючИЗначение.Ключ, ЗначениеПоля);
				Если ЛиТЧ() Тогда
					мОбщиеЗначенияВлияющихРеквизитовВладельца.Вставить(ИмяКолонки, ЗначениеПоля);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	Возврат мОбщиеЗначенияВлияющихРеквизитов;
КонецФункции

Функция ПрочитатьВлияющиеРеквизиты()
	
	Если мСтруктураВлияющих = Неопределено Тогда
		мСтруктураВлияющих = Новый Соответствие;
		ВыполнитьЗапрос = Ложь;
		Для Каждого СтрокаРеквизита Из ЗначенияРеквизитов Цикл
			Если Не ЗначениеЗаполнено(СтрокаРеквизита.СвязиПараметровВыбора) Тогда
				Продолжить;
			КонецЕсли;
			ВлияющиеРеквизиты = ирОбщий.СтрРазделитьЛкс(СтрокаРеквизита.СвязиПараметровВыбора, ",", Истина);
			Для Каждого ВлияющийРеквизит Из ВлияющиеРеквизиты Цикл
				ПолноеИмяПоля = ИмяПоляВлияющегоРеквизита(ВлияющийРеквизит);
				ВыбранноеПоле = ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(Компоновщик.Настройки.Выбор, ПолноеИмяПоля,, Ложь);
				ирОбщий.ПрисвоитьЕслиНеРавноЛкс(ВыбранноеПоле.Использование, Истина, ВыполнитьЗапрос);
				мСтруктураВлияющих.Вставить(ВлияющийРеквизит, ПолноеИмяПоля);
			КонецЦикла;
		КонецЦикла;
		Если Не ВыполнитьЗапрос Тогда
			Если ТипЗнч(ВладелецФормы.СтрокиДляОбработки[0][мИмяКолонкиОтсутствияСтрокиВБД]) <> Тип("Булево") Тогда
				// Пользователь ранее отказался от считывания неключевых колонок или еще не активировал страницу "Строки для обработки"
				ВыполнитьЗапрос = Истина;
			КонецЕсли;
		КонецЕсли;
		Если ВыполнитьЗапрос Тогда
			ВладелецФормы.ОбновитьКоллекциюРезультата();
		КонецЕсли;
	КонецЕсли;

КонецФункции

Функция ЛиТЧ()
	
	Результат = ирОбщий.ЛиТипВложеннойТаблицыБДЛкс(ирОбщий.ТипТаблицыБДЛкс(мИмяТаблицы));
	Возврат Результат;

КонецФункции

Функция КлючИсторииВыбораЗначенияРеквизита()
	
	Результат = ирОбщий.КлючИсторииВыбораЗначенияОтбораЛкс(мИмяТаблицы, ЭлементыФормы.ЗначенияРеквизитов.ТекущаяСтрока.Идентификатор);
	Возврат Результат;

КонецФункции

Процедура КоманднаяПанельРеквизитыЗагрузитьИзОбъекта(Кнопка)
	
	ТипТаблицы = ирОбщий.ТипТаблицыБДЛкс(ОбластьПоиска);
	Если ТипТаблицы = "ТабличнаяЧасть" Тогда
		ОбъектМДВыбораСсылки = мОбъектМД.Родитель();
		лИмяТабличнойЧасти = мОбъектМД.Имя;
	Иначе
		ОбъектМДВыбораСсылки = мОбъектМД;
		лИмяТабличнойЧасти = ИмяТабличнойЧасти;
	КонецЕсли; 
	НачальноеЗначениеСсылки = ВладелецФормы.ПолучитьКлючСтрокиДляОбработки();
	Ссылка = ирОбщий.ВыбратьСсылкуЛкс(ОбъектМДВыбораСсылки, НачальноеЗначениеСсылки);
	Если Ссылка = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	СтруктураКлюча = ирОбщий.СтруктураКлючаТаблицыБДЛкс(ОбластьПоиска,,, Ложь);
	ЗаполнитьЗначенияСвойств(СтруктураКлюча, Ссылка); 
	Если ЗначениеЗаполнено(лИмяТабличнойЧасти) Тогда
		СтрокаРезультата = ирОбщий.ОткрытьТаблицуЗначенийЛкс(Ссылка[лИмяТабличнойЧасти].Выгрузить(),,,, Истина);
		Если СтрокаРезультата = Неопределено Тогда
			Возврат;
		КонецЕсли; 
	Иначе
		СтрокаРезультата = ирОбщий.СтрокаТаблицыБДПоКлючуЛкс(ирКэш.ИмяТаблицыИзМетаданныхЛкс(ОбластьПоиска), СтруктураКлюча);
	КонецЕсли; 
	Для Каждого СтрокаРеквизита Из ЗначенияРеквизитов Цикл
		СтрокаРеквизита.Значение = СтрокаРезультата[СтрокаРеквизита.Идентификатор];
	КонецЦикла; 
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	Если ВладелецФормы <> Неопределено Тогда
		ВладелецФормы.Панель.Доступность = Ложь;
	КонецЕсли;
	НастроитьЭлементыФормы();
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	Если ВладелецФормы <> Неопределено Тогда
		ВладелецФормы.Панель.Доступность = Истина;
		ирОбщий.УстановитьФокусВводаФормеЛкс();
	КонецЕсли; 

КонецПроцедуры

Процедура ЗначенияРеквизитовЗначениеОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	ирОбщий.ПолеВвода_ОкончаниеВводаТекстаЛкс(Элемент, Текст, Значение, СтандартнаяОбработка);

КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ИмяТабличнойЧастиПриИзменении(Элемент)
	
	ЗначенияРеквизитов.Очистить();
	ОбновитьТаблицуРеквизитов();
	
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ЗначенияРеквизитовТипИзмененияПриИзменении(Элемент)
	
	ЭлементыФормы.ЗначенияРеквизитов.ТекущаяСтрока.Пометка = Истина;
	РеквизитыПриНачалеРедактирования(ЭлементыФормы.ЗначенияРеквизитов, Ложь, Ложь);

КонецПроцедуры

Процедура ЗначенияРеквизитовТипИзмененияОчистка(Элемент, СтандартнаяОбработка)
	
	Элемент.Значение = "УстановитьЗначение";
	
КонецПроцедуры

Процедура КоманднаяПанельРеквизитыРедакторОбъектаБД(Кнопка)
	
	Если ЭлементыФормы.ЗначенияРеквизитов.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ЗначениеЯчейки = ЭлементыФормы.ЗначенияРеквизитов.ТекущаяСтрока.Значение;
	Если Не ирОбщий.ЛиСсылкаНаОбъектБДЛкс(ЗначениеЯчейки, Ложь) Тогда
		Возврат;
	КонецЕсли; 
	ирОбщий.ОткрытьСсылкуВРедактореОбъектаБДЛкс(ЗначениеЯчейки);
	
КонецПроцедуры

Процедура ОбработчикОжиданияСПараметрамиЛкс() Экспорт 
	
	ирОбщий.ОбработчикОжиданияСПараметрамиЛкс();

КонецПроцедуры

Процедура ЗначенияРеквизитовВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если Колонка = ЭлементыФормы.ЗначенияРеквизитов.Колонки.ДопРеквизит И ЗначениеЗаполнено(ВыбраннаяСтрока.ДопРеквизит) Тогда
		ОткрытьЗначение(ВыбраннаяСтрока.ДопРеквизит);
	ИначеЕсли Ложь
		Или Колонка = ЭлементыФормы.ЗначенияРеквизитов.Колонки.ОписаниеТипов
	Тогда
		ОписаниеТипов = ПолучитьОписаниеТиповРеквизита(ВыбраннаяСтрока);
		ирОбщий.ЯчейкаТабличногоПоляРасширенногоЗначения_ВыборЛкс(ЭтаФорма, Элемент, СтандартнаяОбработка, ОписаниеТипов,,,, ВыбраннаяСтрока.Синоним);
	ИначеЕсли Колонка = ЭлементыФормы.ЗначенияРеквизитов.Колонки.СвязиПараметровВыбора Тогда 
		Если ЗначениеЗаполнено(ВыбраннаяСтрока.СвязиПараметровВыбора) Тогда
			СписокВыбора = Новый СписокЗначений;
			СписокВыбора.ЗагрузитьЗначения(ирОбщий.СтрРазделитьЛкс(ВыбраннаяСтрока.СвязиПараметровВыбора, ",", Истина));
			СписокВыбора.СортироватьПоЗначению();
			РезультатВыбора = СписокВыбора.ВыбратьЭлемент("Переход к влияющему реквизиту");
			Если РезультатВыбора <> Неопределено Тогда
				НайденнаяСтрока = ЗначенияРеквизитов.Найти(ирОбщий.ПоследнийФрагментЛкс(РезультатВыбора.Значение), "Идентификатор");
				Если НайденнаяСтрока <> Неопределено Тогда
					ЭлементыФормы.ЗначенияРеквизитов.ТекущаяСтрока = НайденнаяСтрока;
					ЭлементыФормы.ЗначенияРеквизитов.ТекущаяКолонка = ЭлементыФормы.ЗначенияРеквизитов.Колонки.Значение;
				КонецЕсли;
			КонецЕсли; 
		КонецЕсли;
	ИначеЕсли Ложь
		Или Колонка = ЭлементыФормы.ЗначенияРеквизитов.Колонки.ТипЗначения
		Или Колонка = ЭлементыФормы.ЗначенияРеквизитов.Колонки.ИмяТипаЗначения
	Тогда 
		ирОбщий.ОткрытьОбъектМДИзТаблицыСИменамиТиповЛкс(ВыбраннаяСтрока);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ЗначенияРеквизитовКлючПоискаПриИзменении(Элемент)
	
	Если ЭлементыФормы.ЗначенияРеквизитов.ТекущаяСтрока.КлючПоиска Тогда
		ЭлементыФормы.ЗначенияРеквизитов.ТекущаяСтрока.Пометка = Истина;
	КонецЕсли; 

КонецПроцедуры

Процедура ЗначенияРеквизитовПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);

КонецПроцедуры

Процедура НастроитьЭлементыФормы()
	
	ЭлементыФормы.ЗначенияРеквизитов.Колонки.ДопРеквизит.Видимость = Истина
		И ирКэш.ЛиДоступныДопРеквизитыБСПЛкс()
		И ирОбщий.ЛиМетаданныеСсылочногоОбъектаЛкс(мОбъектМД);
	ЭлементыФормы.ИзменятьИзмерения.Доступность = Истина
		И мОбъектМД <> Неопределено 
		И ирОбщий.ЛиМетаданныеНезависимогоРегистраЛкс(мОбъектМД);
	ЭлементыФормы.ЗаменятьСуществующие.Доступность = ИзменятьИзмерения И ЭлементыФормы.ИзменятьИзмерения.Доступность;

КонецПроцедуры

Процедура ИзменятьИзмеренияПриИзменении(Элемент)
	
	ОбновитьТаблицуРеквизитов();

КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирОбщий.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура ГлавнаяКоманднаяПанельОбучающееВидео(Кнопка)
	
	ЗапуститьПриложение("https://www.youtube.com/watch?v=MgDXX-qUrx0&t=913s");
	
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Ответ = ирОбщий.ЗапроситьСохранениеДанныхФормыЛкс(ЭтаФорма, Отказ);
	Если Ответ = КодВозвратаДиалога.Да Тогда
		вСохранитьНастройку();
	КонецЕсли;
	
КонецПроцедуры

ирОбщий.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирПодборИОбработкаОбъектов.Форма.ИзменитьДобавитьСтроку");
мИспользоватьНастройки = Истина;
мИменаПредставления = ИмяСиноним;
СвязиИПараметрыВыбора = Истина;

//Реквизиты настройки и значения по умолчанию.
мНастройка = Новый Структура("РеквизитыДляСохранения, ОбрабатыватьСуществующую, ПринудительнаяЗапись, ИмяТабличнойЧасти, ИзменятьИзмерения, ЗаменятьСуществующие");
