﻿//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирПривилегированный Экспорт;

#Если Клиент Тогда

Перем ПризнакРавно			Экспорт; // признаки сравнения
Перем ПризнакНеРавно 		Экспорт;
Перем ПризнакТолько1 		Экспорт;
Перем ПризнакТолько2 		Экспорт;
Перем ВыводитьРазницу		Экспорт; // флаг, выводить ли разницу числовых сравниваемых колонок
Перем ВсегоРазличий			Экспорт; // количество найденных различий при сравнении файлов
Перем ЗагрузкаТабличныхДанных1 Экспорт;
Перем ЗагрузкаТабличныхДанных2 Экспорт;
Перем мИмяГруппыКлючевыхКолонок Экспорт;
Перем мИмяГруппыСравниваемыхКолонок Экспорт;
Перем мИмяГруппыНесравниваемыхКолонок Экспорт;
Перем мИмяГруппыРазностныхКолонок Экспорт;
Перем мИмяКолонкиРезультатаСравнения Экспорт;
Перем мИмяКолонкиНомераСтрокиРезультата Экспорт;
Перем РезультатыСравненияСтрок Экспорт;
Перем СравниваемыеКолонкиРезультата Экспорт;
Перем СтруктураКолонокРезультата Экспорт;

// сравнение файлов
Функция ВыполнитьСравнение(ТабличноеПолеРезультата) Экспорт
	
	Если Не ОбновитьДанныеТаблицы("1") Тогда 
		Возврат Ложь;
	КонецЕсли; 
	Если Не ОбновитьДанныеТаблицы("2") Тогда 
		Возврат Ложь;
	КонецЕсли; 
	Результат = СравнитьТаблицы(ТабличноеПолеРезультата);
	Возврат Результат;
	
КонецФункции

Функция ОбновитьДанныеТаблицы(Знач НомерСтороны, Интерактивно = Ложь, СброситьНастройки = Ложь) Экспорт
	
	ИмяФайла = ЭтотОбъект["ИмяФайла" + НомерСтороны];
	Если ЗначениеЗаполнено(ИмяФайла) Тогда
		Файл = Новый Файл(ИмяФайла);
		Если ирОбщий.СтрокиРавныЛкс(Файл.Расширение, ".vt_") Тогда
			Таблица = ирОбщий.ПрочитатьЗначениеИзФайлаСКонтролемПотерьЛкс(Файл.ПолноеИмя);
		Иначе
			ТабличныйДокумент = Новый ТабличныйДокумент;
			ТабличныйДокумент.Прочитать(Файл.ПолноеИмя);
			ЗагрузкаТабличныхДанных = ЗагрузчикТабличныхДанных(НомерСтороны);
			#Если Сервер И Не Сервер Тогда
				ЗагрузкаТабличныхДанных = Обработки.ирЗагрузкаТабличныхДанных.Создать();
			#КонецЕсли
			ФормаЗагрузки = ЗагрузкаТабличныхДанных.ПолучитьФорму(); // Чтобы создались колонки в реквизитах объекта
			ЗагрузкаТабличныхДанных.ТабличныйДокумент = ТабличныйДокумент;
			НастройкаЗагрузки = Неопределено;
			Если Не СброситьНастройки Тогда
				НастройкаЗагрузки = ЭтотОбъект["НастройкаЗагрузки" + НомерСтороны];
			КонецЕсли; 
			Если НастройкаЗагрузки <> Неопределено Тогда
				ЗагрузкаТабличныхДанных.ЗагрузитьНастройку(НастройкаЗагрузки);
			Иначе
				Интерактивно = Истина;
			КонецЕсли; 
			ЗагрузкаТабличныхДанных.ОбновитьКолонкиТаблицыЗначений(Истина, Ложь);
			ЗагрузкаТабличныхДанных.ОбновитьСопоставлениеКолонокТЗ();
			ЗагрузкаТабличныхДанных.СопоставлениеКолонокТЗЗаполнить();
			Если Интерактивно Тогда
				ФормаЗагрузки.СинхронизироватьРеквизитыОбъекта(Ложь);
				ФормаЗагрузки.РежимРедактора = Истина;
				РезультатФормы = ФормаЗагрузки.ОткрытьМодально();
				Если РезультатФормы = Неопределено Тогда
					Возврат Ложь;
				КонецЕсли; 
				ЭтотОбъект["НастройкаЗагрузки" + НомерСтороны] = ЗагрузкаТабличныхДанных.ПолучитьНастройку();
			КонецЕсли; 
			ЗагрузкаТабличныхДанных.ЗагрузитьВТаблицуЗначений();
			Таблица = ЗагрузкаТабличныхДанных.ТаблицаЗначений;
		КонецЕсли; 
		ЭтотОбъект["Таблица" + НомерСтороны] = Таблица;
	КонецЕсли;
	ОбновитьСопоставлениеКолонок();
	ЗаполнитьСопоставлениеКолонок();
	Таблица = ЭтотОбъект["Таблица" + НомерСтороны];
	Если Таблица.Количество() = 0 Тогда
		Сообщить("Таблица " + НомерСтороны + " не содержит данных");
		Возврат Ложь;
	КонецЕсли;
	Возврат Истина;

