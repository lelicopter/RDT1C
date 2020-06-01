﻿//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирПривилегированный Экспорт;

Перем мПорцияРезультата;
Перем ИмяСвойстваНомера;

Процедура НачатьПоиск()

	Если ПолеВводаПоиска = "" Тогда 
		Возврат;
	КонецЕсли;
	Если ОграничитьОбъектыПоиска = Истина Тогда
		МассивМД = Новый Массив();
		Для Каждого МД Из СписокМетаданных Цикл
			МассивМД.Добавить(Метаданные.НайтиПоПолномуИмени(МД.Значение));
		КонецЦикла;	
		мПорцияРезультата.ОбластьПоиска = МассивМД;
	Иначе	
		МассивМД = Новый Массив();
		мПорцияРезультата.ОбластьПоиска = МассивМД;
	КонецЕсли;
	Если ПрименитьНечеткийПоиск = Истина Тогда
		мПорцияРезультата.ПорогНечеткости = Нечеткость;
	Иначе	
		мПорцияРезультата.ПорогНечеткости = 0;
	КонецЕсли;
	мПорцияРезультата.СтрокаПоиска = ПолеВводаПоиска;
	мПорцияРезультата.РазмерПорции = РазмерПорции;
	мПорцияРезультата.ПерваяЧасть();
	Колво = мПорцияРезультата.ПолноеКоличество();
	ЗаполнитьСписокНайденных();
	
КонецПроцедуры

Процедура ПолучитьТекстДатыИндекса()
	
	ИндексАктуален = ПолнотекстовыйПоиск.ИндексАктуален();
	ЭлементыФормы.НадписьДатаАктуальностиИндекса.Заголовок = "Дата актуальности индекса " + ПолнотекстовыйПоиск.ДатаАктуальности() + ", " 
		+ ?(ИндексАктуален, "актуален", "не актуален");
	Если ИндексАктуален Тогда
		ЭлементыФормы.НадписьДатаАктуальностиИндекса.ЦветТекста = Новый Цвет;
	Иначе
		ЭлементыФормы.НадписьДатаАктуальностиИндекса.ЦветТекста = WebЦвета.Красный;
	КонецЕсли; 
		
Конецпроцедуры

