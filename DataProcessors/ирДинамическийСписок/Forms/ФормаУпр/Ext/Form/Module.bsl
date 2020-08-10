﻿#Если Не ВебКлиент И Не ТонкийКлиент И Не МобильныйКлиент Тогда

Процедура УстановитьОбъектМетаданных(НовоеПолноеИмяТаблицы = Неопределено) Экспорт

	ЭлементыФормы = Элементы;
	Если НовоеПолноеИмяТаблицы <> Неопределено Тогда
		ЗначениеИзменено = Ложь;
		ирОбщий.ПрисвоитьЕслиНеРавноЛкс(фОбъект.ПолноеИмяТаблицы, НовоеПолноеИмяТаблицы, ЗначениеИзменено);
		Если Не ЗначениеИзменено Тогда
			Возврат;
		КонецЕсли; 
	КонецЕсли;
	Если ЭлементыФормы.Найти("ДинамическийСписокВременноеПоле") <> Неопределено Тогда
		Элементы.ДинамическийСписокВременноеПоле.Видимость = Ложь;
		Элементы.Переместить(Элементы.ДинамическийСписокВременноеПоле, ЭтаФорма);
	КонецЕсли; 
	Элементы.ДинамическийСписок.Видимость = Истина;
	ЭлементыФормы.ДинамическийСписок.ИзменятьСоставСтрок = Истина;
	МассивФрагментов = ирОбщий.СтрРазделитьЛкс(фОбъект.ПолноеИмяТаблицы);
	ОсновнойЭУ = ЭлементыФормы.ДинамическийСписок;
	ОсновнойЭУ.РежимВыбора = РежимВыбора;
	ОбъектМД = Метаданные.НайтиПоПолномуИмени(фОбъект.ПолноеИмяТаблицы);
	ЭтаФорма.ЕстьОграниченияДоступа = ирОбщий.ЕстьОграниченияДоступаКСтрокамТаблицыНаЧтениеЛкс(ОбъектМД);
	ЭлементыФормы.ПраваДоступаКСтрокам.Гиперссылка = ЕстьОграниченияДоступа;
	ТипТаблицыБД = ирОбщий.ТипТаблицыБДЛкс(фОбъект.ПолноеИмяТаблицы);
	СоединяемыеРегистры.Очистить();
	СоединенныеРегистры = Новый Массив;
	Если ирОбщий.ЛиКорневойТипСсылкиЛкс(ТипТаблицыБД) Тогда
		СохраненныеНастройки = ирОбщий.ВосстановитьЗначениеЛкс("ДинамическийСписок." + фОбъект.ПолноеИмяТаблицы + "." + РежимВыбора);
		Если ТипЗнч(СохраненныеНастройки) = Тип("Структура") И СохраненныеНастройки.Свойство("СоединенныеРегистры") Тогда
			СоединенныеРегистры = СохраненныеНастройки.СоединенныеРегистры;
		КонецЕсли; 
		ТипСсылки = Тип(ирОбщий.ИмяТипаИзПолногоИмениМДЛкс(фОбъект.ПолноеИмяТаблицы));
		Для Каждого МетаРегистр Из Метаданные.РегистрыСведений Цикл
			#Если Сервер И Не Сервер Тогда
				МетаРегистр = Метаданные.РегистрыСведений.АвансыРаботникам;
			#КонецЕсли
			Если Истина
				И МетаРегистр.ПериодичностьРегистраСведений = Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический
				И МетаРегистр.Измерения.Количество() = 1
				И МетаРегистр.Измерения[0].Тип.СодержитТип(ТипСсылки)
			Тогда
				СтрокаРегистра = СоединяемыеРегистры.Добавить();
				СтрокаРегистра.Имя = МетаРегистр.Имя;
				СтрокаРегистра.Представление = МетаРегистр.Синоним;
				СтрокаРегистра.Соединить = СоединенныеРегистры.Найти(МетаРегистр.Имя) <> Неопределено;
			КонецЕсли; 
		КонецЦикла;
		Если фОбъект.РежимИмяСиноним Тогда
			СоединяемыеРегистры.Сортировать("Имя");
		Иначе
			СоединяемыеРегистры.Сортировать("Представление");
		КонецЕсли; 
	КонецЕсли; 
	ЭлементыФормы.СоединяемыеРегистры.Видимость = СоединяемыеРегистры.Количество() > 0;
	Если Ложь
		Или ТипТаблицыБД = "Последовательность"
		Или ТипТаблицыБД = "Изменения"
		Или ирОбщий.ЛиТипВложеннойТаблицыБДЛкс(ТипТаблицыБД)
	Тогда
		////Сообщить("Динамический список для таблицы """ + фОбъект.ОбъектМетаданных + """ недоступен");
		//ДинамическийСписок.ПроизвольныйЗапрос = Истина;
		//ДинамическийСписок.ТекстЗапроса = "ВЫБРАТЬ * ИЗ " + фОбъект.ПолноеИмяТаблицы;
		ДинамическийСписок.ОсновнаяТаблица = "";
	Иначе
		ДинамическийСписок.ОсновнаяТаблица = фОбъект.ПолноеИмяТаблицы;
	КонецЕсли; 
	Если Не ирСервер.НастроитьАвтоТаблицуФормыДинамическогоСпискаЛкс(ЭтаФорма, ОсновнойЭУ, фОбъект.ПолноеИмяТаблицы, фОбъект.РежимИмяСиноним,, СоединенныеРегистры) Тогда 
		фОбъект.ПолноеИмяТаблицы = "";
		Возврат;
	КонецЕсли;
	Элементы.ФормаНайтиВыбратьПоID.Доступность = ирОбщий.ЛиКорневойТипСсылочногоОбъектаБДЛкс(ТипТаблицыБД);
	Элементы.ДинамическийСписокРедакторОбъектаБД.Доступность = ТипТаблицыБД <> "Изменения";
	ПредставлениеТаблицы = ирОбщий.ПредставлениеТаблицыБДЛкс(фОбъект.ПолноеИмяТаблицы);
	ирОбщий.ОбновитьТекстПослеМаркераВСтрокеЛкс(ЭтаФорма.Заголовок,, ПредставлениеТаблицы, ": ");
	Если РежимВыбора Тогда
		ЭтаФорма.Заголовок = ЭтаФорма.Заголовок + " (выбор)";
	КонецЕсли; 
	КорневойТип = ирОбщий.ПервыйФрагментЛкс(фОбъект.ПолноеИмяТаблицы);
	фОбъект.ВместоОсновной = ирОбщий.ПолучитьИспользованиеДинамическогоСпискаВместоОсновнойФормыЛкс(фОбъект.ПолноеИмяТаблицы);
	ОбновитьСлужебныеДанные();
	//Попытка
	//	ЭлементыФормы.ДинамическийСписок.Колонки.Наименование.ОтображатьИерархию = Истина;
	//	ЭлементыФормы.ДинамическийСписок.Колонки.Картинка.ОтображатьИерархию = Ложь;
	//	ЭлементыФормы.ДинамическийСписок.Колонки.Картинка.Видимость = Ложь;
	//Исключение
	//КонецПопытки;
	//ЭлементыФормы.КоманднаяПанельПереключателяДерева.Кнопки.РежимДерева.Доступность = ирОбщий.ЛиМетаданныеИерархическогоОбъектаЛкс(ОбъектМД);
	//ирОбщий.НастроитьТабличноеПолеЛкс(ОсновнойЭУ);
	ДинамическийСписок.КомпоновщикНастроек.Восстановить(); // Не влияет на пользовательские настройки
	ЗагрузитьНастройкиСписка();
	фОбъект.СтарыйОбъектМетаданных = фОбъект.ПолноеИмяТаблицы;
	ЭтаФорма.мКлючУникальности = фОбъект.ПолноеИмяТаблицы;
	ирОбщий.ПоследниеВыбранныеЗаполнитьПодменюЛкс(ЭтаФорма, ЭлементыФормы.ПоследниеВыбранные);
	//РезультирующаяСхема = Элементы.ДинамическийСписок.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	//АдресСхемы = ПоместитьВоВременноеХранилище(РезультирующаяСхема, ЭтаФорма.УникальныйИдентификатор);
	ЭтаФорма.КлючНазначенияИспользования = фОбъект.ПолноеИмяТаблицы; // Надо делать на сервере, иначе применяться настройки не будут
	
