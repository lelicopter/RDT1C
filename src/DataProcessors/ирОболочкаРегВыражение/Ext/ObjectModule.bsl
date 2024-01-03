﻿//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирКлиент Экспорт;

Перем ТекущийДвижок;
Перем Вычислитель;
Перем ТипВхождения;
Перем ВхождениеОбразец;
Перем ЧтениеJSON;
Перем СтарыйGlobal;
Перем СтарыйIgnoreCase;
Перем СтарыйMultiline;
Перем СтарыйPattern;
Перем ДоступныеДвижкиСтруктура;

// Искать вхождения.
//
// Параметры:
//  ТекстГдеИскать			 - 	 - 
//  ТолькоПоследнее			 - 	 - 
//  РазрешитьЧужуюКоллекцию	 - Булево - для ускорения
//  выхЧислоВхождений		 - 	 - 
// 
// Возвращаемое значение:
//   Массив - Вхождения, позиции указаны начиная с 0
//
Функция НайтиВхождения(Знач ТекстГдеИскать, ТолькоПоследнее = Ложь, РазрешитьЧужуюКоллекцию = Ложь, выхЧислоВхождений = 0, выхДлительность = Неопределено) Экспорт 
	Вхождения = Новый Массив;
	//Если ТекстГдеИскать = Неопределено Тогда
	//	ТекстГдеИскать = "";
	//КонецЕсли; 
	Если ПустаяСтрока(ТекстГдеИскать) Тогда
		Возврат Вхождения;
	КонецЕсли;
	выхЧислоВхождений = 0;
	Если ТекущийДвижок = "VBScript" Тогда
		Если выхДлительность <> Неопределено Тогда
			МоментНачала = ирОбщий.ТекущееВремяВМиллисекундахЛкс();
		КонецЕсли;
		РезультатПоиска = Вычислитель().Execute(ТекстГдеИскать);
		Если выхДлительность <> Неопределено Тогда
			выхДлительность = ирОбщий.ТекущееВремяВМиллисекундахЛкс() - МоментНачала;
		КонецЕсли;
		выхЧислоВхождений = РезультатПоиска.Count;
		Если выхЧислоВхождений > 0 Тогда
			Если ТолькоПоследнее Тогда
				Вхождения.Добавить(РезультатПоиска.Item(РезультатПоиска.Count - 1));
			Иначе 
				Если РазрешитьЧужуюКоллекцию Тогда
					Вхождения = РезультатПоиска;
				Иначе
					Для каждого Элемент из РезультатПоиска Цикл // ОбработкаОбъект.ирОболочкаРегВхождение
						Вхождения.Добавить(Элемент);
					КонецЦикла;
				КонецЕсли;
			КонецЕсли; 
		КонецЕсли; 
	ИначеЕсли ТекущийДвижок = "1С" Тогда
		Если выхДлительность <> Неопределено Тогда
			МоментНачала = ирОбщий.ТекущееВремяВМиллисекундахЛкс();
		КонецЕсли;
		РезультатПоиска = Вычислить("СтрНайтиВсеПоРегулярномуВыражению(ТекстГдеИскать, Pattern, IgnoreCase, Multiline)");
		Если выхДлительность <> Неопределено Тогда
			выхДлительность = ирОбщий.ТекущееВремяВМиллисекундахЛкс() - МоментНачала;
		КонецЕсли;
		#Если Сервер И Не Сервер Тогда
			РезультатПоиска = СтрНайтиВсеПоРегулярномуВыражению();
		#КонецЕсли
		выхЧислоВхождений = РезультатПоиска.Количество();
		Если выхЧислоВхождений > 0 Тогда
			Если ТипВхождения = Неопределено Тогда
				ВхождениеОбразец = ирОбщий.СоздатьОбъектПоИмениМетаданныхЛкс("Обработка.ирОболочкаРегВхождение");
				ТипВхождения = ТипЗнч(ВхождениеОбразец); // Надо удерживать ВхождениеОбразец, чтобы для внешней обработки ТипВхождения не разрушался
			КонецЕсли; 
			Если ТолькоПоследнее Тогда
				Элемент = РезультатПоиска[выхЧислоВхождений - 1];
				РезультатПоиска = Новый Массив;
				РезультатПоиска.Добавить(Элемент);
			КонецЕсли; 
			Для каждого Элемент из РезультатПоиска Цикл
				Вхождение = Новый (ТипВхождения);
				#Если Сервер И Не Сервер Тогда
					Вхождение = Обработки.ирОболочкаРегВхождение.Создать();
				#КонецЕсли
				Вхождение.FirstIndex = Элемент.НачальнаяПозиция - 1;
				Вхождение.Length = Элемент.Длина;
				Вхождение.Value = Элемент.Значение;
				Группы = Новый Массив;
				_РежимОтладки = Ложь;
				Если _РежимОтладки Тогда // Можно менять на Истина в точке останова, например условием ирОбщий.Пр(_РежимОтладки, 1, 1)
					// Пассивный оригинал расположенного ниже однострочного кода. Выполняйте изменения синхронно в обоих вариантах.
					Для Каждого Группа Из Элемент.ПолучитьГруппы() Цикл
						Если Группа.НачальнаяПозиция = 0 Тогда
							Группы.Добавить(Неопределено);
						Иначе
							Группы.Добавить(Группа.Значение);
						КонецЕсли;
					КонецЦикла;
				Иначе
					// Однострочный код использован для ускорения при разрешенной отладке. Выше расположен оригинал. Выполняйте изменения синхронно в обоих вариантах. Преобразовано консолью кода из подсистемы "Инструменты разработчика"
					Для Каждого Группа Из Элемент.ПолучитьГруппы() Цикл  					Если Группа.НачальнаяПозиция = 0 Тогда  						Группы.Добавить(Неопределено);  					Иначе  						Группы.Добавить(Группа.Значение);  					КонецЕсли;  				КонецЦикла;  
				КонецЕсли;
				Вхождение.SubMatches = Группы;
				Вхождения.Добавить(Вхождение);
			КонецЦикла;
		КонецЕсли; 
	Иначе
		Если выхДлительность <> Неопределено Тогда
			МоментНачала = ирОбщий.ТекущееВремяВМиллисекундахЛкс();
		КонецЕсли;
		Попытка
			РезультатJSON = Вычислитель().MatchesJSON(ТекстГдеИскать);
		Исключение
			ВызватьИсключение Вычислитель().ОписаниеОшибки;
		КонецПопытки;
		Если выхДлительность <> Неопределено Тогда
			выхДлительность = ирОбщий.ТекущееВремяВМиллисекундахЛкс() - МоментНачала;
		КонецЕсли;
		Если ЗначениеЗаполнено(РезультатJSON) Тогда
			УстановитьПривилегированныйРежим(Истина);
			Если ТипВхождения = Неопределено Тогда
				ВхождениеОбразец = ирОбщий.СоздатьОбъектПоИмениМетаданныхЛкс("Обработка.ирОболочкаРегВхождение");
				ТипВхождения = ТипЗнч(ВхождениеОбразец); // Надо удерживать ВхождениеОбразец, чтобы для внешней обработки ТипВхождения не разрушался
			КонецЕсли;    
			Если ЧтениеJSON = Неопределено Тогда
				ЧтениеJSON = Вычислить("Новый ЧтениеJSON"); //
				#Если Сервер И Не Сервер Тогда
					ЧтениеJSON = Новый ЧтениеJSON;
				#КонецЕсли
			КонецЕсли;
			ЧтениеJSON.УстановитьСтроку(РезультатJSON);
			Коллекция = Вычислить("ПрочитатьJSON(ЧтениеJSON, Ложь)"); // 8.3
			#Если Сервер И Не Сервер Тогда
				Коллекция = Новый Массив;
			#КонецЕсли 
			выхЧислоВхождений = Коллекция.Количество();
			Если выхЧислоВхождений > 0 Тогда
				Если ТолькоПоследнее Тогда
					Элемент = Коллекция[выхЧислоВхождений - 1];
					Коллекция = Новый Массив;
					Коллекция.Добавить(Элемент);
				КонецЕсли; 
				Для Каждого Элемент Из Коллекция Цикл
					Вхождение = Новый (ТипВхождения);
					#Если Сервер И Не Сервер Тогда
						Вхождение = Обработки.ирОболочкаРегВхождение.Создать();
					#КонецЕсли
					ЗаполнитьЗначенияСвойств(Вхождение, Элемент, "FirstIndex, Length, SubMatches, Value"); 
					Вхождения.Добавить(Вхождение);
				КонецЦикла;
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 
	Возврат Вхождения;
