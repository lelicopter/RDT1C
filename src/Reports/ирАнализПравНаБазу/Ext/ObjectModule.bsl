﻿//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирКлиент Экспорт;

Перем РежимОтладки Экспорт;
Перем ТаблицаПрав Экспорт; 
Перем РолиМД Экспорт; 

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	#Если _ Тогда
		СхемаКомпоновки = Новый СхемаКомпоновкиДанных;
		КонечнаяНастройка = Новый НастройкиКомпоновкиДанных;
		ВнешниеНаборыДанных = Новый Структура;
		ДокументРезультат = Новый ТабличныйДокумент;
	#КонецЕсли
	СтандартнаяОбработка = Ложь;
	ПрофилиГруппДоступа = Новый ТаблицаЗначений;
	ПрофилиГруппДоступа.Колонки.Добавить("РольИмя", Новый ОписаниеТипов("Строка"));
	ПрофилиГруппДоступа.Колонки.Добавить("ПрофильГруппДоступа", Новый ОписаниеТипов("Строка"));
	ПрофилиГруппДоступа.Колонки.Добавить("КоличествоРолей", Новый ОписаниеТипов("Число"));
	Если Истина
		И ирКэш.НомерВерсииБСПЛкс() >= 200 
		И Метаданные.Справочники.Найти("ПрофилиГруппДоступа") <> Неопределено
	Тогда
		Запрос = Новый Запрос;
		Запрос.Текст =
		"
		|ВЫБРАТЬ
		|	ПрофилиГруппДоступаРоли.Ссылка КАК ПрофильГруппДоступа,
		|	Профили.КоличествоРолей КАК КоличествоРолей,
		|	ПрофилиГруппДоступаРоли.Роль.Имя КАК РольИмя
		|ИЗ
		|	Справочник.ПрофилиГруппДоступа.Роли КАК ПрофилиГруппДоступаРоли
		|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|			ПрофилиГруппДоступа_РолиТ.Ссылка КАК Ссылка,
		|			КОЛИЧЕСТВО(ПрофилиГруппДоступа_РолиТ.Роль) КАК КоличествоРолей
		|		ИЗ
		|			Справочник.ПрофилиГруппДоступа.Роли КАК ПрофилиГруппДоступа_РолиТ
		|		
		|		СГРУППИРОВАТЬ ПО
		|			ПрофилиГруппДоступа_РолиТ.Ссылка) КАК Профили
		|		ПО Профили.Ссылка = ПрофилиГруппДоступаРоли.Ссылка
		|";
		ПрофилиГруппДоступа = Запрос.Выполнить().Выгрузить();
	КонецЕсли; 
	РолиПользователей = Новый ТаблицаЗначений;
	РолиПользователей.Колонки.Добавить("Роль", Новый ОписаниеТипов("Строка"));
	РолиПользователей.Колонки.Добавить("Пользователь", Новый ОписаниеТипов("Строка"));
	Если ПравоДоступа("Администрирование", Метаданные) Тогда
		ДоступныеПользователи = ПользователиИнформационнойБазы.ПолучитьПользователей();
	Иначе
		ДоступныеПользователи = Новый Массив;
		ДоступныеПользователи.Добавить(ПользователиИнформационнойБазы.ТекущийПользователь());
	КонецЕсли; 
	Для Каждого ПользовательИБ Из ДоступныеПользователи Цикл
		#Если Сервер И Не Сервер Тогда
			ПользовательИБ = ПользователиИнформационнойБазы.СоздатьПользователя();
		#КонецЕсли
		Для Каждого РольЦикл Из ПользовательИБ.Роли Цикл
			СтрокаРоли = РолиПользователей.Добавить();
			СтрокаРоли.Роль = РольЦикл.Имя;
			СтрокаРоли.Пользователь = ПользовательИБ.Имя;
		КонецЦикла;
	КонецЦикла;
	ТаблицаРоли = Новый ТаблицаЗначений;
	ТаблицаРоли.Колонки.Добавить("Роль", Новый ОписаниеТипов("Строка"));
	ТаблицаРоли.Колонки.Добавить("УстанавливатьПраваДляНовыхОбъектов");
	ТаблицаРоли.Колонки.Добавить("НезависимыеПраваПодчиненныхОбъектов");
	ТаблицаРоли.Колонки.Добавить("УстанавливатьПраваДляРеквизитовИТабличныхЧастейПоУмолчанию");
	КонечнаяНастройка = КомпоновщикНастроек.ПолучитьНастройки();
	Если ЗначениеЗаполнено(Пользователь) Тогда
		ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(КонечнаяНастройка, "Пользователь", Пользователь,,, Ложь);
	КонецЕсли; 
	Если НаборРолей.Количество() > 0 Тогда
		ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(КонечнаяНастройка, "Роль", НаборРолей,,, Ложь);
	КонецЕсли; 
	ВнешниеНаборыДанных = Новый Структура;
	ВнешниеНаборыДанных.Вставить("ПрофилиГруппДоступа", ПрофилиГруппДоступа);
	ВнешниеНаборыДанных.Вставить("РолиПользователей", РолиПользователей);
	ВнешниеНаборыДанных.Вставить("Роли", ТаблицаРоли);
	ВнешниеНаборыДанных.Вставить("Таблица", ТаблицаПрав);
	ВнешниеНаборыДанных.Вставить("Права", ВыбранныеПрава());
	Если РежимОтладки = 2 Тогда
		ирОбщий.ОтладитьЛкс(СхемаКомпоновкиДанных, , КонечнаяНастройка, ВнешниеНаборыДанных);
		Возврат;
	КонецЕсли; 
	ДокументРезультат.Очистить();
	ирОбщий.СкомпоноватьВТабличныйДокументЛкс(СхемаКомпоновкиДанных, КонечнаяНастройка, ДокументРезультат, ВнешниеНаборыДанных, ДанныеРасшифровки);
	
