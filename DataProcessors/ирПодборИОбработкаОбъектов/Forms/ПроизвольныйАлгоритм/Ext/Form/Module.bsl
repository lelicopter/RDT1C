﻿//Признак использования настроек
Перем мИспользоватьНастройки Экспорт;

//Типы объектов, для которых может использоваться обработка.
//По умолчанию для всех.
Перем мТипыОбрабатываемыхОбъектов Экспорт;

Перем мНастройка;
Перем мОписаниеТиповЭлемента;
Перем мОписаниеТиповОбъектаБД;
Перем мТабличноеПолеПараметры;

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
Процедура вОбработатьОбъект(Знач Объект, Знач КоллекцияСтрок = Неопределено, Знач ОбъектБД = Неопределено, Знач ПараметрыОбработки = Неопределено, Знач ОбъектБДМетоды = Неопределено) Экспорт

	ТекстАлгоритма = ЭлементыФормы.ТекстПроизвольногоАлгоритма.ПолучитьТекст();
	ТекстАлгоритма = "Объект = _П0; ОбъектБД = _П1; ОбъектБДМетоды = _П2; Параметры = _П3; ЭтоПервыйОбъектБД = _П4; ЭтоПоследнийОбъектБД = _П5; ЭтоПервыйЭлемент = _П6; ЭтоПоследнийЭлемент = _П7; ПринудительнаяЗапись = _П8;
	|" + ТекстАлгоритма;
	Для Каждого СтрокаПараметра Из мТабличноеПолеПараметры.Значение Цикл
		ТекстАлгоритма = СтрокаПараметра.Имя + " = _АлгоритмОбъект[" + мТабличноеПолеПараметры.Значение.Индекс(СтрокаПараметра) + "];
		|" + ТекстАлгоритма;
	КонецЦикла; 
	ТекстАлгоритма = ТекстАлгоритма + "
	|;
	|_П8 = ПринудительнаяЗапись;
	|";
	ирОбщий.ВыполнитьАлгоритм(ТекстАлгоритма, мТабличноеПолеПараметры.Значение.ВыгрузитьКолонку("Значение")
		, , Объект, ОбъектБД, ОбъектБДМетоды, ПараметрыОбработки, ПараметрыОбработки.ЭтоПервыйОбъектБД, ПараметрыОбработки.ЭтоПоследнийОбъектБД, ПараметрыОбработки.ЭтоПервыйЭлемент,
		ПараметрыОбработки.ЭтоПоследнийЭлемент, ПараметрыОбработки.ПринудительнаяЗапись);
	//РедакторАлгоритма.ВыполнитьПрограммныйКод();

КонецПроцедуры // ОбработатьОбъект()

