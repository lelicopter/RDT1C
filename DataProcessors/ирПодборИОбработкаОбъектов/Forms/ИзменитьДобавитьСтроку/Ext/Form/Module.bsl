﻿//Признак использования настроек
Перем мИспользоватьНастройки Экспорт;

//Типы объектов, для которых может использоваться обработка.
//По умолчанию для всех.
Перем мТипыОбрабатываемыхОбъектов Экспорт;
Перем мПоляТаблицыБД Экспорт;
Перем мИменаПредставления;
Перем мНастройка;
Перем мОбъектМД;
Перем мИмяТаблицы;

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ПередОбработкойВсех(ПараметрыОбработки) Экспорт 
	
КонецПроцедуры

Процедура ПослеОбработкиВсех(ПараметрыОбработки) Экспорт 
	
КонецПроцедуры

// Выполняет обработку строки таблицы.
//
// Параметры:
//  Объект - обрабатываемая строка таблицы;
//  *КоллекцияСтрок - ТабличнаяЧасть, НаборЗаписей - передается для возможности удаления строки из коллекции;
//
Процедура вОбработатьОбъект(Знач Объект, Знач КоллекцияСтрок = Неопределено, Знач ОбъектБД = Неопределено, Знач ПараметрыОбработки = Неопределено) Экспорт

	Если ЗначениеЗаполнено(ИмяТабличнойЧасти) Тогда
		КлючПоиска = Новый Структура;
		Для Каждого РеквизитПоиска Из ЗначенияРеквизитов.НайтиСтроки(Новый Структура("Пометка, КлючПоиска, ТипИзменения", Истина, Истина, "УстановитьЗначение")) Цикл
			КлючПоиска.Вставить(РеквизитПоиска.Идентификатор, РеквизитПоиска.Значение);
		КонецЦикла;
		НайденныеСтрокиТЧ = Объект[ИмяТабличнойЧасти].НайтиСтроки(КлючПоиска);
		Если НайденныеСтрокиТЧ.Количество() > 1 Тогда
			ВызватьИсключение "Найдено более одной строки по реквизитам поиска";
			Возврат;
		ИначеЕсли НайденныеСтрокиТЧ.Количество() = 0 Тогда
			Объект = Объект[ИмяТабличнойЧасти].Добавить();
			ЗаполнитьЗначенияСвойств(Объект, КлючПоиска); 
		ИначеЕсли Не ОбрабатыватьСуществующую Тогда 
			Возврат;
		Иначе
			Объект = НайденныеСтрокиТЧ[0];
		КонецЕсли; 
	КонецЕсли;
	Для каждого СтрокаРеквизита из ЗначенияРеквизитов Цикл
		Если СтрокаРеквизита.Пометка Тогда
			Если Ложь
				Или СтрокаРеквизита.Использование = ""
				Или СтрокаРеквизита.Использование = "ДляГруппыИЭлемента"
				Или (Объект.ЭтоГруппа И СтрокаРеквизита.Использование = "ДляГруппы")
				Или (Не Объект.ЭтоГруппа И СтрокаРеквизита.Использование = "ДляЭлемента")
			Тогда
				ТекущееЗначение = Объект[СтрокаРеквизита.Идентификатор];
				НовоеЗначение = СтрокаРеквизита.Значение;
				Если СтрокаРеквизита.ТипИзменения = "Округлить" Тогда
					НовоеЗначение = Окр(ТекущееЗначение);
				ИначеЕсли СтрокаРеквизита.ТипИзменения = "УстановитьЦелуюЧасть" Тогда
					НовоеЗначение = Цел(НовоеЗначение) + ТекущееЗначение - Цел(ТекущееЗначение);
				ИначеЕсли СтрокаРеквизита.ТипИзменения = "УстановитьДробнуюЧасть" Тогда
					НовоеЗначение = НовоеЗначение - Цел(НовоеЗначение) + Цел(ТекущееЗначение);
				ИначеЕсли СтрокаРеквизита.ТипИзменения = "УстановитьВремя" Тогда
					НовоеЗначение = Дата(Год(ТекущееЗначение), Месяц(ТекущееЗначение), День(ТекущееЗначение), Час(НовоеЗначение), Минута(НовоеЗначение), Секунда(НовоеЗначение));
				ИначеЕсли СтрокаРеквизита.ТипИзменения = "УстановитьДату" Тогда
					НовоеЗначение = Дата(Год(НовоеЗначение), Месяц(НовоеЗначение), День(НовоеЗначение), Час(ТекущееЗначение), Минута(ТекущееЗначение), Секунда(ТекущееЗначение));
				ИначеЕсли СтрокаРеквизита.ТипИзменения = "СдвинутьВНачалоДня" Тогда
					НовоеЗначение = НачалоДня(ТекущееЗначение);
				ИначеЕсли СтрокаРеквизита.ТипИзменения = "СдвинутьВКонецДня" Тогда
					НовоеЗначение = КонецДня(ТекущееЗначение);
				ИначеЕсли СтрокаРеквизита.ТипИзменения = "СдвинутьВНачалоМесяца" Тогда
					НовоеЗначение = НачалоМесяца(ТекущееЗначение);
				ИначеЕсли СтрокаРеквизита.ТипИзменения = "СдвинутьВКонецМесяца" Тогда
					НовоеЗначение = КонецМесяца(ТекущееЗначение);
				ИначеЕсли СтрокаРеквизита.ТипИзменения = "СдвинутьВНачалоГода" Тогда
					НовоеЗначение = НачалоГода(ТекущееЗначение);
				ИначеЕсли СтрокаРеквизита.ТипИзменения = "СдвинутьВКонецГода" Тогда
					НовоеЗначение = КонецГода(ТекущееЗначение);
				ИначеЕсли СтрокаРеквизита.ТипИзменения = "ИнвертироватьЗначение" Тогда
					НовоеЗначение = Не ТекущееЗначение;
				КонецЕсли; 
				Объект[СтрокаРеквизита.Идентификатор] = НовоеЗначение;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	// Антибаг 8.2.15 http://partners.v8.1c.ru/forum/thread.jsp?id=1034144#1034144
	Если ЗначенияРеквизитов.Найти(Истина, "Пометка") <> Неопределено Тогда
		Попытка
			Объект.Период = Объект.Период;
		Исключение
			Попытка
				Объект.Регистратор = Объект.Регистратор;
			Исключение
			КонецПопытки; 
		КонецПопытки; 
	КонецЕсли; 

