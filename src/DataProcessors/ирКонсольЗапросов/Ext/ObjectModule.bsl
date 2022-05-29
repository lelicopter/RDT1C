﻿//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирПривилегированный Экспорт;

Перем мОбъектЗапроса Экспорт; // запрос
Перем мКомандаADO Экспорт; // запрос
Перем мСоединениеADO Экспорт; // запрос
Перем мWMIService Экспорт; // запрос
Перем мСтрокаЗапросаПараметра Экспорт ;
Перем мРежимРедактораЗапроса Экспорт; // Консоль открывается для редактирования одного запроса
Перем мСсылка Экспорт;
Перем мРедактируемыйНаборДанных Экспорт;
Перем мРежимОтладки Экспорт;
Перем мКоллекцияДляЗаполнения Экспорт;
Перем мПлатформыADODB Экспорт;
Перем мВременныеТаблицыМенеджера1СПриОткрытии Экспорт; // Структура имен временных таблиц 1С менеджера временных таблиц при открытии формы

Функция НоваяТаблицаПараметров()

	ТаблицаПараметров = Новый ТаблицаЗначений;
	
	// Порядок должен соответствовать установленному в табличном поле!
	ТаблицаПараметров.Колонки.Добавить("ИмяПараметра", Новый ОписаниеТипов("Строка", Новый КвалификаторыСтроки(100))); // Квалификатор продублирован в поле ввода колонки
	ТаблицаПараметров.Колонки.Добавить("ЭтоВыражение");
	ТаблицаПараметров.Колонки.Добавить("Выражение", Новый ОписаниеТипов("Строка"));
	ТаблицаПараметров.Колонки.Добавить("ИмяФайла", Новый ОписаниеТипов("Строка"));
	ТаблицаПараметров.Колонки.Добавить("ИмяТипаЗначения", Новый ОписаниеТипов("Строка"));
	ТаблицаПараметров.Колонки.Добавить("ТекущийТипЗначения", Новый ОписаниеТипов("Строка"));
	ТаблицаПараметров.Колонки.Добавить("ТипЗначения", Новый ОписаниеТипов("ОписаниеТипов"));
	ТаблицаПараметров.Колонки.Добавить("НеИспользоватьОграничениеТипа", Новый ОписаниеТипов("Булево"));
	ТаблицаПараметров.Колонки.Добавить("Значение"); // Без колонки ТП
	ТаблицаПараметров.Колонки.Добавить("НИмяПараметра", ТаблицаПараметров.Колонки.ИмяПараметра.ТипЗначения); // Без колонки ТП
	Возврат ТаблицаПараметров;

КонецФункции

Процедура ОбновитьТипЗначенияВСтрокеПараметров(Знач СтрокаПараметра) Экспорт 
	
	ирОбщий.ОбновитьТипЗначенияВСтрокеТаблицыЛкс(СтрокаПараметра, , "ТипЗначения", "ТекущийТипЗначения");

КонецПроцедуры

Процедура ИнициализацияСлужебногоРежима() Экспорт 

	//ЭтотОбъект.АвтосохранениеТекущегоФайла = Ложь;
	мСтрокаЗапросаПараметра = ДеревоЗапросов.Строки.Добавить();
	мСтрокаЗапросаПараметра.ПараметрыЗапроса = НоваяТаблицаПараметров();
	ЗаполнитьЗначенияСвойств(мСтрокаЗапросаПараметра, ЗначенияПоУмолчаниюСтрокиЗапроса()); 

КонецПроцедуры

Процедура ДобавитьПараметрыИзЗапроса(Знач пЗапросОтладки, пСтрокаЗапроса)

	ТаблицаПараметров = пСтрокаЗапроса.ПараметрыЗапроса;
	ОписаниеТиповЭлементаУправленияПараметра = ТаблицаПараметров.Колонки.Значение.ТипЗначения;
	МаркерНеверныхПараметров = "Неверные параметры";
	ЗапросОтладки = Новый Запрос(пЗапросОтладки.Текст);
	ЗапросОтладки.МенеджерВременныхТаблиц = пЗапросОтладки.МенеджерВременныхТаблиц;
	Попытка
		ПараметрыЗапроса = ЗапросОтладки.НайтиПараметры();
	Исключение
		Сообщить(ОписаниеОшибки());
		ПараметрыЗапроса = Новый Массив;
	КонецПопытки;
	// Получим значения использованных в тексте параметров
	Для каждого ПараметрЗапроса Из ПараметрыЗапроса Цикл
		Если ТаблицаПараметров.Найти(ПараметрЗапроса.Имя, "НИмяПараметра") <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		ИмяПараметра =  ПараметрЗапроса.Имя;
		СтрокаПараметров = ТаблицаПараметров.Добавить();
		СтрокаПараметров.ИмяПараметра = ИмяПараметра;
		ирОбщий.ОбновитьКопиюСвойстваВНижнемРегистреЛкс(СтрокаПараметров, "ИмяПараметра");
		СтрокаПараметров.ЭтоВыражение = Ложь;
		СтрокаПараметров.ТипЗначения = ПараметрЗапроса.ТипЗначения;
		ЗначениеПараметраЗапроса = 0;
		Если пЗапросОтладки.Параметры.Свойство(ИмяПараметра, ЗначениеПараметраЗапроса) Тогда
			ЗначениеПараметраЗапроса = ирОбщий.ПолучитьСовместимоеЗначениеПараметраЗапросаЛкс(ЗначениеПараметраЗапроса, ИмяПараметра, ОписаниеТиповЭлементаУправленияПараметра);
			ТипЗначенияПараметра = ТипЗнч(ЗначениеПараметраЗапроса);
			СтрокаПараметров.Значение = ЗначениеПараметраЗапроса; 
			Если ТипЗначенияПараметра = Тип("СписокЗначений") Тогда 
				СтрокаПараметров.ЭтоВыражение = 2;
			ИначеЕсли ОписаниеТиповЭлементаУправленияПараметра.СодержитТип(ТипЗначенияПараметра) Тогда
			Иначе
				СтрокаПараметров.НеИспользоватьОграничениеТипа = Истина;
			КонецЕсли;
		КонецЕсли;
		ОбновитьТипЗначенияВСтрокеПараметров(СтрокаПараметров);
	КонецЦикла;
	// Получим значения установленных параметров
	ДополнитьТаблицуПараметровЗапросаПоСтруктуре(пЗапросОтладки.Параметры, ТаблицаПараметров);

КонецПроцедуры // ДобавитьПараметрыИзЗапроса()