КонецПроцедуры

Процедура СохранитьНастройкиСписка()
	
	Если Не ЗначениеЗаполнено(фОбъект.СтарыйОбъектМетаданных) Тогда
		Возврат;
	КонецЕсли; 
	фОбъект.НастройкиКолонок.Очистить();
	Для Каждого КолонкаТП Из Элементы.ДинамическийСписок.ПодчиненныеЭлементы Цикл
		ОписаниеКолонки = фОбъект.НастройкиКолонок.Добавить();
		ЗаполнитьЗначенияСвойств(ОписаниеКолонки, КолонкаТП,, "Имя"); 
		ОписаниеКолонки.Имя = ИмяКолонкиБезРодителя(ЭтаФорма, КолонкаТП);
		ОписаниеКолонки.ВысотаЯчейки = КолонкаТП.Высота;
	КонецЦикла;
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("НастройкиКолонок", фОбъект.НастройкиКолонок.Выгрузить());
	СтруктураНастроек.Вставить("СоединенныеРегистры", СоединяемыеРегистры.Выгрузить(Новый Структура("Соединить", Истина)).ВыгрузитьКолонку(0));
	СтруктураНастроек.Вставить("ПользовательскиеНастройки", ЭтаФорма.ДинамическийСписок.КомпоновщикНастроек.ПользовательскиеНастройки);
	ирОбщий.СохранитьЗначениеЛкс("ДинамическийСписок." + фОбъект.СтарыйОбъектМетаданных + "." + РежимВыбора, СтруктураНастроек);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ИмяКолонкиБезРодителя(ЭтаФорма, Колонка)
	
	Возврат Сред(Колонка.Имя, СтрДлина(ЭтаФорма.Элементы.ДинамическийСписок.Имя) + 1);
	
КонецФункции

Процедура ЗагрузитьНастройкиСписка()
	
	ЭтаФорма.ДинамическийСписок.КомпоновщикНастроек.ЗагрузитьПользовательскиеНастройки(Новый ПользовательскиеНастройкиКомпоновкиДанных);
	СохраненныеНастройки = ирОбщий.ВосстановитьЗначениеЛкс("ДинамическийСписок." + фОбъект.ПолноеИмяТаблицы + "." + РежимВыбора);
	Если СохраненныеНастройки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если ТипЗнч(СохраненныеНастройки) = Тип("Структура") Тогда
		#Если Сервер И Не Сервер Тогда
		    СохраненныеНастройки = Новый Структура;
		#КонецЕсли
		фОбъект.НастройкиКолонок.Загрузить(СохраненныеНастройки.НастройкиКолонок);
		Если СохраненныеНастройки.Свойство("ПользовательскиеНастройки") Тогда
			ЭтаФорма.ДинамическийСписок.КомпоновщикНастроек.ЗагрузитьПользовательскиеНастройки(СохраненныеНастройки.ПользовательскиеНастройки);
		КонецЕсли; 
	КонецЕсли; 
	ПрименитьНастройкиКолонок();
	// Чтобы появилась команда ALT+F "Расширенный поиск"
	Элементы.ДинамическийСписок.Видимость = Ложь;
	Элементы.ДинамическийСписок.Видимость = Истина;
	
КонецПроцедуры

Процедура ПрименитьНастройкиКолонок()
	
	НачальноеКоличество = фОбъект.НастройкиКолонок.Количество(); 
	КолонкиТП = Элементы.ДинамическийСписок.ПодчиненныеЭлементы;
	Для Счетчик = 1 По НачальноеКоличество Цикл
		ОписаниеКолонки = фОбъект.НастройкиКолонок[НачальноеКоличество - Счетчик];
		КолонкаТП = КолонкиТП.Найти(Элементы.ДинамическийСписок.Имя + ОписаниеКолонки.Имя);
		Если КолонкаТП <> Неопределено Тогда
			//КолонкиТП.Сдвинуть(КолонкаТП, -КолонкиТП.Индекс(КолонкаТП));
			Элементы.Переместить(КолонкаТП, КолонкаТП.Родитель, КолонкиТП[0]);
			КолонкаТП.Видимость = ОписаниеКолонки.Видимость;
			Если ОписаниеКолонки.Ширина > 0 Тогда
				КолонкаТП.Ширина = ОписаниеКолонки.Ширина;
			КонецЕсли; 
			Если ОписаниеКолонки.ВысотаЯчейки > 0 Тогда
				КолонкаТП.Высота = ОписаниеКолонки.ВысотаЯчейки;
			КонецЕсли; 
		КонецЕсли; 
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура НайтиСсылкуВСписке(КлючСтроки, УстановитьОбъектМетаданных = Истина) Экспорт

	#Если ТонкийКлиент Или ВебКлиент Тогда
		Возврат;
	#Иначе
		ЭлементыФормы = Элементы;
		МетаданныеТаблицы = Метаданные.НайтиПоТипу(ирОбщий.ТипОбъектаБДЛкс(КлючСтроки));
		Если УстановитьОбъектМетаданных Тогда
			УстановитьОбъектМетаданныхНаКлиенте(МетаданныеТаблицы.ПолноеИмя());
		КонецЕсли; 
		ИмяXMLТипа = СериализаторXDTO.XMLТипЗнч(КлючСтроки).ИмяТипа;
		Если Ложь
			Или Найти(ИмяXMLТипа, "Ref.") > 0
			Или Найти(ИмяXMLТипа, "RecordKey.") > 0
		Тогда
			ЭлементыФормы.ДинамическийСписок.ТекущаяСтрока = КлючСтроки;
		Иначе
			ирОбщий.СкопироватьОтборЛюбойЛкс(ПользовательскийОтбор(), КлючСтроки.Методы.Отбор);
		КонецЕсли; 
	#КонецЕсли 