КонецФункции

Функция ЗагрузчикТабличныхДанных(Знач НомерСтороны) Экспорт 
	
	ЗагрузкаТабличныхДанных = ЭтотОбъект["ЗагрузкаТабличныхДанных" + НомерСтороны];
	Если ЗагрузкаТабличныхДанных = Неопределено Тогда
		ЗагрузкаТабличныхДанных = ирОбщий.ПолучитьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирЗагрузкаТабличныхДанных");
		ЭтотОбъект["ЗагрузкаТабличныхДанных" + НомерСтороны] = ЗагрузкаТабличныхДанных;
	КонецЕсли; 
	Возврат ЗагрузкаТабличныхДанных;

КонецФункции

Процедура ОбновитьСопоставлениеКолонок() Экспорт 
	
	КопияСопоставления1 = КолонкиТаблица1.Выгрузить();
	КопияСопоставления2 = КолонкиТаблица2.Выгрузить();
	КолонкиТаблица2.Очистить();
	Для Каждого Колонка Из Таблица2.Колонки Цикл
		СопоставлениеКолонки = КолонкиТаблица2.Добавить();
		СопоставлениеКолонки.Выводить = Истина;
		СопоставлениеКолонки.ИмяКолонки = Колонка.Имя;
		СопоставлениеКолонки.СинонимКолонки = Колонка.Заголовок;
		СопоставлениеКолонки.ОписаниеТипов = Колонка.ТипЗначения;
	КонецЦикла;
	КолонкиТаблица1.Очистить();
	Для Каждого Колонка Из Таблица1.Колонки Цикл
		СопоставлениеКолонки = КолонкиТаблица1.Добавить();
		СопоставлениеКолонки.Выводить = Истина;
		СопоставлениеКолонки.ИмяКолонки = Колонка.Имя;
		СтараяСтрока = КопияСопоставления1.Найти(СопоставлениеКолонки.ИмяКолонки, "ИмяКолонки");
		Если СтараяСтрока <> Неопределено Тогда
			ЗаполнитьЗначенияСвойств(СопоставлениеКолонки, СтараяСтрока); 
			Колонка2 = Неопределено;
			Если ЗначениеЗаполнено(СопоставлениеКолонки.ИмяКолонки2) Тогда
				Колонка2 = Таблица2.Колонки.Найти(СопоставлениеКолонки.ИмяКолонки2);
			КонецЕсли; 
			СопоставитьКолонку(СопоставлениеКолонки, Колонка2);
		КонецЕсли; 
		СопоставлениеКолонки.СинонимКолонки = Колонка.Заголовок;
		СопоставлениеКолонки.ОписаниеТипов = Колонка.ТипЗначения;
		СопоставлениеКолонки.Числовая = Колонка.ТипЗначения.СодержитТип(Тип("Число"));
	КонецЦикла; 
	ЭтотОбъект.КоличествоСтрок1 = Таблица1.Количество();
	ЭтотОбъект.КоличествоСтрок2 = Таблица2.Количество();
	
КонецПроцедуры

Процедура ЗаполнитьСопоставлениеКолонок(ПоИменам = Ложь) Экспорт
	
	Для Каждого Колонка Из Таблица2.Колонки Цикл
		Если Истина
			И ЗагрузкаТабличныхДанных2 <> Неопределено
			И ирОбщий.СтрокиРавныЛкс(Колонка.Имя, ЗагрузкаТабличныхДанных2.мИмяКолонкиНомерСтроки)
		Тогда
			Продолжить;
		КонецЕсли; 
		СтруктураОтбора = Новый Структура("СинонимКолонки2", "");
		СтрокиСопоставления = КолонкиТаблица1.НайтиСтроки(СтруктураОтбора);
		СтрокаИмен = "";
		Для Каждого СтрокаСопоставления Из СтрокиСопоставления Цикл
			Если Не ирОбщий.ОписаниеТипов1ВходитВОписаниеТипов2Лкс(Колонка.ТипЗначения, Таблица1.Колонки[СтрокаСопоставления.ИмяКолонки].ТипЗначения) Тогда
				Продолжить;
			КонецЕсли; 
			Если Ложь
				Или ирОбщий.СтрокиРавныЛкс(СтрокаСопоставления.ИмяКолонки, Колонка.Имя) 
				Или ирОбщий.СтрокиРавныЛкс(СтрокаСопоставления.СинонимКолонки, Колонка.Заголовок)
			Тогда
				СопоставитьКолонку(СтрокаСопоставления, Колонка);
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