Функция ДополнитьТаблицуПараметровЗапросаПоСтруктуре(СтруктураПараметров, пТаблицаПараметров, ПерезаписыватьСуществующие = Ложь) Экспорт 

	Для каждого КлючИЗначение Из СтруктураПараметров Цикл
		ИмяПараметра = КлючИЗначение.Ключ;
		СтрокаПараметров = пТаблицаПараметров.Найти(НРег(ИмяПараметра), "НИмяПараметра");
		Если Истина
			И Не ПерезаписыватьСуществующие 
			И СтрокаПараметров <> Неопределено 
		Тогда
			Продолжить;
		КонецЕсли;
		Если СтрокаПараметров = Неопределено Тогда
			СтрокаПараметров = пТаблицаПараметров.Добавить();
			СтрокаПараметров.ИмяПараметра = ИмяПараметра;
			ирОбщий.ОбновитьКопиюСвойстваВНижнемРегистреЛкс(СтрокаПараметров, "ИмяПараметра");
		КонецЕсли; 
		СтрокаПараметров.ЭтоВыражение = Ложь;
		СтрокаПараметров.Значение = КлючИЗначение.Значение;
		Если ТипЗнч(КлючИЗначение.Значение) = Тип("СписокЗначений") Тогда 
			СтрокаПараметров.ЭтоВыражение = 2;
		КонецЕсли;
		ОбновитьТипЗначенияВСтрокеПараметров(СтрокаПараметров);
	КонецЦикла;
	Возврат Неопределено;

КонецФункции

#Если Клиент Тогда
	
Функция ОткрытьПоОбъектуМетаданных(ПолноеИмяМД) Экспорт
	
	ИнициализацияСлужебногоРежима();
	ТекстЗапроса = "ВЫБРАТЬ 
	|	* 
	|ИЗ
	|	" + ПолноеИмяМД + " КАК Т";
	мСтрокаЗапросаПараметра.ТекстЗапроса = ТекстЗапроса;
	мСтрокаЗапросаПараметра.Запрос = ПолноеИмяМД;
	Форма = ЭтотОбъект.ПолучитьФорму();
	Форма.Открыть();
	Возврат Форма;
	
КонецФункции 

// ТекстЗапроса - Строка - используется только в случае, если сам объект не содержит свойста с текстом (например WMI)
// ТекстЗапросаИлиИменаВременныхТаблиц - Строка, - текст запроса или имена временных таблиц через запятую
Функция ОткрытьДляОтладки(Знач Запрос, ТипЗапроса = "Обычный", ИмяЗапроса = "Запрос для отладки", Модально = Истина, ТекстЗапросаИлиИменаВременныхТаблиц = "") Экспорт
	
	ИнициализацияСлужебногоРежима();
	Если ТипЗнч(Запрос) = Тип("COMОбъект") Тогда
		ТекстЗапроса = ТекстЗапросаИлиИменаВременныхТаблиц;
		ТипЗапроса = "WQL";
		мWMIService = Запрос;
		Попытка
			ТекстЗапроса = Запрос.CommandText;
			ЭтоКомандаADO = Истина;
			ТипЗапроса = "ADO";
			мКомандаADO = Запрос;
		Исключение
			ЭтоКомандаADO = Ложь;
			Попытка
				Пустышка = Запрос.ConnectionString;
				ЭтоСоединениеADO = Истина;
				ТипЗапроса = "ADO";
				мСоединениеADO = Запрос;
			Исключение
				ЭтоСоединениеADO = Ложь;
			КонецПопытки; 
		КонецПопытки; 
	Иначе
		#Если Сервер И Не Сервер Тогда
			Запрос = Новый Запрос;
		#КонецЕсли
		мОбъектЗапроса = Новый Запрос;
		мОбъектЗапроса.МенеджерВременныхТаблиц = Запрос.МенеджерВременныхТаблиц;
		ТекстЗапроса = Запрос.Текст;
	КонецЕсли; 
	мСтрокаЗапросаПараметра.ТекстЗапроса = ТекстЗапроса;
	мСтрокаЗапросаПараметра.Запрос = ИмяЗапроса;
	мСтрокаЗапросаПараметра.ТипЗапроса = ТипЗапроса;
	мРежимОтладки = Истина;
	Форма = ЭтотОбъект.ПолучитьФорму();
	мСтрокаЗапросаПараметра.ПараметрыЗапроса = НоваяТаблицаПараметров();
	Если ТипЗнч(Запрос) = Тип("COMОбъект") Тогда
		Если ТипЗапроса = "ADO" Тогда
			Если ЭтоКомандаADO Тогда
				Форма.СтрокаСоединенияADO = Запрос.ActiveConnection.ConnectionString;
				Форма.ИменованныеПараметрыADO = Запрос.NamedParameters;
				Если Запрос.NamedParameters Тогда
					СтруктураПараметров = Новый Структура();
					Для Каждого Parameter Из Запрос.Parameters Цикл
						КлючПараметра = Parameter.Name;
						Если Не ирОбщий.ЛиИмяПеременнойЛкс(КлючПараметра) Тогда
							КлючПараметра = "_" + КлючПараметра;
						КонецЕсли; 
						Если Не ирОбщий.ЛиИмяПеременнойЛкс(КлючПараметра) Тогда
							КлючПараметра = КлючПараметра + XMLСтрока(СтруктураПараметров.Количество());
						КонецЕсли; 
						Если СтруктураПараметров.Свойство(КлючПараметра) Тогда
							ВызватьИсключение "Не удалось назначить параметру уникальное имя";
						КонецЕсли;
						СтруктураПараметров.Вставить(КлючПараметра, Parameter.Value);
					КонецЦикла;
				Иначе
					СтруктураПараметров = Новый ТаблицаЗначений;
					СтруктураПараметров.Колонки.Добавить("Ключ");
					СтруктураПараметров.Колонки.Добавить("Значение");
					Для Каждого Parameter Из Запрос.Parameters Цикл
						СтрокаТаблицы = СтруктураПараметров.Добавить();
						СтрокаТаблицы.Ключ = Parameter.Name;
						СтрокаТаблицы.Значение = Parameter.Value;
					КонецЦикла;
				КонецЕсли; 
				ДополнитьТаблицуПараметровЗапросаПоСтруктуре(СтруктураПараметров, мСтрокаЗапросаПараметра.ПараметрыЗапроса);
			Иначе
				Форма.СтрокаСоединенияADO = Запрос.ConnectionString;
			КонецЕсли; 
			Форма.ПлатформаADO = НайтиПлатформуADOПоСтрокеСоединения(Форма.СтрокаСоединенияADO);
		КонецЕсли; 
	Иначе
		ДобавитьПараметрыИзЗапроса(Запрос, мСтрокаЗапросаПараметра);
		ИменаВременныхТаблиц = ирОбщий.ИменаИспользуемыхВЗапросеВременныхТаблицЛкс(Запрос, ТекстЗапросаИлиИменаВременныхТаблиц);
		Для Каждого ИмяВременнойТаблицы Из ИменаВременныхТаблиц Цикл
			//Если Не ирОбщий.ЛиИмяПеременнойЛкс(ИмяВременнойТаблицы) Тогда
			//	ВызватьИсключение "Указано некорректное имя временной таблицы """ + ИмяВременнойТаблицы + """";
			//КонецЕсли; 
			Запрос = Новый Запрос;
			Запрос.МенеджерВременныхТаблиц = мОбъектЗапроса.МенеджерВременныхТаблиц;
			Запрос.Текст = "ВЫБРАТЬ 1 ИЗ " + ИмяВременнойТаблицы + " КАК Т ГДЕ ЛОЖЬ";
			Попытка
				Запрос.Выполнить();
			Исключение
				Продолжить;
			КонецПопытки; 
			мВременныеТаблицыМенеджера1СПриОткрытии.Вставить(НРег(ИмяВременнойТаблицы), ИмяВременнойТаблицы);
		КонецЦикла; 
	КонецЕсли;
	Если Модально Тогда
		Возврат Форма.ОткрытьМодально();
	Иначе
		Форма.Открыть();
	КонецЕсли;
	
