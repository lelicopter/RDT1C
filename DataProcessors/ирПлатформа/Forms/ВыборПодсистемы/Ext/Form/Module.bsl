﻿Процедура ДобавитьПодсистему(СтрокиДереваПодсистем, Подсистема)

	стрПодсистема = СтрокиДереваПодсистем.Добавить();
	ПолноеИмяПодсистемы = СтрЗаменить(Подсистема.ПолноеИмя(), "Подсистема.", "");
	стрПодсистема.ПолноеИмя = ПолноеИмяПодсистемы;
	стрПодсистема.Имя = Подсистема.Имя;
	стрПодсистема.Представление = ?(ПустаяСтрока(Подсистема.Синоним), Подсистема.Имя, Подсистема.Синоним);
	стрПодсистема.ОбъектМД = Подсистема;
	
	Для каждого ДочерняяПодсистема из Подсистема.Подсистемы цикл
		ДобавитьПодсистему(стрПодсистема.Строки, ДочерняяПодсистема);
	КонецЦикла;
	//Если СтрокиДереваПодсистем.Родитель = Неопределено Тогда
	//	стрПодсистема = СтрокиДереваПодсистем.Добавить();
	//	стрПодсистема.ПолноеИмя = "<Не входящие в подсистемы>";
	//	стрПодсистема.Имя = Подсистема.Имя;
	//	стрПодсистема.Представление = ?(ПустаяСтрока(Подсистема.Синоним), Подсистема.Имя, Подсистема.Синоним);
	//	стрПодсистема.ОбъектМД = Неопределено;
	//КонецЕсли; 
	
КонецПроцедуры // ДобавитьПодсистему

Процедура ФильтроватьПодсистемыПоОбъектуМетаданных(СтрокиДереваПодсистем)

	КоличествоСтрокДереваПодсистем = СтрокиДереваПодсистем.Количество();
	Для сч = 1 По КоличествоСтрокДереваПодсистем Цикл
		ДочерняяПодсистема = СтрокиДереваПодсистем[КоличествоСтрокДереваПодсистем - сч];
		Если ДочерняяПодсистема.Строки.Количество() = 0 Тогда
			МДПодсистема = Метаданные.НайтиПополномуИмени("Подсистема." + СтрЗаменить(ДочерняяПодсистема.ПолноеИмя, ".", ".Подсистема."));
			Если НЕ МДПодсистема.Состав.Содержит(МДОбъект) Тогда
				СтрокиДереваПодсистем.Удалить(ДочерняяПодсистема);				
			КонецЕсли;
		Иначе
			ФильтроватьПодсистемыПоОбъектуМетаданных(ДочерняяПодсистема.Строки);
			МДПодсистема = Метаданные.НайтиПополномуИмени("Подсистема." + СтрЗаменить(ДочерняяПодсистема.ПолноеИмя, ".", ".Подсистема."));
			Если ДочерняяПодсистема.Строки.Количество() = 0 И НЕ МДПодсистема.Состав.Содержит(МДОбъект) Тогда
				// Все вложенные подсистемы не содержат объекта. Сама подсистема тоже
				СтрокиДереваПодсистем.Удалить(ДочерняяПодсистема);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

Процедура ПриОткрытии()
	
	Если НачальноеЗначениеВыбора = Неопределено Тогда
		Если ТипЗнч(ВладелецФормы) = Тип("ПолеВвода") Тогда
			НачальноеЗначениеВыбора = ВладелецФормы.Значение;
		КонецЕсли; 
	КонецЕсли; 
	Если ЗначениеЗаполнено(НачальноеЗначениеВыбора) Тогда
		МассивДляПометки = Новый Массив;
		Если МножественныйВыбор И ТипЗнч(НачальноеЗначениеВыбора) = Тип("СписокЗначений") Тогда
			МассивДляПометки = НачальноеЗначениеВыбора.ВыгрузитьЗначения();
		ИначеЕсли ЗначениеЗаполнено(НачальноеЗначениеВыбора) Тогда 
			МассивДляПометки.Добавить(НачальноеЗначениеВыбора);
		КонецЕсли; 
		Для Каждого ИмяПодсистемы Из МассивДляПометки Цикл
			СтрокаДерева = ДеревоПодсистем.Строки.Найти(ИмяПодсистемы, "ПолноеИмя", Истина);
			Если СтрокаДерева <> Неопределено Тогда
				УстановитьЗначениеФлажкаСтроки(СтрокаДерева, 1);
				ЭлементыФормы.ДеревоПодсистем.ТекущаяСтрока = СтрокаДерева;
			КонецЕсли; 
		КонецЦикла;
	КонецЕсли; 
	Если ТипЗнч(МДОбъект) = Тип("ОбъектМетаданных") Тогда
		ФильтроватьПодсистемыПоОбъектуМетаданных(ДеревоПодсистем.Строки);
		ирОбщий.ОбновитьТекстПослеМаркераВСтрокеЛкс(ЭтаФорма.Заголовок,, МДОбъект.ПолноеИмя(), ": ");
	КонецЕсли;
	Если Не РежимВыбора Тогда
		ЭлементыФормы.ДействияФормы.Кнопки.Удалить(ЭлементыФормы.ДействияФормы.Кнопки.ПрименитьИЗакрыть);
	КонецЕсли; 
		
КонецПроцедуры

Процедура КоманднаяПанель1ИмяСиноним(Кнопка)
	
	РежимИмяСиноним = Не Кнопка.Пометка;
	Кнопка.Пометка = РежимИмяСиноним;
	ирОбщий.ТабличноеПоле_ОбновитьКолонкиИмяСинонимЛкс(ЭлементыФормы.ДеревоПодсистем, РежимИмяСиноним);
	