КонецПроцедуры // ОбработатьОбъект()

// Сохраняет значения реквизитов формы.
//
// Параметры:
//  Нет.
//
Процедура вСохранитьНастройку() Экспорт

	//Если ПустаяСтрока(ЭлементыФормы.ТекущаяНастройка) Тогда
	//	Предупреждение("Задайте имя новой настройки для сохранения или выберите существующую настройку для перезаписи.");
	//КонецЕсли;
	Если ЭлементыФормы.ТекущаяНастройка.Значение = мИмяНастройкиПоУмолчанию Тогда
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
	
    НоваяНастройка = Новый Структура();

	РеквизитыДляСохранения = ЗначенияРеквизитов.Выгрузить(Новый Структура("Пометка", Истина));
	
	Для каждого РеквизитНастройки из мНастройка Цикл
		Выполнить("НоваяНастройка.Вставить(Строка(РеквизитНастройки.Ключ), " + Строка(РеквизитНастройки.Ключ) + ");");
	КонецЦикла;

	Если ТекущаяНастройка.Родитель = Неопределено Тогда
		
		НоваяСтрока = ТекущаяНастройка.Строки.Добавить();
		НоваяСтрока.Обработка = ЭлементыФормы.ТекущаяНастройка.Значение;
		ТекущаяНастройка = НоваяСтрока;
		ЭтаФорма.ВладелецФормы.ЭлементыФормы.ДоступныеОбработки.ТекущаяСтрока = НоваяСтрока;
		
	ИначеЕсли НЕ ТекущаяНастройка.Обработка = ЭлементыФормы.ТекущаяНастройка.Значение Тогда
		
		НоваяСтрока           = ТекущаяНастройка.Родитель.Строки.Добавить();
		НоваяСтрока.Обработка = ЭлементыФормы.ТекущаяНастройка.Значение;
		ТекущаяНастройка      = НоваяСтрока;
		ЭтаФорма.ВладелецФормы.ЭлементыФормы.ДоступныеОбработки.ТекущаяСтрока = НоваяСтрока;
		
	КонецЕсли;
	
	ТекущаяНастройка.Настройка = НоваяНастройка;
	
	ЭтаФорма.Модифицированность = Ложь;

КонецПроцедуры // вСохранитьНастройку()

