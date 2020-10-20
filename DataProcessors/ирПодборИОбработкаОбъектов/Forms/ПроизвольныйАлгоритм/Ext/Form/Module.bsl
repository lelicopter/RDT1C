﻿//Признак использования настроек
Перем мИспользоватьНастройки Экспорт;
Перем мНастройка;
Перем мОписаниеТиповЭлемента;
Перем мОписаниеТиповОбъектаБД;
Перем мТабличноеПолеПараметры;

// Сохраняет значения реквизитов формы.
//
// Параметры:
//  Нет.
//
Процедура вСохранитьНастройку() Экспорт

	Если ПустаяСтрока(ЭлементыФормы.ТекущаяНастройка) Тогда
		Предупреждение("Задайте имя новой настройки для сохранения или выберите существующую настройку для перезаписи.");
	КонецЕсли;
	СохранитьНастройкуОбработки(ЭтаФорма);

КонецПроцедуры

Функция ПолучитьНастройкуЛкс() Экспорт 
	
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

// Процедура - обработчик события "ПередОткрытием" формы.
//
Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)

	#Если Сервер И Не Сервер Тогда
	    РедакторАлгоритма = Обработки.ирКлсПолеТекстовогоДокументаСКонтекстнойПодсказкой.Создать();
	#КонецЕсли
	РедакторАлгоритма.Инициализировать(,
		//ЭтаФорма, ЭлементыФормы.ТекстПроизвольногоАлгоритма, ЭлементыФормы.КоманднаяПанель, Ложь, "ВыполнитьЛокально", ЭтаФорма);
		ЭтаФорма, ЭлементыФормы.ТекстПроизвольногоАлгоритма, ЭлементыФормы.КоманднаяПанель, Ложь);
	Если ВладелецФормы <> Неопределено Тогда
		РедакторАлгоритма.ЛиСерверныйКонтекст = ВладелецФормы.ВыполнятьНаСервере;
	КонецЕсли; 
	КнопкаВыполнить = ирОбщий.ПолучитьКнопкуКоманднойПанелиЭкземпляраКомпонентыЛкс(РедакторАлгоритма, "Выполнить");
	ЭлементыФормы.КоманднаяПанель.Кнопки.Удалить(КнопкаВыполнить);
	ЭлементыФормы.ОсновныеДействияФормы.Кнопки.Сохранить.Доступность = Не ирКэш.ЛиПортативныйРежимЛкс() И Не ирКэш.ЛиЭтоРасширениеКонфигурацииЛкс();
	ЭлементыФормы.ОсновныеДействияФормы.Кнопки.Загрузить.Доступность = Не ирКэш.ЛиПортативныйРежимЛкс() И Не ирКэш.ЛиЭтоРасширениеКонфигурацииЛкс();
	
	Если мИспользоватьНастройки Тогда
		вУстановитьИмяНастройки();
		вЗагрузитьНастройку();
	Иначе
		ЭлементыФормы.ТекущаяНастройка.Доступность = Ложь;
		ЭлементыФормы.ОсновныеДействияФормы.Кнопки.СохранитьНастройку.Доступность = Ложь;
	КонецЕсли;

КонецПроцедуры // ПередОткрытием()

Функция ОбновитьКонтекстПодсказкиИПолучитьСтруктуруПараметров()

	ирОбщий.ИнициализироватьГлобальныйКонтекстПодсказкиЛкс(РедакторАлгоритма);
	#Если Сервер И Не Сервер Тогда
	    РедакторАлгоритма = Обработки.ирКлсПолеТекстовогоДокументаСКонтекстнойПодсказкой.Создать();
	#КонецЕсли
	// Локальный
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
	
	#Если Сервер И Не Сервер Тогда
	    РедакторАлгоритма = Обработки.ирКлсПолеТекстовогоДокументаСКонтекстнойПодсказкой.Создать();
	#КонецЕсли
	ОбновитьКонтекстПодсказкиИПолучитьСтруктуруПараметров();
	РедакторАлгоритма.Нажатие(Кнопка);
	
КонецПроцедуры

// @@@.КЛАСС.ПолеТекстовогоДокументаСКонтекстнойПодсказкой
Процедура КлсПолеТекстовогоДокументаСКонтекстнойПодсказкойАвтоОбновитьСправку()
	
	#Если Сервер И Не Сервер Тогда
	    РедакторАлгоритма = Обработки.ирКлсПолеТекстовогоДокументаСКонтекстнойПодсказкой.Создать();
	#КонецЕсли
	РедакторАлгоритма.АвтоОбновитьСправку();
	
КонецПроцедуры

// @@@.КЛАСС.ПолеТекстовогоДокументаСКонтекстнойПодсказкой
Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	#Если Сервер И Не Сервер Тогда
	    РедакторАлгоритма = Обработки.ирКлсПолеТекстовогоДокументаСКонтекстнойПодсказкой.Создать();
	#КонецЕсли
	РедакторАлгоритма.ВнешнееСобытиеОбъекта(Источник, Событие, Данные);
	
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

	вВыполнитьОбработку();

КонецПроцедуры

