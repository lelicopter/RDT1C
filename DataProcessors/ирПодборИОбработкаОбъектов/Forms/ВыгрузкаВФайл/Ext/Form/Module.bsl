﻿//Признак использования настроек
Перем мИспользоватьНастройки Экспорт;

//Типы объектов, для которых может использоваться обработка.
//По умолчанию для всех.
Перем мТипыОбрабатываемыхОбъектов Экспорт;

Перем мНастройка;

Перем мВыгрузкаЗагрузкаДанныхЧерезФайл;

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ПередОбработкойВсех(ПараметрыОбработки) Экспорт 

	#Если Сервер И Не Сервер Тогда
		мВыгрузкаЗагрузкаДанныхЧерезФайл = Обработки.ирВыгрузкаЗагрузкаДанныхЧерезФайл.Создать();
	#КонецЕсли
	мВыгрузкаЗагрузкаДанныхЧерезФайл.ИмяФайла = ИмяФайла;
	мВыгрузкаЗагрузкаДанныхЧерезФайл.ИспользоватьXDTO = ИспользоватьXDTO;
	мВыгрузкаЗагрузкаДанныхЧерезФайл.ПередВыгрузкойВсех(ПараметрыОбработки);

КонецПроцедуры // ПередГрупповойОбработкой() 

Процедура ПослеОбработкиВсех(ПараметрыОбработки) Экспорт 

	#Если Сервер И Не Сервер Тогда
		мВыгрузкаЗагрузкаДанныхЧерезФайл = Обработки.ирВыгрузкаЗагрузкаДанныхЧерезФайл.Создать();
	#КонецЕсли
	мВыгрузкаЗагрузкаДанныхЧерезФайл.ПослеВыгрузкиВсех(ПараметрыОбработки);

КонецПроцедуры // ПередГрупповойОбработкой() 

// Выполняет обработку строки таблицы.
//
// Параметры:
//  Объект - обрабатываемая строка таблицы;
//  *КоллекцияСтрок - ТабличнаяЧасть, НаборЗаписей - передается для возможности удаления строки из коллекции;
//
Процедура вОбработатьОбъект(Знач Объект, Знач КоллекцияСтрок = Неопределено, Знач ОбъектБД = Неопределено, Знач ПараметрыОбработки = Неопределено) Экспорт

	ВыгрузитьОбъектБД(ПараметрыОбработки.ЗаписьXML, Объект, ПараметрыОбработки.СчетчикВыгруженныхОбъектов);
	Если ВыгружатьДвиженияВместеСДокументами Тогда
		ОбъектМД = Объект.Метаданные();
		Если ирОбщий.ЛиКорневойТипДокументаЛкс(ирОбщий.ПолучитьПервыйФрагментЛкс(ОбъектМД.ПолноеИмя())) Тогда
			ОбъектыМД = ирОбщий.ПолучитьМетаданныеНаборовЗаписейПоРегистраторуЛкс(ОбъектМД);
			Для Каждого МетаРегистр из ОбъектыМД Цикл
				ПолноеИмяМД = МетаРегистр.ПолноеИмя();
				НаборЗаписей = Новый (СтрЗаменить(ПолноеИмяМД, ".", "НаборЗаписей."));
				НаборЗаписей.Отбор.Регистратор.Установить(Объект.Ссылка);
				НаборЗаписей.Прочитать();
				ВыгрузитьОбъектБД(ПараметрыОбработки.ЗаписьXML, НаборЗаписей, ПараметрыОбработки.СчетчикВыгруженныхОбъектов);
			КонецЦикла;
		КонецЕсли; 
	КонецЕсли;

КонецПроцедуры // ОбработатьОбъект()

Процедура ВыгрузитьОбъектБД(Знач ЗаписьXML, Знач ОбъектБД, СчетчикВыгруженныхОбъектов) Экспорт 
	
    Если ИспользоватьXDTO Тогда
        СериализаторXDTO.ЗаписатьXML(ЗаписьXML, ОбъектБД);
    Иначе 
        ЗаписатьXML(ЗаписьXML, ОбъектБД);
    КонецЕсли; 
	СчетчикВыгруженныхОбъектов = СчетчикВыгруженныхОбъектов + 1;