Процедура ПодобратьКлючевыеИСравниваемыеКолонки() Экспорт 
	
	Уникальность1Достигнута = Ложь;
	Уникальность2Достигнута = Ложь;
	СтрокаКлюча1 = "";
	СтрокаКлюча2 = "";
	Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(КолонкиТаблица1.Количество(), "Подбор ключа таблиц");
	КолонкиТаблица1.Сортировать("Числовая");
	Для Каждого СтрокаСопоставления Из КолонкиТаблица1 Цикл
		ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
		Если СтрокаСопоставления.ИмяКолонки2 = "" Тогда
			Продолжить;
		КонецЕсли; 
		ДобавитьКолонкуВСтрокуКлюча(СтрокаСопоставления.ИмяКолонки, СтрокаКлюча1);
		ДобавитьКолонкуВСтрокуКлюча(СтрокаСопоставления.ИмяКолонки2, СтрокаКлюча2);
		СтрокаСопоставления.Ключевая = Истина;
		СтрокаСопоставления.Выводить = Истина;
		Если Не ПроверитьУникальностьКлючаТаблицы(Таблица1, СтрокаКлюча1) Тогда
			Продолжить;
		Иначе
			Уникальность1Достигнута = Истина;
		КонецЕсли; 
		Если Не ПроверитьУникальностьКлючаТаблицы(Таблица2, СтрокаКлюча2) Тогда
			Продолжить;
		Иначе
			Уникальность2Достигнута = Истина;
		КонецЕсли; 
		Прервать;
	КонецЦикла;
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	Если Истина
		И Не Уникальность1Достигнута 
		И Таблица1.Количество() > 0
		И ЗначениеЗаполнено(СтрокаКлюча1) 
	Тогда
		Сообщить("В таблице 1 имеются неуникальные строки по сопоставленным колонкам (" + СтрокаКлюча1 + ")");
	КонецЕсли; 
	Если Истина
		И Не Уникальность2Достигнута 
		И Таблица2.Количество() > 0
		И ЗначениеЗаполнено(СтрокаКлюча2) 
	Тогда
		Сообщить("В таблице 2 имеются неуникальные строки по сопоставленным колонкам (" + СтрокаКлюча2 + ")");
	КонецЕсли; 
	Для Каждого СтрокаСопоставления Из КолонкиТаблица1 Цикл
		Если СтрокаСопоставления.ИмяКолонки2 = "" Тогда
			Продолжить;
		КонецЕсли; 
		СтрокаСопоставления.Сравнивать = Не СтрокаСопоставления.Ключевая;
	КонецЦикла;
	
КонецПроцедуры

Функция ПроверитьУникальностьКлючаТаблицы(Таблица, СтрокаКлюча)
	
	КопияТаблицы = Таблица.Скопировать(, СтрокаКлюча);
	КопияТаблицы.Свернуть(СтрокаКлюча);
	ТолькоУникальные = КопияТаблицы.Количество() = Таблица.Количество();
	Возврат ТолькоУникальные;

КонецФункции

Процедура ДобавитьКолонкуВСтрокуКлюча(Знач ИмяДобавляемойКолонки, СтрокаКлюча)
	
	Если СтрокаКлюча <> "" Тогда
		СтрокаКлюча = СтрокаКлюча + ",";
	КонецЕсли; 
	СтрокаКлюча = СтрокаКлюча + ИмяДобавляемойКолонки;

КонецПроцедуры

Процедура СопоставитьКолонку(Знач СтрокаСопоставления, Знач Колонка = Неопределено) Экспорт 
	
	Если Колонка <> Неопределено Тогда
		СтрокаКолонки2 = КолонкиТаблица2.Найти(Колонка.Имя, "ИмяКолонки");
		Если СтрокаКолонки2 <> Неопределено Тогда
			СтрокаКолонки2.ИмяКолонки1 = СтрокаСопоставления.ИмяКолонки;
			СтрокаКолонки2.СинонимКолонки1 = СтрокаСопоставления.СинонимКолонки;
		КонецЕсли; 
		СтрокаСопоставления.ИмяКолонки2 = Колонка.Имя;
		СтрокаСопоставления.СинонимКолонки2 = Колонка.Заголовок;
		СтрокаСопоставления.ОписаниеТипов2 = Колонка.ТипЗначения;
	Иначе
		СтрокаКолонки2 = КолонкиТаблица2.Найти(СтрокаСопоставления.ИмяКолонки2, "ИмяКолонки");
		Если СтрокаКолонки2 <> Неопределено Тогда
			СтрокаКолонки2.ИмяКолонки1 = "";
			СтрокаКолонки2.СинонимКолонки1 = "";
		КонецЕсли; 
		СтрокаСопоставления.ИмяКолонки2 = "";
		СтрокаСопоставления.СинонимКолонки2 = "";
		СтрокаСопоставления.ОписаниеТипов2 = Неопределено;
		СтрокаСопоставления.Ключевая = Ложь;
		СтрокаСопоставления.Сравнивать = Ложь;
	КонецЕсли; 

