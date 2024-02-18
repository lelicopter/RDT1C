﻿Функция СохраняемаяНастройкаФормы(выхНаименование, выхИменаСвойств) Экспорт 
	выхИменаСвойств = "Форма.ПроверятьКороткиеЛитералы";
	Возврат Неопределено;
КонецФункции

Процедура ЗагрузитьНастройкуВФорме(НастройкаФормы, ДопПараметры) Экспорт 
	
	ирКлиент.ЗагрузитьНастройкуФормыЛкс(ЭтаФорма, НастройкаФормы); 
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ирКлиент.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ирКлиент.СоздатьМенеджерСохраненияНастроекФормыЛкс(ЭтаФорма);
	ПриЛюбомОткрытии();

КонецПроцедуры

Процедура ПриЛюбомОткрытии() Экспорт
	ЭтаФорма.ДатаОбновленияКэша = ирОбщий.ДатаОбновленияКэшаМодулейЛкс();
	ирОбщий.ОбновитьТекстПослеМаркераЛкс(ЭтаФорма.Заголовок,, ПараметрМодуль, ": ");
	//Обновить(); // Не помогает обновить отображаемый заголовок сразу
	Если ПараметрИмяМетода <> Неопределено Тогда
		СтрокаМетода = ОшибкиМодуля.Найти(ПараметрИмяМетода, "Метод");
		Если СтрокаМетода <> Неопределено Тогда
			ЭлементыФормы.ОшибкиМодуля.ТекущаяСтрока = СтрокаМетода;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ПриЗакрытии()
	ирКлиент.Форма_ПриЗакрытииЛкс(ЭтаФорма);
КонецПроцедуры

Процедура ОшибкиМодуляПриАктивизацииСтроки(Элемент)
	ЭлементыФормы.ПолеТекстаВхождения.УстановитьТекст("");
	ТекущаяСтрока = Элемент.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ирКлиент.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент); 
	ирКлиент.РазобратьПозициюМодуляВСтрокеТаблицыЛкс(Элемент.ТекущаяСтрока, ПараметрМодуль, ЭлементыФормы.ПолеТекстаВхождения);
КонецПроцедуры

Процедура ОшибкиМодуляПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	ирКлиент.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
КонецПроцедуры

Процедура ОшибкиМодуляВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	Если Колонка.Имя = Элемент.Колонки.Ссылка.Имя Тогда
		ирКлиент.ПоказатьСсылкуНаСтрокуМодуляЛкс(ВыбраннаяСтрока.Ссылка);
	Иначе 
		Если Не ирКлиент.ОткрытьСсылкуСтрокиМодуляЛкс(ВыбраннаяСтрока.Ссылка) Тогда 
			Если ПараметрМодуль = мПлатформа.ИмяДинамическогоМодуля() Тогда 
				МодульМетаданных = мМодульМетаданных;
				ФормаВладелец.Активизировать();           
				ФормаВладелец.ТекущийЭлемент = ПолеТекста.ЭлементФормы;  
				ПолеТекстаЛ = ПолеТекста;
			Иначе
				МодульМетаданных = мПлатформа.МодульМетаданныхИзКэша(ПараметрМодуль);
				ПолеТекстаЛ = ирКлиент.ОткрытьПолеТекстаМодуляКонфигурацииЛкс(ПараметрМодуль).ПолеТекста;
			КонецЕсли;
			ВыделитьСловоОшибки(ВыбраннаяСтрока, МодульМетаданных, ПолеТекстаЛ);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ВыделитьСловоОшибки(ВыбраннаяСтрока, Знач МодульМетаданных, Знач ПолеТекстаЛ) Экспорт
	МетодМодуля = мПлатформа.СтрокаМетодаМодуляПоИмени(МодульМетаданных, ВыбраннаяСтрока.Метод);
	Если МетодМодуля = Неопределено Тогда
		НачальнаяПозицияВПоле = мМодульМетаданных.ПозицияПрограммы;
	Иначе 
		НачальнаяПозицияВПоле = МетодМодуля.ПозицияТела;
	КонецЕсли;
	НачальнаяПозицияВПоле = НачальнаяПозицияВПоле + ВыбраннаяСтрока.ПозицияВМетоде + СтрДлина(ВыбраннаяСтрока.ВыражениеРодитель + ".");
	ДлинаСлова = СтрДлина(ВыбраннаяСтрока.Слово) - ?(Прав(ВыбраннаяСтрока.Слово, 1) = "(", 1, 0);
	ПолеТекстаЛ.УстановитьГраницыВыделения(НачальнаяПозицияВПоле, НачальнаяПозицияВПоле + ДлинаСлова,,, Истина);