// Сохраняет значения реквизитов формы.
//
// Параметры:
//  Нет.
//
Процедура вСохранитьНастройку() Экспорт

	Если ПустаяСтрока(ЭлементыФормы.ТекущаяНастройка) Тогда
		Предупреждение("Задайте имя новой настройки для сохранения или выберите существующую настройку для перезаписи.");
	КонецЕсли;

	ТекстПроизвольногоАлгоритма = ЭлементыФормы.ТекстПроизвольногоАлгоритма.ПолучитьТекст();
	Если ТипЗнч(мТабличноеПолеПараметры.Значение) = Тип("ТаблицаЗначений") Тогда
		Параметры = мТабличноеПолеПараметры.Значение.Скопировать(Новый Структура("Вход", Ложь), "Имя, Значение");
	Иначе
		Параметры = мТабличноеПолеПараметры.Значение.Выгрузить(Новый Структура("Вход", Ложь), "Имя, Значение");
	КонецЕсли; 
    НоваяНастройка = Новый Структура;
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
        Если НЕ ТекущаяНастройка.Настройка = Неопределено Тогда
			мНастройка = ТекущаяНастройка.Настройка;
		КонецЕсли;
	КонецЕсли;

	Если Не мНастройка.Свойство("Параметры") Тогда
		мНастройка.Вставить("Параметры", Новый ТаблицаЗначений);
	КонецЕсли; 
	//Для каждого РеквизитНастройки из мНастройка Цикл
	//	Значение = мНастройка[РеквизитНастройки.Ключ];
	//	Выполнить(Строка(РеквизитНастройки.Ключ) + " = Значение;");
	//КонецЦикла;

	ЭлементыФормы.ТекстПроизвольногоАлгоритма.УстановитьТекст(мНастройка.ТекстПроизвольногоАлгоритма);
	Для Каждого СтрокаПараметра Из мТабличноеПолеПараметры.Значение.НайтиСтроки(Новый Структура("Вход", Ложь)) Цикл
		мТабличноеПолеПараметры.Значение.Удалить(СтрокаПараметра);
	КонецЦикла;
	ирОбщий.ЗагрузитьВТаблицуЗначенийЛкс(мНастройка.Параметры, мТабличноеПолеПараметры.Значение);
	Для Каждого СтрокаПараметра Из мТабличноеПолеПараметры.Значение Цикл
		СтрокаПараметра.НИмя = НСтр(СтрокаПараметра.Имя);
		Если ЗначениеЗаполнено(СтрокаПараметра.Значение) Тогда
			СтрокаПараметра.ТипЗначения = ТипЗнч(СтрокаПараметра.Значение);
		КонецЕсли; 
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

	РедакторАлгоритма.Инициализировать(,
		//ЭтаФорма, ЭлементыФормы.ТекстПроизвольногоАлгоритма, ЭлементыФормы.КоманднаяПанель, Ложь, "ВыполнитьЛокально", ЭтаФорма);
		ЭтаФорма, ЭлементыФормы.ТекстПроизвольногоАлгоритма, ЭлементыФормы.КоманднаяПанель, Ложь);
	КнопкаВыполнить = ирОбщий.ПолучитьКнопкуКоманднойПанелиЭкземпляраКомпонентыЛкс(РедакторАлгоритма, "Выполнить");
	ЭлементыФормы.КоманднаяПанель.Кнопки.Удалить(КнопкаВыполнить);
	ЭлементыФормы.ОсновныеДействияФормы.Кнопки.Сохранить.Доступность = Не ирКэш.ЛиПортативныйРежимЛкс();
	ЭлементыФормы.ОсновныеДействияФормы.Кнопки.Загрузить.Доступность = Не ирКэш.ЛиПортативныйРежимЛкс();
	
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

Функция ОбновитьКонтекстПодсказкиИПолучитьСтруктуруПараметров()

	ирОбщий.ИнициализироватьГлобальныйКонтекстПодсказкиЛкс(РедакторАлгоритма);
	#Если Сервер И Не Сервер Тогда
	    РедакторАлгоритма = Обработки.ирКлсПолеТекстовогоДокументаСКонтекстнойПодсказкой.Создать();
	#КонецЕсли
	// Локальный контекст
	Для Каждого СтрокаПараметра Из мТабличноеПолеПараметры.Значение Цикл
		РедакторАлгоритма.ДобавитьСловоЛокальногоКонтекста(СтрокаПараметра.Имя,,,,, СтрокаПараметра.Значение, мПлатформа.ПолучитьТаблицуСтруктурТиповИзДопустимыхТипов(СтрокаПараметра.ДопустимыеТипы));
	КонецЦикла;
		
	Возврат Неопределено;

КонецФункции // ОбновитьКонтекстПодсказкиИПолучитьСтруктуруПараметров()

// @@@.КЛАСС.ПолеТекстовогоДокументаСКонтекстнойПодсказкой
// Транслятор обработки событий нажатия на кнопки командной панели в компоненту.
// Является обязательным.
//
// Параметры:
//  Кнопка       – КнопкаКоманднойПанели.
//
Процедура КлсПолеТекстовогоДокументаСКонтекстнойПодсказкойНажатие(Кнопка)
	
	ОбновитьКонтекстПодсказкиИПолучитьСтруктуруПараметров();
	РедакторАлгоритма.Нажатие(Кнопка);
	
КонецПроцедуры