КонецПроцедуры // ВыполнитьВыгрузку()

// Сохраняет значения реквизитов формы.
//
// Параметры:
//  Нет.
//
Процедура вСохранитьНастройку() Экспорт

	Если ПустаяСтрока(ЭлементыФормы.ТекущаяНастройка) Тогда
		Предупреждение("Задайте имя новой настройки для сохранения или выберите существующую настройку для перезаписи.");
	КонецЕсли;

    НоваяНастройка = Новый Структура();
	
	Для каждого РеквизитНастройки из мНастройка Цикл
		Выполнить("НоваяНастройка.Вставить(Строка(РеквизитНастройки.Ключ), " + Строка(РеквизитНастройки.Ключ) + ");");
	КонецЦикла;

	Если      ТекущаяНастройка.Родитель = Неопределено Тогда
		
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
        Если НЕ ТекущаяНастройка.Настройка = Неопределено Тогда
			мНастройка = ТекущаяНастройка.Настройка;
		КонецЕсли;
	КонецЕсли;

	Для каждого РеквизитНастройки из мНастройка Цикл
        Значение = мНастройка[РеквизитНастройки.Ключ];
		Выполнить(Строка(РеквизитНастройки.Ключ) + " = Значение;");
	КонецЦикла;
    
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
	КонецЕсли;

КонецПроцедуры // ПередОткрытием()

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

// Обработчик действия "Выполнить" командной панели "ОсновныеДействияФормы".
//
Процедура ОсновныеДействияФормыВыполнить(Кнопка)

	вВыполнитьОбработку();

КонецПроцедуры // ОсновныеДействияФормыВыполнить()
			   
Функция вВыполнитьОбработку() Экспорт
	
	ОбработаноОбъектов = вВыполнитьГрупповуюОбработку(ЭтаФорма);
	Возврат ОбработаноОбъектов;
	
КонецФункции

// Обработчик действия "СохранитьНастройку" командной панели "ОсновныеДействияФормы".
//
Процедура ОсновныеДействияФормыСохранитьНастройку(Кнопка)

	вСохранитьНастройку();

КонецПроцедуры // ОсновныеДействияФормыСохранитьНастройку()

Процедура ИмяФайлаПриИзменении(Элемент)
	
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, Метаданные().Имя + ".ВыгрузкаВФайл");

КонецПроцедуры

Процедура ИмяФайлаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, Метаданные().Имя + ".ВыгрузкаВФайл");

КонецПроцедуры

Процедура ИмяФайлаНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ПолноеИмяФайла = ирОбщий.ВыбратьФайлЛкс(, "zip",, Элемент.Значение);
	Если ПолноеИмяФайла = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ирОбщий.ИнтерактивноЗаписатьВЭлементУправленияЛкс(Элемент, ПолноеИмяФайла);
	
КонецПроцедуры

Процедура ИмяФайлаОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗапуститьПриложение(Элемент.Значение);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ИНИЦИАЛИЗАЦИЯ МОДУЛЬНЫХ ПЕРЕМЕННЫХ

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирПодборИОбработкаОбъектов.Форма.ПеренумерацияОбъектов");
мИспользоватьНастройки = Истина;

//Реквизиты настройки и значения по умолчанию.
мНастройка = Новый Структура("ВыгружатьДвиженияВместеСДокументами,ИспользоватьXDTO,ИмяФайла");
мНастройка.ВыгружатьДвиженияВместеСДокументами = Ложь;
мНастройка.ИспользоватьXDTO = Ложь;

мТипыОбрабатываемыхОбъектов = Неопределено;

мВыгрузкаЗагрузкаДанныхЧерезФайл = ирОбщий.ПолучитьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирВыгрузкаЗагрузкаДанныхЧерезФайл");
