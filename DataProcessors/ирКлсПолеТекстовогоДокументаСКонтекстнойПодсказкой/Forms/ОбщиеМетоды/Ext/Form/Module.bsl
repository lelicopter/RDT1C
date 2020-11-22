﻿Перем ОбщиеМетодыВсе;
Перем СхемаКомпоновки;
Перем СтарыйСнимокНастройкиКомпоновки;

Функция СохраняемаяНастройкаФормы(выхНаименование, выхИменаСвойств) Экспорт 
	выхИменаСвойств = "Форма.Фильтр, Форма.ВычислитьТипыСразу, Форма.ПрименятьФильтрКОписанию, Форма.ПрименятьФильтрКТелу, Форма.ОбновлятьСразу";
	Возврат Неопределено;
КонецФункции

Процедура ЗагрузитьНастройкуВФорме(НастройкаФормы, ДопПараметры) Экспорт 
	
	ирОбщий.ЗагрузитьНастройкуФормыЛкс(ЭтаФорма, НастройкаФормы); 
	
КонецПроцедуры

Процедура ОсновныеДействияФормыСохранитьНастройки(Кнопка)
	
	ирОбщий.ВыбратьИСохранитьНастройкуФормыЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ОсновныеДействияФормыЗагрузитьНастройки(Кнопка)
	
	ирОбщий.ВыбратьИЗагрузитьНастройкуФормыЛкс(ЭтаФорма);

КонецПроцедуры

Процедура ПриОткрытии()
	
	ирОбщий.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ирОбщий.СоздатьМенеджерСохраненияНастроекФормыЛкс(ЭтаФорма);
	ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(Компоновщик.Настройки.Порядок, "Имя");
	ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(Компоновщик.Настройки.Порядок, "Модуль");
	ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(Компоновщик.Настройки.Отбор, "ТипЗначения", "", ВидСравненияКомпоновкиДанных.НеРавно,,, Ложь).Представление = "Только функции";
	ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(Компоновщик.Настройки.Отбор, "Экспорт", Истина);
	ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(Компоновщик.Настройки.Отбор, "Глобальный", Истина,,,, Ложь);
	ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(Компоновщик.Настройки.Отбор, "КлиентУП", Истина,,,, Ложь );
	ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(Компоновщик.Настройки.Отбор, "Сервер", Истина,,,, Ложь);
	ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(Компоновщик.Настройки.Отбор, "ВнешнееСоединение", Истина,,,, Ложь );
	ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(Компоновщик.Настройки.Отбор, "КлиентОП", Истина,,,, Ложь);
	ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(Компоновщик.Настройки.Отбор, "ВызовСервера", Истина,,,, Ложь);
	ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(Компоновщик.Настройки.Отбор, "Привилегированный", Истина,,,, Ложь );
	ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(Компоновщик.Настройки.Отбор, "ОбщийМодуль", Истина,,,, Ложь );
	ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(Компоновщик.Настройки.Отбор, "ПовторноеИспользование", "", ВидСравненияКомпоновкиДанных.НеРавно,,, Ложь);
	ПерезаполнитьТаблицуВсехМетодов();

КонецПроцедуры