КонецПроцедуры

Функция Сравнить2СтрокиПоКолонкам(Знач ОтборКолонок, Знач Строка1, Знач Строка2)
	
	ЗначенияЯчеекРавны = Истина;
	КолонкиСопоставления = КолонкиТаблица1.НайтиСтроки(ОтборКолонок);
	Для Каждого СтрокаСопоставления Из КолонкиСопоставления Цикл
		Если Не СравнитьЗначенияЯчеек(СтрокаСопоставления.ИмяКолонки, СтрокаСопоставления.ИмяКолонки2, Строка1, Строка2) Тогда
			ЗначенияЯчеекРавны = Ложь; 
			Прервать;
		КонецЕсли; 
	КонецЦикла;
	Возврат ЗначенияЯчеекРавны;

КонецФункции

Функция СравнитьЗначенияЯчеек(Знач ИмяКолонки1, Знач ИмяКолонки2, Знач Строка1, Знач Строка2) Экспорт 
	
	ЗначенияЯчеекРавны = Истина;
	ЛевоеЗначение = Строка1[ИмяКолонки1];
	ПравоеЗначение = Строка2[ИмяКолонки2];
	// регистронезависимое сравнение
	Если НеУчитыватьРегистр Тогда 
		// сравнение без учета регистра имеет смысл только для строк
		Если ТипЗнч(ЛевоеЗначение) = Тип("Строка") И ТипЗнч(ПравоеЗначение) = Тип("Строка") Тогда
			Если ВРег(ЛевоеЗначение) <> ВРег(ПравоеЗначение) Тогда
				ЗначенияЯчеекРавны = Ложь;
			КонецЕсли;
		Иначе
			Если ЛевоеЗначение <> ПравоеЗначение Тогда
				ЗначенияЯчеекРавны = Ложь;
			КонецЕсли;
		КонецЕсли;
		// регистрозависимое сравнение
	Иначе	
		Если ЛевоеЗначение <> ПравоеЗначение Тогда
			ЗначенияЯчеекРавны = Ложь;
		КонецЕсли;
	КонецЕсли;
	Возврат ЗначенияЯчеекРавны;

КонецФункции

Функция СравнитьТаблицы(ТабличноеПолеРезультата)
	Перем Таблица2;
	
	// первая таблица - основная, во второй ищем подходящие строки
	Таблица2 = ЭтотОбъект.Таблица2.Скопировать();
	ПорядокСтрок = СоздатьКолонкиРезультата(ТабличноеПолеРезультата);
	ВсегоРазличий = 0;
	Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(Таблица1.Количество(), "Сравнение");
	Для i = 0 По Таблица1.Количество() - 1 Цикл
		ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
		СтрокаРезультата = Неопределено;
		Строка1 = Таблица1[i];
		Отбор = Новый Структура;
		Для Каждого СтрокаСравнения Из КолонкиТаблица1.НайтиСтроки(Новый Структура("Ключевая", Истина)) Цикл
			Отбор.Вставить(СтрокаСравнения.ИмяКолонки2, Строка1[СтрокаСравнения.ИмяКолонки]);
		КонецЦикла;
		Если Отбор.Количество() > 0 Тогда
			Строки2 = Таблица2.НайтиСтроки(Отбор);
		Иначе
			Строки2 = Таблица2;
		КонецЕсли; 
		НайденоСтрок = Строки2.Количество();
		// вариант 1. Найдена 1 и более строка
		Если НайденоСтрок >= 1 Тогда 
			Строка2 = Строки2[0];
			Если Сравнить2СтрокиПоКолонкам(Новый Структура("Сравнивать, Ключевая", Истина, Ложь), Строка1, Строка2) Тогда 
				Признак = ПризнакРавно;
			Иначе
				Признак = ПризнакНеРавно;
			КонецЕсли; 
			Если Признак <> ПризнакРавно Или Не НеВыводитьОдинаковыеСтроки Тогда 
				ВывестиСтрокуРезультата(СтрокаРезультата, Строка1, "1");
				ВывестиСтрокуРезультата(СтрокаРезультата, Строка2, "2");
				Если ВыводитьРазницуЧисловыхКолонокСравнения Тогда
					ВывестиРазницуЧисел(СтрокаРезультата, Признак);
				КонецЕсли;
			КонецЕсли;
			Если Признак <> ПризнакРавно Тогда
				ВсегоРазличий = ВсегоРазличий + 1;
			КонецЕсли;
			// удаляем строку из второй таблицы, чтоб не мешалась дальше
			Таблица2.Удалить(Строка2);
		ИначеЕсли НайденоСтрок = 0 Тогда
			ВывестиСтрокуРезультата(СтрокаРезультата, Строка1, "1");
			Признак = ПризнакТолько1;
			Если ВыводитьРазницуЧисловыхКолонокСравнения Тогда
				ВывестиРазницуЧисел(СтрокаРезультата, Признак);
			КонецЕсли;
			ВсегоРазличий = ВсегоРазличий + 1;
		КонецЕсли;
		Если СтрокаРезультата <> Неопределено Тогда
			СтрокаРезультата[мИмяКолонкиРезультатаСравнения] = Признак;
		КонецЕсли; 
	КонецЦикла;
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	Признак = ПризнакТолько2;
	// если во второй таблице остались строки, выводим их в конце
	Для Каждого Строка2 Из Таблица2 Цикл
		СтрокаРезультата = Неопределено;
		ВывестиСтрокуРезультата(СтрокаРезультата, Строка2, "2");
		СтрокаРезультата[мИмяКолонкиРезультатаСравнения] = Признак;
		Если ВыводитьРазницуЧисловыхКолонокСравнения Тогда
			ВывестиРазницуЧисел(СтрокаРезультата, Признак);
		КонецЕсли;
		ВсегоРазличий = ВсегоРазличий + 1;
	КонецЦикла;
	Если ЗначениеЗаполнено(ПорядокСтрок) Тогда
		РезультатСравнения.Сортировать(ПорядокСтрок);
	КонецЕсли; 
	Возврат ВсегоРазличий = 0;
	
