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
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, Метаданные().Имя);
	
КонецПроцедуры

Процедура ПредставлениеОбластиПоискаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, Метаданные().Имя);

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
	
	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, Метаданные().Имя);
	
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
	
	Если Истина
		И Не ЛиВсеТипы
		И ТипыСсылокДляПоиска.Количество() = 0 
	Тогда
		Возврат;
	КонецЕсли; 
	ПолучитьЗапросВыборки();
	ИтогиБитыхСсылок = СвязанныеДанные.Выгрузить();
	ИтогиБитыхСсылок.Свернуть("Ссылка, ИмяТипаСсылки", "КоличествоСсылающихся");
	БитыеСсылки.Загрузить(ИтогиБитыхСсылок);
	Для Каждого БитаяСсылка Из БитыеСсылки Цикл
		БитаяСсылка.ПредставлениеТипаСсылки = "" + Тип(СтрЗаменить(БитаяСсылка.ИмяТипаСсылки, ".", "Ссылка."));
	КонецЦикла;
	ИтогиТипов = БитыеСсылки.Выгрузить();
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
	ТаблицаВсехТаблиц = ирКэш.ПолучитьТаблицуВсехТаблицБДЛкс();
	Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(СвязанныеДанные.Количество(), "Обработка результатов");
	Для Каждого СтрокаСвязанныхДанных Из СвязанныеДанные Цикл
		ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
		ПолноеИмяТаблицы = СтрокаСвязанныхДанных.ПолноеИмяТаблицы;
		КомпоновщикТаблицы = ирКэш.ПолучитьКомпоновщикТаблицыБДПоПолномуИмениЛкс(ПолноеИмяТаблицы);
		#Если _ Тогда
		    КомпоновщикТаблицы = Новый КомпоновщикНастроекКомпоновкиДанных;
		#КонецЕсли
		ОписаниеТаблицы = ТаблицаВсехТаблиц.Найти(НРег(ПолноеИмяТаблицы), "НПолноеИмя");
		СтрокаСвязанныхДанных.ИмяТаблицы = ОписаниеТаблицы.Имя;
		СтрокаСвязанныхДанных.ПредставлениеТаблицы = ОписаниеТаблицы.Представление;
		ДоступноеПоле = КомпоновщикТаблицы.Настройки.ДоступныеПоляОтбора.НайтиПоле(Новый ПолеКомпоновкиДанных(СтрокаСвязанныхДанных.ИмяКолонки));
		СтрокаСвязанныхДанных.ПредставлениеКолонки = ДоступноеПоле.Заголовок;
		СтрокаСвязанныхДанных.КоличествоТипов = ДоступноеПоле.ТипЗначения.Типы().Количество();
		СтрокаБитойСсылки = БитыеСсылки.Найти(СтрокаСвязанныхДанных.Ссылка, "Ссылка");
		Если Найти(Нрег(СтрокаБитойСсылки.ИменаСсылающихсяТаблиц), НРег(ПолноеИмяТаблицы)) = 0 Тогда
			Если ЗначениеЗаполнено(СтрокаБитойСсылки.ИменаСсылающихсяТаблиц) Тогда
				СтрокаБитойСсылки.ИменаСсылающихсяТаблиц = СтрокаБитойСсылки.ИменаСсылающихсяТаблиц + ", ";
			КонецЕсли; 
			СтрокаБитойСсылки.ИменаСсылающихсяТаблиц = СтрокаБитойСсылки.ИменаСсылающихсяТаблиц + СтрокаСвязанныхДанных.ИмяТаблицы;
			СтрокаБитойСсылки.ПредставленияСсылающихсяТаблиц = СтрокаБитойСсылки.ПредставленияСсылающихсяТаблиц + СтрокаСвязанныхДанных.ПредставлениеТаблицы;
		КонецЕсли; 
	КонецЦикла;
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	
КонецПроцедуры