Процедура ПерезаполнитьТаблицуВсехМетодов()
	
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	ОбщиеМетодыВсе = ОбщиеМетоды.ВыгрузитьКолонки();
	ОбщиеМетодыВсе.Колонки.Добавить("ТаблицаСтруктурТипов");
	мПлатформа.ИнициализацияОписанияМетодовИСвойств();
	МетаТипы = ирКэш.ТипыМетаОбъектов(Истина, Ложь, Ложь);
	ИндикаторТиповМД = ирОбщий.ПолучитьИндикаторПроцессаЛкс(МетаТипы.Количество(), "МетаТипы");
	Для Каждого МетаТип Из МетаТипы Цикл
		ирОбщий.ОбработатьИндикаторЛкс(ИндикаторТиповМД);
		Если МетаТип.Множественное = "Перерасчеты" Тогда
			Продолжить;
		КонецЕсли; 
		ИндикаторОбъектовМД = ирОбщий.ПолучитьИндикаторПроцессаЛкс(Метаданные.ОбщиеМодули.Количество(), МетаТип.Множественное);
		Для Каждого ОбъектМД Из Метаданные[МетаТип.Множественное] Цикл
			ирОбщий.ОбработатьИндикаторЛкс(ИндикаторОбъектовМД);
			Если МетаТип.Единственное = "ОбщийМодуль" Тогда
				СтруктураТипа = мПлатформа.ПолучитьСтруктуруТипаИзЗначения(ирОбщий);
				СтруктураТипа.Метаданные = ОбъектМД;
			Иначе
				ИмяТипаМенеджера = ирОбщий.ИмяТипаИзПолногоИмениМДЛкс(ОбъектМД, "Менеджер");
				Попытка
					ТипМенеджера = Тип(ИмяТипаМенеджера);
				Исключение
					// у этого типа метаданных нет модуля менеджера
					Прервать;
				КонецПопытки; 
				СтруктураТипа = мПлатформа.ПолучитьСтруктуруТипаИзКонкретногоТипа(ТипМенеджера);
			КонецЕсли; 
			ДобавитьМетодыМодуля(СтруктураТипа, МетаТип);
		КонецЦикла;
		ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	КонецЦикла;
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	СхемаКомпоновки = ирОбщий.СоздатьСхемуПоТаблицамЗначенийЛкс(СтруктураТаблицКомпоновки());
	Компоновщик.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновки));
	ОбновитьДанные();

КонецПроцедуры

Процедура ДобавитьМетодыМодуля(Знач СтруктураТипа, СтрокаМетаТипа)
	
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	МодульМетаданных = мПлатформа.ПодготовитьМодульМетаданных(СтруктураТипа);
	Если МодульМетаданных = Неопределено Тогда
		// Пустой модуль не рождает файл
		Возврат;
	КонецЕсли;
	МетаМодуль = СтруктураТипа.Метаданные;
	МетодыМодуля = МодульМетаданных.Методы;
	#Если Сервер И Не Сервер Тогда
		МетодыМодуля = Новый ТаблицаЗначений;
	#КонецЕсли
	ИскательВозврата = Неопределено;
	Если ВычислитьТипыСразу Тогда
		ИндикаторМодуля = ирОбщий.ПолучитьИндикаторПроцессаЛкс(МетодыМодуля.Количество(), МетаМодуль.Имя + ". Вычисление типов");
	Иначе
		ИндикаторМодуля = Неопределено;
	КонецЕсли; 
	Для Каждого МетодМодуля Из МетодыМодуля Цикл
		Если ИндикаторМодуля <> Неопределено Тогда
			ирОбщий.ОбработатьИндикаторЛкс(ИндикаторМодуля);
		КонецЕсли; 
		СтрокаОбщейТаблицы = ОбщиеМетодыВсе.Добавить();
		#Если Сервер И Не Сервер Тогда
			СтрокаОбщейТаблицы = ОбщиеМетоды.Добавить();
		#КонецЕсли
		ЗаполнитьЗначенияСвойств(СтрокаОбщейТаблицы, МетодМодуля);
		СтрокаОбщейТаблицы.ОбщийМодуль = СтрокаМетаТипа.Единственное = "ОбщийМодуль";
		СтрокаОбщейТаблицы.Модуль = МетаМодуль.ПолноеИмя();
		СтрокаОбщейТаблицы.Экспорт = МетодМодуля.ЛиЭкспорт;
		Если СтрокаОбщейТаблицы.ОбщийМодуль Тогда
			#Если Сервер И Не Сервер Тогда
				МетаМодуль = Метаданные.ОбщиеМодули.ирОбщий;
			#КонецЕсли
			СтрокаОбщейТаблицы.КлиентУП = МетаМодуль.КлиентУправляемоеПриложение;
			СтрокаОбщейТаблицы.КлиентОП = МетаМодуль.КлиентОбычноеПриложение;
			СтрокаОбщейТаблицы.Сервер = МетаМодуль.Сервер;
			СтрокаОбщейТаблицы.ВызовСервера = МетаМодуль.ВызовСервера;
			СтрокаОбщейТаблицы.Глобальный = МетаМодуль.Глобальный;
			СтрокаОбщейТаблицы.Привилегированный = МетаМодуль.Привилегированный;
			СтрокаОбщейТаблицы.ПовторноеИспользование = ?(МетаМодуль.ПовторноеИспользованиеВозвращаемыхЗначений = Метаданные.СвойстваОбъектов.ПовторноеИспользованиеВозвращаемыхЗначений.НеИспользовать, "",
				МетаМодуль.ПовторноеИспользованиеВозвращаемыхЗначений);
			СтрокаОбщейТаблицы.ВнешнееСоединение = МетаМодуль.ВнешнееСоединение;
			СтрокаОбщейТаблицы.ПолноеИмя = МетаМодуль.Имя + "." + МетодМодуля.Имя;
		Иначе
			СтрокаОбщейТаблицы.КлиентУП = Истина;
			СтрокаОбщейТаблицы.КлиентОП = Истина;
			СтрокаОбщейТаблицы.Сервер = Истина;
			СтрокаОбщейТаблицы.ВнешнееСоединение = Истина;
			СтрокаОбщейТаблицы.ПовторноеИспользование = "";
			СтрокаОбщейТаблицы.ПолноеИмя = СтрокаМетаТипа.Множественное + "." + МетаМодуль.Имя + "." + МетодМодуля.Имя;
		КонецЕсли; 
		ОбновитьТипЗначения(МетодМодуля, МодульМетаданных, СтрокаОбщейТаблицы, ИскательВозврата);
	КонецЦикла;
	Если ИндикаторМодуля <> Неопределено Тогда
		ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	КонецЕсли;

