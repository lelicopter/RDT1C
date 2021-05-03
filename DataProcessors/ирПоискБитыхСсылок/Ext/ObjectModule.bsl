﻿//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирПривилегированный Экспорт;

Перем мПлатформа Экспорт;
Перем мЗапрос Экспорт;
Перем мИмяТаблицыПустыхСсылок;
Перем мИмяТаблицыТипов;

Функция РеквизитыОбработки(Параметры) Экспорт 
	
	Результат = ирОбщий.РеквизитыОбработкиЛкс(ЭтотОбъект);
	Возврат Результат;
	
КонецФункции

Функция ПолучитьЗапросВыборки(Параметры) Экспорт 
	
	ПолучатьДанные = Параметры.ПолучатьДанные;
	ЭтаФорма = Параметры.ЭтаФорма;
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	мЗапрос = Неопределено;
	Если ПолучатьДанные Тогда
		СвязанныеДанные.Очистить();
	КонецЕсли; 
	ТипыСсылок = Новый Соответствие;
	Запрос = ЗапросСВременнымиТаблицами(ТипыСсылок);
	
	#Если Сервер И Не Сервер Тогда
		ЗагрузитьРезультатОбработкиОбъекта();
		ОбработатьЭлементыОбъекта();
	#КонецЕсли
    СтруктураПотоков = ирОбщий.НоваяСтруктураМногопоточнойОбработкиЛкс("ОбработатьЭлементыОбъекта", ЭтотОбъект, "ЗагрузитьРезультатОбработкиОбъекта", КоличествоОбъектовВПорции,
		ВыполнятьНаСервере, ?(ПолучатьДанные, КоличествоПотоков, 1));
		
	ТаблицаВсехТаблиц = ирКэш.ТаблицаВсехТаблицБДЛкс();
	ТекстПакета = Неопределено;
	ТекстЗапроса = "";
	КоличествоТиповМаксБезДробления = 200; // 200 - оптимальное
	КоличествоТиповВОднойЧастиДробления = 1; // после >5 начинается заметное замедление на моем домашнем MSSQL стенде, экспериментально установлено что 1 - самое быстрое и удобное значение
	МаксимальноеЧислоСоединенийВЗапросе = 20; // 20 - оптимальное
	СчетчикЧастейОбъединения = 0;
	СчетчикЗапросовПакета = 0;
	Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(ТаблицаВсехТаблиц.Количество());
	Для Каждого ОписаниеТаблицы Из ТаблицаВсехТаблиц Цикл
		ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
		Если Ложь
			Или ирОбщий.ЛиКорневойТипКритерияОтбораЛкс(ОписаниеТаблицы.Тип)
			Или (Истина
				//И Не УчитыватьВиртуальныеТаблицы
				И ОписаниеТаблицы.Тип = "ВиртуальнаяТаблица")
			Или (Истина
				И ТолькоРегистраторы
				И Не ирОбщий.ЛиКорневойТипРегистраБДЛкс(ОписаниеТаблицы.Тип))
		Тогда
			Продолжить;
		КонецЕсли; 
		Если ирОбщий.ПроверитьПропуститьНедоступнуюТаблицуБДЛкс(ОписаниеТаблицы) Тогда
			Продолжить;
		КонецЕсли; 
		ПолноеИмяТаблицыБД = ОписаниеТаблицы.ПолноеИмя;
		ПоляТаблицыБД = ирКэш.ПоляТаблицыБДЛкс(ПолноеИмяТаблицыБД);
		Если ПоляТаблицыБД = Неопределено Тогда
			// https://www.hostedredmine.com/issues/898118
			ирОбщий.СообщитьЛкс("Пропускаем таблицу БД """ + ОписаниеТаблицы.ПолноеИмя + """ с недоступными полями", СтатусСообщения.Внимание);
			Продолжить;
		КонецЕсли; 
		#Если Сервер И Не Сервер Тогда
			ПоляТаблицыБД = НайтиПоСсылкам().Колонки;
		#КонецЕсли
		Для Каждого ПолеТаблицыБД Из ПоляТаблицыБД Цикл
			Если Ложь
				Или ПолеТаблицыБД.ТипЗначения.СодержитТип(Тип("ТаблицаЗначений")) 
				Или (Истина
					И ТолькоРегистраторы
					И Не ирОбщий.СтрокиРавныЛкс(ПолеТаблицыБД.Имя, "Регистратор"))
				Или (Истина
					И ОписаниеТаблицы.Тип = "Изменения"
					И Не УчитыватьВсеКолонкиТаблицИзменений
					И Не ирОбщий.СтрокиРавныЛкс(ПолеТаблицыБД.Имя, "Узел"))
			Тогда
				Продолжить;
			КонецЕсли; 
			Если Истина // Защита от измерения Узел с основным отбором, иначе будет выдаваться ошибка "Поле не найдено "Т.Узел1""
				И ОписаниеТаблицы.Тип = "Изменения"
				И УчитыватьВсеКолонкиТаблицИзменений
			Тогда
				ПолноеИмяМД = ирОбщий.СтрокаМеждуМаркерамиЛкс(ПолноеИмяТаблицыБД,, ".Изменения");
				Если Не ирОбщий.ЭтоКорректноеПолеТаблицыИзмененийЛкс(ПолноеИмяМД, "" + ПолеТаблицыБД.Имя) Тогда
					ирОбщий.СообщитьЛкс("В таблице изменений регистра " + ПолноеИмяМД + " пропущено поле " + ПолеТаблицыБД.Имя + ", т.к. оно порождено конфликтом имен полей");
					Продолжить;
				КонецЕсли; 
			КонецЕсли; 
			ВыражениеПоляСУсечениемТипов = Неопределено;
			СписокТипов = Неопределено;
			СчетчикТипов = 0;
			ТипыЗначенияПоля = ПолеТаблицыБД.ТипЗначения.Типы();
			КоличествоТипов = ТипыЗначенияПоля.Количество();
			РежимДробления = КоличествоТипов > КоличествоТиповМаксБезДробления;
			Для Каждого ТипЗначенияПоля Из ТипыЗначенияПоля Цикл
				ИмяИскомогоТипа = ТипыСсылок[ТипЗначенияПоля];
				Если ИмяИскомогоТипа <> Неопределено Тогда
					Если ВыражениеПоляСУсечениемТипов = Неопределено Тогда
						ВыражениеПоляСУсечениемТипов = Новый ЗаписьXML;
						ВыражениеПоляСУсечениемТипов.УстановитьСтроку("");
						СписокТипов = Новый Массив;
					КонецЕсли; 
					Если РежимДробления Тогда
						ВыражениеПоляСУсечениемТипов.ЗаписатьБезОбработки("
						|		КОГДА Т." + ПолеТаблицыБД.Имя + " ССЫЛКА " + ИмяИскомогоТипа + " ТОГДА ВЫРАЗИТЬ(Т." + ПолеТаблицыБД.Имя + " КАК " + ИмяИскомогоТипа + ")");
					КонецЕсли; 
					СписокТипов.Добавить(ТипЗначенияПоля);
					СчетчикТипов = СчетчикТипов + 1;
					Если РежимДробления И СчетчикТипов = КоличествоТиповВОднойЧастиДробления Тогда
						ВыражениеПоляСУсечениемТипов = ВыражениеПоляСУсечениемТипов.Закрыть();
						ДобавитьЧастьОбъединения(Запрос, ПолучатьДанные, ТекстПакета, ВыражениеПоляСУсечениемТипов, мИмяТаблицыТипов, ОписаниеТаблицы, ПолеТаблицыБД, ПолноеИмяТаблицыБД, ТекстЗапроса,
							СчетчикЧастейОбъединения, СписокТипов, СчетчикЧастейОбъединения, мИмяТаблицыПустыхСсылок, МаксимальноеЧислоСоединенийВЗапросе, СтруктураПотоков, ЭтаФорма, СчетчикЗапросовПакета);
						ВыражениеПоляСУсечениемТипов = Неопределено;
						СписокТипов = Неопределено;
						СчетчикТипов = 0;
					Иначе
						СчетчикЧастейОбъединения = СчетчикЧастейОбъединения + 1;
					КонецЕсли; 
				КонецЕсли; 
			КонецЦикла; 
			Если ВыражениеПоляСУсечениемТипов <> Неопределено Тогда
				ВыражениеПоляСУсечениемТипов = ВыражениеПоляСУсечениемТипов.Закрыть();
				ДобавитьЧастьОбъединения(Запрос, ПолучатьДанные, ТекстПакета, ВыражениеПоляСУсечениемТипов, мИмяТаблицыТипов, ОписаниеТаблицы, ПолеТаблицыБД, ПолноеИмяТаблицыБД, ТекстЗапроса,
					СчетчикЧастейОбъединения, СписокТипов, СчетчикЧастейОбъединения, мИмяТаблицыПустыхСсылок, МаксимальноеЧислоСоединенийВЗапросе, СтруктураПотоков, ЭтаФорма, СчетчикЗапросовПакета);
			КонецЕсли; 
		КонецЦикла;
		//ВыполнитьДобавитьНакопленныйЗапрос(Запрос, ПолучатьДанные, ТекстЗапроса, ТекстПакета, СчетчикЧастейОбъединения, СтруктураПотоков, ЭтаФорма); // Наверно не нужно
	КонецЦикла;
	ВыполнитьДобавитьНакопленныйЗапрос(Запрос, ПолучатьДанные, ТекстЗапроса, ТекстПакета, СчетчикЧастейОбъединения, СтруктураПотоков, ЭтаФорма);
	ирОбщий.ОжидатьЗавершенияВсехПотоковОбработкиЛкс(СтруктураПотоков);
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	Если ТекстПакета <> Неопределено Тогда
		ТекстПакета = ТекстПакета.Закрыть();
	КонецЕсли; 
	Запрос.Текст = ТекстПакета;
	Результат = Новый Структура;
	Результат.Вставить("Запрос", Запрос);
	Если ЭтаФорма <> Неопределено Тогда
		Результат.Вставить("СвязанныеДанные", СвязанныеДанные);
	Иначе
		Результат.Вставить("СвязанныеДанные", СвязанныеДанные.Выгрузить());
	КонецЕсли; 
	Возврат Результат;

КонецФункции

Функция ЗапросСВременнымиТаблицами(ТипыСсылок = Неопределено) Экспорт 
	
	Если мЗапрос <> Неопределено Тогда
		Возврат мЗапрос;
	КонецЕсли; 
	ТипыСсылок = Новый Соответствие;
	ТипыСсылокМассив = Новый Массив;
	ТаблицаПустыхСсылок = Новый ТаблицаЗначений;
	ТаблицаПустыхСсылок.Колонки.Добавить("ПустаяСсылка");
	ТаблицаПустыхСсылок.Добавить(); // Неопределено тоже нужно
	Если ЛиВсеТипы Тогда
		СтрокиМетаОбъектов = мПлатформа.ТаблицаТиповМетаОбъектов.НайтиСтроки(Новый Структура("Категория", 0));
		Для Каждого СтрокаТаблицыМетаОбъектов Из СтрокиМетаОбъектов Цикл
			Единственное = СтрокаТаблицыМетаОбъектов.Единственное;
			Если ирОбщий.ЛиКорневойТипСсылочногоОбъектаБДЛкс(Единственное) Тогда
				Для Каждого МетаОбъект Из Метаданные[СтрокаТаблицыМетаОбъектов.Множественное] Цикл
					Тип = Тип(СтрокаТаблицыМетаОбъектов.Единственное + "Ссылка." + МетаОбъект.Имя);
					ТипыСсылок.Вставить(Тип, МетаОбъект.ПолноеИмя());
					ТипыСсылокМассив.Добавить(Тип);
					ТаблицаПустыхСсылок.Добавить().ПустаяСсылка = Новый (Тип);
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;
	Иначе
		Для Каждого ИмяИскомогоТипа Из ТипыСсылокДляПоиска Цикл
			Тип = Тип(ирОбщий.ИмяТипаИзПолногоИмениТаблицыБДЛкс(ИмяИскомогоТипа.Значение));
			ТипыСсылок.Вставить(Тип, ИмяИскомогоТипа);
			ТипыСсылокМассив.Добавить(Тип);
			ТаблицаПустыхСсылок.Добавить().ПустаяСсылка = Новый (Тип);
		КонецЦикла; 
	КонецЕсли; 
 	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Текст = ирОбщий.ПолучитьТекстЗапросаВсехТиповСсылокЛкс(мИмяТаблицыТипов, Новый ОписаниеТипов(ТипыСсылокМассив)) + ";" + Символы.ПС;
	Запрос.Параметры.Вставить("СписокТипов", ТипыСсылокМассив);
	ТаблицаПустыхСсылок = ирОбщий.СузитьТипыКолонокТаблицыБезПотериДанныхЛкс(ТаблицаПустыхСсылок);
	#Если Сервер И Не Сервер Тогда
		ТаблицаПустыхСсылок = Новый ТаблицаЗначений;
	#КонецЕсли
	Запрос.Параметры.Вставить("ТаблицаПустыхСсылок", ТаблицаПустыхСсылок);
	Запрос.Текст = Запрос.Текст + "ВЫБРАТЬ * ПОМЕСТИТЬ ТаблицаПустыхСсылок ИЗ &ТаблицаПустыхСсылок КАК ТаблицаПустыхСсылок ИНДЕКСИРОВАТЬ ПО ПустаяСсылка;" + Символы.ПС;
	Запрос.Выполнить();
	мЗапрос = Запрос;
	Возврат мЗапрос;

КонецФункции

Процедура ВыполнитьДобавитьНакопленныйЗапрос(Знач Запрос, Знач ПолучатьДанные, ТекстЗапроса, ТекстПакета, СчетчикЧастейОбъединения, СтруктураПотоков, ЭтаФорма = Неопределено, СчетчикЗапросовПакета = 0)
	
	#Если Сервер И Не Сервер Тогда
		Запрос = Новый Запрос;
	#КонецЕсли
	Если Не ЗначениеЗаполнено(ТекстЗапроса) Тогда
		Возврат;
	КонецЕсли; 
	Если ПолучатьДанные Тогда
		ПараметрыОбработкиОбъекта = Новый Структура;
		ПараметрыОбработкиОбъекта.Вставить("ТипыСсылокДляПоиска", ТипыСсылокДляПоиска);
		ПараметрыОбработкиОбъекта.Вставить("ТекстЗапроса", ТекстЗапроса);
		ПараметрыОбработкиОбъекта.Вставить("Параметры", Запрос.Параметры);
		ирОбщий.ДобавитьОбъектВОчередьМногопоточнойОбработкиЛкс(СтруктураПотоков, ПараметрыОбработкиОбъекта);
	Иначе
		МаксЗапросов = 100;
		Если СчетчикЗапросовПакета < МаксЗапросов Тогда // Консоль запросов не рассчитана на такие большие тексты https://www.hostedredmine.com/issues/915850
			Если ТекстПакета = Неопределено Тогда
				ТекстПакета = Новый ЗаписьXML;
				ТекстПакета.УстановитьСтроку("");
			Иначе
				ТекстЗапроса = ";//////////////////////" + ТекстЗапроса;
			КонецЕсли; 
			ТекстПакета.ЗаписатьБезОбработки(ТекстЗапроса);
			СчетчикЗапросовПакета = СчетчикЗапросовПакета + 1;
			Если СчетчикЗапросовПакета = МаксЗапросов Тогда
				ирОбщий.СообщитьЛкс("Запрос обрезан из-за большого размера текста", СтатусСообщения.Внимание);
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 
	СчетчикЧастейОбъединения = 0;
	ТекстЗапроса = "";

КонецПроцедуры

Процедура ЗагрузитьРезультатОбработкиОбъекта(Результат, Знач ЭтаФорма = Неопределено) Экспорт 
	
	СтароеКоличествоСтрок = СвязанныеДанные.Количество();
	ирОбщий.ЗагрузитьВТаблицуЗначенийЛкс(Результат, СвязанныеДанные);
	ТаблицаВсехТаблиц = ирКэш.ТаблицаВсехТаблицБДЛкс();
	Для Индекс = СтароеКоличествоСтрок По СвязанныеДанные.Количество() - 1 Цикл
		СтрокаСвязанныхДанных = СвязанныеДанные[Индекс];
		ПолноеИмяТаблицы = СтрокаСвязанныхДанных.ПолноеИмяТаблицы;
		ОписаниеТаблицы = ТаблицаВсехТаблиц.Найти(НРег(ПолноеИмяТаблицы), "НПолноеИмя");
		СтрокаСвязанныхДанных.ИмяТаблицы = ОписаниеТаблицы.Имя;
		СтрокаСвязанныхДанных.ПредставлениеТаблицы = ОписаниеТаблицы.Представление;
	КонецЦикла;
	Если Истина
		И ЭтаФорма <> Неопределено 
		И СтароеКоличествоСтрок < 40
	Тогда
		ЭтаФорма.ЭлементыФормы.СвязанныеДанные.ОбновитьСтроки();
	КонецЕсли;

КонецПроцедуры

Функция ОбработатьЭлементыОбъекта(ПараметрыОбработкиОбъекта) Экспорт 
	
	// Выполнение запросов в цикле здесь почему то быстрее пакетного запроса
	ЭтотОбъект.ТипыСсылокДляПоиска = ПараметрыОбработкиОбъекта.ТипыСсылокДляПоиска;
	Запрос = ЗапросСВременнымиТаблицами();
	Запрос.Текст = ПараметрыОбработкиОбъекта.ТекстЗапроса;
	Если Запрос.Параметры <> ПараметрыОбработкиОбъекта.Параметры Тогда
		ирОбщий.СкопироватьУниверсальнуюКоллекциюЛкс(ПараметрыОбработкиОбъекта.Параметры, Запрос.Параметры);
	КонецЕсли; 
	РезультатЗапроса = Запрос.Выполнить();
	ТаблицаРезультата = РезультатЗапроса.Выгрузить();
	Возврат ТаблицаРезультата;

КонецФункции

Процедура ДобавитьЧастьОбъединения(Запрос, ПолучатьДанные, ТекстПакета, Знач ВыражениеПоляСУсечениемТипов, Знач мИмяТаблицыТипов, Знач ОписаниеТаблицы, Знач ПолеТаблицыБД, Знач ПолноеИмяТаблицыБД, ТекстЗапроса,
	СчетчикПодзапросов, СписокТипов, СчетчикЧастейОбъединения, мИмяТаблицыПустыхСсылок, МаксимальноеЧислоСоединенийВЗапросе = 100, СтруктураПотоков, ЭтаФорма = Неопределено, СчетчикЗапросовПакета = Неопределено)
	
	#Если Клиент Тогда
	ОбработкаПрерыванияПользователя();
	#КонецЕсли 
	Если ЗначениеЗаполнено(ВыражениеПоляСУсечениемТипов) Тогда
		ИмяПараметраСписокТипов = "СписокТипов" + XMLСтрока(СчетчикЧастейОбъединения);
		Запрос.УстановитьПараметр(ИмяПараметраСписокТипов, СписокТипов);
		ВыражениеПоляСУсечениемТипов = "
		|	И ТИПЗНАЧЕНИЯ(Т." + ПолеТаблицыБД.Имя + ") В (&" + ИмяПараметраСписокТипов + ") // http://www.hostedredmine.com/issues/877555
		|	И (ВЫБОР " + ВыражениеПоляСУсечениемТипов + " КОНЕЦ).Ссылка ЕСТЬ NULL";
		//|	И " + ирОбщий.СтрокаМеждуМаркерамиЛкс(ВыражениеПоляСУсечениемТипов, "КОГДА ", " ТОГДА ", Ложь) + "
		//|	И " + ирОбщий.ПоследнийФрагментЛкс(ВыражениеПоляСУсечениемТипов, " ТОГДА ", Ложь) + ".Ссылка ЕСТЬ NULL";
	Иначе
		// Так при большом количестве типов будет ошибка MSSQL - Обработчик запросов исчерпал внутренние ресурсы, и ему не удалось предоставить план запроса. Это редкое событие, которое может происходить только при очень сложных запросах или запросах, которые обращаются к очень большому числу таблиц или секций.
		ВыражениеПоляСУсечениемТипов = "
		|	И Т." + ПолеТаблицыБД.Имя + ".Ссылка ЕСТЬ NULL";
	КонецЕсли; 
	СчетчикПодзапросов = СчетчикПодзапросов + 1;
	ТипТаблицы = ОписаниеТаблицы.Тип;
	ТекстЧасти = "
	|ВЫБРАТЬ
	|	" + мИмяТаблицыТипов + ".Имя КАК ИмяТипаСсылки,
	|	ТИПЗНАЧЕНИЯ(Т." + ПолеТаблицыБД.Имя + ") КАК ТипСсылки,
	|	""" + ТипТаблицы + """ КАК ТипТаблицы,
	|	""" + ПолноеИмяТаблицыБД + """ КАК ПолноеИмяТаблицы,
	|	""" + ПолеТаблицыБД.Имя + """ КАК ИмяКолонки,
	|	Т." + ПолеТаблицыБД.Имя + " КАК Ссылка,
	|	Количество(*) КАК КоличествоСсылающихся
	|ИЗ " + ПолноеИмяТаблицыБД + " КАК Т
	|ВНУТРЕННЕЕ СОЕДИНЕНИЕ " + мИмяТаблицыТипов + " КАК " + мИмяТаблицыТипов + " ПО ТИПЗНАЧЕНИЯ(Т." + ПолеТаблицыБД.Имя + ") = " + мИмяТаблицыТипов + ".Тип
	|ЛЕВОЕ СОЕДИНЕНИЕ " + мИмяТаблицыПустыхСсылок + " КАК " + мИмяТаблицыПустыхСсылок + " ПО Т." + ПолеТаблицыБД.Имя + " = " + мИмяТаблицыПустыхСсылок + ".ПустаяСсылка
	|ГДЕ ИСТИНА
	//|	И НЕ Т." + ПолеТаблицыБД.Имя + " В (&СписокПустыхСсылок) // Так меделеннее
	|	И " + мИмяТаблицыПустыхСсылок + ".ПустаяСсылка ЕСТЬ NULL
	|" + ВыражениеПоляСУсечениемТипов + "
	|СГРУППИРОВАТЬ ПО 
	|	" + мИмяТаблицыТипов + ".Имя,
	|	ТИПЗНАЧЕНИЯ(Т." + ПолеТаблицыБД.Имя + "),
	|	""" + ТипТаблицы + """,
	|	""" + ПолноеИмяТаблицыБД + """,
	|	""" + ПолеТаблицыБД.Имя + """,
	|	Т." + ПолеТаблицыБД.Имя + "
	|";
	Если ТекстЗапроса <> "" Тогда
		ТекстЧасти = "ОБЪЕДИНИТЬ ВСЕ
		|" + ТекстЧасти;
	КонецЕсли; 
	ТекстЗапроса = ТекстЗапроса + ТекстЧасти;
	Если СчетчикЧастейОбъединения >= МаксимальноеЧислоСоединенийВЗапросе Тогда
		ВыполнитьДобавитьНакопленныйЗапрос(Запрос, ПолучатьДанные, ТекстЗапроса, ТекстПакета, СчетчикЧастейОбъединения, СтруктураПотоков, ЭтаФорма, СчетчикЗапросовПакета);
	КонецЕсли; 

КонецПроцедуры

//ирПортативный лФайл = Новый Файл(ИспользуемоеИмяФайла);
//ирПортативный ПолноеИмяФайлаБазовогоМодуля = Лев(лФайл.Путь, СтрДлина(лФайл.Путь) - СтрДлина("Модули\")) + "ирПортативный.epf";
//ирПортативный #Если Клиент Тогда
//ирПортативный 	Контейнер = Новый Структура();
//ирПортативный 	Оповестить("ирПолучитьБазовуюФорму", Контейнер);
//ирПортативный 	Если Не Контейнер.Свойство("ирПортативный", ирПортативный) Тогда
//ирПортативный 		ирПортативный = ВнешниеОбработки.ПолучитьФорму(ПолноеИмяФайлаБазовогоМодуля);
//ирПортативный 		ирПортативный.Открыть();
//ирПортативный 	КонецЕсли; 
//ирПортативный #Иначе
//ирПортативный 	ирПортативный = ВнешниеОбработки.Создать(ПолноеИмяФайлаБазовогоМодуля, Ложь); // Это будет второй экземпляр объекта
//ирПортативный #КонецЕсли
//ирПортативный ирОбщий = ирПортативный.ПолучитьОбщийМодульЛкс("ирОбщий");
//ирПортативный ирКэш = ирПортативный.ПолучитьОбщийМодульЛкс("ирКэш");
//ирПортативный ирСервер = ирПортативный.ПолучитьОбщийМодульЛкс("ирСервер");
//ирПортативный ирПривилегированный = ирПортативный.ПолучитьОбщийМодульЛкс("ирПривилегированный");

мПлатформа = ирКэш.Получить();
ЭтотОбъект.КоличествоПотоков = 4;
ЭтотОбъект.КоличествоОбъектовВПорции = 5;
мИмяТаблицыТипов = "ТаблицаТиповСсылок";
мИмяТаблицыПустыхСсылок = "ТаблицаПустыхСсылок";