// @@@.КЛАСС.ПолеТекстовогоДокументаСКонтекстнойПодсказкой
Процедура КлсПолеТекстовогоДокументаСКонтекстнойПодсказкойАвтоОбновитьСправку()
	
	РедакторАлгоритма.АвтоОбновитьСправку();
	
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

Функция вВыполнитьОбработку() Экспорт
	
	Если ТипЗнч(мТабличноеПолеПараметры.Значение) = Тип("ТаблицаЗначений") Тогда
		Параметры = мТабличноеПолеПараметры.Значение.Скопировать();
	Иначе
		Параметры = мТабличноеПолеПараметры.Значение.Выгрузить();
	КонецЕсли; 
	Если Не ирОбщий.ЛиПараметрыАлгоритмыКорректныЛкс(Параметры) Тогда
		Возврат Неопределено;
	КонецЕсли; 
	ОбновитьКонтекстПодсказкиИПолучитьСтруктуруПараметров();
	Если Открыта() И Не РедакторАлгоритма.ПроверитьПрограммныйКод() Тогда
		Возврат Неопределено;
	КонецЕсли; 
	ОбработаноОбъектов = вВыполнитьГрупповуюОбработку(ЭтаФорма);
	Возврат ОбработаноОбъектов;
	
КонецФункции

// Обработчик действия "Выполнить" командной панели "ОсновныеДействияФормы".
//
Процедура ОсновныеДействияФормыВыполнить(Кнопка)

	ОбработаноОбъектов = вВыполнитьОбработку();

КонецПроцедуры // ОсновныеДействияФормыВыполнить()

// Обработчик действия "СохранитьНастройку" командной панели "ОсновныеДействияФормы".
//
Процедура ОсновныеДействияФормыСохранитьНастройку(Кнопка)

	вСохранитьНастройку();

КонецПроцедуры // ОсновныеДействияФормыСохранитьНастройку()

Процедура ПриОткрытии()
	
	Если ВладелецФормы <> Неопределено Тогда
		ВладелецФормы.Панель.Доступность = Ложь;
		ИскомыйОбъект = ВладелецФормы.мИскомыйОбъект;
	КонецЕсли; 
	мОписаниеТиповЭлемента = ПолучитьОписаниеТиповОбрабатываемогоЭлементаИлиОбъекта(ИскомыйОбъект, Ложь);
	СтрокаПараметра = мТабличноеПолеПараметры.Значение.Найти("Объект", "Имя");
	СтрокаПараметра.ТипЗначения = мОписаниеТиповЭлемента;
	СтрокаПараметра.ДопустимыеТипы = мПлатформа.ПолучитьДопустимыеТипыИзОписанияТипов(мОписаниеТиповЭлемента);
	
	мОписаниеТиповОбъектаБД = ПолучитьОписаниеТиповОбрабатываемогоЭлементаИлиОбъекта(ИскомыйОбъект, Истина);
	СтрокаПараметра = мТабличноеПолеПараметры.Значение.Найти("ОбъектБД", "Имя");
	СтрокаПараметра.ТипЗначения = мОписаниеТиповОбъектаБД;
	СтрокаПараметра.ДопустимыеТипы = мПлатформа.ПолучитьДопустимыеТипыИзОписанияТипов(мОписаниеТиповОбъектаБД);
	СтрокаПараметра = мТабличноеПолеПараметры.Значение.Найти("ОбъектБДМетоды", "Имя");
	СтрокаПараметра.ТипЗначения = мОписаниеТиповОбъектаБД;
	СтрокаПараметра.ДопустимыеТипы = мПлатформа.ПолучитьДопустимыеТипыИзОписанияТипов(мОписаниеТиповОбъектаБД);
		
КонецПроцедуры

Процедура ПриЗакрытии()
	
	Если ВладелецФормы <> Неопределено Тогда
		ВладелецФормы.Панель.Доступность = Истина;
	КонецЕсли; 
	
	// +++.КЛАСС.ПолеТекстовогоДокументаСКонтекстнойПодсказкой
	// Уничтожение всех экземпляров компоненты. Обязательный блок.
	РедакторАлгоритма.Уничтожить();
	// ---.КЛАСС.ПолеТекстовогоДокументаСКонтекстнойПодсказкой
	