// Восстанавливает сохраненные значения реквизитов формы.
//
// Параметры:
//  Нет.
//
Процедура вЗагрузитьНастройку() Экспорт

	Если Ложь
		Или ТекущаяНастройка = Неопределено
		Или ТекущаяНастройка.Родитель = Неопределено 
	Тогда
		вУстановитьИмяНастройки(мИмяНастройкиПоУмолчанию);
	Иначе
		Если ТекущаяНастройка.Настройка <> Неопределено Тогда
			мНастройка = ТекущаяНастройка.Настройка;
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
	
КонецПроцедуры //вЗагрузитьНастройку()

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

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

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
	ЭлементыФормы.ЗначенияРеквизитов.Колонки.Использование.Видимость = Истина
		И мОбъектМД <> Неопределено
		И ирОбщий.ЛиМетаданныеОбъектаСГруппамиЛкс(мОбъектМД);
	ОбновитьКолонки();
	
	ТипТаблицы = ирОбщий.ПолучитьТипТаблицыБДЛкс(ОбластьПоиска);
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
	Если Не ЗначениеЗаполнено(мИмяТаблицы) Тогда
		мИмяТаблицы = ирОбщий.ПолучитьИмяТаблицыИзМетаданныхЛкс(мОбъектМД);
	КонецЕсли; 
	СписокВыбораТЧ = ЭлементыФормы.ИмяТабличнойЧасти.СписокВыбора;
	СписокВыбораТЧ.Очистить();
	ТабличныеЧастиОбъекта = ирОбщий.ПолучитьТабличныеЧастиОбъектаЛкс(мОбъектМД);
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
	
	СтруктураКлюча = ирОбщий.ПолучитьСтруктуруКлючаТаблицыБДЛкс(мИмяТаблицы);
	мПоляТаблицыБД = ирКэш.ПолучитьПоляТаблицыБДЛкс(мИмяТаблицы);
	#Если Сервер И Не Сервер Тогда
		мПоляТаблицыБД = ПолучитьСтруктуруХраненияБазыДанных().Колонки;
	#КонецЕсли
	Для Каждого ПолеТаблицыБД Из мПоляТаблицыБД Цикл
		Если ПолеТаблицыБД.ТипЗначения.СодержитТип(Тип("ТаблицаЗначений")) Тогда
			Продолжить;
		КонецЕсли;
		Если СтруктураКлюча.Свойство(ПолеТаблицыБД.Имя) Тогда
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
		Если ирОбщий.ЛиКорневойТипКонстантыЛкс(ИскомыйОбъект.ТипТаблицы) Тогда
			СтрокаРеквизита.Синоним = "Значение";
		КонецЕсли; 
		СтрокаРеквизита.Использование = Метаданные.СвойстваОбъектов.ИспользованиеРеквизита.ДляГруппыИЭлемента;
		Если мОбъектМД <> Неопределено И Не ЗначениеЗаполнено(ИмяТабличнойЧасти)  Тогда
			Если ирОбщий.ЛиМетаданныеОбъектаСГруппамиЛкс(мОбъектМД) Тогда
				МетаРеквизит = мОбъектМД.Реквизиты.Найти(СтрокаРеквизита.Идентификатор);
				//Если МетаРеквизит = Неопределено Тогда
				//	МетаРеквизит = Метаданные.ОбщиеРеквизиты.Найти(СтрокаРеквизита.Идентификатор);
				//КонецЕсли;
				Если МетаРеквизит <> Неопределено Тогда
					СтрокаРеквизита.Использование = МетаРеквизит.Использование;
				КонецЕсли;
			КонецЕсли; 
		КонецЕсли; 
	КонецЦикла;
	МассивКУдалению = Новый Массив();
	Для Каждого СтрокаРеквизита Из ЗначенияРеквизитов Цикл
		ПолеТаблицыБД = мПоляТаблицыБД.Найти(СтрокаРеквизита.Идентификатор, "Имя");
		Если ПолеТаблицыБД <> Неопределено Тогда
			Если СтруктураКлюча.Свойство(ПолеТаблицыБД.Имя) Тогда
				ПолеТаблицыБД = Неопределено;
			КонецЕсли;
		КонецЕсли; 
		СтрокаРеквизита.Сопоставлен = ПолеТаблицыБД <> Неопределено;
		Если Не СтрокаРеквизита.Сопоставлен Тогда
			СтрокаРеквизита.Использование = "ОтсутствуетВДанных";
		КонецЕсли; 
		Если Не СтрокаРеквизита.Сопоставлен Тогда
			СтрокаРеквизита.Пометка = Ложь;
		КонецЕсли; 
		ОбновитьТипЗначенияВСтрокеТаблицы(СтрокаРеквизита);
	КонецЦикла;
	ЗначенияРеквизитов.Сортировать("Сопоставлен Убыв, " + ПолучитьИмяКолонкиПредставления());

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ, ВЫЗЫВАЕМЫЕ ИЗ ЭЛЕМЕНТОВ ФОРМЫ

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

