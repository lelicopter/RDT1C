﻿Перем СтарыйРасширенныеПредставления;

Функция СохраняемаяНастройкаФормы(выхНаименование, выхИменаСвойств) Экспорт 
	выхИменаСвойств = "Реквизит.ТипОбъектов, Реквизит.РасширенныеПредставления, Форма.Авторасшифровка";
	НастройкаКомпоновки = КомпоновщикНастроек.ПолучитьНастройки();
	выхНаименование = ТипОбъектов;
	ПредставлениеОтбора = "" + НастройкаКомпоновки.Отбор;
	Если ЗначениеЗаполнено(ПредставлениеОтбора) Тогда
		выхНаименование = выхНаименование + ", " + ПредставлениеОтбора;
	КонецЕсли; 
	Результат = Новый Структура;
	Результат.Вставить("НастройкаКомпоновки", НастройкаКомпоновки);
	Возврат Результат;
КонецФункции

Процедура ЗагрузитьНастройкуВФорме(НастройкаФормы, ДопПараметры) Экспорт 
	
	#Если Сервер И Не Сервер Тогда
		НастройкаФормы = Новый Структура;
	#КонецЕсли
	ирОбщий.ЗагрузитьНастройкуФормыЛкс(ЭтаФорма, НастройкаФормы);
	Если НастройкаФормы <> Неопределено И НастройкаФормы.Свойство("НастройкаКомпоновки") Тогда
		КомпоновщикНастроек.ЗагрузитьНастройки(НастройкаФормы.НастройкаКомпоновки);
	КонецЕсли; 
	НастроитьКомпоновщик(КомпоновщикНастроек.Настройки.Структура.Количество() = 0);
	
КонецПроцедуры

Процедура ТабличныйДокументОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры)
	
	ирОбщий.ОтчетКомпоновкиОбработкаРасшифровкиЛкс(ЭтаФорма, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры, Элемент, ДанныеРасшифровки, Авторасшифровка);
	
КонецПроцедуры

Процедура ОбработкаРасшифровки(ДанныеРасшифровки, ЭлементРасшифровки, ТабличныйДокумент, ДоступныеДействия, СписокДополнительныхДействий, РазрешитьАвтовыборДействия, ЗначенияВсехПолей) Экспорт 
	
	#Если Сервер И Не Сервер Тогда
		ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
		ЭлементРасшифровки = ДанныеРасшифровки.Элементы[0];
		ТабличныйДокумент = Новый ТабличныйДокумент;
		ДоступныеДействия = Новый Массив;
		СписокДополнительныхДействий = Новый СписокЗначений;
	#КонецЕсли
	ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.Отфильтровать);
	ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.Оформить);
	ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.Сгруппировать);
	ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.Упорядочить);
	ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.Расшифровать);
	ЗначенияПолей = ЭлементРасшифровки.ПолучитьПоля();
	Если Ложь
		Или ЗначенияПолей.Найти("ПолноеИмя") <> Неопределено 
		Или ЗначенияПолей.Найти("ОбъектМД") <> Неопределено
	Тогда 
		СписокДополнительныхДействий.Вставить(0, "ОткрытьВФорме", "Открыть в форме",, ирКэш.КартинкаИнструментаЛкс("Обработка.ирИнтерфейснаяПанель"));
		СписокДополнительныхДействий.Вставить(0, "ОткрытьВКонфигураторе", "Открыть в конфигураторе",, ирКэш.КартинкаПоИмениЛкс("ирКонфигуратор1С8"));
		СписокДополнительныхДействий.Вставить(0, "ОткрытьВИсследователе", "Исследовать",, ирКэш.КартинкаИнструментаЛкс("Обработка.ирИсследовательОбъектов"));
	ИначеЕсли ЗначенияПолей.Найти("ПолноеИмяРодителя") <> Неопределено Тогда 
		СписокДополнительныхДействий.Вставить(0, "ОткрытьРодителяВФорме", "Открыть родителя в форме",, ирКэш.КартинкаИнструментаЛкс("Обработка.ирИнтерфейснаяПанель"));
		СписокДополнительныхДействий.Вставить(0, "ОткрытьРодителяВКонфигураторе", "Открыть родителя в конфигураторе",, ирКэш.КартинкаПоИмениЛкс("ирКонфигуратор1С8"));
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДействиеРасшифровки(ВыбранноеДействие, ПараметрВыбранногоДействия, СтандартнаяОбработка) Экспорт
	
	Перем Пользователь;
	#Если Сервер И Не Сервер Тогда
	    ПараметрВыбранногоДействия = Новый Соответствие;
	#КонецЕсли
	Если ВыбранноеДействие = "ОткрытьВФорме" Тогда
		ОбъектМД = ОбъектМДИзПараметровДействия(ПараметрВыбранногоДействия);
		Если ОбъектМД <> Неопределено Тогда
			Попытка
				ПолноеИмя = ОбъектМД.ПолноеИмя();
			Исключение
				ПолноеИмя = "";
			КонецПопытки;
			Если ЗначениеЗаполнено(ПолноеИмя) Тогда
				ирОбщий.ОткрытьОбъектМетаданныхЛкс(ПолноеИмя);
			КонецЕсли; 
		КонецЕсли; 
	ИначеЕсли ВыбранноеДействие = "ОткрытьВКонфигураторе" Тогда
		ОбъектМД = ОбъектМДИзПараметровДействия(ПараметрВыбранногоДействия);
		Если ОбъектМД <> Неопределено Тогда
			Попытка
				ПолноеИмя = ОбъектМД.ПолноеИмя();
			Исключение
				ПолноеИмя = "";
			КонецПопытки;
			Если ЗначениеЗаполнено(ПолноеИмя) Тогда
				ирОбщий.ПерейтиКОбъектуМетаданныхВКонфигуратореЛкс(ПолноеИмя);
			КонецЕсли; 
		КонецЕсли; 
	ИначеЕсли ВыбранноеДействие = "ОткрытьВИсследователе" Тогда
		ОбъектМД = ОбъектМДИзПараметровДействия(ПараметрВыбранногоДействия);
		Если ОбъектМД <> Неопределено Тогда
			ирОбщий.ИсследоватьЛкс(ОбъектМД);
		КонецЕсли; 
	ИначеЕсли ВыбранноеДействие = "ОткрытьРодителяВФорме" Тогда
		ПолноеИмя = ПараметрВыбранногоДействия["ПолноеИмяРодителя"];
		ирОбщий.ОткрытьОбъектМетаданныхЛкс(ПолноеИмя);
	ИначеЕсли ВыбранноеДействие = "ОткрытьРодителяВКонфигураторе" Тогда
		ПолноеИмя = ПараметрВыбранногоДействия["ПолноеИмяРодителя"];
		ирОбщий.ПерейтиКОбъектуМетаданныхВКонфигуратореЛкс(ПолноеИмя);
	КонецЕсли; 
	
