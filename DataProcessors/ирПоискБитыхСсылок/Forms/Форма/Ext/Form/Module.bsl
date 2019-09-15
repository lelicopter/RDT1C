﻿////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Перем мВыборкаРезультатаСтрокиТаблицы;

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПриОткрытии()

	ОбновитьДоступность();
	
КонецПроцедуры // ПриОткрытии()

Процедура ПослеВосстановленияЗначений()

	ОбновитьДоступность();
	ИмяПредставлениеПриИзменении();

КонецПроцедуры // ПослеВосстановленияЗначений()

Процедура БитыеСсылкиВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ирОбщий.ЯчейкаТабличногоПоляРасширенногоЗначения_ВыборЛкс(Элемент, СтандартнаяОбработка);

КонецПроцедуры // НайденныеОбъектыВыбор()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ УПРАВЛЕНИЯ

Процедура ПредставлениеОбластиПоискаНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	Форма = ирКэш.Получить().ПолучитьФорму("ВыборОбъектаМетаданных", Элемент, ЭтаФорма);

	лСтруктураПараметров = Новый Структура;
	лНачальноеЗначениеВыбора = ТипыСсылокДляПоиска.ВыгрузитьЗначения();
	лСтруктураПараметров.Вставить("НачальноеЗначениеВыбора", лНачальноеЗначениеВыбора);
	лСтруктураПараметров.Вставить("ОтображатьСсылочныеОбъекты", Истина);
	//лСтруктураПараметров.Вставить("ОтображатьВнешниеИсточникиДанных", Истина);
	лСтруктураПараметров.Вставить("МножественныйВыбор", Истина);
	лСтруктураПараметров.Вставить("МножественныйВыборТолькоДляОднотипныхТаблиц", Ложь);
	Форма.НачальноеЗначениеВыбора = лСтруктураПараметров;
	Форма.ОткрытьМодально();
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

Процедура ГлавнаяКоманднаяПанельОПодсистеме(Кнопка)
	ирОбщий.ОткрытьСправкуПоПодсистемеЛкс(ЭтотОбъект);
КонецПроцедуры

Процедура ГлавнаяКоманднаяПанельНовоеОкно(Кнопка)
	
	ирОбщий.ОткрытьНовоеОкноОбработкиЛкс(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбновлениеОтображения()

	ЭтаФорма.СтрокаКоличествоСтрок = БитыеСсылки.Количество();
	
КонецПроцедуры

Процедура ПредставлениеОбластиПоискаПриИзменении(Элемент)

	ОбновитьДоступность();
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
	
КонецПроцедуры

Процедура ПредставлениеОбластиПоискаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, ЭтаФорма);

КонецПроцедуры

Процедура ПредставлениеОбластиПоискаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Массив") Тогда
		СтандартнаяОбработка = Ложь;
		ТипыСсылокДляПоиска = Новый СписокЗначений;
		ТипыСсылокДляПоиска.ЗагрузитьЗначения(ВыбранноеЗначение);
		ПредставлениеОбластиПоискаПриИзменении(Элемент);
	ИначеЕсли ТипЗнч(ВыбранноеЗначение) = Тип("СписокЗначений") Тогда
		СтандартнаяОбработка = Ложь;
		ТипыСсылокДляПоиска = Новый СписокЗначений;
		ТипыСсылокДляПоиска.ЗагрузитьЗначения(ВыбранноеЗначение.ВыгрузитьЗначения());
		ПредставлениеОбластиПоискаПриИзменении(Элемент);
	КонецЕсли;
		
КонецПроцедуры

Процедура МноготабличнаяВыборкаПриИзменении(Элемент)

	Если Истина
		//И МноготабличнаяВыборка 
		И ТипЗнч(ТипыСсылокДляПоиска) <> Тип("СписокЗначений")
	Тогда
		лОбластьПоиска = Новый СписокЗначений;
		Если ЗначениеЗаполнено(ТипыСсылокДляПоиска) Тогда
			лОбластьПоиска.Добавить(ТипыСсылокДляПоиска);
		КонецЕсли; 
	ИначеЕсли Истина
		//И Не МноготабличнаяВыборка 
		И ТипЗнч(ТипыСсылокДляПоиска) = Тип("СписокЗначений")
	Тогда
		Если ТипыСсылокДляПоиска.Количество() > 0 Тогда
			лОбластьПоиска = ТипыСсылокДляПоиска[0].Значение;
		Иначе
			лОбластьПоиска = "";
		КонецЕсли; 
	КонецЕсли; 
	ОбновитьДоступность();
	
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура КоманднаяПанельБитыеСсылкиОчистить(Кнопка)
	
	БитыеСсылки.Очистить();
	
КонецПроцедуры

Процедура УзелОтбораОбъектовНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, ЭтаФорма);
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ирОбщий.ФормаОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура КоманднаяПанельБитыеСсылкиИсполняемыйЗапрос(Кнопка)
	
	Запрос = ПолучитьЗапросВыборки(Ложь);
	ирОбщий.ОтладитьЛкс(Запрос);
	
КонецПроцедуры

Процедура КоманднаяПанельНайденныеОбъектыКонсольОбработки(Кнопка)
	
	ирОбщий.ОткрытьОбъектыИзВыделенныхЯчеекВПодбореИОбработкеОбъектовЛкс(ЭтаФорма.ЭлементыФормы.БитыеСсылки);
	
