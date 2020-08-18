﻿//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирПривилегированный Экспорт;

#Если Клиент Тогда
////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

Перем мЗапрос Экспорт;
Перем мРезультатыПоиска Экспорт;
Перем мМетаданныеОбъекта Экспорт;
Перем мКорневойТипОбъекта Экспорт;
Перем мПутьКДаннымПоляНечеткогоСравнения;
Перем мСтруктураКлючаПоиска;
Перем мСтруктураПредставлений Экспорт;
Перем мСтрокаРеквизитов;
Перем мСписокРеквизитов;

Перем мЗависимыеМетаданные;

Перем мПостроительЗапросаОтбора;
Перем мЗатронутыеЭлементыПВХ  Экспорт;
Перем МассивСтруктурУсекаемыхТипов Экспорт;


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// <Описание процедуры>
//
// Параметры:
//  <Параметр1>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>;
//  <Параметр2>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>.
//
Функция ВыполнитьАвтокорректировку() Экспорт

	Если ВыполнятьВТранзакции Тогда
		НачатьТранзакцию();
	КонецЕсли;
	Попытка
		ВыполнитьАнализ();
		ВыполнитьОчисткуРегистров();
		ВыполнитьКоррекциюПВХ(мЗатронутыеЭлементыПВХ);
	Исключение
		Если ВыполнятьВТранзакции Тогда
			ОтменитьТранзакцию();
		КонецЕсли;
		ВызватьИсключение;
	КонецПопытки; 
	Если ВыполнятьВТранзакции Тогда
		ЗафиксироватьТранзакцию();
	КонецЕсли;

	Возврат ВыполнитьАнализ();
	
КонецФункции // ВыполнитьАвтокорректировку()

