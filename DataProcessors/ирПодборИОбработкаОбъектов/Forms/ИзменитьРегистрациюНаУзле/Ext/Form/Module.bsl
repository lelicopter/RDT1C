﻿//Признак использования настроек
Перем мИспользоватьНастройки Экспорт;
Перем мНастройка;

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

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
		АвтоИмяНастройки = АвтоИмяНастройки + "Узел = " + Узел;
		Если НовоеЗначениеРегистрации Тогда
			АвтоИмяНастройки = АвтоИмяНастройки + ", добавить регистрацию";
		Иначе
			АвтоИмяНастройки = АвтоИмяНастройки + ", удалить регистрацию";
		КонецЕсли; 
		вУстановитьИмяНастройки(АвтоИмяНастройки);
	КонецЕсли; 
	СохранитьНастройкуОбработки(ЭтаФорма);

КонецПроцедуры

Функция ПолучитьНастройкуЛкс() Экспорт 
	
	НоваяНастройка = Новый Структура();
	Для каждого РеквизитНастройки из мНастройка Цикл
		Выполнить("НоваяНастройка.Вставить(Строка(РеквизитНастройки.Ключ), " + Строка(РеквизитНастройки.Ключ) + ");");
	КонецЦикла;
	Возврат НоваяНастройка;

КонецФункции // вСохранитьНастройку()

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
			ирОбщий.СкопироватьУниверсальнуюКоллекциюЛкс(ТекущаяНастройка.Настройка, мНастройка);
		КонецЕсли;
	КонецЕсли;

	Для каждого РеквизитНастройки из мНастройка Цикл
        Значение = мНастройка[РеквизитНастройки.Ключ];
		Выполнить("ЭтаФорма." + Строка(РеквизитНастройки.Ключ) + " = Значение;");
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

	Если ВладелецФормы <> Неопределено Тогда
		ЭтаФорма.Узел = ВладелецФормы.УзелОтбораОбъектов;
	КонецЕсли; 
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

КонецПроцедуры

Процедура вВыполнитьОбработку() Экспорт 
	
	ОбщиеПараметрыОбработки = ОбщиеПараметрыОбработки();
	ирОбщий.ПодборИОбработкаОбъектов_ВыполнитьОбработкуЛкс("ИзменитьРегистрациюНаУзле", ОбщиеПараметрыОбработки, ПолучитьНастройкуЛкс(),, ЭтаФорма);
	ВернутьПараметрыПослеОбработки(ОбщиеПараметрыОбработки, ВладелецФормы);

КонецПроцедуры // ОсновныеДействияФормыВыполнить()

// Обработчик действия "СохранитьНастройку" командной панели "ОсновныеДействияФормы".
//
Процедура ОсновныеДействияФормыСохранитьНастройку(Кнопка)

	вСохранитьНастройку();

КонецПроцедуры // ОсновныеДействияФормыСохранитьНастройку()

Процедура КлсУниверсальнаяКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура УзелНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВвода_НачалоВыбораЛкс(Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОбработчикОжиданияСПараметрамиЛкс() Экспорт 
	
	ирОбщий.ОбработчикОжиданияСПараметрамиЛкс();

КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирПодборИОбработкаОбъектов.Форма.ИзменитьРегистрациюНаУзле");
мИспользоватьНастройки = Истина;

//Реквизиты настройки и значения по умолчанию.
мНастройка = Новый Структура("Узел, НовоеЗначениеРегистрации, ВместеСДвижениями, ДвиженияВместеСПоследовательностями");
мНастройка.НовоеЗначениеРегистрации = Истина;
мНастройка.ВместеСДвижениями = Ложь;
мНастройка.ДвиженияВместеСПоследовательностями = Ложь;