КонецПроцедуры

Процедура КоманднаяПанельБитыеСсылкиВыполнитьПоиск(Кнопка)
	
	СтрокиТаблицыБД.Очистить();
	ЭлементыФормы.СтрокиТаблицыБД.ОбновитьСтроки();
	Если Истина
		И Не ЛиВсеТипы
		И ТипыСсылокДляПоиска.Количество() = 0 
	Тогда
		Возврат;
	КонецЕсли;
	НачалаПоиска = ТекущаяДата();
	ПолучитьЗапросВыборки();
	Сообщить("Поиск выполнен за " + XMLСтрока(ТекущаяДата() - НачалаПоиска) + " сек");
	ИтогиБитыхСсылок = СвязанныеДанные.Выгрузить();
	ИтогиБитыхСсылок.Свернуть("ИмяТипаСсылки, Ссылка", "КоличествоСсылающихся");
	БитыеСсылкиТЗ = БитыеСсылки.ВыгрузитьКолонки();
	БитыеСсылкиТЗ.Индексы.Добавить("Ссылка");
	ирОбщий.ЗагрузитьВТаблицуЗначенийЛкс(ИтогиБитыхСсылок, БитыеСсылкиТЗ);
	//БитыеСсылки.Сортировать("ИмяТипаСсылки, Ссылка"); // Заметно дольше и пользы мало
	БитыеСсылкиТЗ.Сортировать("ИмяТипаСсылки");
	Для Каждого БитаяСсылка Из БитыеСсылкиТЗ Цикл
		БитаяСсылка.ПредставлениеТипаСсылки = "" + Тип(ирОбщий.ИмяТипаИзПолногоИмениТаблицыБДЛкс(БитаяСсылка.ИмяТипаСсылки));
	КонецЦикла;
	ИтогиТипов = БитыеСсылкиТЗ.Скопировать();
	ИтогиТипов.Колонки.Добавить("КоличествоБитыхСсылок");
	ИтогиТипов.ЗаполнитьЗначения(1, "КоличествоБитыхСсылок");
	ИтогиТипов.Свернуть("ИмяТипаСсылки, ПредставлениеТипаСсылки", "КоличествоБитыхСсылок, КоличествоСсылающихся");
	ИтогиТипов.Сортировать("ПредставлениеТипаСсылки");
	ТипыНайденныхБитыхСсылок.Очистить();
	Для Каждого СтрокаИтогаИсточник Из ИтогиТипов Цикл
		СтрокаИтогаПриемник = ТипыНайденныхБитыхСсылок.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаИтогаПриемник, СтрокаИтогаИсточник); 
	КонецЦикла;
	ИтогиТипов.Свернуть(, "КоличествоБитыхСсылок, КоличествоСсылающихся");
	СтрокаВсехТипов = ТипыНайденныхБитыхСсылок.Вставить(0);
	СтрокаВсехТипов.ИмяТипаСсылки = "<Все>";
	СтрокаВсехТипов.ПредставлениеТипаСсылки = "<Все>";
	Если ИтогиТипов.Количество() > 0 Тогда
		ЗаполнитьЗначенияСвойств(СтрокаВсехТипов, ИтогиТипов[0]); 
	КонецЕсли; 
	ТаблицаВсехТаблиц = ирКэш.ТаблицаВсехТаблицБДЛкс();
	Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(СвязанныеДанные.Количество(), "Обработка результатов");
	Для Каждого СтрокаСвязанныхДанных Из СвязанныеДанные Цикл
		ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
		ПолноеИмяТаблицы = СтрокаСвязанныхДанных.ПолноеИмяТаблицы;
		ПоляТаблицыБД = ирКэш.ПоляТаблицыБДЛкс(ПолноеИмяТаблицы);
		Если ПоляТаблицыБД = Неопределено Тогда
			Продолжить;
		КонецЕсли; 
		#Если Сервер И Не Сервер Тогда
			ПоляТаблицыБД = НайтиПоСсылкам().Колонки;
		#КонецЕсли
		ОписаниеТаблицы = ТаблицаВсехТаблиц.Найти(НРег(ПолноеИмяТаблицы), "НПолноеИмя");
		СтрокаСвязанныхДанных.ИмяТаблицы = ОписаниеТаблицы.Имя;
		СтрокаСвязанныхДанных.ПредставлениеТаблицы = ОписаниеТаблицы.Представление;
		ПолеТаблицыБД = ПоляТаблицыБД.Найти(СтрокаСвязанныхДанных.ИмяКолонки, "Имя");
		СтрокаСвязанныхДанных.ПредставлениеКолонки = ПолеТаблицыБД.Заголовок;
		СтрокаСвязанныхДанных.КоличествоТипов = ПолеТаблицыБД.ТипЗначения.Типы().Количество();
		СтрокаБитойСсылки = БитыеСсылкиТЗ.Найти(СтрокаСвязанныхДанных.Ссылка, "Ссылка");
		Если Найти(Нрег(СтрокаБитойСсылки.ИменаСсылающихсяТаблиц), НРег(ПолноеИмяТаблицы)) = 0 Тогда
			Если ЗначениеЗаполнено(СтрокаБитойСсылки.ИменаСсылающихсяТаблиц) Тогда
				СтрокаБитойСсылки.ИменаСсылающихсяТаблиц = СтрокаБитойСсылки.ИменаСсылающихсяТаблиц + ", ";
				СтрокаБитойСсылки.ПредставленияСсылающихсяТаблиц = СтрокаБитойСсылки.ПредставленияСсылающихсяТаблиц + ", ";
			КонецЕсли; 
			СтрокаБитойСсылки.ИменаСсылающихсяТаблиц = СтрокаБитойСсылки.ИменаСсылающихсяТаблиц + СтрокаСвязанныхДанных.ИмяТаблицы;
			СтрокаБитойСсылки.ПредставленияСсылающихсяТаблиц = СтрокаБитойСсылки.ПредставленияСсылающихсяТаблиц + СтрокаСвязанныхДанных.ПредставлениеТаблицы;
		КонецЕсли; 
	КонецЦикла;
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	ЭлементыФормы.ТипыНайденныхБитыхСсылок.ТекущаяСтрока = ТипыНайденныхБитыхСсылок[0];
	БитыеСсылки.Загрузить(БитыеСсылкиТЗ);
	Если БитыеСсылки.Количество() > 0 Тогда
		ЭлементыФормы.БитыеСсылки.ТекущаяСтрока = БитыеСсылки[0];
	КонецЕсли; 
	
