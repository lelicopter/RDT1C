﻿
Процедура ЗначенияСвойствВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИмяРеквизита = ВыбраннаяСтрока.ИмяВТаблице;
	Если Не ЗначениеЗаполнено(ИмяРеквизита) Тогда
		Возврат;
	КонецЕсли; 
	ТипЗначения = Метаданные().ТабличныеЧасти.ТаблицаЖурнала.Реквизиты[ИмяРеквизита].Тип;
	#Если Сервер И Не Сервер Тогда
	    ТипЗначения = Новый ОписаниеТипов();
	#КонецЕсли
	СтрокаСвойстваИнфобаза = ЗначенияСвойств.Найти("Инфобаза", "ИмяВТаблице");
	Если СтрокаСвойстваИнфобаза <> Неопределено Тогда
		Инфобаза = СтрокаСвойстваИнфобаза.Значение;
	КонецЕсли; 
	Если Истина
		И ирОбщий.СтрокиРавныЛкс(ПолучитьИмяСвойстваБезМета(ИмяРеквизита), "ТекстSDBL")
		И (Ложь
			Или Инфобаза = ""
			Или ирОбщий.СтрокиРавныЛкс(Инфобаза, НСтр(СтрокаСоединенияИнформационнойБазы(), "Ref")))
	Тогда
		СтрокаСвойстваИнфобаза = ЗначенияСвойств.Найти("ТекстSDBL", "ИмяВТаблице");
		Если СтрокаСвойстваИнфобаза <> Неопределено Тогда
			ТекстSDBL = СтрокаСвойстваИнфобаза.Значение;
			ОткрытьТекстБДВКонверторе(ТекстSDBL, Не ирОбщий.СтрокиРавныЛкс(ИмяРеквизита, "ТекстSDBL"));
		КонецЕсли; 
	ИначеЕсли Истина
		И ТипЗначения.СодержитТип(Тип("Строка"))
		И ТипЗначения.КвалификаторыСтроки.Длина = 0
	Тогда
		ВариантПросмотра = ПолучитьВариантПросмотраТекстПоИмениРеквизита(ИмяРеквизита);
		ирКлиент.ОткрытьТекстЛкс(ВыбраннаяСтрока.Значение, ВыбраннаяСтрока.СвойствоСиноним, ВариантПросмотра, Истина,
			"" + ЭтаФорма.КлючУникальности + ВыбраннаяСтрока.ИмяВТаблице);
	ИначеЕсли Истина
		И ирОбщий.СтрокиРавныЛкс(ИмяРеквизита, "ИмяФайлаЛога")
	Тогда
		ирКлиент.ОткрытьФайлВПроводникеЛкс(ВыбраннаяСтрока.Значение);
	ИначеЕсли Истина
		И ВыбраннаяСтрока.ИмяВТаблице = "Пользователь" 
		И ЗначениеЗаполнено(ВыбраннаяСтрока.Значение) 
		И ПользователиИнформационнойБазы.НайтиПоИмени(ВыбраннаяСтрока.Значение) <> Неопределено 
	Тогда 
		ирКлиент.ОткрытьПользователяИБЛкс(ВыбраннаяСтрока.Значение);
	Иначе
		ирКлиент.ЯчейкаТабличногоПоляРасширенногоЗначения_ВыборЛкс(ЭтаФорма, Элемент, СтандартнаяОбработка);
	КонецЕсли; 

КонецПроцедуры