Функция ПолучитьЗапросВыборки(ПолучатьДанные = Истина)
	
	Если ПолучатьДанные Тогда
		СвязанныеДанные.Очистить();
	КонецЕсли; 
	ТипыСсылок = Новый Соответствие;
	Если ЛиВсеТипы Тогда
		СтрокиМетаОбъектов = ирКэш.Получить().ТаблицаТиповМетаОбъектов.НайтиСтроки(Новый Структура("Категория", 0));
		Для Каждого СтрокаТаблицыМетаОбъектов Из СтрокиМетаОбъектов Цикл
			Единственное = СтрокаТаблицыМетаОбъектов.Единственное;
			Если ирОбщий.ЛиКорневойТипСсылочногоОбъектаБДЛкс(Единственное) Тогда
				Для Каждого МетаОбъект Из Метаданные[СтрокаТаблицыМетаОбъектов.Множественное] Цикл
					ТипыСсылок.Вставить(МетаОбъект.ПолноеИмя(), Тип(СтрокаТаблицыМетаОбъектов.Единственное + "Ссылка." + МетаОбъект.Имя));
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;
	Иначе
		Для Каждого ИскомыйТип Из ТипыСсылокДляПоиска Цикл
			ТипыСсылок.Вставить(ИскомыйТип, Тип(СтрЗаменить(ИскомыйТип, ".", "Ссылка.")));
		КонецЦикла; 
	КонецЕсли; 
	ТаблицаВсехТаблиц = ирКэш.ПолучитьТаблицуВсехТаблицБДЛкс();
	ТекстПакета = Неопределено;
	Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(ТаблицаВсехТаблиц.Количество());
	Для Каждого ОписаниеТаблицы Из ТаблицаВсехТаблиц Цикл
		ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
		Если Ложь
			Или ирОбщий.ЛиКорневойТипКритерияОтбораЛкс(ОписаниеТаблицы.Тип)
			Или (Истина
				И Не УчитыватьВиртуальныеТаблицы
				И ОписаниеТаблицы.Тип = "ВиртуальнаяТаблица")
			Или (Истина
				И ТолькоРегистраторы
				И Не ирОбщий.ЛиКорневойТипРегистраБДЛкс(ОписаниеТаблицы.Тип))
		Тогда
			Продолжить;
		КонецЕсли; 
		ПолноеИмяТаблицыБД = ОписаниеТаблицы.ПолноеИмя;
		КомпоновщикТаблицы = ирКэш.ПолучитьКомпоновщикТаблицыБДПоПолномуИмениЛкс(ПолноеИмяТаблицыБД);
		#Если _ Тогда
			КомпоновщикТаблицы = Новый КомпоновщикНастроекКомпоновкиДанных;
		#КонецЕсли
		ТекстЗапроса = "";
		Для Каждого ДоступноеПоле Из КомпоновщикТаблицы.Настройки.ДоступныеПоляВыбора.Элементы Цикл
			Если Ложь
				Или ДоступноеПоле.Папка 
				Или (Истина
					И ТолькоРегистраторы
					И ("" + ДоступноеПоле.Поле) <> "Регистратор")
				Или (Истина
					И Не УчитыватьВсеКолонкиТаблицИзменений
					И ОписаниеТаблицы.Тип = "Изменения"
					И ("" + ДоступноеПоле.Поле) <> "Узел")
			Тогда
				Продолжить;
			КонецЕсли;
			ТипЗначенияДоступногоПоля = ДоступноеПоле.Тип;
			ТекстЧасти = "";
			Для Каждого КлючИЗначение Из ТипыСсылок Цикл
				Если ТипЗначенияДоступногоПоля.СодержитТип(КлючИЗначение.Значение) Тогда
					ИскомыйТип = КлючИЗначение.Ключ;
					ТипТаблицы = ОписаниеТаблицы.Тип;
					ТекстЧасти = "
					|ВЫБРАТЬ 
					|	""" + ИскомыйТип + """ КАК ИмяТипаСсылки,
					|	""" + ТипТаблицы + """ КАК ТипТаблицы,
					|	""" + ПолноеИмяТаблицыБД + """ КАК ПолноеИмяТаблицы,
					|	""" + ДоступноеПоле.Поле + """ КАК ИмяКолонки,
					|	Т." + ДоступноеПоле.Поле + " КАК Ссылка,
					|	Количество(*) КАК КоличествоСсылающихся
					|ИЗ " + ПолноеИмяТаблицыБД + " КАК Т
					|ГДЕ Т." + ДоступноеПоле.Поле + " ССЫЛКА " + ИскомыйТип + " 
					|	И Т." + ДоступноеПоле.Поле + " <> ЗНАЧЕНИЕ(" + ИскомыйТип + ".ПустаяСсылка) 
					|	И ВЫРАЗИТЬ(Т." + ДоступноеПоле.Поле + " КАК " + ИскомыйТип + ").ПометкаУдаления ЕСТЬ NULL
					|СГРУППИРОВАТЬ ПО 
					|	""" + ИскомыйТип + """,
					|	""" + ТипТаблицы + """,
					|	""" + ПолноеИмяТаблицыБД + """,
					|	""" + ДоступноеПоле.Поле + """,
					|	Т." + ДоступноеПоле.Поле + "
					|";
					Прервать;
				КонецЕсли; 
			КонецЦикла;
			Если ЗначениеЗаполнено(ТекстЧасти) Тогда
				Если ТекстЗапроса <> "" Тогда
					ТекстЧасти = "ОБЪЕДИНИТЬ ВСЕ
					|" + ТекстЧасти;
				КонецЕсли; 
				ТекстЗапроса = ТекстЗапроса + ТекстЧасти;
			КонецЕсли; 
		КонецЦикла;
		Если ЗначениеЗаполнено(ТекстЗапроса) Тогда
			Если ПолучатьДанные Тогда
				// Выполнение запросов в цикле здесь почему то быстрее пакетного запроса
				Запрос = Новый Запрос(ТекстЗапроса);
				ирОбщий.ЗагрузитьВТаблицуЗначенийЛкс(Запрос.Выполнить().Выгрузить(), СвязанныеДанные);
			Иначе
				Если ТекстПакета = Неопределено Тогда
					ТекстПакета = Новый ЗаписьXML;
					ТекстПакета.УстановитьСтроку("");
				Иначе
					ТекстЗапроса = ";//////////////////////" + ТекстЗапроса;
				КонецЕсли; 
				ТекстПакета.ЗаписатьБезОбработки(ТекстЗапроса);
			КонецЕсли; 
		КонецЕсли; 
	КонецЦикла;
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	Если ТекстПакета <> Неопределено Тогда
		ТекстПакета = ТекстПакета.Закрыть();
	КонецЕсли; 
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстПакета;
	Возврат Запрос;

