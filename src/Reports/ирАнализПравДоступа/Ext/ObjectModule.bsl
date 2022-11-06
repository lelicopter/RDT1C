﻿//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирПривилегированный Экспорт;

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
	Если ИзвлечьСвойстваРолей Тогда
		мПлатформа = ирКэш.Получить();
		#Если Сервер И Не Сервер Тогда
			мПлатформа = Обработки.ирПлатформа.Создать();
		#КонецЕсли
		Для Каждого МетаРоль Из РолиМД Цикл
			ФайлРоли = мПлатформа.ФайлРоли(МетаРоль.Имя);
			#Если Сервер И Не Сервер Тогда
				ФайлРоли = Новый Файл;
			#КонецЕсли
			Если Не ФайлРоли.Существует() Тогда
				Сообщить("В кэше ролей не обнаружен файл роли """ + МетаРоль.Имя + """. Для извлечения недоступных в объектной модели свойств этой роли необходимо обновить кэш ролей.");
				Продолжить;
			КонецЕсли; 
			СтрокаРоли = ТаблицаРоли.Добавить();
			СтрокаРоли.Роль = МетаРоль.Имя;
			ЧтениеXML = Новый ЧтениеXML;
			ЧтениеXML.ОткрытьФайл(ФайлРоли.ПолноеИмя);
			ЧтениеXML.Прочитать();
			Для Счетчик = 1 По 3 Цикл
				ЧтениеXML.Прочитать();
				Если ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
					Если ЧтениеXML.ЛокальноеИмя = "setForNewObjects" Тогда
						ЧтениеXML.Прочитать();
						СтрокаРоли.УстанавливатьПраваДляНовыхОбъектов = Булево(ЧтениеXML.Значение);
					ИначеЕсли ЧтениеXML.ЛокальноеИмя = "setForAttributesByDefault" Тогда
						ЧтениеXML.Прочитать();
						СтрокаРоли.НезависимыеПраваПодчиненныхОбъектов = Булево(ЧтениеXML.Значение);
					ИначеЕсли ЧтениеXML.ЛокальноеИмя = "independentRightsOfChildObjects" Тогда
						ЧтениеXML.Прочитать();
						СтрокаРоли.УстанавливатьПраваДляРеквизитовИТабличныхЧастейПоУмолчанию = Булево(ЧтениеXML.Значение);
					КонецЕсли; 
					ЧтениеXML.Прочитать();
				КонецЕсли; 
			КонецЦикла;
		КонецЦикла;
	КонецЕсли; 
	Если ВычислятьФункциональныеОпции Тогда
		ФункциональныеОпции.Очистить();
		Для Каждого ФункциональнаяОпция Из Метаданные.ФункциональныеОпции Цикл
			Попытка
				ЗначениеОпции = ПолучитьФункциональнуюОпцию(ФункциональнаяОпция.Имя);
			Исключение
				// Опция с параметрами
				Продолжить;
			КонецПопытки; 
			СтрокаТаблицы = ФункциональныеОпции.Добавить();
			СтрокаТаблицы.ФункциональнаяОпция = ФункциональнаяОпция.Имя;
			СтрокаТаблицы.ФункциональнаяОпцияВключена = ЗначениеОпции;
		КонецЦикла;
	КонецЕсли; 
	КонечнаяНастройка = КомпоновщикНастроек.ПолучитьНастройки();
	Если ЗначениеЗаполнено(Пользователь) Тогда
		ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(КонечнаяНастройка, "Пользователь", Пользователь,,, Ложь);
	КонецЕсли; 
	Если ЗначениеЗаполнено(ОбъектМетаданных) Тогда
		ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(КонечнаяНастройка, "ОбъектМетаданных", ОбъектМетаданных, ВидСравненияКомпоновкиДанных.Содержит,, Ложь);
	КонецЕсли; 
	Если НаборРолей.Количество() > 0 Тогда
		ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(КонечнаяНастройка, "Роль", НаборРолей,,, Ложь);
	КонецЕсли; 
	ВнешниеНаборыДанных = Новый Структура;
	ВнешниеНаборыДанных.Вставить("ПрофилиГруппДоступа", ПрофилиГруппДоступа);
	ВнешниеНаборыДанных.Вставить("РолиПользователей", РолиПользователей);
	ВнешниеНаборыДанных.Вставить("Роли", ТаблицаРоли);
	ВнешниеНаборыДанных.Вставить("Таблица", ТаблицаПрав);
	ВнешниеНаборыДанных.Вставить("ОбъектыМетаданных", ОбъектыМетаданных);
	ВнешниеНаборыДанных.Вставить("ТабличныеЧасти", ТабличныеЧасти);
	ВнешниеНаборыДанных.Вставить("ПоляМетаданных", ПоляМетаданных);
	ВнешниеНаборыДанных.Вставить("ФункциональныеОпции", ФункциональныеОпции);
	ВнешниеНаборыДанных.Вставить("ФункциональныеОпцииПолей", ФункциональныеОпцииПолей);
	ВнешниеНаборыДанных.Вставить("Права", ДоступныеПрава());
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
	ФункциональныеОпцииПолей.Очистить();
	ОбъектыМетаданных.Очистить();
	ТабличныеЧасти.Очистить();
	ПоляМетаданных.Очистить();
	РолиМД = Новый Массив;
	Для Каждого ИмяРоли Из ИменаРолей Цикл
		РолиМД.Добавить(Метаданные.Роли[ИмяРоли]);
	КонецЦикла;
	ИнициироватьТаблицуПрав();
	ДоступныеПрава = ДоступныеПрава();
	#Если Сервер И Не Сервер Тогда
		ДоступныеПрава = Новый ТаблицаЗначений;
		КонечныеНастройки = Новый НастройкиКомпоновкиДанных;
	#КонецЕсли
	ОтборПоДоступу = ирОбщий.НайтиЭлементОтбораЛкс(КонечныеНастройки.Отбор, "Доступ",,,,, Истина);
	ДоступныеПрава = ирОбщий.ОтобратьТаблицуЗначенийКомпоновкойЛкс(ДоступныеПрава, КонечныеНастройки,, Истина); 
	ПраваСсылочные = Новый Структура;
	ПраваСсылочные.Вставить("Чтение");
	ПраваСсылочные.Вставить("Просмотр");
	ПраваСсылочные.Вставить("Добавление");
	ПраваСсылочные.Вставить("ИнтерактивноеДобавление");
	ПраваСсылочные.Вставить("Изменение");
	ПраваСсылочные.Вставить("Редактирование");
	ПраваСсылочные.Вставить("Удаление");
	ПраваСсылочные.Вставить("ИнтерактивноеУдаление");
	ПраваРегистры = Новый Структура;
	ПраваРегистры.Вставить("Чтение");
	ПраваРегистры.Вставить("Просмотр");
	ПраваРегистры.Вставить("Изменение");
	ПраваРегистры.Вставить("Редактирование");
	ПраваРегистры.Вставить("УправлениеИтогами");
	ПраваПоследовательность = Новый Структура;
	ПраваПоследовательность.Вставить("Чтение");
	ПраваПоследовательность.Вставить("Изменение");
	ПраваКонстанты = Новый Структура;
	ПраваКонстанты.Вставить("Чтение");
	ПраваКонстанты.Вставить("Просмотр");
	ПраваКонстанты.Вставить("Изменение");
	ПраваКонстанты.Вставить("Редактирование");
	ПраваЖурналы = Новый Структура;
	ПраваЖурналы.Вставить("Чтение");
	ПраваЖурналы.Вставить("Просмотр");
	ПраваНехранимые = Новый Структура;
	ПраваНехранимые.Вставить("Использование");
	ПраваНехранимые.Вставить("Просмотр");
	мПлатформа = ирКэш.Получить();
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	ТипыМетаданных = ирКэш.ТипыМетаОбъектов(Истина, Ложь, Ложь);
	СтрокаТипаВнешнегоИсточникаДанных = мПлатформа.ОписаниеТипаМетаОбъектов("ВнешнийИсточникДанных");
	КоллекцияКорневыхТипов = Новый Массив;
	Для Каждого СтрокаТипаМетаданных Из ТипыМетаданных Цикл
		КоллекцияКорневыхТипов.Добавить(СтрокаТипаМетаданных.Единственное);
	КонецЦикла; 
	Если ирКэш.НомерРежимаСовместимостиЛкс() >= 802013 Тогда
		Для Каждого МетаВнешнийИсточникДанных Из Метаданные.ВнешниеИсточникиДанных Цикл
			КоллекцияКорневыхТипов.Добавить(МетаВнешнийИсточникДанных.ПолноеИмя());
		КонецЦикла; 
	КонецЕсли; 
	ИндикаторТиповМетаданных = ирОбщий.ПолучитьИндикаторПроцессаЛкс(КоллекцияКорневыхТипов.Количество(), "Объекты. Типы метаданных");
	Для Каждого КорневойТип Из КоллекцияКорневыхТипов Цикл
		ирОбщий.ОбработатьИндикаторЛкс(ИндикаторТиповМетаданных);
		СтрокаТипаМетаданных = мПлатформа.ОписаниеТипаМетаОбъектов(КорневойТип);
		Если СтрокаТипаМетаданных = Неопределено Тогда
			СтрокаТипаМетаданных = СтрокаТипаВнешнегоИсточникаДанных;
			ОбъектМДКорневогоТипа = ирКэш.ОбъектМДПоПолномуИмениЛкс(КорневойТип);
			КоллекцияМетаОбъектов = ОбъектМДКорневогоТипа.Таблицы;
			ЕстьДоступ = ПравоДоступа("Использование", ОбъектМДКорневогоТипа);
			ЛиКорневойТипСсылочный = Истина;
			ЛиКорневойТипРегистра = Истина;
			ЛиКорневойТипНехранимый = Ложь;
			ЛиКорневойТипЖурнала = Ложь;
			ЛиКорневойТипКонстанта = Ложь;
		Иначе
			Попытка
				КоллекцияМетаОбъектов = Метаданные[СтрокаТипаМетаданных.Множественное];
			Исключение
				Продолжить;
			КонецПопытки;
			Если Ложь
				Или ирОбщий.ЛиКорневойТипПеречисленияЛкс(КорневойТип) 
				Или ирОбщий.ЛиКорневойТипВнешнегоИсточникаДанныхЛкс(КорневойТип)
			Тогда
				Продолжить;
			КонецЕсли; 
			ЛиКорневойТипСсылочный = ирОбщий.ЛиКорневойТипСсылкиЛкс(КорневойТип);
			ЛиКорневойТипРегистра = ирОбщий.ЛиКорневойТипРегистраБДЛкс(КорневойТип);
			ЛиКорневойТипПоследовательности = ирОбщий.ЛиКорневойТипПоследовательностиЛкс(КорневойТип);
			ЛиКорневойТипЖурнала = ирОбщий.ЛиКорневойТипЖурналаДокументовЛкс(КорневойТип);
			ЛиКорневойТипКонстанта = ирОбщий.ЛиКорневойТипКонстантыЛкс(КорневойТип);
			ЛиКорневойТипНехранимый = Не ЛиКорневойТипСсылочный И Не ЛиКорневойТипРегистра И Не ЛиКорневойТипЖурнала И Не ЛиКорневойТипКонстанта;
			Если Истина
				И ЛиКорневойТипНехранимый
				И КорневойТип <> "HTTPСервис"
				И КорневойТип <> "WebСервис"
				И КорневойТип <> "Интерфейс"
				И КорневойТип <> "КритерийОтбора"
				И КорневойТип <> "Отчет"
				И КорневойТип <> "Обработка"
				И КорневойТип <> "ОбщаяКоманда"
				И КорневойТип <> "ОбщаяФорма"
				И КорневойТип <> "ОбщийРеквизит"
				И КорневойТип <> "ПараметрСеанса"
				И КорневойТип <> "Подсистема"
			Тогда
				Продолжить;
			КонецЕсли;
			ЕстьДоступ = Истина;
		КонецЕсли; 
		Если ЗначениеЗаполнено(ПолеОбъекта) Тогда
			ИмяПоляТипаМетаданных = ПолеОбъекта;
		ИначеЕсли ЛиКорневойТипСсылочный Или ЛиКорневойТипЖурнала Тогда
			ИмяПоляТипаМетаданных = "Ссылка";
		ИначеЕсли ЛиКорневойТипРегистра Тогда
			ИмяПоляТипаМетаданных = "Период";
		Иначе
			ИмяПоляТипаМетаданных = Неопределено;
		КонецЕсли; 
		ИндикаторОбъектов = ирОбщий.ПолучитьИндикаторПроцессаЛкс(КоллекцияМетаОбъектов.Количество(), СтрокаТипаМетаданных.Множественное);
		Для Каждого МетаОбъект Из КоллекцияМетаОбъектов Цикл
			#Если Сервер И Не Сервер Тогда
				МетаОбъект = Метаданные.Обработки.ирАнализЖурналаРегистрации;
			#КонецЕсли
			Если СтрокаТипаМетаданных = СтрокаТипаВнешнегоИсточникаДанных Тогда
				ЛиКорневойТипСсылочный = ирОбщий.ЛиМетаданныеСсылочногоОбъектаЛкс(МетаОбъект);
				ЛиКорневойТипРегистра = Не ЛиКорневойТипСсылочный;
			КонецЕсли; 
			ирОбщий.ОбработатьИндикаторЛкс(ИндикаторОбъектов);
			ПолноеИмяОбъектаМД = МетаОбъект.ПолноеИмя();
			ТабличныеЧастиЦикл = Новый Массив;
			Если Истина
				И Не ИспользоватьНаборПолей
				И ЗначениеЗаполнено(ОбъектМетаданных) 
			Тогда
				Если ОбъектМетаданных <> ПолноеИмяОбъектаМД Тогда
					Продолжить;
				КонецЕсли;
				Если Не ЗначениеЗаполнено(ПолеОбъекта) Тогда
					СтруктураТабличныхЧастей = ирОбщий.ТабличныеЧастиОбъектаЛкс(МетаОбъект);
					#Если Сервер И Не Сервер Тогда
						СтруктураТабличныхЧастей = Новый Структура;
					#КонецЕсли
					Для Каждого КлючИЗначение Из СтруктураТабличныхЧастей Цикл
						ТабличныеЧастиЦикл.Добавить(КлючИЗначение.Ключ);
					КонецЦикла;
				КонецЕсли; 
			ИначеЕсли ИспользоватьНаборПолей Тогда
				ТабличныеЧастиЦикл = НаборПолейТаблица.Выгрузить(Новый Структура("ОбъектМДПолноеИмя", ПолноеИмяОбъектаМД)).ВыгрузитьКолонку("ТабличнаяЧасть");
				Если ТабличныеЧастиЦикл.Количество() = 0 Тогда
					Продолжить;
				КонецЕсли; 
			КонецЕсли;
			Если КорневойТип = "HTTPСервис" Тогда
				#Если Сервер И Не Сервер Тогда
					МетаОбъект = Метаданные.HTTPСервисы.task1;
				#КонецЕсли
				Для Каждого ШаблонСервиса Из МетаОбъект.ШаблоныURL Цикл
					Для Каждого МетодШаблона Из ШаблонСервиса.Методы Цикл
						#Если Сервер И Не Сервер Тогда
							МетодШаблона = МетаОбъект.ШаблоныURL.ШаблонURL1.Методы.Метод1;
						#КонецЕсли
						ПолноеИмяШаблона = МетодШаблона.ПолноеИмя();
						СтрокаМД = ОбъектыМетаданных.Добавить();
						СтрокаМД.ОбъектМетаданных = ПолноеИмяШаблона;
						СтрокаМД.Представление = МетодШаблона.Представление();
						СтрокаМД.ТипМетаданных = КорневойТип;
						Для Каждого ДоступноеПраво Из ДоступныеПрава Цикл
							ПравоДоступа = ДоступноеПраво.Право;
							Для Каждого РольЦикл Из РолиМД Цикл
								Попытка
									ЕстьДоступ = ПравоДоступа(ПравоДоступа, МетодШаблона, РольЦикл);
								Исключение
									Прервать;
								КонецПопытки;
								СтрокаТаблицы = ТаблицаПрав.Добавить();
								СтрокаТаблицы.ОбъектМетаданных = ПолноеИмяШаблона;
								СтрокаТаблицы.ОбъектМД = МетодШаблона;
								СтрокаТаблицы.Роль = РольЦикл.Имя;
								СтрокаТаблицы.Право = ПравоДоступа;
								СтрокаТаблицы.Доступ = Нрег(ЕстьДоступ);
							КонецЦикла;
						КонецЦикла;
					КонецЦикла;
				КонецЦикла;
				Продолжить;
			ИначеЕсли КорневойТип = "WebСервис" Тогда
				#Если Сервер И Не Сервер Тогда
					МетаОбъект = Метаданные.WebСервисы.WebСервис1;
				#КонецЕсли
				Для Каждого ОперацияСервиса Из МетаОбъект.Операции Цикл
					#Если Сервер И Не Сервер Тогда
						ОперацияСервиса = МетаОбъект.Операции.Операция1;
					#КонецЕсли
					ПолноеИмяОперации = ОперацияСервиса.ПолноеИмя();
					СтрокаМД = ОбъектыМетаданных.Добавить();
					СтрокаМД.ОбъектМетаданных = ПолноеИмяОперации;
					СтрокаМД.Представление = ОперацияСервиса.Представление();
					СтрокаМД.ТипМетаданных = КорневойТип;
					Для Каждого ДоступноеПраво Из ДоступныеПрава Цикл
						ПравоДоступа = ДоступноеПраво.Право;
						Для Каждого РольЦикл Из РолиМД Цикл
							Попытка
								ЕстьДоступ = ПравоДоступа(ПравоДоступа, ОперацияСервиса, РольЦикл);
							Исключение
								Прервать;
							КонецПопытки;
							СтрокаТаблицы = ТаблицаПрав.Добавить();
							СтрокаТаблицы.ОбъектМетаданных = ПолноеИмяОперации;
							СтрокаТаблицы.ОбъектМД = ОперацияСервиса;
							СтрокаТаблицы.Роль = РольЦикл.Имя;
							СтрокаТаблицы.Право = ПравоДоступа;
							СтрокаТаблицы.Доступ = Нрег(ЕстьДоступ);
						КонецЦикла;
					КонецЦикла;
				КонецЦикла;
				Продолжить;
			КонецЕсли;
			#Если Сервер И Не Сервер Тогда
				МетаОбъект = Метаданные.Справочники.ирАлгоритмы;
			#КонецЕсли
			Если Не ИспользоватьНаборПолей И Не ЗначениеЗаполнено(ПолеОбъекта) Тогда
				Попытка
					МетаКоманды = МетаОбъект.Команды;
				Исключение
					МетаКоманды = Новый Массив;
				КонецПопытки;
				Для Каждого МетаКоманда Из МетаКоманды Цикл
					#Если Сервер И Не Сервер Тогда
						МетаКоманда = МетаОбъект.Команды.Команда1;
					#КонецЕсли
					ПолноеИмяКоманды = МетаКоманда.ПолноеИмя();
					СтрокаМД = ОбъектыМетаданных.Добавить();
					СтрокаМД.ОбъектМетаданных = ПолноеИмяКоманды;
					СтрокаМД.Представление = МетаКоманда.Представление();
					СтрокаМД.ТипМетаданных = КорневойТип;
					Для Каждого ДоступноеПраво Из ДоступныеПрава Цикл
						ПравоДоступа = ДоступноеПраво.Право;
						Для Каждого РольЦикл Из РолиМД Цикл
							Попытка
								ЕстьДоступ = ПравоДоступа(ПравоДоступа, МетаКоманда, РольЦикл);
							Исключение
								Прервать;
							КонецПопытки;
							СтрокаТаблицы = ТаблицаПрав.Добавить();
							СтрокаТаблицы.ОбъектМетаданных = ПолноеИмяКоманды;
							СтрокаТаблицы.ОбъектМД = МетаКоманда;
							СтрокаТаблицы.Роль = РольЦикл.Имя;
							СтрокаТаблицы.Право = ПравоДоступа;
							СтрокаТаблицы.Доступ = Нрег(ЕстьДоступ);
						КонецЦикла;
					КонецЦикла;
				КонецЦикла;
			КонецЕсли;
			ТабличныеЧастиЦикл.Добавить("");
			СтрокаМД = ОбъектыМетаданных.Добавить();
			СтрокаМД.ОбъектМетаданных = ПолноеИмяОбъектаМД;
			СтрокаМД.Представление = МетаОбъект.Представление();
			СтрокаМД.ТипМетаданных = КорневойТип;
			Для Каждого ИмяТЧ Из ТабличныеЧастиЦикл Цикл
				ТЧ_МД = МетаОбъект;
				ПолноеИмяТЧ_МД = ПолноеИмяОбъектаМД;
				Если ЗначениеЗаполнено(ИмяТЧ) Тогда
					ПолноеИмяТЧ_МД = ПолноеИмяТЧ_МД + "." + ИмяТЧ;
					ТЧ_МД = МетаОбъект.ТабличныеЧасти[ИмяТЧ];
				КонецЕсли; 
				Если ВычислятьФункциональныеОпции Тогда
					// Добавим фиктивную строку для проверки функциональных опций на сам объект
					СтрокаТаблицы = ТаблицаПрав.Добавить();
					СтрокаТаблицы.ОбъектМетаданных = ПолноеИмяОбъектаМД;
					СтрокаТаблицы.ОбъектМД = МетаОбъект;
					СтрокаТаблицы.ТабличнаяЧасть = ИмяТЧ;
				КонецЕсли;
				ПоляТаблицыБД = Неопределено;
				ПоляТЧ = Новый Массив;
				Если ЛиКорневойТипНехранимый Тогда 
					ПоляТЧ.Добавить("");
				ИначеЕсли Истина
					И Не ИспользоватьНаборПолей
					И ЗначениеЗаполнено(ОбъектМетаданных) 
				Тогда
					ПоляТаблицы = ирКэш.ПоляТаблицыБДЛкс(ПолноеИмяТЧ_МД);
					Для Каждого СтрокаПоля Из ПоляТаблицы Цикл
						Если Ложь
							Или ЗначениеЗаполнено(ПолеОбъекта) И СтрокаПоля.Имя <> ПолеОбъекта
							Или СтрокаПоля.ТипЗначения.СодержитТип(Тип("ТаблицаЗначений")) 
							Или (Истина
								И ЗначениеЗаполнено(ИмяТЧ)
								И (Ложь
									Или СтрокаПоля.Имя = "Ссылка"
									Или СтрокаПоля.Имя = "НомерСтроки"))
						Тогда
							Продолжить;
						КонецЕсли; 
						ПоляТЧ.Добавить(СтрокаПоля.Имя);
					КонецЦикла;
					ПоляТаблицыБД = ПоляТаблицыБД(ПолноеИмяОбъектаМД, ИмяТЧ);
				ИначеЕсли ИспользоватьНаборПолей Тогда
					ПоляТЧ = НаборПолейТаблица.Выгрузить(Новый Структура("ОбъектМДПолноеИмя, ТабличнаяЧасть", ПолноеИмяОбъектаМД, ИмяТЧ)).ВыгрузитьКолонку("Поле");
					Если ПоляТЧ.Количество() = 0 Тогда
						Продолжить;
					КонецЕсли;
					ПоляТаблицыБД = ПоляТаблицыБД(ПолноеИмяОбъектаМД, ИмяТЧ);
				ИначеЕсли Не ЗначениеЗаполнено(ИмяТЧ) Тогда
					ПоляТЧ.Добавить(ИмяПоляТипаМетаданных);
				КонецЕсли;
				//ПоляТЧ.Добавить("");
				Если ЗначениеЗаполнено(ИмяТЧ) Тогда
					СтрокаМД = ТабличныеЧасти.Добавить();
					СтрокаМД.ОбъектМетаданных = ПолноеИмяОбъектаМД;
					СтрокаМД.ТабличнаяЧасть = ИмяТЧ;
					СтрокаМД.Представление = ТЧ_МД.Представление();
				КонецЕсли; 
				Для Каждого ИмяПоляОбъекта Из ПоляТЧ Цикл
					Если ПоляТаблицыБД <> Неопределено И ЗначениеЗаполнено(ИмяПоляОбъекта) Тогда
						СтрокаМД = ПоляМетаданных.Добавить();
						СтрокаМД.ОбъектМетаданных = ПолноеИмяОбъектаМД;
						СтрокаМД.ТабличнаяЧасть = ИмяТЧ;
						СтрокаМД.Поле = ИмяПоляОбъекта;
						ПолеТаблицыБД = ПоляТаблицыБД.Найти(ИмяПоляОбъекта);
						СтрокаМД.Представление = ПолеТаблицыБД.Заголовок;  
						Если ВычислятьФункциональныеОпции Тогда
							СтрокаМД.ПросмотрТипов = ирОбщий.ЛиЕстьПравоПросмотраТиповЛкс(ПолеТаблицыБД.ТипЗначения);
							СтрокаМД.ОписаниеТипов = ирОбщий.ПредставлениеТипаЛкс(ПолеТаблицыБД.ТипЗначения.Типы()[0], ПолеТаблицыБД.ТипЗначения, Истина);
						КонецЕсли;
					КонецЕсли;
					Для Каждого ДоступноеПраво Из ДоступныеПрава Цикл
						ПравоДоступа = ДоступноеПраво.Право;
						Если Ложь
							Или ЛиКорневойТипСсылочный И Не ПраваСсылочные.Свойство(ПравоДоступа) 
							Или ЛиКорневойТипРегистра И Не ПраваРегистры.Свойство(ПравоДоступа) 
							Или ЛиКорневойТипЖурнала И Не ПраваЖурналы.Свойство(ПравоДоступа) 
							Или ЛиКорневойТипКонстанта И Не ПраваКонстанты.Свойство(ПравоДоступа) 
							Или ЛиКорневойТипПоследовательности И Не ПраваПоследовательность.Свойство(ПравоДоступа) 
							Или (Истина
								И ЛиКорневойТипНехранимый 
								И Не ПраваНехранимые.Свойство(ПравоДоступа)
								И Не (КорневойТип = "ОбщийРеквизит" И ПравоДоступа = "Редактирование")
								И Не (КорневойТип = "ОбщаяФорма" И ПравоДоступа = "Использование"))
						Тогда
							Продолжить;
						КонецЕсли; 
						//ИндикаторРолей = ирОбщий.ПолучитьИндикаторПроцессаЛкс(Метаданные.Роли.Количество(), "Роли");
						Для Каждого РольЦикл Из РолиМД Цикл
							Право = ПравоДоступа;
							ПрерватьЦикл = Ложь;
							ИмяПоляВместеСТЧ = ИмяПоляОбъекта;
							Если ЗначениеЗаполнено(ИмяТЧ) Тогда
								ИмяПоляВместеСТЧ = ИмяТЧ + "." + ИмяПоляОбъекта;
							КонецЕсли; 
							Если ЛиКорневойТипНехранимый Тогда
								ПроверяемыйОбъект = ТЧ_МД;
								Если ЗначениеЗаполнено(ИмяПоляОбъекта) Тогда
									ПроверяемыйОбъект = ТЧ_МД.Реквизиты[ИмяПоляОбъекта];
								КонецЕсли; 
								Попытка
									ПараметрыДоступа = ПравоДоступа(Право, ПроверяемыйОбъект, РольЦикл);
								Исключение
									Прервать;
								КонецПопытки;
							Иначе
								Попытка
									ПараметрыДоступа = ПараметрыДоступа(Право, МетаОбъект, ИмяПоляВместеСТЧ, РольЦикл);
								Исключение
									Если Ложь
										Или ЗначениеЗаполнено(ПолеОбъекта) 
										Или ЗначениеЗаполнено(ИмяТЧ)
									Тогда
										ПрерватьЦикл = Истина;
									Иначе
										ИмяПоляОбъекта = "";
										ПараметрыДоступа = ирОбщий.ПараметрыДоступаКОбъектуМДЛкс(Право, МетаОбъект, РольЦикл, ПрерватьЦикл, ИмяПоляОбъекта);
									КонецЕсли; 
									Если ПрерватьЦикл Тогда
										Прервать;
									КонецЕсли; 
								КонецПопытки;
							КонецЕсли; 
							Если ТипЗнч(ПараметрыДоступа) = Тип("Булево") Тогда
								Если ПараметрыДоступа Тогда
									Доступ = "да";
								Иначе
									Доступ = "нет";
								КонецЕсли; 
							ИначеЕсли ПараметрыДоступа.Доступность Тогда
								Если ПараметрыДоступа.ОграничениеУсловием Тогда
									Доступ = "да ограничено";
								Иначе
									Доступ = "да";
								КонецЕсли;
							Иначе
								Доступ = "нет";
							КонецЕсли;
							Если Истина
								И ОтборПоДоступу <> Неопределено
								И Не ирОбщий.ЛиЗначениеПроходитЭлементОтбораЛкс(ОтборПоДоступу, Доступ)
							Тогда
								Продолжить;
							КонецЕсли; 
							СтрокаТаблицы = ТаблицаПрав.Добавить();
							СтрокаТаблицы.ОбъектМетаданных = ПолноеИмяОбъектаМД;
							СтрокаТаблицы.ОбъектМД = МетаОбъект;
							СтрокаТаблицы.ТабличнаяЧасть = ИмяТЧ;
							СтрокаТаблицы.Поле = ИмяПоляОбъекта;
							//ДочернийОбъектМД = ирОбщий.ДочернийОбъектМДПоИмениЛкс(МетаОбъект, ИмяПоляОбъекта, КорневойТип);
							//Если ДочернийОбъектМД <> Неопределено Тогда
							//	СтрокаТаблицы.ПолеПолноеИмя = ДочернийОбъектМД.ПолноеИмя();
							//КонецЕсли; 
							СтрокаТаблицы.Роль = РольЦикл.Имя;
							СтрокаТаблицы.Право = ПравоДоступа;
							СтрокаТаблицы.Доступ = Доступ;
						КонецЦикла;
					КонецЦикла; 
					//ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
				КонецЦикла;
			КонецЦикла;
		КонецЦикла;
		ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	КонецЦикла;
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	Если ВычислятьФункциональныеОпции Тогда
		ОпцииОбъектовМД = ирКэш.ФункциональныеОпцииОбъектовМДЛкс();
		ДобавленныеОбъектыМД = Новый Соответствие;
		ИменаГруппировок = "ОбъектМД, ТабличнаяЧасть, Поле";
		ПолныеИменаПолей = ТаблицаПрав.Скопировать(, ИменаГруппировок);
		ПолныеИменаПолей.Свернуть(ИменаГруппировок);
		Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(ПолныеИменаПолей.Количество(), "Функциональные опции");
		Для Каждого СтрокаПоля Из ПолныеИменаПолей Цикл
			ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
			РодительскийОбъектМД = СтрокаПоля.ОбъектМД;
			Если ЗначениеЗаполнено(СтрокаПоля.ТабличнаяЧасть) Тогда
				ТЧ_МД = РодительскийОбъектМД.ТабличныеЧасти.Найти(СтрокаПоля.ТабличнаяЧасть);
				Если ТЧ_МД <> Неопределено Тогда
					РодительскийОбъектМД = ТЧ_МД;
				КонецЕсли; 
			КонецЕсли; 
			ДочернийОбъектМД = Неопределено;
			Если ЗначениеЗаполнено(СтрокаПоля.Поле) Тогда
				ДочернийОбъектМД = ирОбщий.ДочернийОбъектМДПоИмениЛкс(РодительскийОбъектМД, СтрокаПоля.Поле);
			КонецЕсли;
			Если ДочернийОбъектМД <> Неопределено Тогда
				ОбъектМД = ДочернийОбъектМД;
				ПрямоеНазначение = Истина;
			Иначе
				Если ЗначениеЗаполнено(СтрокаПоля.Поле) Тогда
					Продолжить;
				КонецЕсли; 
				ОбъектМД = РодительскийОбъектМД;
				ПрямоеНазначение = Ложь;
			КонецЕсли;
			ПолноеИмяМД = ОбъектМД.ПолноеИмя();
			Если ОбъектМД = СтрокаПоля.ОбъектМД Тогда
				ПолноеИмяКорневогоМД = ПолноеИмяМД;
			Иначе
				ПолноеИмяКорневогоМД = СтрокаПоля.ОбъектМД.ПолноеИмя();
			КонецЕсли; 
			Для Каждого СтрокаОпции Из ОпцииОбъектовМД.НайтиСтроки(Новый Структура("ИмяОбъектаМД", ПолноеИмяМД)) Цикл
				СтрокаТаблицы = ФункциональныеОпцииПолей.Добавить();
				СтрокаТаблицы.ФункциональнаяОпция = СтрокаОпции.ИмяОпции;
				СтрокаТаблицы.ПолеПолноеИмя = ПолноеИмяКорневогоМД + "." + СтрокаПоля.ТабличнаяЧасть + "." + СтрокаПоля.Поле;
				СтрокаТаблицы.ПрямоеНазначение = ПрямоеНазначение = ЗначениеЗаполнено(СтрокаПоля.Поле);
				//ДобавленыСтроки = Истина;
			КонецЦикла;
			//Если Не ДобавленыСтроки Тогда
			//	// Если объект не входит в функциональные опции
			//	СтрокаТаблицы = ФункциональныеОпцииПолей.Добавить();
			//	СтрокаТаблицы.ФункциональнаяОпция = "";
			//	СтрокаТаблицы.ПолеПолноеИмя = СтрокаПоля.ПолеПолноеИмя;
			//	СтрокаТаблицы.ПрямоеНазначение = ПрямоеНазначение = ЗначениеЗаполнено(СтрокаПоля.Поле);
			//КонецЕсли;
		КонецЦикла;
		ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	КонецЕсли; 
	ТаблицаПрав.Колонки.Удалить("ОбъектМД");
	Результат = Новый Структура;
	Результат.Вставить("ТаблицаПрав", ТаблицаПрав);
	Результат.Вставить("ОбъектыМетаданных", ОбъектыМетаданных.Выгрузить());
	Результат.Вставить("ТабличныеЧасти", ТабличныеЧасти.Выгрузить());
	Результат.Вставить("ПоляМетаданных", ПоляМетаданных.Выгрузить());
	Результат.Вставить("ФункциональныеОпцииПолей", ФункциональныеОпцииПолей.Выгрузить());
	Результат.Вставить("КонечныеНастройки", КонечныеНастройки);
	Возврат Результат;
КонецФункции

Процедура ИнициироватьТаблицуПрав()
	
	ТаблицаПрав = Новый ТаблицаЗначений;
	ТаблицаПрав.Колонки.Добавить("ОбъектМетаданных", Новый ОписаниеТипов("Строка"));
	ТаблицаПрав.Колонки.Добавить("ОбъектМД"); // Удалим перед возвращением результата
	ТаблицаПрав.Колонки.Добавить("Поле", Новый ОписаниеТипов("Строка"));
	ТаблицаПрав.Колонки.Добавить("ТабличнаяЧасть", Новый ОписаниеТипов("Строка"));
	ТаблицаПрав.Колонки.Добавить("Роль", Новый ОписаниеТипов("Строка"));
	ТаблицаПрав.Колонки.Добавить("Право", Новый ОписаниеТипов("Строка"));
	ТаблицаПрав.Колонки.Добавить("Доступ", Новый ОписаниеТипов("Строка"));

КонецПроцедуры

Функция ПоляТаблицыБД(Знач ПолноеИмяОбъектаМД, Знач ИмяТЧ)
	
	ПолноеИмяТаблицыБД = ПолноеИмяОбъектаМД;
	Если ЗначениеЗаполнено(ИмяТЧ) Тогда
		ПолноеИмяТаблицыБД = ПолноеИмяТаблицыБД + "." + ИмяТЧ;
	КонецЕсли; 
	ПоляТаблицыБД = ирКэш.ПоляТаблицыБДЛкс(ПолноеИмяТаблицыБД);
	Возврат ПоляТаблицыБД;

КонецФункции

Функция ДоступныеПрава(ВВидеТаблицы = Истина, ДобавитьПустоеЗначение = Ложь) Экспорт 
	
	Результат = Новый СписокЗначений;
	Если ДобавитьПустоеЗначение Тогда
		Результат.Добавить("", "");
	КонецЕсли; 
	Результат.Добавить("Чтение", "0.Чтение");
	Результат.Добавить("Просмотр", "1.Просмотр");
	Результат.Добавить("Добавление", "2.Добавление");
	Результат.Добавить("ИнтерактивноеДобавление", "3.Интерактивное Добавление");
	Результат.Добавить("Изменение", "4.Изменение");
	Результат.Добавить("Редактирование", "5.Интерактивное изменение");
	Результат.Добавить("Удаление", "6.Удаление");
	Результат.Добавить("ИнтерактивноеУдаление", "7.Интерактивное Удаление");
	Результат.Добавить("Использование", "8.Использование");
	Результат.Добавить("УправлениеИтогами", "9.Управление итогами");
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

РежимОтладки = 0;
ИнициироватьТаблицуПрав();