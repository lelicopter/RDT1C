﻿Функция СохраняемаяНастройкаФормы(выхНаименование, выхИменаСвойств) Экспорт 
	выхИменаСвойств = "";
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
	ЭтаФорма.КоличествоНайдено = ОшибкиМодуля.Количество();
	ирОбщий.ОбновитьТекстПослеМаркераЛкс(ЭтаФорма.Заголовок,, ПараметрМодуль, ": ");
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
	ТекущаяСтрока = Элемент.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ирКлиент.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент); 
	ирКлиент.РазобратьПозициюМодуляВСтрокеТаблицыЛкс(Элемент.ТекущаяСтрока, ПараметрМодуль);
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
			МетодМодуля = мПлатформа.СтрокаМетодаМодуляПоИмени(МодульМетаданных, ВыбраннаяСтрока.Метод);
			Если МетодМодуля = Неопределено Тогда
				НачальнаяПозицияВПоле = мМодульМетаданных.ПозицияПрограммы - 1; // Не понял почему возникло смещение на 1
			Иначе 
				НачальнаяПозицияВПоле = МетодМодуля.ПозицияТела;
			КонецЕсли;
			НачальнаяПозицияВПоле = НачальнаяПозицияВПоле + ВыбраннаяСтрока.ПозицияВМетоде + СтрДлина(ВыбраннаяСтрока.ВыражениеРодитель + ".");
			ДлинаСлова = СтрДлина(ВыбраннаяСтрока.Слово) - ?(Прав(ВыбраннаяСтрока.Слово, 1) = "(", 1, 0);
			ПолеТекстаЛ.УстановитьГраницыВыделения(НачальнаяПозицияВПоле, НачальнаяПозицияВПоле + ДлинаСлова,,, Истина);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ДействияФормыОбновить(Кнопка)
	
	ирКлиент.ПолеТекстаМодуляБезСтруктурыТипаЛкс(мИмяМодуля, мОригинальныйТекст);
	ЭтаФорма.КоличествоНайдено = 0;
	ПроверитьВыраженияПослеТочки(ЭлементыФормы.ОшибкиМодуля);
	
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

ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирКлсПолеТекстаПрограммы.Форма.ОшибкиМодуля");

