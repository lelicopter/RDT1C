﻿//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирПривилегированный Экспорт;

Перем мПоследнийПрочитанныйОбъект Экспорт;

Процедура ОбработатьИсключениеПоОбъекту(ОбъектБД, ОписаниеОшибки, ВывестиСообщение = Истина) Экспорт 
	
	СтрокаРезультата = РезультатОбработки.Добавить();
	СтрокаРезультата.Порядок = СтрокаРезультата.НомерСтроки;
	СтрокаРезультата.ОписаниеОшибки = ОписаниеОшибки;
	Если ТипЗнч(ОбъектБД)= Тип("Строка") Тогда 
		СтрокаРезультата.XML = ОбъектБД;
		СтрокаРезультата.КлючОбъекта = ОбъектБД;
	Иначе
		//СтрокаРезультата.XML = ирОбщий.СохранитьОбъектВВидеСтрокиXMLЛкс(ОбъектБД, Ложь); // На перерасчетах ЗаписьXML ошибку выдает. Видимо ошибка платформы.
		СтрокаРезультата.XML = ирОбщий.СохранитьОбъектВВидеСтрокиXMLЛкс(ОбъектБД, Истина);
		СтрокаРезультата.КлючОбъекта = ирОбщий.ПолучитьXMLКлючОбъектаБДЛкс(ОбъектБД, Истина);
		Если ТипЗнч(ОбъектБД) = Тип("УдалениеОбъекта") Тогда
			СтрокаРезультата.Таблица = ОбъектБД.Ссылка.Метаданные().ПолноеИмя();
		Иначе
			СтрокаРезультата.Таблица = ОбъектБД.Метаданные().ПолноеИмя();
		КонецЕсли; 
	КонецЕсли;
	Если ВывестиСообщение Тогда
		Сообщить("Ошибка обработки объекта """ + СтрокаРезультата.КлючОбъекта + """: " + ОписаниеОшибки, СтатусСообщения.Внимание);
	КонецЕсли; 
	
КонецПроцедуры

Функция ВыполнитьВыгрузку() Экспорт 

	РезультатОбработки.Очистить();
	ПараметрыОбработки = Новый Структура;
	ПередВыгрузкойВсех(ПараметрыОбработки);
	//ИмяВременногоКаталога = ПолучитьИмяВременногоФайла();
	//СоздатьКаталог(ИмяВременногоКаталога);
	//ФайлДанных = Новый файл(ИмяВременногоКаталога + "\Data.xml");
	//ЗаписьXML = Новый ЗаписьXML;
	//ЗаписьXML.ОткрытьФайл(ФайлДанных.ПолноеИмя);
	//ЗаписьXML.ЗаписатьНачалоЭлемента("IRData");
	//СчетчикВыгруженныхОбъектов = 0;
	КоличествоОбъектов = ирОбщий.ПолучитьКоличествоИзмененийПоУзлуЛкс(УзелВыборкиДанных);
	Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(КоличествоОбъектов, "Выборка");
	ВыборкаОбъектов = ПланыОбмена.ВыбратьИзменения(УзелВыборкиДанных, УзелВыборкиДанных.НомерОтправленного + 1);
	Пока ВыборкаОбъектов.Следующий() Цикл
		ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
		ОбъектБД = ВыборкаОбъектов.Получить();
		ВыгрузитьОбъектБД(ПараметрыОбработки.ЗаписьXML, ОбъектБД, ПараметрыОбработки.СчетчикВыгруженныхОбъектов);
		Если ВыгружатьДвиженияВместеСДокументами Тогда
			ОбъектМД = ОбъектБД.Метаданные();
			Если ирОбщий.ЛиКорневойТипДокументаЛкс(ирОбщий.ПолучитьПервыйФрагментЛкс(ОбъектМД.ПолноеИмя())) Тогда
				ОбъектыМД = ирОбщий.ПолучитьМетаданныеНаборовЗаписейПоРегистраторуЛкс(ОбъектМД);
				Для Каждого МетаРегистр из ОбъектыМД Цикл
					ПолноеИмяМД = МетаРегистр.ПолноеИмя();
					НаборЗаписей = Новый (СтрЗаменить(ПолноеИмяМД, ".", "НаборЗаписей."));
					НаборЗаписей.Отбор.Регистратор.Установить(ОбъектБД.Ссылка);
					НаборЗаписей.Прочитать();
					ВыгрузитьОбъектБД(ПараметрыОбработки.ЗаписьXML, НаборЗаписей, ПараметрыОбработки.СчетчикВыгруженныхОбъектов);
				КонецЦикла;
			КонецЕсли; 
		КонецЕсли;
	КонецЦикла; 
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс(, Истина);
	//ИнфоДанных = Новый Структура;
	//ИнфоДанных.Вставить("КоличествоОбъектов", СчетчикВыгруженныхОбъектов);
	//ИнфоДанных.Вставить("ИспользоватьXDTO", ИспользоватьXDTO);
	//Сообщить("Выгружено объектов " + XMLСтрока(СчетчикВыгруженныхОбъектов));
	//ЗаписьXML.ЗаписатьКонецЭлемента();
	//ЗаписьXML.Закрыть();
	//ФайлИнфо = Новый файл(ИмяВременногоКаталога + "\Info.xml");
	//ЗаписьXML = Новый ЗаписьXML;
	//ЗаписьXML.ОткрытьФайл(ФайлИнфо.ПолноеИмя);
	//СериализаторXDTO.ЗаписатьXML(ЗаписьXML, ИнфоДанных);
	//ЗаписьXML.Закрыть();
	//ЗаписьZIP = Новый ЗаписьZipФайла(ИмяФайла);
	//ЗаписьZIP.Добавить(ФайлДанных.ПолноеИмя);
	//ЗаписьZIP.Добавить(ФайлИнфо.ПолноеИмя);
	//ЗаписьZIP.Записать();
	//УдалитьФайлы(ИмяВременногоКаталога);
	ПослеВыгрузкиВсех(ПараметрыОбработки);
	Возврат Истина;

КонецФункции

Процедура ВыгрузитьОбъектБД(Знач ЗаписьXML, Знач ОбъектБД, СчетчикВыгруженныхОбъектов)
	
	Попытка
		Успех = Истина;
		ирОбщий.СохранитьОбъектВВидеСтрокиXMLЛкс(ОбъектБД, ИспользоватьXDTO,,, ЗаписьXML);
	Исключение
		Успех = Ложь;
		ОбработатьИсключениеПоОбъекту(ОбъектБД, ОписаниеОшибки());
		Если Не ПропускатьОшибки Тогда
			ВызватьИсключение;
		КонецЕсли; 
	КонецПопытки;
	Если Успех Тогда
		СчетчикВыгруженныхОбъектов = СчетчикВыгруженныхОбъектов + 1;
	КонецЕсли; 

КонецПроцедуры // ВыполнитьВыгрузку()

Функция ВыполнитьЗагрузку() Экспорт 

	РезультатОбработки.Очистить();
	ИмяВременногоКаталога = ПолучитьИмяВременногоФайла();
	СоздатьКаталог(ИмяВременногоКаталога);
	ЧтениеZip = Новый ЧтениеZipФайла(ИмяФайла);
	ЧтениеZip.ИзвлечьВсе(ИмяВременногоКаталога);
	ФайлИнфо = Новый файл(ИмяВременногоКаталога + "\Info.xml");
	Если Не ФайлИнфо.Существует() Тогда
		Возврат "Неверный формат файла данных!";
	КонецЕсли; 
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.ОткрытьФайл(ФайлИнфо.ПолноеИмя);
	ИнфоДанных = СериализаторXDTO.ПрочитатьXML(ЧтениеXML);
	ФайлДанных = Новый файл(ИмяВременногоКаталога + "\Data.xml");
	Если Не ФайлИнфо.Существует() Тогда
		Возврат "Неверный формат файла данных!";
	КонецЕсли; 
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.ОткрытьФайл(ФайлДанных.ПолноеИмя);
	ЧтениеXML.Прочитать();
	Если ЧтениеXML.ЛокальноеИмя <> "IRData" Тогда
		ЧтениеXML.Закрыть();
		УдалитьФайлы(ИмяВременногоКаталога);
		Возврат "Неверный формат файла данных!";
	КонецЕсли; 
	ЧтениеXML.Прочитать();
	Сообщить("В файле данных заявлено " + ИнфоДанных.КоличествоОбъектов + " объектов");
	Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(ИнфоДанных.КоличествоОбъектов, "Загрузка");
	СчетчикСчитанныхОбъектов = 0;
	Пока Истина Цикл
		ирОбщий.ОбработатьИндикаторЛкс(Индикатор, СчетчикСчитанныхОбъектов);
		Если ИнфоДанных.ИспользоватьXDTO Тогда
			Если Не СериализаторXDTO.ВозможностьЧтенияXML(ЧтениеXML) Тогда
				Прервать;
			КонецЕсли; 
			ОбъектБД = СериализаторXDTO.ПрочитатьXML(ЧтениеXML);
		Иначе 
			Если Не ВозможностьЧтенияXML(ЧтениеXML) Тогда
				Если ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда 
					ОписаниеОшибки = "Неизвестный тип элемента XML: " + ЧтениеXML.Имя;
					Если Не ПропускатьОшибки Тогда 
						ВызватьИсключение ОписаниеОшибки;
					Иначе
						ОбработатьИсключениеПоОбъекту(ЧтениеXML.Имя, ОписаниеОшибки);
						ЧтениеXML.Пропустить();
						Если ЧтениеXML.ТипУзла = ТипУзлаXML.КонецЭлемента Тогда 
							ЧтениеXML.Прочитать();
						КонецЕсли;
						Продолжить;
					КонецЕсли;
				Иначе
					Прервать;
				КонецЕсли;
			КонецЕсли; 
			ОбъектБД = ПрочитатьXML(ЧтениеXML);
		КонецЕсли;
		СчетчикСчитанныхОбъектов = СчетчикСчитанныхОбъектов + 1;
		#Если Сервер И Не Сервер Тогда
			ОбъектБД = Справочники.ирАлгоритмы.СоздатьЭлемент();
		#КонецЕсли
		Попытка
			Отправитель = ОбъектБД.ОбменДанными.Отправитель;
		Исключение
			// Элемент плана обмена в 8.3.5+
			Отправитель = Неопределено;
		КонецПопытки;
		Если Отправитель <> Неопределено Тогда
			ОбъектБД.ОбменДанными.Отправитель = УзелОтправитель;
		КонецЕсли;
		ЭтотОбъект.мПоследнийПрочитанныйОбъект = ОбъектБД;
		Попытка
			ирОбщий.ЗаписатьОбъектЛкс(ОбъектБД, ЗаписьНаСервере,,, Истина, БезАвторегистрацииИзменений);
			Успех = Истина;
		Исключение
			Успех = Ложь;
			ОбработатьИсключениеПоОбъекту(ОбъектБД, ОписаниеОшибки());
			Если Не ПропускатьОшибки Тогда
				ВызватьИсключение;
			КонецЕсли; 
		КонецПопытки; 
	КонецЦикла;
	ЧтениеXML.Закрыть();
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс(, Истина);
	УдалитьФайлы(ИмяВременногоКаталога);
	ЭтотОбъект.мПоследнийПрочитанныйОбъект = Неопределено;
	Если СчетчикСчитанныхОбъектов <> ИнфоДанных.КоличествоОбъектов Тогда
		Возврат "Считано объектов " + XMLСтрока(СчетчикСчитанныхОбъектов) + " из " + XMLСтрока(ИнфоДанных.КоличествоОбъектов) + " заявленных!";
	КонецЕсли; 
	Возврат Истина;

КонецФункции // ВыполнитьВыгрузку()

Процедура ПередВыгрузкойВсех(Параметры) Экспорт 

	#Если Сервер И Не Сервер Тогда
	    Параметры = Новый Структура;
	#КонецЕсли
	ИмяВременногоКаталога = ПолучитьИмяВременногоФайла();
	СоздатьКаталог(ИмяВременногоКаталога);
	ФайлДанных = Новый файл(ИмяВременногоКаталога + "\Data.xml");
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.ОткрытьФайл(ФайлДанных.ПолноеИмя);
	ЗаписьXML.ЗаписатьНачалоЭлемента("IRData");
	СчетчикВыгруженныхОбъектов = 0;
	Параметры.Вставить("ЗаписьXML", ЗаписьXML);
	Параметры.Вставить("ФайлДанных", ФайлДанных);
	Параметры.Вставить("ИмяВременногоКаталога", ИмяВременногоКаталога);
	Параметры.Вставить("СчетчикВыгруженныхОбъектов", СчетчикВыгруженныхОбъектов);

КонецПроцедуры // ПередГрупповойОбработкой() 

Процедура ПослеВыгрузкиВсех(Параметры) Экспорт 

	#Если Сервер И Не Сервер Тогда
	    Параметры = Новый Структура;
	#КонецЕсли
	ИнфоДанных = Новый Структура;
	ИнфоДанных.Вставить("КоличествоОбъектов", Параметры.СчетчикВыгруженныхОбъектов);
	ИнфоДанных.Вставить("ИспользоватьXDTO", ИспользоватьXDTO);
	Сообщить("Выгружено объектов " + XMLСтрока(Параметры.СчетчикВыгруженныхОбъектов));
	Параметры.ЗаписьXML.ЗаписатьКонецЭлемента();
	Параметры.ЗаписьXML.Закрыть();
	ФайлИнфо = Новый файл(Параметры.ИмяВременногоКаталога + "\Info.xml");
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.ОткрытьФайл(ФайлИнфо.ПолноеИмя);
	СериализаторXDTO.ЗаписатьXML(ЗаписьXML, ИнфоДанных);
	ЗаписьXML.Закрыть();
	ЗаписьZIP = Новый ЗаписьZipФайла(ИмяФайла);
	ЗаписьZIP.Добавить(Параметры.ФайлДанных.ПолноеИмя);
	ЗаписьZIP.Добавить(ФайлИнфо.ПолноеИмя);
	ЗаписьZIP.Записать();
	УдалитьФайлы(Параметры.ИмяВременногоКаталога);

КонецПроцедуры // ПередГрупповойОбработкой() 

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