Процедура ЗаполнитьСписокНайденных()
	
	Если мПорцияРезультата.ПолноеКоличество() = 0 Тогда
		ЭлементыФормы.Найдено.Значение = "Не найдено";
		ЭлементыФормы.КнопкаВперед.Видимость = Ложь;
		ЭлементыФормы.КнопкаНазад.Видимость = Ложь;
		ЭлементыФормы.HTMLОтображение.УстановитьТекст("");
		Возврат;
	КонецЕсли;
	Если ЭлементыФормы.ПолеВводаПоиска.СписокВыбора.НайтиПоЗначению(мПорцияРезультата.СтрокаПоиска) = Неопределено Тогда
		ЭлементыФормы.ПолеВводаПоиска.СписокВыбора.Вставить(0, мПорцияРезультата.СтрокаПоиска);
		ирОбщий.СохранитьЗначениеЛкс("Строки для полнотекстового поиска", ЭлементыФормы.ПолеВводаПоиска.СписокВыбора.ВыгрузитьЗначения());
	КонецЕсли;
	ЭлементыФормы.КнопкаВперед.Видимость = Истина;
	ЭлементыФормы.КнопкаНазад.Видимость = Истина;
	ЭлементыФормы.Найдено.Значение = 
		"Показаны " + 
		Строка(мПорцияРезультата.НачальнаяПозиция() + 1) + " - " +  
		Строка(мПорцияРезультата.НачальнаяПозиция() + мПорцияРезультата.Количество()) + 
		" из " + мПорцияРезультата.ПолноеКоличество();
	
	СтрHTML = мПорцияРезультата.ПолучитьОтображение(ВидОтображенияПолнотекстовогоПоиска.HTMLТекст);
	СтрHTML = СтрЗаменить(СтрHTML, "<td>", "<td><font face=""MS Sans Serif"" size=""1"">");
	СтрHTML = СтрЗаменить(СтрHTML, "<td valign=top width=1>", "<td valign=top width=1><font face=""MS Sans Serif"" size=""1"">");
	СтрHTML = СтрЗаменить(СтрHTML, "<body>", "<body><body topmargin=0 leftmargin=0>");
	СтрHTML = СтрЗаменить(СтрHTML, "</td>", "</font></td>");
	СтрHTML = СтрЗаменить(СтрHTML, "<b>", "");
	СтрHTML = СтрЗаменить(СтрHTML, "</b>", "");
	СтрHTML = СтрЗаменить(СтрHTML, "FFFF00", "FFFFC8");  
	
	ЭлементыФормы.HTMLОтображение.УстановитьТекст(СтрHTML);
	ТаблицаПорции.Очистить();
	Для Каждого ЭлементПорции Из мПорцияРезультата Цикл
		#Если Сервер И Не Сервер Тогда
			ЭлементПорции = ПолнотекстовыйПоиск.СоздатьСписок()[0];
		#КонецЕсли
		СтрокаПорции = ТаблицаПорции.Добавить();
		СтрокаПорции.Объект = ЭлементПорции.Значение;
		СтрокаПорции.Метаданные = ЭлементПорции.Метаданные.ПолноеИмя();
		ПредставлениеПоля = СокрЛП(ирОбщий.ПервыйФрагментЛкс(ЭлементПорции.Описание, ":"));
		ПредставлениеЗначения = СокрЛП(Сред(ЭлементПорции.Описание, СтрДлина(ПредставлениеПоля + ": ") + 1));
		СтрокаПорции.Описание = ПредставлениеЗначения;
		СтрокаПорции.Поле = ПредставлениеПоля;
	КонецЦикла;
	Если мПорцияРезультата.СлишкомМногоРезультатов() Тогда
		Предупреждение("Слишком много результатов, уточните запрос.");
	КонецЕсли;
	ДоступностьКнопок();
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	Массив = ирОбщий.ВосстановитьЗначениеЛкс("Строки для полнотекстового поиска");
	Если Массив <> Неопределено Тогда
		ЭлементыФормы.ПолеВводаПоиска.СписокВыбора.ЗагрузитьЗначения(Массив);
	КонецЕсли;	
	Если ирОбщий.РежимСовместимостиМеньше8_3_4Лкс() Тогда
		ИмяСвойстваНомера = "nameProp";
	Иначе
		ИмяСвойстваНомера = "sel_num";
	КонецЕсли; 
	ЭлементыФОрмы.СписокМетаданных.Доступность = Ложь;
	ЭлементыФормы.ОбновитьИндекс.Доступность = ПравоДоступа("Администрирование",Метаданные);
	ПолучитьТекстДатыИндекса();
	ИзменитьСвернутостьПанельНастроек(Ложь);
	ирОбщий.УстановитьПрикреплениеФормыВУправляемомПриложенииЛкс(Этаформа);
	
КонецПроцедуры

Процедура ДоступностьКнопок()
	
	Если (мПорцияРезультата.ПолноеКоличество() - мПорцияРезультата.НачальнаяПозиция()) > мПорцияРезультата.Количество() ИЛИ (мПорцияРезультата.НачальнаяПозиция() > 0) Тогда
		Видимость = Истина;
	Иначе	
		Видимость = Ложь;
	КонецЕсли;	
		
	ЭлементыФормы.КнопкаВперед.Видимость = Видимость;
	ЭлементыФормы.КнопкаНазад.Видимость = Видимость;

	ЭлементыФормы.КнопкаВперед.Доступность = (мПорцияРезультата.ПолноеКоличество() - мПорцияРезультата.НачальнаяПозиция()) > мПорцияРезультата.Количество();
	ЭлементыФормы.КнопкаНазад.Доступность = (мПорцияРезультата.НачальнаяПозиция() > 0);
	
КонецПроцедуры

Процедура КнопкаВпередНажатие(Элемент)
	
	мПорцияРезультата.СледующаяЧасть();
	ЗаполнитьСписокНайденных();
	
КонецПроцедуры

Процедура КнопкаНазадНажатие(Элемент)
	
	мПорцияРезультата.ПредыдущаяЧасть();
	ЗаполнитьСписокНайденных();
	
КонецПроцедуры

Процедура ПоказыватьОписанияПриИзменении(Элемент)
	
	мПорцияРезультата.ПолучатьОписание = ПоказыватьОписания;
	
КонецПроцедуры

