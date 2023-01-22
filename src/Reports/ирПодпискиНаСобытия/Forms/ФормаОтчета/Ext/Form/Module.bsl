﻿Функция СохраняемаяНастройкаФормы(выхНаименование, выхИменаСвойств) Экспорт 
	выхИменаСвойств = "Форма.Авторасшифровка";
	Результат = Новый Структура;
	Результат.Вставить("НастройкаКомпоновки", КомпоновщикНастроек.ПолучитьНастройки());
	Возврат Результат;
КонецФункции

Процедура ЗагрузитьНастройкуВФорме(НастройкаФормы, ДопПараметры) Экспорт 
	
	ирКлиент.ЗагрузитьНастройкуФормыЛкс(ЭтаФорма, НастройкаФормы); 
	Если НастройкаФормы <> Неопределено И НастройкаФормы.Свойство("НастройкаКомпоновки") Тогда
		КомпоновщикНастроек.ЗагрузитьНастройки(НастройкаФормы.НастройкаКомпоновки);
	КонецЕсли; 

КонецПроцедуры

Процедура ТабличныйДокументОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры)
	
	ирКлиент.ОтчетКомпоновкиОбработкаРасшифровкиЛкс(ЭтаФорма, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры, Элемент, ДанныеРасшифровки, Авторасшифровка);
	
КонецПроцедуры

Процедура ДействиеРасшифровки(ВыбранноеДействие, ПараметрВыбранногоДействия, СтандартнаяОбработка) Экспорт
	
	Перем Пользователь;
	#Если Сервер И Не Сервер Тогда
	    ПараметрВыбранногоДействия = Новый Соответствие;
	#КонецЕсли
	Если ВыбранноеДействие = "ОткрытьОбработчик" Тогда
		Обработчик = ПараметрВыбранногоДействия["Обработчик"];
		ирОбщий.ПерейтиКОпределениюМетодаВКонфигуратореЛкс(Обработчик);
	ИначеЕсли ВыбранноеДействие = "ОткрытьСобытие" Тогда
		Слово = ПараметрВыбранногоДействия["Событие"];
		мПлатформа = ирКэш.Получить();
		#Если Сервер И Не Сервер Тогда
			мПлатформа = Обработки.ирПлатформа.Создать();
		#КонецЕсли
		ТаблицаСтруктурВозможныхТиповКонтекста = ирКлиент.НайтиВозможныеСтрокиОписанияСловаВСинтаксПомощникеЛкс(Слово);
		СтруктураЦикла = Новый Соответствие;
		СтруктураЦикла.Вставить("2.Возможные:", ТаблицаСтруктурВозможныхТиповКонтекста);
		мПлатформа.ВыбратьСтрокуОписанияИзМассиваСтруктурТипов(СтруктураЦикла, , , Слово);
	ИначеЕсли ВыбранноеДействие = "ОткрытьОбъектМетаданных" Тогда
		ОбъектМетаданных = ПараметрВыбранногоДействия["ОбъектМетаданных"];
		ирКлиент.ОткрытьОбъектМетаданныхЛкс(ОбъектМетаданных);
	КонецЕсли; 
	
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
	Если ЗначенияПолей.Найти("Обработчик") <> Неопределено Тогда 
		СписокДополнительныхДействий.Вставить(0, "ОткрытьОбработчик", "Открыть обработчик",, ирКэш.КартинкаПоИмениЛкс("ирКонфигуратор1С8"));
	КонецЕсли; 
	Если ЗначенияПолей.Найти("Событие") <> Неопределено Тогда 
		СписокДополнительныхДействий.Вставить(0, "ОткрытьСобытие", "Открыть событие",, ирКэш.КартинкаПоИмениЛкс("ирСинтаксПомощник"));
	КонецЕсли; 
	Если ЗначенияПолей.Найти("ОбъектМетаданных") <> Неопределено Тогда 
		СписокДополнительныхДействий.Вставить(0, "ОткрытьОбъектМетаданных", "Открыть объект метаданных",, ирКэш.КартинкаИнструментаЛкс("Обработка.ирИнтерфейснаяПанель"));
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ирКлиент.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ирКлиент.СоздатьМенеджерСохраненияНастроекФормыЛкс(ЭтаФорма);
	КнопкиПодменю = ЭлементыФормы.ДействияФормы.Кнопки.Варианты.Кнопки;
	Для Каждого ВариантНастроек Из СхемаКомпоновкиДанных.ВариантыНастроек Цикл
		Кнопка = КнопкиПодменю.Добавить();
		Кнопка.ТипКнопки = ТипКнопкиКоманднойПанели.Действие;
		Кнопка.Имя = ВариантНастроек.Имя;
		Кнопка.Текст = ВариантНастроек.Представление;
		Кнопка.Действие = Новый Действие("КнопкаВариантаНастроек");
	КонецЦикла;
	Если ЗначениеЗаполнено(ПараметрКлючВарианта) Тогда
		ЗагрузитьВариант(ПараметрКлючВарианта);
	КонецЕсли; 
	События = ирОбщий.ТаблицаЗначенийИзТабличногоДокументаЛкс(ПолучитьМакет("События"));
	#Если Сервер И Не Сервер Тогда
		События = Новый ТаблицаЗначений;
	#КонецЕсли
	СписокСобытий = ЭлементыФормы.Событие.СписокВыбора;
	СписокСобытий.ЗагрузитьЗначения(События.ВыгрузитьКолонку("Имя"));