Функция вВыполнитьОбработку() Экспорт
	
	ОбработаноОбъектов = вВыполнитьГрупповуюОбработку(ЭтаФорма);
	Возврат ОбработаноОбъектов;
	
КонецФункции

// Обработчик действия "Выполнить" командной панели "ОсновныеДействияФормы".
//
Процедура ОсновныеДействияФормыВыполнить(Кнопка)

	Если РежимОбходаДанных = "Строки" И Не ЗначениеЗаполнено(ИмяТабличнойЧасти) Тогда
		Для каждого СтрокаРеквизита из ЗначенияРеквизитов Цикл
			Если Истина
				И СтрокаРеквизита.Пометка 
				И НайденныеОбъекты.Колонки.Найти(СтрокаРеквизита.Идентификатор) = Неопределено
			Тогда
				ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(ЭтаФорма.ВладелецФормы.Компоновщик.Настройки.Выбор, СтрокаРеквизита.Идентификатор);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли; 
	ОбработаноОбъектов = вВыполнитьОбработку();

КонецПроцедуры // ОсновныеДействияФормыВыполнить()

// Обработчик действия "СохранитьНастройку" командной панели "ОсновныеДействияФормы".
//
Процедура ОсновныеДействияФормыСохранитьНастройку(Кнопка)

	вСохранитьНастройку();

КонецПроцедуры // ОсновныеДействияФормыСохранитьНастройку()

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
	СписокВыбораТипаИзменения = ЭлементыФормы.ЗначенияРеквизитов.Колонки.ТипИзменения.ЭлементУправления.СписокВыбора;
	#Если Сервер И Не Сервер Тогда
	    СписокВыбораТипаИзменения = Новый СписокЗначений;
	#КонецЕсли
	СписокВыбораТипаИзменения.Очистить();
	Если ОписаниеТиповРеквизита.СодержитТип(Тип("Дата")) Тогда
		СписокВыбораТипаИзменения.Добавить("УстановитьЗначение", "Установить значение");
		Если ОписаниеТиповРеквизита.КвалификаторыДаты.ЧастиДаты = ЧастиДаты.ДатаВремя Тогда
			СписокВыбораТипаИзменения.Добавить("УстановитьВремя", "Установить только время");
			СписокВыбораТипаИзменения.Добавить("УстановитьДату", "Установить только дату");
		КонецЕсли; 
		Если ОписаниеТиповРеквизита.КвалификаторыДаты.ЧастиДаты <> ЧастиДаты.Дата Тогда
			СписокВыбораТипаИзменения.Добавить("СдвинутьВКонецДня", "Сдвинуть в конец дня");
			СписокВыбораТипаИзменения.Добавить("СдвинутьВНачалоДня", "Сдвинуть в начало дня");
		КонецЕсли; 
		Если ОписаниеТиповРеквизита.КвалификаторыДаты.ЧастиДаты <> ЧастиДаты.Время Тогда
			СписокВыбораТипаИзменения.Добавить("СдвинутьВКонецМесяца", "Сдвинуть в конец месяца");
			СписокВыбораТипаИзменения.Добавить("СдвинутьВНачалоМесяца", "Сдвинуть в начало месяца");
			СписокВыбораТипаИзменения.Добавить("СдвинутьВКонецГода", "Сдвинуть в конец года");
			СписокВыбораТипаИзменения.Добавить("СдвинутьВНачалоГода", "Сдвинуть в начало года");
		КонецЕсли;
	ИначеЕсли ОписаниеТиповРеквизита.СодержитТип(Тип("Булево")) Тогда
		СписокВыбораТипаИзменения.Добавить("УстановитьЗначение", "Установить значение");
		СписокВыбораТипаИзменения.Добавить("ИнвертироватьЗначение", "Инвертировать значение");
	ИначеЕсли ОписаниеТиповРеквизита.СодержитТип(Тип("Число")) Тогда
		СписокВыбораТипаИзменения.Добавить("УстановитьЗначение", "Установить значение");
		СписокВыбораТипаИзменения.Добавить("УстановитьДробнуюЧасть", "Установить дробную часть");
		СписокВыбораТипаИзменения.Добавить("УстановитьЦелуюЧасть", "Установить целую часть");
		СписокВыбораТипаИзменения.Добавить("Округлить", "Округлить");
	КонецЕсли; 
	