Процедура ПриОткрытии()
	
	ВыбраннаяСтрока = ЭтотОбъект.ТаблицаЖурнала.Найти(ЭтаФорма.КлючУникальности, "МоментВремени");
	Если ВыбраннаяСтрока = Неопределено Тогда
		// Автотест
		Возврат;
	КонецЕсли; 
	ЗначенияСвойств.Очистить();
	ОбработкаНастройкиЖурнала = ирОбщий.СоздатьОбъектПоИмениМетаданныхЛкс("Обработка.ирНастройкаТехножурнала");
	#Если Сервер И Не Сервер Тогда
		ОбработкаНастройкиЖурнала = Обработки.ирНастройкаТехножурнала.Создать();
	#КонецЕсли
	СписокСобытий = ОбработкаНастройкиЖурнала.ПолучитьСписокСобытий();
	СписокДействий = ОбработкаНастройкиЖурнала.ПолучитьСписокДействий();
	//СвойстваСобытия = ПолучитьСтруктуруСвойствСобытия(ВыбраннаяСтрока.Событие);
	СвойстваСобытия = ОбработкаНастройкиЖурнала.ПолучитьСтруктуруСвойствСобытия(ВыбраннаяСтрока.Событие);
	ТекущаяСтрокаСвойства = Неопределено;
	Если ВладелецФормы <> Неопределено Тогда
		СвойстваТаблицы = ВладелецФормы.ЭлементыФормы.ТаблицаЖурнала.Колонки;
	Иначе
		СвойстваТаблицы = Метаданные().ТабличныеЧасти.ТаблицаЖурнала.Реквизиты;
	КонецЕсли; 
	Для Каждого МетаРеквизит Из СвойстваТаблицы Цикл
		Если ТипЗнч(МетаРеквизит) = Тип("КолонкаТабличногоПоля") Тогда
			СвойствоСиноним = МетаРеквизит.ТекстШапки;
			ИмяКолонки = МетаРеквизит.Данные;
		Иначе
			СвойствоСиноним = МетаРеквизит.Представление();
			ИмяКолонки = МетаРеквизит.Имя;
		КонецЕсли; 
		Если Не ЗначениеЗаполнено(ИмяКолонки) Тогда
			Продолжить;
		КонецЕсли; 
		ЗначениеСвойства = ВыбраннаяСтрока[МетаРеквизит.Имя];
		Если Ложь
			Или Не ЗначениеЗаполнено(ЗначениеСвойства) 
		Тогда
			Продолжить;
		КонецЕсли; 
		ОписаниеСвойства = "";
		ОсновоеИмяРеквизита = МетаРеквизит.Имя;
		ОсновоеИмяРеквизита = ПолучитьИмяСвойстваБезМета(ОсновоеИмяРеквизита);
		ВнутреннееИмя = ОсновоеИмяРеквизита;
		СтрокаВнутреннегоИмени = мТаблицаКолонок.Найти(ОсновоеИмяРеквизита, "ИмяВТаблице");
		Если СтрокаВнутреннегоИмени <> Неопределено Тогда
			ВнутреннееИмя = СтрокаВнутреннегоИмени.ВнутреннееИмя;
		КонецЕсли;
		СтрокаСвойстваСобытия = мСвойстваСобытий.Найти(НРег(СтрЗаменить(ВнутреннееИмя, ":", "_")), "НИмя");
		Если СтрокаСвойстваСобытия <> Неопределено Тогда
			Если Истина
				И Не СвойстваСобытия.Свойство(ОсновоеИмяРеквизита) 
				И ЗначениеСвойства = Ложь 
			Тогда 
				Продолжить;
			КонецЕсли; 
			ОписаниеСвойства = СтрокаСвойстваСобытия.Описание;
			Если ОсновоеИмяРеквизита <> МетаРеквизит.Имя Тогда
				ОписаниеСвойства = ОписаниеСвойства + " в именах метаданных";
			КонецЕсли;
			Если ЗначениеЗаполнено(СтрокаСвойстваСобытия.Представление) Тогда
				СвойствоСиноним = СтрокаСвойстваСобытия.Представление;
			КонецЕсли; 
		Иначе
			ВнутреннееИмя = "";
		КонецЕсли; 
		СтрокаСвойства = ЗначенияСвойств.Добавить();
		СтрокаСвойства.СвойствоСиноним = СвойствоСиноним;
		СтрокаСвойства.СвойствоИмя = ВнутреннееИмя;
		СтрокаСвойства.ИмяВТаблице = МетаРеквизит.Имя;
		СтрокаСвойства.Значение = ЗначениеСвойства;
		СтрокаСвойства.ОписаниеСвойства = ОписаниеСвойства;
		СтрокаСвойства.Порядок = ЗначенияСвойств.Количество();
		Если ирОбщий.СтрокиРавныЛкс(ТекущееСвойство, МетаРеквизит.Имя) Тогда
			ТекущаяСтрокаСвойства = СтрокаСвойства;
		КонецЕсли;
		Если МетаРеквизит.Имя = "Событие" Тогда
			ОписаниеСобытия = СписокСобытий.НайтиПоЗначению(НРег(ВыбраннаяСтрока.Событие));
			Если ОписаниеСобытия <> Неопределено Тогда
				СтрокаСвойства = ЗначенияСвойств.Добавить();
				СтрокаСвойства.СвойствоСиноним = "Событие (описание)";
				СтрокаСвойства.Значение = ОписаниеСобытия.Представление;
				СтрокаСвойства.Порядок = ЗначенияСвойств.Количество();
			КонецЕсли; 
		КонецЕсли; 
		Если МетаРеквизит.Имя = "Действие" Тогда
			ОписаниеДействия = СписокДействий.НайтиПоЗначению(НРег(ВыбраннаяСтрока.Действие));
			Если ОписаниеДействия <> Неопределено Тогда
				СтрокаСвойства = ЗначенияСвойств.Добавить();
				СтрокаСвойства.СвойствоСиноним = "Действие (описание)";
				СтрокаСвойства.Значение = ОписаниеДействия.Представление;
				СтрокаСвойства.Порядок = ЗначенияСвойств.Количество();
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Если ТекущаяСтрокаСвойства <> Неопределено Тогда
		ЭлементыФормы.ЗначенияСвойств.ТекущаяСтрока = ТекущаяСтрокаСвойства;
	КонецЕсли; 
	ирОбщий.ОбновитьТекстПослеМаркераВСтрокеЛкс(ЭтаФорма.Заголовок,, ВыбраннаяСтрока.Событие + " " + Формат(ВыбраннаяСтрока.МоментВремени, "ЧГ="), ": ");

КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирКлиент.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработчикОжиданияСПараметрамиЛкс() Экспорт 
	
	ирКлиент.ОбработчикОжиданияСПараметрамиЛкс();

КонецПроцедуры

Процедура ДействияФормыНайтиВЖурнале(Кнопка)
	
	Если ВладелецФормы <> Неопределено Тогда
		ВыбраннаяСтрока = ЭтотОбъект.ТаблицаЖурнала.Найти(ЭтаФорма.КлючУникальности, "МоментВремени");
		Если ВыбраннаяСтрока = Неопределено Тогда
			Возврат;
		КонецЕсли; 
		ВладелецФормы.ЭлементыФормы.ТаблицаЖурнала.ТекущаяСтрока = ВыбраннаяСтрока;
		Если ВладелецФормы.ЭлементыФормы.ТаблицаЖурнала.ТекущаяСтрока <> ВыбраннаяСтрока Тогда
			Сообщить("Невозможно активизировать строку события в журнале при текущем отборе");
		КонецЕсли; 
		ирКлиент.Форма_АктивироватьОткрытьЛкс(ВладелецФормы);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ЗначенияСвойствПриАктивизацииСтроки(Элемент)
	
	ирКлиент.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);

КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирКлиент.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирКлиент.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура ЗначенияСвойствПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ирКлиент.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
	
КонецПроцедуры

ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирАнализТехножурнала.Форма.Событие");