КонецПроцедуры

Процедура ДеревоПодсистемВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Для Каждого ВыбраннаяСтрока Из ВыбраннаяСтрока Цикл
		Если ВыбраннаяСтрока.Уровень() > 0 Тогда
			ВыбраннаяСтрока.Пометка = 1;
		КонецЕсли; 
	КонецЦикла;
	ДействияФормыПрименитьИЗакрыть();
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

Процедура ДействияФормыСнятьПометки(Кнопка)
	
	ИзменитьПометкиВыделенныхСтрок(Ложь);
	
КонецПроцедуры

Процедура ДействияФормыСнятьПометкиСоВсемиПотомками(Кнопка)
	
	ИзменитьПометкиВыделенныхСтрок(Ложь, Истина);
	
КонецПроцедуры

Процедура ДействияФормыУстановитьПометки(Кнопка)
	
	ИзменитьПометкиВыделенныхСтрок(Истина);
	
КонецПроцедуры

Процедура ДействияФормыУстановитьПометкиСоВсемиПотомками(Кнопка)
	
	ИзменитьПометкиВыделенныхСтрок(Истина, Истина);
	
КонецПроцедуры

Процедура ИзменитьПометкиВыделенныхСтрок(НовоеЗначениеПометки, СоВсемиПотоками = Ложь)
	
	ТабличноеПоле = ЭлементыФормы.ДеревоПодсистем;
	ВыделенныеСтроки = ТабличноеПоле.ВыделенныеСтроки;
	Если Не СоВсемиПотоками И ВыделенныеСтроки.Количество() < 2 Тогда
		ВыделенныеСтроки = ТабличноеПоле.Значение.Строки;
	КонецЕсли; 
	Для Каждого СтрокаДерева Из ВыделенныеСтроки Цикл
		УстановитьЗначениеФлажкаСтроки(СтрокаДерева, НовоеЗначениеПометки, , СоВсемиПотоками);
	КонецЦикла;
	//Если МножественныйВыбор Тогда
	//	НачальноеЗначениеВыбора = ПолучитьКлючиПомеченныхСтрок();
	//КонецЕсли;

КонецПроцедуры

Процедура УстановитьЗначениеФлажкаСтроки(ТекущаяСтрока, НовоеЗначениеПометки, ОбновлятьРодителя = Неопределено, СоВсемиПотоками = Ложь)
	
	ИмяКолонкиПометки = "Пометка";
	ТекущаяСтрока[ИмяКолонкиПометки] = НовоеЗначениеПометки;
	Если ОбновлятьРодителя = Неопределено Тогда
		ирОбщий.УстановитьПометкиРодителейЛкс(ТекущаяСтрока.Родитель,, Истина);
	Иначе
		ОбновлятьРодителя = Истина;
	КонецЕсли; 
	ОбновлятьРодителяСнизу = Ложь;
	Если Ложь
		//Или ТекущаяСтрока.Уровень() = 0
		//Или НовоеЗначениеПометки = 0
		Или СоВсемиПотоками
	Тогда
		Для Каждого СтрокаДерева Из ТекущаяСтрока.Строки Цикл
			УстановитьЗначениеФлажкаСтроки(СтрокаДерева, НовоеЗначениеПометки, ОбновлятьРодителяСнизу, СоВсемиПотоками);
		КонецЦикла;  
	КонецЕсли; 
	//Если ОбновлятьРодителяСнизу Тогда
		ирОбщий.УстановитьПометкиРодителейЛкс(ТекущаяСтрока,, Истина);
	//КонецЕсли; 

КонецПроцедуры

Процедура ДействияФормыПрименитьИЗакрыть(Кнопка = Неопределено)
	
	Если РежимВыбора Тогда
		Если МножественныйВыбор Тогда
			Результат = Новый СписокЗначений;
			Для Каждого СтрокаДерева Из ДеревоПодсистем.Строки.НайтиСтроки(Новый Структура("Пометка", 1), Истина) Цикл
				Результат.Добавить(СтрокаДерева.ПолноеИмя);
			КонецЦикла;
		Иначе
			Если ЭлементыФормы.ДеревоПодсистем.ТекущаяСтрока <> Неопределено Тогда
				Результат = ЭлементыФормы.ДеревоПодсистем.ТекущаяСтрока.ПолноеИмя;
			КонецЕсли; 
		КонецЕсли; 
		ОповеститьОВыборе(Результат);
	КонецЕсли; 
	
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ирОбщий.ФормаОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура ДеревоПодсистемПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ирОбщий.ТабличноеПоле_ОформитьЯчейкиИмяСинонимЛкс(Элемент, ОформлениеСтроки,,, "", ?(МножественныйВыбор, "Пометка", ""));

КонецПроцедуры

Процедура ДеревоПодсистемПриИзмененииФлажка(Элемент, Колонка)
	
	ТекущаяСтрока = Элемент.ТекущиеДанные;
	ИмяКолонкиПометки = "Пометка";
	Если ТекущаяСтрока.Уровень() > 0 Тогда
		НовоеЗначениеПометки = ТекущаяСтрока[ИмяКолонкиПометки];
		НовоеЗначениеПометки = НовоеЗначениеПометки -1;
		Если НовоеЗначениеПометки < 0 Тогда
			НовоеЗначениеПометки = 1;
		КонецЕсли;
	КонецЕсли; 
	УстановитьЗначениеФлажкаСтроки(ТекущаяСтрока, НовоеЗначениеПометки);

КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.ВыборПодсистемы");
ДобавитьПодсистему(ДеревоПодсистем.Строки, Метаданные);