КонецПроцедуры

Процедура ОбновитьТипЗначения(Знач МетодМодуля, Знач МодульМетаданных, Знач СтрокаОбщейТаблицы, Знач ВычислятьТипы = Неопределено, ИскательВозврата = Неопределено)
	
	#Если Сервер И Не Сервер Тогда
		СтрокаОбщейТаблицы = ОбщиеМетоды.Добавить();
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	Если ВычислятьТипы = Неопределено Тогда
		ВычислятьТипы = ЭтаФорма.ВычислитьТипыСразу;
	КонецЕсли; 
	Если ВычислятьТипы Тогда
		мПлатформа.ПодготовитьТипРезультатаМетода(МетодМодуля, МодульМетаданных, ИскательВозврата); 
	КонецЕсли; 
	ТаблицаСтруктурТипов = мПлатформа.НоваяТаблицаСтруктурТипа();
	Если МетодМодуля.ТаблицаСтруктурТипов <> Неопределено Тогда
		ТаблицаСтруктурТипов = МетодМодуля.ТаблицаСтруктурТипов.Скопировать();
		#Если Сервер И Не Сервер Тогда
			ТаблицаСтруктурТипов = Новый ТаблицаЗначений;
		#КонецЕсли
		ОбновитьТипЗначенияИзТаблицыСтруктурТипов(СтрокаОбщейТаблицы, ТаблицаСтруктурТипов, Ложь);
	Иначе
		СтруктураТипа = ТаблицаСтруктурТипов.Добавить();
		Если МетодМодуля.Тип = "Функция" Тогда
			СтруктураТипа.ИмяОбщегоТипа = "??";
			//СтрокаОбщейТаблицы.ТипЗначения = "??";
		КонецЕсли; 
	КонецЕсли; 
	ТаблицаСтруктурТипов.ЗаполнитьЗначения(МетодМодуля, "СтрокаОписания");
	СтрокаОбщейТаблицы.ТаблицаСтруктурТипов = ТаблицаСтруктурТипов;

