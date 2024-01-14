﻿Перем мРежимОдинМодуль;
Перем МетодыМодуляВсе;
Перем СхемаКомпоновки;
Перем СтарыйСнимокНастройкиКомпоновки;

Функция СохраняемаяНастройкаФормы(выхНаименование, выхИменаСвойств) Экспорт 
	выхИменаСвойств = "Форма.МетодыМодулейСтрокаПоиска, Форма.ПрименятьФильтрКОписанию, Форма.ПрименятьФильтрКТелу, Форма.ОбновлятьСразу, Форма.ПрименятьФильтрКПараметрам";
	Возврат Неопределено;
КонецФункции

Процедура ЗагрузитьНастройкуВФорме(НастройкаФормы, ДопПараметры) Экспорт 
	
	ирКлиент.ЗагрузитьНастройкуФормыЛкс(ЭтаФорма, НастройкаФормы); 
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ирКлиент.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ирКлиент.СоздатьМенеджерСохраненияНастроекФормыЛкс(ЭтаФорма);
	мРежимОдинМодуль = КлючСохраненияПоложенияОкна = "ОдинМодуль";
	ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(Компоновщик.Настройки.Порядок, "Имя");
	ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(Компоновщик.Настройки.Порядок, "Модуль");
	ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(Компоновщик.Настройки.Отбор, "ТипЗначения", "", ВидСравненияКомпоновкиДанных.НеРавно,,, Ложь).Представление = "Только функции";
	ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(Компоновщик.Настройки.Отбор, "КоличествоПараметров", 0, ВидСравненияКомпоновкиДанных.Равно,,, Ложь).Представление = "Только без параметров";
	ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(Компоновщик.Настройки.Отбор, "Экспорт", Истина,,,, Не мРежимОдинМодуль);
	ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(Компоновщик.Настройки.Отбор, "Глобальный", Истина,,,, Ложь);
	ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(Компоновщик.Настройки.Отбор, "КлиентУП", Истина,,,, Ложь );
	ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(Компоновщик.Настройки.Отбор, "Сервер", Истина,,,, Ложь);
	ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(Компоновщик.Настройки.Отбор, "ВнешнееСоединение", Истина,,,, Ложь );
	ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(Компоновщик.Настройки.Отбор, "КлиентОП", Истина,,,, Ложь);
	ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(Компоновщик.Настройки.Отбор, "ВызовСервера", Истина,,,, Ложь);
	ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(Компоновщик.Настройки.Отбор, "Привилегированный", Истина,,,, Ложь );
	ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(Компоновщик.Настройки.Отбор, "ОбщийМодуль", Истина,,,, Ложь );
	ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(Компоновщик.Настройки.Отбор, "ПовторноеИспользование", "", ВидСравненияКомпоновкиДанных.НеРавно,,, Ложь);
	ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(Компоновщик.Настройки.Отбор, "ПараметрыСтрокой", "", ВидСравненияКомпоновкиДанных.Содержит,, Ложь, Ложь);
	ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(Компоновщик.Настройки.Отбор, "КоличествоПараметров", 10, ВидСравненияКомпоновкиДанных.Больше,, Ложь, Ложь);
	Если ЗначениеЗаполнено(ПараметрСтрокаПоиска) Тогда
		ЭтаФорма.МетодыМодулейСтрокаПоиска = ПараметрСтрокаПоиска;
	КонецЕсли;
	ЭлементыФормы.Расширения.ОтборСтрок.ИмяРасширяемогоМетода.Установить("$");
	Если мРежимОдинМодуль Тогда
		ЭтаФорма.ОбработкаОбъект = ирОбщий.НовыйАнализаторКодаЛкс();
		ЭтаФорма.Заголовок = "Методы: " + КлючУникальности;
		ЭлементыФормы.МетодыМодулей.Колонки.ПолноеИмя.Видимость = Ложь;
		ЭлементыФормы.МетодыМодулей.Колонки.ПолноеИмяВызова.Видимость = Ложь;
		ЭлементыФормы.МетодыМодулей.Колонки.Модуль.Видимость = Ложь;
	КонецЕсли;
	ПерезаполнитьТаблицуВсехМетодов();
	Если ПараметрИмяМетода <> Неопределено Тогда
		СтрокаМетода = МетодыМодулей.Найти(ПараметрИмяМетода, "Имя");
		Если СтрокаМетода <> Неопределено Тогда
			ЭлементыФормы.МетодыМодулей.ТекущаяСтрока = СтрокаМетода;
		КонецЕсли;
	КонецЕсли;
	ПоказыватьРасширения = ЭлементыФормы.ДействияФормы.Кнопки.СверткаРасширения.Пометка;
	ПодключитьОбработчикОжидания("ИзменитьСвернутостьПанельРасширенияОтложенно", 0.1, Истина);
	ЭтаФорма.ДатаОбновленияКэша = ирОбщий.ДатаОбновленияКэшаМодулейЛкс();