КонецПроцедуры

// Обработчик действия "ПриВыводеСтроки" табличного поля "ЗначенияРеквизитов".
//
Процедура РеквизитыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
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
		ОформлениеСтроки.ЦветФона = WebЦвета.СветлоРозовый;
		ОформлениеСтроки.Ячейки.Пометка.ТолькоПросмотр = Истина;
	КонецЕсли;
	//ПредставлениеТипаИзменения = ЭлементыФормы.ЗначенияРеквизитов.Колонки.ТипИзменения.ЭлементУправления.СписокВыбора.НайтиПоЗначению(ДанныеСтроки.ТипИзменения).Представление;
	//ОформлениеСтроки.Ячейки.ТипИзменения.УстановитьТекст(ПредставлениеТипаИзменения);
	ирОбщий.ТабличноеПоле_ОтобразитьФлажкиЛкс(ОформлениеСтроки, "Значение");
	ирОбщий.ТабличноеПоле_ОтобразитьПиктограммыТиповЛкс(ОформлениеСтроки, "Значение");
	ОписаниеТипов = ПолучитьОписаниеТиповРеквизита(ДанныеСтроки);
	ирОбщий.ОформитьЯчейкуСРасширеннымЗначениемЛкс(ОформлениеСтроки.Ячейки.ОписаниеТипов, ОписаниеТипов,, Ложь);

КонецПроцедуры

// Обработчик действия "СнятьФлажки" командной панели "КоманднаяПанельРеквизиты".
//
Процедура КоманднаяПанельРеквизитыСнятьФлажки(Кнопка)

	ирОбщий.ИзменитьПометкиВыделенныхСтрокЛкс(ЭлементыФормы.ЗначенияРеквизитов, , Ложь);

КонецПроцедуры // КоманднаяПанельРеквизитыСнятьФлажки()

Процедура ЗначенияРеквизитовЗначениеПриИзменении(Элемент)
	
	Если ЭлементыФормы.ЗначенияРеквизитов.ТекущаяСтрока.Сопоставлен Тогда
		ЭлементыФормы.ЗначенияРеквизитов.ТекущаяСтрока.Пометка = Истина;
	КонецЕсли; 
	ОбновитьТипЗначенияВСтрокеТаблицы();
	
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
	
	Кнопка.Пометка = Не Кнопка.Пометка;
	мИменаПредставления = Кнопка.Пометка;
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
	
	Если Колонка = ЭлементыФормы.ЗначенияРеквизитов.Колонки.КлючПоиска И ЭлементыФормы.ЗначенияРеквизитов.ТекущаяСтрока.КлючПоиска Тогда
		ЭлементыФормы.ЗначенияРеквизитов.ТекущаяСтрока.Пометка = Истина;
	КонецЕсли; 
	ирОбщий.ТабличноеПоле__ПриИзмененииФлажкаЛкс(Элемент, Колонка);

КонецПроцедуры

Процедура ЗначенияРеквизитовЗначениеНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	Если СвязиИПараметрыВыбора Тогда
		МетаРеквизит = мПоляТаблицыБД.Найти(ЭлементыФормы.ЗначенияРеквизитов.ТекущаяСтрока.Идентификатор, "Имя").Метаданные;
		СтруктураРеквизитов = Новый Структура;
		Для Каждого СтрокаРеквизита Из ЗначенияРеквизитов Цикл
			СтруктураРеквизитов.Вставить(СтрокаРеквизита.Идентификатор, СтрокаРеквизита.Значение);
		КонецЦикла;
		СтруктураОтбора = ирОбщий.ПолучитьСтруктуруОтбораПоСвязямИПараметрамВыбораЛкс(СтруктураРеквизитов, МетаРеквизит);
	КонецЕсли; 
	Если ирОбщий.ПолеВводаКолонкиРасширенногоЗначения_НачалоВыбораЛкс(ЭлементыФормы.ЗначенияРеквизитов, СтандартнаяОбработка, , Истина, СтруктураОтбора) Тогда 
		ОбновитьТипЗначенияВСтрокеТаблицы();
	КонецЕсли; 
	
КонецПроцедуры

