﻿Функция СохраняемаяНастройкаФормы(выхНаименование, выхИменаСвойств) Экспорт 
	выхИменаСвойств = "Реквизит.ОбщаяТаблицаИндексов, Реквизит.ПоказыватьSDBL, Реквизит.ПоказыватьРазмеры, Реквизит.ПоказыватьСУБД, Реквизит.ПоказыватьУдаленные, Форма.ФильтрИмяХранения,
	|Форма.ФильтрИмяМетаданных";
	Возврат Неопределено;
КонецФункции

Процедура ЗагрузитьНастройкуВФорме(НастройкаФормы, ДопПараметры) Экспорт 
	
	ирОбщий.ЗагрузитьНастройкуФормыЛкс(ЭтаФорма, НастройкаФормы); 
	ОбновитьОтбор();

КонецПроцедуры

Процедура ОсновныеДействияФормыСохранитьНастройки(Кнопка)
	
	ирОбщий.ВыбратьИСохранитьНастройкуФормыЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ОсновныеДействияФормыЗагрузитьНастройки(Кнопка)
	
	ирОбщий.ВыбратьИЗагрузитьНастройкуФормыЛкс(ЭтаФорма);

КонецПроцедуры

Процедура ПриОткрытии()
	
	ирОбщий.СоздатьМенеджерСохраненияНастроекФормыЛкс(ЭтаФорма);
	Если ПараметрПоказыватьСУБД <> Неопределено Тогда
		ЭтаФорма.ПоказыватьСУБД = ПараметрПоказыватьСУБД;
	Иначе
		ЭтаФорма.ПоказыватьСУБД = Истина;
	КонецЕсли; 
	Если ПараметрПоказыватьSDBL <> Неопределено Тогда
		ЭтаФорма.ПоказыватьSDBL = ПараметрПоказыватьSDBL;
	Иначе
		ЭтаФорма.ПоказыватьSDBL = Ложь;
	КонецЕсли; 
	Если Ложь
		Или ПараметрИмяТаблицы <> Неопределено
		Или ПараметрИмяИндексаХранения <> Неопределено
		Или ПараметрИмяТаблицыХранения <> Неопределено
		Или ПараметрПоказыватьSDBL <> Неопределено
		Или ПараметрПоказыватьСУБД <> Неопределено
	Тогда
		ЭтаФорма.ФильтрИмяХранения = "";
		ЭтаФорма.ФильтрИмяМетаданных = "";
	КонецЕсли; 
	Если Таблицы.Количество() = 0 Тогда
		Если ОтборПоМетаданным = Неопределено И Не ЗначениеЗаполнено(ПараметрИмяТаблицы) Тогда
			ФормаВыбора = ирОбщий.ПолучитьФормуВыбораОбъектаМетаданныхЛкс(,,, Истина, Истина, Истина, Истина, Истина, Истина, Истина, Истина);
			ОтборПоМетаданным = ФормаВыбора.ОткрытьМодально();
			Если ТипЗнч(ОтборПоМетаданным) = Тип("Массив") Тогда
				Если ОтборПоМетаданным.Количество() = 0 Тогда
					ОтборПоМетаданным = Неопределено;
				КонецЕсли; 
			КонецЕсли; 
		КонецЕсли; 
		ОбновитьТаблицыВФорме();
	КонецЕсли; 
	ОбработатьПараметрыОткрытия();
	ОбновитьДоступность();
	//ЭлементыФормы.ГлавнаяКоманднаяПанель.Кнопки.ОчисткаТаблицСУБД.Доступность = Не ирКэш.ЭтоФайловаяБазаЛкс();
	ЭлементыФормы.ГлавнаяКоманднаяПанель.Кнопки.ПараметрыСУБД.Доступность = Не ирКэш.ЭтоФайловаяБазаЛкс();
	
КонецПроцедуры