КонецПроцедуры

Функция СтруктураТаблицКомпоновки()
	
	СтруктураТаблиц = Новый Структура("Таблица");
	СтруктураТаблиц.Таблица = ОбщиеМетодыВсе.Скопировать();
	СтруктураТаблиц.Таблица.Колонки.Удалить("ТаблицаСтруктурТипов");
	Возврат СтруктураТаблиц;

КонецФункции

Процедура ПриЗакрытии()
	
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ДействияФормыОПодсистеме(Кнопка)
	
	ирОбщий.ОткрытьСправкуПоПодсистемеЛкс(ЭтотОбъект);

КонецПроцедуры

Процедура ДействияФормыСтруктураФормы(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруФормыЛкс(ЭтаФорма);

КонецПроцедуры

Процедура ДействияФормыИсполняемаяКомпоновка(Кнопка)
	
	ОбновитьДанные(, Истина);
	
КонецПроцедуры

Процедура ОбновитьДанные(РедактируемыйФильтрПоПодстроке = Неопределено, РежимОтладки = Ложь)
	
	НастройкаКомпоновки = КонечнаяНастройкаКомпоновки(РедактируемыйФильтрПоПодстроке);
	ТекущаяСтрока = ЭлементыФормы.ОбщиеМетоды.ТекущаяСтрока;
	Если ТекущаяСтрока <> Неопределено Тогда
		СтарыйМетод = ТекущаяСтрока.ПолноеИмя;
	КонецЕсли; 
	СтруктураТаблиц = СтруктураТаблицКомпоновки();
	НоваяТаблица = ирОбщий.СкомпоноватьВКоллекциюЗначенийПоСхемеЛкс(СхемаКомпоновки, НастройкаКомпоновки,, СтруктураТаблиц,,,,, РежимОтладки,,,, Истина);
	Если РежимОтладки Тогда
		Возврат;
	КонецЕсли; 
	ОбщиеМетоды.Загрузить(НоваяТаблица);
	СтарыйСнимокНастройкиКомпоновки = ирОбщий.СохранитьОбъектВВидеСтрокиXMLЛкс(Компоновщик.Настройки);
	Если СтарыйМетод <> Неопределено Тогда
		НоваяТекущаяСтрока = ОбщиеМетоды.Найти(СтарыйМетод, "ПолноеИмя");
		Если НоваяТекущаяСтрока <> Неопределено Тогда
			ЭлементыФормы.ОбщиеМетоды.ТекущаяСтрока = НоваяТекущаяСтрока;
		КонецЕсли; 
	КонецЕсли; 
	ЭтаФорма.Количество = ОбщиеМетоды.Количество();

КонецПроцедуры

Функция КонечнаяНастройкаКомпоновки(Знач РедактируемыйФильтрПоПодстроке = Неопределено)
	
	Если РедактируемыйФильтрПоПодстроке = Неопределено Тогда
		РедактируемыйФильтрПоПодстроке = Фильтр;
	КонецЕсли; 
	Фрагменты = ирОбщий.СтрРазделитьЛкс(РедактируемыйФильтрПоПодстроке, " ", Истина, Ложь);
	НастройкаКомпоновки = Компоновщик.ПолучитьНастройки();
	Если Фрагменты.Количество() > 0 Тогда
		ГруппаИли = НастройкаКомпоновки.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаИли.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
		ГруппаИ = ГруппаИли.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаИ.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
		Для Каждого Фрагмент Из Фрагменты Цикл
			ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(ГруппаИ, "Имя", Фрагмент, ВидСравненияКомпоновкиДанных.Содержит,, Ложь);
		КонецЦикла;
		Если ПрименятьФильтрКОписанию Тогда
			ГруппаИ = ГруппаИли.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
			ГруппаИ.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
			Для Каждого Фрагмент Из Фрагменты Цикл
				ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(ГруппаИ, "Описание", Фрагмент, ВидСравненияКомпоновкиДанных.Содержит,, Ложь);
			КонецЦикла;
		КонецЕсли; 
		Если ПрименятьФильтрКТелу Тогда
			ГруппаИ = ГруппаИли.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
			ГруппаИ.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
			Для Каждого Фрагмент Из Фрагменты Цикл
				ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(ГруппаИ, "Тело", Фрагмент, ВидСравненияКомпоновкиДанных.Содержит,, Ложь);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли; 
	ЭлементыФормы.НадписьОтбор.Заголовок = ирОбщий.ПредставлениеОтбораЛкс(НастройкаКомпоновки.Отбор);
	Возврат НастройкаКомпоновки;

КонецФункции

Процедура ФильтрАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	
	ирОбщий.ПромежуточноеОбновлениеСтроковогоЗначенияПоляВводаЛкс(Элемент, Текст);
	ОбновитьДанные(Текст);
	
КонецПроцедуры

Процедура ДействияФормыПерейтиКОпределению(Кнопка)
	
	ТекущаяСтрока = ЭлементыФормы.ОбщиеМетоды.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	#Если Сервер И Не Сервер Тогда
		ТекущаяСтрока = ОбщиеМетоды.Добавить();
	#КонецЕсли
	ирОбщий.ПерейтиКОпределениюМетодаВКонфигуратореЛкс(ТекущаяСтрока.ПолноеИмя);
	
КонецПроцедуры

Процедура ФильтрПриИзменении(Элемент)
	
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
	ОбновитьДанные();
	
КонецПроцедуры

Процедура ФильтрНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, ЭтаФорма);
	
