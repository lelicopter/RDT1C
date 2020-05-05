﻿Процедура ПриОткрытии()
	
	Если ВладелецФормы = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ТаблицаЖурнала = ВладелецФормы.ТаблицаЖурнала;
	СтрокаСобытияБлокировки = ЭтаФорма.КлючУникальности; 
	Если СтрокаСобытияБлокировки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	#Если Сервер И Не Сервер Тогда
	    СтрокаСобытияБлокировки = Обработки.ирАнализТехножурнала.Создать().ТаблицаЖурнала.Добавить();
	#КонецЕсли
	ЭтаФорма.Заголовок = ЭтаФорма.Заголовок + " - " + Формат(СтрокаСобытияБлокировки.МоментВремени, "ЧГ=");
	СтрокаДерева = ДеревоОжиданий.Строки.Добавить();
	ЗаполнитьСвойстваСтрокиДерева(СтрокаДерева, СтрокаСобытияБлокировки);
	
КонецПроцедуры

Процедура ЗаполнитьСвойстваСтрокиДерева(Знач СтрокаДерева, Знач СтрокаСобытияБлокировки, РодительЕстьЖертва = Неопределено)
	
	ЗаполнитьЗначенияСвойств(СтрокаДерева, СтрокаСобытияБлокировки); 
	СтрокаДерева.ЖертваВремя = СтрокаСобытияБлокировки.lkpto;
	СтрокаДерева.Соединение1С = СтрокаСобытияБлокировки.Соединение_;
	СтрокаДерева.Длительность = СтрокаСобытияБлокировки.Длительность / 1000;
	СтрокаДерева.ВиновникВремя = СтрокаСобытияБлокировки.lkato;
	Если СтрокаДерева.Уровень() = 2 Тогда
		Возврат;
	КонецЕсли; 
	Если РодительЕстьЖертва = Неопределено Тогда
		Если СтрокаСобытияБлокировки.lka Тогда
			ДобавитьДочерние(СтрокаДерева, СтрокаСобытияБлокировки.lkaid, Ложь);
		КонецЕсли; 
		Если СтрокаСобытияБлокировки.lkp Тогда
			ДобавитьДочерние(СтрокаДерева, СтрокаСобытияБлокировки.lkpid, Истина);
		КонецЕсли; 
	Иначе
		Если Истина
			И СтрокаСобытияБлокировки.lkp
			И РодительЕстьЖертва
		Тогда 
			ДобавитьДочерние(СтрокаДерева, СтрокаСобытияБлокировки.lkpid, РодительЕстьЖертва);
		КонецЕсли; 
		Если Истина
			И СтрокаСобытияБлокировки.lka
			И Не РодительЕстьЖертва
		Тогда 
			ДобавитьДочерние(СтрокаДерева, СтрокаСобытияБлокировки.lkaid, РодительЕстьЖертва);
		КонецЕсли; 
	КонецЕсли; 

КонецПроцедуры