КонецПроцедуры

//// @@@.КЛАСС.ПолеТекстовогоДокументаСКонтекстнойПодсказкой
//// Процедура служит для выполнения программы поля текстового документа в локальном контексте.
//// Вызывается из компоненты ирКлсПолеТекстовогоДокументаСКонтекстнойПодсказкой в режиме внутреннего языка.
////
//// Параметры:
////  ТекстДляВыполнения – Строка;
////  *ЛиСинтаксическийКонтроль - Булево, *Ложь - признак вызова только для синтаксического контроля.
////
//Функция ВыполнитьЛокально(ТекстДляВыполнения, ЛиСинтаксическийКонтроль = Ложь) Экспорт
//	
//	Если ЛиСинтаксическийКонтроль Тогда
//		Выполнить(ТекстДляВыполнения);
//		Возврат Неопределено;
//	КонецЕсли;
//	
//	Предупреждение("Функция недоступна в данном контексте");
//	
//КонецФункции // ВыполнитьЛокально()

Процедура КоманднаяПанельОбработкаСтрокиРезультатаШаблонЧтениеИЗаписьОбъекта(Кнопка)
	
	Текст =
	"Объект.
	|//Объект.ОбменДанными.Загрузка = Истина;
	|Объект.Записать();";
	
	ирОбщий.УстановитьТекстСОткатомЛкс(ЭлементыФормы.ТекстПроизвольногоАлгоритма, Текст);
	ЭтаФорма.ТекущийЭлемент = ЭлементыФормы.ТекстПроизвольногоАлгоритма;
	
КонецПроцедуры

Процедура ПараметрыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	Если ДанныеСтроки.Вход Тогда
		ОформлениеСтроки.ЦветФона = Новый Цвет(230, 230, 230);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПараметрыПередНачаломИзменения(Элемент, Отказ)
	
	Если Элемент.ТекущиеДанные.Вход Тогда
		Отказ = Истина;
	КонецЕсли; 
	
КонецПроцедуры

Процедура КоманднаяПанельСсылкаНаОбъектБД(Кнопка)
	
	СтрокаПараметра = РедакторАлгоритма.ВставитьСсылкуНаОбъектБД(мТабличноеПолеПараметры);
	Если СтрокаПараметра <> Неопределено Тогда
		СтрокаПараметра.ТипЗначения = ТипЗнч(СтрокаПараметра.Значение);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПараметрыПередУдалением(Элемент, Отказ)

	Если Элемент.ТекущиеДанные.Вход Тогда
		Отказ = Истина;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПараметрыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		Элемент.ТекущиеДанные.Вход = Ложь;
		Элемент.ТекущиеДанные.Комментарий = "";
		Элемент.ТекущиеДанные.ДопустимыеТипы = Неопределено;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОсновныеДействияФормыЗагрузить(Кнопка)
	
	РезультатВыбора = ирОбщий.ВыбратьСсылкуЛкс(Метаданные.Справочники.ирАлгоритмы, ТекущийАлгоритм, Ложь);
	Если Не ЗначениеЗаполнено(РезультатВыбора) Тогда
		Возврат;
	КонецЕсли; 
	ТекущийАлгоритм = РезультатВыбора;
	РедакторАлгоритма.ПолеТекстовогоДокумента.УстановитьТекст(ТекущийАлгоритм.ТекстАлгоритма);
	Если мТабличноеПолеПараметры.Значение.Количество() > 0 Тогда
		Ответ = Вопрос("Очистить параметры перед загрузкой?", РежимДиалогаВопрос.ДаНет);
		Если Ответ = КодВозвратаДиалога.Да Тогда
			СтрокиВхода = мТабличноеПолеПараметры.Значение.НайтиСтроки(Новый Структура("Вход", Ложь));
			Для Каждого СтрокаВхода Из СтрокиВхода Цикл
				мТабличноеПолеПараметры.Значение.Удалить(СтрокаВхода);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли; 
	Для Каждого СтрокаПараметраАлгоритма Из ТекущийАлгоритм.Параметры Цикл
		СтрокаПараметраКонсоли = мТабличноеПолеПараметры.Значение.Найти(СтрокаПараметраАлгоритма.Имя, "Имя");
		Если СтрокаПараметраКонсоли = Неопределено Тогда
			СтрокаПараметраКонсоли = мТабличноеПолеПараметры.Значение.Добавить();
			СтрокаПараметраКонсоли.Имя = СтрокаПараметраАлгоритма.Имя;
			СтрокаПараметраКонсоли.НИмя = НРег(СтрокаПараметраКонсоли.Имя);
		КонецЕсли; 
		СтрокаПараметраКонсоли.Значение = СтрокаПараметраАлгоритма.Значение;
		СтрокаПараметраКонсоли.ТипЗначения = ТипЗнч(СтрокаПараметраАлгоритма.Значение);
		СтрокаПараметраКонсоли.Вход = Ложь;
	КонецЦикла;
	ОбновитьПараметрыВПортативномРежиме();

