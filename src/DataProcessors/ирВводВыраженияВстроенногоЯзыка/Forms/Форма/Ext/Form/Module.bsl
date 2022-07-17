﻿Перем ПолеТекстаПрограммы;
Перем ОбработкаПолеТекстаПрограммы Экспорт;

// @@@.КЛАСС.ПолеТекстаПрограммы
Функция КлсОбновитьКонтекстПоляТекстаПрограммы(Знач Компонента = Неопределено, Знач Кнопка = Неопределено) Экспорт 
КонецФункции

// @@@.КЛАСС.ПолеТекстаПрограммы
Процедура КлсПолеТекстаПрограммыНажатие(Кнопка)
	
	#Если Сервер И Не Сервер Тогда
	    ПолеТекстаПрограммы = Обработки.ирКлсПолеТекстаПрограммы.Создать();
	#КонецЕсли
	ПолеТекстаПрограммы[ЭлементыФормы.ВыражениеВнутреннегоЯзыка.Имя].Нажатие(Кнопка);
	
КонецПроцедуры

// @@@.КЛАСС.ПолеТекстаПрограммы
Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	Если ПолеТекстаПрограммы = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ЭкземплярКомпоненты = ПолеТекстаПрограммы.ВыражениеВнутреннегоЯзыка;
	#Если Сервер И Не Сервер Тогда
	    ЭкземплярКомпоненты = Обработки.ирКлсПолеТекстаПрограммы.Создать();
	#КонецЕсли
	ЭкземплярКомпоненты.ВнешнееСобытиеОбъекта(Источник, Событие, Данные);
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	Если ТипЗнч(ВладелецФормы) = Тип("Форма") Тогда
		ВладелецФормы.Панель.Доступность = Ложь;
	КонецЕсли;
	ЭлементыФормы.ВыражениеВнутреннегоЯзыка.УстановитьТекст(Формула);
	
	// +++.КЛАСС.ПолеТекстаПрограммы
	ПолеТекстаПрограммы = Новый Структура;
	ОбработкаПолеТекстаПрограммы = ирОбщий.СоздатьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирКлсПолеТекстаПрограммы");
	#Если Сервер И Не Сервер Тогда
		ОбработкаПолеТекстаПрограммы = Обработки.ирКлсПолеТекстаПрограммы.Создать();
	#КонецЕсли
	ОбработкаПолеТекстаПрограммы.Инициализировать(ПолеТекстаПрограммы,
		ЭтаФорма, ЭлементыФормы.ВыражениеВнутреннегоЯзыка, ЭлементыФормы.КоманднаяПанельВыражениеВнутреннегоЯзыка,
		Ложь, "ВычислитьВФорме", ЭтаФорма, "Выражение");
	ОбработкаПолеТекстаПрограммы.ЛиСерверныйКонтекст = НаСервере;
	Если мПараметры <> Неопределено Тогда
		ОбработкаПолеТекстаПрограммы.ДобавитьСловоЛокальногоКонтекста(
			"Параметры", "Свойство", , мПараметры, , мПараметры);
	КонецЕсли; 
	// ---.КЛАСС.ПолеТекстаПрограммы

КонецПроцедуры

Процедура ПриЗакрытии()
	
	// +++.КЛАСС.ПолеТекстаПрограммы
	Для Каждого Экземпляр Из ПолеТекстаПрограммы Цикл
		Экземпляр.Значение.Уничтожить();
	КонецЦикла;
	// ---.КЛАСС.ПолеТекстаПрограммы

	Если ТипЗнч(ВладелецФормы) = Тип("Форма") Тогда
		ВладелецФормы.Панель.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОсновныеДействияФормыОК(Кнопка = Неопределено)
	
	ЗначениеВыбора = Новый Структура("Формула", СокрЛП(ЭлементыФормы.ВыражениеВнутреннегоЯзыка.ПолучитьТекст()));
	ирОбщий.ПрименитьИзмененияИЗакрытьФормуЛкс(ЭтаФорма, ЗначениеВыбора);
	
КонецПроцедуры

// Выполняет программный код в контексте.
//
// Параметры:
//  ТекстДляВыполнения - Строка;
//  *ЛиСинтаксическийКонтроль - Булево, *Ложь - признак вызова только для синтаксического контроля.
//
Функция ВычислитьВФорме(ТекстДляВыполнения, ЛиСинтаксическийКонтроль = Ложь) Экспорт
	
	Если ТекстДляВыполнения = "" Тогда
		ТекстДляВыполнения = "Неопределено";
	КонецЕсли;
	Если МетодВыполнения = "" Тогда
		МетодВыполнения = "Вычислить";
	КонецЕсли;
	Если КонтекстВыполнения = Неопределено Тогда
		ЭтаФорма.Результат = Вычислить(МетодВыполнения + "(ТекстДляВыполнения)");
	Иначе
		ЭтаФорма.Результат = Вычислить("КонтекстВыполнения." + МетодВыполнения + "(ТекстДляВыполнения)");
	КонецЕсли;
	ТипЗначенияРезультата = ТипЗнч(ЭтаФорма.Результат);
	ЭтаФорма.ПредставлениеРезультата = ирОбщий.РасширенноеПредставлениеЗначенияЛкс(ЭтаФорма.Результат);

КонецФункции // ВычислитьВФорме()

Процедура РезультатОткрытие(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ИсследоватьЛкс(ЭтаФорма.Результат);
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	ирОбщий.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработчикОжиданияСПараметрамиЛкс() Экспорт 
	
	ирОбщий.ОбработчикОжиданияСПараметрамиЛкс();

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирОбщий.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Ответ = ирОбщий.ЗапроситьСохранениеДанныхФормыЛкс(ЭтаФорма, Отказ);
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ОсновныеДействияФормыОК();
	КонецЕсли;
	
КонецПроцедуры

ирОбщий.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирВводВыраженияВстроенногоЯзыка.Форма.Форма");