КонецФункции 

Функция ОткрытьЗапросБД(Знач ТекстЗапроса, ИмяЗапроса = "Запрос для отладки", Параметры = Неопределено, Автоподключение = Ложь) Экспорт
	
	ИнициализацияСлужебногоРежима();
	мСтрокаЗапросаПараметра.ТекстЗапроса = ТекстЗапроса;
	мСтрокаЗапросаПараметра.Запрос = ИмяЗапроса;
	мСтрокаЗапросаПараметра.ТипЗапроса = "ADO";
	мРежимОтладки = Истина;
	мСтрокаЗапросаПараметра.ПараметрыЗапроса = НоваяТаблицаПараметров();
	Если Параметры <> Неопределено Тогда
		Для каждого СтрокаПараметраИсточника Из Параметры Цикл
			СтрокаПараметров = мСтрокаЗапросаПараметра.ПараметрыЗапроса.Добавить();
			СтрокаПараметров.ИмяПараметра = СтрокаПараметраИсточника.Имя;
			ирОбщий.ОбновитьКопиюСвойстваВНижнемРегистреЛкс(СтрокаПараметров, "ИмяПараметра");
			СтрокаПараметров.ЭтоВыражение = Ложь;
			СтрокаПараметров.Значение = СтрокаПараметраИсточника.Значение;
		КонецЦикла; 
	КонецЕсли;
	ИсточникДанных = ПолучитьСтруктуруИсточникаДанныхADO();
	ЗаполнитьПараметрыADOДляЭтойБД(ИсточникДанных, Автоподключение);
	мСтрокаЗапросаПараметра.ПараметрыADO = ИсточникДанных;
	Форма = ЭтотОбъект.ПолучитьФорму();
	Форма.Открыть();
	
КонецФункции

Процедура ЗаполнитьПараметрыADOДляЭтойБД(Знач ИсточникДанных, Автоподключение = Ложь) Экспорт 
	
	ПараметрыСоединения = ирОбщий.ПараметрыСоединенияADOЭтойБДЛкс();
	//ФормаПодключения.Закрыть();
	ИсточникДанных.Платформа = 11; // ADO-SQLOLEDB
	Если Не ирКэш.ЛиФайловаяБазаЛкс() Тогда
		ИсточникДанных.БазаСервер = ПараметрыСоединения.ИмяСервера;
		ИсточникДанных.БазаИмя = ПараметрыСоединения.ИмяБД;
	КонецЕсли; 
	ИсточникДанных.АутентификацияОС = Не ЗначениеЗаполнено(ПараметрыСоединения.ИмяПользователя);
	ИсточникДанных.Пользователь = ПараметрыСоединения.ИмяПользователя;
	ИсточникДанных.Пароль = ПараметрыСоединения.Пароль;
	ИсточникДанных.Вставить("Типизировать1С", Истина);
	ИсточникДанных.Вставить("БинарныеВСтроку", Истина);
	ИсточникДанных.Вставить("ИспользованиеGWF", 1);
	ИсточникДанных.Вставить("СмещениеГодаADO", 2000);
	//ИсточникДанных.Вставить("РасширенноеПолучениеМетаданных", РасширенноеПолучениеМетаданных);

КонецПроцедуры 

//Параметры:
// Коллекция - ТаблицаЗначений, ДеревоЗначений - если без колонок, то результату разрешается иметь произвольные колонки, иначе они фиксированы
// Запрос - Запрос, *Неопределено - начальный запрос
Функция ОткрытьДляЗаполненияКоллекции(Знач КоллекцияДляЗаполнения, Запрос = Неопределено, ТипЗапроса = "Компоновка", Имя = "Запрос") Экспорт
	
	мКоллекцияДляЗаполнения = КоллекцияДляЗаполнения;
	мРежимЗаполненияКоллекции = Истина;
	ИнициализацияСлужебногоРежима();
	мСтрокаЗапросаПараметра.Запрос = Имя;
	мСтрокаЗапросаПараметра.ТипЗапроса = ТипЗапроса;
	Если Запрос <> Неопределено Тогда
		ТекстЗапроса = Запрос.Текст;
		мСтрокаЗапросаПараметра.ТекстЗапроса = ТекстЗапроса;
	КонецЕсли; 
	Форма = ЭтотОбъект.ПолучитьФорму();
	Если Запрос <> Неопределено Тогда
		ДобавитьПараметрыИзЗапроса(Запрос, мСтрокаЗапросаПараметра);
	КонецЕсли; 
	Результат = Форма.ОткрытьМодально();
	Если Форма.ЭлементыФормы.РезультатКоллекция.Значение.Количество() > 0 Тогда
		Ответ = Вопрос("Хотите заполнить коллекцию полученным результатом?", РежимДиалогаВопрос.ОКОтмена);
		Если Ответ = КодВозвратаДиалога.ОК Тогда
			Возврат Форма.ЭлементыФормы.РезультатКоллекция.Значение;
		КонецЕсли;
	КонецЕсли; 
	Возврат Неопределено;
	
КонецФункции

Функция ОткрытьПоПостроителю(Знач Построитель, ИмяЗапроса = "Исполняемый запрос построителя") Экспорт
	
	ИнициализацияСлужебногоРежима();
	мСтрокаЗапросаПараметра.Запрос = ИмяЗапроса;
	ЗапросОтладки = Построитель.ПолучитьЗапрос();
	мСтрокаЗапросаПараметра.ТекстЗапроса = ЗапросОтладки.Текст;
	мСтрокаЗапросаПараметра.ТипЗапроса = "Построитель";
	Форма = ЭтотОбъект.ПолучитьФорму();
	ДобавитьПараметрыИзЗапроса(ЗапросОтладки, мСтрокаЗапросаПараметра);
	мРежимОтладки = Истина;
	Форма.Открыть();
	
КонецФункции 

