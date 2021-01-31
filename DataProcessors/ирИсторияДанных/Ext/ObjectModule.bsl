﻿//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирПривилегированный Экспорт;

Перем мПлатформа Экспорт;
Перем мОписанияТиповПолей Экспорт;

Функция ИсторияДанныхМоя() Экспорт 
	
	Возврат Вычислить("ИсторияДанных");

КонецФункции

Процедура ОбновитьИсторию() Экспорт 
	ирОбщий.СостояниеЛкс("Обновление истории данных");
	ИсторияДанныхМоя = ИсторияДанныхМоя();
	#Если Сервер И Не Сервер Тогда
		ИсторияДанныхМоя = ИсторияДанных;
	#КонецЕсли
	ИсторияДанныхМоя.ОбновитьИсторию();
	ирОбщий.СостояниеЛкс("");
КонецПроцедуры

Процедура ОбновитьПредставлениеПолейВСтрокеТипа(Знач НастройкиИстории, ОбъектМД, Знач СтрокаДанных, ВычислятьПоля = Ложь) Экспорт 
	
	СтрокаДанных.ПоляВключенные = "?";
	СтрокаДанных.ПоляВыключенные = "?";
	ИспользованиеПолейНастроекИстории = Неопределено;
	Если НастройкиИстории <> Неопределено Тогда
		СтрокаДанных.Использование = НастройкиИстории.Использование;
		ИспользованиеПолейНастроекИстории = НастройкиИстории.ИспользованиеПолей;
	КонецЕсли;
	Если Не ВычислятьПоля Тогда
		Возврат;
	КонецЕсли; 
	ТаблицаПолей = ИспользованиеПолей(ОбъектМД, ИспользованиеПолейНастроекИстории);
	СтрокаДанных.ПоляВключенные = ПредставлениеПолей(ТаблицаПолей, Истина);
	СтрокаДанных.ПоляВыключенные = ПредставлениеПолей(ТаблицаПолей, Ложь);

КонецПроцедуры