КонецПроцедуры

&НаКлиенте
Процедура ОбъектОбъектМетаданныхПриИзменении(Элемент)
	СохранитьНастройкиСписка();
	УстановитьОбъектМетаданныхНаКлиенте();
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Функция ПараметрыВыбораОбъектаМетаданных()
	Возврат ирОбщий.ПараметрыВыбораОбъектаМетаданныхЛкс(Истина, Истина, Истина, Истина,, Истина, Истина, Истина,,, Истина,,, Истина);
КонецФункции

&НаКлиенте
Процедура ОбъектОбъектМетаданныхНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ирОбщий.ОбъектМетаданныхНачалоВыбораЛкс(Элемент, ПараметрыВыбораОбъектаМетаданных(), СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектМетаданныхОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ирОбщий.ОбъектМетаданныхОкончаниеВводаТекстаЛкс(Элемент, ПараметрыВыбораОбъектаМетаданных(), Текст, ДанныеВыбора, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура УстановитьОбъектМетаданныхНаКлиенте(ПолноеИмяТаблицы = Неопределено)
	
	УстановитьОбъектМетаданных(ПолноеИмяТаблицы);
	ПослеУстановкиОбъектаМетаданныхНаКлиенте();

КонецПроцедуры

&НаКлиенте
Процедура ПослеУстановкиОбъектаМетаданныхНаКлиенте()
	
	ЭтаФорма.КлючУникальности = фОбъект.ПолноеИмяТаблицы;
	фОбъект.КоличествоСтрокВОбластиПоиска = "...";
	Если Не ирКэш.ЛиПортативныйРежимЛкс() И Не ирКэш.ЭтоФайловаяБазаЛкс() Тогда
		ирОбщий.ОтменитьФоновоеЗаданиеЛкс(фОбъект.ИДФоновогоЗадания);
		//ФормаРезультатФоновогоЗадания = ирОбщий.ФормаРезультатаФоновогоЗаданияЛкс();
		//фОбъект.АдресХранилищаКоличестваСтрок = ПоместитьВоВременноеХранилище(Неопределено, ФормаРезультатФоновогоЗадания.УникальныйИдентификатор);
		фОбъект.АдресХранилищаКоличестваСтрок = ПоместитьВоВременноеХранилище(Неопределено);
		ПараметрыЗапуска = Новый Массив;
		ПараметрыЗапуска.Добавить(фОбъект.ПолноеИмяТаблицы);
		ПараметрыЗапуска.Добавить(фОбъект.АдресХранилищаКоличестваСтрок);
		#Если Сервер И Не Сервер Тогда
			ирОбщий.КоличествоСтрокВТаблицеБДЛкс();
		#КонецЕсли
		ФоновоеЗадание = ФоновыеЗадания.Выполнить("ирОбщий.КоличествоСтрокВТаблицеБДЛкс", ПараметрыЗапуска,, "ИР. Вычисление количества строк в таблице " + фОбъект.ПолноеИмяТаблицы);
		фОбъект.ИДФоновогоЗадания = ФоновоеЗадание.УникальныйИдентификатор;
	КонецЕсли; 
	#Если Сервер И Не Сервер Тогда
		ОбновитьКоличествоСтрок();
	#КонецЕсли
	ПодключитьОбработчикОжидания("ОбновитьКоличествоСтрок", 0.1, Истина);

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.ДинамическийСписок.Видимость = Ложь;
	ЭлементыФормы = Элементы;
	НачальноеЗначениеВыбора = Параметры.ТекущаяСтрока;
	ЭтаФорма.РежимВыбора = Параметры.РежимВыбора;
	ЭтаФорма.ПараметрТекущаяКолонка = Параметры.ТекущаяКолонка;
	Элементы.ОбъектМетаданных.ТолькоПросмотр = РежимВыбора;
	ирСервер.УправляемаяФорма_ПриСозданииЛкс(ЭтаФорма, Отказ, СтандартнаяОбработка,, ПоляСИсториейВыбора());
	НовоеИмяТаблицы = Параметры.ИмяТаблицы;
	Если ЗначениеЗаполнено(НовоеИмяТаблицы) Тогда
		НовоеИмяТаблицы = ирОбщий.ПервыйФрагментЛкс(НовоеИмяТаблицы, ";");
		ОбъектМД = Метаданные.НайтиПоПолномуИмени(НовоеИмяТаблицы);
		Если ОбъектМД <> Неопределено Тогда
			НовоеИмяТаблицы = Неопределено;
		КонецЕсли;
	КонецЕсли; 
	УстановитьОбъектМетаданных(НовоеИмяТаблицы);
	Если Истина
		И ЗначениеЗаполнено(фОбъект.ПолноеИмяТаблицы)
		И НачальноеЗначениеВыбора <> Неопределено 
		И ЗначениеЗаполнено(НачальноеЗначениеВыбора) 
	Тогда
		Если Ложь
			Или ирОбщий.ЛиСсылкаНаОбъектБДЛкс(НачальноеЗначениеВыбора, Ложь)
			Или ирОбщий.ЛиСсылкаНаПеречислениеЛкс(НачальноеЗначениеВыбора)
			Или ирОбщий.ЛиКлючЗаписиРегистраЛкс(НачальноеЗначениеВыбора)
		Тогда
			ЭлементыФормы.ДинамическийСписок.ТекущаяСтрока = НачальноеЗначениеВыбора;
		//ИначеЕсли ирОбщий.ЛиСсылкаНаОбъектБДЛкс(НачальноеЗначениеВыбора, Ложь) Тогда 
		//	ДанныеСписка = ирОбщий.ПолучитьДанныеЭлементаУправляемойФормыЛкс(ЭлементыФормы.ДинамическийСписок); //
		//	ТекущаяСтрока = ДанныеСписка.Найти(НачальноеЗначениеВыбора, "Ссылка");
		//	Если ТекущаяСтрока <> Неопределено Тогда
		//		ЭлементыФормы.ДинамическийСписок.ТекущаяСтрока = ТекущаяСтрока;
		//	КонецЕсли; 
		КонецЕсли; 
	КонецЕсли;
	Если ЗначениеЗаполнено(фОбъект.ПолноеИмяТаблицы) Тогда
		ЭтаФорма.ТекущийЭлемент = ЭлементыФормы.ДинамическийСписок;
	КонецЕсли; 
	Если РежимВыбора Тогда
		ЭтаФорма.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	КонецЕсли; 

КонецПроцедуры

&НаСервере
Функция ПоляСИсториейВыбора()
	
	Возврат Элементы.ОбъектМетаданных;

КонецФункции

&НаСервереБезКонтекста
Процедура ДинамическийСписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	#Если Сервер И Не Сервер Тогда
	    Настройки = Новый НастройкиКомпоновкиДанных;
	#КонецЕсли
	ИмяПоляСсылка = ирОбщий.ПеревестиСтроку("Ссылка");
	РасширенноеПредставлениеХранилищЗначений = Ложь;
	РасширенныеКолонки = Неопределено;
	ИменаКолонокСПиктограммамиТипов = Неопределено;
	КолонкиТаблицы = Настройки.Выбор.Элементы;
	ВариантОтображенияИдентификаторов = Неопределено;
	Настройки.ДополнительныеСвойства.Свойство("ОтображениеИдентификаторов", ВариантОтображенияИдентификаторов);
	СостоянияКнопки = ирОбщий.ПолучитьСостоянияКнопкиОтображатьПустыеИИдентификаторыЛкс();
	ЛиОтбражатьПустые = Ложь
		Или ВариантОтображенияИдентификаторов = СостоянияКнопки[1]
		Или ВариантОтображенияИдентификаторов = СостоянияКнопки[2];
	ОтображатьИдентификаторы = Ложь
			Или ВариантОтображенияИдентификаторов = СостоянияКнопки[2];
	ирПлатформа = ирКэш.Получить();
	#Если Сервер И Не Сервер Тогда
	    ирПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	Если ТипЗнч(ИменаКолонокСПиктограммамиТипов) = Тип("Строка") Тогда
		ИменаКолонокСПиктограммамиТипов = ирОбщий.СтрРазделитьЛкс(ИменаКолонокСПиктограммамиТипов, ",", Истина); 
	КонецЕсли; 
	Для Каждого СтрокаСписка Из Строки Цикл
		СтрокаОформления = СтрокаСписка.Значение;
		ДанныеСтроки = СтрокаОформления.Данные;
		Ячейки = СтрокаОформления.Оформление;
		Для Каждого Ячейка Из Ячейки Цикл
			//КолонкаОтображаетДанныеФлажка = Ложь;
			ЗначениеЯчейки = ДанныеСтроки[Ячейка.Ключ];
			//Если Ложь
			//	Или КолонкаОтображаетДанныеФлажка
			//	Или Формат(ЗначениеЯчейки, Колонка.Формат) = Ячейка.Текст 
			//Тогда // Здесь могут быть обращения к БД
				ПредставлениеЗначения = "";
				//Если Истина
				//	И Не КолонкаОтображаетДанныеФлажка
				//	И ТипЗнч(ЗначениеЯчейки) <> Тип("Строка") 
				//Тогда
				//	ПредставлениеЗначения = ирОбщий.РасширенноеПредставлениеЗначенияЛкс(ЗначениеЯчейки, Колонка,, РасширенноеПредставлениеХранилищЗначений);
				//КонецЕсли; 
				Если ЛиОтбражатьПустые И Не ирОбщий.ЭтоКоллекцияЛкс(ЗначениеЯчейки) Тогда
					ЦветПустых = ирОбщий.ЦветФонаЯчеекПустыхЗначенийЛкс();
					Если ТипЗнч(ЗначениеЯчейки) = Тип("Строка") Тогда
						ПредставлениеЗначения = """" + ЗначениеЯчейки + """";
						Ячейка.Значение.УстановитьЗначениеПараметра("ЦветФона", ЦветПустых);
					Иначе
						Попытка
							ЗначениеНепустое = ЗначениеЗаполнено(ЗначениеЯчейки) И ЗначениеЯчейки <> Ложь;
						Исключение
							ЗначениеНепустое = Истина;
						КонецПопытки;
						Если Не ЗначениеНепустое Тогда
							ПредставлениеЗначения = ирПлатформа.мПолучитьПредставлениеПустогоЗначения(ЗначениеЯчейки);
							Ячейка.Значение.УстановитьЗначениеПараметра("ЦветФона", ЦветПустых);
						КонецЕсли;
					КонецЕсли; 
				КонецЕсли; 
				Если ПредставлениеЗначения <> "" Тогда
					Ячейка.Значение.УстановитьЗначениеПараметра("Текст", ПредставлениеЗначения);
				КонецЕсли; 
			//КонецЕсли; 
			Если ОтображатьИдентификаторы Тогда
				ИдентификаторСсылки = ирОбщий.ПолучитьИдентификаторСсылкиЛкс(ЗначениеЯчейки);
				Если ИдентификаторСсылки <> Неопределено Тогда
					XMLТип = XMLТипЗнч(ЗначениеЯчейки);
					ИдентификаторСсылки = ИдентификаторСсылки + "." + XMLТип.ИмяТипа;
				КонецЕсли; 
				Если ИдентификаторСсылки <> Неопределено Тогда
					Ячейка.Значение.УстановитьЗначениеПараметра("Текст", ИдентификаторСсылки);
				КонецЕсли; 
			КонецЕсли; 
		КонецЦикла;  
		Если Настройки.ДоступныеПоляВыбора.НайтиПоле(Новый ПолеКомпоновкиДанных("ИдентификаторСсылкиЛкс")) <> Неопределено Тогда
			Попытка
				ЯчейкаИдентификатора = Ячейки["ИдентификаторСсылкиЛкс"];
			Исключение
				// Скрыли колонку в таблице
			КонецПопытки;
			Если ЯчейкаИдентификатора <> Неопределено Тогда
				Ссылка = ДанныеСтроки[ИмяПоляСсылка];
				Если ирОбщий.ЛиСсылкаНаПеречислениеЛкс(Ссылка) Тогда
					ИдентификаторСсылки = "" + XMLСтрока(Ссылка);
				Иначе
					ИдентификаторСсылки = "" + ирОбщий.ПолучитьИдентификаторСсылкиЛкс(Ссылка);
				КонецЕсли; 
				ЯчейкаИдентификатора.УстановитьЗначениеПараметра("Текст", ИдентификаторСсылки);
			КонецЕсли; 
		КонецЕсли; 
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектОбъектМетаданныхОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;

КонецПроцедуры

&НаКлиенте
Процедура ИзменитьСтрокуЧерезРедакторОбъектаБД(Команда)
	
	ирОбщий.ОткрытьТекущуюСтрокуТабличногоПоляТаблицыБДВРедактореОбъектаБДЛкс(Элементы.ДинамическийСписок, фОбъект.ПолноеИмяТаблицы,,,,, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура РедакторОбъектаБДЯчейки(Команда)
	
	ЭлементыФормы = Элементы;
	ирОбщий.ОткрытьСсылкуЯчейкиВРедактореОбъектаБДЛкс(ЭлементыФормы.ДинамическийСписок);
	
КонецПроцедуры

&НаСервере
Процедура ОбъектРежимИмяСинонимПриИзмененииНаСервере()
	ирОбщий.НастроитьЗаголовкиАвтоТаблицыФормыДинамическогоСпискаЛкс(Элементы.ДинамическийСписок, фОбъект.ПолноеИмяТаблицы, фОбъект.РежимИмяСиноним);
	Элементы.СоединяемыеРегистрыИмя.Видимость = фОбъект.РежимИмяСиноним;
	Элементы.СоединяемыеРегистрыПредставление.Видимость = Не фОбъект.РежимИмяСиноним;
КонецПроцедуры

&НаКлиенте
Процедура ОбъектРежимИмяСинонимПриИзменении(Элемент)
	Если Не ЗначениеЗаполнено(фОбъект.ПолноеИмяТаблицы) Тогда
		Возврат;
	КонецЕсли; 
	ОбъектРежимИмяСинонимПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура НовоеОкно(Команда)
	
	ирОбщий.ОткрытьНовоеОкноОбработкиЛкс(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Функция Отбор() Экспорт 
	Возврат ДинамическийСписок.Отбор;
КонецФункции

&НаКлиенте
Функция ПользовательскийОтбор() Экспорт 
	
	НастройкиСписка = ирОбщий.НастройкиДинамическогоСпискаЛкс(ДинамическийСписок, "Пользовательские");
	Возврат НастройкиСписка.Отбор;
	
КонецФункции

&НаКлиенте
Процедура ОсновнаяФорма(Команда)
	
	ЭлементыФормы = Элементы;
	МножественныйВыбор = ЭлементыФормы.ДинамическийСписок.МножественныйВыбор;
	
	Если Не ЗначениеЗаполнено(фОбъект.ПолноеИмяТаблицы) Тогда
		Возврат;
	КонецЕсли; 
	Если РежимВыбора Тогда
		Закрыть();
	КонецЕсли; 
	//Попытка
		Отбор = ДинамическийСписок.Отбор;
	//Исключение
	//	Отбор = Неопределено;
	//КонецПопытки;
	Форма = ирОбщий.ОткрытьФормуСпискаЛкс(фОбъект.ПолноеИмяТаблицы, Отбор, Ложь, ВладелецФормы, РежимВыбора, МножественныйВыбор, ЭлементыФормы.ДинамическийСписок.ТекущаяСтрока);
	Если Форма = Неопределено Тогда
		ЭтаФорма.Открыть();
	КонецЕсли; 

КонецПроцедуры

&НаКлиенте
Процедура СброситьНастройкиСписка(Команда)
	СброситьНастройкиСпискаНаСервере();
КонецПроцедуры

&НаСервере
Процедура СброситьНастройкиСпискаНаСервере()
	
	ХранилищеОбщихНастроек.Сохранить(ирОбщий.ИмяПродуктаЛкс(), "ДинамическийСписок." + фОбъект.СтарыйОбъектМетаданных + "." + РежимВыбора, Неопределено);
	УстановитьОбъектМетаданных();
	СохранитьНастройкиСписка();
	
КонецПроцедуры

Процедура СколькоСтрокНаСервере()
	ЭлементыФормы = Элементы;
	НастройкиСписка = НастройкиРезультатаНаСервере();
	ирОбщий.ТабличноеПолеИлиТаблицаФормы_СколькоСтрокЛкс(ЭлементыФормы.ДинамическийСписок, НастройкиСписка);
КонецПроцедуры

&НаКлиенте
Процедура СколькоСтрок(Команда)
	Если Не ЗначениеЗаполнено(фОбъект.ПолноеИмяТаблицы) Тогда
		Возврат;
	КонецЕсли; 
	СколькоСтрокНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ВыделитьНужноеКоличество(Команда)
	
	Количество = 10;
	Если Не ВвестиЧисло(Количество, "Введите количество", 6, 0) Тогда
		Возврат;
	КонецЕсли; 
	Если Количество = 0 Тогда
		Возврат;
	КонецЕсли; 
	ВыделитьНужноеКоличествоНаСервере(Количество);

КонецПроцедуры

&НаСервере
Процедура ВыделитьНужноеКоличествоНаСервере(Знач Количество)
	
	ЭлементыФормы = Элементы;
	НастройкиСписка = НастройкиРезультатаНаСервере();
	ирОбщий.ВыделитьПервыеСтрокиДинамическогоСпискаЛкс(ЭлементыФормы.ДинамическийСписок, Количество, НастройкиСписка);

КонецПроцедуры

&НаКлиенте
Процедура РазличныеЗначенияКолонки(Команда)
	
	ЭлементыФормы = Элементы;
	АдресСхемы = Неопределено;
	НастройкиСписка = НастройкиРезультатаНаКлиенте(АдресСхемы);
	ирОбщий.ОткрытьРазличныеЗначенияКолонкиЛкс(ЭлементыФормы.ДинамическийСписок, НастройкиСписка, АдресСхемы);

КонецПроцедуры

&НаКлиенте
Процедура НастройкаСписка(Команда = Неопределено, АктивироватьФиксированныйОтбор = Ложь)
	
	Если Не ЗначениеЗаполнено(фОбъект.ПолноеИмяТаблицы) Тогда
		Возврат;
	КонецЕсли; 
	ИсполняемаяСхема = Неопределено;
	ИсполняемыеНастройки = НастройкиРезультатаНаКлиенте(ИсполняемаяСхема);
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("АктивироватьФиксированныйОтбор", АктивироватьФиксированныйОтбор);
	ПараметрыФормы.Вставить("ИсполняемыеНастройки", ИсполняемыеНастройки);
	ПараметрыФормы.Вставить("ИсполняемаяСхема", ИсполняемаяСхема);
	ПараметрыФормы.Вставить("ФиксированныеНастройки", ДинамическийСписок.КомпоновщикНастроек.ФиксированныеНастройки);
	ПараметрыФормы.Вставить("Настройки", ДинамическийСписок.КомпоновщикНастроек.Настройки);
	ПараметрыФормы.Вставить("ПользовательскиеНастройки", ДинамическийСписок.КомпоновщикНастроек.ПользовательскиеНастройки);
	ПараметрыФормы.Вставить("ИсточникДоступныхНастроек", ДинамическийСписок.КомпоновщикНастроек.ПолучитьИсточникДоступныхНастроек());
	ОткрытьФорму("Обработка.ирДинамическийСписок.Форма.НастройкиСпискаУпр", ПараметрыФормы, Элементы.ДинамическийСписок,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

&НаКлиенте
Процедура ОПодсистеме(Команда)
	
	ирОбщий.ОткрытьСправкуПоПодсистемеЛкс(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьОбъекты(Команда)
	
	ЭлементыФормы = Элементы;
	НастройкиСписка = НастройкиРезультатаНаКлиенте();
	ирОбщий.ОткрытьПодборИОбработкуОбъектовИзТабличногоПоляДинамическогоСпискаЛкс(ЭлементыФормы.ДинамическийСписок, НастройкиСписка);

КонецПроцедуры

&НаКлиенте
Функция НастройкиРезультатаНаКлиенте(выхАдресСхемы = Неопределено)
	
	выхАдресСхемы = Неопределено;
    НастройкаКомпоновки = Неопределено;
    ИсполняемыеСхемаИНастройка(выхАдресСхемы, НастройкаКомпоновки);
	Компоновщик = Новый КомпоновщикНастроекКомпоновкиДанных;
	Компоновщик.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(выхАдресСхемы));
	Компоновщик.ЗагрузитьНастройки(НастройкаКомпоновки);
	Результат = Компоновщик.Настройки;
	Возврат Результат;
	
КонецФункции

Функция НастройкиРезультатаНаСервере()
	
	АдресСхемы = Неопределено;
    НастройкаКомпоновки = Неопределено;
    ИсполняемыеСхемаИНастройка(АдресСхемы, НастройкаКомпоновки);
	Компоновщик = Новый КомпоновщикНастроекКомпоновкиДанных;
	Компоновщик.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемы));
	Компоновщик.ЗагрузитьНастройки(НастройкаКомпоновки);
	Результат = Компоновщик.Настройки;
	Возврат Результат;
	
КонецФункции

Процедура ИсполняемыеСхемаИНастройка(АдресСхемы, НастройкаКомпоновки)
	
	АдресСхемы = ПоместитьВоВременноеХранилище(Элементы.ДинамическийСписок.ПолучитьИсполняемуюСхемуКомпоновкиДанных(), УникальныйИдентификатор);
	НастройкаКомпоновки = Элементы.ДинамическийСписок.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	// Для поддержки динамически добавленных (пользователем) полей списка
	ОбновитьСлужебныеДанные();

КонецПроцедуры

&НаКлиенте
Процедура ОтборБезЗначенияВТекущейКолонке(Команда)
	
	ЭлементыФормы = Элементы;
	АктуализироватьПутьКДаннымТекущегоПоля(ЭлементыФормы);
	ирОбщий.ТабличноеПолеОтборБезЗначенияВТекущейКолонке_КнопкаЛкс(ЭлементыФормы.ДинамическийСписок);
	
КонецПроцедуры

&НаКлиенте
// Для поддержки динамически добавленных (пользователем) полей списка
Процедура АктуализироватьПутьКДаннымТекущегоПоля(Знач ЭлементыФормы)
	
	ДанныеКолонки = ирОбщий.ПутьКДаннымКолонкиТабличногоПоляЛкс(ЭлементыФормы.ДинамическийСписок);
	Если Не ЗначениеЗаполнено(ДанныеКолонки) Тогда
		ОбновитьСлужебныеДанные();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОтборПоЗначенияВТекущейКолонке(Команда)
	
	ЭлементыФормы = Элементы;
	ТабличноеПоле = Элементы.ДинамическийСписок;
	ДанныеТабличногоПоля = ДинамическийСписок;
	ДанныеКолонки = ирОбщий.ПутьКДаннымКолонкиТабличногоПоляЛкс(ТабличноеПоле);
	НастройкиСписка = ирОбщий.НастройкиДинамическогоСпискаЛкс(ДанныеТабличногоПоля, "Пользовательские");
	#Если Сервер И Не Сервер Тогда
		НастройкиСписка = Новый НастройкиКомпоновкиДанных;
	#КонецЕсли
	Отбор = НастройкиСписка.Отбор;
	ДоступноеПоле = ирОбщий.НайтиДоступноеПолеКомпоновкиПоИмениКолонкиЛкс(Отбор.ДоступныеПоляОтбора, ДанныеКолонки);
	#Если Сервер И Не Сервер Тогда
		ДоступноеПоле = НастройкиСписка.ДоступныеПоляВыбора.НайтиПоле(); 
	#КонецЕсли
	ЭлементОтбора = ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(Отбор, ДоступноеПоле.Поле,,,,, Ложь);
	ЗначениеЯчейки = ТабличноеПоле.ТекущиеДанные["" + ДоступноеПоле.Поле];
	ЭлементОтбора.Использование = Истина;
	Если Истина
		И ДоступноеПоле.ТипЗначения.СодержитТип(Тип("Строка"))
		И ДоступноеПоле.ТипЗначения.КвалификаторыСтроки.Длина = 0
	Тогда
		Если ЗначениеЗаполнено(ЗначениеЯчейки) Тогда
			ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Содержит;
		Иначе
			ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеСодержит;
		КонецЕсли;
	Иначе
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	КонецЕсли;
	ЭлементОтбора.ПравоеЗначение = ЗначениеЯчейки;
	Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
		ирОбщий.ПроверитьВключитьЭлементНастроекКомпоновкиВПользовательскиеНастройки(ЭлементОтбора);
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСлужебныеДанные()
	
	ирСервер.УправляемаяФорма_ОбновитьСлужебныеДанныеЛкс(ЭтаФорма,, ПоляСИсториейВыбора());

КонецПроцедуры

&НаКлиенте
Процедура ВывестиСтроки(Команда)
	
	ЭлементыФормы = Элементы;
	НастройкиСписка = НастройкиРезультатаНаКлиенте();
	ирОбщий.ВывестиСтрокиТабличногоПоляИПоказатьЛкс(ЭлементыФормы.ДинамическийСписок,, НастройкиСписка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьОтбор(Команда)
	
	ПользовательскиеНастройки = ирОбщий.НастройкиДинамическогоСпискаЛкс(ДинамическийСписок, "Пользовательские");
	Для Каждого ЭлементОтбора Из ПользовательскиеНастройки.Отбор.Элементы Цикл
		ЭлементОтбора.Использование = Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтображениеИдентификаторов(Команда)
	
	ЭлементыФормы = Элементы;
	Кнопка = ЭлементыФормы.ФормаОтображениеИдентификаторов;
	ирОбщий.КнопкаОтображатьПустыеИИдентификаторыНажатиеЛкс(Кнопка);
	ДинамическийСписок.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ОтображениеИдентификаторов", Кнопка.Заголовок);
	ЭлементыФормы.ДинамическийСписок.Обновить();
	
КонецПроцедуры

&НаКлиенте
Функция ПоследниеВыбранныеНажатие(Кнопка) Экспорт
	
	ЭлементыФормы = Элементы;
	ирОбщий.ПоследниеВыбранныеНажатиеЛкс(ЭтаФорма, ЭлементыФормы.ДинамическийСписок, , Кнопка);
	
КонецФункции

&НаКлиенте
Процедура ДинамическийСписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если РежимВыбора Тогда
		ирОбщий.ПоследниеВыбранныеДобавитьЛкс(ЭтаФорма, ВыбраннаяСтрока);
	КонецЕсли; 

КонецПроцедуры

&НаКлиенте
Процедура СтруктураФормы(Команда)
	
	ирОбщий.ОткрытьСтруктуруФормыЛкс(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ДинамическийСписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	ЭлементыФормы = Элементы;
	
	Ответ = Вопрос("Использовать редактор объекта БД?", РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет);
	Если Ответ = КодВозвратаДиалога.Да Тогда
		Отказ = Истина;
		ДобавитьСтрокуЧерезРедакторОбъектаБД(, Копирование, Группа);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьКоличествоСтрок()
	
	Если Не ирКэш.ЛиПортативныйРежимЛкс() И Не ирКэш.ЭтоФайловаяБазаЛкс() Тогда
		ФоновоеЗадание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(фОбъект.ИДФоновогоЗадания);
		Если ФоновоеЗадание.Состояние = СостояниеФоновогоЗадания.Активно Тогда
			ПодключитьОбработчикОжидания("ОбновитьКоличествоСтрок", 2, Истина);
		Иначе
			//// Антибаг 8.3.13  В обычной форме в клиент-серверном режиме из временного хранилища возвращается Неопределено https://partners.v8.1c.ru/forum/t/1768363/m/1768363
			//ФормаРезультатФоновогоЗадания.ОбновитьВременноеХранилище(фОбъект.АдресХранилищаКоличестваСтрок);
			Результат = ПолучитьИзВременногоХранилища(фОбъект.АдресХранилищаКоличестваСтрок);
		КонецЕсли; 
	Иначе
		Результат = ирОбщий.КоличествоСтрокВТаблицеБДЛкс(фОбъект.ПолноеИмяТаблицы);
	КонецЕсли;
	Если Результат <> Неопределено Тогда
		фОбъект.КоличествоСтрокВОбластиПоиска = Результат;
	КонецЕсли; 

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПослеУстановкиОбъектаМетаданныхНаКлиенте();
	Если ПараметрТекущаяКолонка <> Неопределено Тогда
		КолонкаСписка = Элементы.ДинамическийСписок.ПодчиненныеЭлементы.Найти(Элементы.ДинамическийСписок.Имя + ПараметрТекущаяКолонка);
		Если КолонкаСписка <> Неопределено Тогда
			Элементы.ДинамическийСписок.ТекущийЭлемент = КолонкаСписка;
		КонецЕсли; 
		ЭтаФорма.ПараметрТекущаяКолонка = "";
	КонецЕсли; 
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элементы.ОбъектМетаданных, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаКолонок(Команда)
	
	СохранитьНастройкиСписка();
	ФормаНастроек = ирОбщий.ПолучитьФормуЛкс("Обработка.ирДинамическийСписок.Форма.НастройкиКолонок",, ЭтаФорма);
	ФормаНастроек.ОбработкаОбъект1.НастройкиКолонок.Загрузить(НастройкаКолонокСервер());
	Для Каждого СтрокаНастройкиКолонки Из ФормаНастроек.ОбработкаОбъект1.НастройкиКолонок Цикл
		ДоступноеПоле = ДинамическийСписок.КомпоновщикНастроек.Настройки.ДоступныеПоляВыбора.НайтиПоле(Новый ПолеКомпоновкиДанных(СтрокаНастройкиКолонки.Имя));
		Если ДоступноеПоле = Неопределено Тогда
			Продолжить;
		КонецЕсли; 
		СтрокаНастройкиКолонки.ТипЗначения = ДоступноеПоле.Тип;
	КонецЦикла;
	Если Элементы.ДинамическийСписок.ТекущийЭлемент <> Неопределено Тогда
		ФормаНастроек.ПараметрИмяТекущейКолонки = ИмяКолонкиБезРодителя(ЭтаФорма, Элементы.ДинамическийСписок.ТекущийЭлемент);
	КонецЕсли; 
	ВыбранноеЗначение = ФормаНастроек.ОткрытьМодально();
	ОбработатьВыборНастроекКолонок(ВыбранноеЗначение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыборНастроекКолонок(Знач ВыбранноеЗначение)
	
	ОбработатьВыборНастроекКолонокСервер(ВыбранноеЗначение);

КонецПроцедуры

Процедура ОбработатьВыборНастроекКолонокСервер(Знач ВыбранноеЗначение)
	
	СтарыеНастройки = фОбъект.НастройкиКолонок.Выгрузить();
	Если ВыбранноеЗначение <> Неопределено Тогда
		Если ВыбранноеЗначение.Свойство("НастройкиКолонок") Тогда
			Если ВыбранноеЗначение.ПрименятьПорядок Тогда
				фОбъект.НастройкиКолонок.Загрузить(ВыбранноеЗначение.НастройкиКолонок);
			Иначе
				Для Каждого СтрокаКолонки Из фОбъект.НастройкиКолонок Цикл
					СтрокаНастройки = ВыбранноеЗначение.НастройкиКолонок.Найти(СтрокаКолонки.Имя, "Имя");
					ЗаполнитьЗначенияСвойств(СтрокаКолонки, СтрокаНастройки,, "Имя"); 
				КонецЦикла;
			КонецЕсли; 
		КонецЕсли; 
		Если ВыбранноеЗначение.Свойство("ТекущаяКолонка") Тогда
			Элементы.ДинамическийСписок.ТекущийЭлемент = Элементы.ДинамическийСписок.ПодчиненныеЭлементы.Найти(Элементы.ДинамическийСписок.Имя + ВыбранноеЗначение.ТекущаяКолонка);
		КонецЕсли; 
	КонецЕсли; 
	ПрименитьНастройкиКолонок();
	Если ВыбранноеЗначение <> Неопределено И ВыбранноеЗначение.Свойство("Сохранить") И ВыбранноеЗначение.Сохранить Тогда
		СохранитьНастройкиСписка();
	Иначе
		фОбъект.НастройкиКолонок.Загрузить(СтарыеНастройки);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		ОбработатьВыборНастроекКолонок(ВыбранноеЗначение);
	КонецЕсли; 
	
КонецПроцедуры

Функция НастройкаКолонокСервер()
	
	Возврат фОбъект.НастройкиКолонок.Выгрузить();

КонецФункции

&НаКлиенте
Процедура ПраваДоступаКСтрокамНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Форма = ирОбщий.ПолучитьФормуЛкс("Отчет.ирАнализПравДоступа.Форма",,, фОбъект.ПолноеИмяТаблицы);
	Форма.ПолноеИмяТаблицы = фОбъект.ПолноеИмяТаблицы;
	Форма.Пользователь = ИмяПользователя();
	Форма.ПараметрКлючВарианта = "ПоПользователям";
	Форма.Открыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьСтрокуЧерезРедакторОбъектаБД(Команда = Неопределено, Копирование = Неопределено, ЭтоГруппа = Ложь)
	
	ИмяПоляСсылка = ирОбщий.ПеревестиСтроку("Ссылка");
	ИмяПоляЭтоГруппа = ирОбщий.ПеревестиСтроку("ЭтоГруппа");
	ЭлементыФормы = Элементы;
	Если Копирование = Неопределено Тогда
		Если ЭлементыФормы.ДинамическийСписок.ТекущаяСтрока <> Неопределено Тогда
			Ответ = Вопрос("Хотите скопировать текущую строку?", РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет);
			Копирование = Ответ = КодВозвратаДиалога.Да;
		Иначе
			Копирование = Ложь;
		КонецЕсли; 
	КонецЕсли; 
	ОбъектМД = Метаданные.НайтиПоПолномуИмени(фОбъект.ПолноеИмяТаблицы);
	Если ирОбщий.ЛиКорневойТипСсылочногоОбъектаБДЛкс(ирОбщий.ПервыйФрагментЛкс(фОбъект.ПолноеИмяТаблицы)) Тогда
		Если ПравоДоступа("Добавление", ОбъектМД) Тогда
			Отбор = ДинамическийСписок.КомпоновщикНастроек.ПолучитьНастройки().Отбор;
			ЭлементОтбораЭтоГруппа = ирОбщий.НайтиЭлементОтбораКомпоновкиЛкс(Отбор, ИмяПоляЭтоГруппа);
			Если Копирование Тогда
				СтруктураОбъекта = ирОбщий.ОбъектБДПоКлючуЛкс(фОбъект.ПолноеИмяТаблицы, ЭлементыФормы.ДинамическийСписок.ТекущаяСтрока);
				СтруктураОбъекта = ирОбщий.КопияОбъектаБДЛкс(СтруктураОбъекта);
			Иначе
				ЭтоГруппа = Ложь
					Или ЭтоГруппа = Истина
					Или (Истина
						И ирОбщий.ЛиМетаданныеОбъектаСГруппамиЛкс(ОбъектМД)
						И ЭлементОтбораЭтоГруппа <> Неопределено
						И ЭлементОтбораЭтоГруппа.Использование = Истина
						И ЭлементОтбораЭтоГруппа.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно
						И ЭлементОтбораЭтоГруппа.Значение = Истина);
				СтруктураОбъекта = ирОбщий.ОбъектБДПоКлючуЛкс(фОбъект.ПолноеИмяТаблицы, ЭтоГруппа);
			КонецЕсли; 
			ирОбщий.УстановитьЗначенияРеквизитовПоОтборуЛкс(СтруктураОбъекта.Данные, Отбор);
			ирОбщий.ОткрытьОбъектВРедактореОбъектаБДЛкс(СтруктураОбъекта);
		Иначе
			ирОбщий.ОткрытьОбъектВРедактореОбъектаБДЛкс(Новый(ирОбщий.ИмяТипаИзПолногоИмениТаблицыБДЛкс(фОбъект.ПолноеИмяТаблицы, "Ссылка")));
		КонецЕсли; 
	Иначе
		КлючОбъекта = ирОбщий.СтруктураКлючаТаблицыБДЛкс(фОбъект.ПолноеИмяТаблицы, Ложь);
		Для Каждого КлючИЗначение Из КлючОбъекта Цикл
			Если Копирование Тогда
				КлючОбъекта[КлючИЗначение.Ключ] = ЭлементыФормы.ДинамическийСписок.ТекущаяСтрока[КлючИЗначение.Ключ];
			КонецЕсли; 
		КонецЦикла;
		СтруктураОбъекта = ирОбщий.ОбъектБДПоКлючуЛкс(фОбъект.ПолноеИмяТаблицы, КлючОбъекта);
		ирОбщий.ОткрытьСсылкуВРедактореОбъектаБДЛкс(СтруктураОбъекта);
	КонецЕсли; 
	
КонецПроцедуры


&НаКлиенте
Процедура СвязанныйРедакторОбъектаБДСтроки(Команда)
	
	Элементы.ФормаСвязанныйРедакторОбъектаБДСтроки.Пометка = Не Элементы.ФормаСвязанныйРедакторОбъектаБДСтроки.Пометка;
	Если Не Элементы.ФормаСвязанныйРедакторОбъектаБДСтроки.Пометка Тогда
		Возврат;
	КонецЕсли; 
	Если Элементы.ДинамическийСписок.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ОткрытьСвязанныйРедакторОбъектаБДСтроки();
	//Сообщить("Закрепите окно связанного редактора БД через его контекстное меню на панели открытых окон");

КонецПроцедуры

&НаКлиенте
Процедура ДинамическийСписокПриАктивизацииСтроки(Элемент)
	
	Если Элементы.ФормаСвязанныйРедакторОбъектаБДСтроки.Пометка Тогда
		ОткрытьСвязанныйРедакторОбъектаБДСтроки();
	КонецЕсли; 

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСвязанныйРедакторОбъектаБДСтроки()
	
	ирОбщий.ОткрытьТекущуюСтрокуТабличногоПоляТаблицыБДВРедактореОбъектаБДЛкс(Элементы.ДинамическийСписок, фОбъект.ПолноеИмяТаблицы,, Истина,,, Ложь);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗакрытСвязанныйРедакторОбъектаБД" Тогда
		Элементы.ФормаСвязанныйРедакторОбъектаБДСтроки.Пометка = Ложь;
	КонецЕсли; 
	Если ИмяСобытия = "ЗаписанОбъект" Тогда
		Если ТипЗнч(Параметр) = Тип("Тип") Тогда
			ОбъектМД = Метаданные.НайтиПоТипу(Параметр);
		ИначеЕсли ТипЗнч(Параметр) = Тип("Строка") Тогда
			ОбъектМД = Метаданные.НайтиПоПолномуИмени(Параметр);
		Иначе
			ОбъектМД = Метаданные.НайтиПоТипу(ТипЗнч(Параметр));
		КонецЕсли; 
		Если Ложь
			Или Параметр = Неопределено
			Или (Истина
				И ОбъектМД <> Неопределено 
				И ОбъектМД.ПолноеИмя() = фОбъект.ПолноеИмяТаблицы)
		Тогда
			Элементы.ДинамическийСписок.Обновить();
		КонецЕсли; 
	КонецЕсли; 
	ирОбщий.ФормаОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 
	
КонецПроцедуры

&НаКлиенте
Процедура НайтиВыбратьПоID(Команда)
	
	Если Не ЗначениеЗаполнено(фОбъект.ПолноеИмяТаблицы) Тогда
		Возврат;
	КонецЕсли; 
	ирОбщий.НайтиВыбратьСсылкуВДинамическомСпискеПоIDЛкс(Элементы.ДинамическийСписок);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОбъектМетаданных(Команда)
	
	ирОбщий.ОткрытьОбъектМетаданныхЛкс(фОбъект.ПолноеИмяТаблицы);

КонецПроцедуры

&НаКлиенте
Процедура СправкаМетаданного(Команда)
	
	ОткрытьСправку(Метаданные.НайтиПоПолномуИмени(фОбъект.ПолноеИмяТаблицы));

КонецПроцедуры

&НаКлиенте
Процедура СоединяемыеРегистрыПриИзменении(Элемент)
	
	СохранитьНастройкиСписка();
	УстановитьОбъектМетаданных();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	ирОбщий.ОтменитьФоновоеЗаданиеЛкс(фОбъект.ИДФоновогоЗадания);
	Если ЗавершениеРаботы <> Истина Тогда
		СохранитьНастройкиСписка();
	КонецЕсли; 

КонецПроцедуры

&НаКлиенте
Процедура ФиксированныйОтборОткрытие(Элемент, СтандартнаяОбработка)
	
	НастройкаСписка(, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ДинамическийСписокОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура СтруктураКоманднойПанели(Команда)

	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Элементы.ФормаСтруктураКоманднойПанели);

КонецПроцедуры

#КонецЕсли