КонецФункции

Функция СоздатьКолонкиРезультата(ТабличноеПолеРезультата)
	
	ЭтотОбъект.СравниваемыеКолонкиРезультата = Новый Массив;
	ЭтотОбъект.СтруктураКолонокРезультата = Новый Структура;
	ЭтотОбъект.ВыбранныйРезультат = Новый ТаблицаЗначений;
	ЭтотОбъект.РезультатСравнения = Новый ТаблицаЗначений;
	ТабличноеПолеРезультата.Колонки.Очистить();
	РезультатСравнения.Колонки.Добавить(мИмяКолонкиРезультатаСравнения, Новый ОписаниеТипов("Число"));
	РезультатСравнения.Колонки.Добавить(мИмяКолонкиНомераСтрокиРезультата, Новый ОписаниеТипов("Число"));
	КолонкаТабличногоПоля = ТабличноеПолеРезультата.Колонки.Добавить(мИмяКолонкиРезультатаСравнения);
	КолонкаТабличногоПоля.Данные = мИмяКолонкиРезультатаСравнения;
	КолонкаТабличногоПоля.ТекстШапки = "Результат сравнения";
	КолонкиГруппы = КолонкиТаблица1.НайтиСтроки(Новый Структура("Ключевая", Истина));
	ПорядокСтрок = ДобавитьКолонкиТаблицыГруппыРезультата(КолонкиГруппы, "1");
	ДобавитьКолонкиТабличногоПоляГруппыРезультата(КолонкиГруппы, мИмяГруппыКлючевыхКолонок, "Ключевые колонки", , "1", "1", ТабличноеПолеРезультата);
	СоздатьКолонкиСтороныРезультата("1", ТабличноеПолеРезультата);
	СоздатьКолонкиСтороныРезультата("2", ТабличноеПолеРезультата);
	Если ВыводитьРазницуЧисловыхКолонокСравнения Тогда
		КолонкиГруппы = КолонкиТаблица1.НайтиСтроки(Новый Структура("Числовая, Сравнивать", Истина, Истина));
		Для Каждого КолонкаГруппы Из КолонкиГруппы Цикл
			КолонкаИсходнойТаблицы = Таблица1.Колонки[КолонкаГруппы.ИмяКолонки];
			ДобавитьКолонкуТаблицыРезультата(КолонкаГруппы.ИмяКолонки, КолонкаГруппы.ИмяКолонки, КолонкаИсходнойТаблицы, "Разность");
		КонецЦикла;
		ДобавитьКолонкиТабличногоПоляГруппыРезультата(КолонкиГруппы, мИмяГруппыРазностныхКолонок, "Разность числовых колонок", , "Разность", "1", ТабличноеПолеРезультата);
	КонецЕсли;
	ЭтотОбъект.ВыбранныйРезультат = РезультатСравнения;
	ирОбщий.НастроитьДобавленныеКолонкиТабличногоПоляЛкс(ТабличноеПолеРезультата,,,, Истина);
	Возврат ПорядокСтрок;
	
КонецФункции