Функция ОткрытьПоТаблицеЗначений(Знач ТаблицаЗначений) Экспорт
	
	ИнициализацияСлужебногоРежима();
	ИмяПараметра = "ТЗ";
	мСтрокаЗапросаПараметра.ТекстЗапроса = ирОбщий.ТекстЗапросаПоместитьИзПараметраЛкс("ТЗ", ИмяПараметра,,, Истина);
	мСтрокаЗапросаПараметра.Запрос = "Запрос к таблице значений";
	ДополнитьТаблицуПараметровЗапросаПоСтруктуре(Новый Структура(ИмяПараметра, ТаблицаЗначений), мСтрокаЗапросаПараметра.ПараметрыЗапроса);
	Форма = ЭтотОбъект.ПолучитьФорму();
	Форма.Открыть();
	
КонецФункции 

Функция ОткрытьПоМакетуКомпоновки(Знач МакетКомпоновки, Модально = Истина) Экспорт
	
	//ИнициализацияСлужебногоРежима();
	//ЭтотОбъект.АвтосохранениеТекущегоФайла = Ложь;
	ДобавитьМакетКомпоновки(ДеревоЗапросов, МакетКомпоновки);
	мРежимОтладки = Истина;
	Форма = ЭтотОбъект.ПолучитьФорму();
	Если Модально Тогда
		Возврат Форма.ОткрытьМодально();
	Иначе
		Форма.Открыть();
	КонецЕсли;
	
КонецФункции

#КонецЕсли

Процедура ДобавитьНаборыДанных(Родитель, ПараметрыЗапроса, НаборыДанных)

	Для каждого НаборДанных Из НаборыДанных Цикл
		лСтрокаЗапроса = Неопределено;
		Если ТипЗнч(НаборДанных) = Тип("НаборДанныхЗапросМакетаКомпоновкиДанных") Тогда
			лСтрокаЗапроса = Родитель.Строки.Добавить();
			лСтрокаЗапроса.Запрос = НаборДанных.Имя;
			лСтрокаЗапроса.ТекстЗапроса = НаборДанных.Запрос;
			лСтрокаЗапроса.ПараметрыЗапроса = ПараметрыЗапроса.Скопировать();
			лСтрокаЗапроса.ТипЗапроса = "Компоновка";
		ИначеЕсли ТипЗнч(НаборДанных) = Тип("НаборДанныхОбъединениеМакетаКомпоновкиДанных") Тогда
			лСтрокаЗапроса = Родитель.Строки.Добавить();
			лСтрокаЗапроса.Запрос = "Объединение - " + НаборДанных.Имя;
			лСтрокаЗапроса.ТипЗапроса = "Папка";
			ДобавитьНаборыДанных(лСтрокаЗапроса, ПараметрыЗапроса, НаборДанных.Элементы);
		КонецЕсли;
		Если ТипЗнч(НаборДанных) <> Тип("ВложенныйНаборДанныхМакетаКомпоновкиДанных") Тогда
			Если НаборДанных.ВложенныеНаборыДанных.Количество() > 0 Тогда
				Если лСтрокаЗапроса = Неопределено Тогда
					лСтрокаЗапроса = Родитель.Строки.Добавить();
					лСтрокаЗапроса.Запрос = НаборДанных.Имя;
					лСтрокаЗапроса.ТипЗапроса = "Папка";
				КонецЕсли;
				ДобавитьНаборыДанных(лСтрокаЗапроса, ПараметрыЗапроса, НаборДанных.ВложенныеНаборыДанных);
			КонецЕсли;
		КонецЕсли; 
	КонецЦикла;

КонецПроцедуры // ДобавитьНаборыДанных()

Функция ДобавитьМакетКомпоновки(СтрокаДереваЗапросов, МакетКомпоновки, РодительскиеЗначенияПараметров = Неопределено, СвязиПараметров = Неопределено)

	ПараметрыЗапроса = НоваяТаблицаПараметров();
	Если РодительскиеЗначенияПараметров <> Неопределено Тогда
		Для Каждого СвязьПараметра Из СвязиПараметров Цикл
			ИмяПараметра = Сред(СвязьПараметра.Значение, 2);
			ЗначениеПараметра = РодительскиеЗначенияПараметров.Найти(ИмяПараметра).Значение;
			ДобавитьПараметрЗапросаЛкс(ПараметрыЗапроса, ИмяПараметра, ЗначениеПараметра);
		КонецЦикла;
	КонецЕсли; 
	ЗаполнитьПараметрыИзМакетаКомпоновки(ПараметрыЗапроса, МакетКомпоновки.ЗначенияПараметров);
	ДобавитьНаборыДанных(СтрокаДереваЗапросов, ПараметрыЗапроса, МакетКомпоновки.НаборыДанных);
	Для Каждого ЭлементТела Из МакетКомпоновки.Тело Цикл
		Если ТипЗнч(ЭлементТела) = Тип("ВложенныйОбъектМакетаКомпоновкиДанных") Тогда
			Если ЭлементТела.КомпоновкаДанных.НаборыДанных.Количество() > 0 Тогда
				лСтрокаЗапроса = СтрокаДереваЗапросов.Строки.Добавить();
				лСтрокаЗапроса.Запрос = ЭлементТела.Имя;
				лСтрокаЗапроса.ТипЗапроса = "Папка";
				ДобавитьМакетКомпоновки(лСтрокаЗапроса, ЭлементТела.КомпоновкаДанных, МакетКомпоновки.ЗначенияПараметров, ЭлементТела.ЗначенияПараметров);
			КонецЕсли;
		КонецЕсли; 
	КонецЦикла;

КонецФункции

Процедура ЗаполнитьПараметрыИзМакетаКомпоновки(ПараметрыЗапроса, ЗначенияПараметров)

	Для Каждого ЗначениеПараметра Из ЗначенияПараметров Цикл
		ИмяПараметра = ЗначениеПараметра.Имя;
		ЗначениеПараметра = ЗначениеПараметра.Значение;
		Если ПараметрыЗапроса.Найти(ИмяПараметра, "ИмяПараметра") <> Неопределено Тогда
			Продолжить;
		КонецЕсли; 
		ДобавитьПараметрЗапросаЛкс(ПараметрыЗапроса, ИмяПараметра, ЗначениеПараметра);
	КонецЦикла;

КонецПроцедуры