КонецФункции

// Replace
Функция Заменить(Знач ТекстГдеИскать, Знач ШаблонЗамены) Экспорт 
	Если ПустаяСтрока(ТекстГдеИскать) Тогда
		Возврат ТекстГдеИскать;
	КонецЕсли;
	Если ТекущийДвижок = "1С" Тогда
		Результат = Вычислить("СтрЗаменитьПоРегулярномуВыражению(ТекстГдеИскать, Pattern, ШаблонЗамены, IgnoreCase, Multiline)");
	ИначеЕсли ТекущийДвижок = "VBScript" Тогда
		Результат = Вычислитель().Replace(ТекстГдеИскать, ШаблонЗамены);
	Иначе
		Попытка
			Результат = Вычислитель().Replace(ТекстГдеИскать,, ШаблонЗамены);
		Исключение
			// После номера группы обязательно делать не цифру. Тогда будет работать одинаково в VBScript и PCRE2. Например вместо "$152" делать "$1 52", иначе PCRE2 будет читать "ссылка на группу 152"
			ВызватьИсключение Вычислитель().ОписаниеОшибки;
		КонецПопытки;
	КонецЕсли; 
	Возврат Результат;
КонецФункции

// Test
Функция Проверить(Знач ТекстГдеИскать) Экспорт 
	Если ТекстГдеИскать = Неопределено Тогда
		ТекстГдеИскать = "";
	КонецЕсли; 
	Если ТекущийДвижок = "VBScript" Тогда
		Результат = Вычислитель().Test(ТекстГдеИскать);
	Иначе
		Результат = Вычислитель().Test(ТекстГдеИскать);
	КонецЕсли;
	Возврат Результат;