Процедура СоздатьКолонкиСтороныРезультата(Знач НомерСтороны, Знач ТабличноеПолеРезультата)
	
	// Используем имена сопоставленных колонок от первой стороны
	СопоставленныеНеключевые = КолонкиТаблица1.Выгрузить(Новый Структура("Ключевая", Ложь));
	// Отбросим несопоставленные, т.к. их отдельно выводим
	Отбрасываемые = СопоставленныеНеключевые.НайтиСтроки(Новый Структура("ИмяКолонки2", ""));
	Для Каждого Отбрасываемая Из Отбрасываемые Цикл
		СопоставленныеНеключевые.Удалить(Отбрасываемая);
	КонецЦикла;
	ДобавитьКолонкиТаблицыГруппыРезультата(СопоставленныеНеключевые, НомерСтороны);
	КолонкиГруппы = СопоставленныеНеключевые.НайтиСтроки(Новый Структура("Ключевая, Сравнивать", Ложь, Истина));
	ДобавитьКолонкиТабличногоПоляГруппыРезультата(КолонкиГруппы, мИмяГруппыСравниваемыхКолонок, "Сравниваемые колонки", НомерСтороны, НомерСтороны, НомерСтороны, ТабличноеПолеРезультата);
	Если НомерСтороны = "1" Тогда
		Для Каждого КолонкаГруппы Из КолонкиГруппы Цикл
			СравниваемыеКолонкиРезультата.Добавить(КолонкаГруппы.ИмяКолонки + НомерСтороны);
		КонецЦикла;
	КонецЕсли; 
	КолонкиГруппы = СопоставленныеНеключевые.НайтиСтроки(Новый Структура("Ключевая, Сравнивать", Ложь, Ложь));
	ДобавитьКолонкиТабличногоПоляГруппыРезультата(КолонкиГруппы, мИмяГруппыНесравниваемыхКолонок, "Несравниваемые колонки", НомерСтороны, НомерСтороны, НомерСтороны,
		ТабличноеПолеРезультата);
	// Используем имена несопоставленных колонок от своей стороны
	Если НомерСтороны = "1" Тогда
		КолонкиГруппы = КолонкиТаблица1.НайтиСтроки(Новый Структура("ИмяКолонки2", ""));
		ДобавитьКолонкиТаблицыГруппыРезультата(КолонкиГруппы, НомерСтороны);
		ДобавитьКолонкиТабличногоПоляГруппыРезультата(КолонкиГруппы, мИмяГруппыНесравниваемыхКолонок, "Несопоставленные колонки", НомерСтороны, НомерСтороны, НомерСтороны,
			ТабличноеПолеРезультата);
	КонецЕсли; 
	Если НомерСтороны = "2" Тогда
		КолонкиГруппы = КолонкиТаблица2.НайтиСтроки(Новый Структура("ИмяКолонки1", ""));
		ДобавитьКолонкиТаблицыГруппыРезультата(КолонкиГруппы, НомерСтороны);
		ДобавитьКолонкиТабличногоПоляГруппыРезультата(КолонкиГруппы, мИмяГруппыНесравниваемыхКолонок, "Несопоставленные колонки", НомерСтороны, НомерСтороны, НомерСтороны,
			ТабличноеПолеРезультата);
	КонецЕсли; 

КонецПроцедуры

Функция ДобавитьКолонкиТаблицыГруппыРезультата(Знач КолонкиГруппы, Знач НомерСтороны)
	
	Массив = Новый Массив;
	Для Каждого КолонкаГруппы Из КолонкиГруппы Цикл
		ИмяКолонки = КолонкаГруппы.ИмяКолонки;
		КолонкаИсходнойТаблицы = ЭтотОбъект["Таблица" + НомерСтороны].Колонки[ИмяКолонки];
		ИмяКолонкиРезультата = ДобавитьКолонкуТаблицыРезультата(ИмяКолонки, КолонкаГруппы.ИмяКолонки, КолонкаИсходнойТаблицы, НомерСтороны);
		Массив.Добавить(ИмяКолонкиРезультата);
	КонецЦикла;
	Результат = ирОбщий.ПолучитьСтрокуСРазделителемИзМассиваЛкс(Массив);
	Возврат Результат;

КонецФункции

Функция ДобавитьКолонкуТаблицыРезультата(Знач ИмяКолонкиТаблицыРезультата, Знач ИмяИсходнойКолонки, Знач КолонкаИсходнойТаблицы, Суффикс)
	
	ИмяКолонкиРезультата = ИмяКолонкиТаблицыРезультата + Суффикс;
	РезультатСравнения.Колонки.Добавить(ИмяКолонкиРезультата, КолонкаИсходнойТаблицы.ТипЗначения, КолонкаИсходнойТаблицы.Заголовок + " " + Суффикс,
		КолонкаИсходнойТаблицы.Ширина);
	СтруктураКолонокРезультата.Вставить(ИмяКолонкиРезультата, ИмяИсходнойКолонки);
	Возврат ИмяКолонкиРезультата;