Процедура ДобавитьПараметрЗапросаЛкс(ПараметрыЗапроса, Знач ИмяПараметра, Знач ЗначениеПараметра)
	
	СтрокаПараметров = ПараметрыЗапроса.Добавить();
	СтрокаПараметров.ИмяПараметра = ИмяПараметра;
	ирОбщий.ОбновитьКопиюСвойстваВНижнемРегистреЛкс(СтрокаПараметров, "ИмяПараметра");
	СтрокаПараметров.Значение = ЗначениеПараметра; 
	//ПараметрСхемы = Неопределено;
	//Если СхемаКомпоновки <> Неопределено Тогда 
	//	ПараметрСхемы = СхемаКомпоновки.Параметры.Найти(Значение.Имя);
	//КонецЕсли; 
	Если ТипЗнч(СтрокаПараметров.Значение) = Тип("СписокЗначений") Тогда 
		СтрокаПараметров.ЭтоВыражение = 2;
		СтрокаПараметров.ТипЗначения = СтрокаПараметров.Значение.ТипЗначения;
	ИначеЕсли ТипЗнч(СтрокаПараметров.Значение) = Тип("ВыражениеКомпоновкиДанных") Тогда
		Если ирКэш.НомерИзданияПлатформыЛкс() = "82" Тогда
			// Мультиметка0017216734 Антибаг платформы https://www.hostedredmine.com/issues/944945
			СтрокаПараметров.ЭтоВыражение = Истина;
		Иначе
			СтрокаПараметров.ЭтоВыражение = "СКД";
		КонецЕсли;
		СтрокаПараметров.Выражение = СтрокаПараметров.Значение; 
	Иначе
		СтрокаПараметров.ЭтоВыражение = Ложь;
		СтрокаПараметров.ТипЗначения = Новый ОписаниеТипов(ирОбщий.БыстрыйМассивЛкс(ТипЗнч(СтрокаПараметров.Значение)));
	КонецЕсли;

КонецПроцедуры

Функция РедактироватьНаборДанныхСхемыКомпоновкиДанных(ВладелецФормы, НаборДанных, Схема, НастройкаКомпоновки = Неопределено) Экспорт

	#Если Сервер И Не Сервер Тогда
		Схема = Новый СхемаКомпоновкиДанных;
		НаборДанных = Схема.НаборыДанных.Найти();
		НастройкаКомпоновки = Новый НастройкиКомпоновкиДанных;
	#КонецЕсли
	мРежимРедактораЗапроса = Истина;
	мРедактируемыйНаборДанных = НаборДанных;
	ИнициализацияСлужебногоРежима();
	мСтрокаЗапросаПараметра.Запрос = НаборДанных.Имя;
	мСтрокаЗапросаПараметра.АвтозаполнениеДоступныхПолей = НаборДанных.АвтозаполнениеДоступныхПолей;
	ПараметыСхемы = Схема.Параметры;
	Для Каждого ПараметрСхемы Из ПараметыСхемы Цикл
		СтрокаПараметров = мСтрокаЗапросаПараметра.ПараметрыЗапроса.Добавить();
		СтрокаПараметров.ИмяПараметра = ПараметрСхемы.Имя;
		ирОбщий.ОбновитьКопиюСвойстваВНижнемРегистреЛкс(СтрокаПараметров, "ИмяПараметра");
		СтрокаПараметров.Значение = ПараметрСхемы.Значение;
		СтрокаПараметров.ТипЗначения = ПараметрСхемы.ТипЗначения;
		Если СтрокаПараметров.Значение = Неопределено Тогда
			СтрокаПараметров.Значение = СтрокаПараметров.ТипЗначения.ПривестиЗначение(СтрокаПараметров.Значение); // Чтобы Неопределено превращать в пустые ссылки
		КонецЕсли; 
		Если Истина
			И Не ПараметрСхемы.ОграничениеИспользования
			И НастройкаКомпоновки <> Неопределено
		Тогда
			ЗначениеПараметра = НастройкаКомпоновки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных(ПараметрСхемы.Имя));
			Если ЗначениеПараметра <> Неопределено И ЗначениеПараметра.Использование Тогда
				СтрокаПараметров.Значение = ЗначениеПараметра.Значение;
			КонецЕсли; 
		КонецЕсли; 
		Если ПараметрСхемы.Выражение <> "" Тогда
			СтрокаПараметров.ЭтоВыражение = "СКД";
			СтрокаПараметров.Выражение = ПараметрСхемы.Выражение; 
			Если ирКэш.НомерИзданияПлатформыЛкс() = "82" Тогда
				// Мультиметка0017216734 Антибаг платформы https://www.hostedredmine.com/issues/944945
				СтрокаПараметров.Выражение = СтрЗаменить(СтрокаПараметров.Выражение, "&", "Параметры."); 
			КонецЕсли;
		ИначеЕсли ТипЗнч(ПараметрСхемы.Значение) = Тип("СписокЗначений") Тогда 
			СтрокаПараметров.ЭтоВыражение = 2;
		Иначе
			СтрокаПараметров.ЭтоВыражение = Ложь;
		КонецЕсли;
	КонецЦикла;
	мСтрокаЗапросаПараметра.ТекстЗапроса = НаборДанных.Запрос;
	мСтрокаЗапросаПараметра.ТипЗапроса = "Компоновка";
	Форма = ЭтотОбъект.ПолучитьФорму(, ВладелецФормы);
	Форма.Открыть();
	
КонецФункции // РедактироватьНаборДанныхСхемыКомпоновкиДанных()

Функция РедактироватьСтруктуруЗапроса(ВладелецФормы = Неопределено, СтруктураЗапроса) Экспорт

	мРежимРедактораЗапроса = Истина;
	ДеревоЗапросов.Строки.Очистить();
	ИнициализацияСлужебногоРежима();
	Если СтруктураЗапроса.Свойство("Имя") Тогда
		мСтрокаЗапросаПараметра.Запрос = СтруктураЗапроса.Имя;
	КонецЕсли;
	Если СтруктураЗапроса.Свойство("Ссылка") Тогда
		мСсылка = СтруктураЗапроса.Ссылка;
	КонецЕсли;
	Если СтруктураЗапроса.Свойство("Параметры") Тогда
		мСтрокаЗапросаПараметра.ПараметрыЗапроса = ирОбщий.КопияОбъектаЛкс(СтруктураЗапроса.Параметры);
	КонецЕсли;
	Если СтруктураЗапроса.Свойство("ПараметрыADO") Тогда
		мСтрокаЗапросаПараметра.ПараметрыADO = ирОбщий.КопияОбъектаЛкс(СтруктураЗапроса.ПараметрыADO);
	КонецЕсли;
	Если СтруктураЗапроса.Свойство("ПараметрыWMI") Тогда
		мСтрокаЗапросаПараметра.ПараметрыWMI = ирОбщий.КопияОбъектаЛкс(СтруктураЗапроса.ПараметрыWMI);
	КонецЕсли;
	мСтрокаЗапросаПараметра.ТекстЗапроса = СтруктураЗапроса.ТекстЗапроса;
	Если СтруктураЗапроса.Свойство("ТипЗапроса") Тогда
		мСтрокаЗапросаПараметра.ТипЗапроса = СтруктураЗапроса.ТипЗапроса;
	Иначе
		мСтрокаЗапросаПараметра.ТипЗапроса = "Построитель";
	КонецЕсли;
	Если ВладелецФормы = Неопределено Тогда
		Форма = ЭтотОбъект.ПолучитьФорму();
		Форма.ОткрытьМодально();
		Результат = Форма.РезультатФормы;
	Иначе
		Форма = ЭтотОбъект.ПолучитьФорму(, ВладелецФормы);
		Форма.Открыть();
	КонецЕсли; 
	Возврат Результат;
	
КонецФункции