КонецПроцедуры

Процедура ДействияФормыОбновить(Кнопка)
	
	ОбновитьОшибки();
	
КонецПроцедуры

//.
// Параметры:
//    ПолныйПересчет - Булево - 
Процедура ОбновитьОшибки(Знач ПолныйПересчет = Ложь) Экспорт
	//ирКлиент.ПолеТекстаМодуляБезСтруктурыТипаЛкс(мИмяМодуля, мОригинальныйТекст);
	Если ЭлементыФормы.ОшибкиМодуля.ТекущаяСтрока <> Неопределено Тогда
		ЗагрузитьМетодМодуляПоПозиции(ЭлементыФормы.ОшибкиМодуля.ТекущаяСтрока.Позиция);
	КонецЕсли; 
	Если ПроверитьВыражения(ЭлементыФормы.ОшибкиМодуля, ЭтаФорма, ПолныйПересчет, ПроверятьКороткиеЛитералы) Тогда 
		Если мПлатформа.ЛиСохранятьОшибкиМодуля(мМодульМетаданных) Тогда
			мПлатформа.ЗаписатьМодульВКэш(мМодульМетаданных, Истина);
		КонецЕсли;
	КонецЕсли;
	Если ОшибкиМодуля.Количество() > 0 Тогда
		ЭтаФорма.ТекущийЭлемент = ЭлементыФормы.ОшибкиМодуля;
	КонецЕсли;
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирКлиент.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	ирКлиент.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры
 
Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирКлиент.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура НадписьКэшМодулейНажатие(Элемент)
	ПолучитьФорму("ФормаНастройки", ФормаВладелец).Открыть();
КонецПроцедуры

Процедура ПриПовторномОткрытии(СтандартнаяОбработка)
	ПриЛюбомОткрытии();
КонецПроцедуры

Процедура ДействияФормыОбновитьВсе(Кнопка)
	ОбновитьОшибки(Истина);
КонецПроцедуры

Процедура ДействияФормыПодавитьПроверки(Кнопка)
	ВыбраннаяСтрока = ЭлементыФормы.ОшибкиМодуля.ТекущаяСтрока;
	Если ВыбраннаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если ПараметрМодуль = мПлатформа.ИмяДинамическогоМодуля() Тогда 
		ФормаВладелец.Активизировать();           
		ФормаВладелец.ТекущийЭлемент = ПолеТекста.ЭлементФормы;  
		ВыделитьСловоОшибки(ВыбраннаяСтрока, мМодульМетаданных, ПолеТекста);
		ВыделениеДвумерное = ПолеТекста.ВыделениеДвумерное();
		ДлинаСтроки = СтрДлина(ПолеТекста.ПолучитьСтроку(ВыделениеДвумерное.КонечнаяСтрока));
		ВыделениеДвумерное.НачальнаяКолонка = ДлинаСтроки + 1;
		ВыделениеДвумерное.КонечнаяКолонка = ВыделениеДвумерное.НачальнаяКолонка;
		ПолеТекста.УстановитьВыделениеДвумерное(ВыделениеДвумерное);
		ПолеТекста.ВыделенныйТекст(" " + ИнструкцияПодавленияПроверки());
	Иначе 
		СсылкаПодавленияПроверок = СтрЗаменить(ВыбраннаяСтрока.Ссылка, ")}", "!ПодавитьПроверки)}");
		ирКлиент.ОткрытьСсылкуСтрокиМодуляЛкс(СсылкаПодавленияПроверок, Истина);
	КонецЕсли;
КонецПроцедуры

ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирКлсПолеТекстаПрограммы.Форма.ОшибкиМодуля");

