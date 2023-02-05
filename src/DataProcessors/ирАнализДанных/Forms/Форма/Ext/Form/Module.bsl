﻿Перем ВесПоУмолчанию;
Перем мТаблицаТиповАнализа;

Функция СохраняемаяНастройкаФормы(выхНаименование, выхИменаСвойств) Экспорт 
	выхИменаСвойств = "Табличная часть.КолонкиАнализаДанных";
	Результат = Новый Структура;
	Результат.Вставить("Параметры", ирОбщий.ТаблицаЗначенийИзКоллекцииЛкс(Построитель.Параметры));
	Возврат Результат;
КонецФункции

Процедура ЗагрузитьНастройкуВФорме(НастройкаФормы, ДопПараметры) Экспорт 
	
	Если НастройкаФормы <> Неопределено Тогда
		#Если Сервер И Не Сервер Тогда
			НастройкаФормы = Новый Структура;
		#КонецЕсли
		ДоступныеРолиКолонки = ЭлементыФормы.КолонкиАнализаДанных.Колонки.ТипКолонки.ЭлементУправления.СписокВыбора;
		Для Каждого СтараяСтрока Из НастройкаФормы.КолонкиАнализаДанных Цикл
			НоваяСтрока = КолонкиАнализаДанных.Найти(СтараяСтрока.Имя, "Имя");
			Если НоваяСтрока <> Неопределено Тогда
				ЗаполнитьЗначенияСвойств(НоваяСтрока, СтараяСтрока); 
			КонецЕсли; 
		КонецЦикла;
		НастройкаФормы.Удалить("КолонкиАнализаДанных");
		ЗагрузитьЗначенияПараметров(НастройкаФормы.Параметры);
		НастройкаФормы.Удалить("Параметры");
		ирКлиент.ЗагрузитьНастройкуФормыЛкс(ЭтаФорма, НастройкаФормы); 
	КонецЕсли; 
	НастроитьЭлементыФормы();
	
КонецПроцедуры

Процедура ЗагрузитьЗначенияПараметров(Знач НовыеЗначенияПараметров)
	
	Для Каждого СтараяСтрока Из НовыеЗначенияПараметров Цикл
		НоваяСтрока = Построитель.Параметры.Найти(СтараяСтрока.Имя);
		Если НоваяСтрока <> Неопределено Тогда
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтараяСтрока); 
		КонецЕсли; 
	КонецЦикла;

КонецПроцедуры

Процедура УстановитьОтборТолькоВключенные(НовоеЗначение)
	
	ЭлементыФормы.КПКолонки.Кнопки.ТолькоВключенные.Пометка = НовоеЗначение;
	ЭлементыФормы.КолонкиТабличногоПоля.ОтборСтрок.Пометка.ВидСравнения = ВидСравнения.Равно;
	ЭлементыФормы.КолонкиТабличногоПоля.ОтборСтрок.Пометка.Использование = НовоеЗначение;
	ЭлементыФормы.КолонкиТабличногоПоля.ОтборСтрок.Пометка.Значение = Истина;
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ирКлиент.Форма_ПриОткрытииЛкс(ЭтаФорма);
	УстановитьТипАнализа();

КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	ирКлиент.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
КонецПроцедуры