// <Описание процедуры>
//
// Параметры:
//  <Параметр1>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>;
//  <Параметр2>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>.
//
Функция ВыполнитьАнализ() Экспорт

	ЗатрагиваемыеЭлементыТекущегоПланаВидовХарактеристик = Новый ТаблицаЗначений;
	МассивСтруктурУсекаемыхТипов = Новый Массив;
	МассивТиповКУдалению = Новый Массив;
	Для Каждого УдаляемыйТип Из УдаляемыеТипы.Типы() Цикл
		МетаданныеТипа = Метаданные.НайтиПоТипу(УдаляемыйТип);
		Если МетаданныеТипа = Неопределено Тогда
			ирОбщий.СообщитьЛкс("Примитивный тип """ + УдаляемыйТип + """ не будет учтен");
			МассивТиповКУдалению.Добавить(УдаляемыйТип);
			Продолжить;
		КонецЕсли;
		СтруктураУсекаемогоТипа = Новый Структура;
		СтруктураУсекаемогоТипа.Вставить("Тип", УдаляемыйТип);
		СтруктураУсекаемогоТипа.Вставить("ТипЗапроса", Метаданные.НайтиПоТипу(УдаляемыйТип).ПолноеИмя());
		МассивСтруктурУсекаемыхТипов.Добавить(СтруктураУсекаемогоТипа);
	КонецЦикла;
	УдаляемыеТипы = Новый ОписаниеТипов(УдаляемыеТипы, , МассивТиповКУдалению);
	
	// Регистры сведений
	НайтиПоРавенствуНовыхКлючейЗаписи();
	
	// Планы видов характеристик
	ЗаполнитьТаблицуПВХ();
	
	Результат = Истина
		И Не ПроблемныеПланыВидовХарактеристик.Количество() > 0
		И Не ПроблемныеРегистры.Количество() > 0;
	Возврат Результат;

КонецФункции // ВыполнитьАнализ()

// <Описание процедуры>
//
// Параметры:
//  <Параметр1>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>;
//  <Параметр2>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>.
//
Процедура ВыполнитьОчисткуГруппыРегистра(СтрокаРегистра, СтрокаГруппы) Экспорт

	Если ВыполнятьВТранзакции Тогда
		НачатьТранзакцию();
	КонецЕсли;
	МенеджерРегистра = РегистрыСведений[СтрокаРегистра.Имя];
	ТаблицаЗаписей = ПолучитьПроблемныеЗаписиГруппыРегистра(СтрокаРегистра, СтрокаГруппы);
	ПервуюСтрокуПропустили = Ложь;
	ПредставлениеГруппы = СтрокаГруппы.Владелец().Индекс(СтрокаГруппы);
	Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(СтрокаГруппы.КоличествоЭлементовВГруппе - 1, "Элементы группы " + ПредставлениеГруппы);
	Для Каждого СтрокаЗаписи Из ТаблицаЗаписей Цикл
		Если Не ПервуюСтрокуПропустили Тогда
			ПервуюСтрокуПропустили = Истина;
			Продолжить;
		КонецЕсли; 
		ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
		СтруктураНабораЗаписей = ирОбщий.ОбъектБДПоКлючуЛкс("РегистрСведений." + СтрокаРегистра.Имя, СтрокаЗаписи,, Ложь);
		ирОбщий.ЗаписатьОбъектЛкс(СтруктураНабораЗаписей.Методы);
	КонецЦикла; 
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	Если ВыполнятьВТранзакции Тогда
		ЗафиксироватьТранзакцию();
	КонецЕсли;

КонецПроцедуры

// <Описание функции>
//
// Параметры:
//  <Параметр1>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>;
//  <Параметр2>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>.
//
// Возвращаемое значение:
//               – <Тип.Вид> – <описание значения>
//                 <продолжение описания значения>;
//  <Значение2>  – <Тип.Вид> – <описание значения>
//                 <продолжение описания значения>.
//
Функция ПолучитьПроблемныеЗаписиГруппыРегистра(СтрокаРегистра, СтрокаГруппы) Экспорт 

	Запрос = Новый Запрос;
	Запрос.Текст = СтрокаРегистра.ЗапросВыборкиСоставаГруппы;
	МетаРегистр = Метаданные.РегистрыСведений[СтрокаРегистра.Имя];
	Для Каждого МетаИзмерение Из МетаРегистр.Измерения Цикл
		Запрос.УстановитьПараметр(МетаИзмерение.Имя, СтрокаГруппы[МетаИзмерение.Имя]);
	КонецЦикла;
	Если МетаРегистр.ПериодичностьРегистраСведений <> Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический Тогда
		Запрос.УстановитьПараметр("Период", СтрокаГруппы["Период"]);
	КонецЕсли;
	Если МетаРегистр.РежимЗаписи = Метаданные.СвойстваОбъектов.РежимЗаписиРегистра.ПодчинениеРегистратору Тогда
		Запрос.УстановитьПараметр("Регистратор", СтрокаГруппы["Регистратор"]);
	КонецЕсли;
	ТаблицаЗаписей = Запрос.Выполнить().Выгрузить();
	Возврат ТаблицаЗаписей;

КонецФункции // ПолучитьПроблемныеЗаписиГруппыРегистра()

// <Описание процедуры>
//
// Параметры:
//  <Параметр1>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>;
//  <Параметр2>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>.
//
Процедура ВыполнитьОчисткуРегистра(СтрокаРегистра) Экспорт    
	
	Если ВыполнятьВТранзакции Тогда
		НачатьТранзакцию();
	КонецЕсли;
	мЗапрос.Текст = "ВЫБРАТЬ * ИЗ " + СтрокаРегистра.Имя;
	ГруппыТекущегоРегистра = мЗапрос.Выполнить().Выгрузить();
	Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(ГруппыТекущегоРегистра.Количество(), "Коррекция регистра " + СтрокаРегистра.Имя);
	Для Каждого СтрокаГруппы Из ГруппыТекущегоРегистра Цикл
		ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
		ВыполнитьОчисткуГруппыРегистра(СтрокаРегистра, СтрокаГруппы);
	КонецЦикла;
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	Если ВыполнятьВТранзакции Тогда
		ЗафиксироватьТранзакцию();
	КонецЕсли;

КонецПроцедуры // ВыполнитьОчисткуГруппРегистра()

// <Описание процедуры>
//
// Параметры:
//  <Параметр1>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>;
//  <Параметр2>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>.
//
Процедура ВыполнитьОчисткуРегистров() Экспорт

	Если ВыполнятьВТранзакции Тогда
		НачатьТранзакцию();
	КонецЕсли;
	Для Каждого СтрокаРегистра Из ПроблемныеРегистры Цикл
		ВыполнитьОчисткуРегистра(СтрокаРегистра);
	КонецЦикла;
	Если ВыполнятьВТранзакции Тогда
		ЗафиксироватьТранзакцию();
	КонецЕсли;

КонецПроцедуры // ВыполнитьОчисткуРегистров()

Процедура НайтиПоРавенствуНовыхКлючейЗаписи() Экспорт
	
	ПроблемныеРегистры.Очистить();
	ЭлементыТекущейГруппы.Очистить();
	ГруппыТекущегоРегистра.Очистить();
	ГруппыТекущегоРегистра.Колонки.Очистить();
	мТекущаяГруппа = Неопределено;
	
	мСтруктураПредставлений = Новый Структура;
	мСтруктураПредставлений.Вставить("КоличествоЭлементовВГруппе", "Количество элементов");
	мСтруктураПредставлений.Вставить("НомерГруппы", "Номер группы");
	мСтруктураПредставлений.Вставить("ВывестиСостав", "Вывести состав");
	мСтруктураПредставлений.Вставить("Период", "Период");
	мСтруктураПредставлений.Вставить("Регистратор", "Регистратор");
	мСтруктураПредставлений.Вставить("ОткрытьЗапись", "Открыть запись");
	мСтруктураПредставлений.Вставить("НомерСтроки", "Номер строки");
	мСтруктураПредставлений.Вставить("Активность", "Активность");
	
	Для Каждого ПолноеИмяИзмерения Из УдаляемыеИзмерения Цикл
		Если ирКэш.ОбъектМДПоПолномуИмениЛкс(ПолноеИмяИзмерения) = Неопределено Тогда
			ирОбщий.СообщитьЛкс("В текущей конфигурации не найдено удаляемое измерение """ + ПолноеИмяИзмерения + """", СтатусСообщения.Внимание);
		КонецЕсли; 
	КонецЦикла;
	
	мЗапрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(Метаданные.РегистрыСведений.Количество(), "Регистры сведений");
	Для Каждого МетаРегистр Из Метаданные.РегистрыСведений Цикл
		ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
		ТекстВЫБРАТЬ = "";
		ТекстСГРУППИРОВАТЬ = "";
		ТекстГДЕ2 = "";
		ВозможныПроблемы = Ложь;
		Для Каждого МетаИзмерение Из МетаРегистр.Измерения Цикл
			ИмяПоля = МетаИзмерение.Имя;
			ТекстПоля = "ВЫБОР КОГДА ЛОЖЬ";
			ПолноеИмяИзмерения = МетаИзмерение.ПолноеИмя();
			Если УдаляемыеИзмерения.НайтиПоЗначению(ПолноеИмяИзмерения) <> Неопределено Тогда
				ТекстПоля = ТекстПоля + Символы.ПС + "ИЛИ ИСТИНА";
				ВозможныПроблемы = Истина;
			Иначе
				Для Каждого СтруктураУсекаемогоТипа Из МассивСтруктурУсекаемыхТипов Цикл
					Если МетаИзмерение.Тип.СодержитТип(СтруктураУсекаемогоТипа.Тип) Тогда
						ТекстПоля = ТекстПоля + Символы.ПС + "ИЛИ (" + ИмяПоля + " ССЫЛКА " + СтруктураУсекаемогоТипа.ТипЗапроса + ")";
						ВозможныПроблемы = Истина;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли; 
			ТекстПоля = ТекстПоля + Символы.ПС + "ТОГДА НЕОПРЕДЕЛЕНО";
			ТекстПоля = ТекстПоля + Символы.ПС + "ИНАЧЕ " + ИмяПоля + Символы.ПС + " КОНЕЦ";
			ТекстВЫБРАТЬ = ТекстВЫБРАТЬ + ", " + ТекстПоля + " КАК " + ИмяПоля; // запрещенные имена например "Соединение" так вызывают ошибку?
			ТекстГДЕ2 = ТекстГДЕ2 + " И " + ТекстПоля + " = &" + ИмяПоля;
			ТекстСГРУППИРОВАТЬ = ТекстСГРУППИРОВАТЬ + ", " + ТекстПоля;
		КонецЦикла;
		
		Если МетаРегистр.ПериодичностьРегистраСведений <> Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический Тогда
			ИмяПоля = "Период";
			ТекстПоля = "ВЫБОР КОГДА ЛОЖЬ";
			ПолноеИмяИзмерения = МетаРегистр.ПолноеИмя() + "." + ИмяПоля;
			Если УдаляемыеИзмерения.НайтиПоЗначению(ПолноеИмяИзмерения) <> Неопределено Тогда
				ТекстПоля = ТекстПоля + Символы.ПС + "ИЛИ ИСТИНА";
				ВозможныПроблемы = Истина;
			КонецЕсли; 
			ТекстПоля = ТекстПоля + Символы.ПС + "ТОГДА НЕОПРЕДЕЛЕНО";
			ТекстПоля = ТекстПоля + Символы.ПС + "ИНАЧЕ " + ИмяПоля + Символы.ПС + " КОНЕЦ";
			ТекстВЫБРАТЬ = ТекстВЫБРАТЬ + ", " + ТекстПоля + " КАК " + ИмяПоля;
			ТекстГДЕ2 = ТекстГДЕ2 + " И " + ТекстПоля + " = &" + ИмяПоля;
			ТекстСГРУППИРОВАТЬ = ТекстСГРУППИРОВАТЬ + ", " + ТекстПоля;
		КонецЕсли;
		
		Если МетаРегистр.РежимЗаписи = Метаданные.СвойстваОбъектов.РежимЗаписиРегистра.ПодчинениеРегистратору Тогда
			ИмяПоля = "Регистратор";
			ТекстПоля = ИмяПоля;
			ТекстВЫБРАТЬ = ТекстВЫБРАТЬ + ", " + ТекстПоля + " КАК " + ИмяПоля;
			ТекстГДЕ2 = ТекстГДЕ2 + " И " + ТекстПоля + " = &" + ИмяПоля;
			ТекстСГРУППИРОВАТЬ = ТекстСГРУППИРОВАТЬ + ", " + ТекстПоля;
		КонецЕсли;
		
		Если Не ВозможныПроблемы Тогда
			Продолжить;
		КонецЕсли;
		
		ТекстСГРУППИРОВАТЬ = Сред(ТекстСГРУППИРОВАТЬ, 2);
		ТекстЗапросаПоиска = "
		|ВЫБРАТЬ
		|	КОЛИЧЕСТВО(*) КАК КоличествоЭлементовВГруппе" + ТекстВЫБРАТЬ + "
		|ПОМЕСТИТЬ " + МетаРегистр.Имя + "
		|ИЗ " + МетаРегистр.ПолноеИмя() + " КАК Регистр
		|СГРУППИРОВАТЬ ПО " + ТекстСГРУППИРОВАТЬ + " 
		|ИМЕЮЩИЕ КОЛИЧЕСТВО(*) > 1
		|";
		
		мЗапрос.Текст = ТекстЗапросаПоиска;
		мЗапрос.Выполнить();
		
		мЗапрос.Текст = "ВЫБРАТЬ КОЛИЧЕСТВО(*) КАК КоличествоГрупп ИЗ " + МетаРегистр.Имя;
		КоличествоГрупп = мЗапрос.Выполнить().Выгрузить()[0].КоличествоГрупп;
		
		Если КоличествоГрупп = 0 Тогда
			Продолжить;
		КонецЕсли;
			
		СтрокаРегистра = ПроблемныеРегистры.Добавить();
		СтрокаРегистра.ЗапросВыборкиСоставаГруппы = "
		|ВЫБРАТЬ *
		|ИЗ " + МетаРегистр.ПолноеИмя() + " КАК Регистр
		|ГДЕ ИСТИНА " + ТекстГДЕ2 + "
		|";
		СтрокаРегистра.Имя = МетаРегистр.Имя;
		СтрокаРегистра.КоличествоГрупп = КоличествоГрупп;
		
	КонецЦикла;
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс();

КонецПроцедуры // НайтиПоРавенствуНовыхКлючейЗаписи()

// <Описание процедуры>
//
// Параметры:
//  <Параметр1>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>;
//  <Параметр2>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>.
//
Процедура ЗаполнитьТаблицуПВХ()

	мЗатронутыеЭлементыПВХ = Новый ТаблицаЗначений;
	мЗатронутыеЭлементыПВХ.Колонки.Добавить("Имя", Новый ОписаниеТипов("Строка"));
	мЗатронутыеЭлементыПВХ.Колонки.Добавить("Ссылка");
	
	Для Каждого МетаПВХ Из Метаданные.ПланыВидовХарактеристик Цикл
		Выборка = ирОбщий.ПолучитьМенеджерЛкс(МетаПВХ).Выбрать();
		Пока Выборка.Следующий() Цикл
			Затрагивается = Ложь;
			Для Каждого СтруктураУсекаемогоТипа Из МассивСтруктурУсекаемыхТипов Цикл
				Если Выборка.ТипЗначения.СодержитТип(СтруктураУсекаемогоТипа.Тип) Тогда
					Затрагивается = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Если Затрагивается Тогда
				СтрокаЭлементаПВХ = мЗатронутыеЭлементыПВХ.Добавить();
				СтрокаЭлементаПВХ.Имя = МетаПВХ.Имя;
				СтрокаЭлементаПВХ.Ссылка = Выборка.Ссылка;
			КонецЕсли;
		КонецЦикла; 
	КонецЦикла;
	
	ИтогоПВХ = мЗатронутыеЭлементыПВХ.Скопировать();
	ИтогоПВХ.Колонки.Добавить("КоличествоЗатрагиваемыхЭлементов");
	ИтогоПВХ.ЗаполнитьЗначения(1, "КоличествоЗатрагиваемыхЭлементов");
	ИтогоПВХ.Свернуть("Имя", "КоличествоЗатрагиваемыхЭлементов");
	ПроблемныеПланыВидовХарактеристик.Загрузить(ИтогоПВХ);

КонецПроцедуры

Процедура ВыполнитьКоррекциюПВХ(ТаблицаСсылокПВХ) Экспорт 

	Если ТаблицаСсылокПВХ = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	Если ВыполнятьВТранзакции Тогда
		НачатьТранзакцию();
	КонецЕсли;
	ИндикаторПроцесса = ирОбщий.ПолучитьИндикаторПроцессаЛкс(ТаблицаСсылокПВХ.Количество(), "Коррекция элементов ПВХ");
	Для Каждого СтрокаЭлемента Из ТаблицаСсылокПВХ Цикл
		#Если Клиент Тогда
			ирОбщий.ОбработатьИндикаторЛкс(ИндикаторПроцесса);
		#КонецЕсли
		Ссылка = СтрокаЭлемента.Ссылка;
		ОбъектПВХ = ирОбщий.ОбъектБДПоКлючуЛкс(Ссылка.Метаданные().ПолноеИмя(), Ссылка);
		ИсходныйТипЗначения = Новый ОписаниеТипов(ОбъектПВХ.Данные.ТипЗначения);
		ДобавляемыеТипы = Новый Массив;
		//
		НовыйТипЗначения = Новый ОписаниеТипов(ИсходныйТипЗначения, ДобавляемыеТипы, УдаляемыеТипы.Типы());
		Если НовыйТипЗначения.Типы().Количество() = 0 Тогда
			ирОбщий.СообщитьЛкс("Автоматическая модификация типа значения элемента """ + Ссылка + """ невозможна, т.к. он становится пустым",
				СтатусСообщения.Важное);
			Продолжить;
		КонецЕсли;
		ОбъектПВХ.Данные.ТипЗначения = НовыйТипЗначения;
		Попытка
			ирОбщий.ЗаписатьОбъектЛкс(ОбъектПВХ.Методы);
			ирОбщий.СообщитьЛкс("Модифицирован тип значения элемента """ + Ссылка + """", СтатусСообщения.Информация);
			ирОбщий.СообщитьЛкс(Символы.Таб + "Старый: " + ИсходныйТипЗначения);
			ирОбщий.СообщитьЛкс(Символы.Таб + " Новый: " + ОбъектПВХ.Данные.ТипЗначения);
		Исключение
			ирОбщий.СообщитьЛкс("Ошибка при коррекции """ + Ссылка + """: " + ОписаниеОшибки(), СтатусСообщения.Важное);
		КонецПопытки;
	КонецЦикла; 
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	Если ВыполнятьВТранзакции Тогда
		ЗафиксироватьТранзакцию();
	КонецЕсли;

КонецПроцедуры

// <Описание функции>
//
// Параметры:
//  <Параметр1>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>;
//  <Параметр2>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>.
//
// Возвращаемое значение:
//               – <Тип.Вид> – <описание значения>
//                 <продолжение описания значения>;
//  <Значение2>  – <Тип.Вид> – <описание значения>
//                 <продолжение описания значения>.
//
Процедура ЗаполнитьПоРазницеМеждуКонфигурациями(ПолноеИмяФайла = "") Экспорт

	Если ирКэш.НомерВерсииПлатформыЛкс() >= 803008 Тогда
		ЗаполнитьПоРазницеМеждуКонфигурациямиЧерезОтчетСравнения();
		Возврат;
	КонецЕсли; 
	Если Не ЗначениеЗаполнено(ПолноеИмяФайла) Тогда
		ВременныйФайл = Новый ФАйл(ПолучитьИмяВременногоФайла("CF"));
		ПолноеИмяФайла = ВременныйФайл.ПолноеИмя;
		Состояние("Выгружаем основную конфигурацию");
		ЗапуститьСистему("DESIGNER /DumpCfg """ + ПолноеИмяФайла + """", Истина);
		//ВременныйФайл = Новый Файл("Z:\Система2ис.cf"); // для отладки
		Если Не ВременныйФайл.Существует() Тогда
			ирОбщий.СообщитьЛкс("Не удалось выгрузить файл конфигурации. Возможно был занят конфигуратор.", СтатусСообщения.Внимание);
			Возврат;
		КонецЕсли; 
	КонецЕсли; 
	ФайлКонфигурации = Новый Файл(ПолноеИмяФайла);
	ВременныйКаталог = ПолучитьИмяВременногоФайла();
	СтрокаСоединенияВременнойБазы = "File=""" + ВременныйКаталог + """;";
	
	мПлатформа = ирКэш.Получить();
	Состояние("Создаем временную базу");
	// Антибаг платформы 8.2.14 http://partners.v8.1c.ru/forum/thread.jsp?id=952390#952390
	//ЗапуститьСистему("CREATEINFOBASE " + СтрокаСоединенияВременнойБазы + " /UseTemplate " + ФайлКонфигурации.ПолноеИмя, Истина); 
	СтрокаКоманды = """" + КаталогПрограммы() + "1cv8.exe"" " + "CREATEINFOBASE File=""" + ВременныйКаталог + """;";
	
	// Антибаг платформы http://partners.v8.1c.ru/forum/thread.jsp?id=1076785#1076785
	Если ирКэш.НомерВерсииПлатформыЛкс() < 802018 Тогда
		СтрокаКоманды = СтрокаКоманды + "/";
	КонецЕсли; 
	ИмяФайлаЛога = ПолучитьИмяВременногоФайла("txt");
	СтрокаКоманды = СтрокаКоманды + " /UseTemplate """ + ФайлКонфигурации.ПолноеИмя + """ /Out""" + ИмяФайлаЛога + """";
	//мПлатформа.ЗапуститьСкрытоеПриложениеИДождатьсяЗавершения(СтрокаКоманды);
	РезультатКоманды = мПлатформа.ПолучитьТекстРезультатаКомандыСистемы(СтрокаКоманды);
	Попытка
	    КомСоединитель = Новый COMОбъект("v" + ирКэш.НомерИзданияПлатформыЛкс() + ".ComConnector");
		КомСоединение = КомСоединитель.Connect(СтрокаСоединенияВременнойБазы);
		Если КомСоединение.КонфигурацияИзменена() Тогда
			ТекстовыйДокумент = Новый ТекстовыйДокумент;
			ТекстовыйДокумент.Прочитать(ИмяФайлаЛога);
			ирОбщий.СообщитьЛкс(ТекстовыйДокумент.ПолучитьТекст());
		Иначе
			МассивУдаленныхТипов = Новый Массив();
			НовыеМетаданные = КомСоединение.Метаданные;
			СсылочныеТипыМетаданных = ирКэш.КорневыеТипыСсылочныеЛкс();
			Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(СсылочныеТипыМетаданных.Количество());
			Для Каждого СтрокаКорневогоТипа Из СсылочныеТипыМетаданных Цикл
				ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
				ИмяКоллекции = СтрокаКорневогоТипа.Множественное;
				ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
				КоллекцияТекущая = Метаданные[ИмяКоллекции];
				КоллекцияНовая = НовыеМетаданные[ИмяКоллекции];
				Для Каждого МетаобъектТекущий Из КоллекцияТекущая Цикл
					ИмяТипаМенеджера = СтрЗаменить(МетаобъектТекущий.ПолноеИмя(), ".", "Менеджер.");
					МенеджерОбъекта = Новый(ИмяТипаМенеджера);
					ИдентификаторМенеджера = ЗначениеВСтрокуВнутр(МенеджерОбъекта);
					НовыйМенеджер = КомСоединение.ЗначениеИзСтрокиВнутр(ИдентификаторМенеджера);
					Если НовыйМенеджер <> Неопределено Тогда
						МетаобъектНовый = НовыйМенеджер.ПустаяСсылка().Метаданные();
					КонецЕсли; 
					Если МетаобъектНовый = Неопределено Тогда
						МетаобъектНовый = КоллекцияНовая.Найти(МетаобъектТекущий.Имя);
					КонецЕсли; 
					Если МетаобъектНовый = Неопределено Тогда 
						МассивУдаленныхТипов.Добавить(Тип(ирОбщий.ИмяТипаИзПолногоИмениТаблицыБДЛкс(МетаобъектТекущий.ПолноеИмя())));
					КонецЕсли; 
				КонецЦикла; 
			КонецЦикла;
			ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
			КоллекцияТекущая = Метаданные.РегистрыСведений;
			КоллекцияНовая = НовыеМетаданные.РегистрыСведений;
			Для Каждого МетаобъектТекущий Из КоллекцияТекущая Цикл
				ИмяТипаМенеджера = СтрЗаменить(МетаобъектТекущий.ПолноеИмя(), ".", "Менеджер.");
				МенеджерОбъекта = Новый(ИмяТипаМенеджера);
				ИдентификаторМенеджера = ЗначениеВСтрокуВнутр(МенеджерОбъекта);
				НовыйМенеджер = КомСоединение.ЗначениеИзСтрокиВнутр(ИдентификаторМенеджера);
				Если НовыйМенеджер <> Неопределено Тогда
					МетаобъектНовый = НовыйМенеджер.СоздатьНаборЗаписей().Метаданные();
				КонецЕсли; 
				Если МетаобъектНовый = Неопределено Тогда
					// Если не нашли по внутреннему идентификатору, ищем по имени объекта МД
					МетаобъектНовый = КоллекцияНовая.Найти(МетаобъектТекущий.Имя);
				КонецЕсли; 
				Если МетаобъектНовый = Неопределено Тогда
					ирОбщий.СообщитьЛкс("Для регистра сведений """ + МетаобъектТекущий.Имя + """ не найдено соответствия в новой конфигурации");
					Продолжить;
				КонецЕсли; 
				Для Каждого ИзмерениеТекущее Из МетаобъектТекущий.Измерения Цикл
					Если МетаобъектНовый.Измерения.Найти(ИзмерениеТекущее.Имя) = Неопределено Тогда 
						УдаляемыеИзмерения.Добавить(ИзмерениеТекущее.ПолноеИмя());
					КонецЕсли; 
				КонецЦикла;
				Если Истина
					И МетаобъектТекущий.ПериодичностьРегистраСведений <> Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический 
					И МетаобъектНовый.ПериодичностьРегистраСведений = КомСоединение.Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический 
				Тогда
					УдаляемыеИзмерения.Добавить(МетаобъектТекущий.ПолноеИмя() + ".Период");
				КонецЕсли; 
			КонецЦикла; 
			ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
		КонецЕсли;
		ирОбщий.СообщитьЛкс("Сравнение объектов выполнено частично по именам объектов вместо идентификаторов. Проверьте результат заполнения! Полностью корректное сравнение доступно на 8.3.8+");
	Исключение
		НовыеМетаданные = Неопределено;
		КоллекцияНовая = Неопределено;
		МетаобъектНовый = Неопределено;
		НовыйМенеджер = Неопределено;
		КомСоединитель = Неопределено;
		КомСоединение = Неопределено;
		Если ВременныйФайл <> Неопределено Тогда
			УдалитьФайлы(ВременныйФайл.ПолноеИмя);
		КонецЕсли; 
		УдалитьФайлы(ВременныйКаталог);
		ВызватьИсключение;
	КонецПопытки; 
	НовыеМетаданные = Неопределено;
	КоллекцияНовая = Неопределено;
	МетаобъектНовый = Неопределено;
	НовыйМенеджер = Неопределено;
	КомСоединитель = Неопределено;
	КомСоединение = Неопределено;
	Если ВременныйФайл <> Неопределено Тогда
		УдалитьФайлы(ВременныйФайл.ПолноеИмя);
	КонецЕсли; 
	УдалитьФайлы(ВременныйКаталог);
	УдаляемыеТипы = Новый ОписаниеТипов(МассивУдаленныхТипов);

КонецПроцедуры // ЗаполнитьПоРазницеМеждуКонфигурациями()

// 8.3.8+
Процедура ЗаполнитьПоРазницеМеждуКонфигурациямиЧерезОтчетСравнения(ПолноеИмяФайла = "") Экспорт

	КомандаСистемы = "DESIGNER /DisableStartupMessages /DisableStartupDialogs /CompareCfg -FirstConfigurationType DBConfiguration -SecondConfigurationType ";
	Если ЗначениеЗаполнено(ПолноеИмяФайла) Тогда
		КомандаСистемы = КомандаСистемы + "File -SecondConfigurationKey """ + ПолноеИмяФайла + """";
	Иначе
		КомандаСистемы = КомандаСистемы + "MainConfiguration";
	КонецЕсли; 
	ФайлОтчета = Новый ФАйл(ПолучитьИмяВременногоФайла("mxl"));
	ФайлЛога = Новый ФАйл(ПолучитьИмяВременногоФайла("Txt"));
	КомандаСистемы = КомандаСистемы + " -IncludeChangedObjects -IncludeDeletedObjects -MappingRule ";
	//Если 1=1 Тогда
		КомандаСистемы = КомандаСистемы + "ByObjectIDs";
	//Иначе
	//	КомандаСистемы = КомандаСистемы + "ByObjectNames";
	//КонецЕсли;
	КомандаСистемы = КомандаСистемы + " -ReportType Brief -ReportFormat mxl -ReportFile """ + ФайлОтчета.ПолноеИмя + """ /Out """ + ФайлЛога.ПолноеИмя + """"; 
	ЗапуститьСистему(КомандаСистемы, Истина);
	Если Не ФайлОтчета.Существует() Тогда
		ТекстовыйДокумент = Новый ТекстовыйДокумент;
		ТекстовыйДокумент.Прочитать(ФайлЛога.ПолноеИмя);
		ирОбщий.СообщитьЛкс(ТекстовыйДокумент.ПолучитьТекст());
		ирОбщий.СообщитьЛкс("Не удалось сравнить конфигурации конфигуратором базы");
		Возврат;
	КонецЕсли;
	РезультатСравнения = Новый ТабличныйДокумент;
	РезультатСравнения.Прочитать(ФайлОтчета.ПолноеИмя);
	ЦветУдаления = Новый Цвет(255, 228, 196);
	
	// Ищем удаленные измерения
	Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс();
	НайденнаяЯчейка = Неопределено;
	ОбластьПоиска = РезультатСравнения.Область("C5");
	Пока Истина Цикл
		ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
		НайденнаяЯчейка = РезультатСравнения.НайтиТекст(".Измерение.", НайденнаяЯчейка, ОбластьПоиска);
		Если НайденнаяЯчейка = Неопределено Тогда
			Прервать;
		КонецЕсли;
		Если НайденнаяЯчейка.ЦветФона = ЦветУдаления Тогда
			УдаляемыеИзмерения.Добавить(НайденнаяЯчейка.Текст);
		КонецЕсли;
	КонецЦикла;
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс();

	// Ищем удаленные ссылочные типы
	МассивУдаленныхТипов = Новый Массив();
	СсылочныеТипыМетаданных = ирКэш.КорневыеТипыСсылочныеЛкс();
	Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(СсылочныеТипыМетаданных.Количество());
	Для Каждого СтрокаКорневогоТипа Из СсылочныеТипыМетаданных Цикл
		ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
		ИмяКорневогоТипа = СтрокаКорневогоТипа.Единственное;
		Индикатор2 = ирОбщий.ПолучитьИндикаторПроцессаЛкс();
		НайденнаяЯчейка = Неопределено;
		ОбластьПоиска = РезультатСравнения.Область("C4");
		Пока Истина Цикл
			ирОбщий.ОбработатьИндикаторЛкс(Индикатор2);
			НайденнаяЯчейка = РезультатСравнения.НайтиТекст(ИмяКорневогоТипа + ".", НайденнаяЯчейка, ОбластьПоиска);
			Если НайденнаяЯчейка = Неопределено Тогда
				Прервать;
			КонецЕсли;
			Если НайденнаяЯчейка.ЦветФона = ЦветУдаления Тогда
				МассивУдаленныхТипов.Добавить(Тип(ирОбщий.ИмяТипаИзПолногоИмениТаблицыБДЛкс(НайденнаяЯчейка.Текст)));
			КонецЕсли;
		КонецЦикла;
		ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	КонецЦикла;
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	УдаляемыеТипы = Новый ОписаниеТипов(МассивУдаленныхТипов);

КонецПроцедуры // ЗаполнитьПоРазницеМеждуКонфигурациями()

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

мЗапрос = Новый Запрос;
#КонецЕсли 