Процедура HTMLОтображениеonclick(Элемент, pEvtObj)
	
	htmlElement = pEvtObj.srcElement;
	Если (htmlElement.id = "FullTextSearchListItem") Тогда
		Если ирОбщий.РежимСовместимостиМеньше8_3_4Лкс() Тогда
			номерВСписке = Число(htmlElement[ИмяСвойстваНомера]);
		Иначе
			номерВСписке = Число(htmlElement.attributes[ИмяСвойстваНомера].value);
		КонецЕсли; 
		ВыбраннаяСтрока = мПорцияРезультата[номерВСписке];
		Если ОткрыватьВРедактореОбъектаБД Тогда
			РедакторОбъектаБД = ирОбщий.ОткрытьСсылкуВРедактореОбъектаБДЛкс(ВыбраннаяСтрока.Значение);
			ПредставлениеПоля = СокрЛП(ирОбщий.ПервыйФрагментЛкс(ВыбраннаяСтрока.Описание, ":"));
			ПредставлениеЗначения = СокрЛП(Сред(ВыбраннаяСтрока.Описание, СтрДлина(ПредставлениеПоля + ": ") + 1));
			РедакторОбъектаБД.НайтиПоказатьПолеПоПредставлению(ПредставлениеПоля, ПредставлениеЗначения);
		Иначе
			ОткрытьЗначение(ВыбраннаяСтрока.Значение);
		КонецЕсли; 
		pEvtObj.returnValue = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура КнопкаДобавитьМетаданныеНажатие(Элемент)
	
	Форма = ирОбщий.ПолучитьФормуВыбораОбъектаМетаданныхЛкс(,, СписокМетаданных.ВыгрузитьЗначения(), Истина, Истина, , Истина,,,,,,, Истина);
	РезультатВыбора = Форма.ОткрытьМодально();
	Если РезультатВыбора <> Неопределено Тогда
		СписокМетаданных.Очистить();
		Для Каждого ПолноеИмяОбъекта Из РезультатВыбора Цикл
			ОграничитьОбъектыПоиска = Истина;
			ЭлементыФОрмы.СписокМетаданных.Доступность = Истина;
			СписокМетаданных.Добавить(ПолноеИмяОбъекта);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОграничитьОбъектыПоискаПриИзменении(Элемент)
	
	Если ОграничитьОбъектыПоиска = Истина Тогда
		ЭлементыФОрмы.СписокМетаданных.Доступность = Истина;
	Иначе	
		ЭлементыФОрмы.СписокМетаданных.Доступность = Ложь;
	КонецЕсли;	
	
КонецПроцедуры

Процедура ПрименитьНечеткийПоискПриИзменении(Элемент)
	
	Если ПрименитьНечеткийПоиск = Истина Тогда
		ЭлементыФормы.Нечеткость.Доступность = Истина;
	Иначе	
		ЭлементыФормы.Нечеткость.Доступность = Ложь;
	КонецЕсли;	
	
КонецПроцедуры

Процедура ДействияФормыПоказатьНастройки(Кнопка)
	
	ИзменитьСвернутостьПанельНастроек(Не ЭлементыФормы.ДействияФормы.Кнопки.ПоказатьНастройки.Пометка);

КонецПроцедуры

Процедура ИзменитьСвернутостьПанельНастроек(Видимость = Истина)
	
	ЭлементыФормы.ДействияФормы.Кнопки.ПоказатьНастройки.Пометка = Видимость;
	ирОбщий.ИзменитьСвернутостьЛкс(ЭтаФорма, Видимость, ЭлементыФормы.ПанельНастройки, ЭтаФорма.ЭлементыФормы.РазделительГоризонтальный, ЭтаФорма.Панель, "верх");

КонецПроцедуры

Процедура КоманднаяПанельПоиск(Кнопка)
	НачатьПоиск();
КонецПроцедуры

Процедура КлсУниверсальнаяКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ПриПовторномОткрытии(СтандартнаяОбработка)
	ТекущийЭлемент = ЭлементыФормы.ПолеВводаПоиска;
КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	Если Не ПроверитьДоступностьПоиска() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	мПорцияРезультата = ПолнотекстовыйПоиск.СоздатьСписок("", РазмерПорции);
	мПорцияРезультата.ПолучатьОписание = ПоказыватьОписания;
КонецПроцедуры

Процедура ОбновитьИндексНажатие(Элемент)
	ПолнотекстовыйПоиск.ОбновитьИндекс(Истина,Ложь);
	ПолучитьТекстДатыИндекса();
КонецПроцедуры