Процедура ОсновныеДействияФормыОК(Кнопка)
	
	ЗагрузитьНастройкиКолонокВПостроитель();
	ПараметрТипЗаполнения = Построитель.Параметры.Найти("ТипЗаполненияТаблицы");
	Если МодальныйРежим И ПараметрТипЗаполнения <> Неопределено Тогда
		ПользовательскийТипЗаполнения = ПараметрТипЗаполнения.Значение;
		Если ПользовательскийТипЗаполнения = ТипЗаполненияТаблицыРезультатаАнализаДанных.НеЗаполнять Тогда
			Построитель.Параметры.ТипЗаполненияТаблицы.Значение = ТипЗаполненияТаблицыРезультатаАнализаДанных.ИспользуемыеПоля;
		КонецЕсли; 
	КонецЕсли; 
	Построитель.Выполнить();
	Если МодальныйРежим И ПараметрТипЗаполнения <> Неопределено Тогда
		Если ПользовательскийТипЗаполнения = ТипЗаполненияТаблицыРезультатаАнализаДанных.НеЗаполнять Тогда
			ТаблицаКластеризации = Построитель.Результат.ТаблицаКластеризации.Скопировать();
			Построитель.Результат.ТаблицаКластеризации.Очистить();
		КонецЕсли; 
		Построитель.Параметры.ТипЗаполненияТаблицы.Значение = ПользовательскийТипЗаполнения;
	КонецЕсли; 
	Документ = Новый ТабличныйДокумент;
	Построитель.Вывести(Документ);
	Если МодальныйРежим Тогда
		Если ТаблицаКластеризации <> Неопределено Тогда
			ирОбщий.ЗагрузитьВТаблицуЗначенийЛкс(Построитель.Результат.ТаблицаКластеризации, ТаблицаКластеризации);
		КонецЕсли; 
		Закрыть(Построитель.Результат);
	КонецЕсли; 
	ирКлиент.ОткрытьЗначениеЛкс(Документ,,, "" + ТипАнализа + ": " + ирОбщий.ТекущееВремяЛкс(), Ложь);
	
КонецПроцедуры

Процедура ЗагрузитьНастройкиКолонокВПостроитель()
	
	ПеречислениеТиповКолонки = ПеречислениеТиповКолонкиАнализаДанных();
	Для Каждого СтрокаКолонки Из КолонкиАнализаДанных Цикл
		КолонкаПостроителя = Построитель.НастройкаКолонок.Найти(СтрокаКолонки.Имя);
		Если КолонкаПостроителя = Неопределено Тогда
			Продолжить;
		КонецЕсли; 
		КолонкаПостроителя.ВидДанных = ВидДанныхАнализа[СтрокаКолонки.ВидДанных];
		КолонкаПостроителя.ТипКолонки = ПеречислениеТиповКолонки[СтрокаКолонки.ТипКолонки];
		Если КолонкаПостроителя.ДополнительныеПараметры <> Неопределено Тогда
			ЗаполнитьЗначенияСвойств(КолонкаПостроителя.ДополнительныеПараметры, СтрокаКолонки); 
		КонецЕсли; 
	КонецЦикла;

КонецПроцедуры

Процедура НастроитьЭлементыФормы()
	
	
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирКлиент.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура КолонкиТабличногоПоляПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт

	ирКлиент.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
	
КонецПроцедуры

Процедура КолонкиТабличногоПоляПриАктивизацииСтроки(Элемент)
	
	ирКлиент.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);

КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирКлиент.Форма_ПриЗакрытииЛкс(ЭтаФорма);

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

Процедура КолонкиАнализаДанныхВесОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Элемент.Значение = ВесПоУмолчанию;
	
КонецПроцедуры

Процедура КПКолонкиУстановитьТипКолонки(Кнопка)
	
	Для Каждого ВыделеннаяСтрока Из ЭлементыФормы.КолонкиАнализаДанных.ВыделенныеСтроки Цикл
		ВыделеннаяСтрока.ТипКолонки = Кнопка.Имя;
	КонецЦикла;
	
КонецПроцедуры