Процедура ДобавитьДочерние(РодительскаяСтрокаДерева, НомераЗапросов, РодительЕстьЖертва = Истина)
	
	#Если Сервер И Не Сервер Тогда
	    РодительскаяСтрокаДерева = ДеревоОжиданий.Строки.Добавить();
		ТаблицаЖурнала = Обработки.ирАнализТехножурнала.Создать().ТаблицаЖурнала;
	#КонецЕсли
	Для Каждого НомерЗапроса Из ирОбщий.ПолучитьМассивИзСтрокиСРазделителемЛкс(НомераЗапросов, ",", Истина) Цикл
		ВременныйПостроительЗапроса = Новый ПостроительЗапроса;
		ВременныйПостроительЗапроса.ИсточникДанных = Новый ОписаниеИсточникаДанных(ТаблицаЖурнала);
		Если РодительЕстьЖертва Тогда
			ИмяПоляСвязи = "lkaid";
		Иначе
			ИмяПоляСвязи = "lkpid";
		КонецЕсли; 
		ОтборСвязи = ВременныйПостроительЗапроса.Отбор.Добавить(ИмяПоляСвязи);
		ОтборСвязи.Использование = Истина;
		ОтборСвязи.ВидСравнения = ВидСравнения.Содержит;
		ОтборСвязи.Значение = НомерЗапроса;
		//ВременныйПостроительЗапроса.Отбор.Добавить("Инфобаза").Установить(Инфобаза);
		//ВременныйПостроительЗапроса.Отбор.Добавить("ИнфобазаСУБД").Установить(Инфобаза);
		ВременныйПостроительЗапроса.Порядок.Установить("МоментВремени Возр");
		
		СтрокиЖурнала = ВременныйПостроительЗапроса.Результат.Выгрузить();
		Для Каждого СтрокаСобытияБлокировки Из СтрокиЖурнала Цикл
			Если Ложь
				Или (Истина
					И СтрокаСобытияБлокировки.Дата <= РодительскаяСтрокаДерева.Дата
					И СтрокаСобытияБлокировки.Дата >= РодительскаяСтрокаДерева.ДатаНачала)
				Или (Истина
					И СтрокаСобытияБлокировки.ДатаНачала <= РодительскаяСтрокаДерева.Дата
					И СтрокаСобытияБлокировки.ДатаНачала >= РодительскаяСтрокаДерева.ДатаНачала)
				Или (Истина
					И СтрокаСобытияБлокировки.Дата <= РодительскаяСтрокаДерева.Дата
					И СтрокаСобытияБлокировки.Дата >= РодительскаяСтрокаДерева.ДатаНачала
					И СтрокаСобытияБлокировки.ДатаНачала <= РодительскаяСтрокаДерева.Дата
					И СтрокаСобытияБлокировки.ДатаНачала >= РодительскаяСтрокаДерева.ДатаНачала)
				Или (Истина
					И СтрокаСобытияБлокировки.Дата >= РодительскаяСтрокаДерева.Дата
					И СтрокаСобытияБлокировки.Дата <= РодительскаяСтрокаДерева.ДатаНачала
					И СтрокаСобытияБлокировки.ДатаНачала >= РодительскаяСтрокаДерева.Дата
					И СтрокаСобытияБлокировки.ДатаНачала <= РодительскаяСтрокаДерева.ДатаНачала)
			Тогда
				СтрокаДерева = РодительскаяСтрокаДерева.Строки.Добавить();
				СтрокаДерева.РодительЕстьЖертва = РодительЕстьЖертва;
				ЗаполнитьСвойстваСтрокиДерева(СтрокаДерева, СтрокаСобытияБлокировки, РодительЕстьЖертва);
			КонецЕсли; 
		КонецЦикла;
	КонецЦикла;

КонецПроцедуры

Процедура КоманднаяПанель1НайтиВЖурнале(Кнопка)
	
	Если ВладелецФормы <> Неопределено Тогда
		Если ЭлементыФормы.ДеревоОжиданий.ТекущаяСтрока = Неопределено Тогда
			Возврат;
		КонецЕсли; 
		ВыбраннаяСтрока = ЭтотОбъект.ТаблицаЖурнала.Найти(ЭлементыФормы.ДеревоОжиданий.ТекущаяСтрока.МоментВремени, "МоментВремени");
		Если ВыбраннаяСтрока = Неопределено Тогда
			Возврат;
		КонецЕсли; 
		ВладелецФормы.ЭлементыФормы.ТаблицаЖурнала.ТекущаяСтрока = ВыбраннаяСтрока;
		Если ВладелецФормы.ЭлементыФормы.ТаблицаЖурнала.ТекущаяСтрока <> ВыбраннаяСтрока Тогда
			Сообщить("Невозможно активизировать строку события в журнале при текущем отборе");
		КонецЕсли; 
		ВладелецФормы.Активизировать();
	КонецЕсли; 

КонецПроцедуры

Процедура ДействияФормыСобытие(Кнопка = Неопределено)
	
	Если ЭлементыФормы.ДеревоОжиданий.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ФормаСобытия = ПолучитьФорму("Событие", , ЭлементыФормы.ДеревоОжиданий.ТекущаяСтрока.МоментВремени);
	ФормаСобытия.Открыть();