КонецПроцедуры

Процедура КнопкаВариантаНастроек(Кнопка)
	
	ЗагрузитьВариант(Кнопка.Имя);
	
КонецПроцедуры

Процедура ЗагрузитьВариант(Знач ИмяВарианта) 
	
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.ВариантыНастроек[ИмяВарианта].Настройки);

КонецПроцедуры

Процедура ДействияФормыСформировать(Кнопка = Неопределено) Экспорт 
	
	РежимОтладки = 0;
	СкомпоноватьРезультат(ЭлементыФормы.ТабличныйДокумент, ДанныеРасшифровки);
	//ЭлементыФормы.ТабличныйДокумент.ПоказатьУровеньГруппировокСтрок(0);
	
КонецПроцедуры

Процедура ДействияФормыКопия(Кнопка)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.Вывести(ЭлементыФормы.ТабличныйДокумент);
	ЗаполнитьЗначенияСвойств(ТабличныйДокумент, ЭлементыФормы.ТабличныйДокумент); 
	Результат = ирКлиент.ОткрытьЗначениеЛкс(ТабличныйДокумент,,,, Ложь);

КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирКлиент.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ДействияФормыИсполняемаяКомпоновка(Кнопка)
	
	РежимОтладки = 2;
	СкомпоноватьРезультат(ЭлементыФормы.ТабличныйДокумент, ДанныеРасшифровки);
	
КонецПроцедуры

Процедура ОбъектМетаданныхПриИзменении(Элемент)
	ирКлиент.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
КонецПроцедуры

Процедура ОбъектМетаданныхНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	ирОбщий.ПолеВводаСИсториейВыбора_ОбновитьСписокЛкс(Элемент, ЭтаФорма);
КонецПроцедуры

Функция ПараметрыВыбораОбъектаМетаданных()
	Возврат ирКлиент.ПараметрыВыбораОбъектаМетаданныхЛкс(Истина, Истина, Истина, Истина, Истина,,,,,, Истина, Истина, Истина);
КонецФункции

Процедура ОбъектМетаданныхНачалоВыбора(Элемент, СтандартнаяОбработка)
	ирКлиент.ОбъектМетаданныхНачалоВыбораЛкс(Элемент, ПараметрыВыбораОбъектаМетаданных(), СтандартнаяОбработка);
КонецПроцедуры

Процедура ОбъектМетаданныхОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	ирКлиент.ОбъектМетаданныхОкончаниеВводаТекстаЛкс(Элемент, ПараметрыВыбораОбъектаМетаданных(), Текст, Значение, СтандартнаяОбработка);
КонецПроцедуры

Процедура ДействияФормыВыполнитьПроверкуПодписок(Кнопка)

	Если ирКлиент.ПроверитьПодпискиЛкс() Тогда 
		Сообщить("Проблем совместимости подписок с подсистемой не выявлено");
	КонецЕсли;
	
КонецПроцедуры

Процедура ПорядокВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ирКлиент.ТабличноеПолеПорядкаКомпоновкиВыборЛкс(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка);

КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирКлиент.Форма_ПриЗакрытииЛкс(ЭтаФорма);

КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирКлиент.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
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

Процедура ТабличныйДокументПриАктивизацииОбласти(Элемент)
	ирКлиент.ПолеТабличногоДокументаПриАктивизацииОбластиЛкс(ЭтаФорма, Элемент);
КонецПроцедуры

ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Отчет.ирПодпискиНаСобытия.Форма.ФормаОтчета");
ЭтаФорма.Авторасшифровка = Истина;