КонецФункции

Функция КоличествоПодгрупп(Вхождение) Экспорт 
	Если ТипЗнч(Вхождение.SubMatches) = Тип("Массив") Тогда
		Результат = Вхождение.SubMatches.Количество();
	Иначе
		Результат = Вхождение.SubMatches.Count;
	КонецЕсли;
	Возврат Результат; 
КонецФункции

Функция ДоступенPCRE2() Экспорт 
	
	Возврат ирКэш.НомерВерсииПлатформыЛкс() >= 803006;

КонецФункции

Функция ДоступенVBScript() Экспорт 
	
	Возврат ирКэш.ЛиПлатформаWindowsЛкс();

КонецФункции

Функция Доступен1СВычислитель() Экспорт 
	
	Возврат ирКэш.НомерВерсииПлатформыЛкс() >= 803023;

КонецФункции

Функция ДоступныеДвижки(ВернутьСтруктуру = Ложь) Экспорт 
	
	Если ВернутьСтруктуру И ДоступныеДвижкиСтруктура <> Неопределено Тогда
		Возврат ДоступныеДвижкиСтруктура;
	КонецЕсли; 
	Список = Новый СписокЗначений;
	Если Доступен1СВычислитель() Тогда
		Список.Добавить("1С");
	КонецЕсли; 
	Если ДоступенPCRE2() Тогда
		// https://www.pcre.org/current/doc/html
		// https://github.com/alexkmbk/RegEx1CAddin
		Список.Добавить("PCRE2"); 
	КонецЕсли; 
	Если ДоступенVBScript() Тогда
		Список.Добавить("VBScript");
	КонецЕсли; 
	Если ВернутьСтруктуру Тогда
		ДоступныеДвижкиСтруктура = Новый Структура;
		Для Каждого ЭлементСписка Из Список Цикл
			ДоступныеДвижкиСтруктура.Вставить(ЭлементСписка.Значение, ЭлементСписка.Значение);
		КонецЦикла;
		Список = ДоступныеДвижкиСтруктура;
	КонецЕсли; 
	Возврат Список;

КонецФункции

Функция ТекущийДвижок() Экспорт 
	
	Возврат ТекущийДвижок;

КонецФункции