КонецПроцедуры

Функция ВычислитьПрава(Параметры) Экспорт 
	ИменаРолей = Параметры.ИменаРолей;  
	КонечныеНастройки = Параметры.КонечныеНастройки; 
	РолиМД = Новый Массив;
	Для Каждого ИмяРоли Из ИменаРолей Цикл
		РолиМД.Добавить(Метаданные.Роли[ИмяРоли]);
	КонецЦикла;
	ИнициироватьТаблицуПрав();
	ДоступныеПрава = ВыбранныеПрава();
	#Если Сервер И Не Сервер Тогда
		ДоступныеПрава = Новый ТаблицаЗначений;
		КонечныеНастройки = Новый НастройкиКомпоновкиДанных;
	#КонецЕсли
	мПлатформа = ирКэш.Получить();
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	Для Каждого ДоступноеПраво Из ДоступныеПрава Цикл
		ПравоДоступа = ДоступноеПраво.Право;
		Для Каждого РольЦикл Из РолиМД Цикл
			Право = ПравоДоступа;
			ПрерватьЦикл = Ложь;
			ПараметрыДоступа = ПравоДоступа(Право, Метаданные, РольЦикл);
			Если ПараметрыДоступа Тогда
				Доступ = "да";
			Иначе
				Доступ = "нет";
			КонецЕсли; 
			СтрокаТаблицы = ТаблицаПрав.Добавить();
			СтрокаТаблицы.Роль = РольЦикл.Имя;
			СтрокаТаблицы.Право = ПравоДоступа;
			СтрокаТаблицы.Доступ = Доступ;
		КонецЦикла;
	КонецЦикла; 
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	Результат = Новый Структура;
	Результат.Вставить("ТаблицаПрав", ТаблицаПрав);
	Результат.Вставить("КонечныеНастройки", КонечныеНастройки);
	Возврат Результат;
КонецФункции

Процедура ИнициироватьТаблицуПрав()
	
	ТаблицаПрав = Новый ТаблицаЗначений;
	ТаблицаПрав.Колонки.Добавить("Роль", Новый ОписаниеТипов("Строка"));
	ТаблицаПрав.Колонки.Добавить("Право", Новый ОписаниеТипов("Строка"));
	ТаблицаПрав.Колонки.Добавить("Доступ", Новый ОписаниеТипов("Строка"));

КонецПроцедуры

Функция ВыбранныеПрава(ВВидеТаблицы = Истина, _ДобавитьПустоеЗначение = Ложь) Экспорт 
	
	ТаблицаДоступныхОбщихПрав = ТаблицаДоступныхОбщихПрав();
	Результат = Новый СписокЗначений;
	Для Каждого СтрокаПрава Из ТаблицаДоступныхОбщихПрав Цикл
		Результат.Добавить(СтрокаПрава.Имя, ирОбщий.ПредставлениеЗначенияСОграничениемДлиныЛкс(СтрокаПрава.Представление));
	КонецЦикла;
	Результат.СортироватьПоПредставлению();
	Если ВВидеТаблицы Тогда
		РезультатТаблица = Новый ТаблицаЗначений;
		РезультатТаблица.Колонки.Добавить("Право");
		РезультатТаблица.Колонки.Добавить("ПравоПредставление");
		Для Каждого ЭлементСписка Из Результат Цикл
			СтрокаТаблицы = РезультатТаблица.Добавить();
			СтрокаТаблицы.Право = ЭлементСписка.Значение;
			СтрокаТаблицы.ПравоПредставление = ЭлементСписка.Представление;
		КонецЦикла;
		Результат = РезультатТаблица;
	КонецЕсли;
	Возврат Результат;

КонецФункции

Функция ТаблицаДоступныхОбщихПрав() Экспорт 
	
	ТаблицаДоступныхОбщихПрав = ирКэш.ВсеВидыПравДоступаЛкс().Скопировать(Новый Структура("Применение", "Конфигурация"));
	Возврат ТаблицаДоступныхОбщихПрав;

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

РежимОтладки = 0;
ИнициироватьТаблицуПрав();