Процедура КоманднаяПанельРеквизитыЗагрузитьИзОбъекта(Кнопка)
	
	ТипТаблицы = ирОбщий.ПолучитьТипТаблицыБДЛкс(ОбластьПоиска);
	Если ТипТаблицы = "ТабличнаяЧасть" Тогда
		ОбъектМДВыбораСсылки = мОбъектМД.Родитель();
		лИмяТабличнойЧасти = мОбъектМД.Имя;
	Иначе
		ОбъектМДВыбораСсылки = мОбъектМД;
		лИмяТабличнойЧасти = ИмяТабличнойЧасти;
	КонецЕсли; 
	Ссылка = ирОбщий.ВыбратьСсылкуЛкс(ОбъектМДВыбораСсылки);
	Если Ссылка = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	СтруктураКлюча = ирОбщий.ПолучитьСтруктуруКлючаТаблицыБДЛкс(ОбластьПоиска,,, Ложь);
	ЗаполнитьЗначенияСвойств(СтруктураКлюча, Ссылка); 
	Если Ссылка <> Неопределено Тогда
		Если ЗначениеЗаполнено(лИмяТабличнойЧасти) Тогда
			СтрокаРезультата = Ссылка[лИмяТабличнойЧасти].Выгрузить().ВыбратьСтроку();
			Если СтрокаРезультата = Неопределено Тогда
				Возврат;
			КонецЕсли; 
		Иначе
			СтрокаРезультата = ирОбщий.ПолучитьСтрокуТаблицыБДПоКлючуЛкс(ирОбщий.ПолучитьИмяТаблицыИзМетаданныхЛкс(ОбластьПоиска), СтруктураКлюча);
		КонецЕсли; 
		Для Каждого СтрокаРеквизита Из ЗначенияРеквизитов Цикл
			СтрокаРеквизита.Значение = СтрокаРезультата[СтрокаРеквизита.Идентификатор];
		КонецЦикла; 
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	Если ВладелецФормы <> Неопределено Тогда
		ВладелецФормы.Панель.Доступность = Ложь;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	Если ВладелецФормы <> Неопределено Тогда
		ВладелецФормы.Панель.Доступность = Истина;
	КонецЕсли; 

КонецПроцедуры

Процедура ЗначенияРеквизитовЗначениеОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	ирОбщий.ПолеВвода_ОкончаниеВводаТекстаЛкс(Элемент, Текст, Значение, СтандартнаяОбработка);

КонецПроцедуры

Процедура КлсУниверсальнаяКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработчикОжиданияСПараметрамиЛкс() Экспорт 
	
	ирОбщий.ОбработчикОжиданияСПараметрамиЛкс();

КонецПроцедуры

Процедура ИмяТабличнойЧастиПриИзменении(Элемент)
	
	ЗначенияРеквизитов.Очистить();
	ОбновитьТаблицуРеквизитов();
	
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура КоманднаяПанельРеквизитыУстановитьФлажки(Кнопка)
	
	ирОбщий.ИзменитьПометкиВыделенныхСтрокЛкс(ЭлементыФормы.ЗначенияРеквизитов, , Истина);

КонецПроцедуры

Процедура ЗначенияРеквизитовТипИзмененияПриИзменении(Элемент)
	
	ЭлементыФормы.ЗначенияРеквизитов.ТекущаяСтрока.Пометка = Истина;
	РеквизитыПриНачалеРедактирования(ЭлементыФормы.ЗначенияРеквизитов, Ложь, Ложь);

КонецПроцедуры

Процедура ЗначенияРеквизитовТипИзмененияОчистка(Элемент, СтандартнаяОбработка)
	
	Элемент.Значение = "УстановитьЗначение";
	
КонецПроцедуры

Процедура КоманднаяПанельРеквизитыМенеджерТабличногоПоля(Кнопка)
	
	ирОбщий.ОткрытьМенеджерТабличногоПоляЛкс(ЭлементыФормы.ЗначенияРеквизитов, ЭтаФорма);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ИНИЦИАЛИЗАЦИЯ МОДУЛЬНЫХ ПЕРЕМЕННЫХ

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирПодборИОбработкаОбъектов.Форма.ИзменитьДобавитьСтроку");
мИспользоватьНастройки = Истина;
мИменаПредставления = Ложь;
СвязиИПараметрыВыбора = Истина;

//Реквизиты настройки и значения по умолчанию.
мНастройка = Новый Структура("РеквизитыДляСохранения, ОбрабатыватьСуществующую, ИмяТабличнойЧасти");
мТипыОбрабатываемыхОбъектов = Неопределено;