КонецФункции

Процедура ДобавитьКолонкиТабличногоПоляГруппыРезультата(Знач КолонкиГруппы, Знач ИмяГруппы, Знач ЗаголовокГруппы, Знач НомерСтороныГруппы = "", СуффиксКолонки = "",
	Знач НомерСтороныКолонки = "", Знач ТабличноеПолеРезультата)
	
	Если КолонкиГруппы.Количество() > 0 Тогда
		ИмяКолонкиГруппы = ИмяГруппы + НомерСтороныГруппы;
		КолонкаТабличногоПоля = ТабличноеПолеРезультата.Колонки.Найти(ИмяКолонкиГруппы);
		Если КолонкаТабличногоПоля = Неопределено Тогда
			КолонкаТабличногоПоля = ТабличноеПолеРезультата.Колонки.Добавить(ИмяКолонкиГруппы);
		КонецЕсли; 
		Если ЗначениеЗаполнено(НомерСтороныГруппы) Тогда
			ЗаголовокГруппы = ЗаголовокГруппы + " " + НомерСтороныГруппы;
		КонецЕсли; 
		КолонкаТабличногоПоля.ТекстШапки = ЗаголовокГруппы;
		ЭтоПерваяКолонка = Истина;
		Для Каждого КолонкаГруппы Из КолонкиГруппы Цикл
			ИмяКолонкиТаблицыРезультата = КолонкаГруппы.ИмяКолонки + СуффиксКолонки;
			КолонкаТабличногоПоля = ТабличноеПолеРезультата.Колонки.Добавить(ИмяКолонкиТаблицыРезультата);
			КолонкаТабличногоПоля.Данные = ИмяКолонкиТаблицыРезультата;
			КолонкаТабличногоПоля.ТекстШапки = ЭтотОбъект["КолонкиТаблица" + НомерСтороныКолонки].Найти(КолонкаГруппы.ИмяКолонки, "ИмяКолонки").СинонимКолонки;
			Если ЭтоПерваяКолонка Тогда
				КолонкаТабличногоПоля.Положение = ПоложениеКолонки.НаСледующейСтроке;
				ЭтоПерваяКолонка = Ложь;
			Иначе
				КолонкаТабличногоПоля.Положение = ПоложениеКолонки.ВТойЖеКолонке;
			КонецЕсли; 
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

Процедура ВывестиСтрокуРезультата(СтрокаРезультата, СтрокаТаблицы, НомерСтороны)
	
	#Если Сервер И Не Сервер Тогда
	    СтрокаТаблицы = Новый ТаблицаЗначений;
		СтрокаТаблицы = СтрокаТаблицы.Добавить();
	#КонецЕсли
	Если СтрокаРезультата = Неопределено Тогда
		СтрокаРезультата = РезультатСравнения.Добавить();
		СтрокаРезультата[мИмяКолонкиНомераСтрокиРезультата] = РезультатСравнения.Количество();
	КонецЕсли; 
	КолонкиТаблица = ЭтотОбъект["КолонкиТаблица" + НомерСтороны];
	ВыведенныеКолонки = Новый Структура;
	Если НомерСтороны = "2" Тогда
		Для Каждого ВыводимаяКолонка Из КолонкиТаблица1.НайтиСтроки(Новый Структура("Ключевая", Истина)) Цикл
			СтрокаРезультата[ВыводимаяКолонка.ИмяКолонки + "1"] = СтрокаТаблицы[ВыводимаяКолонка.ИмяКолонки2];
			ВыведенныеКолонки.Вставить(ВыводимаяКолонка.ИмяКолонки2);
		КонецЦикла;
	КонецЕсли; 
	Для Каждого ВыводимаяКолонка Из КолонкиТаблица.НайтиСтроки(Новый Структура("Выводить", Истина)) Цикл
		Если ВыведенныеКолонки.Свойство(ВыводимаяКолонка.ИмяКолонки) Тогда
			Продолжить;
		КонецЕсли; 
		СтрокаРезультата[ВыводимаяКолонка.ИмяКолонки + НомерСтороны] = СтрокаТаблицы[ВыводимаяКолонка.ИмяКолонки];
	КонецЦикла;
	
КонецПроцедуры	