Функция УстановитьДвижок(НовыйДвижок) Экспорт 
	
	Если ТекущийДвижок = НовыйДвижок Тогда
		Возврат Истина;
	КонецЕсли; 
	Если НовыйДвижок = "PCRE2" Тогда
		Если ДоступенPCRE2() Тогда
			ТекущийДвижок = НовыйДвижок;
		КонецЕсли; 
	ИначеЕсли НовыйДвижок = "VBScript" Тогда
		Если ДоступенVBScript() Тогда
			ТекущийДвижок = НовыйДвижок;
		КонецЕсли; 
	ИначеЕсли НовыйДвижок = "1С" Тогда
		Если Доступен1СВычислитель() Тогда
			ТекущийДвижок = НовыйДвижок;
		КонецЕсли; 
	КонецЕсли;
	Если ТекущийДвижок = НовыйДвижок Тогда
		СтарыйGlobal = Неопределено;
		СтарыйIgnoreCase = Неопределено;
		СтарыйMultiline = Неопределено;
		СтарыйPattern = Неопределено;
		Вычислитель = Неопределено;
	КонецЕсли; 
	Возврат ТекущийДвижок = НовыйДвижок;
	
КонецФункции

Функция Вычислитель()
	Если Вычислитель = Неопределено Тогда
		Если ТекущийДвижок = "VBScript" Тогда
			Вычислитель = Новый COMОбъект("VBScript.RegExp");
		Иначе
			мПлатформа = ирКэш.Получить();
			#Если Сервер И Не Сервер Тогда
				мПлатформа = Обработки.ирПлатформа.Создать();
			#КонецЕсли
			Вычислитель = мПлатформа.ПолучитьОбъектВнешнейКомпонентыИзМакета("RegEx", "AddIn.ВычислительРегВыражений.RegEx", "ВычислительРегВыражений", ТипВнешнейКомпоненты.Native);
			Вычислитель.ВызыватьИсключения = Истина;
		КонецЕсли; 
	КонецЕсли; 
	// Ускорение
	Если СтарыйGlobal <> Global Тогда
		Вычислитель.Global = Global;
		СтарыйGlobal = Global;
	КонецЕсли; 
	Если СтарыйIgnoreCase <> IgnoreCase Тогда 
		Вычислитель.IgnoreCase = IgnoreCase;
		СтарыйIgnoreCase = IgnoreCase;
	КонецЕсли; 
	Если СтарыйMultiline <> Multiline Тогда 
		Вычислитель.Multiline = Multiline;
		СтарыйMultiline = Multiline;
	КонецЕсли; 
	Если СтарыйPattern <> Pattern Тогда
		Вычислитель.Pattern = Pattern;
		СтарыйPattern = Pattern;
	КонецЕсли;
	Возврат Вычислитель;
КонецФункции

Функция НоваяТаблицаВхождений() Экспорт 
	//ТаблицаВхождений = Новый ТаблицаЗначений;
	//ТаблицаВхождений.Колонки.Добавить("Номер", Новый ОписаниеТипов("Число"));
	//ТаблицаВхождений.Колонки.Добавить("ТекстВхождения", Новый ОписаниеТипов("Строка"));
	//ТаблицаВхождений.Колонки.Добавить("ПозицияВхождения", Новый ОписаниеТипов("Число"));
	//ТаблицаВхождений.Колонки.Добавить("ДлинаВхождения", Новый ОписаниеТипов("Число"));
	мПлатформа = ирКэш.Получить();
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	ТаблицаВхождений = мПлатформа.ВхожденияРегВыражения.ВыгрузитьКолонки();
	ТаблицаВхождений.Колонки.Удалить("Номер");
	ТаблицаВхождений.Колонки.Удалить(ирОбщий.ПеревестиСтроку("НомерСтроки"));
	ТаблицаВхождений.Колонки.Удалить("Подгруппы");
	
	ТаблицаВхождений.Колонки.Добавить("Подгруппы");
	Возврат ТаблицаВхождений;
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
//ирПортативный ирОбщий = ирПортативный.ОбщийМодульЛкс("ирОбщий");
//ирПортативный ирКэш = ирПортативный.ОбщийМодульЛкс("ирКэш");
//ирПортативный ирСервер = ирПортативный.ОбщийМодульЛкс("ирСервер");
//ирПортативный ирКлиент = ирПортативный.ОбщийМодульЛкс("ирКлиент");

IgnoreCase = Истина;
Если ДоступенPCRE2() Тогда
	ТекущийДвижок = "PCRE2";
КонецЕсли; 
Если Доступен1СВычислитель() Тогда
	ТекущийДвижок = "1С";
КонецЕсли; 
#Если Клиент Тогда
Если ДоступенVBScript() Тогда
	ТекущийДвижок = "VBScript";
КонецЕсли; 
#КонецЕсли 
//ТекущийДвижок = "1С"; // для отладки