Процедура ДействияФормыСгенерироватьПрограммныйКод(Кнопка)
	
	Текст = ирОбщий.СтрШаблонИменЛкс("
	|Анализ = Новый АнализДанных;
	|Анализ.ИсточникДанных = ПараметрТаблица;
	|Анализ.ТипАнализа = Тип(%1);",, ирОбщий.ИмяТипаЛкс(ТипАнализа));
	Для Каждого Параметр Из Построитель.Параметры Цикл
		Текст = Текст + ирОбщий.СтрШаблонЛкс("
		|Анализ.Параметры.%1.Значение = %2;", Параметр.Имя, ирОбщий.ПредставлениеЗначенияВоВстроенномЯзыкеЛкс(Параметр.Значение));
	КонецЦикла;
	Для Каждого Колонка Из КолонкиАнализаДанных Цикл
		Текст = Текст + ирОбщий.СтрШаблонЛкс("
		|Анализ.НастройкаКолонок.%1.ТипКолонки = %2;", Колонка.Имя, ПолучитьПолноеИмяПредопределенногоЗначения(ПеречислениеТиповКолонкиАнализаДанных()[Колонка.ТипКолонки]));
		Текст = Текст + ирОбщий.СтрШаблонЛкс("
		|Анализ.НастройкаКолонок.%1.ВидДанных = %2;", Колонка.Имя, ПолучитьПолноеИмяПредопределенногоЗначения(ВидДанныхАнализа[Колонка.ВидДанных]));
		Если ТипАнализа = Тип("АнализДанныхКластеризация") Тогда
			Текст = Текст + ирОбщий.СтрШаблонЛкс("
			|Анализ.НастройкаКолонок.%1.ДополнительныеПараметры.Вес = %2;", Колонка.Имя, ирОбщий.СтроковыйИдентификаторЗначенияЛкс(Колонка.Вес));
		КонецЕсли; 
	КонецЦикла;
	Текст = Текст + "
	|РезультатАнализа = Анализ.Выполнить();";
	ирОбщий.ОперироватьСтруктуройЛкс(Текст, , Новый Структура("ПараметрТаблица", ПараметрТаблица));
	
КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	КолонкиАнализаДанных.Очистить();
	Построитель.ИсточникДанных = ПараметрТаблица;
	СписокВыбора = ЭлементыФормы.ТипАнализа.СписокВыбора;
	#Если Сервер И Не Сервер Тогда
		СписокВыбора = Новый СписокЗначений;
	#КонецЕсли
	СписокВыбора.Добавить(Тип("АнализДанныхДеревоРешений"));
	СписокВыбора.Добавить(Тип("АнализДанныхКластеризация"));
	СписокВыбора.Добавить(Тип("АнализДанныхОбщаяСтатистика"));
	СписокВыбора.Добавить(Тип("АнализДанныхПоискАссоциаций"));
	СписокВыбора.Добавить(Тип("АнализДанныхПоискПоследовательностей"));
	мТаблицаТиповАнализа = ирОбщий.ТаблицаЗначенийИзТабличногоДокументаЛкс(ПолучитьМакет("ТипыАнализа"));

КонецПроцедуры

Функция ПеречислениеТиповКолонкиАнализаДанных()
	
	Если ТипАнализа = Тип("АнализДанныхКластеризация") Тогда
		ПеречислениеРолейКолонок = ТипКолонкиАнализаДанныхКластеризация;
	ИначеЕсли ТипАнализа = Тип("АнализДанныхПоискАссоциаций") Тогда
		ПеречислениеРолейКолонок = ТипКолонкиАнализаДанныхПоискАссоциаций;
	ИначеЕсли ТипАнализа = Тип("АнализДанныхПоискПоследовательностей") Тогда
		ПеречислениеРолейКолонок = ТипКолонкиАнализаДанныхПоискПоследовательностей;
	ИначеЕсли ТипАнализа = Тип("АнализДанныхДеревоРешений") Тогда
		ПеречислениеРолейКолонок = ТипКолонкиАнализаДанныхДеревоРешений;
	ИначеЕсли ТипАнализа = Тип("АнализДанныхОбщаяСтатистика") Тогда
		ПеречислениеРолейКолонок = ТипКолонкиАнализаДанныхОбщаяСтатистика;
	КонецЕсли;
	Возврат ПеречислениеРолейКолонок;

КонецФункции

Процедура ТипАнализаПриИзменении(Элемент)
	
	УстановитьТипАнализа();
	
КонецПроцедуры

Процедура УстановитьТипАнализа()
	
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	ирКлиент.СохранитьНастройкуФормыЛкс(ЭтаФорма);
	СтарыеЗначенияПараметров = ирОбщий.ТаблицаЗначенийИзКоллекцииЛкс(Построитель.Параметры);
	Построитель.ТипАнализа = ТипАнализа;
	Если ТипАнализа = Тип("АнализДанныхКластеризация") Тогда 
		Построитель.Макет = ПолучитьМакет("МакетКластерныйАнализ");
		//КартинкаЗаголовка = ЭлементыФормы.КартинкаКластерныйАнализ.Картинка;
	ИначеЕсли ТипАнализа = Тип("АнализДанныхДеревоРешений") Тогда 
		Построитель.Макет = ПолучитьМакет("МакетДеревоРешений");
		//КартинкаЗаголовка = ЭлементыФормы.КартинкаДеревоРешений.Картинка;
	ИначеЕсли ТипАнализа = Тип("АнализДанныхПоискАссоциаций") Тогда 
		Построитель.Макет = ПолучитьМакет("МакетПоискАссоциаций");
		//КартинкаЗаголовка = ЭлементыФормы.КартинкаПоискАссоциаций.Картинка;
	ИначеЕсли ТипАнализа = Тип("АнализДанныхПоискПоследовательностей") Тогда 
		Построитель.Макет = ПолучитьМакет("МакетПоискПоследовательностей");
		//КартинкаЗаголовка = ЭлементыФормы.КартинкаПоискПоследовательностей.Картинка;
	ИначеЕсли ТипАнализа = Тип("АнализДанныхОбщаяСтатистика") Тогда 
		Построитель.Макет = ПолучитьМакет("МакетОбщаяСтатистика");
		//КартинкаЗаголовка = ЭлементыФормы.КартинкаОбщаяСтатистика.Картинка;
	КонецЕсли;
	ЗагрузитьЗначенияПараметров(СтарыеЗначенияПараметров);
	ЭлементыФормы.КолонкиАнализаДанных.Колонки.Вес.Видимость = ТипАнализа = Тип("АнализДанныхКластеризация");
	ДоступныеЗначенияКолонки = мПлатформа.ДоступныеЗначенияТипа(ТипЗнч(ВидДанныхАнализа));
	ЭлементыФормы.КолонкиАнализаДанных.Колонки.ВидДанных.ЭлементУправления.СписокВыбора = ДоступныеЗначенияКолонки;
	ПеречислениеТиповКолонки = ПеречислениеТиповКолонкиАнализаДанных();
	ДоступныеЗначенияКолонки = мПлатформа.ДоступныеЗначенияТипа(ТипЗнч(ПеречислениеТиповКолонки));
	ЭлементыФормы.КолонкиАнализаДанных.Колонки.ТипКолонки.ЭлементУправления.СписокВыбора = ДоступныеЗначенияКолонки;
	Для Каждого Колонка Из Построитель.НастройкаКолонок Цикл
		#Если Сервер И Не Сервер Тогда
			Колонка = Построитель.НастройкаКолонок.Найти();
		#КонецЕсли
		СтрокаКолонки = КолонкиАнализаДанных.Найти(Колонка.Имя);
		Если СтрокаКолонки = Неопределено Тогда
			СтрокаКолонки = КолонкиАнализаДанных.Добавить();
			СтрокаКолонки.Имя = Колонка.Имя;
			СтрокаКолонки.ВидДанных = ирОбщий.СтроковыйИдентификаторЗначенияЛкс(Колонка.ВидДанных);
			СтрокаКолонки.Вес = ВесПоУмолчанию;
		КонецЕсли; 
		Если ДоступныеЗначенияКолонки.НайтиПоЗначению(СтрокаКолонки.ТипКолонки) = Неопределено Тогда
			Если СтрокаКолонки.Имя = "Кластер" + ирОбщий.СуффиксСлужебногоСвойстваЛкс() Тогда
				СтрокаКолонки.ТипКолонки = ирОбщий.СтроковыйИдентификаторЗначенияЛкс(ПеречислениеТиповКолонки.НеИспользуемая);
			Иначе
				СтрокаКолонки.ТипКолонки = ирОбщий.СтроковыйИдентификаторЗначенияЛкс(Колонка.ТипКолонки);
			КонецЕсли; 
		КонецЕсли; 
	КонецЦикла; 
	ПодменюТипКолонки = ЭлементыФормы.КПКолонки.Кнопки.УстановитьТипКолонки.Кнопки;
	ПодменюТипКолонки.Очистить();
	ДоступныеЗначенияКолонки.СортироватьПоПредставлению();
	Для Каждого ЭлементСписка Из ДоступныеЗначенияКолонки Цикл
		Кнопка = ПодменюТипКолонки.Добавить(ирОбщий.СтроковыйИдентификаторЗначенияЛкс(ЭлементСписка.Значение), ТипКнопкиКоманднойПанели.Действие);
		#Если Сервер И Не Сервер Тогда
			КПКолонкиУстановитьТипКолонки();
		#КонецЕсли
		Кнопка.Действие = Новый Действие("КПКолонкиУстановитьТипКолонки");
		Кнопка.Текст = ЭлементСписка.Значение;
	КонецЦикла;
	НачальноеКоличество = КолонкиАнализаДанных.Количество(); 
	Для Счетчик = 1 По НачальноеКоличество Цикл
		Колонка = КолонкиАнализаДанных[НачальноеКоличество - Счетчик];
		Если Построитель.НастройкаКолонок.Найти(Колонка.Имя) = Неопределено Тогда
			КолонкиАнализаДанных.Удалить(Колонка);
		КонецЕсли;
	КонецЦикла;
	ирКлиент.СоздатьМенеджерСохраненияНастроекФормыЛкс(ЭтаФорма, ТипАнализа);
	Если МодальныйРежим Тогда
		СтрокаПараметра = Построитель.Параметры.Найти(ирОбщий.ПеревестиСтроку("ТипЗаполненияТаблицы"));
		СтрокаПараметра.Значение = ТипЗаполненияТаблицыРезультатаАнализаДанных.ИспользуемыеПоля;
	КонецЕсли;
	Если ПараметрВыделенныеКолонки <> Неопределено Тогда   
		ВыделенныеСтроки = ЭлементыФормы.КолонкиАнализаДанных.ВыделенныеСтроки;
		ВыделенныеСтроки.Очистить();
		Для Каждого ИмяКолонки Из ПараметрВыделенныеКолонки Цикл
			СтрокаКолонки = КолонкиАнализаДанных.Найти(ИмяКолонки, "Имя");
			Если СтрокаКолонки <> Неопределено Тогда
				ВыделенныеСтроки.Добавить(СтрокаКолонки);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	Если ПараметрИмяКолонки <> Неопределено Тогда   
		СтрокаКолонки = КолонкиАнализаДанных.Найти(ПараметрИмяКолонки, "Имя");
		Если СтрокаКолонки <> Неопределено Тогда
			ЭлементыФормы.КолонкиАнализаДанных.ТекущаяСтрока = СтрокаКолонки;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Процедура ДействияФормыИсходнаяТаблица(Кнопка)
	
	ирКлиент.ОткрытьЗначениеЛкс(ПараметрТаблица,,,, Ложь);

КонецПроцедуры

Процедура ДействияФормыСтатья1(Кнопка)
	
	ЗапуститьПриложение("https://infostart.ru/1c/articles/1486999");
	
КонецПроцедуры

Процедура НадписьОписаниеНажатие(Элемент)
	
	ИмяТипа = ирОбщий.ИмяТипаЛкс(ТипАнализа);
	ирКлиент.ОткрытьТекстЛкс(мТаблицаТиповАнализа.Найти(ИмяТипа, "Имя").Описание, "" + ТипАнализа,, Истина, ИмяТипа);
	
КонецПроцедуры

Процедура ПараметрыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	Если МодальныйРежим И ДанныеСтроки.Имя = ирОбщий.ПеревестиСтроку("ТипЗаполненияТаблицы") Тогда
		ОформлениеСтроки.Ячейки.Значение.ТолькоПросмотр = Истина;
	КонецЕсли;
	
КонецПроцедуры

ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирАнализДанных.Форма.Форма");
ВесПоУмолчанию = 100;
ТипАнализа = Тип("АнализДанныхКластеризация");
мТаблицаТиповАнализа = Новый ТаблицаЗначений;