КонецПроцедуры

Функция ОбъектМДИзПараметровДействия(Знач ПараметрВыбранногоДействия)
	
	ОбъектМД = ПараметрВыбранногоДействия["ОбъектМД"];
	Если ОбъектМД = Неопределено Тогда
		ПолноеИмя = ПараметрВыбранногоДействия["ПолноеИмя"];
		ОбъектМД = Метаданные.НайтиПоПолномуИмени(ПолноеИмя);
	КонецЕсли;
	Возврат ОбъектМД;

КонецФункции

Процедура ПриОткрытии()
	
	ирОбщий.Форма_ПриОткрытииЛкс(ЭтаФорма);
	мПлатформа = ирКэш.Получить();
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	мПлатформа.ИнициализацияОписанияМетодовИСвойств();
	ирОбщий.СоздатьМенеджерСохраненияНастроекФормыЛкс(ЭтаФорма);

КонецПроцедуры

Процедура КнопкаВариантаНастроек(Кнопка)
	
	ЗагрузитьВариант(Кнопка.Имя);
	
КонецПроцедуры

Процедура ЗагрузитьВариант(Знач ИмяВарианта) 
	
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.ВариантыНастроек[ИмяВарианта].Настройки);

КонецПроцедуры

Функция РеквизитыОбработки(Параметры) Экспорт 
	
	Результат = ирОбщий.РеквизитыОбработкиЛкс(ЭтотОбъект);
	#Если Сервер И Не Сервер Тогда
		Результат = Новый Структура;
	#КонецЕсли
	Результат.Вставить("мОбъекты", мОбъекты);
	Результат.Вставить("мКолонкиРасширенногоПредставления", мКолонкиРасширенногоПредставления);
	Возврат Результат;
	
КонецФункции

Процедура ДействияФормыСформировать(Кнопка = Неопределено) Экспорт 
	
	РежимОтладки = 0;
	Если Ложь
		Или ТипОбъектов <> СтарыйТипОбъектов 
		Или РасширенныеПредставления <> СтарыйРасширенныеПредставления
	Тогда
		#Если Сервер И Не Сервер Тогда
			СобратьОбъектыМетаданных();
			СобратьОбъектыМДЗавершение();
		#КонецЕсли
		ирОбщий.ВыполнитьЗаданиеФормыЛкс("СобратьОбъектыМетаданных",, ЭтаФорма, "Сформировать",, ЭлементыФормы.ДействияФормы.Кнопки.Сформировать, "СобратьОбъектыМДЗавершение");
	Иначе
		СкомпоноватьРезультатПоГотовымТаблицам();
	КонецЕсли; 
	
