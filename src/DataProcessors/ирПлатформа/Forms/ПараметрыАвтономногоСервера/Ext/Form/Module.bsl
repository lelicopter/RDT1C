﻿
Процедура ПриОткрытии()
	
	ирКлиент.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ЭтаФорма.ИмяПользователя = ИмяПользователя();  
	Файл = ирОбщий.ИсполняемыйФайлАвтоСервераЛкс(); 
	Если Файл <> Неопределено Тогда
		ЭтаФорма.ИсполняемыйФайл = Файл.ПолноеИмя;
	КонецЕсли;
	ОбновитьДоступность();
	
КонецПроцедуры

Процедура ОсновныеДействияФормыКнопкаОК(Кнопка = Неопределено)
	
	Закрыть(Истина);
	
КонецПроцедуры

Процедура АутентификацияСервераПриИзменении(Элемент)
	
	ОбновитьДоступность();
	
КонецПроцедуры

Процедура ОбновитьДоступность()
	
КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	ирКлиент.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
КонецПроцедуры

Процедура ПриЗакрытии()
	ирКлиент.Форма_ПриЗакрытииЛкс(ЭтаФорма);
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирКлиент.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ИмяПользователяНачалоВыбора(Элемент, СтандартнаяОбработка)
	ирКлиент.ПолеВводаПользователя_НачалоВыбораЛкс(Элемент, СтандартнаяОбработка);
КонецПроцедуры  

Процедура НадписьПараметрыСУБДНажатие(Элемент)
	ирКлиент.ОткрытьФормуСоединенияСУБДЛкс();
КонецПроцедуры

Процедура ИсполняемыйФайлОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ирКлиент.ОткрытьФайлВПроводникеЛкс(ИсполняемыйФайл);
КонецПроцедуры

Процедура ИсполняемыйФайлНачалоВыбора(Элемент, СтандартнаяОбработка)
	РезультатФормы = ирКлиент.ВыбратьФайлЛкс(, "exe",, ИсполняемыйФайл,,, "Выберите файл ibcmd.exe");
	Если РезультатФормы <> Неопределено Тогда
		Файл = Новый Файл(РезультатФормы);
		Если Файл.Существует() и ирОбщий.СтрокиРавныЛкс(Файл.Имя, "ibcmd.exe") Тогда 
			ЭтаФорма.ИсполняемыйФайл = Файл.ПолноеИмя;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.ПараметрыАвтономногоСервера");