Функция ИспользованиеПолей(ОбъектМД, ИспользованиеПолейНастроекИстории = Неопределено, Подробно = Ложь) Экспорт 
	
	#Если Сервер И Не Сервер Тогда
		ОбъектМД = Метаданные.Справочники.ирАлгоритмы;
	#КонецЕсли
	Если ИспользованиеПолейНастроекИстории = Неопределено Тогда
		ИсторияДанныхМоя = ИсторияДанныхМоя();
		#Если Сервер И Не Сервер Тогда
			ИсторияДанныхМоя = ИсторияДанных;
		#КонецЕсли
		НастройкиИстории = ИсторияДанныхМоя.ПолучитьНастройки(ОбъектМД);
		Если НастройкиИстории <> Неопределено Тогда
			ИспользованиеПолейНастроекИстории = НастройкиИстории.ИспользованиеПолей;
		КонецЕсли;
	КонецЕсли; 
	ТаблицаПолей = Поля.ВыгрузитьКолонки();
	ИспользованиеИсторииДанныхИспользовать = Метаданные.СвойстваОбъектов.ИспользованиеИсторииДанных.Использовать;
	Если Метаданные.Константы.Содержит(ОбъектМД) Тогда
		Возврат ТаблицаПолей;
	КонецЕсли; 
	#Если Сервер И Не Сервер Тогда
		ТаблицаПолей = Поля;
	#КонецЕсли
	ИмяПоляВерсияДанных = ирОбщий.ПеревестиСтроку("ВерсияДанных");
	ИмяПоляНомерСтроки = ирОбщий.ПеревестиСтроку("НомерСтроки");
	ИмяПоляСсылка = ирОбщий.ПеревестиСтроку("Ссылка");
	Если Подробно Тогда
		мОписанияТиповПолей = Новый ТаблицаЗначений;
		мОписанияТиповПолей.Колонки.Добавить("Имя");
		мОписанияТиповПолей.Колонки.Добавить("ОписаниеТипов");
	КонецЕсли; 
	Для Каждого СтандартныйРеквизит Из ОбъектМД.СтандартныеРеквизиты Цикл
		Если СтандартныйРеквизит.Имя = ИмяПоляСсылка Тогда
			Продолжить;
		КонецЕсли; 
		СтрокаПоля = ТаблицаПолей.Добавить();
		СтрокаПоля.ИмяПоля = СтандартныйРеквизит.Имя;
		СтрокаПоля.ПредставлениеПоля  = СтандартныйРеквизит.Представление();
		СтрокаПоля.ИспользованиеВМетаданных = СтандартныйРеквизит.ИсторияДанных = ИспользованиеИсторииДанныхИспользовать;
		СтрокаПоля.Использование = СтрокаПоля.ИспользованиеВМетаданных;
		СтрокаПоля.ТипПоля = 1;
		Если ИспользованиеПолейНастроекИстории <> Неопределено И ИспользованиеПолейНастроекИстории[СтрокаПоля.ИмяПоля] <> Неопределено Тогда
			СтрокаПоля.Использование = ИспользованиеПолейНастроекИстории[СтрокаПоля.ИмяПоля];
		КонецЕсли; 
		Если Подробно Тогда
			СтрокаОписанияТипов = мОписанияТиповПолей.Добавить();
			СтрокаОписанияТипов.Имя = СтрокаПоля.ИмяПоля;
			СтрокаОписанияТипов.ОписаниеТипов = СтандартныйРеквизит.Тип;
			СтрокаПоля.ОписаниеТипов = ирОбщий.РасширенноеПредставлениеЗначенияЛкс(СтрокаОписанияТипов.ОписаниеТипов);
		КонецЕсли; 
	КонецЦикла;
	ТабличныеЧасти = ирОбщий.ТабличныеЧастиОбъектаЛкс(ОбъектМД);
	#Если Сервер И Не Сервер Тогда
		ТабличныеЧасти = Новый Структура;
	#КонецЕсли
	ТабличныеЧасти.Вставить("_", ОбъектМД);
	ИмяТаблицыБД = ирКэш.ИмяТаблицыИзМетаданныхЛкс(ОбъектМД.ПолноеИмя());
	Для Каждого ОписаниеТЧ Из ТабличныеЧасти Цикл
		Если ОписаниеТЧ.Ключ = "_" Тогда
			ПоляТаблицыБД = ирКэш.ПоляТаблицыБДЛкс(ИмяТаблицыБД);
		Иначе
			ПоляТаблицыБД = ирКэш.ПоляТаблицыБДЛкс(ИмяТаблицыБД + "." + ОписаниеТЧ.Ключ);
		КонецЕсли; 
		Если ПоляТаблицыБД = Неопределено Тогда
			Продолжить;
		КонецЕсли; 
		Для Каждого СтрокаПоляБД Из ПоляТаблицыБД Цикл
			ИмяПоля = СтрокаПоляБД.Имя;
			ПредставлениеПоля = СтрокаПоляБД.Заголовок;
			Если ОписаниеТЧ.Ключ = "_" Тогда
				Если Ложь
					Или ТаблицаПолей.Найти(ИмяПоля, "ИмяПоля") <> Неопределено 
					Или ИмяПоля = ИмяПоляСсылка
					Или ИмяПоля = ИмяПоляВерсияДанных
					Или СтрокаПоляБД.ТипЗначения.СодержитТип(Тип("ТаблицаЗначений"))
				Тогда
					Продолжить;
				КонецЕсли;
				ТипПоля = 2;
			Иначе
				Если Ложь
					Или ИмяПоля = ИмяПоляСсылка
					Или ИмяПоля = ИмяПоляНомерСтроки
				Тогда
					Продолжить;
				КонецЕсли; 
				ИмяПоля = ОписаниеТЧ.Ключ + "." + ИмяПоля;
				ПредставлениеПоля = ОписаниеТЧ.Значение + "." + ПредставлениеПоля;
				ТипПоля = 3;
			КонецЕсли; 
			СтрокаПоля = ТаблицаПолей.Добавить();
			СтрокаПоля.ИмяПоля = ИмяПоля;
			СтрокаПоля.ПредставлениеПоля = ПредставлениеПоля;
			МетаданныеПоля = СтрокаПоляБД.Метаданные;
			Если МетаданныеПоля <> Неопределено Тогда
				СтрокаПоля.ИспользованиеВМетаданных = МетаданныеПоля.ИсторияДанных = ИспользованиеИсторииДанныхИспользовать;
			КонецЕсли; 
			СтрокаПоля.Использование = СтрокаПоля.ИспользованиеВМетаданных;
			СтрокаПоля.ТипПоля = ТипПоля;
			Если ИспользованиеПолейНастроекИстории <> Неопределено И ИспользованиеПолейНастроекИстории[ИмяПоля] <> Неопределено Тогда
				СтрокаПоля.Использование = ИспользованиеПолейНастроекИстории[ИмяПоля];
			КонецЕсли; 
			Если Подробно Тогда
				СтрокаОписанияТипов = мОписанияТиповПолей.Добавить();
				СтрокаОписанияТипов.Имя = СтрокаПоля.ИмяПоля;
				СтрокаОписанияТипов.ОписаниеТипов = СтрокаПоляБД.ТипЗначения;
				СтрокаПоля.ОписаниеТипов = ирОбщий.РасширенноеПредставлениеЗначенияЛкс(СтрокаОписанияТипов.ОписаниеТипов);
			КонецЕсли; 
		КонецЦикла;
	КонецЦикла;
	ТаблицаПолей.Сортировать("ТипПоля, ИмяПоля");
	Возврат ТаблицаПолей;
	