КонецПроцедуры

Процедура ПараметрыЗначениеПриИзменении(Элемент)
	
	СтрокаПараметра = мТабличноеПолеПараметры.ТекущиеДанные;
	СтрокаПараметра.ТипЗначения = ТипЗнч(СтрокаПараметра.Имя);
	
КонецПроцедуры

Процедура ПараметрыИмяПриИзменении(Элемент)
	
	СтрокаПараметра = мТабличноеПолеПараметры.ТекущиеДанные;
	СтрокаПараметра.НИмя = НСтр(СтрокаПараметра.Имя);
	
КонецПроцедуры

Процедура ОсновныеДействияФормыСохранить(Кнопка)
	
	РезультатВыбора = ирОбщий.ВыбратьСсылкуЛкс(Метаданные.Справочники.ирАлгоритмы, ТекущийАлгоритм, Ложь);
	Если ЗначениеЗаполнено(РезультатВыбора) Тогда
		//Если Не ЗначениеЗаполнено(ТекущийАлгоритм) Тогда
			ТекущийАлгоритм = РезультатВыбора;
		//КонецЕсли; 
		//АлгоритмОбъект = РезультатВыбора.ПолучитьОбъект();
		АлгоритмОбъект = РезультатВыбора;
	Иначе
		АлгоритмОбъект = Справочники.ирАлгоритмы.СоздатьЭлемент();
		ТекущийАлгоритм = ирОбщий.ПолучитьТочнуюСсылкуОбъектаЛкс(АлгоритмОбъект);
	КонецЕсли; 
	ФормаАлгоритма = АлгоритмОбъект.ПолучитьФорму();
	ФормаАлгоритма.ТекстАлгоритма = РедакторАлгоритма.ПолеТекстовогоДокумента.ПолучитьТекст();
	СтрокиПараметровКонсоли = мТабличноеПолеПараметры.Значение.НайтиСтроки(Новый Структура("Вход", Ложь));
	Для Каждого СтрокаПараметраКонсоли Из СтрокиПараметровКонсоли Цикл
		СтрокаПараметраАлгоритма = ФормаАлгоритма.Параметры.Найти(СтрокаПараметраКонсоли.Имя, "Имя");
		Если СтрокаПараметраАлгоритма = Неопределено Тогда
			СтрокаПараметраАлгоритма = ФормаАлгоритма.Параметры.Добавить();
			СтрокаПараметраАлгоритма.Имя = СтрокаПараметраКонсоли.Имя;
		КонецЕсли; 
		СтрокаПараметраАлгоритма.Значение = СтрокаПараметраКонсоли.Значение;
	КонецЦикла;
	ФормаАлгоритма.СправочникОбъект = ФормаАлгоритма.СправочникОбъект;
	ФормаАлгоритма.Открыть();
	ФормаАлгоритма.Модифицированность = Истина;

КонецПроцедуры

Процедура СкрытыеПараметрыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ОбновитьПараметрыВПортативномРежиме();
	
КонецПроцедуры