КонецФункции

Процедура КП_СвязанныеДанныеОтборБезЗначения(Кнопка)
	
	ирОбщий.ТабличноеПоле_ОтборБезЗначенияВТекущейКолонке_КнопкаЛкс(ЭлементыФормы.СвязанныеДанные);

КонецПроцедуры

Процедура КоманднаяПанельНайденныеОбъектыОткрытьТаблицу(Кнопка)
	
	ирОбщий.ОткрытьФормуПроизвольногоЗначенияЛкс(БитыеСсылки.Выгрузить(), Ложь);

КонецПроцедуры

Процедура БитыеСсылкиПередНачаломДобавления(Элемент, Отказ, Копирование)
	// Вставить содержимое обработчика.
КонецПроцедуры

Процедура БитыеСсылкиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
КонецПроцедуры

Процедура БитыеСсылкиПриАктивизацииСтроки(Элемент)
	
	ЭлементыФормы.СвязанныеДанные.ОтборСтрок.Ссылка.Установить(Элемент.ТекущаяСтрока.Ссылка, ЭлементыФормы.СвязанныеДанные.ОтборСтрок.Ссылка.Использование);
	
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

	ирОбщий.ПослеЗагрузкиДинамическойВыборкиВТабличноеПолеЛкс(ЭтаФорма, мВыборкаРезультатаСтрокиТаблицы,
		ЭлементыФормы.КоманднаяПанельСтрокиТаблицыБД, ЭлементыФормы.КоличествоСтрокТаблицыБД);