КонецПроцедуры

Процедура ПрименятьФильтрКТелуПриИзменении(Элемент)
	
	ОбновитьДанные();
	
КонецПроцедуры

Процедура ПрименятьФильтрКОписаниюПриИзменении(Элемент)
	
	ОбновитьДанные();

КонецПроцедуры

Процедура ВычислятьТипыПриИзменении(Элемент)
	ПерезаполнитьТаблицуВсехМетодов();
КонецПроцедуры

Процедура ТолькоФункцииПриИзменении(Элемент)
	ОбновитьДанные();
КонецПроцедуры

Процедура ОбщиеМетодыПриАктивизацииСтроки(Элемент)
	
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	ТекущаяСтрока = ЭлементыФормы.ОбщиеМетоды.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	СтрокаПолногоОписания = ОбщиеМетодыВсе.Найти(ТекущаяСтрока.ПолноеИмя, "ПолноеИмя");
	Если Найти(СтрокаПолногоОписания.ТипЗначения, "??") = 1 Тогда
		Если СтрокаПолногоОписания.ОбщийМодуль Тогда
			СтруктураТипа = мПлатформа.ПолучитьСтруктуруТипаИзЗначения(ирОбщий);
			СтруктураТипа.Метаданные = ирКэш.ОбъектМДПоПолномуИмениЛкс(СтрокаПолногоОписания.Модуль);
		Иначе
			СтруктураТипа = мПлатформа.ПолучитьСтруктуруТипаИзКонкретногоТипа(Тип(ирОбщий.ИмяТипаИзПолногоИмениМДЛкс(СтрокаПолногоОписания.Модуль, "Менеджер")));
		КонецЕсли; 
		МодульМетаданных = мПлатформа.ПодготовитьМодульМетаданных(СтруктураТипа);
		ОбновитьТипЗначения(СтрокаПолногоОписания.ТаблицаСтруктурТипов[0].СтрокаОписания, МодульМетаданных, СтрокаПолногоОписания, Истина);
		ЗаполнитьЗначенияСвойств(ТекущаяСтрока, СтрокаПолногоОписания); 
	КонецЕсли;
	#Если Сервер И Не Сервер Тогда
		ТекущаяСтрока = ОбщиеМетоды.Добавить();
	#КонецЕсли
	СтрокаПолногоОписания = ОбщиеМетодыВсе.Найти(ТекущаяСтрока.ПолноеИмя, "ПолноеИмя");
	СтруктураТипаКонтекста = СтрокаПолногоОписания.ТаблицаСтруктурТипов[0];
	ТаблицаВладелец = СтруктураТипаКонтекста.СтрокаОписания.Владелец();
	#Если Сервер И Не Сервер Тогда
		ТаблицаВладелец = Новый ТаблицаЗначений;
	#КонецЕсли
	ФормаВызовМетода = ПолучитьФорму("ВызовМетода", ЭтаФорма, "Прикрепленное");
	Если Не ФормаВызовМетода.Открыта() Тогда
		ФормаВызовМетода.СоединяемоеОкно = Истина;
		ФормаВызовМетода.КлючСохраненияПоложенияОкна = ФормаВызовМетода.КлючУникальности;
		ФормаВызовМетода.СостояниеОкна = ВариантСостоянияОкна.Прикрепленное;
		ФормаВызовМетода.ПоложениеПрикрепленногоОкна = ВариантПрикрепленияОкна.Низ;
	КонецЕсли; 
	ФормаВызовМетода.ПараметрСтруктураТипаКонтекста = СтруктураТипаКонтекста;
	Если ФормаВызовМетода.Открыта() Тогда
		ФормаВызовМетода.ОбновитьИлиЗакрытьФорму();
	Иначе
		ФормаВызовМетода.Открыть();
	КонецЕсли; 
	Активизировать();
	