Процедура СкрытыеПараметрыПослеУдаления(Элемент)
	
	ОбновитьПараметрыВПортативномРежиме();
	
КонецПроцедуры

Процедура ОбновитьПараметрыВПортативномРежиме()
	
	РедакторАлгоритма.Параметры.Загрузить(СкрытыеПараметры);
	
КонецПроцедуры

Процедура КлсУниверсальнаяКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработчикОжиданияСПараметрамиЛкс() Экспорт 
	
	ирОбщий.ОбработчикОжиданияСПараметрамиЛкс();

КонецПроцедуры

Процедура ПараметрыНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	ПараметрыПеретаскивания.Значение = Элемент.ТекущаяСтрока.Имя;
	
КонецПроцедуры

Процедура ПараметрыЗначениеНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаКолонкиРасширенногоЗначения_НачалоВыбораЛкс(ЭлементыФормы.Параметры, СтандартнаяОбработка, , Истина);

КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ИНИЦИАЛИЗАЦИЯ МОДУЛЬНЫХ ПЕРЕМЕННЫХ

мИспользоватьНастройки = Истина;

//Реквизиты настройки и значения по умолчанию.
мНастройка = Новый Структура("ТекстПроизвольногоАлгоритма, Параметры", "", Новый ТаблицаЗначений);

мТипыОбрабатываемыхОбъектов = Неопределено;
ЭтаФорма.РедакторАлгоритма = рРедакторАлгоритма;
мТабличноеПолеПараметры = ЭлементыФормы.Параметры;
Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
	ЭтаФорма.РедакторАлгоритма = ирОбщий.ПолучитьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирКлсПолеТекстовогоДокументаСКонтекстнойПодсказкой");
	#Если Сервер И Не Сервер Тогда
		ЭтаФорма.РедакторАлгоритма = Обработки.ирКлсПолеТекстовогоДокументаСКонтекстнойПодсказкой.Создать();
	#КонецЕсли
	ЭтаФорма.ЭлементыФормы.Удалить(ЭлементыФормы.Параметры);
	мТабличноеПолеПараметры = ЭтаФорма.ЭлементыФормы.СкрытыеПараметры;
	мТабличноеПолеПараметры.Видимость = Истина;