КонецПроцедуры

Процедура ИзменитьСвернутостьПанельРасширенияОтложенно()
	ИзменитьСвернутостьПанельРасширения(Ложь);
КонецПроцедуры

Процедура ПерезаполнитьТаблицуВсехМетодов(ТолькоГлобальные = Ложь) Экспорт 
	
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	МетодыМодуляВсе = МетодыМодулей.ВыгрузитьКолонки();
	МетодыМодуляВсе.Колонки.Добавить("ТаблицаТипов");
	МетодыМодуляВсе.Колонки.Добавить("ИмяМодуляМетаданных");
	мПлатформа.ИнициацияОписанияМетодовИСвойств();
	ФайлыРасширений = Новый Соответствие;
	Для Каждого КлючИЗначение Из ирКэш.РасширенияКонфигурацииЛкс() Цикл
		РасширениеКонфигурации = КлючИЗначение.Ключ;
		#Если Сервер И Не Сервер Тогда
			РасширениеКонфигурации = РасширенияКонфигурации.Создать();
		#КонецЕсли
		Для Каждого Файл Из НайтиФайлы(мПлатформа.ПапкаКэшаМодулей.ПолноеИмя + "\" + РасширениеКонфигурации.Имя, "*.txt") Цикл
			РасширенияМодуля = ФайлыРасширений[Файл.ИмяБезРасширения];
			Если РасширенияМодуля = Неопределено Тогда
				РасширенияМодуля = Новый СписокЗначений;
				ФайлыРасширений[Файл.ИмяБезРасширения] = РасширенияМодуля;
			КонецЕсли;
			РасширенияМодуля.Добавить(КлючИЗначение.Значение, РасширениеКонфигурации.Имя);
		КонецЦикла;
	КонецЦикла;
	Если мРежимОдинМодуль Тогда
		ДобавитьМетодыМодуля(ПараметрМодуль.СтруктураТипа,,, ФайлыРасширений);
	Иначе 
		МетаТипы = ирКэш.ТипыМетаОбъектов(Истина, Ложь, Ложь);   
		ИндикаторТиповМД = ирОбщий.ПолучитьИндикаторПроцессаЛкс(МетаТипы.Количество(), "МетаТипы");
		Для Каждого МетаТип Из МетаТипы Цикл
			ирОбщий.ОбработатьИндикаторЛкс(ИндикаторТиповМД);
			Если Ложь      
				Или МетаТип.Множественное = "Перерасчеты" 
				Или ТолькоГлобальные И МетаТип.Единственное <> "ОбщийМодуль"
			Тогда
				Продолжить;
			КонецЕсли; 
			ИндикаторОбъектовМД = ирОбщий.ПолучитьИндикаторПроцессаЛкс(Метаданные.ОбщиеМодули.Количество(), МетаТип.Множественное);
			Для Каждого ОбъектМД Из Метаданные[МетаТип.Множественное] Цикл
				ирОбщий.ОбработатьИндикаторЛкс(ИндикаторОбъектовМД);
				Если МетаТип.Единственное = "ОбщийМодуль" Тогда
					Если ТолькоГлобальные И Не ОбъектМД.Глобальный Тогда
						Продолжить;
					КонецЕсли; 
					СтруктураТипа = мПлатформа.НоваяСтруктураТипа();
					СтруктураТипа.ИмяОбщегоТипа = "ОбщийМодуль";
					СтруктураТипа.Метаданные = ОбъектМД;
				Иначе
					ИмяТипаМенеджера = ирОбщий.ИмяТипаИзПолногоИмениМДЛкс(ОбъектМД, "Менеджер");
					Попытка
						ТипМенеджера = Тип(ИмяТипаМенеджера);
					Исключение
						// у этого типа метаданных нет модуля менеджера
						Прервать;
					КонецПопытки; 
					СтруктураТипа = мПлатформа.СтруктураТипаИзКонкретногоТипа(ТипМенеджера);
				КонецЕсли; 
				ДобавитьМетодыМодуля(СтруктураТипа, МетаТип,, ФайлыРасширений);
			КонецЦикла;
			ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
		КонецЦикла;
		ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
		СтруктураТипа = мПлатформа.СтруктураТипаИзЗначения(Метаданные);
		ДобавитьМетодыМодуля(СтруктураТипа, Неопределено, "МодульОбычногоПриложения", ФайлыРасширений);
		ДобавитьМетодыМодуля(СтруктураТипа, Неопределено, "МодульУправляемогоПриложения", ФайлыРасширений);
		ДобавитьМетодыМодуля(СтруктураТипа, Неопределено, "МодульВнешнегоСоединения", ФайлыРасширений);
	КонецЕсли;
	СхемаКомпоновки = ирОбщий.СоздатьСхемуПоТаблицамЗначенийЛкс(СтруктураТаблицКомпоновки());
	#Если Сервер И Не Сервер Тогда
		СхемаКомпоновки = Новый СхемаКомпоновкиДанных;
	#КонецЕсли
	СписокЗначений = мПлатформа.ДоступныеЗначенияТипа("ПовторноеИспользованиеВозвращаемыхЗначений");
	СхемаКомпоновки.НаборыДанных[0].Поля.Найти("ПовторноеИспользование").УстановитьДоступныеЗначения(СписокЗначений);
	Компоновщик.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновки));
	ОбновитьДанные();