Функция ПроверитьДоступностьПоиска()
	Если ПолнотекстовыйПоиск.ПолучитьРежимПолнотекстовогоПоиска() = РежимПолнотекстовогоПоиска.Разрешить Тогда
		// поиск разрешен
		Возврат Истина;
	КонецЕсли;
	
	СтрОшибки = "В текущей информационной базе отключена возможность полнотекстового поиска." + Символы.ПС;
	
	// Проверим, есть ли права на включение поиска
	Если Не ПравоДоступа("Администрирование", Метаданные) Тогда
		Предупреждение(СтрОшибки + "Для включения поиска обратитесь к администратору.");
		Возврат Ложь;
	КонецЕсли;
	
	
	// Проверим, работают ли другие пользователи в базе
	МассивСоединений = ПолучитьСоединенияИнформационнойБазы();
	ВсегоСоединений  = ?(МассивСоединений = Неопределено, 0, МассивСоединений.Количество());
	Если  ВсегоСоединений <> 1 Тогда
		// работают другие пользователи
		
		Сообщение = СтрОшибки + "Для включения полнотекстового поиска попросите пользователей выйти из программы и повторно запустите поиск.
		|
		|Текущие соединения:
		|";
		
		Для каждого Соединение Из МассивСоединений Цикл
			Если Не Соединение.НомерСоединения = НомерСоединенияИнформационнойБазы() Тогда
				Сообщение = Сообщение + Символы.ПС + " - " + Соединение;
			КонецЕсли;
		КонецЦикла; 
		
		Предупреждение(Сообщение);
		Возврат Ложь;
	КонецЕсли;
	
	// Спросим, нужно ли включать поиск
	СтрВопроса = СтрОшибки + "Включить полнотекстовый поиск?";
	Если Вопрос(СтрВопроса, РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет  Тогда
		Возврат Ложь;
	КонецЕсли;
		
	// Пробуем включить полнотекстовый поиск
	МасОшибок = Новый Массив;
	Попытка
		ПолнотекстовыйПоиск.УстановитьРежимПолнотекстовогоПоиска(РежимПолнотекстовогоПоиска.Разрешить);
	Исключение
		Предупреждение("Ошибка при включении полнотекстового поиска:
		|" + ОписаниеОшибки());
		Возврат Ложь;
	КонецПопытки;	
	
	// Если были ошибки, то выведем предупреждения
	Для Каждого Ошибка Из МасОшибок Цикл
		Предупреждение(Ошибка);
	КонецЦикла;
	
	Если МасОшибок.Количество() <> 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// Проверим, нужно ли индексировать
	Если Не ПолнотекстовыйПоиск.ИндексАктуален() Тогда
		СтрВопроса = "Индекс не актуален. Обновление индекса может занять длительное время.
		|Индекс можно обновить позднее в форме поиска данных.
		|Обновить индекс прямо сейчас?";
		Если Вопрос(СтрВопроса, РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
			Попытка
				ПолнотекстовыйПоиск.ОбновитьИндекс(Истина, Ложь);
			Исключение
				Предупреждение("Ошибка при обновлении индекса:
				|" + ОписаниеОшибки());
			КонецПопытки;
		КонецЕсли;
	КонецЕсли;

	Возврат Истина;
КонецФункции

Процедура ПолеВводаПоискаПриИзменении(Элемент)
	
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
	НастроитьЭлементыФормы();

КонецПроцедуры

Процедура НастроитьЭлементыФормы()
	
	ирОбщий.ОбновитьТекстПослеМаркераВСтрокеЛкс(ЭтаФорма.Заголовок,, ПолеВводаПоиска, ": ");
	
КонецПроцедуры

Процедура КоманднаяПанельОткрыватьВРедактореОбъектаБД(Кнопка)
	
	ЭтаФорма.ОткрыватьВРедактореОбъектаБД = Не ОткрыватьВРедактореОбъектаБД;
	Кнопка.Пометка = ОткрыватьВРедактореОбъектаБД;
	
КонецПроцедуры

Процедура КоманднаяПанельОПодсистеме(Кнопка)
	
	ирОбщий.ОткрытьСправкуПоПодсистемеЛкс(ЭтотОбъект);
	
КонецПроцедуры

Процедура КоманднаяПанельКонсольОбработки(Кнопка)
	
	Если ЭлементыФормы.ПанельРезультат.ТекущаяСтраница = ЭлементыФормы.ПанельРезультат.Страницы.HtmlПорции Тогда
		ШаблонПоиска = ИмяСвойстваНомера + "=""(\d+)""";
		МассивСсылок = Новый Массив;
		ВыделенныйТекстHtml = ирОбщий.ПолучитьHtmlТекстВыделенияЛкс(ЭлементыФормы.HTMLОтображение.Документ);
		Вхождения = ирОбщий.НайтиРегулярноеВыражениеЛкс(ВыделенныйТекстHtml, ШаблонПоиска, "Индекс");
		#Если Сервер И Не Сервер Тогда
		    Вхождения = Обработки.ирПлатформа.Создать().ВхожденияРегулярногоВыражения;
		#КонецЕсли
		Для Каждого Вхождение Из Вхождения Цикл
			НомерВСписке = Число(Вхождение.Индекс);
			ВыбраннаяСтрока = мПорцияРезультата[НомерВСписке];
			МассивСсылок.Добавить(ВыбраннаяСтрока.Значение);
		КонецЦикла; 
		ирОбщий.ОткрытьМассивОбъектовВПодбореИОбработкеОбъектовЛкс(МассивСсылок);
	Иначе
		ирОбщий.ОткрытьОбъектыИзВыделенныхЯчеекВПодбореИОбработкеОбъектовЛкс(ЭлементыФормы.ТаблицаПорции, "Объект");
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ирОбщий.ФормаОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 
	
КонецПроцедуры

Процедура КоманднаяПанельФормыОткрытьИТС(Кнопка)
	
	ирОбщий.ОткрытьСсылкуИТСЛкс("https://its.1c.ru/db/v?doc#bookmark:dev:TI000000799");
	ирОбщий.ОткрытьСсылкуИТСЛкс("https://its.1c.ru/db/v?doc#bookmark:dev:TI000001240");
	ирОбщий.ОткрытьСсылкуИТСЛкс("https://its.1c.ru/db/v?doc/bookmark/utx/TI000000308/%EF%EE%EB%ED%EE%F2%E5%EA%F1%F2%EE%E2%FB%E9%20%EF%EE%E8%F1%EA");
	
КонецПроцедуры

Процедура ПолеВводаПоискаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, ЭтаФорма);
	
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если Не Отказ Тогда
		ИзменитьСвернутостьПанельНастроек(Истина);
	КонецЕсли; 

КонецПроцедуры

Процедура ТаблицаПорцииВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если ОткрыватьВРедактореОбъектаБД Тогда
		РедакторОбъектаБД = ирОбщий.ОткрытьСсылкуВРедактореОбъектаБДЛкс(ВыбраннаяСтрока.Объект);
		РедакторОбъектаБД.НайтиПоказатьПолеПоПредставлению(ВыбраннаяСтрока.Поле, ВыбраннаяСтрока.Описание);
	Иначе
		ОткрытьЗначение(ВыбраннаяСтрока.Объект);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДействияФормыСсылкиОтобратьПоТипам(Кнопка)
	
	ирОбщий.ИзменитьОтборКлиентаПоМетаданнымЛкс(ЭлементыФормы.ТаблицаПорции,, Истина);
	
КонецПроцедуры

Процедура ДействияФормыМенеджерТабличногоПоля(Кнопка)
	
	ирОбщий.ОткрытьМенеджерТабличногоПоляЛкс(ЭлементыФормы.ТаблицаПорции, ЭтаФорма);
	
КонецПроцедуры

Процедура ДействияФормыСтруктураФормы(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруФормыЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ДействияФормыНовоеОкно(Кнопка)
	
	ирОбщий.ОткрытьНовоеОкноОбработкиЛкс(ЭтотОбъект);
	
КонецПроцедуры

Процедура КП_ТаблицаПорцииСсылкиОтборБезЗначенияВТекущейКолонке(Кнопка)
	
	ирОбщий.ТабличноеПоле_ОтборБезЗначенияВТекущейКолонке_КнопкаЛкс(ЭлементыФормы.ТаблицаПорции);
	
КонецПроцедуры

Процедура КП_ТаблицаПорцииРазличныеЗначенияКолонки(Кнопка)
	
	ирОбщий.ОткрытьРазличныеЗначенияКолонкиЛкс(ЭлементыФормы.ТаблицаПорции);
	
КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	ирОбщий.ОбновитьЗаголовкиСтраницПанелейЛкс(ЭтаФорма);

КонецПроцедуры

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

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирПоискДанных.Форма.Форма");
РазмерПорции = 20;
Нечеткость = 25;
ПоказыватьОписания = Истина;
ЭлементыФормы.Нечеткость.СписокВыбора.Добавить(25);
ЭлементыФормы.Нечеткость.СписокВыбора.Добавить(50);
ЭлементыФормы.Нечеткость.СписокВыбора.Добавить(75);
ЭлементыФормы.РазмерПорции.СписокВыбора.Добавить(20);
ЭлементыФормы.РазмерПорции.СписокВыбора.Добавить(60);
ЭлементыФормы.РазмерПорции.СписокВыбора.Добавить(200);
ЭлементыФормы.РазмерПорции.СписокВыбора.Добавить(600);
ЭлементыФормы.РазмерПорции.СписокВыбора.Добавить(2000);