КонецЕсли; 
ОписаниеТиповСтруктура = Новый ОписаниеТипов("Структура");
ОписаниеТиповБулево = Новый ОписаниеТипов("Булево");
СтрокаПараметра = РедакторАлгоритма.Параметры.Добавить();
СтрокаПараметра.Имя = "Объект";
СтрокаПараметра.НИмя = НСтр(СтрокаПараметра.Имя);
СтрокаПараметра.Комментарий = "Для доступа к элементу данных";
СтрокаПараметра.Вход = Истина;
СтрокаПараметра = РедакторАлгоритма.Параметры.Добавить();
СтрокаПараметра.Имя = "ОбъектБД";
СтрокаПараметра.НИмя = НСтр(СтрокаПараметра.Имя);
СтрокаПараметра.Комментарий = "Для доступа к объекту данных при обработке его элементов. В режиме ""запись на сервере"" содержит только данные объекта.";
СтрокаПараметра.Вход = Истина;
СтрокаПараметра = РедакторАлгоритма.Параметры.Добавить();
СтрокаПараметра.Имя = "ОбъектБДМетоды";
СтрокаПараметра.НИмя = НСтр(СтрокаПараметра.Имя);
СтрокаПараметра.Комментарий = "Для доступа к объекту данных при обработке его элементов. В режиме ""запись на сервере"" содержит только предопределенные свойства и методы объекта.";
СтрокаПараметра.Вход = Истина;
СтрокаПараметра = РедакторАлгоритма.Параметры.Добавить();
СтрокаПараметра.Имя = "Параметры";
СтрокаПараметра.НИмя = НСтр(СтрокаПараметра.Имя);
СтрокаПараметра.Комментарий = "Для хранения значений между проходами цикла";
СтрокаПараметра.Вход = Истина;
СтрокаПараметра.ТипЗначения = ОписаниеТиповСтруктура;
СтрокаПараметра.ДопустимыеТипы = мПлатформа.ПолучитьДопустимыеТипыИзОписанияТипов(ОписаниеТиповСтруктура);
СтрокаПараметра = РедакторАлгоритма.Параметры.Добавить();
СтрокаПараметра.Имя = "ЭтоПервыйОбъектБД";
СтрокаПараметра.НИмя = НСтр(СтрокаПараметра.Имя);
СтрокаПараметра.Комментарий = "Признак того, что обрабатывается первый объект данных. Только чтение.";
СтрокаПараметра.Вход = Истина;
СтрокаПараметра.ТипЗначения = ОписаниеТиповБулево;
СтрокаПараметра.ДопустимыеТипы = мПлатформа.ПолучитьДопустимыеТипыИзОписанияТипов(ОписаниеТиповБулево);
СтрокаПараметра = РедакторАлгоритма.Параметры.Добавить();
СтрокаПараметра.Имя = "ЭтоПоследнийОбъектБД";
СтрокаПараметра.НИмя = НСтр(СтрокаПараметра.Имя);
СтрокаПараметра.Комментарий = "Признак того, что обрабатывается последний объект данных. Только чтение.";
СтрокаПараметра.Вход = Истина;
СтрокаПараметра.ТипЗначения = ОписаниеТиповБулево;
СтрокаПараметра.ДопустимыеТипы = мПлатформа.ПолучитьДопустимыеТипыИзОписанияТипов(ОписаниеТиповБулево);
СтрокаПараметра = РедакторАлгоритма.Параметры.Добавить();
СтрокаПараметра.Имя = "ЭтоПервыйЭлемент";
СтрокаПараметра.НИмя = НСтр(СтрокаПараметра.Имя);
СтрокаПараметра.Комментарий = "Признак того, что обрабатывается первый элемент внутри объекта данных. Только чтение.";
СтрокаПараметра.Вход = Истина;
СтрокаПараметра.ТипЗначения = ОписаниеТиповБулево;
СтрокаПараметра.ДопустимыеТипы = мПлатформа.ПолучитьДопустимыеТипыИзОписанияТипов(ОписаниеТиповБулево);
СтрокаПараметра = РедакторАлгоритма.Параметры.Добавить();
СтрокаПараметра.Имя = "ЭтоПоследнийЭлемент";
СтрокаПараметра.НИмя = НСтр(СтрокаПараметра.Имя);
СтрокаПараметра.Комментарий = "Признак того, что обрабатывается последний элемент внутри объекта данных. Только чтение.";
СтрокаПараметра.Вход = Истина;
СтрокаПараметра.ТипЗначения = ОписаниеТиповБулево;
СтрокаПараметра.ДопустимыеТипы = мПлатформа.ПолучитьДопустимыеТипыИзОписанияТипов(ОписаниеТиповБулево);
СтрокаПараметра = РедакторАлгоритма.Параметры.Добавить();
СтрокаПараметра.Имя = "ПринудительнаяЗапись";
СтрокаПараметра.НИмя = НСтр(СтрокаПараметра.Имя);
СтрокаПараметра.Комментарий = "Установите в коде этот флаг, чтобы выполнить запись объекта независимо от модифицированности";
СтрокаПараметра.Вход = Истина;
СтрокаПараметра.ТипЗначения = ОписаниеТиповБулево;
СтрокаПараметра.ДопустимыеТипы = мПлатформа.ПолучитьДопустимыеТипыИзОписанияТипов(ОписаниеТиповБулево);
Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
	ЭтаФорма.СкрытыеПараметры = ЭтаФорма.РедакторАлгоритма.Параметры.Выгрузить();
КонецЕсли; 
ЭлементыФормы.ОсновныеДействияФормы.Кнопки.Сохранить.Доступность = Не ирКэш.ЛиПортативныйРежимЛкс();
ЭлементыФормы.ОсновныеДействияФормы.Кнопки.Загрузить.Доступность = Не ирКэш.ЛиПортативныйРежимЛкс();

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирПодборИОбработкаОбъектов.Форма.ПроизвольныйАлгоритм");