КонецПроцедуры

Функция ПолучитьЗапросВыборки(ПолучатьДанные = Истина)
	
	Если ПолучатьДанные Тогда
		СвязанныеДанные.Очистить();
	КонецЕсли; 
	ТипыСсылок = Новый Соответствие;
	ТипыСсылокМассив = Новый Массив;
	ТаблицаПустыхСсылок = Новый ТаблицаЗначений;
	ТаблицаПустыхСсылок.Колонки.Добавить("ПустаяСсылка");
	ТаблицаПустыхСсылок.Добавить(); // Неопределено тоже нужно
	Если ЛиВсеТипы Тогда
		СтрокиМетаОбъектов = ирКэш.Получить().ТаблицаТиповМетаОбъектов.НайтиСтроки(Новый Структура("Категория", 0));
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
	ТаблицаПустыхСсылок = ирОбщий.ПолучитьТаблицуСМинимальнымиТипамиКолонокЛкс(ТаблицаПустыхСсылок);
	ТаблицаВсехТаблиц = ирКэш.ТаблицаВсехТаблицБДЛкс();
	ТекстПакета = Неопределено;
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	ИмяТаблицыТипов = "ТаблицаТиповСсылок";
	ИмяТаблицыПустыхСсылок = "ТаблицаПустыхСсылок";
	Запрос.Текст = ирОбщий.ПолучитьТекстЗапросаВсехТиповСсылокЛкс(ИмяТаблицыТипов, Новый ОписаниеТипов(ТипыСсылокМассив));
	Запрос.Выполнить();
	Запрос.Параметры.Вставить("СписокТипов", ТипыСсылокМассив);
	Запрос.Параметры.Вставить("ТаблицаПустыхСсылок", ТаблицаПустыхСсылок);
	Запрос.Текст = "ВЫБРАТЬ * ПОМЕСТИТЬ ТаблицаПустыхСсылок ИЗ &ТаблицаПустыхСсылок КАК ТаблицаПустыхСсылок";
	Запрос.Выполнить();
	ТекстЗапроса = "";
	СчетчикЧастейОбъединения = 0;
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
		ПолноеИмяТаблицыБД = ОписаниеТаблицы.ПолноеИмя;
		ПоляТаблицыБД = ирКэш.ПоляТаблицыБДЛкс(ПолноеИмяТаблицыБД);
		Если ПоляТаблицыБД = Неопределено Тогда
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
				ПолноеИмяМД = ирОбщий.ПолучитьСтрокуМеждуМаркерамиЛкс(ПолноеИмяТаблицыБД,, ".Изменения");
				Если Не ирОбщий.ЭтоКорректноеПолеТаблицыИзмененийЛкс(ПолноеИмяМД, "" + ПолеТаблицыБД.Имя) Тогда
					Сообщить("В таблице изменений регистра " + ПолноеИмяМД + " пропущено поле " + ПолеТаблицыБД.Имя + ", т.к. оно порождено конфликтом имен полей");
					Продолжить;
				КонецЕсли; 
			КонецЕсли; 
			ВыражениеПоляСУсечениемТипов = Неопределено;
			СписокТипов = Неопределено;
			СчетчикТипов = 0;
			Для Каждого ТипЗначенияПоля Из ПолеТаблицыБД.ТипЗначения.Типы() Цикл
				ИмяИскомогоТипа = ТипыСсылок[ТипЗначенияПоля];
				Если ИмяИскомогоТипа <> Неопределено Тогда
					Если ВыражениеПоляСУсечениемТипов = Неопределено Тогда
						ВыражениеПоляСУсечениемТипов = Новый ЗаписьXML;
						ВыражениеПоляСУсечениемТипов.УстановитьСтроку("");
						СписокТипов = Новый ЗаписьXML;
						СписокТипов.УстановитьСтроку("");
					КонецЕсли; 
					ВыражениеПоляСУсечениемТипов.ЗаписатьБезОбработки("
					|		КОГДА Т." + ПолеТаблицыБД.Имя + " ССЫЛКА " + ИмяИскомогоТипа + " ТОГДА ВЫРАЗИТЬ(Т." + ПолеТаблицыБД.Имя + " КАК " + ИмяИскомогоТипа + ")");
					СписокТипов.ЗаписатьБезОбработки(",
					|		ТИП(" + ИмяИскомогоТипа + ")");
					СчетчикТипов = СчетчикТипов + 1;
					Если СчетчикТипов = 1 Тогда // после >5 начинается заметное замедление на моем домашнем MSSQL стенде
						ВыражениеПоляСУсечениемТипов = ВыражениеПоляСУсечениемТипов.Закрыть();
						СписокТипов = Сред(СписокТипов.Закрыть(), 2);
						ДобавитьЧастьОбъединения(Запрос, ПолучатьДанные, ТекстПакета, ВыражениеПоляСУсечениемТипов, ИмяТаблицыТипов, ОписаниеТаблицы, ПолеТаблицыБД, ПолноеИмяТаблицыБД, ТекстЗапроса,
							СчетчикЧастейОбъединения, СписокТипов, СчетчикЧастейОбъединения, ИмяТаблицыПустыхСсылок);
						ВыражениеПоляСУсечениемТипов = Неопределено;
						СписокТипов = Неопределено;
						СчетчикТипов = 0;
					КонецЕсли; 
				КонецЕсли; 
			КонецЦикла; 
			Если ВыражениеПоляСУсечениемТипов <> Неопределено Тогда
				Если ПолеТаблицыБД.ТипЗначения.Типы().Количество() = 1 Тогда
					ВыражениеПоляСУсечениемТипов = "КОГДА ИСТИНА ТОГДА Т." + ПолеТаблицыБД.Имя;
				Иначе
					ВыражениеПоляСУсечениемТипов = ВыражениеПоляСУсечениемТипов.Закрыть();
				КонецЕсли; 
				СписокТипов = Сред(СписокТипов.Закрыть(), 2);
				ДобавитьЧастьОбъединения(Запрос, ПолучатьДанные, ТекстПакета, ВыражениеПоляСУсечениемТипов, ИмяТаблицыТипов, ОписаниеТаблицы, ПолеТаблицыБД, ПолноеИмяТаблицыБД, ТекстЗапроса,
					СчетчикЧастейОбъединения, СписокТипов, СчетчикЧастейОбъединения, ИмяТаблицыПустыхСсылок);
			КонецЕсли; 
		КонецЦикла;
	КонецЦикла;
	Если ЗначениеЗаполнено(ТекстЗапроса) Тогда
		ВыполнитьДобавитьНакопленныйЗапрос(Запрос, ПолучатьДанные, ТекстЗапроса, ТекстПакета, СчетчикЧастейОбъединения);
	КонецЕсли; 
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	Если ТекстПакета <> Неопределено Тогда
		ТекстПакета = ТекстПакета.Закрыть();
	КонецЕсли; 
	Запрос.Текст = ТекстПакета;
	Возврат Запрос;

КонецФункции

Процедура ВыполнитьДобавитьНакопленныйЗапрос(Знач Запрос, Знач ПолучатьДанные, ТекстЗапроса, ТекстПакета, СчетчикЧастейОбъединения)
	
	Если ЗначениеЗаполнено(ТекстЗапроса) Тогда
		Если ПолучатьДанные Тогда
			// Выполнение запросов в цикле здесь почему то быстрее пакетного запроса
			Запрос.Текст = ТекстЗапроса;
			СтароеКоличествоСтрок = СвязанныеДанные.Количество();
			ирОбщий.ЗагрузитьВТаблицуЗначенийЛкс(Запрос.Выполнить().Выгрузить(), СвязанныеДанные);
			
			ТаблицаВсехТаблиц = ирКэш.ТаблицаВсехТаблицБДЛкс();
			Для Индекс = СтароеКоличествоСтрок По СвязанныеДанные.Количество() - 1 Цикл
				СтрокаСвязанныхДанных = СвязанныеДанные[Индекс];
				ПолноеИмяТаблицы = СтрокаСвязанныхДанных.ПолноеИмяТаблицы;
				ОписаниеТаблицы = ТаблицаВсехТаблиц.Найти(НРег(ПолноеИмяТаблицы), "НПолноеИмя");
				СтрокаСвязанныхДанных.ИмяТаблицы = ОписаниеТаблицы.Имя;
				СтрокаСвязанныхДанных.ПредставлениеТаблицы = ОписаниеТаблицы.Представление;
			КонецЦикла;
			ЭлементыФормы.СвязанныеДанные.ОбновитьСтроки();
		Иначе
			Если ТекстПакета = Неопределено Тогда
				ТекстПакета = Новый ЗаписьXML;
				ТекстПакета.УстановитьСтроку("");
			Иначе
				ТекстЗапроса = ";//////////////////////" + ТекстЗапроса;
			КонецЕсли; 
			ТекстПакета.ЗаписатьБезОбработки(ТекстЗапроса);
		КонецЕсли; 
		СчетчикЧастейОбъединения = 0;
		ТекстЗапроса = "";
	КонецЕсли;

КонецПроцедуры

Процедура ДобавитьЧастьОбъединения(Запрос, ПолучатьДанные, ТекстПакета, Знач ВыражениеПоляСУсечениемТипов, Знач ИмяТаблицыТипов, Знач ОписаниеТаблицы, Знач ПолеТаблицыБД, Знач ПолноеИмяТаблицыБД, ТекстЗапроса,
	СчетчикПодзапросов, СписокТипов, СчетчикЧастейОбъединения, ИмяТаблицыПустыхСсылок)
	
	ОбработкаПрерыванияПользователя();
	СчетчикПодзапросов = СчетчикПодзапросов + 1;
	ТипТаблицы = ОписаниеТаблицы.Тип;
	ТекстЧасти = "
	|ВЫБРАТЬ
	|	" + ИмяТаблицыТипов + ".Имя КАК ИмяТипаСсылки,
	|	ТИПЗНАЧЕНИЯ(Т." + ПолеТаблицыБД.Имя + ") КАК ТипСсылки,
	|	""" + ТипТаблицы + """ КАК ТипТаблицы,
	|	""" + ПолноеИмяТаблицыБД + """ КАК ПолноеИмяТаблицы,
	|	""" + ПолеТаблицыБД.Имя + """ КАК ИмяКолонки,
	|	Т." + ПолеТаблицыБД.Имя + " КАК Ссылка,
	|	Количество(*) КАК КоличествоСсылающихся
	|ИЗ " + ПолноеИмяТаблицыБД + " КАК Т
	|ВНУТРЕННЕЕ СОЕДИНЕНИЕ " + ИмяТаблицыТипов + " КАК " + ИмяТаблицыТипов + " ПО ТИПЗНАЧЕНИЯ(Т." + ПолеТаблицыБД.Имя + ") = " + ИмяТаблицыТипов + ".Тип
	|ЛЕВОЕ СОЕДИНЕНИЕ " + ИмяТаблицыПустыхСсылок + " КАК " + ИмяТаблицыПустыхСсылок + " ПО Т." + ПолеТаблицыБД.Имя + " = " + ИмяТаблицыПустыхСсылок + ".ПустаяСсылка
	|ГДЕ ИСТИНА
	|	И " + ИмяТаблицыПустыхСсылок + ".ПустаяСсылка ЕСТЬ NULL
	|	И (ВЫБОР " + ВыражениеПоляСУсечениемТипов + " КОНЕЦ).Ссылка ЕСТЬ NULL
	|	И ТИПЗНАЧЕНИЯ(Т." + ПолеТаблицыБД.Имя + ") В (" + СписокТипов + ")
	|СГРУППИРОВАТЬ ПО 
	|	" + ИмяТаблицыТипов + ".Имя,
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
	Если СчетчикЧастейОбъединения = 100 Тогда
		ВыполнитьДобавитьНакопленныйЗапрос(Запрос, ПолучатьДанные, ТекстЗапроса, ТекстПакета, СчетчикЧастейОбъединения);
	КонецЕсли; 

КонецПроцедуры

Процедура КП_СвязанныеДанныеОтборБезЗначения(Кнопка)
	
	ирОбщий.ТабличноеПоле_ОтборБезЗначенияВТекущейКолонке_КнопкаЛкс(ЭлементыФормы.СвязанныеДанные);

КонецПроцедуры

Процедура КоманднаяПанельНайденныеОбъектыОткрытьТаблицу(Кнопка)
	
	ирОбщий.ОткрытьЗначениеЛкс(БитыеСсылки.Выгрузить(), Ложь,,,,, ЭлементыФормы.БитыеСсылки);

КонецПроцедуры

Процедура БитыеСсылкиПередНачаломДобавления(Элемент, Отказ, Копирование)
	// Вставить содержимое обработчика.
КонецПроцедуры

Процедура БитыеСсылкиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
КонецПроцедуры

Процедура БитыеСсылкиПриАктивизацииСтроки(Элемент)
	
	ТекущаяСтрока = Элемент.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		ЗначениеОтбора = Неопределено;
	Иначе
		ЗначениеОтбора = ТекущаяСтрока.Ссылка;
	КонецЕсли; 
	ЭлементыФормы.СвязанныеДанные.ОтборСтрок.Ссылка.Установить(ЗначениеОтбора, ЭлементыФормы.СвязанныеДанные.ОтборСтрок.Ссылка.Использование);
	
КонецПроцедуры

Процедура ИмяПредставлениеПриИзменении(Элемент = Неопределено)
	
	ТабличноеПоле = ЭлементыФормы.СвязанныеДанные;
	ТабличноеПоле.Колонки.ПредставлениеКолонки.Видимость = Не ИмяПредставление;
	ТабличноеПоле.Колонки.ПредставлениеТаблицы.Видимость = Не ИмяПредставление;
	ТабличноеПоле.Колонки.ИмяТаблицы.Видимость = ИмяПредставление;
	ТабличноеПоле.Колонки.ИмяКолонки.Видимость = ИмяПредставление;
	//Если Не ИмяПредставление Тогда
	//	ЭлементОтбора = ТабличноеПоле.ОтборСтрок.ИмяТаблицы;
	//Иначе
	//	ЭлементОтбора = ТабличноеПоле.ОтборСтрок.ПредставлениеТаблицы;
	//КонецЕсли;
	//ЭлементОтбора.Значение = "";
	//Если Не ИмяПредставление Тогда
	//	ЭлементОтбора = ТабличноеПоле.ОтборСтрок.ИмяКолонки;
	//Иначе
	//	ЭлементОтбора = ТабличноеПоле.ОтборСтрок.ПредставлениеКолонки;
	//КонецЕсли;
	//ЭлементОтбора.Значение = "";
	СтараяКолонка = ТабличноеПоле.ТекущаяКолонка;
	Если СтараяКолонка <> Неопределено Тогда
		Если Найти(НРег(СтараяКолонка.Имя), "таблицы") > 0 Тогда
			Если ТабличноеПоле.Колонки.ПредставлениеТаблицы.Видимость Тогда
				ТабличноеПоле.ТекущаяКолонка = ТабличноеПоле.Колонки.ПредставлениеТаблицы;
			Иначе
				ТабличноеПоле.ТекущаяКолонка = ТабличноеПоле.Колонки.ИмяТаблицы;
			КонецЕсли; 
		ИначеЕсли Найти(НРег(СтараяКолонка.Имя), "колонки") > 0 Тогда
			Если ТабличноеПоле.Колонки.ПредставлениеКолонки.Видимость Тогда
				ТабличноеПоле.ТекущаяКолонка = ТабличноеПоле.Колонки.ПредставлениеКолонки;
			Иначе
				ТабличноеПоле.ТекущаяКолонка = ТабличноеПоле.Колонки.ИмяКолонки;
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 
	//ОбновитьОтборСвязанныхДанных();
	
	ТабличноеПоле = ЭлементыФормы.БитыеСсылки;
	ТабличноеПоле.Колонки.ПредставленияСсылающихсяТаблиц.Видимость = Не ИмяПредставление;
	ТабличноеПоле.Колонки.ИменаСсылающихсяТаблиц.Видимость = ИмяПредставление;
	ТабличноеПоле.Колонки.ПредставлениеТипаСсылки.Видимость = Не ИмяПредставление;
	ТабличноеПоле.Колонки.ИмяТипаСсылки.Видимость = ИмяПредставление;
	СтараяКолонка = ТабличноеПоле.ТекущаяКолонка;
	Если СтараяКолонка <> Неопределено Тогда
		Если Найти(НРег(СтараяКолонка.Имя), "таблиц") > 0 Тогда
			Если ТабличноеПоле.Колонки.ПредставленияСсылающихсяТаблиц.Видимость Тогда
				ТабличноеПоле.ТекущаяКолонка = ТабличноеПоле.Колонки.ПредставленияСсылающихсяТаблиц;
			Иначе
				ТабличноеПоле.ТекущаяКолонка = ТабличноеПоле.Колонки.ИменаСсылающихсяТаблиц;
			КонецЕсли; 
		ИначеЕсли Найти(НРег(СтараяКолонка.Имя), "типассылки") > 0 Тогда
			Если ТабличноеПоле.Колонки.ПредставлениеТипаСсылки.Видимость Тогда
				ТабличноеПоле.ТекущаяКолонка = ТабличноеПоле.Колонки.ПредставлениеТипаСсылки;
			Иначе
				ТабличноеПоле.ТекущаяКолонка = ТабличноеПоле.Колонки.ИмяТипаСсылки;
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 
	
	ТабличноеПоле = ЭлементыФормы.ТипыНайденныхБитыхСсылок;
	ТабличноеПоле.Колонки.ПредставлениеТипаСсылки.Видимость = Не ИмяПредставление;
	ТабличноеПоле.Колонки.ИмяТипаСсылки.Видимость = ИмяПредставление;
	СтараяКолонка = ТабличноеПоле.ТекущаяКолонка;
	Если СтараяКолонка <> Неопределено Тогда
		Если Найти(НРег(СтараяКолонка.Имя), "типассылки") > 0 Тогда
			Если ТабличноеПоле.Колонки.ПредставлениеТипаСсылки.Видимость Тогда
				ТабличноеПоле.ТекущаяКолонка = ТабличноеПоле.Колонки.ПредставлениеТипаСсылки;
			Иначе
				ТабличноеПоле.ТекущаяКолонка = ТабличноеПоле.Колонки.ИмяТипаСсылки;
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

Процедура СвязанныеДанныеПриАктивизацииСтроки(Элемент = Неопределено)
	
	Элемент = ЭлементыФормы.СвязанныеДанные;
	СтрокаСвязаннойКолонки = Элемент.ТекущаяСтрока;
	Если СтрокаСвязаннойКолонки = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	Если ЭлементыФормы.СвязанныеДанные.ОтборСтрок.Ссылка.Использование Или ОтборПоТекущейСсылкеВТаблицеБД Тогда
		ЗначениеОтбора = СтрокаСвязаннойКолонки.Ссылка;
	Иначе
		ПостроительТабличногоПоля = ирОбщий.ПолучитьПостроительТабличногоПоляСОтборомКлиентаЛкс(Элемент);
		ПостроительТабличногоПоля.Отбор.ИмяКолонки.Установить(СтрокаСвязаннойКолонки.ИмяКолонки);
		ПостроительТабличногоПоля.Отбор.ПолноеИмяТаблицы.Установить(СтрокаСвязаннойКолонки.ПолноеИмяТаблицы);
		МассивСсылок = ПостроительТабличногоПоля.Результат.Выгрузить().ВыгрузитьКолонку("Ссылка");
		ЗначениеОтбора = Новый СписокЗначений;
		ЗначениеОтбора.ЗагрузитьЗначения(МассивСсылок);
	КонецЕсли; 
	РезультатЗагрузки = ирОбщий.ЗагрузитьСвязанныеСтрокиТаблицыБДЛкс(ЭтаФорма, Элемент, ЭлементыФормы.СтрокиТаблицыБД, ЭлементыФормы.КоманднаяПанельСтрокиТаблицыБД, 
		мВыборкаРезультатаСтрокиТаблицы, ЗначениеОтбора);
	Если РезультатЗагрузки = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ЭтаФорма.ПолноеИмяСвязаннойТаблицыБД = РезультатЗагрузки;
	СтрокаСвязанныхДанных = Элемент.ТекущаяСтрока;
	Если ОтборПоТекущейСсылкеВТаблицеБД Или ЭлементыФормы.СвязанныеДанные.ОтборСтрок.Ссылка.Использование Тогда
		СтрокаСвязанныхДанных.КоличествоСсылающихся = СтрокиТаблицыБД.Количество();
	КонецЕсли; 

КонецПроцедуры

Процедура ОбновитьРазмерДинамическойТаблицы() Экспорт

	ирОбщий.ПослеЗагрузкиВыборкиВТабличноеПолеЛкс(ЭтаФорма, мВыборкаРезультатаСтрокиТаблицы,
		ЭлементыФормы.КоманднаяПанельСтрокиТаблицыБД, ЭлементыФормы.КоличествоСтрокТаблицыБД);

КонецПроцедуры // ОбновитьРазмерТаблицы()

Процедура КоманднаяПанельСтрокиТаблицыБДЗагрузитьПолностью(Кнопка)
	
	ирОбщий.ЗагрузитьВыборкуВТабличноеПолеПолностьюЛкс(ЭтаФорма, мВыборкаРезультатаСтрокиТаблицы, 
		ЭлементыФормы.КоманднаяПанельСтрокиТаблицыБД);

КонецПроцедуры

Процедура КоманднаяПанельСтрокиТаблицыБДРедактировать(Кнопка)
	
	Если ЭлементыФормы.СвязанныеДанные.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ирОбщий.ОткрытьТекущуюСтрокуТабличногоПоляТаблицыБДВРедактореОбъектаБДЛкс(ЭлементыФормы.СтрокиТаблицыБД, ЭлементыФормы.СвязанныеДанные.ТекущаяСтрока.ПолноеИмяТаблицы,,,,, Ложь);
	
КонецПроцедуры

Процедура КоманднаяПанельСтрокиТаблицыБДКонсольОбработки(Кнопка)
	
	Ответ = Вопрос("Использовать значения текущей колонки (да) или ключи строк (нет)?", РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ирОбщий.ОткрытьОбъектыИзВыделенныхЯчеекВПодбореИОбработкеОбъектовЛкс(ЭлементыФормы.СтрокиТаблицыБД);
	Иначе
		ирОбщий.ОткрытьОбъектыИзВыделенныхСтрокВПодбореИОбработкеОбъектовЛкс(ЭлементыФормы.СтрокиТаблицыБД, ПолноеИмяСвязаннойТаблицыБД);
	КонецЕсли;
	
КонецПроцедуры

Процедура КоманднаяПанельСтрокиТаблицыБДСжатьКолонки(Кнопка)
	
	ирОбщий.СжатьКолонкиТабличногоПоляЛкс(ЭлементыФормы.СтрокиТаблицыБД);
	
КонецПроцедуры

Процедура КоманднаяПанельСтрокиТаблицыБДШиринаКолонок(Кнопка)
	
	ирОбщий.РасширитьКолонкиТабличногоПоляЛкс(ЭлементыФормы.СтрокиТаблицыБД);

КонецПроцедуры

Процедура СвязанныеДанныеВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если ВыбраннаяСтрока.ТипТаблицы = "Константа" Тогда
		ФормаСписка = ирОбщий.ПолучитьФормуЛкс("Обработка.ирРедакторКонстант.Форма");
		ТекущаяСтрока = ирОбщий.ПолучитьПоследнийФрагментЛкс(ВыбраннаяСтрока.ПолноеИмяТаблицы);
		ФормаСписка.НачальноеЗначениеВыбора = ТекущаяСтрока;
		ФормаСписка.Открыть();
	ИначеЕсли Истина
		И Не ирОбщий.ЛиТипВложеннойТаблицыБДЛкс(ВыбраннаяСтрока.ТипТаблицы)
		И ВыбраннаяСтрока.ТипТаблицы <> "Изменения"
	Тогда
		ирОбщий.ОткрытьФормуСпискаЛкс(ВыбраннаяСтрока.ПолноеИмяТаблицы, Новый Структура(ВыбраннаяСтрока.ИмяКолонки, ВыбраннаяСтрока.Ссылка));
	КонецЕсли; 

КонецПроцедуры

Процедура КП_СвязанныеДанныеОткрытьТаблицу(Кнопка)
	
	ирОбщий.ОткрытьЗначениеЛкс(СвязанныеДанные.Выгрузить(), Ложь,,,,, ЭлементыФормы.СвязанныеДанные);
	
КонецПроцедуры

Процедура СтрокиТаблицыБДВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ирОбщий.ЯчейкаТабличногоПоляРасширенногоЗначения_ВыборЛкс(Элемент, СтандартнаяОбработка);

КонецПроцедуры

Процедура ТипыНайденныхБитыхСсылокПриАктивизацииСтроки(Элемент)
	
	ТекущаяСтрока = ЭлементыФормы.ТипыНайденныхБитыхСсылок.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		ИмяТипаСсылки = "<Все>";
	Иначе
		ИмяТипаСсылки = ТекущаяСтрока.ИмяТипаСсылки;
	КонецЕсли; 
	ЭлементыФормы.ОтборПоТипуСсылки.Доступность = ИмяТипаСсылки <> "<Все>";
	ЭлементыФормы.БитыеСсылки.ОтборСтрок.ИмяТипаСсылки.Установить(ИмяТипаСсылки, ИмяТипаСсылки <> "<Все>");
	ЭлементыФормы.СвязанныеДанные.ОтборСтрок.ИмяТипаСсылки.Установить(ИмяТипаСсылки, ЭлементыФормы.СвязанныеДанные.ОтборСтрок.ИмяТипаСсылки.Использование И ИмяТипаСсылки <> "<Все>");
	
КонецПроцедуры

Процедура ОтборПоТекущейСсылкеВТаблицеБДПриИзменении(Элемент)
	
	СвязанныеДанныеПриАктивизацииСтроки();

КонецПроцедуры

Процедура ОтборПоСсылкеПриИзменении(Элемент)
	
	ОбновитьДоступность();
	
КонецПроцедуры

Процедура ОбновитьДоступность()
	
	ЭлементыФормы.ОтборПоТекущейСсылкеВТаблицеБД.Доступность = Не ЭлементыФормы.СвязанныеДанные.ОтборСтрок.Ссылка.Использование;
	ЭлементыФормы.ТипыСсылокДляПоиска.Доступность = Не ЛиВсеТипы;
	ЭлементыФормы.УчитыватьВиртуальныеТаблицы.Доступность = Не ТолькоРегистраторы;
	
КонецПроцедуры

Процедура СвязанныеДанныеПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	Ячейка = ОформлениеСтроки.Ячейки.ТипТаблицы;
	Ячейка.ОтображатьКартинку = Истина;
	//ТипТаблицы = ирОбщий.ПолучитьПервыйФрагментЛкс(ДанныеСтроки.ТипТаблицы);
	Ячейка.ИндексКартинки = ирОбщий.ПолучитьИндексКартинкиТипаТаблицыБДЛкс(ДанныеСтроки.ТипТаблицы);

КонецПроцедуры

Процедура ВсеТипыПриИзменении(Элемент)
	
	ОбновитьДоступность();
	
КонецПроцедуры

Процедура ТолькоРегистраторыПриИзменении(Элемент)
	
	ОбновитьДоступность();
	
КонецПроцедуры

Процедура КлсУниверсальнаяКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработчикОжиданияСПараметрамиЛкс() Экспорт 
	
	ирОбщий.ОбработчикОжиданияСПараметрамиЛкс();

КонецПроцедуры

Процедура КоманднаяПанельСтрокиТаблицыБДИдентификаторы(Кнопка)
	
	ирОбщий.КнопкаОтображатьПустыеИИдентификаторыНажатиеЛкс(Кнопка);
	ЭлементыФормы.СтрокиТаблицыБД.ОбновитьСтроки();
	
КонецПроцедуры

Процедура СтрокиТаблицыБДПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(Элемент, ОформлениеСтроки, ДанныеСтроки, ЭлементыФормы.КоманднаяПанельСтрокиТаблицыБД.Кнопки.Идентификаторы);

КонецПроцедуры

Процедура КП_СвязанныеДанныеМенеджерТабличногоПоля(Кнопка)
	
	ирОбщий.ОткрытьМенеджерТабличногоПоляЛкс(ЭлементыФормы.СвязанныеДанные, ЭтаФорма);
	
КонецПроцедуры

Процедура КоманднаяПанельНайденныеОбъектыРедакторОбъектаБД(Кнопка)
	
	Если ЭлементыФормы.БитыеСсылки.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ирОбщий.ОткрытьСсылкуВРедактореОбъектаБДЛкс(ЭлементыФормы.БитыеСсылки.ТекущаяСтрока.Ссылка);

КонецПроцедуры

Процедура ГлавнаяКоманднаяПанельСтруктураФормы(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруФормыЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура КоманднаяПанельСтрокиТаблицыБДМенеджерТабличногоПоля(Кнопка)
	
	ирОбщий.ОткрытьМенеджерТабличногоПоляЛкс(ЭлементыФормы.СтрокиТаблицыБД, ЭтаФорма);
	
КонецПроцедуры

Процедура КоманднаяПанельНайденныеОбъектыМенеджерТабличногоПоля(Кнопка)
	
	ирОбщий.ОткрытьМенеджерТабличногоПоляЛкс(ЭлементыФормы.БитыеСсылки, ЭтаФорма);
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирПоискБитыхСсылок.Форма.Форма");
ЭтаФорма.ПолноеИмяСвязаннойТаблицыБД = "<Полное имя таблицы>";
ЭтаФорма.ЛиВсеТипы = Истина;
// Антибаг платформы. Очищаются свойство данные, если оно указывает на отбор табличной части
ЭлементыФормы.ОтборПоСсылке.Данные = "ЭлементыФормы.СвязанныеДанные.Отбор.Ссылка.Использование";
ЭлементыФормы.ОтборПоТипуСсылки.Данные = "ЭлементыФормы.СвязанныеДанные.Отбор.ИмяТипаСсылки.Использование";