КонецПроцедуры

Процедура ОбщиеМетодыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
	
КонецПроцедуры

Процедура ДействияФормыНастройка(Кнопка)
	
	ПолучитьФорму("ФормаНастройки", ФормаВладелец).Открыть();
	
КонецПроцедуры

Процедура ОбщиеМетодыВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ТекущаяСтрока = ЭлементыФормы.ОбщиеМетоды.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	СтрокаПолногоОписания = ОбщиеМетодыВсе.Найти(ТекущаяСтрока.ПолноеИмя, "ПолноеИмя");
	#Если Сервер И Не Сервер Тогда
		СтрокаПолногоОписания = ОбщиеМетоды.Добавить();
	#КонецЕсли
	Если Колонка = ЭлементыФормы.ОбщиеМетоды.Колонки.ТипЗначения Тогда
		ирОбщий.ОткрытьЗначениеЛкс(СтрокаПолногоОписания.ТаблицаСтруктурТипов,,, "Описания типов значений");
	ИначеЕсли Колонка = ЭлементыФормы.ОбщиеМетоды.Колонки.Описание Тогда
		ирОбщий.ОткрытьТекстЛкс(СтрокаПолногоОписания.Описание, "Описание метода " + СтрокаПолногоОписания.ПолноеИмя, "Обычный", Истина, СтрокаПолногоОписания.ПолноеИмя + ".Описание");
	Иначе
		ирОбщий.ОткрытьТекстЛкс(СтрокаПолногоОписания.Тело, "Тело метода " + СтрокаПолногоОписания.ПолноеИмя, "ВстроенныйЯзык", Истина, СтрокаПолногоОписания.ПолноеИмя + ".Тело");
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	КонечнаяНастройкаКомпоновки();
	Если ОбновлятьСразу Тогда
		Если СтарыйСнимокНастройкиКомпоновки <> ирОбщий.СохранитьОбъектВВидеСтрокиXMLЛкс(Компоновщик.Настройки) Тогда
			ОбновитьДанные();
		КонецЕсли; 
	КонецЕсли; 

КонецПроцедуры

Процедура ДействияФормыОбновить(Кнопка)
	
	ОбновитьДанные();
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирОбщий.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	ирОбщий.ФормаОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирКлсПолеТекстовогоДокументаСКонтекстнойПодсказкой.Форма.ОбщиеМетоды");
ОбновлятьСразу = Истина;