Функция НайтиПлатформуADOПоСтрокеСоединения(СтрокаСоединения)

	Результат = Неопределено;
	Провайдер = ирОбщий.ПервыйФрагментЛкс(ирОбщий.СтрокаМеждуМаркерамиЛкс(СтрокаСоединения, "Provider=", ";"));
	Для Каждого СтрокаПлатформы Из мПлатформыADODB Цикл
		Если Найти(НРег(СтрокаПлатформы.СтрокаСоединения), Нрег(Провайдер)) > 0 Тогда
			Результат = СтрокаПлатформы.Код;
			Прервать;
		КонецЕсли; 
	КонецЦикла;
	Возврат Результат;

КонецФункции // НайтиПлатформуADOПоСтрокеСоединения()

Функция ПолучитьСтруктуруИсточникаДанныхADO() Экспорт
	
	ИсточникДанныхADO = Новый Структура("Платформа, Путь, БазаСервер, БазаИмя, Пользователь, Пароль, ТипИсточникаДанных, СтрокаСоединения, АутентификацияОС");
	Возврат ИсточникДанныхADO;
	
КонецФункции

Функция ПараметрыПлатформыADO_Получить(ПлатформаЗначение) Экспорт
	
	ПлатформаПар = Новый Структура("ТипИсточникаДанных, МаскаФайлов, СтрокаСоединения, СтрокаАутентификацииОС, ИменованныеПараметры");
	Стр = мПлатформыADODB.Найти(ПлатформаЗначение, "Код");
	Если Стр <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ПлатформаПар, Стр);
		//ПлатформаПар.ТипИсточникаДанных = Стр.ТипИсточникаДанных;
		//ПлатформаПар.СтрокаСоединения = Стр.СтрокаСоединения;
	КонецЕсли;
	Возврат ПлатформаПар;
	
КонецФункции