КонецПроцедуры

Процедура ОбновитьПанельТексты()
	
	ИмяКолонки = ТекущееСвойствоНаПанели();
	ЭлементыФормы.ТекстРодительскойСтроки.УстановитьТекст("");
	ЭлементыФормы.ТекстВыбраннойСтроки.УстановитьТекст("");
	ТекущаяСтрока = ЭлементыФормы.ДеревоОжиданий.ТекущаяСтрока;
	Если Истина
		И ТекущаяСтрока <> Неопределено
		И ТекущаяСтрока.Родитель = Неопределено
	Тогда
		ЭлементыФормы.ТекстРодительскойСтроки.УстановитьТекст(ТекущаяСтрока[ИмяКолонки]);
	ИначеЕсли Истина
		И ТекущаяСтрока <> Неопределено
		И ТекущаяСтрока.Родитель <> Неопределено
	Тогда
		ЭлементыФормы.ТекстРодительскойСтроки.УстановитьТекст(ТекущаяСтрока.Родитель[ИмяКолонки]);
		ЭлементыФормы.ТекстВыбраннойСтроки.УстановитьТекст(ТекущаяСтрока[ИмяКолонки]);
	КонецЕсли; 
	
КонецПроцедуры

Функция ТекущееСвойствоНаПанели()
	
	Перем ИмяКолонки;
	
	Если ЭлементыФормы.ПанельТексты.ТекущаяСтраница = ЭлементыФормы.ПанельТексты.Страницы.ТекстСУБД Тогда
		ИмяКолонки = "ТекстСУБД";
	ИначеЕсли ЭлементыФормы.ПанельТексты.ТекущаяСтраница = ЭлементыФормы.ПанельТексты.Страницы.ТекстСУБДМета Тогда
		ИмяКолонки = "ТекстСУБДМета";
	ИначеЕсли ЭлементыФормы.ПанельТексты.ТекущаяСтраница = ЭлементыФормы.ПанельТексты.Страницы.Контекст Тогда
		ИмяКолонки = "Контекст";
	КонецЕсли;
	Возврат ИмяКолонки;

КонецФункции

Процедура ДеревоОжиданийВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДействияФормыСобытие();
	
КонецПроцедуры

Процедура ДеревоОжиданийПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	ОбновитьПанельТексты();
	
КонецПроцедуры

Процедура ДействияФормыСтруктураФормы(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруФормыЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ПанельТекстыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	ОбновитьПанельТексты();

КонецПроцедуры

Процедура ДействияФормыОткрытьМенеджерТабличногоПоля(Кнопка)
	
	ирОбщий.ОткрытьМенеджерТабличногоПоляЛкс(ЭлементыФормы.ДеревоОжиданий, ЭтаФорма);
	
КонецПроцедуры

Процедура ДеревоОжиданийПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
	Если ДанныеСтроки.Родитель = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	Если ДанныеСтроки.РодительЕстьЖертва Тогда
		Картинка = ирКэш.КартинкаПоИмениЛкс("ирВыходящий");
		ЦветФона = Новый Цвет(240, 240, 255);
	Иначе
		Картинка = ирКэш.КартинкаПоИмениЛкс("ирВходящий");
		ЦветФона = Новый Цвет(240, 255, 240);
	КонецЕсли; 
	ОформлениеСтроки.Ячейки[0].УстановитьКартинку(Картинка);
	ОформлениеСтроки.ЦветФона = ЦветФона;
	
КонецПроцедуры

Процедура СравнитьТекстыНажатие(Элемент)
	
	ирОбщий.СравнитьЗначенияИнтерактивноЧерезXMLСтрокуЛкс(ЭлементыФормы.ТекстРодительскойСтроки.ПолучитьТекст(), ЭлементыФормы.ТекстВыбраннойСтроки.ПолучитьТекст(),, "Родительское", "Выбранное");
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирАнализТехножурнала.Форма.БлокировкаСУБД");