КонецПроцедуры

Процедура СобратьОбъектыМДЗавершение(СостояниеЗадания = Неопределено, РезультатЗадания = Неопределено) Экспорт 
	
	Если Ложь
		Или СостояниеЗадания = Неопределено
		Или СостояниеЗадания = СостояниеФоновогоЗадания.Завершено 
	Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, РезультатЗадания); 
		СкомпоноватьРезультатПоГотовымТаблицам();
	КонецЕсли; 

КонецПроцедуры

Процедура СкомпоноватьРезультатПоГотовымТаблицам()
	
	СтарыйТипОбъектов = ТипОбъектов;
	СтарыйРасширенныеПредставления = РасширенныеПредставления;
	СкомпоноватьРезультат(ЭлементыФормы.ТабличныйДокумент, ДанныеРасшифровки);
	//ЭлементыФормы.ТабличныйДокумент.ПоказатьУровеньГруппировокСтрок(0);

КонецПроцедуры

// Предопределеный метод
Процедура ПроверкаЗавершенияФоновыхЗаданий() Экспорт 
	
	ирОбщий.ПроверитьЗавершениеФоновыхЗаданийФормыЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ДействияФормыКопия(Кнопка)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.Вывести(ЭлементыФормы.ТабличныйДокумент);
	ЗаполнитьЗначенияСвойств(ТабличныйДокумент, ЭлементыФормы.ТабличныйДокумент); 
	Результат = ирОбщий.ОткрытьЗначениеЛкс(ТабличныйДокумент,,,, Ложь);

КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ДействияФормыИсполняемаяКомпоновка(Кнопка)
	
	РежимОтладки = 2;
	СкомпоноватьРезультат(ЭлементыФормы.ТабличныйДокумент, ДанныеРасшифровки);
	
КонецПроцедуры

Процедура ТипОбъектовПриИзменении(Элемент)
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
	НастроитьКомпоновщик();
КонецПроцедуры

Процедура НастроитьКомпоновщик(ЗаполнитьНастройки = Истина)
	
	СхемаКомпоновкиДанных = СхемаКомпоновки();
	ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных);
	КомпоновщикНастроек.Инициализировать(ИсточникНастроек);
	Если ЗаполнитьНастройки Тогда
		КомпоновщикНастроек.ЗагрузитьНастройки(Новый НастройкиКомпоновкиДанных);
		ГруппировкаПоРодителю = КомпоновщикНастроек.Настройки;
		ГруппировкаПоРодителю.Структура.Очистить();
		Если Не ЭтоКорневойТипМетаданныхЛкс(ТипОбъектов) Тогда 
			ГруппировкаПоРодителю = ирОбщий.НайтиДобавитьЭлементСтруктурыГруппировкаКомпоновкиЛкс(ГруппировкаПоРодителю.Структура, "ПолноеИмяРодителя");
		КонецЕсли; 
		ГруппировкаВсеПоля = ирОбщий.НайтиДобавитьЭлементСтруктурыГруппировкаКомпоновкиЛкс(ГруппировкаПоРодителю.Структура);
		ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(КомпоновщикНастроек.Настройки.Выбор, "Имя");
		ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(КомпоновщикНастроек.Настройки.Выбор, "ОбъектМД");
		ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(КомпоновщикНастроек.Настройки.Выбор, "ПолноеИмя",, Ложь);
		ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(КомпоновщикНастроек.Настройки.Выбор, "ПолноеИмяРодителя");
		ирОбщий.ВыбратьВсеДоступныеПоляКомпоновки(СхемаКомпоновкиДанных, КомпоновщикНастроек.Настройки);
		ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(КомпоновщикНастроек.Настройки.Порядок, "ПолноеИмя");
		КомпоновщикНастроек.Настройки.ПараметрыВывода.УстановитьЗначениеПараметра("МакетОформления", "Античный");
		ЭлементыФормы.СтруктураКомпоновки.Развернуть(ЭлементыФормы.СтруктураКомпоновки.Значение, Истина);
		ЭлементыФормы.ВыбранныеПоля.Развернуть(ЭлементыФормы.ВыбранныеПоля.Значение, Истина);
	Иначе
		КомпоновщикНастроек.Восстановить();
	КонецЕсли; 

КонецПроцедуры

Процедура ТипОбъектовНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, ЭтаФорма);
КонецПроцедуры

Процедура ДействияФормыВыполнитьПроверкуПодписок(Кнопка)

	Если ирОбщий.ПроверитьПодпискиЛкс() Тогда 
		Сообщить("Проблем совместимости подписок с подсистемой не выявлено");
	КонецЕсли;
	