Процедура ОбработатьПараметрыОткрытия()
	
	Если ЗначениеЗаполнено(ПараметрИмяТаблицы) Тогда
		НоваяТекущаяСтрока = Таблицы.Найти(ПараметрИмяТаблицы, "ИмяТаблицы");
		Если НоваяТекущаяСтрока <> Неопределено Тогда
			ЭлементыФормы.Таблицы.ТекущаяСтрока = НоваяТекущаяСтрока;
		Иначе
			Сообщить("Таблица с ""Имя таблицы"" = """ + ПараметрИмяТаблицы + """ не найдена");
		КонецЕсли; 
	КонецЕсли; 
	Если ЗначениеЗаполнено(ПараметрИмяТаблицыХранения) Тогда
		НоваяТекущаяСтрока = Таблицы.Найти(ПараметрИмяТаблицыХранения, "ИмяТаблицыХранения");
		Если НоваяТекущаяСтрока <> Неопределено Тогда
			ЭлементыФормы.Таблицы.ТекущаяСтрока = НоваяТекущаяСтрока;
		Иначе
			Сообщить("Таблица с ""Имя хранения"" = """ + ПараметрИмяТаблицы + """ не найдена");
		КонецЕсли; 
	КонецЕсли; 
	Если ЗначениеЗаполнено(ПараметрИмяИндексаХранения) Тогда
		НоваяТекущаяСтрока = НаборыПолей.Найти(ПараметрИмяИндексаХранения, "ИмяХранения");
		Если НоваяТекущаяСтрока <> Неопределено Тогда
			ЭлементыФормы.НаборыПолей.ТекущаяСтрока = НоваяТекущаяСтрока;
		Иначе
			Сообщить("Набор полей с ""Имя хранения"" = """ + ПараметрИмяТаблицы + """ не найден");
		КонецЕсли; 
	КонецЕсли;

КонецПроцедуры

Процедура ПоказыватьSDBLПриИзменении(Элемент)
	
	ОбновитьТаблицыВФорме();
	
КонецПроцедуры

Процедура ОбновитьТаблицыВФорме()
	
	Если ЭлементыФормы.Таблицы.ТекущаяСтрока <> Неопределено Тогда
		СтароеИмяТаблицыХранения = ЭлементыФормы.Таблицы.ТекущаяСтрока.ИмяТаблицыХранения;
	КонецЕсли; 
	Если ЭлементыФормы.Индексы.ТекущаяСтрока <> Неопределено Тогда
		СтароеИмяИндексаХранения = ЭлементыФормы.Индексы.ТекущаяСтрока.ИмяИндексаХранения;
	КонецЕсли; 
	Если ЭлементыФормы.Поля.ТекущаяСтрока <> Неопределено Тогда
		СтароеИмяПоляХранения = ЭлементыФормы.Поля.ТекущаяСтрока.ИмяПоляХранения;
	КонецЕсли; 
	ОбновитьТаблицы();
	ОбновитьДоступность();
	Если ЭлементыФормы.Таблицы.ТекущаяСтрока = Неопределено Тогда
		Если СтароеИмяТаблицыХранения <> Неопределено Тогда
			НоваяТекущаяСтрока = Таблицы.Найти(СтароеИмяТаблицыХранения, "ИмяТаблицыХранения");
			Если НоваяТекущаяСтрока <> Неопределено Тогда
				ЭлементыФормы.Таблицы.ТекущаяСтрока = НоваяТекущаяСтрока;
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 
	Если ЭлементыФормы.Индексы.ТекущаяСтрока = Неопределено Тогда
		Если СтароеИмяИндексаХранения <> Неопределено Тогда
			НоваяТекущаяСтрока = Индексы.Найти(СтароеИмяИндексаХранения, "ИмяИндексаХранения");
			Если НоваяТекущаяСтрока <> Неопределено Тогда
				ЭлементыФормы.Индексы.ТекущаяСтрока = НоваяТекущаяСтрока;
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 
	Если ЭлементыФормы.Поля.ТекущаяСтрока = Неопределено Тогда
		Если СтароеИмяПоляХранения <> Неопределено Тогда
			НоваяТекущаяСтрока = Поля.Найти(СтароеИмяПоляХранения, "ИмяПоляХранения");
			Если НоваяТекущаяСтрока <> Неопределено Тогда
				ЭлементыФормы.Поля.ТекущаяСтрока = НоваяТекущаяСтрока;
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбновитьДоступность()
	
	РезультирующееПоказыватьРазмеры = ПоказыватьРазмеры И ПоказыватьСУБД;
	РезультирующееПоказыватьУдаленные = ПоказыватьУдаленные И ирКэш.ЭтоФайловаяБазаЛкс();
	ЭлементыФормы.Таблицы.Колонки.КоличествоСтрок.Видимость = РезультирующееПоказыватьРазмеры;
	ЭлементыФормы.Таблицы.Колонки.РазмерБлоб.Видимость = РезультирующееПоказыватьРазмеры И ирКэш.ЭтоФайловаяБазаЛкс();
	ЭлементыФормы.Таблицы.Колонки.РазмерЗаписи.Видимость = РезультирующееПоказыватьРазмеры;
	ЭлементыФормы.Таблицы.Колонки.РазмерИндексы.Видимость = РезультирующееПоказыватьРазмеры;
	ЭлементыФормы.Таблицы.Колонки.РазмерОбщий.Видимость = РезультирующееПоказыватьРазмеры;
	ЭлементыФормы.Таблицы.Колонки.РазмерУдаленБлоб.Видимость = РезультирующееПоказыватьУдаленные;
	ЭлементыФормы.Таблицы.Колонки.РазмерУдаленЗаписи.Видимость = РезультирующееПоказыватьУдаленные;
	ЭлементыФормы.Таблицы.Колонки.РазмерУдаленОбщий.Видимость = РезультирующееПоказыватьУдаленные;
	ЭлементыФормы.Индексы.Колонки.РазмерИндексы.Видимость = РезультирующееПоказыватьРазмеры И Не ирКэш.ЭтоФайловаяБазаЛкс();
	ЭлементыФормы.Индексы.Колонки.РазмерОбщий.Видимость = РезультирующееПоказыватьРазмеры И Не ирКэш.ЭтоФайловаяБазаЛкс();
	ЭлементыФормы.Индексы.Колонки.ТипИндекса.Видимость = РезультирующееПоказыватьРазмеры И Не ирКэш.ЭтоФайловаяБазаЛкс();
	ЭлементыФормы.Панель1.Страницы.Индексы.Доступность = ОбщаяТаблицаИндексов;
	ЭлементыФормы.Панель1.Страницы.Поля.Доступность = ОбщаяТаблицаПолей;
	ЭлементыФормы.ПоказыватьРазмеры.Доступность = ПоказыватьСУБД;

КонецПроцедуры

Процедура ПоказыватьСУБДПриИзменении(Элемент)

	ОбновитьТаблицыВФорме();
	
КонецПроцедуры

Процедура ТаблицыПриАктивизацииСтроки(Элемент = Неопределено)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	НаборыПолей.Очистить();
	ПоляНабора.Очистить();
	СтрокаГлавнойТаблицы = ЭлементыФормы.Таблицы.ТекущаяСтрока;
	Если СтрокаГлавнойТаблицы = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	Если СтрокаГлавнойТаблицы.СУБД Тогда
		СтруктураХранения = мСтруктураХраненияСУБД;
	Иначе
		СтруктураХранения = мСтруктураХраненияSDBL;
	КонецЕсли; 
	СтрокаСтруктуры = СтруктураХранения.Найти(СтрокаГлавнойТаблицы.ИмяТаблицыХранения, "ИмяТаблицыХранения");
	Если СтрокаСтруктуры <> Неопределено Тогда
		Для Каждого СтрокаИндексов Из СтрокаСтруктуры.Индексы Цикл
			СтрокаНабораПолей = НаборыПолей.Добавить();
			СтрокаНабораПолей.ИмяНабораМета = ирОбщий.ПолучитьПредставлениеИндексаХраненияЛкс(СтрокаИндексов, СтрокаГлавнойТаблицы.СУБД, СтрокаСтруктуры);
			СтрокаНабораПолей.ИмяНабораБД = ирОбщий.ПолучитьПредставлениеИндексаХраненияЛкс(СтрокаИндексов, СтрокаГлавнойТаблицы.СУБД, СтрокаСтруктуры, Истина);
			СтрокаНабораПолей.ИмяХранения = СтрокаИндексов.ИмяИндексаХранения;
			СтрокаНабораПолей.Поля = СтрокаИндексов.Поля.Количество();
		КонецЦикла;
		НаборыПолей.Сортировать("ИмяНабораМета");
		СтрокаНабораПолей = НаборыПолей.Вставить(0);
		СтрокаНабораПолей.ИмяНабораМета = "<Основной>";
		СтрокаНабораПолей.ИмяНабораБД = "<Основной>";
		СтрокаНабораПолей.ИмяХранения = СтрокаСтруктуры.ИмяТаблицыХранения;
		СтрокаНабораПолей.Поля = СтрокаСтруктуры.Поля.Количество();
		ЭлементыФормы.НаборыПолей.ТекущаяСтрока = СтрокаНабораПолей;
	КонецЕсли; 
	
КонецПроцедуры

Процедура НаборыПолейПриАктивизацииСтроки(Элемент)
	
	ПоляНабора.Очистить();
	СтрокаТаблиц = ГлавноеТабличноеПоле().ТекущаяСтрока;
	Если СтрокаТаблиц = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	СтрокаНабора = ЭлементыФормы.НаборыПолей.ТекущаяСтрока;
	Если СтрокаНабора = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	Если СтрокаТаблиц.СУБД Тогда
		СтруктураХранения = мСтруктураХраненияСУБД;
	Иначе
		СтруктураХранения = мСтруктураХраненияSDBL;
	КонецЕсли; 
	СтрокаСтруктуры = СтруктураХранения.Найти(СтрокаТаблиц.ИмяТаблицыХранения, "ИмяТаблицыХранения");
	Если СтрокаНабора.ИмяНабораМета = "<Основной>" Тогда
		НаборПолей = СтрокаСтруктуры.Поля;
	Иначе
		НаборПолей = СтрокаСтруктуры.Индексы.Найти(СтрокаНабора.ИмяХранения, "ИмяИндексаХранения").Поля;
	КонецЕсли; 
	ЭтоТабличнаяЧасть = Ложь; //!!!!!!!!!!!!
	ирОбщий.ПеревестиКолонкиСтруктурыХраненияБДПоляЛкс(НаборПолей);
	Для Каждого СтрокаПоля Из НаборПолей Цикл
		СтрокаНабораПолей = ПоляНабора.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаНабораПолей, СтрокаПоля); 
		СтрокаНабораПолей.ИмяПоля = ирОбщий.ПолучитьПредставлениеПоляБДЛкс(СтрокаПоля, СтрокаТаблиц.СУБД, ЭтоТабличнаяЧасть);
	КонецЦикла;
	Если СтрокаНабора.ИмяНабораМета = "<Основной>" Тогда
		ПоляНабора.Сортировать("ИмяПоля");
	КонецЕсли; 
	
КонецПроцедуры

Функция ГлавноеТабличноеПоле()
	
	Если ЭлементыФормы.Панель1.ТекущаяСтраница = ЭлементыФормы.Панель1.Страницы.Индексы Тогда
		Результат = ЭлементыФормы.Индексы;
	ИначеЕсли ЭлементыФормы.Панель1.ТекущаяСтраница = ЭлементыФормы.Панель1.Страницы.Поля Тогда
		Результат = ЭлементыФормы.Поля;
	Иначе
		Результат = ЭлементыФормы.Таблицы;
	КонецЕсли; 
	Возврат Результат;
	
КонецФункции

Процедура КоманднаяПанельНайденныеОбъектыМенеджерТабличногоПоля(Кнопка)
	
	ирОбщий.ОткрытьМенеджерТабличногоПоляЛкс(ГлавноеТабличноеПоле(), ЭтаФорма);
	
КонецПроцедуры

Процедура КоманднаяПанельНайденныеОбъектыОтборБезЗначенияВТекущейКолонке(Кнопка)
	
	ирОбщий.ТабличноеПолеОтборБезЗначенияВТекущейКолонке_КнопкаЛкс(ГлавноеТабличноеПоле());
	
КонецПроцедуры

Процедура КоманднаяПанельНайденныеОбъектыОтобратьПоМетаданным(Кнопка)
	
	ирОбщий.ИзменитьОтборКлиентаПоМетаданнымЛкс(ГлавноеТабличноеПоле(),, Истина);

КонецПроцедуры

Процедура КоманднаяПанельНайденныеОбъектыРазличныеЗначенияКолонки(Кнопка)
	
	ирОбщий.ОткрытьРазличныеЗначенияКолонкиЛкс(ГлавноеТабличноеПоле());
	
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ИндексыПриАктивизацииСтроки(Элемент = Неопределено)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	НаборыПолей.Очистить();
	ПоляНабора.Очистить();
	СтрокаГлавнойТаблицы = ЭлементыФормы.Индексы.ТекущаяСтрока;
	Если СтрокаГлавнойТаблицы = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	Если СтрокаГлавнойТаблицы.СУБД Тогда
		СтруктураХранения = мСтруктураХраненияСУБД;
	Иначе
		СтруктураХранения = мСтруктураХраненияSDBL;
	КонецЕсли; 
	СтрокаСтруктуры = СтруктураХранения.Найти(СтрокаГлавнойТаблицы.ИмяТаблицыХранения, "ИмяТаблицыХранения");
	Если СтрокаСтруктуры <> Неопределено Тогда
		СтрокаСтруктурыИндекса = СтрокаСтруктуры.Индексы.Найти(СтрокаГлавнойТаблицы.ИмяИндексаХранения, "ИмяИндексаХранения");
		Если СтрокаСтруктурыИндекса <> Неопределено Тогда
			СтрокаНабораПолей = НаборыПолей.Добавить();
			СтрокаНабораПолей.ИмяНабораМета = ирОбщий.ПолучитьПредставлениеИндексаХраненияЛкс(СтрокаСтруктурыИндекса, СтрокаГлавнойТаблицы.СУБД, СтрокаСтруктуры);
			СтрокаНабораПолей.ИмяНабораБД = ирОбщий.ПолучитьПредставлениеИндексаХраненияЛкс(СтрокаСтруктурыИндекса, СтрокаГлавнойТаблицы.СУБД, СтрокаСтруктуры, Истина);
			СтрокаНабораПолей.ИмяХранения = СтрокаСтруктурыИндекса.ИмяИндексаХранения;
			СтрокаНабораПолей.Поля = СтрокаСтруктурыИндекса.Поля.Количество();
			ЭлементыФормы.НаборыПолей.ТекущаяСтрока = СтрокаНабораПолей;
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	ирОбщий.ОбновитьЗаголовкиСтраницПанелейЛкс(ЭтаФорма);

КонецПроцедуры

Процедура Панель1ПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	ЭтоОбщиеПоля = ЭлементыФормы.Панель1.ТекущаяСтраница = ЭлементыФормы.Панель1.Страницы.Поля;
	Если ЭтоОбщиеПоля Тогда
		НаборыПолей.Очистить();
		ПоляНабора.Очистить();
	Иначе
		ЭтоОбщиеИндексы = ЭлементыФормы.Панель1.ТекущаяСтраница = ЭлементыФормы.Панель1.Страницы.Индексы;
		Если ЭтоОбщиеИндексы Тогда
			ИндексыПриАктивизацииСтроки();
		Иначе
			ТаблицыПриАктивизацииСтроки();
		КонецЕсли;
		ЭлементыФормы.КонтекстноеМенюНаборыПолей.Кнопки.ПоказатьИндексВОбщейТаблицеИндексов.Доступность = Не ЭтоОбщиеИндексы;
	КонецЕсли; 
	ЭлементыФормы.КПТаблица.ИсточникДействий = ГлавноеТабличноеПоле();
	
КонецПроцедуры

Процедура ОбщаяТаблицаИндексовПриИзменении(Элемент)
	
	ОбновитьТаблицыВФорме();
	
КонецПроцедуры

Процедура ГлавнаяКоманднаяПанельНовоеОкно(Кнопка)
	
	ирОбщий.ОткрытьНовоеОкноОбработкиЛкс(ЭтотОбъект);

КонецПроцедуры

Процедура ГлавнаяКоманднаяПанельОПодсистеме(Кнопка)
	
	ирОбщий.ОткрытьСправкуПоПодсистемеЛкс(ЭтотОбъект);
	
КонецПроцедуры

Процедура ТаблицыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
	ТипТаблицы = ирОбщий.ТипТаблицыБДЛкс(ДанныеСтроки.ИмяТаблицы);
	КорневойТип = ирОбщий.ПервыйФрагментЛкс(ДанныеСтроки.ИмяТаблицы);
	КартинкаТипаТаблицы = ирОбщий.ПолучитьКартинкуКорневогоТипаЛкс(ТипТаблицы);
	КартинкаКорневогоТипа = ирОбщий.ПолучитьКартинкуКорневогоТипаЛкс(КорневойТип);
	ОформлениеСтроки.Ячейки.ИмяТаблицы.УстановитьКартинку(КартинкаКорневогоТипа);
	Если ТипТаблицы <> КорневойТип Тогда
		ОформлениеСтроки.Ячейки.Назначение.УстановитьКартинку(КартинкаТипаТаблицы);
	КонецЕсли; 
	Если Истина
		И Элемент = ЭлементыФормы.Таблицы
		И ДанныеСтроки.КоличествоСтрок = Неопределено 
	Тогда
		ОформлениеСтроки.Ячейки.КоличествоСтрок.УстановитьТекст("?");
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПоказыватьРазмерыПриИзменении(Элемент)
	
	ОбновитьДоступность();
	ОбновитьТаблицыВФорме();
	
КонецПроцедуры

Процедура КонтекстноеМенюТаблицыПоказатьИндексыВОбщейТаблицеИндексов(Кнопка)
	
	Если ОбщаяТаблицаИндексов И ЭлементыФормы.Таблицы.ТекущаяСтрока <> Неопределено Тогда
		НоваяТекущаяСтрока = Индексы.Найти(ЭлементыФормы.Таблицы.ТекущаяСтрока.ИмяТаблицыХранения, "ИмяТаблицыХранения");
		ЭлементыФормы.Индексы.ТекущаяСтрока = НоваяТекущаяСтрока;
		ЭлементыФормы.Панель1.ТекущаяСтраница = ЭлементыФормы.Панель1.Страницы.Индексы;
	КонецЕсли; 
	
КонецПроцедуры

Процедура КонтекстноеМенюТаблицыПоказатьПоляВОбщейТаблицеПолей(Кнопка)
	
	Если ОбщаяТаблицаПолей И ЭлементыФормы.Таблицы.ТекущаяСтрока <> Неопределено Тогда
		НоваяТекущаяСтрока = Поля.Найти(ЭлементыФормы.Таблицы.ТекущаяСтрока.ИмяТаблицыХранения, "ИмяТаблицыХранения");
		ЭлементыФормы.Поля.ТекущаяСтрока = НоваяТекущаяСтрока;
		ЭлементыФормы.Панель1.ТекущаяСтраница = ЭлементыФормы.Панель1.Страницы.Поля;
	КонецЕсли; 
	
КонецПроцедуры

Процедура КонтекстноеМенюТаблицыПоказатьИндексВОбщейТаблицеИндексов(Кнопка)
	
	Если Истина
		И ОбщаяТаблицаИндексов 
		И ЭлементыФормы.НаборыПолей.ТекущаяСтрока <> Неопределено 
		И ЭлементыФормы.НаборыПолей.ТекущаяСтрока.ИмяНабораМета <> "<Основной>" 
	Тогда
		КлючПоиска = Новый Структура;
		КлючПоиска.Вставить("ИмяТаблицыХранения", ЭлементыФормы.Таблицы.ТекущаяСтрока.ИмяТаблицыХранения);
		КлючПоиска.Вставить("ИмяИндексаХранения", ЭлементыФормы.НаборыПолей.ТекущаяСтрока.ИмяХранения);
		НоваяТекущаяСтрока = Индексы.НайтиСтроки(КлючПоиска)[0];
		ЭлементыФормы.Индексы.ТекущаяСтрока = НоваяТекущаяСтрока;
		ЭлементыФормы.Панель1.ТекущаяСтраница = ЭлементыФормы.Панель1.Страницы.Индексы;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ГлавнаяКоманднаяПанельСтруктураФормы(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруФормыЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ТаблицыВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если РежимВыбора Тогда
		Закрыть(ВыбраннаяСтрока.ИмяТаблицыХранения);
	КонецЕсли; 
	Если Колонка = ЭлементыФормы.Таблицы.Колонки.Метаданные Или Колонка = ЭлементыФормы.Таблицы.Колонки.ИмяТаблицы Тогда
		ирОбщий.ОткрытьОбъектМетаданныхЛкс(Метаданные.НайтиПоПолномуИмени(ВыбраннаяСтрока.Метаданные));
	КонецЕсли; 
	
КонецПроцедуры

Процедура КонтекстноеМенюТаблицыОткрытьФормуСписка(Кнопка)
	
	ТекущаяСтрока = ЭлементыФормы.Таблицы.ТекущаяСтрока;
	Если ТекущаяСтрока <> Неопределено И ТекущаяСтрока.Назначение = "Основная" Тогда
		ирОбщий.ОткрытьФормуСпискаЛкс(ТекущаяСтрока.ИмяТаблицы,, Неопределено);
	КонецЕсли; 
	
КонецПроцедуры

Процедура КоманднаяПанельНайденныеОбъектыОбновить(Кнопка)
	
	ОбновитьТаблицыВФорме();
	
КонецПроцедуры

Процедура АутентификацияСервераПриИзменении(Элемент)
	
	ОбновитьДоступность();
	
КонецПроцедуры

Процедура КоманднаяПанельНайденныеОбъектыСравнить(Кнопка)
	
	ирОбщий.СравнитьСодержимоеЭлементаУправленияЛкс(ЭтаФорма, ГлавноеТабличноеПоле());
	
КонецПроцедуры

Процедура ФильтрИмяМетаданныхПриИзменении(Элемент)
	
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
	ОбновитьОтбор();
	
КонецПроцедуры

Процедура ФильтрИмяМетаданныхНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, ЭтаФорма);
	
КонецПроцедуры

Процедура ФильтрИмяХраненияПриИзменении(Элемент)
	
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
	ОбновитьОтбор();
	
КонецПроцедуры

Процедура ГлавнаяКоманднаяПанельОчисткаТаблицСУБД(Кнопка)
	
	ВыбранныеМетаданные = Новый Массив;
	Для Каждого ВыделеннаяСтрока Из ЭлементыФормы.Таблицы.ВыделенныеСтроки Цикл
		ВыбранныеМетаданные.Добавить(ВыделеннаяСтрока.Метаданные);
	КонецЦикла;
	ФормаВыбора = мПлатформа.ПолучитьФорму("ВыборОбъектаМетаданных", ВладелецФормы, КлючУникальности);
	лСтруктураПараметров = Новый Структура;
	лСтруктураПараметров.Вставить("ОтображатьКонстанты", Истина);
	лСтруктураПараметров.Вставить("ОтображатьВыборочныеТаблицы", Истина);
	лСтруктураПараметров.Вставить("ОтображатьРегистры", Истина);
	лСтруктураПараметров.Вставить("ОтображатьПоследовательности", Истина);
	лСтруктураПараметров.Вставить("ОтображатьСсылочныеОбъекты", Истина);
	лСтруктураПараметров.Вставить("НеОтображатьПланыОбмена", Истина);
	лСтруктураПараметров.Вставить("ОтображатьРегламентныеЗадания", Истина);
	лСтруктураПараметров.Вставить("МножественныйВыбор", Истина);
	лСтруктураПараметров.Вставить("НачальноеЗначениеВыбора", ВыбранныеМетаданные);
	ФормаВыбора.НачальноеЗначениеВыбора = лСтруктураПараметров;
	РезультатВыбора = ФормаВыбора.ОткрытьМодально();
	Если РезультатВыбора = Неопределено Или РезультатВыбора.Количество() = 0 Тогда
		Возврат;
	КонецЕсли; 
	ТекстЗапроса = СформироватьТекстЗапросаСУБДОчисткиТаблиц(РезультатВыбора);
	ФормаТекста = ирОбщий.ПолучитьФормуТекстаЛкс(ТекстЗапроса, "Текст запроса очистки выбранных таблиц", "Обычный");
	ТекстЗапроса = ФормаТекста.ОткрытьМодально();
	Если ТекстЗапроса <> Неопределено Тогда
		Если Не ирОбщий.ПроверитьСоединениеADOЭтойБДЛкс() Тогда
			Возврат;
		КонецЕсли; 
		СоединениеADO = ирОбщий.ПолучитьСоединениеСУБД();
		//Если СоединениеADO = Неопределено Тогда
		//	Возврат;
		//КонецЕсли; 
		Если Не ирОбщий.ПодтверждениеОперацииСУБДЛкс() Тогда
			Возврат;
		КонецЕсли;
		РезультатЗапроса = Новый COMОбъект("ADODB.Recordset");
		adOpenStatic = 3;
		adLockOptimistic = 3;
		adCmdText = 1;
		РезультатЗапроса.Open(ТекстЗапроса, СоединениеADO, adOpenStatic, adLockOptimistic, adCmdText);
		Если СоединениеADO.Properties("Multiple Results").Value <> 0 Тогда
			Сообщить("Запрос очистки выбранных таблиц БД выполнен успешно.");
			Если ПоказыватьРазмеры Тогда
				ОбновитьТаблицыВФорме();
			КонецЕсли; 
		КонецЕсли; 
		//ирОбщий.ОткрытьЗапросСУБДЛкс(ТекстЗапроса, "Очистка таблиц");
	КонецЕсли; 
	
КонецПроцедуры

Функция СформироватьТекстЗапросаСУБДОчисткиТаблиц(МассивМетаданных)
	
	НуженПеревод = Неопределено;
	ТекстЗапроса = "";
	Для Каждого ПолноеИмяМД Из МассивМетаданных Цикл 
		ОбъектыМД = Новый Массив;
		ОбъектыМД.Добавить(ПолноеИмяМД);
		СтрокиТаблиц = ПолучитьСтруктуруХраненияБазыДанных(ОбъектыМД, Истина);
		ирОбщий.ПеревестиКолонкиСтруктурыХраненияБДТаблицыЛкс(СтрокиТаблиц, НуженПеревод);
		Для Каждого СтрокаТаблицы Из СтрокиТаблиц Цикл
			//Если СтрокаТаблицы.Назначение = "ИнициализированныеПредопределенныеДанныеСправочника" Тогда 
			//	Продолжить;
			//КонецЕсли; 
			//Если Истина
			//	И СтрокаТаблицы.Назначение = "Основная" 
			//	И ирОбщий.ЛиКорневойТипОбъектаСПредопределеннымЛкс(ирОбщий.ПервыйФрагментЛкс(ПолноеИмяМД)) 
			//Тогда
			//	ТекстЗапроса = ТекстЗапроса + "delete from " + СтрокаТаблицы.ИмяТаблицыХранения + " where _IsMetaData <> 1";
			//Иначе 	
				ТекстЗапроса = ТекстЗапроса + "truncate table " + СтрокаТаблицы.ИмяТаблицыХранения;
			//КонецЕсли;
			//ТекстЗапроса = ТекстЗапроса + " --" + СтрокаТаблицы.ИмяТаблицы + Символы.ПС; // https://partners.v8.1c.ru/forum/t/1485806/m/1485806
			ТекстЗапроса = ТекстЗапроса + " --" + СтрокаТаблицы.Метаданные + "." + СтрокаТаблицы.Назначение + Символы.ПС;
		КонецЦикла;
	КонецЦикла;	
	//Если ДобавитьКонструкциюSHRINKDATABASE Тогда
	//	ТекстЗапроса = ТекстЗапроса + Символы.ПС + "DBCC SHRINKDATABASE (" + ИмяБД + ", 10)";
	//КонецЕсли;
	Возврат ТекстЗапроса;
	
КонецФункции

Процедура ПриЗакрытии()
	
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);

КонецПроцедуры

Процедура ГлавнаяКоманднаяПанельПараметрыСУБД(Кнопка)
	
	ирОбщий.ОткрытьФормуСоединенияСУБДЛкс();
	
КонецПроцедуры

Процедура ОбновитьОтбор()
	
	ирОбщий.УстановитьОтборПоПодстрокеЛкс(ЭлементыФормы.Таблицы.ОтборСтрок.ИмяТаблицы, ФильтрИмяМетаданных);
	ирОбщий.УстановитьОтборПоПодстрокеЛкс(ЭлементыФормы.Индексы.ОтборСтрок.ИмяИндекса, ФильтрИмяМетаданных);
	ирОбщий.УстановитьОтборПоПодстрокеЛкс(ЭлементыФормы.Поля.ОтборСтрок.ИмяПоля, ФильтрИмяМетаданных);
	ирОбщий.УстановитьОтборПоПодстрокеЛкс(ЭлементыФормы.Таблицы.ОтборСтрок.ИмяТаблицыХранения, ФильтрИмяХранения);
	ирОбщий.УстановитьОтборПоПодстрокеЛкс(ЭлементыФормы.Индексы.ОтборСтрок.ИмяИндексаХранения, ФильтрИмяХранения);
	ирОбщий.УстановитьОтборПоПодстрокеЛкс(ЭлементыФормы.Поля.ОтборСтрок.ИмяПоляХранения, ФильтрИмяХранения);

КонецПроцедуры

Процедура ПриПовторномОткрытии(СтандартнаяОбработка)
	
	ОбработатьПараметрыОткрытия();
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ирОбщий.ФормаОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

Процедура КПТаблицаВывестиСтроки(Кнопка)
	
	ирОбщий.ВывестиСтрокиТабличногоПоляИПоказатьЛкс(ГлавноеТабличноеПоле());
	
КонецПроцедуры

Процедура КонтекстноеМенюТаблицыОткрытьОбъектМетаданных(Кнопка)
	
	ТекущаяСтрока = ЭлементыФормы.Таблицы.ТекущаяСтрока;
	Если ТекущаяСтрока <> Неопределено  Тогда
		ирОбщий.ОткрытьОбъектМетаданныхЛкс(ТекущаяСтрока.Метаданные);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОписаниеВнутреннихТаблицБДEI(Кнопка)
	ЗапуститьПриложение("http://main.1c-ei.ru/Home/help/objectdb/dbschema");
КонецПроцедуры

Процедура ОписаниеВнутреннихТаблицБДИТС(Кнопка)
	ЗапуститьПриложение("https://its.1c.ru/db/metod8dev#content:1798:hdoc");
КонецПроцедуры

Процедура ГлавнаяКоманднаяПанельКонверторТекстаБД(Кнопка)
	
	Форма = ирОбщий.ПолучитьФормуЛкс("Обработка.ирАнализТехножурнала.Форма.КонверторТекстаСУБД");
	Форма.Открыть();

КонецПроцедуры

Процедура ОбщаяТаблицаПолейПриИзменении(Элемент)
	
	ОбновитьТаблицыВФорме();
	
КонецПроцедуры

Процедура ПоляВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если Колонка = ЭлементыФормы.Поля.Колонки.ИмяТаблицы Или Колонка = ЭлементыФормы.Поля.Колонки.ИмяТаблицыХранения Тогда
		ПоказатьТаблицуХранения(ВыбраннаяСтрока.ИмяТаблицыХранения);
		ЭлементыФормы.НаборыПолей.ТекущаяСтрока = НаборыПолей[0];
		СтрокаПоля = ПоляНабора.Найти(ВыбраннаяСтрока.ИмяПоляХранения, "ИмяПоляХранения");
		Если СтрокаПоля <> Неопределено Тогда
			ЭлементыФормы.ПоляНабора.ТекущаяСтрока = СтрокаПоля;
		КонецЕсли; 
	ИначеЕсли Колонка = ЭлементыФормы.Поля.Колонки.Метаданные Тогда
		ирОбщий.ИсследоватьЛкс(Метаданные.НайтиПоПолномуИмени(ВыбраннаяСтрока.Метаданные));
	КонецЕсли; 
	
КонецПроцедуры

Процедура ИндексыВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если Колонка = ЭлементыФормы.Индексы.Колонки.ИмяТаблицы Или Колонка = ЭлементыФормы.Индексы.Колонки.ИмяТаблицыХранения Тогда
		ПоказатьТаблицуХранения(ВыбраннаяСтрока.ИмяТаблицыХранения);
		СтрокаНабора = НаборыПолей.Найти(ВыбраннаяСтрока.ИмяИндексаХранения, "ИмяХранения");
		Если СтрокаНабора <> Неопределено Тогда
			ЭлементыФормы.НаборыПолей.ТекущаяСтрока = СтрокаНабора;
		КонецЕсли; 
	КонецЕсли; 

КонецПроцедуры

Процедура ПоказатьТаблицуХранения(ИмяХранения)
	
	СтрокаТаблицы = Таблицы.Найти(ИмяХранения, "ИмяТаблицыХранения");
	Если СтрокаТаблицы = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ЭлементыФормы.Таблицы.ТекущаяСтрока = СтрокаТаблицы;
	ЭлементыФормы.Панель1.ТекущаяСтраница = ЭлементыФормы.Панель1.Страницы.Таблицы;
	
КонецПроцедуры 

Процедура КонтекстноеМенюПолеПоказатьПолеВОбщейТаблицеПолей(Кнопка)
	
	Если Истина
		И ОбщаяТаблицаПолей 
		И ЭлементыФормы.ПоляНабора.ТекущаяСтрока <> Неопределено 
	Тогда
		КлючПоиска = Новый Структура;
		КлючПоиска.Вставить("ИмяТаблицыХранения", ГлавноеТабличноеПоле().ТекущаяСтрока.ИмяТаблицыХранения);
		КлючПоиска.Вставить("ИмяПоляХранения", ЭлементыФормы.ПоляНабора.ТекущаяСтрока.ИмяПоляХранения);
		НоваяТекущаяСтрока = Поля.НайтиСтроки(КлючПоиска)[0];
		ЭлементыФормы.Поля.ТекущаяСтрока = НоваяТекущаяСтрока;
		ЭлементыФормы.Панель1.ТекущаяСтраница = ЭлементыФормы.Панель1.Страницы.Поля;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПоляНабораВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если Колонка = ЭлементыФормы.ПоляНабора.Колонки.Метаданные Тогда
		ирОбщий.ИсследоватьЛкс(Метаданные.НайтиПоПолномуИмени(ВыбраннаяСтрока.Метаданные));
	КонецЕсли; 
	
КонецПроцедуры

Процедура КонтекстноеМенюТаблицыОткрытьЗапросСУБД(Кнопка)
	
	Если ЭлементыФормы.Таблицы.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	Запрос = "SELECT TOP 100000 * FROM " + ЭлементыФормы.Таблицы.ТекущаяСтрока.ИмяТаблицыХранения;
	ирОбщий.ОткрытьЗапросСУБДЛкс(Запрос, "Итоги по периодам");
	
КонецПроцедуры

Процедура ПоляПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);

КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирСтруктураХраненияБД.Форма.Форма");