КонецФункции

Функция ПредставлениеПолей(ТаблицаПолей, Использование)
	
	#Если Сервер И Не Сервер Тогда
		ТаблицаПолей = Поля;
	#КонецЕсли
	Результат = Новый ЗаписьXML;
	Результат.УстановитьСтроку("");
	ВыбранныеПоля = ТаблицаПолей.НайтиСтроки(Новый Структура("Использование", Использование));
	Если ВыбранныеПоля.Количество() > 0 Тогда
		Результат.ЗаписатьБезОбработки("" + ВыбранныеПоля.Количество() + ": ");
		ЭтоПервоеПоле = Истина;
		Для Каждого СтрокаПоля Из ВыбранныеПоля Цикл
			#Если Сервер И Не Сервер Тогда
				СтрокаПоля = ТаблицаПолей.Добавить();
			#КонецЕсли
			Если Не ЭтоПервоеПоле Тогда
				Результат.ЗаписатьБезОбработки(", ");
			КонецЕсли; 
			Результат.ЗаписатьБезОбработки(СтрокаПоля.ИмяПоля);
			ЭтоПервоеПоле = Ложь;
		КонецЦикла;
	КонецЕсли; 
	Результат = Результат.Закрыть();
	Возврат Результат;
	
КонецФункции

Процедура РассчитатьИтогиИсторииПоТипам(ОтборВерсий) Экспорт 
	ИсторияДанныхМоя = ИсторияДанныхМоя();
	мПлатформа = ирКэш.Получить();
	#Если Сервер И Не Сервер Тогда
		ОтборВерсий = Новый Структура;
		ИсторияДанныхМоя = ИсторияДанных;
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	ИспользованиеИсторииДанныхИспользовать = Метаданные.СвойстваОбъектов.ИспользованиеИсторииДанных.Использовать;
	СтрокиМетаОбъектов = мПлатформа.ТаблицаТиповМетаОбъектов.НайтиСтроки(Новый Структура("Категория", 0));
	Типы.Очистить();
	ИндикаторТипаМетаданных = ирОбщий.ПолучитьИндикаторПроцессаЛкс(СтрокиМетаОбъектов.Количество(), "Типы метаданных");
	Для Каждого СтрокаТаблицыМетаОбъектов Из СтрокиМетаОбъектов Цикл
		ирОбщий.ОбработатьИндикаторЛкс(ИндикаторТипаМетаданных);
		Единственное = СтрокаТаблицыМетаОбъектов.Единственное;
		Если Ложь
			Или ирОбщий.ЛиКорневойТипСсылкиЛкс(Единственное, Истина) 
			Или ирОбщий.ЛиКорневойТипРегистраСведенийЛкс(Единственное)
			Или ирОбщий.ЛиКорневойТипКонстантыЛкс(Единственное)
		Тогда 
			КоллекцияМетаданных = Метаданные[СтрокаТаблицыМетаОбъектов.Множественное];
			ИндикаторТипаОбъектов = ирОбщий.ПолучитьИндикаторПроцессаЛкс(КоллекцияМетаданных.Количество(), Единственное);
			Для Каждого ОбъектМД Из КоллекцияМетаданных Цикл
				ирОбщий.ОбработатьИндикаторЛкс(ИндикаторТипаОбъектов);
				#Если Сервер И Не Сервер Тогда
					ОбъектМД = Метаданные.Справочники.ирАлгоритмы;
				#КонецЕсли
				ПолноеИмя = ОбъектМД.ПолноеИмя();
				Попытка
					НастройкиИстории = ИсторияДанныхМоя.ПолучитьНастройки(ОбъектМД);
				Исключение
					// В этой версии платформы не поддерживается этот корневой тип метаданных
					//ОписаниеОшибки = ОписаниеОшибки();
					Продолжить;
				КонецПопытки; 
				СтрокаДанных = Типы.Добавить();
				СтрокаДанных.ТипМетаданных = ирОбщий.ПервыйФрагментЛкс(ПолноеИмя);
				СтрокаДанных.ПолноеИмяМД = ПолноеИмя;
				СтрокаДанных.ИмяМД = ОбъектМД.Имя;
				СтрокаДанных.ПредставлениеМД = ОбъектМД.Представление();
				СтрокаДанных.ИспользованиеВМетаданных = ОбъектМД.ИсторияДанных = ИспользованиеИсторииДанныхИспользовать;
				СтрокаДанных.Использование = СтрокаДанных.ИспользованиеВМетаданных;
				ОбновитьПредставлениеПолейВСтрокеТипа(НастройкиИстории, ОбъектМД, СтрокаДанных, ВычислятьПоля);
				СтрокаДанных.ЕстьДоступ = ПравоДоступа("ЧтениеИсторииДанных", ОбъектМД);
				Если СтрокаДанных.ЕстьДоступ И ВычислятьКоличествоВерсий Тогда
					ОтборВерсий.Вставить("Метаданные", ОбъектМД);
					СтрокаДанных.КоличествоВерсий = ИсторияДанныхМоя.ВыбратьВерсии(ОтборВерсий,,, МаксКоличествоВерсий).Количество();
				КонецЕсли; 
			КонецЦикла;
			ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
		КонецЕсли;
	КонецЦикла;
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	Типы.Сортировать("ПолноеИмяМД");
КонецПроцедуры

Функция ВыбратьВерсииПоОбъектуМД(ПолноеИмяМД, ОтборВерсий) Экспорт 
	ИсторияДанныхМоя = ИсторияДанныхМоя();
	#Если Сервер И Не Сервер Тогда
		ИсторияДанныхМоя = ИсторияДанных;
	#КонецЕсли
	ОтборВерсий.Вставить("Метаданные", ирКэш.ОбъектМДПоПолномуИмениЛкс(ПолноеИмяМД));
	ТаблицаВерсий = ИсторияДанныхМоя.ВыбратьВерсии(ОтборВерсий,,, МаксКоличествоВерсий);
	Возврат ТаблицаВерсий;
КонецФункции

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