// Параметры - ПолучитьИсточникДанныхADO()
Функция ConnectADO(ИсточникДанных, выхСоединениеADO = Неопределено, стОпции = Неопределено, Еррорс = Неопределено, выхСтрокаСоединенияДляСообщения = "", Асинхронно = Ложь, выхСоединениеФакт = "") Экспорт
	Перем Параметры;
	Перем Результат;
	
	ПараметрыПлатформыADO = ПараметрыПлатформыADO_Получить(ИсточникДанных.Платформа);
	ИсточникДанных.ТипИсточникаДанных = ПараметрыПлатформыADO.ТипИсточникаДанных;
	Если Не ЗначениеЗаполнено(ИсточникДанных.СтрокаСоединения) Тогда
		ИсточникДанных.СтрокаСоединения = ПараметрыПлатформыADO.СтрокаСоединения;
	КонецЕсли; 
	Параметры = ИсточникДанных;
	Еррорс = Новый Массив;
	 
	// дополнительные параметры для соединения к источнику данных
	Если ТипЗнч(стОпции)<>Тип("Структура") Тогда
		стОпции = Новый Структура;
	КонецЕсли;
	
	Доп_Путь=Неопределено;
	Если стОпции.Свойство("Путь",Доп_Путь) Тогда
		// передали другой непустой путь - используем его
		Если ЗначениеЗаполнено(Доп_Путь) Тогда
			Параметры.Путь = Доп_Путь;
		КонецЕсли; 
	КонецЕсли; 
	
	// параметры подключения к источнику данных (в зависимости от его типа):
	ПроверятьПользователя = Истина;
	ДопМаска="";
	//ВыбратьПуть=Ложь;
	Путь = Параметры.Путь;
	Если Параметры.ТипИсточникаДанных=0 Тогда
		// файл с данными
		ПроверятьПользователя = Ложь;
		СтрИнфо="";
		Если ПустаяСтрока(Путь) Тогда
			//ВыбратьПуть=Истина;
		Иначе
			ЗаданаМаскаФайлов = Ложь;
			ПутьДоступен = ДоступностьПутиИсточникаДанных(Путь,Ложь,СтрИнфо,ЗаданаМаскаФайлов);
			Если ЗаданаМаскаФайлов=Истина И (Лев(Нрег(Путь),7)<>Нрег("<Пусто>")) Тогда
				ДопМаска=СокрЛП(Путь);
				Если (СтрЧислоВхождений(Путь,"|")=0) Тогда
					ДопМаска="Маска узла COM|"+ДопМаска;
				КонецЕсли; 
				//ВыбратьПуть=Истина;
			ИначеЕсли (ПутьДоступен = Ложь) И (Лев(Нрег(Путь),7)<>Нрег("<Пусто>")) Тогда
				Еррорс.Добавить("Ошибка доступности файла с данными: "+СтрИнфо);
			КонецЕсли;
		КонецЕсли; 
	ИначеЕсли Параметры.ТипИсточникаДанных=1 Тогда
		// база данных файловая
		Если Параметры.Платформа < 100 Тогда
			ПроверятьПользователя=Ложь;
		Иначе 
			ПроверятьПользователя=Истина;
		КонецЕсли; 
		СтрИнфо="";
		ПутьДоступен = ДоступностьПутиИсточникаДанных(Путь,Истина,СтрИнфо,);
		Если НЕ ПутьДоступен Тогда
			Еррорс.Добавить("Ошибка доступности каталога файловой базы: "+СтрИнфо);
		КонецЕсли; 
	ИначеЕсли Параметры.ТипИсточникаДанных = 2 Тогда
		// база данных клиент-серверная
		Если ПустаяСтрока(Параметры.БазаСервер) И НЕ ПустаяСтрока(Параметры.БазаИмя) Тогда
			Еррорс.Добавить("Не указано имя сервера для клиент-серверной базы");
		ИначеЕсли НЕ ПустаяСтрока(Параметры.БазаСервер) И ПустаяСтрока(Параметры.БазаИмя) Тогда
			Еррорс.Добавить("Не указано имя базы на сервере для клиент-серверной базы");
		ИначеЕсли ПустаяСтрока(Параметры.БазаСервер) И ПустаяСтрока(Параметры.БазаИмя) Тогда
			Еррорс.Добавить("Не указано имя сервера и имя базы на сервере для клиент-серверной базы");
		КонецЕсли; 
	ИначеЕсли Параметры.ТипИсточникаДанных=3 Тогда
		// ресурс интернета
		Если ПустаяСтрока(Путь) Тогда
			Еррорс.Добавить("Не задан путь (URL) к ресурсу интернета базы данных");
		КонецЕсли; 
    Иначе
		Еррорс.Добавить("Не предусмотренный тип источника данных: "+ Параметры.ТипИсточникаДанных);
	КонецЕсли;
	
	Если ПроверятьПользователя И Не Параметры.АутентификацияОС Тогда
		Если ПустаяСтрока(Параметры.Пользователь) И НЕ ПустаяСтрока(Параметры.Пароль) Тогда
			Еррорс.Добавить("Не указано имя пользователя базы");
		ИначеЕсли НЕ ПустаяСтрока(Параметры.Пользователь) И ПустаяСтрока(Параметры.Пароль) Тогда
			Еррорс.Добавить("Не указан пароль пользователя базы");
		ИначеЕсли ПустаяСтрока(Параметры.Пользователь) И ПустаяСтрока(Параметры.Пароль) Тогда
			Еррорс.Добавить("Не указаны имя и пароль пользователя базы");
		КонецЕсли; 
	КонецЕсли; 
	
	//Если ВыбратьПуть=Истина И Еррорс.Количество()=0 Тогда
	//	#Если Клиент Тогда
	//		ДиалогФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	//		ДиалогФайла.Заголовок="Выбор пути к файлу с данными:";
	//		ДиалогФайла.МножественныйВыбор=Ложь;
	//		Если ДопМаска="" Тогда
	//			ДиалогФайла.ПолноеИмяФайла=Путь;
	//			ФайлПуть=Новый Файл(Путь);
	//			Если ФайлПуть.Существует() Тогда
	//				ДиалогФайла.Каталог=ФайлПуть.Путь;
	//			КонецЕсли;
	//			ДиалогФайла.Фильтр="Все файлы(*.*)|*.*";
	//		Иначе
	//			ДиалогФайла.Фильтр=ДопМаска+"|Все файлы(*.*)|*.*";
	//		КонецЕсли;
	//		Если ДиалогФайла.Выбрать() Тогда
	//			Параметры.Вставить("Путь",ДиалогФайла.ПолноеИмяФайла);
	//			стОпции.Вставить("Путь",ДиалогФайла.ПолноеИмяФайла);
	//			стОпции.Вставить("Отказ",Ложь);
	//		Иначе
	//			стОпции.Вставить("Путь",Неопределено);
	//			стОпции.Вставить("Отказ",Истина);
	//			Еррорс.Добавить("Выбор файла с данными для подключения к источнику данных отменен пользователем");
	//		КонецЕсли;
	//	#Иначе 
	//		Еррорс.Добавить("Не выбран файл с данными для подключения к источнику данных");
	//	#КонецЕсли	
	//КонецЕсли;
	
	выхСоединениеADO = Неопределено;
	выхСоединениеФакт = Параметры.СтрокаСоединения;
	Если Параметры.АутентификацияОС Тогда
		выхСоединениеФакт = СокрП(выхСоединениеФакт);
		Если Прав(выхСоединениеФакт, 1) <> ";" Тогда
			выхСоединениеФакт = выхСоединениеФакт + ";";
		КонецЕсли; 
		выхСоединениеФакт = выхСоединениеФакт + ПараметрыПлатформыADO.СтрокаАутентификацииОС;
		Параметры.Пользователь = "";
		Параметры.Пароль = "";
	КонецЕсли; 
	
	// макро имена параметров подключения
	выхСоединениеФакт = СтрЗаменить(выхСоединениеФакт,"!Путь!",			Параметры.Путь);
	выхСоединениеФакт = СтрЗаменить(выхСоединениеФакт,"!БазаСервер!",	Параметры.БазаСервер);
	выхСоединениеФакт = СтрЗаменить(выхСоединениеФакт,"!БазаИмя!",		Параметры.БазаИмя);
	выхСоединениеФакт = СтрЗаменить(выхСоединениеФакт,"!Пользователь!",	Параметры.Пользователь);
	выхСоединениеФакт = СтрЗаменить(выхСоединениеФакт, "!Пароль!", Параметры.Пароль);
	выхСтрокаСоединенияДляСообщения = СтрЗаменить(выхСоединениеФакт,"!Пароль!", "***");
	Если Еррорс.Количество() > 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	КомпьютераИмя = ИмяКомпьютера();
	#Если Сервер И Не Клиент Тогда
		КомпьютераИмя = КомпьютераИмя + " - сервер!";
	#КонецЕсли
	Попытка
		выхСоединениеADO = Новый COMОбъект("ADODB.Connection");
	Исключение
		Еррорс.Добавить(
		"Ошибка создания COM-объекта для подключения:
		|"+ОписаниеОшибки()+"
		|-----------------------------
		//|СерверCOM		= '"+Параметры.СерверCOM+"'
		|ИмяКомпьютера	= '"+КомпьютераИмя+"'
		|");	
		Возврат Ложь;
	КонецПопытки;
	
	// макро имена параметров подключения
	Результат = Неопределено;
	выхСоединениеADO.ConnectionTimeOut = 7; // секунд, 5 - недостаточно, игнорируется при первом соединении (6 секунд ожидания все равно проходят)
	выхСоединениеADO.CommandTimeout = 300; // секунд
	выхСоединениеADO.CursorLocation = 3; // курсоры на стороне клиента
	Если Асинхронно Тогда
		КодСинхронности = 16;
	Иначе
		КодСинхронности = -1;
		ирОбщий.СостояниеЛкс("ADO Подключение " + выхСтрокаСоединенияДляСообщения); // https://www.hostedredmine.com/issues/910136
	КонецЕсли; 
	Попытка
		выхСоединениеADO.Open(выхСоединениеФакт, Параметры.Пользователь, Параметры.Пароль, КодСинхронности);
		Результат = 1;
	Исключение
		СтрЕррор = 
		"Ошибка инициализации подключения:
		|	" + ОписаниеОшибки() + "
		|Фактическая строка соединения с базой:
		|	" + выхСтрокаСоединенияДляСообщения + "
		|";
		Еррорс.Добавить(СтрЕррор);
		Результат = -1;
	КонецПопытки;
	Если Не Асинхронно Тогда 
		ирОбщий.СостояниеЛкс(""); // https://www.hostedredmine.com/issues/910136
	КонецЕсли; 
	Если Еррорс.Количество()>0 Тогда
		Результат=-1;
	Иначе
		Если ТипЗнч(Результат)=Тип("Число") Тогда
			Если Результат<0 Тогда
				Результат=-1;
			ИначеЕсли Результат>0 Тогда
				Результат=+1;
			КонецЕсли; 
		КонецЕсли; 
		Если Результат <> 1  Тогда
			ЕррорТекст = "Не проработанная ошибка при выполнении модуля инициализации подключения";
			Если Результат = -1 Тогда
				ЕррорТекст = ЕррорТекст + " (фатального характера)";
			КонецЕсли; 
			Еррорс.Добавить(ЕррорТекст);
		КонецЕсли; 
	КонецЕсли;
	
	Возврат (Результат=1);
КонецФункции

Функция ДоступностьПутиИсточникаДанных(Путь, Знач ВидПутиКаталог=Истина, СтрИнфо, ЗаданаМаскаФайлов=Ложь) Экспорт
	СтрИнфо="";
	ЗаданаМаскаФайлов=Ложь;
	
	ПрефиксНЛФС="";
	Если (Лев(Нрег(Путь),7)=Нрег("<Пусто>")) Тогда
		СтрИнфо="выбирается при закрытии соединения";
		Если (Найти(Путь,"*")>0)ИЛИ(Найти(Путь,"?")>0) Тогда
			ЗаданаМаскаФайлов=Истина;
			СтрИнфо = СтрИнфо + " (по маске файлов)";
		КонецЕсли; 
		Возврат НЕ ВидПутиКаталог;
	ИначеЕсли (Лев(Нрег(Путь),5)="http:") Тогда
		ПрефиксНЛФС="http";
	ИначеЕсли (Лев(Нрег(Путь),4)="ftp:") Тогда
		ПрефиксНЛФС="ftp";
	КонецЕсли; 
	
	Если ВидПутиКаталог=Истина Тогда
		МетаИмяПути = "каталог";
	ИначеЕсли ВидПутиКаталог=Ложь Тогда
		МетаИмяПути = "файл";
	Иначе
		// всякие http, ftp ресурсы - непроверяем
		Если НЕ ПустаяСтрока(ПрефиксНЛФС) Тогда
			СтрИнфо = "ресурс " + ПрефиксНЛФС + " не проверяется";
		КонецЕсли; 
		Возврат Истина;
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ПрефиксНЛФС) Тогда
		СтрИнфо = МетаИмяПути + " по " + ПрефиксНЛФС + " не проверяется";
		Возврат Истина;
	КонецЕсли; 
	
	Если ПустаяСтрока(Путь) Тогда
		СтрИнфо = МетаИмяПути + " не задан";
		Возврат Ложь;
	КонецЕсли;
	
	Если (Найти(Путь,"*")>0)ИЛИ(Найти(Путь,"?")>0) Тогда
		ЗаданаМаскаФайлов=Истина;
		СтрИнфо = "задана маска файлов";
		Возврат НЕ ВидПутиКаталог;
	КонецЕсли; 
	
	#Если Сервер И Не Клиент Тогда
	Если НЕ (Найти(Врег(СтрокаСоединенияИнформационнойБазы()), "FILE=") = 1) Тогда
		МетаИмяПути=МетаИмяПути+" на сервере 1С";
	КонецЕсли;
	#КонецЕсли	

	Файл = Новый Файл(Путь);
	Если НЕ Файл.Существует() Тогда
		СтрИнфо = МетаИмяПути + " не существует";
		Возврат Ложь;
	КонецЕсли;
	
	Если ВидПутиКаталог=Истина Тогда
		Если НЕ Файл.ЭтоКаталог() Тогда
			СтрИнфо = МетаИмяПути + " не является каталогом файлов";
			Возврат Ложь;
		КонецЕсли;
	Иначе
		Если НЕ Файл.ЭтоФайл() Тогда
			СтрИнфо = МетаИмяПути + " является каталогом файлов";
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Истина;
КонецФункции // ДоступностьПутиИсточникаДанных()