КонецПроцедуры

Процедура ДобавитьМетодыМодуля(Знач СтруктураТипа, Знач СтрокаМетаТипа = Неопределено, ТипМодуляКонфигурации = "", Знач ФайлыРасширений)
	
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли     
	ИмяМодуля = мПлатформа.ИмяФайлаМодуляБезРасширения(СтруктураТипа, ТипМодуляКонфигурации);
	РасширенияМодуля = ФайлыРасширений[ИмяМодуля];
	Если РасширенияМодуля = Неопределено Тогда
		РасширенияМодуля = Новый СписокЗначений;
	КонецЕсли;
	РасширенияМодуля.Добавить(Ложь, ""); // Модуль конфигурации должен быть строго последним
	РасширенияМетодов = Новый Структура;
	Для Каждого ЭлементСписка Из РасширенияМодуля Цикл
		ИмяРасширения = ?(ПустаяСтрока(ЭлементСписка.Представление), Неопределено, ЭлементСписка.Представление);
		АктивностьРасширения = ЭлементСписка.Значение;
		СтруктураТипа.ДержательМетаданных = ИмяРасширения;
		МодульМетаданных = мПлатформа.ПодготовитьМодульМетаданных(СтруктураТипа, ТипМодуляКонфигурации);
		Если МодульМетаданных = Неопределено Тогда
			// Пустой модуль не рождает файл
			Продолжить;
		КонецЕсли;
		МетаМодуль = СтруктураТипа.Метаданные;
		ТаблицаМетодов = МодульМетаданных.Методы; 
		Если ВычислитьТипыСразу Тогда
			ИндикаторМодуля = ирОбщий.ПолучитьИндикаторПроцессаЛкс(ТаблицаМетодов.Количество(), МетаМодуль.Имя + ". Вычисление типов");
		Иначе
			ИндикаторМодуля = Неопределено;
		КонецЕсли;
		БылиИзмененияКэшаМодуля = Ложь;
		Для Каждого МетодМодуля Из ТаблицаМетодов Цикл
			Если ИндикаторМодуля <> Неопределено Тогда
				ирОбщий.ОбработатьИндикаторЛкс(ИндикаторМодуля);
			КонецЕсли;
			Если МетодМодуля.Имя = "<>" Тогда
				Продолжить;
			КонецЕсли; 
			ПараметрыМетода = мПлатформа.ПараметрыМетодаМодуля(МетодМодуля, БылиИзмененияКэшаМодуля);
			СтрокаМетода = МетодыМодуляВсе.Добавить();
			#Если Сервер И Не Сервер Тогда
				СтрокаМетода = ТаблицаМетодов.Добавить();
			#КонецЕсли
			ЗаполнитьЗначенияСвойств(СтрокаМетода, МетодМодуля);
			СтрокаМетода.ОбщийМодуль = СтрокаМетаТипа <> Неопределено И СтрокаМетаТипа.Единственное = "ОбщийМодуль";
			СтрокаМетода.Экспорт = МетодМодуля.ЛиЭкспорт;
			СтрокаМетода.ИмяМодуляМетаданных = МодульМетаданных.Имя;
			СтрокаМетода.Аннотация = МетодМодуля.Аннотация;
			СтрокаМетода.ИмяРасширения = СтруктураТипа.ДержательМетаданных;
			СтрокаМетода.АктивноРасширение = АктивностьРасширения;
			СтрокаМетода.Позиция = МетодМодуля.ПозицияОпределения;
			СтрокаМетода.Модуль = ирОбщий.ПоследнийФрагментЛкс(МодульМетаданных.Имя, "\");
			СтрокаМетода.ПолноеИмяВызова = МетодМодуля.Имя;
			Если ТипЗнч(МетаМодуль) = Тип("ОбъектМетаданныхКонфигурация") Тогда
				СтрокаМетода.Глобальный = Истина;
				Если ТипМодуляКонфигурации = "МодульОбычногоПриложения" Тогда 
					СтрокаМетода.КлиентОП = Истина;
				ИначеЕсли ТипМодуляКонфигурации = "МодульУправляемогоПриложения" Тогда 
					СтрокаМетода.КлиентУП = Истина;
				ИначеЕсли ТипМодуляКонфигурации = "МодульВнешнегоСоединения" Тогда 
					СтрокаМетода.ВнешнееСоединение = Истина;
				КонецЕсли; 
			Иначе
				Если СтрокаМетода.ОбщийМодуль Тогда
					#Если Сервер И Не Сервер Тогда
						МетаМодуль = Метаданные.ОбщиеМодули.ирОбщий;
					#КонецЕсли
					СтрокаМетода.КлиентУП = МетаМодуль.КлиентУправляемоеПриложение;
					СтрокаМетода.КлиентОП = МетаМодуль.КлиентОбычноеПриложение;
					СтрокаМетода.Сервер = МетаМодуль.Сервер;
					СтрокаМетода.ВызовСервера = МетаМодуль.ВызовСервера;
					СтрокаМетода.Глобальный = МетаМодуль.Глобальный;
					СтрокаМетода.Привилегированный = МетаМодуль.Привилегированный;
					СтрокаМетода.ПовторноеИспользование = ?(МетаМодуль.ПовторноеИспользованиеВозвращаемыхЗначений = Метаданные.СвойстваОбъектов.ПовторноеИспользованиеВозвращаемыхЗначений.НеИспользовать, "",
						МетаМодуль.ПовторноеИспользованиеВозвращаемыхЗначений);
					СтрокаМетода.ВнешнееСоединение = МетаМодуль.ВнешнееСоединение;
					Если Не МетаМодуль.Глобальный Тогда
						СтрокаМетода.ПолноеИмяВызова = МетаМодуль.Имя + "." + МетодМодуля.Имя;
					КонецЕсли; 
				Иначе
					СтрокаМетода.КлиентУП = МодульМетаданных.ФлагиКомпиляции.КлиентУправляемоеПриложение;
					СтрокаМетода.КлиентОП = МодульМетаданных.ФлагиКомпиляции.КлиентОбычноеПриложение;
					СтрокаМетода.Сервер = МодульМетаданных.ФлагиКомпиляции.Сервер;
					СтрокаМетода.ВнешнееСоединение = Истина;
					СтрокаМетода.ПовторноеИспользование = ""; 
					Если СтрокаМетаТипа <> Неопределено Тогда
						СтрокаМетода.ПолноеИмяВызова = СтрокаМетаТипа.Множественное + "." + МетаМодуль.Имя + "." + МетодМодуля.Имя;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли; 
			СтрокаМетода.ПолноеИмя = СтрокаМетода.ПолноеИмяВызова;
			Если ЗначениеЗаполнено(СтрокаМетода.ИмяРасширения) Тогда
				СтрокаМетода.ПолноеИмя = СтрокаМетода.ИмяРасширения + " " + СтрокаМетода.ПолноеИмя;
			КонецЕсли;
			ОбновитьТипЗначения(МетодМодуля, МодульМетаданных, СтрокаМетода);
			Если ПараметрыМетода <> Неопределено Тогда
				СтрокаМетода.ПараметрыСтрокой = ирОбщий.СтрСоединитьЛкс(ПараметрыМетода.ВыгрузитьКолонку("Имя"));
				СтрокаМетода.КоличествоПараметров = ПараметрыМетода.Количество();
			КонецЕсли;
			ЧислоРасширенийМетода = 0;
			Если СтруктураТипа.ДержательМетаданных <> Неопределено Тогда
				Если Найти(МетодМодуля.Аннотация, """") > 0 Тогда
					ИмяРасширяемогоМетода = ирОбщий.ТекстМеждуМаркерамиЛкс(МетодМодуля.Аннотация, """", """", Ложь);
					РасширенияМетодов.Свойство(ИмяРасширяемогоМетода, ЧислоРасширенийМетода);
					Если ЧислоРасширенийМетода = Неопределено Тогда 
						ЧислоРасширенийМетода = 1;
					Иначе 
						ЧислоРасширенийМетода = ЧислоРасширенийМетода + 1;
					КонецЕсли; 
					РасширенияМетодов.Вставить(ИмяРасширяемогоМетода, ЧислоРасширенийМетода);
					СтрокаМетода.ИмяРасширяемогоМетода = НРег(ИмяРасширяемогоМетода);
				КонецЕсли;
			Иначе 
				РасширенияМетодов.Свойство(МетодМодуля.Имя, ЧислоРасширенийМетода);
				СтрокаМетода.РасширенияАктивно = ЧислоРасширенийМетода;
			КонецЕсли;
		КонецЦикла;
		Если ИндикаторМодуля <> Неопределено Тогда
			ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
		КонецЕсли;                   
		Если БылиИзмененияКэшаМодуля Тогда
			мПлатформа.ЗаписатьМодульВКэш(МодульМетаданных, Истина);
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

Процедура ОбновитьТипЗначения(Знач МетодМодуля, Знач МодульМетаданных, Знач СтрокаОбщейТаблицы, Знач ВычислятьТипы = Неопределено)
	
	#Если Сервер И Не Сервер Тогда
		СтрокаОбщейТаблицы = МетодыМодулей.Добавить();
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	Если ВычислятьТипы = Неопределено Тогда
		ВычислятьТипы = ЭтаФорма.ВычислитьТипыСразу;
	КонецЕсли; 
	Если ВычислятьТипы Тогда
		мПлатформа.ПодготовитьТипРезультатаМетода(МетодМодуля, МодульМетаданных); 
	КонецЕсли; 
	ТаблицаТипов = мПлатформа.ТаблицаТиповСловаМодуля(МетодМодуля, МодульМетаданных);
	ОбновитьТипЗначенияИзТаблицыТипов(СтрокаОбщейТаблицы, ТаблицаТипов, Ложь);
	СтрокаОбщейТаблицы.ТаблицаТипов = ТаблицаТипов;

КонецПроцедуры

Функция СтруктураТаблицКомпоновки()
	
	СтруктураТаблиц = Новый Структура("Таблица");
	СтруктураТаблиц.Таблица = МетодыМодуляВсе.Скопировать();
	СтруктураТаблиц.Таблица.Колонки.Удалить("ТаблицаТипов");
	Возврат СтруктураТаблиц;

КонецФункции

Процедура ПриЗакрытии()
	
	ирКлиент.Форма_ПриЗакрытииЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ДействияФормыИсполняемаяКомпоновка(Кнопка)
	
	ОбновитьДанные(, Истина);
	
КонецПроцедуры

Процедура ОбновитьДанные(РедактируемыйФильтрПоПодстроке = Неопределено, РежимОтладки = Ложь) Экспорт 
	
	НастройкаКомпоновки = КонечнаяНастройкаКомпоновки(РедактируемыйФильтрПоПодстроке);
	ТекущаяСтрока = ЭлементыФормы.МетодыМодулей.ТекущаяСтрока;
	Если ТекущаяСтрока <> Неопределено Тогда
		СтарыйМетод = ТекущаяСтрока.ПолноеИмя;
	КонецЕсли; 
	СтруктураТаблиц = СтруктураТаблицКомпоновки();
	НоваяТаблица = ирОбщий.СкомпоноватьВКоллекциюЗначенийПоСхемеЛкс(СхемаКомпоновки, НастройкаКомпоновки,, СтруктураТаблиц,,,,, РежимОтладки,,,, Истина);
	Если РежимОтладки Тогда
		Возврат;
	КонецЕсли; 
	МетодыМодулей.Загрузить(НоваяТаблица);
	СтарыйСнимокНастройкиКомпоновки = ирОбщий.ОбъектВСтрокуXMLЛкс(Компоновщик.Настройки);
	Если СтарыйМетод <> Неопределено Тогда
		НоваяТекущаяСтрока = МетодыМодулей.Найти(СтарыйМетод, "ПолноеИмя");
		Если НоваяТекущаяСтрока <> Неопределено Тогда
			ЭлементыФормы.МетодыМодулей.ТекущаяСтрока = НоваяТекущаяСтрока;
		КонецЕсли; 
	КонецЕсли; 
	ЭтаФорма.Количество = МетодыМодулей.Количество();

КонецПроцедуры

Функция КонечнаяНастройкаКомпоновки(Знач РедактируемыйФильтрПоПодстроке = Неопределено)
	
	Если РедактируемыйФильтрПоПодстроке = Неопределено Тогда
		РедактируемыйФильтрПоПодстроке = МетодыМодулейСтрокаПоиска;
	КонецЕсли; 
	Фрагменты = ирОбщий.СтрРазделитьЛкс(РедактируемыйФильтрПоПодстроке, " ", Истина, Ложь);
	КолонкиПоиска = Новый Структура();
	НастройкаКомпоновки = Компоновщик.ПолучитьНастройки();
	Если Фрагменты.Количество() > 0 Тогда
		ГруппаИли = НастройкаКомпоновки.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаИли.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
		КолонкиПоиска.Вставить("Имя");
		Если ПрименятьФильтрКОписанию Тогда
			КолонкиПоиска.Вставить("Описание");
		КонецЕсли; 
		Если ПрименятьФильтрКТелу Тогда
			КолонкиПоиска.Вставить("Тело");
		КонецЕсли;
		Если ПрименятьФильтрКПараметрам Тогда
			КолонкиПоиска.Вставить("ПараметрыСтрокой");
		КонецЕсли;
		Для Каждого КлючИЗначение Из КолонкиПоиска Цикл
			ГруппаИ = ГруппаИли.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
			ГруппаИ.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
			Для Каждого Фрагмент Из Фрагменты Цикл
				ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(ГруппаИ, КлючИЗначение.Ключ, Фрагмент, ВидСравненияКомпоновкиДанных.Содержит,, Ложь);
			КонецЦикла;
		КонецЦикла;
	КонецЕсли; 
	ЭлементыФормы.НадписьОтбор.Заголовок = ирОбщий.ПредставлениеОтбораЛкс(НастройкаКомпоновки.Отбор);
	ирКлиент.ДопСвойстваЭлементаФормыЛкс(ЭтаФорма, ЭлементыФормы.МетодыМодулей).МенеджерПоиска = ирКлиент.СоздатьМенеджерПоискаВТабличномПолеЛкс(КолонкиПоиска,,, КолонкиПоиска.Количество() > 1);
	Возврат НастройкаКомпоновки;

КонецФункции

Процедура ФильтрАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	
	ирКлиент.ПромежуточноеОбновлениеСтроковогоЗначенияПоляВводаЛкс(ЭтаФорма, Элемент, Текст);
	ОбновитьДанные(Текст);
	
КонецПроцедуры

Процедура ДействияФормыПерейтиКОпределению(Кнопка)
	
	ТекущаяСтрока = ЭлементыФормы.МетодыМодулей.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	СтрокаПолногоОписания = МетодыМодуляВсе.Найти(ТекущаяСтрока.ПолноеИмя, "ПолноеИмя");
	ОткрытьОпределениеСтруктурыТипа(СтрокаПолногоОписания.ТаблицаТипов[0]);
	
КонецПроцедуры

Процедура ФильтрПриИзменении(Элемент)
	
	ирКлиент.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
	ОбновитьДанные();
	
КонецПроцедуры

Процедура ФильтрНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_ОбновитьСписокЛкс(Элемент, ЭтаФорма);
	
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

Процедура МетодыМодуляПриАктивизацииСтроки(Элемент)
	
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	ирКлиент.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	ТекущаяСтрока = ЭлементыФормы.МетодыМодулей.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	СтрокаПолногоОписания = МетодыМодуляВсе.Найти(ТекущаяСтрока.ПолноеИмя, "ПолноеИмя");
	МодульМетаданных = мПлатформа.МодульМетаданныхИзКэша(СтрокаПолногоОписания.ИмяМодуляМетаданных);
	Если Найти(СтрокаПолногоОписания.ТипЗначения, "??") = 1 Тогда
		ОбновитьТипЗначения(СтрокаПолногоОписания.ТаблицаТипов[0].СтрокаОписания, МодульМетаданных, СтрокаПолногоОписания, Истина);
		ЗаполнитьЗначенияСвойств(ТекущаяСтрока, СтрокаПолногоОписания); 
	КонецЕсли;
	#Если Сервер И Не Сервер Тогда             
		ТекущаяСтрока = МетодыМодулей.Добавить();
	#КонецЕсли
	СтрокаПолногоОписания = МетодыМодуляВсе.Найти(ТекущаяСтрока.ПолноеИмя, "ПолноеИмя");
	СтруктураТипаКонтекста = СтрокаПолногоОписания.ТаблицаТипов[0];
	ОткрытьПрикрепленнуюФормуВызоваМетода(СтруктураТипаКонтекста, ЭтаФорма);
	ЭтаФорма.Активизировать();
	ирКлиент.РазобратьПозициюМодуляВСтрокеТаблицыЛкс(ТекущаяСтрока, СтрокаПолногоОписания.ИмяМодуляМетаданных,,,,, ТекущаяСтрока.Имя);
	ЭлементыФормы.Расширения.ОтборСтрок.Модуль.Установить(ТекущаяСтрока.Модуль);
	ЭлементыФормы.Расширения.ОтборСтрок.ИмяРасширяемогоМетода.Установить(ТекущаяСтрока.НИмя);

КонецПроцедуры

Процедура МетодыМодуляПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	ирКлиент.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
КонецПроцедуры

// Вызывается из 2-х табличых полей
Процедура МетодыМодуляВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элемент.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	СтрокаПолногоОписания = МетодыМодуляВсе.Найти(ТекущаяСтрока.ПолноеИмя, "ПолноеИмя");
	Если Колонка.Имя = ЭлементыФормы.МетодыМодулей.Колонки.ТипЗначения.Имя Тогда
		ирКлиент.ОткрытьЗначениеЛкс(СтрокаПолногоОписания.ТаблицаТипов,,, "Описания типов значений");
	ИначеЕсли Колонка.Имя = ЭлементыФормы.МетодыМодулей.Колонки.Описание.Имя Тогда
		ирКлиент.ОткрытьТекстЛкс(СтрокаПолногоОписания.Описание, "Описание метода " + СтрокаПолногоОписания.ПолноеИмя, "Обычный", Истина, СтрокаПолногоОписания.ПолноеИмя + ".Описание");
	ИначеЕсли Колонка.Имя = ЭлементыФормы.МетодыМодулей.Колонки.Ссылка.Имя Тогда
		ирКлиент.ПоказатьСсылкуНаСтрокуМодуляЛкс(ТекущаяСтрока.Ссылка);
	ИначеЕсли Колонка.Имя = ЭлементыФормы.МетодыМодулей.Колонки.РасширенияАктивно.Имя Тогда
		ИзменитьСвернутостьПанельРасширения(Истина);
	Иначе
		//ОткрытьОпределениеМетодаМодуля(СтрокаПолногоОписания.ТаблицаТипов[0].СтрокаОписания);
		ирКлиент.ОткрытьМетодМодуляПоИмениЛкс(СтрокаПолногоОписания.Имя, СтрокаПолногоОписания.ИмяМодуляМетаданных);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	КонечнаяНастройкаКомпоновки();
	Если ОбновлятьСразу Тогда
		Если СтарыйСнимокНастройкиКомпоновки <> ирОбщий.ОбъектВСтрокуXMLЛкс(Компоновщик.Настройки) Тогда
			ирОбщий.КомпоновщикНастроекВосстановитьЛкс(Компоновщик);
			ОбновитьДанные();
		КонецЕсли; 
	КонецЕсли; 

КонецПроцедуры

Процедура ДействияФормыОбновить(Кнопка)
	
	ОбновитьДанные();
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирКлиент.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирКлиент.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	ирКлиент.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры
 
Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирКлиент.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	Если ирОбщий.ПроверитьПлатформаНеWindowsЛкс(Отказ,, Истина) Тогда
		Возврат;
	КонецЕсли; 
	ПроверитьИнициировать();
КонецПроцедуры

Процедура ДействияФормыВызовыМетода(Кнопка)
	
	ТекущаяСтрока = ЭлементыФормы.МетодыМодулей.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	СтрокаПолногоОписания = МетодыМодуляВсе.Найти(ТекущаяСтрока.ПолноеИмя, "ПолноеИмя");
	СтруктураТипаКонтекста = СтрокаПолногоОписания.ТаблицаТипов[0];
	ФормаВызовов = ПолучитьФорму("ПоискВМодулях",, ТекущаяСтрока.ПолноеИмя); 
	ФормаВызовов.ПараметрСтруктураТипаКонтекста = СтруктураТипаКонтекста;    
	ФормаВызовов.Открыть(); 
	ФормаВызовов.ОбновитьДанные();
	
КонецПроцедуры

Процедура НадписьКэшМодулейНажатие(Элемент)
	ПолучитьФорму("ФормаНастройки", ФормаВладелец).Открыть();
КонецПроцедуры

Процедура ДействияФормыСверткаРасширения(Кнопка)
	ИзменитьСвернутостьПанельРасширения(Не ПоказыватьРасширения);
КонецПроцедуры

Процедура ИзменитьСвернутостьПанельРасширения(Видимость)
	Если Видимость = ПоказыватьРасширения Тогда
		Возврат;
	КонецЕсли;
	ирКлиент.ИзменитьСвернутостьЛкс(ЭтаФорма, Видимость, ЭлементыФормы.Расширения, ЭтаФорма.ЭлементыФормы.РазделительРасширения, ЭтаФорма.Панель, "низ");
	ЭлементыФормы.ДействияФормы.Кнопки.СверткаРасширения.Пометка = Видимость;
	ЭтаФорма.ПоказыватьРасширения = Видимость;
КонецПроцедуры

Процедура РасширенияПриАктивизацииСтроки(Элемент)
	ирКлиент.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	ТекущаяСтрока = ЭлементыФормы.Расширения.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	СтрокаПолногоОписания = МетодыМодуляВсе.Найти(ТекущаяСтрока.ПолноеИмя, "ПолноеИмя");
	ирКлиент.РазобратьПозициюМодуляВСтрокеТаблицыЛкс(ТекущаяСтрока, СтрокаПолногоОписания.ИмяМодуляМетаданных,,,,, ТекущаяСтрока.Имя);
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	ИзменитьСвернутостьПанельРасширения(Истина);
КонецПроцедуры

Процедура РасширенияПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	ирКлиент.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
КонецПроцедуры

ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирКлсПолеТекстаПрограммы.Форма.МетодыМодулей");
ОбновлятьСразу = Истина;
мРежимОдинМодуль = Ложь;

