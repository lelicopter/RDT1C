﻿Перем мСвязанныйРедакторОбъектаБД;
Перем Построитель;
Перем ЭтоПеречисление;
Перем ПараметрТекущаяКолонка Экспорт;
Перем ФормаРезультата;
Перем СтарыйОтбор;

Функция УстановитьОбъектМетаданных(Знач НовоеПолноеИмяТаблицы = Неопределено, Знач СохранитьНастройкиТаблицы = Ложь) Экспорт

	Если НовоеПолноеИмяТаблицы <> Неопределено Тогда
		ЗначениеИзменено = Ложь;
		ирОбщий.ПрисвоитьЕслиНеРавноЛкс(фОбъект.ПолноеИмяТаблицы, НовоеПолноеИмяТаблицы, ЗначениеИзменено);
		Если Не ЗначениеИзменено Тогда
			Возврат Ложь;
		КонецЕсли; 
		СтарыйОтбор = Неопределено;
	КонецЕсли; 
	фОбъект.КоличествоСтрокВОбластиПоиска = "...";
	Если ирОбщий.ЛиАсинхронностьДоступнаЛкс() Тогда
		ирКлиент.ОтменитьФоновоеЗаданиеЛкс(фОбъект.ИДФоновогоЗадания);
		ФормаРезультата = ирКлиент.НоваяФормаРезультатаФоновогоЗаданияЛкс();
		фОбъект.АдресХранилищаКоличестваСтрок = ПоместитьВоВременноеХранилище(Null, ФормаРезультата.УникальныйИдентификатор);
		ПараметрыЗапуска = Новый Массив;
		ПараметрыЗапуска.Добавить(фОбъект.ПолноеИмяТаблицы);
		ПараметрыЗапуска.Добавить(фОбъект.АдресХранилищаКоличестваСтрок);
		#Если Сервер И Не Сервер Тогда
			ирОбщий.КоличествоСтрокВТаблицеМДЛкс();
		#КонецЕсли
		ирОбщий.ДобавитьТекущемуПользователюРолиИРЛкс();
		ФоновоеЗадание = ФоновыеЗадания.Выполнить("ирОбщий.КоличествоСтрокВТаблицеМДЛкс", ПараметрыЗапуска,, "ИР. Вычисление количества строк в таблице " + фОбъект.ПолноеИмяТаблицы);
		фОбъект.ИДФоновогоЗадания = ФоновоеЗадание.УникальныйИдентификатор;
	КонецЕсли; 
	#Если Сервер И Не Сервер Тогда
		ОбновитьКоличествоСтрок();
	#КонецЕсли
	ПодключитьОбработчикОжидания("ОбновитьКоличествоСтрок", 0.1, Истина);
	Если Не ирОбщий.ЛиТаблицаБДСуществуетЛкс(фОбъект.ПолноеИмяТаблицы, Истина) Тогда
		фОбъект.ПолноеИмяТаблицы = Неопределено;
		Возврат Ложь;
	КонецЕсли; 
	ТипТаблицыБД = ирОбщий.ТипТаблицыБДЛкс(фОбъект.ПолноеИмяТаблицы);
	ЭлементыФормы.ДинамическийСписок.ИзменятьСоставСтрок = Истина;
	МассивФрагментов = ирОбщий.СтрРазделитьЛкс(фОбъект.ПолноеИмяТаблицы);
	ОсновнойЭУ = ЭлементыФормы.ДинамическийСписок;
	ИмяТипаСписка = ирОбщий.ИмяТипаИзПолногоИмениТаблицыБДЛкс(фОбъект.ПолноеИмяТаблицы, "Список");
	ОбъектМД = ирКэш.ОбъектМДПоПолномуИмениЛкс(фОбъект.ПолноеИмяТаблицы);
	ЕстьОграниченияДоступа = ирОбщий.ЕстьОграниченияДоступаКСтрокамТаблицыНаЧтениеЛкс(ОбъектМД);
	ЭлементыФормы.НадписьПраваДоступаКСтрокам.Заголовок = "RLS: " + Формат(ЕстьОграниченияДоступа, "БЛ=Нет; БИ=Да");
	ЭлементыФормы.НадписьПраваДоступаКСтрокам.Гиперссылка = ЕстьОграниченияДоступа;
	Если ЗначениеЗаполнено(ИмяТипаСписка) Тогда
		Если Истина
			И ЭтаФорма.Открыта()
			И ирОбщий.ЛиКорневойТипРегистраСведенийЛкс(МассивФрагментов[0]) 
			И ОбъектМД.Измерения.Количество() = 0
			И ОбъектМД.ПериодичностьРегистраСведений = Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический
			И ОбъектМД.РежимЗаписи = Метаданные.СвойстваОбъектов.РежимЗаписиРегистра.Независимый
		Тогда
			// Антибаг платформы 8.3 Приложение аварийно завершалось
			ОсновнойЭУ.ТипЗначения = Новый ОписаниеТипов("ТаблицаЗначений");
			Сообщить("Списки независимых непериодических регистров сведений без измерений после открытия формы не подключаются из-за ошибки платформы");
		Иначе
			Попытка
				ОсновнойЭУ.ТипЗначения = Новый ОписаниеТипов(ИмяТипаСписка);
			Исключение
				ОписаниеОшибки = ОписаниеОшибки(); // Для отладки
				Сообщить("Динамический список для таблицы """ + фОбъект.ПолноеИмяТаблицы + """ недоступен");
				фОбъект.ПолноеИмяТаблицы = Неопределено;
				Возврат Ложь;
			КонецПопытки; 
			//ТекстЗапросаКоличестваСтрок = "ВЫБРАТЬ СУММА(Количество) ИЗ (" + ТекстЗапросаКоличестваСтрок + ") КАК Т";
			//ЗапросКоличестваСтрок = Новый Запрос(мТекстЗапросаКоличестваСтрок);
			//КоличествоСтрокВТаблицеБД = ЗапросКоличестваСтрок.Выполнить().Выгрузить()[0][0];
			ирКлиент.НастроитьАвтоТабличноеПолеДинамическогоСпискаЛкс(ОсновнойЭУ, фОбъект.РежимИмяСиноним);
			ЭтаФорма.Отбор = ЭлементыФормы.ДинамическийСписок.Значение.Отбор;
		КонецЕсли; 
	Иначе
		ТекстЗапроса = "ВЫБРАТЬ ПЕРВЫЕ 100000 РАЗРЕШЕННЫЕ Т.* ИЗ " + фОбъект.ПолноеИмяТаблицы + " КАК Т";
		ОсновнойЭУ.ТипЗначения = Новый ОписаниеТипов("ТаблицаЗначений");
		Построитель.Текст = ТекстЗапроса;
		ОсновнойЭУ.Значение = Построитель.Результат.Выгрузить();
		ОсновнойЭУ.СоздатьКолонки();
		ОсновнойЭУ.ИзменятьСоставСтрок = Ложь;
		Для Каждого КолонкаТП Из ОсновнойЭУ.Колонки Цикл
			КолонкаТП.ТолькоПросмотр = Истина;
		КонецЦикла;
		Построитель.ЗаполнитьНастройки();
		КолонкаИдентификатора = ОсновнойЭУ.Колонки.Добавить("ИдентификаторСсылкиЛкс");
		КолонкаИдентификатора.ТекстШапки = "Идентификатор ссылки";
		ЭтаФорма.Отбор = Построитель.Отбор;
	КонецЕсли;
	ДопСвойства = ирКлиент.ДопСвойстваЭлементаФормыЛкс(ЭтаФорма, ОсновнойЭУ);
	ДопСвойства.ЗапросИтоговПоТаблицеКлючей = Неопределено;
	Для Каждого КолонкаТП Из ОсновнойЭУ.Колонки Цикл
		Если ТипЗнч(КолонкаТП.ЭлементУправления) = Тип("ПолеВвода") Тогда
			КолонкаТП.ЭлементУправления.УстановитьДействие("ОкончаниеВводаТекста", Новый Действие("ПолеВводаКолонкиСписка_ОкончаниеВводаТекста"));
			КолонкаТП.ЭлементУправления.УстановитьДействие("НачалоВыбора", Новый Действие("ПолеВводаКолонкиСписка_НачалоВыбора"));
		КонецЕсли; 
	КонецЦикла;
	//ЭтаФорма.Заголовок = СтрЗаменить(ЭтаФорма.Заголовок, "Динамический список ", "ДС");
	//ирОбщий.ОбновитьТекстПослеМаркераВСтрокеЛкс(ЭтаФорма.Заголовок,, ПредставлениеТаблицы, ": ");
	ирКлиент.ФормаОбъекта_ОбновитьЗаголовокЛкс(ЭтаФорма);
	ирКлиент.ДописатьРежимВыбораВЗаголовокФормыЛкс(ЭтаФорма);
	ЭтоПеречисление = ирОбщий.ЛиКорневойТипПеречисленияЛкс(ТипТаблицыБД);
	ЭтоСсылкаБД = ирОбщий.ЛиКорневойТипСсылочногоОбъектаБДЛкс(ТипТаблицыБД);
	фОбъект.ВместоОсновной = ирОбщий.ИспользованиеДинамическогоСпискаВместоОсновнойФормыЛкс(фОбъект.ПолноеИмяТаблицы);
	Попытка
		ЭлементыФормы.ДинамическийСписок.Колонки.Наименование.ОтображатьИерархию = Истина;
		ЭлементыФормы.ДинамическийСписок.Колонки.Картинка.ОтображатьИерархию = Ложь;
		ЭлементыФормы.ДинамическийСписок.Колонки.Картинка.Видимость = Ложь;
	Исключение
	КонецПопытки;
	ЭлементыФормы.КоманднаяПанельПереключателяДерева.Кнопки.РежимДерева.Доступность = ирОбщий.ЛиМетаданныеИерархическогоОбъектаЛкс(ОбъектМД);
	ЭлементыФормы.КП_Список.Кнопки.ПодменюРедактор.Кнопки.ДобавитьСтрокуЧерезРедакторОбъектаБД.Доступность = ЭтоСсылкаБД;
	ЭлементыФормы.КП_Список.Кнопки.НайтиВыбратьПоID.Доступность = ЭтоСсылкаБД;
	ЗагрузитьНастройкиТаблицы();
	Если Истина
		И Не ирОбщий.ЛиКорневойТипПеречисленияЛкс(ТипТаблицыБД) 
		И ТипЗнч(ОсновнойЭУ.Значение) <> Тип("ТаблицаЗначений")
	Тогда
		ЭлементПорядкаТипаДата = ирОбщий.ЭлементПорядкаТипаДатаЛкс(ПолноеИмяТаблицы, ОсновнойЭУ.Значение.Порядок);
		Если ЭлементПорядкаТипаДата <> Неопределено И ЭлементПорядкаТипаДата.Направление = НаправлениеСортировки.Возр Тогда 
			ОсновнойЭУ.НачальноеОтображениеСписка = НачальноеОтображениеСписка.Конец;
		Иначе
			ОсновнойЭУ.НачальноеОтображениеСписка = НачальноеОтображениеСписка.Начало;
		КонецЕсли;
	КонецЕсли;
	фОбъект.СтарыйОбъектМетаданных = фОбъект.ПолноеИмяТаблицы;
	ирКлиент.ПоследниеВыбранныеЗаполнитьПодменюЛкс(ЭтаФорма, ЭлементыФормы.КП_Список.Кнопки.ПоследниеВыбранные, ЭлементыФормы.ДинамическийСписок);
	// Не удалось найти способ удалить автокнопку истории отборов
	//Для Каждого Кнопка Из ЭлементыФормы.КП_Список.Кнопки Цикл
	//	Если Кнопка.Текст = "История отборов" Тогда
	//		ирКлиент.УстановитьДоступностьПодменюЛкс(Кнопка);
	//		Прервать;
	//	КонецЕсли; 
	//КонецЦикла;
	ОбновитьПодменюПоследнихОтборов();
	ЭлементыФормы.КП_Список.Кнопки.ОтображатьОстатки.Доступность = Истина
		И Не ирОбщий.ЛиКорневойТипРегистраБухгалтерииЛкс(ирОбщий.ТипТаблицыБДЛкс(ПолноеИмяТаблицы))
		И ирОбщий.ОписаниеТаблицыБДЛкс(ПолноеИмяТаблицы + ".Остатки") <> Неопределено;
	Если Не РежимВыбора Тогда
		ирКлиент.ДобавитьТаблицуВИзбранноеЛкс(фОбъект.ПолноеИмяТаблицы);
	КонецЕсли; 
	Возврат Истина;
	
КонецФункции

Процедура СохранитьНастройкиТаблицы()
	
	Если Не ЗначениеЗаполнено(фОбъект.СтарыйОбъектМетаданных) Тогда
		Возврат;
	КонецЕсли;
	ПрочитатьНастройкиКолонокИзТабличногоПоля(ЭлементыФормы.ДинамическийСписок);
	СтруктураНастроек = Новый Структура;
	Попытка
		СтруктураНастроек.Вставить("ИерархическийПросмотр", ЭлементыФормы.ДинамическийСписок.ИерархическийПросмотр);
	Исключение
	КонецПопытки;
	СтруктураНастроек.Вставить("ТекущаяСтрока", КлючСтрокиИзСсылки(ЭлементыФормы.ДинамическийСписок.ТекущаяСтрока));
	СтруктураНастроек.Вставить("НастройкиКолонок", фОбъект.НастройкиКолонок.Выгрузить());
	Попытка
		ПорядокСписка = ЭлементыФормы.ДинамическийСписок.Значение.Порядок;
	Исключение
		ПорядокСписка = Неопределено;
	КонецПопытки; 
	Если ПорядокСписка <> Неопределено Тогда
		СтрокаПорядка = ирОбщий.ПорядокВСтрокуЛкс(ПорядокСписка);
		Если ЗначениеЗаполнено(СтрокаПорядка) Тогда
			СтруктураНастроек.Вставить("Порядок", СтрокаПорядка);
		КонецЕсли; 
	КонецЕсли; 
	ирОбщий.СохранитьЗначениеЛкс("ДинамическийСписок." + фОбъект.СтарыйОбъектМетаданных + "." + РежимВыбора, СтруктураНастроек);
	
КонецПроцедуры

Процедура ЗагрузитьНастройкиТаблицы()
	
	СтруктураНастроек = ирОбщий.ВосстановитьЗначениеЛкс("ДинамическийСписок." + фОбъект.ПолноеИмяТаблицы + "." + РежимВыбора);
	Если СтруктураНастроек = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	#Если Сервер И Не Сервер Тогда
	    СтруктураНастроек = Новый Структура;
	#КонецЕсли
	Если ТипЗнч(СтруктураНастроек) = Тип("Структура") Тогда
		фОбъект.НастройкиКолонок.Загрузить(СтруктураНастроек.НастройкиКолонок);
		Если СтруктураНастроек.Свойство("Порядок") И ЗначениеЗаполнено(СтруктураНастроек.Порядок) Тогда
			НовыйПорядок = СтруктураНастроек.Порядок;
			ПорядокДинамическогоСписка = ЭлементыФормы.ДинамическийСписок.Значение.Порядок;
			Попытка
				ПорядокДинамическогоСписка.Установить(НовыйПорядок);
			Исключение
			КонецПопытки; 
		КонецЕсли; 
		Если СтруктураНастроек.Свойство("ТекущаяСтрока") Тогда
			ТипТаблицы = ирОбщий.ТипТаблицыБДЛкс(фОбъект.ПолноеИмяТаблицы);
			Если Истина
				И СтруктураНастроек.ТекущаяСтрока <> Неопределено
				И ирОбщий.ЛиКорневойТипСсылкиЛкс(ТипТаблицы)
				И Не ирОбщий.ЛиКорневойТипДокументаЛкс(ТипТаблицы)
				И Не ирОбщий.ЛиКорневойТипБизнесПроцессаЛкс(ТипТаблицы)
				И Не ТипТаблицы = "Задача"
				И (Ложь
					Или Не СтруктураНастроек.Свойство("ИерархическийПросмотр")
					Или Не СтруктураНастроек.ИерархическийПросмотр)
			Тогда     
				КлючСтроки = КлючСтрокиИзСсылки(СтруктураНастроек.ТекущаяСтрока);
				Если КлючСтроки <> Неопределено Тогда
					ЭлементыФормы.ДинамическийСписок.ТекущаяСтрока = КлючСтроки;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли; 
		Попытка
			ЭлементыФормы.ДинамическийСписок.ИерархическийПросмотр = СтруктураНастроек.ИерархическийПросмотр;
		Исключение
		КонецПопытки;
	КонецЕсли;
	ПрименитьНастройкиКолонокКТабличномуПолю(ЭлементыФормы.ДинамическийСписок);
	
КонецПроцедуры

Процедура НайтиСсылкуВСписке(КлючСтроки, УстановитьОбъектМетаданных = Истина) Экспорт

	МетаданныеТаблицы = Метаданные.НайтиПоТипу(ирОбщий.ТипОбъектаБДЛкс(КлючСтроки));
	Если УстановитьОбъектМетаданных Тогда
		УстановитьОбъектМетаданных(МетаданныеТаблицы.ПолноеИмя());
	КонецЕсли; 
	ИмяXMLТипа = СериализаторXDTO.XMLТипЗнч(КлючСтроки).ИмяТипа;
	Если Ложь
		Или Найти(ИмяXMLТипа, "Ref.") > 0
		Или Найти(ИмяXMLТипа, "RecordKey.") > 0
	Тогда
		ЭлементыФормы.ДинамическийСписок.ТекущаяСтрока = КлючСтроки;
	Иначе
		ирОбщий.СкопироватьОтборЛюбойЛкс(ЭлементыФормы.ДинамическийСписок.Значение.Отбор, КлючСтроки.Методы.Отбор);
	КонецЕсли; 

КонецПроцедуры

Процедура ОбъектМетаданныхОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;

КонецПроцедуры

Процедура ПриОткрытии()
	
	ирКлиент.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ЭтаФорма.СвязиИПараметрыВыбора = Истина;
	Если КлючУникальности <> Неопределено Тогда
		НовоеИмяТаблицы = ирОбщий.ПервыйФрагментЛкс(КлючУникальности, ";");
		Если Не ЗначениеЗаполнено(фОбъект.ПолноеИмяТаблицы) Тогда
			ОбъектМД = ирОбщий.ОбъектМДПоПолномуИмениТаблицыБДЛкс(НовоеИмяТаблицы);
			Если ОбъектМД <> Неопределено Тогда
				УстановитьОбъектМетаданных(НовоеИмяТаблицы);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	Если КлючУникальности = "Связанный" Тогда
		ЭтаФорма.КлючСохраненияПоложенияОкна = КлючУникальности;
	ИначеЕсли ЗначениеЗаполнено(ПолноеИмяТаблицы) Тогда
		// В обычном приложении изменение состава полей формы приводит к удалению настроек окна управляемой формы. Поэтому сохраняем для каждой таблицы отдельные настройки.
		ЭтаФорма.КлючСохраненияПоложенияОкна = ПолноеИмяТаблицы + ";" + XMLСтрока(РежимВыбора);
	КонецЕсли;
	Если ЗначениеЗаполнено(фОбъект.ПолноеИмяТаблицы) Тогда
		ЭтаФорма.ТекущийЭлемент = ЭлементыФормы.ДинамическийСписок;
	КонецЕсли; 
	ЭлементыФормы.ДинамическийСписок.РежимВыбора = РежимВыбора;
	Если Не РежимВыбора Тогда
		ЭлементыФормы.КП_Список.Кнопки.Удалить(ЭлементыФормы.КП_Список.Кнопки.Выбрать);
	КонецЕсли;
	Если Истина
		И ЗначениеЗаполнено(фОбъект.ПолноеИмяТаблицы)
		И НачальноеЗначениеВыбора <> Неопределено 
		И ЗначениеЗаполнено(НачальноеЗначениеВыбора) 
	Тогда
		КлючСтроки = КлючСтрокиИзСсылки(НачальноеЗначениеВыбора);
		Если КлючСтроки <> Неопределено Тогда
			ЭлементыФормы.ДинамическийСписок.ТекущаяСтрока = КлючСтроки;
		КонецЕсли;
		ЭтаФорма.НачальноеЗначениеВыбора = Неопределено;
	КонецЕсли;
	Если ПараметрТекущаяКолонка <> Неопределено Тогда
		КолонкаСписка = ЭлементыФормы.ДинамическийСписок.Колонки.Найти(ПараметрТекущаяКолонка);
		Если КолонкаСписка <> Неопределено И КолонкаСписка.Видимость Тогда
			ЭлементыФормы.ДинамическийСписок.ТекущаяКолонка = КолонкаСписка;
		КонецЕсли; 
		ЭтаФорма.ПараметрТекущаяКолонка = "";
	КонецЕсли; 
	ирКлиент.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(ЭлементыФормы.ОбъектМетаданных, ЭтаФорма);
	УстановитьНовыйПриемОбъекта();
	
КонецПроцедуры

Функция КлючСтрокиИзСсылки(Ссылка)
	
	КлючСтроки = Неопределено;
	Если Ложь
		Или ирОбщий.ЛиСсылкаНаОбъектБДЛкс(Ссылка)
		Или ирОбщий.ЛиСсылкаНаПеречислениеЛкс(Ссылка)
		Или ирОбщий.ЛиКлючЗаписиРегистраЛкс(Ссылка)
	Тогда
		КлючСтроки = Ссылка; 
	ИначеЕсли ирОбщий.ЛиСсылкаНаОбъектБДЛкс(Ссылка, Ложь) Тогда 
		ИмяПоляСсылка = ирОбщий.ПеревестиСтроку("Ссылка");
		ДанныеСписка = ЭлементыФормы.ДинамическийСписок.Значение;
		ТекущаяСтрока = ДанныеСписка.Найти(Ссылка, ИмяПоляСсылка);
		Если ТекущаяСтрока <> Неопределено Тогда
			КлючСтроки = ТекущаяСтрока;
		КонецЕсли; 
	КонецЕсли;
	Возврат КлючСтроки;

КонецФункции

Процедура ИзменитьСтрокуЧерезРедакторОбъектаБД(Кнопка = Неопределено)
	
	ирКлиент.ОткрытьТекущуюСтрокуТабличногоПоляТаблицыБДВРедактореОбъектаБДЛкс(ЭлементыФормы.ДинамическийСписок, ПолноеИмяТаблицы,,,,, Ложь,,,, ЭтаФорма);
	
КонецПроцедуры

Процедура ДинамическийСписокПриПолученииДанных(Элемент, ОформленияСтрок)
	
	ИмяПоляСсылка = ирОбщий.ПеревестиСтроку("Ссылка");
	ИмяПоляЭтоГруппа = ирОбщий.ПеревестиСтроку("ЭтоГруппа");
	ИмяПоляИмяПредопределенныхДанных = ирОбщий.ПеревестиСтроку("ИмяПредопределенныхДанных");
	КолонкаИдентификатор = Элемент.Колонки.Найти("ИдентификаторСсылкиЛкс");
	Если КолонкаИдентификатор <> Неопределено Тогда
		КолонкаИдентификатораВидима = КолонкаИдентификатор.Видимость;
	Иначе
		КолонкаИдентификатораВидима = Ложь;
	КонецЕсли; 
	КолонкаИмяПредопределенного = Элемент.Колонки.Найти(ИмяПоляИмяПредопределенныхДанных);
	Если КолонкаИмяПредопределенного <> Неопределено Тогда
		КолонкаИмяПредопределенногоВидима = КолонкаИмяПредопределенного.Видимость;
	Иначе
		КолонкаИмяПредопределенногоВидима = Ложь;
	КонецЕсли; 
	КолонкаЭтоГруппа = Элемент.Колонки.Найти(ИмяПоляЭтоГруппа);
	Если Истина
		И КолонкаЭтоГруппа <> Неопределено 
		И КолонкаЭтоГруппа.Данные = ""
		И КолонкаЭтоГруппа.ДанныеФлажка = ""
	Тогда
		// Антибаг платформы 8.2-8.3.9 В свойство Данные и ДанныеФлажка нельзя записать "ЭтоГруппа", поэтому выводим значение в ячейки сами
		КолонкаЭтоГруппаВидима = КолонкаЭтоГруппа.Видимость;
	Иначе
		КолонкаЭтоГруппаВидима = Ложь;
	КонецЕсли;
	Кнопка = ЭлементыФормы.КП_Список.Кнопки.ОтображатьОстатки;
	ОбъектМД = ирОбщий.ОбъектМДПоПолномуИмениТаблицыБДЛкс(ПолноеИмяТаблицы);
	ирКлиент.ТабличноеПолеРегистраОтобразитьОстаткиЛкс(ОформленияСтрок, ОбъектМД, Кнопка, ПолноеИмяТаблицы);
	КолонкиВРежимеПароля = ирОбщий.ИменаПолейТаблицыБДВРежимеПароляЛкс(ПолноеИмяТаблицы);
	МаскироватьПароли = Не ЭлементыФормы.КП_Список.Кнопки.Идентификаторы.Пометка;
	Для каждого ОформлениеСтроки Из ОформленияСтрок Цикл
		ДанныеСтроки = ОформлениеСтроки.ДанныеСтроки;
		ирКлиент.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки, ЭлементыФормы.КП_Список.Кнопки.Идентификаторы);
		Если ДанныеСтроки = неопределено Тогда
			Продолжить;
		КонецЕсли;
		Если КолонкаИдентификатораВидима Тогда
			ЯчейкаИдентификатора = ОформлениеСтроки.Ячейки["ИдентификаторСсылкиЛкс"];
			ИдентификаторСсылки = ирОбщий.СтроковыйИдентификаторСсылкиЛкс(ирОбщий.КлючСтрокиТаблицыБДИзСтрокиТаблицыЗначенийЛкс(ПолноеИмяТаблицы, ДанныеСтроки));
			ЯчейкаИдентификатора.УстановитьТекст(ИдентификаторСсылки);
		КонецЕсли;
		Если КолонкаИмяПредопределенногоВидима Тогда
			ЯчейкаИмяПредопределенного = ОформлениеСтроки.Ячейки[ИмяПоляИмяПредопределенныхДанных];
			Если ЗначениеЗаполнено(ПолноеИмяТаблицы) И ДанныеСтроки.Предопределенный Тогда
				ИмяПредопределенного = ирОбщий.ПолучитьМенеджерЛкс(ПолноеИмяТаблицы).ПолучитьИмяПредопределенного(ДанныеСтроки[ИмяПоляСсылка]);
				ЯчейкаИмяПредопределенного.УстановитьТекст(ИмяПредопределенного);
			КонецЕсли; 
		КонецЕсли;
		Если КолонкаЭтоГруппаВидима Тогда
			ЯчейкаИдентификатора = ОформлениеСтроки.Ячейки[ИмяПоляЭтоГруппа];
			ЯчейкаИдентификатора.Значение = ДанныеСтроки[ИмяПоляЭтоГруппа];
		КонецЕсли;
		Если Истина
			И Не ЭтоПеречисление
			И Элемент.Значение.Колонки.Найти("Активность") <> Неопределено
			И ДанныеСтроки.Активность = Ложь 
		Тогда
			ОформлениеСтроки.ЦветТекста = ирОбщий.ЦветТекстаНеактивностиЛкс();
		КонецЕсли; 
		Если МаскироватьПароли Тогда
			Для Каждого ИмяКолонки Из КолонкиВРежимеПароля Цикл
				ОформлениеСтроки.Ячейки[ИмяКолонки].УстановитьТекст("*****");
			КонецЦикла;
		КонецЕсли; 
	КонецЦикла;

КонецПроцедуры

Процедура ОбъектМетаданныхПриИзменении(Элемент)
	
	СохранитьНастройкиТаблицы();
	ЭтаФорма.КлючУникальности = ирОбщий.КлючУникальностиДинамическогоСпискаЛкс(фОбъект.ПолноеИмяТаблицы);
	Если УстановитьОбъектМетаданных() Тогда 
		ирКлиент.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбъектМетаданныхНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_ОбновитьСписокЛкс(Элемент, ЭтаФорма);

КонецПроцедуры

Функция ПараметрыВыбораОбъектаМетаданных()
	Возврат ирКлиент.ПараметрыВыбораОбъектаМетаданныхЛкс(Истина, Истина, Истина,,,,,,,, Истина);
КонецФункции

Процедура ОбъектМетаданныхНачалоВыбора(Элемент, СтандартнаяОбработка)
	ирКлиент.ОбъектМетаданныхНачалоВыбораЛкс(Элемент, ПараметрыВыбораОбъектаМетаданных(), СтандартнаяОбработка);
КонецПроцедуры

Процедура ОбъектМетаданныхОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	Если Не ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		Значение = фОбъект.ПолноеИмяТаблицы;
		Возврат;
	КонецЕсли;
	ирКлиент.ОбъектМетаданныхОкончаниеВводаТекстаЛкс(Элемент, ПараметрыВыбораОбъектаМетаданных(), Текст, Значение, СтандартнаяОбработка);
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирКлиент.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ПослеВосстановленияЗначений()
	
	УстановитьОбъектМетаданных();
	
КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	ирКлиент.Форма_ОбновлениеОтображенияЛкс(ЭтаФорма);
	ЗначениеТабличногоПоля = ЭлементыФормы.ДинамическийСписок.Значение;
	#Если Сервер И Не Сервер Тогда
		ЗначениеТабличногоПоля = Новый ПостроительЗапроса;
	#КонецЕсли
	Отбор = "";
	Попытка
		Отбор = ЗначениеТабличногоПоля.Отбор;
	Исключение
	КонецПопытки; 
	ЭлементыФормы.НадписьОтбор.Заголовок = "Отбор: " + ирОбщий.ПредставлениеОтбораЛкс(Отбор);
	ДобавленВСписок = ирКлиент.ДобавитьОтборВИсториюТабличногоПоляЛкс(ЭтаФорма, фОбъект.ПолноеИмяТаблицы, Отбор, СтарыйОтбор);
	Если ДобавленВСписок Тогда
		ОбновитьПодменюПоследнихОтборов();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбновитьПодменюПоследнихОтборов()
	
	#Если Сервер И Не Сервер Тогда
		ПоследниеОтборыНажатие();
	#КонецЕсли
	ирКлиент.ПоследниеВыбранныеЗаполнитьПодменюЛкс(ЭтаФорма, ЭлементыФормы.КП_Список.Кнопки.ПоследниеОтборы, фОбъект.ПолноеИмяТаблицы, Новый Действие("ПоследниеОтборыНажатие"), "Отборы");

КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	Если Истина
		И КлючУникальности = "Связанный"
		И ИмяСобытия = "ТаблицаБД" 
		И Источник = ВладелецФормы 
	Тогда
		УстановитьОбъектМетаданных(Параметр, Истина);
	ИначеЕсли Истина
		И ИмяСобытия = "ЗаписанОбъект" 
		И ЗначениеЗаполнено(фОбъект.ПолноеИмяТаблицы)
	Тогда
		Если ТипЗнч(Параметр) = Тип("Тип") Тогда
			ОбъектМД = Метаданные.НайтиПоТипу(Параметр);
		ИначеЕсли ТипЗнч(Параметр) = Тип("Строка") Тогда
			ОбъектМД = ирКэш.ОбъектМДПоПолномуИмениЛкс(Параметр);
		Иначе
			ОбъектМД = Метаданные.НайтиПоТипу(ТипЗнч(Параметр));
		КонецЕсли; 
		Если Ложь
			Или Параметр = Неопределено
			Или (Истина
				И ОбъектМД <> Неопределено 
				И ОбъектМД.ПолноеИмя() = фОбъект.ПолноеИмяТаблицы)
		Тогда
			ЭлементыФормы.ДинамическийСписок.Значение.Обновить();
		КонецЕсли; 
	КонецЕсли; 
	ирКлиент.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура ДинамическийСписокВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если РежимВыбора Тогда
		ИмяПоляСсылка = ирОбщий.ПеревестиСтроку("Ссылка");
		Если ирОбщий.ТипТаблицыБДЛкс(фОбъект.ПолноеИмяТаблицы) = "Точки" Тогда
			Если ТипЗнч(ВыбраннаяСтрока) = Тип("Массив") Тогда
				Массив = Новый Массив;
				Для Каждого ЭлементМассива Из ВыбраннаяСтрока Цикл
					Массив.Добавить(ЭлементМассива[ИмяПоляСсылка]);
				КонецЦикла;
			Иначе
				Массив = ВыбраннаяСтрока[ИмяПоляСсылка];
			КонецЕсли; 
			ВыбраннаяСтрока = Массив;
		КонецЕсли; 
		ирКлиент.ПоследниеВыбранныеДобавитьЛкс(ЭтаФорма, ВыбраннаяСтрока);
		ОповеститьОВыборе(ВыбраннаяСтрока);
		СтандартнаяОбработка = Ложь;
	Иначе
		ДинамическийСписокПередНачаломИзменения(Элемент, СтандартнаяОбработка);
		СтандартнаяОбработка = Не СтандартнаяОбработка;
	КонецЕсли; 
	
КонецПроцедуры

Процедура КП_СписокВыбрать(Кнопка)

	ТабличноеПоле = ЭлементыФормы.ДинамическийСписок; 
	РезультатВыбора = ирКлиент.ВыделенныеСтрокиТабличногоПоляЛкс(ЭлементыФормы.ДинамическийСписок, Ложь);
	Если РезультатВыбора.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	Если Не МножественныйВыбор Тогда
		РезультатВыбора = РезультатВыбора[0];
	КонецЕсли;
	ДинамическийСписокВыбор(ТабличноеПоле, РезультатВыбора, ТабличноеПоле.ТекущаяКолонка, Истина);
	
КонецПроцедуры

Процедура КП_СписокВыбратьНужноеКоличество(Кнопка)
	
	Количество = 10;
	Если Не ВвестиЧисло(Количество, "Введите количество", 6, 0) Тогда
		Возврат;
	КонецЕсли; 
	Если Количество = 0 Тогда
		Возврат;
	КонецЕсли; 
	ирОбщий.ВыделитьПервыеСтрокиДинамическогоСпискаЛкс(ЭлементыФормы.ДинамическийСписок, Количество);
	
КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирКлиент.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработчикОжиданияСПараметрамиЛкс() Экспорт 
	
	ирКлиент.ОбработчикОжиданияСПараметрамиЛкс();

КонецПроцедуры

Процедура КП_СписокКопироватьСсылку(Кнопка)
	
	ТекущийЭлементФормы = ЭлементыФормы.ДинамическийСписок;
	ТекущаяСтрока = ТекущийЭлементФормы.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ирКлиент.БуферОбменаПриложения_УстановитьЗначениеЛкс(ТекущаяСтрока);
	
КонецПроцедуры

Процедура ДинамическийСписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель = Неопределено, ЭтоГруппа = Неопределено)
	
	ОбъектМД = ирКэш.ОбъектМДПоПолномуИмениЛкс(фОбъект.ПолноеИмяТаблицы);
	Если ирОбщий.ЛиДоступноРедактированиеВФормеОбъектаЛкс(ОбъектМД) Тогда
		Ответ = Вопрос("Использовать редактор объекта БД?", РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет);
	Иначе
		Ответ = КодВозвратаДиалога.Да;
	КонецЕсли; 
	Если Ответ = КодВозвратаДиалога.Да Тогда
		Отказ = Истина;
		ДобавитьСтрокуЧерезРедакторОбъектаБД(, Копирование, ЭтоГруппа);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПолеВводаКолонкиСписка_НачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ТабличноеПоле = ЭлементыФормы.ДинамическийСписок;
	Если СвязиИПараметрыВыбора Тогда
		ИмяПоляТаблицы = ТабличноеПоле.ТекущаяКолонка.Имя;
		ПоляТаблицыБД = ирКэш.ПоляТаблицыБДЛкс(фОбъект.ПолноеИмяТаблицы);
		МетаРеквизит = ПоляТаблицыБД.Найти(ИмяПоляТаблицы, "Имя").Метаданные;
		СтруктураОтбора = ирКлиент.СтруктураОтбораПоСвязямИПараметрамВыбораЛкс(МетаРеквизит, ТабличноеПоле.ТекущиеДанные);
	КонецЕсли; 
	ирКлиент.ПолеВводаКолонкиРасширенногоЗначения_НачалоВыбораЛкс(ЭтаФорма, ТабличноеПоле, СтандартнаяОбработка,, Истина, СтруктураОтбора);

КонецПроцедуры

Процедура ПолеВводаКолонкиСписка_ОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	ирКлиент.ПолеВвода_ОкончаниеВводаТекстаЛкс(Элемент, Текст, Значение, СтандартнаяОбработка);

КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирКлиент.ОтменитьФоновоеЗаданиеЛкс(фОбъект.ИДФоновогоЗадания);
	СохранитьНастройкиТаблицы();
	ирКлиент.Форма_ПриЗакрытииЛкс(ЭтаФорма);
	
КонецПроцедуры

Функция Отбор() Экспорт 
	Возврат Отбор;
КонецФункции

Функция ПользовательскийОтбор(Отключить = Ложь) Экспорт 
	Если Отключить Тогда
		ирОбщий.УстановитьСвойствоВКоллекцииЛкс(Отбор, "Использование", Ложь);
	КонецЕсли;
	Возврат Отбор;
КонецФункции

Процедура КП_СписокОсновнаяФорма(Кнопка)
	
	Если Не ЗначениеЗаполнено(фОбъект.ПолноеИмяТаблицы) Тогда
		Возврат;
	КонецЕсли; 
	Если РежимВыбора Тогда
		Закрыть();
	КонецЕсли; 
	ДинамическийСписок = ЭлементыФормы.ДинамическийСписок.Значение;
	Попытка
		Отбор = ДинамическийСписок.Отбор;
	Исключение
		Отбор = Неопределено;
	КонецПопытки;
	Форма = ирКлиент.ОткрытьФормуСпискаЛкс(фОбъект.ПолноеИмяТаблицы, Отбор, Ложь, ВладелецФормы, РежимВыбора, МножественныйВыбор, ЭлементыФормы.ДинамическийСписок.ТекущаяСтрока);
	Если Форма = Неопределено Тогда
		ЭтаФорма.Открыть();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ВместоОсновнойПриИзменении(Элемент)
	
	ирОбщий.СохранитьЗначениеЛкс("ирДинамическийСписок.ВместоОсновной." + фОбъект.ПолноеИмяТаблицы, фОбъект.ВместоОсновной);

КонецПроцедуры

Процедура КП_СписокСвязанныйРедакторОбъектаБДСтроки(Кнопка)

	Если ЭлементыФормы.ДинамическийСписок.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ОткрытьСвязанныйРедакторОбъектаБДСтроки();
	
КонецПроцедуры

Процедура ДинамическийСписокПриАктивизацииСтроки(Элемент)
	
	ирКлиент.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	Если мСвязанныйРедакторОбъектаБД <> Неопределено И мСвязанныйРедакторОбъектаБД.Открыта() Тогда
		ОткрытьСвязанныйРедакторОбъектаБДСтроки();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОткрытьСвязанныйРедакторОбъектаБДСтроки()
	
	ирКлиент.ОткрытьТекущуюСтрокуТабличногоПоляТаблицыБДВРедактореОбъектаБДЛкс(ЭлементыФормы.ДинамическийСписок, фОбъект.ПолноеИмяТаблицы,, Истина, мСвязанныйРедакторОбъектаБД,, Ложь,,,, ЭтаФорма);

КонецПроцедуры

Процедура КП_СписокРежимДерева(Кнопка)
	
	Кнопка.Пометка = Не Кнопка.Пометка;
	Если Кнопка.Пометка Тогда
		Попытка
			ЭлементыФормы.ДинамическийСписок.ИерархическийПросмотр = Истина;
		Исключение
		КонецПопытки;
	КонецЕсли;
	Попытка
		Если ЭлементыФормы.ДинамическийСписок.Дерево <> Кнопка.Пометка Тогда
			ЭлементыФормы.ДинамическийСписок.Дерево = Кнопка.Пометка;
		КонецЕсли;
	Исключение
	КонецПопытки;
	Попытка
		ЭлементыФормы.ДинамическийСписок.ИерархическийПросмотр = Истина;
	Исключение
	КонецПопытки;
	
КонецПроцедуры

Процедура КП_СписокОбновить(Кнопка)
	
	ЭлементыФормы.ДинамическийСписок.Значение.Обновить();
	
КонецПроцедуры

Процедура КП_СписокСправкаМетаданного(Кнопка)
	
	ОткрытьСправку(ирКэш.ОбъектМДПоПолномуИмениЛкс(фОбъект.ПолноеИмяТаблицы));
	
КонецПроцедуры

Процедура КП_СписокИмяСиноним(Кнопка)
	
	Если Не ЗначениеЗаполнено(фОбъект.ПолноеИмяТаблицы) Тогда
		Возврат;
	КонецЕсли; 
	фОбъект.РежимИмяСиноним = Не Кнопка.Пометка;
	Кнопка.Пометка = фОбъект.РежимИмяСиноним;
	ирКлиент.НастроитьЗаголовкиАвтоТабличногоПоляДинамическогоСпискаЛкс(ЭлементыФормы.ДинамическийСписок, фОбъект.РежимИмяСиноним);
	
КонецПроцедуры

Процедура КП_СписокОткрытьОбъектМетаданных(Кнопка)
	
	ирКлиент.ПредложитьЗакрытьМодальнуюФормуЛкс(ЭтаФорма);
	ирКлиент.ОткрытьОбъектМетаданныхЛкс(фОбъект.ПолноеИмяТаблицы);
	
КонецПроцедуры

Процедура КП_СписокСброситьНастройкиСписка(Кнопка)
	
	ирОбщий.СохранитьЗначениеЛкс("ДинамическийСписок." + фОбъект.СтарыйОбъектМетаданных + "." + РежимВыбора, Неопределено);
	УстановитьОбъектМетаданных();
	СохранитьНастройкиТаблицы();
	
КонецПроцедуры

Функция ПоследниеВыбранныеНажатие(Кнопка) Экспорт
	
	ирКлиент.ПоследниеВыбранныеНажатиеЛкс(ЭтаФорма, ЭлементыФормы.ДинамическийСписок, , Кнопка);
	
КонецФункции

Функция ПоследниеОтборыНажатие(Кнопка) Экспорт
	
	НастройкаКомпоновки = ирКлиент.ВыбранныйЭлементПоследнихЗначенийЛкс(ЭтаФорма, фОбъект.ПолноеИмяТаблицы, Кнопка, "Отборы", Истина);
	#Если Сервер И Не Сервер Тогда
		НастройкаКомпоновки = Новый НастройкиКомпоновкиДанных;
	#КонецЕсли
	ирОбщий.СкопироватьОтборЛюбойЛкс(ЭлементыФормы.ДинамическийСписок.Значение.Отбор, НастройкаКомпоновки.Отбор);
	
КонецФункции

Процедура ОбъектМетаданныхОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ирКлиент.ОткрытьОбъектМетаданныхЛкс(фОбъект.ПолноеИмяТаблицы);
	
КонецПроцедуры

Процедура ОбновитьКоличествоСтрок()
	
	Если ЗначениеЗаполнено(фОбъект.ИДФоновогоЗадания) Тогда
		ФоновоеЗадание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(фОбъект.ИДФоновогоЗадания);
		Если ФоновоеЗадание.Состояние = СостояниеФоновогоЗадания.Активно Тогда
			ПодключитьОбработчикОжидания("ОбновитьКоличествоСтрок", 2, Истина);
		Иначе
			Результат = ирОбщий.ПрочитатьРезультатФоновогоЗаданияЛкс(фОбъект.АдресХранилищаКоличестваСтрок, ФормаРезультата);
		КонецЕсли; 
	Иначе
		// www.hostedredmine.com/issues/884199
	КонецЕсли;
	Если Результат <> Неопределено Тогда
		фОбъект.КоличествоСтрокВОбластиПоиска = Результат;
	КонецЕсли; 

КонецПроцедуры

Процедура НастройкаКолонок(Команда)
	
	Если Не ЗначениеЗаполнено(ПолноеИмяТаблицы) Тогда
		Возврат;
	КонецЕсли;
	СохранитьНастройкиТаблицы();
	ФормаНастроек = ирКлиент.ПолучитьФормуЛкс("Обработка.ирДинамическийСписок.Форма.НастройкиКолонок",, ЭтаФорма);
	ЗаполнитьЗначенияСвойств(ФормаНастроек, фОбъект); 
	ФормаНастроек.НастройкиКолонок.Загрузить(фОбъект.НастройкиКолонок.Выгрузить());
	ФормаНастроек.СвязанноеТабличноеПоле = ЭлементыФормы.ДинамическийСписок;
	ВыбранноеЗначение = ФормаНастроек.ОткрытьМодально();
	Если ВыбранноеЗначение <> Неопределено Тогда
		СохранитьНастройкиТаблицы();
	КонецЕсли;
	
КонецПроцедуры

Процедура НадписьПраваДоступаКСтрокамНажатие(Элемент)
	
	Форма = ирКлиент.ПолучитьФормуЛкс("Отчет.ирАнализПравДоступа.Форма",,, фОбъект.ПолноеИмяТаблицы);
	Форма.ОбъектМетаданных = фОбъект.ПолноеИмяТаблицы;
	Форма.Пользователь = ИмяПользователя();
	Форма.ПараметрКлючВарианта = "ПоПользователям";
	Форма.Открыть();
	
КонецПроцедуры

Процедура ДобавитьСтрокуЧерезРедакторОбъектаБД(Кнопка = Неопределено, Копирование = Неопределено, ЭтоГруппа = Ложь)
	
	ИмяПоляСсылка = ирОбщий.ПеревестиСтроку("Ссылка");
	ИмяПоляЭтоГруппа = ирОбщий.ПеревестиСтроку("ЭтоГруппа");
	Если Копирование = Неопределено Тогда
		Если ЭлементыФормы.ДинамическийСписок.ТекущаяСтрока <> Неопределено Тогда
			Ответ = Вопрос("Хотите скопировать текущую строку?", РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет);
			Копирование = Ответ = КодВозвратаДиалога.Да;
		Иначе
			Копирование = Ложь;
		КонецЕсли; 
	КонецЕсли; 
	ОбъектМД = ирКэш.ОбъектМДПоПолномуИмениЛкс(фОбъект.ПолноеИмяТаблицы);
	Если ирОбщий.ЛиКорневойТипСсылочногоОбъектаБДЛкс(ирОбщий.ПервыйФрагментЛкс(фОбъект.ПолноеИмяТаблицы)) Тогда
		Если ПравоДоступа("Добавление", ОбъектМД) Тогда
			ЭлементОтбораЭтоГруппа = ЭлементыФормы.ДинамическийСписок.Значение.Отбор.Найти(ИмяПоляЭтоГруппа);
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
						И ЭлементОтбораЭтоГруппа.ВидСравнения = ВидСравнения.Равно
						И ЭлементОтбораЭтоГруппа.Значение = Истина);
				СтруктураОбъекта = ирОбщий.ОбъектБДПоКлючуЛкс(фОбъект.ПолноеИмяТаблицы, ЭтоГруппа);
			КонецЕсли; 
			ирОбщий.УстановитьЗначенияРеквизитовПоОтборуЛкс(СтруктураОбъекта.Данные, ЭлементыФормы.ДинамическийСписок.Значение.Отбор);
			ирКлиент.ОткрытьОбъектВРедактореОбъектаБДЛкс(СтруктураОбъекта);
		Иначе
			ирКлиент.ОткрытьОбъектВРедактореОбъектаБДЛкс(Новый(ирОбщий.ИмяТипаИзПолногоИмениТаблицыБДЛкс(фОбъект.ПолноеИмяТаблицы, "Ссылка")));
		КонецЕсли; 
	Иначе
		КлючОбъекта = ирОбщий.СтруктураКлючаТаблицыБДЛкс(фОбъект.ПолноеИмяТаблицы, Ложь);
		Для Каждого КлючИЗначение Из КлючОбъекта Цикл
			Если Копирование Тогда
				КлючОбъекта[КлючИЗначение.Ключ] = ЭлементыФормы.ДинамическийСписок.ТекущаяСтрока[КлючИЗначение.Ключ];
			Иначе
				КлючОбъекта[КлючИЗначение.Ключ] = Неопределено;
			КонецЕсли; 
		КонецЦикла;
		СтруктураОбъекта = ирОбщий.ОбъектБДПоКлючуЛкс(фОбъект.ПолноеИмяТаблицы, КлючОбъекта);
		ирКлиент.ОткрытьСсылкуВРедактореОбъектаБДЛкс(СтруктураОбъекта);
	КонецЕсли; 
	
КонецПроцедуры

Процедура КП_СписокНайтиВыбратьПоID(Кнопка)
	
	Если Не ЗначениеЗаполнено(фОбъект.ПолноеИмяТаблицы) Тогда
		Возврат;
	КонецЕсли; 
	ирКлиент.НайтиВыбратьСсылкуВДинамическомСпискеПоIDЛкс(ЭлементыФормы.ДинамическийСписок, ЭтаФорма);
	
КонецПроцедуры

Процедура КоличествоСтрокВОбластиПоискаОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	фОбъект.КоличествоСтрокВОбластиПоиска = ирОбщий.КоличествоСтрокВТаблицеМДЛкс(фОбъект.ПолноеИмяТаблицы);
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирКлиент.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирКлиент.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура ДинамическийСписокПередНачаломИзменения(Элемент = Неопределено, Отказ = Ложь)
	
	СтандартнаяОбработка = Не ОткрытьРедакторОбъектаБДЕслиНужно();
	Если СтандартнаяОбработка Тогда
		ирКлиент.ОткрытьЗначениеЛкс(Элемент.ТекущаяСтрока,, СтандартнаяОбработка);
	КонецЕсли;
	Отказ = Не СтандартнаяОбработка;
	
КонецПроцедуры

Функция ОткрытьРедакторОбъектаБДЕслиНужно()
	
	ОбъектМД = ирКэш.ОбъектМДПоПолномуИмениЛкс(фОбъект.ПолноеИмяТаблицы);
	Если Не ирОбщий.ЛиДоступноРедактированиеВФормеОбъектаЛкс(ОбъектМД) Тогда
		ИзменитьСтрокуЧерезРедакторОбъектаБД();
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;

КонецФункции

Процедура ДинамическийСписокПриАктивизацииКолонки(Элемент)
	ирКлиент.ТабличноеПолеПриАктивацииКолонкиЛкс(ЭтаФорма, Элемент);
КонецПроцедуры

Процедура КП_СписокОтображатьОстатки(Кнопка)
	Кнопка = ЭлементыФормы.КП_Список.Кнопки.ОтображатьОстатки;
	НоваяПометка = Не Кнопка.Пометка;
	ОбъектМД = ирОбщий.ОбъектМДПоПолномуИмениТаблицыБДЛкс(ПолноеИмяТаблицы);
	Если Не Кнопка.Доступность Тогда
		Возврат;
	КонецЕсли;
	ирКлиент.ТабличноеПолеРегистраОбновитьКолонкиОстатковЛкс(ЭлементыФормы.ДинамическийСписок, ОбъектМД, Кнопка, НоваяПометка);
КонецПроцедуры

Процедура КП_СписокНовоеОкно(Кнопка)
	
	ирКлиент.ОткрытьФормуСпискаЛкс(ПолноеИмяТаблицы,, "Обычная",,,, ЭлементыФормы.ДинамическийСписок.ТекущаяСтрока,, ПользовательскийОтбор(),, Новый УникальныйИдентификатор);

КонецПроцедуры

Процедура КП_СписокСвязанныеКолонкиБД(Кнопка)
	ирКлиент.ОткрытьРедакторОбъектаБДЛкс(ПолноеИмяТаблицы,,, ЭлементыФормы.ДинамическийСписок.ТекущаяСтрока,,, Ложь,,,, Истина,, ЭтаФорма);
КонецПроцедуры

Процедура КП_СписокПриемОбъекта(Кнопка)
	УстановитьНовыйПриемОбъекта(Не Кнопка.Пометка);
КонецПроцедуры

Процедура УстановитьНовыйПриемОбъекта(Знач НовыйПриемОбъекта = Неопределено) Экспорт 
	
	ирКлиент.УстановитьРежимПриемаОбъектаФормеЛкс(ЭтаФорма, ЭлементыФормы.КП_Список.Кнопки.ПриемОбъекта, НовыйПриемОбъекта, ПолноеИмяТаблицы);

КонецПроцедуры

Функция ПредставлениеОбъектаДанных() Экспорт 
	
	Результат = ирОбщий.ПредставлениеТаблицыБДЛкс(фОбъект.ПолноеИмяТаблицы);
	Возврат Результат;

КонецФункции

Процедура ДинамическийСписокОбработкаЗаписиНовогоОбъекта(Элемент, Объект, СтандартнаяОбработка)
	ирКлиент.ДобавитьСсылкуВИсториюРаботыЛкс(Объект.Ссылка);
КонецПроцедуры

ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирДинамическийСписок.Форма.Форма");
//Если КлючУникальности = "Связанный" Тогда
//	ЭтаФорма.Заголовок = ЭтаФорма.Заголовок + " (связанный)";
//КонецЕсли;
Построитель = Новый ПостроительЗапроса;