// вывод разницы
Процедура ВывестиРазницуЧисел(Знач СтрокаРезультата, Знач РезультатСравненияСтрок);
	
	#Если Сервер И Не Сервер Тогда
	    СтрокаРезультата = Новый ТаблицаЗначений;
		СтрокаРезультата = СтрокаТаблицы.Добавить();
		Строка2 = СтрокаТаблицы.Добавить();
	#КонецЕсли
	КолонкиТаблица = ЭтотОбъект.КолонкиТаблица1;
	Для Каждого ВыводимаяКолонка Из КолонкиТаблица.НайтиСтроки(Новый Структура("Сравнивать", Истина)) Цикл
		Колонка1 = Таблица1.Колонки[ВыводимаяКолонка.ИмяКолонки];
		Колонка2 = Таблица2.Колонки[ВыводимаяКолонка.ИмяКолонки2];
		Если Истина
			И Колонка1.ТипЗначения.СодержитТип(Тип("Число"))
			И Колонка2.ТипЗначения.СодержитТип(Тип("Число"))
		Тогда 
			Если РезультатСравненияСтрок = ПризнакТолько2 Тогда
				ЗначениеЯчейки1 = 0;
			Иначе
				ЗначениеЯчейки1 = СтрокаРезультата[ВыводимаяКолонка.ИмяКолонки + "1"];
			КонецЕсли; 
			Если РезультатСравненияСтрок = ПризнакТолько1 Тогда
				ЗначениеЯчейки2 = 0;
			Иначе
				ЗначениеЯчейки2 = СтрокаРезультата[ВыводимаяКолонка.ИмяКолонки + "2"];
			КонецЕсли; 
			СтрокаРезультата[ВыводимаяКолонка.ИмяКолонки + "Разность"] = ЗначениеЯчейки1 - ЗначениеЯчейки2;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры	

// установка отборов по результатам сравнения
Процедура ОтображениеРезультатаУстановитьОтбор(ТабличноеПолеРезультата, РежимОтбора = "ОтборВсе") Экспорт
	
	Если РежимОтбора = "ОтборВсе" Тогда 
		НужныйПризнак = 0;
	ИначеЕсли РежимОтбора = "ОтборОтличия" Тогда 
		НужныйПризнак = ПризнакНеРавно;	
	ИначеЕсли РежимОтбора = "Отбор1" Тогда 
		НужныйПризнак = ПризнакТолько1;
	ИначеЕсли РежимОтбора = "Отбор2" Тогда 
		НужныйПризнак = ПризнакТолько2;
	КонецЕсли;
	ТекущаяСтрока = ТабличноеПолеРезультата.ТекущаяСтрока;
	Если ТекущаяСтрока <> Неопределено Тогда
		КлючСтаройСтроки = ТекущаяСтрока[мИмяКолонкиНомераСтрокиРезультата];
	КонецЕсли; 
	Если НужныйПризнак = 0 Тогда
		ВыбранныйРезультат = РезультатСравнения;
	Иначе
		ВыбранныйРезультат = РезультатСравнения.Скопировать(Новый Структура(мИмяКолонкиРезультатаСравнения, НужныйПризнак));
	КонецЕсли; 
	Если КлючСтаройСтроки <> Неопределено Тогда
		НоваяТекущаяСтрока = ВыбранныйРезультат.Найти(КлючСтаройСтроки, мИмяКолонкиНомераСтрокиРезультата);
		Если НоваяТекущаяСтрока <> Неопределено Тогда
			ТабличноеПолеРезультата.ТекущаяСтрока = НоваяТекущаяСтрока;
		КонецЕсли; 
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

// цвета по-умолчанию
ОтличаютсяЦветФона 		= WebЦвета.Красный;
ОтличаютсяЦветТекста 	= WebЦвета.Белый;
	
ТолькоВТаблице1ЦветФона 	= WebЦвета.Желтый;
ТолькоВТаблице1ЦветТекста 	= WebЦвета.Черный;

ТолькоВТаблице2ЦветФона 	= WebЦвета.БледноЗеленый;
ТолькоВТаблице2ЦветТекста 	= WebЦвета.Черный;

ПризнакРавно = 1;
ПризнакНеРавно = 2;
ПризнакТолько1 = 3;
ПризнакТолько2 = 4;
НеВыводитьОдинаковыеСтроки = Истина;
ВыводитьРазницуЧисловыхКолонокСравнения = Истина;
РезультатыСравненияСтрок = Новый Соответствие;
РезультатыСравненияСтрок.Вставить(ПризнакРавно, "Равно");
РезультатыСравненияСтрок.Вставить(ПризнакНеРавно, "Не равно");
РезультатыСравненияСтрок.Вставить(ПризнакТолько1, "Только 1");
РезультатыСравненияСтрок.Вставить(ПризнакТолько2, "Только 2");

мИмяГруппыКлючевыхКолонок = "_ГруппаКлючевых9234284"; 
мИмяГруппыСравниваемыхКолонок = "_ГруппаСравниваемых9234284"; 
мИмяГруппыНесравниваемыхКолонок = "_ГруппаНесравниваемых9234284"; 
мИмяГруппыРазностныхКолонок = "_ГруппаРазностных9234284"; 
мИмяКолонкиРезультатаСравнения = "РезультатСравнения9234284";
мИмяКолонкиНомераСтрокиРезультата = "НомерСтрокиРезультата9234284";
#КонецЕсли