КонецПроцедуры // ОбновитьРазмерТаблицы()

Процедура КоманднаяПанельСтрокиТаблицыБДЗагрузитьПолностью(Кнопка)
	
	ирОбщий.ЗагрузитьДинамическуюВыборкуВТабличноеПолеПолностьюЛкс(ЭтаФорма, мВыборкаРезультатаСтрокиТаблицы, 
		ЭлементыФормы.КоманднаяПанельСтрокиТаблицыБД);

КонецПроцедуры

Процедура КоманднаяПанельСтрокиТаблицыБДРедактировать(Кнопка)
	
	Если ЭлементыФормы.СвязанныеДанные.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ирОбщий.ОткрытьТекущуюСтрокуТабличногоПоляТаблицыБДВРедактореОбъектаБДЛкс(ЭлементыФормы.СтрокиТаблицыБД, ЭлементыФормы.СвязанныеДанные.ТекущаяСтрока.ПолноеИмяТаблицы);
	
КонецПроцедуры

Процедура КоманднаяПанельСтрокиТаблицыБДКонсольОбработки(Кнопка)
	
	Ответ = Вопрос("Использовать значения текущей колонки?", РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
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
	
	ирОбщий.ВвестиИУстановитьШиринуКолонокТабличногоПоляЛкс(ЭлементыФормы.СтрокиТаблицыБД);

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
		ирОбщий.ОткрытьФормуСпискаСОтборомЛкс(ВыбраннаяСтрока.ПолноеИмяТаблицы, Новый Структура(ВыбраннаяСтрока.ИмяКолонки, ВыбраннаяСтрока.Ссылка));
	КонецЕсли; 

КонецПроцедуры

Процедура КП_СвязанныеДанныеОткрытьТаблицу(Кнопка)
	
	ирОбщий.ОткрытьФормуПроизвольногоЗначенияЛкс(СвязанныеДанные.Выгрузить(), Ложь);
	
КонецПроцедуры

Процедура СтрокиТаблицыБДВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ирОбщий.ЯчейкаТабличногоПоляРасширенногоЗначения_ВыборЛкс(Элемент, СтандартнаяОбработка);

КонецПроцедуры

Процедура ТипыНайденныхБитыхСсылокПриАктивизацииСтроки(Элемент)
	
	ИмяТипаСсылки = ЭлементыФормы.ТипыНайденныхБитыхСсылок.ТекущаяСтрока.ИмяТипаСсылки;
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
	
	 ирОбщий.ПолучитьФормуЛкс("Обработка.ирМенеджерТабличногоПоля.Форма",, ЭтаФорма, ).УстановитьСвязь(ЭлементыФормы.СвязанныеДанные);
	
КонецПроцедуры

Процедура КоманднаяПанельНайденныеОбъектыРедакторОбъектаБД(Кнопка)
	
	Если ЭлементыФормы.БитыеСсылки.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ирОбщий.ОткрытьСсылкуВРедактореОбъектаБДЛкс(ЭлементыФормы.БитыеСсылки.ТекущаяСтрока.Ссылка);

КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирПоискБитыхСсылок.Форма.Форма");
ЭтаФорма.ПолноеИмяСвязаннойТаблицыБД = "<Полное имя таблицы>";
ЭтаФорма.ЛиВсеТипы = Истина;