КонецПроцедуры

Процедура ПорядокВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ирОбщий.ТабличноеПолеПорядкаКомпоновкиВыборЛкс(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка);

КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);

КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирОбщий.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура ТипОбъектовНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	СписокВыбора = СписокВыбораТипаОбъекта();
	#Если Сервер И Не Сервер Тогда
		СписокВыбора = Новый СписокЗначений;
	#КонецЕсли
	РезультатВыбора = ЭтаФорма.ВыбратьИзСписка(СписокВыбора, Элемент, СписокВыбора.НайтиПоЗначению(ТипОбъектов));
	Если РезультатВыбора <> Неопределено Тогда
		ирОбщий.ИнтерактивноЗаписатьВЭлементУправленияЛкс(Элемент, РезультатВыбора.Значение);
	КонецЕсли; 
	
КонецПроцедуры

Функция СписокВыбораТипаОбъекта()
	
	мПлатформа = ирКэш.Получить();
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	Массив = ирОбщий.СтрРазделитьЛкс(мПлатформа.ТаблицаОбщихТипов.Найти("КоллекцияОбъектовМетаданных", "Слово").ТипЭлементаКоллекции, ",", Истина);
	СписокВыбора = Новый СписокЗначений;
	Для Каждого ТипОбъектовЦикл Из Массив Цикл
		СписокВыбора.Добавить(ТипОбъектовЦикл, СокрЛП(ирОбщий.ПоследнийФрагментЛкс(ТипОбъектовЦикл, ":")));
	КонецЦикла;
	СписокВыбора.Добавить("ОписаниеСтандартногоРеквизита", "СтандартныйРеквизит");
	СписокВыбора.Добавить("ОписаниеСтандартнойТабличнойЧасти", "СтандартнаяТабличнаяЧасть");
	СписокВыбора.Добавить("ОписаниеХарактеристик", "Характеристика");
	СписокВыбора.СортироватьПоПредставлению();
	Возврат СписокВыбора;

КонецФункции

Процедура ТипОбъектовОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СписокВыбора = СписокВыбораТипаОбъекта();
	#Если Сервер И Не Сервер Тогда
		СписокВыбора = Новый СписокЗначений;
	#КонецЕсли
	СтандартнаяОбработка = СписокВыбора.НайтиПоЗначению(ВыбранноеЗначение) <> Неопределено;
	
КонецПроцедуры

Процедура ТипОбъектовОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	СписокВыбора = СписокВыбораТипаОбъекта();
	#Если Сервер И Не Сервер Тогда
		СписокВыбора = Новый СписокЗначений;
	#КонецЕсли
	СтандартнаяОбработка = СписокВыбора.НайтиПоЗначению(Текст) <> Неопределено;

КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	ирОбщий.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура НастройкиКомпоновкиПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Колонка)
	Значение = ПараметрыПеретаскивания.Значение;
	Если Истина
		И ТипЗнч(Значение) = Тип("Массив")
		И ТипЗнч(Значение[0]) = Тип("ВыбранноеПолеКомпоновкиДанных")
	Тогда
		ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Копирование;
		СтандартнаяОбработка = Ложь;
	КонецЕсли; 
КонецПроцедуры

Процедура НастройкиКомпоновкиПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Колонка)
	Значение = ПараметрыПеретаскивания.Значение;
	Если Истина
		И ТипЗнч(Значение) = Тип("Массив")
		И ТипЗнч(Значение[0]) = Тип("ВыбранноеПолеКомпоновкиДанных")
	Тогда
		ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Копирование;
		Элемент.ВыделенныеСтроки.Очистить();
		Для Каждого ЭлементМассива Из Значение Цикл
			Если ТипЗнч(ЭлементМассива) = Тип("ВыбранноеПолеКомпоновкиДанных") Тогда
				Если ТипЗнч(Элемент.Значение) = Тип("ОтборКомпоновкиДанных") Тогда
					НоваяСтрока = ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(Элемент.Значение, ЭлементМассива.Поле);
				Иначе
					НоваяСтрока = ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(Элемент.Значение, ЭлементМассива.Поле);
				КонецЕсли; 
				Если Элемент.ВыделенныеСтроки.Количество() = 0 Тогда
					Элемент.ТекущаяСтрока = НоваяСтрока;
				КонецЕсли; 
				Элемент.ВыделенныеСтроки.Добавить(НоваяСтрока);
			КонецЕсли; 
		КонецЦикла;
		СтандартнаяОбработка = Ложь;
	КонецЕсли; 
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Отчет.ирАнализМетаданных.Форма.ФормаОтчета");
ЭтаФорма.Авторасшифровка = Истина;