Функция ЗначенияПоУмолчаниюСтрокиЗапроса() Экспорт 
	
	Результат = Новый Структура;
	Результат.Вставить("СпособВыгрузки", 1);
	Результат.Вставить("ВыбратьВсеПоля", Истина);
	Результат.Вставить("АвтовыборкиИтогов", Истина);
	Результат.Вставить("АвтоЗаполнениеДоступныхПолей", Истина);
	//Результат.Вставить("ДобавлятьСлужебныеКолонкиРезультата", Истина);
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

мОбъектЗапроса = Новый Запрос;
мРежимРедактораЗапроса = Ложь;
мРежимОтладки = Ложь;
мВременныеТаблицыМенеджера1СПриОткрытии = Новый Соответствие;
ЭтотОбъект.НаСервере = ирОбщий.РежимОбъектыНаСервереПоУмолчаниюЛкс(Ложь);

// Создадим структуру дерева запросов
ДеревоЗапросов.Колонки.Добавить("Запрос", Новый ОписаниеТипов("Строка"));
ДеревоЗапросов.Колонки.Добавить("ТекстЗапроса");
ДеревоЗапросов.Колонки.Добавить("ПараметрыЗапроса");
ДеревоЗапросов.Колонки.Добавить("СпособВыгрузки", Новый ОписаниеТипов("Число"));
ДеревоЗапросов.Колонки.Добавить("НовыйМенеджерВременныхТаблиц", Новый ОписаниеТипов("Булево"));
ДеревоЗапросов.Колонки.Добавить("КодОбработкиСтрокиРезультата");
ДеревоЗапросов.Колонки.Добавить("КодПередВыполнениемЗапроса");
ДеревоЗапросов.Колонки.Добавить("КодОбработкиРезультата");
ДеревоЗапросов.Колонки.Добавить("Настройка");
ДеревоЗапросов.Колонки.Добавить("ВыбратьВсеПоля", Новый ОписаниеТипов("Булево"));
ДеревоЗапросов.Колонки.Добавить("ТипЗапроса", Новый ОписаниеТипов("Строка"));
ДеревоЗапросов.Колонки.Добавить("Длительность", Новый ОписаниеТипов("Число, Строка"));
ДеревоЗапросов.Колонки.Добавить("ДатаВыполнения", Новый ОписаниеТипов("Дата"));
ДеревоЗапросов.Колонки.Добавить("РазмерРезультата", Новый ОписаниеТипов("Число, Строка"));
ДеревоЗапросов.Колонки.Добавить("ПараметрыWMI");
ДеревоЗапросов.Колонки.Добавить("ПараметрыADO");
ДеревоЗапросов.Колонки.Добавить("СтандартнаяВыгрузкаВДерево", Новый ОписаниеТипов("Булево"));
ДеревоЗапросов.Колонки.Добавить("АвтовыборкиИтогов", Новый ОписаниеТипов("Булево"));
ДеревоЗапросов.Колонки.Добавить("АвтоЗаполнениеДоступныхПолей", Новый ОписаниеТипов("Булево"));
ДеревоЗапросов.Колонки.Добавить("ДобавлятьСлужебныеКолонкиРезультата", Новый ОписаниеТипов("Булево"));
ДеревоЗапросов.Колонки.Добавить("ОбходитьИерархическиеВыборкиРекурсивно", Новый ОписаниеТипов("Булево"));
ДеревоЗапросов.Колонки.Добавить("ВыборкиИтогов");
ДеревоЗапросов.Колонки.Добавить("НачальнаяСтрока", Новый ОписаниеТипов("Число"));
ДеревоЗапросов.Колонки.Добавить("НачальнаяКолонка", Новый ОписаниеТипов("Число"));
ДеревоЗапросов.Колонки.Добавить("КонечнаяСтрока", Новый ОписаниеТипов("Число"));
ДеревоЗапросов.Колонки.Добавить("КонечнаяКолонка", Новый ОписаниеТипов("Число"));
ДеревоЗапросов.Колонки.Добавить("СтрокаДанных");

мПлатформыADODB = ирОбщий.ТаблицаЗначенийИзТабличногоДокументаЛкс(ПолучитьМакет("ПлатформыADODB"),,,, Истина);