Процедура вВыполнитьОбработку() Экспорт 
	
	Если ТипЗнч(мТабличноеПолеПараметры.Значение) = Тип("ТаблицаЗначений") Тогда
		Параметры = мТабличноеПолеПараметры.Значение.Скопировать();
	Иначе
		Параметры = мТабличноеПолеПараметры.Значение.Выгрузить();
	КонецЕсли; 
	Если Не ирОбщий.ПроверитьТаблицуПараметровЛкс(Параметры) Тогда
		Возврат;
	КонецЕсли; 
	ОбновитьКонтекстПодсказкиИПолучитьСтруктуруПараметров();
	Если Открыта() И Не РедакторАлгоритма.ПроверитьПрограммныйКод() Тогда
		Возврат;
	КонецЕсли; 
	ОбщиеПараметрыОбработки = ОбщиеПараметрыОбработки();
	ирОбщий.ПодборИОбработкаОбъектов_ВыполнитьОбработкуЛкс("ПроизвольныйАлгоритм", ОбщиеПараметрыОбработки, ПолучитьНастройкуЛкс(),, ЭтаФорма);
	ВернутьПараметрыПослеОбработки(ОбщиеПараметрыОбработки, ВладелецФормы);

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
		ирОбщий.УстановитьФокусВводаФормеЛкс(ВладелецФормы);
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

Процедура ПараметрыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
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

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ПараметрыНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	ПараметрыПеретаскивания.Значение = Элемент.ТекущаяСтрока.Имя;
	
КонецПроцедуры

Процедура ПараметрыЗначениеНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаКолонкиРасширенногоЗначения_НачалоВыбораЛкс(ЭтаФорма, ЭлементыФормы.Параметры, СтандартнаяОбработка, , Истина);

КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработчикОжиданияСПараметрамиЛкс() Экспорт 
	
	ирОбщий.ОбработчикОжиданияСПараметрамиЛкс();

КонецПроцедуры

Процедура ПараметрыПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);

КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Отказ = Ложь;
	Если Модифицированность Тогда
		ирОбщий.ПередОтображениемДиалогаПередЗакрытиемФормыЛкс(ЭтаФорма);
		Ответ = Вопрос("Настройка была изменена. Сохранить изменения?", РежимДиалогаВопрос.ДаНетОтмена);
		Если Ответ = КодВозвратаДиалога.Да Тогда
			вСохранитьНастройку();
		ИначеЕсли Ответ = КодВозвратаДиалога.Отмена Тогда
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура КоманднаяПанельЗначениеИзБуфера(Кнопка)
	
	ЗначениеИзБуфера = ирОбщий.СсылкаИзБуфераОбменаЛкс();
	Если Не ирОбщий.ЛиСсылкаНаОбъектБДЛкс(ЗначениеИзБуфера, Ложь) Тогда
		Возврат;
	КонецЕсли; 
	#Если Сервер И Не Сервер Тогда
	    РедакторАлгоритма = Обработки.ирКлсПолеТекстовогоДокументаСКонтекстнойПодсказкой.Создать();
	#КонецЕсли
	СтрокаПараметра = РедакторАлгоритма.ВставитьСсылкуНаОбъектБД(ЭлементыФормы.Параметры,,,, Истина, ЗначениеИзБуфера, Ложь, ЭтаФорма.ТекущийЭлемент = ЭлементыФормы.ТекстПроизвольногоАлгоритма);
	Если СтрокаПараметра = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	СтрокаПараметра.ТипЗначения = ТипЗнч(СтрокаПараметра.Значение);
	ЭлементыФормы.Параметры.ТекущаяСтрока = СтрокаПараметра;
	
КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирОбщий.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирПодборИОбработкаОбъектов.Форма.ПроизвольныйАлгоритм");

мИспользоватьНастройки = Истина;

//Реквизиты настройки и значения по умолчанию.
мНастройка = Новый Структура("ТекстПроизвольногоАлгоритма, Параметры", "", Новый ТаблицаЗначений);

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
СтрокаПараметра.Комментарий = "Для доступа к объекту данных при обработке его элементов. В режиме ""Объекты на сервере"" в непортативных вариантах на клиенте содержит только данные объекта.";
СтрокаПараметра.Вход = Истина;
СтрокаПараметра = РедакторАлгоритма.Параметры.Добавить();
СтрокаПараметра.Имя = "ОбъектБДМетоды";
СтрокаПараметра.НИмя = НСтр(СтрокаПараметра.Имя);
СтрокаПараметра.Комментарий = "Для доступа к объекту данных при обработке его элементов. В режиме ""объекты на сервере"" в непортативных вариантах на клиенте содержит только предопределенные свойства и методы объекта.";
СтрокаПараметра.Вход = Истина;
СтрокаПараметра = РедакторАлгоритма.Параметры.Добавить();
СтрокаПараметра.Имя = "Параметры";
СтрокаПараметра.НИмя = НСтр(СтрокаПараметра.Имя);
СтрокаПараметра.Комментарий = "Для хранения значений между проходами цикла. В многопоточном режиме сохраняется только между проходами цикла внутри одного объекта БД.";
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
