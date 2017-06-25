﻿//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирПривилегированный Экспорт;

Перем мМенеджеры Экспорт;
Перем мИмяКолонкиПометки Экспорт;
Перем мИмяКолонкиРезультатаОбработки Экспорт;
Перем мИмяКолонкиПолногоИмениТаблицы Экспорт;
Перем мЗапрос Экспорт;
Перем мПлатформа Экспорт;
Перем мРезультатЗапроса Экспорт;
Перем мСхемаКолонок Экспорт;
Перем мВопросНаОбновлениеСтрокДляОбработкиЗадавался Экспорт;
Перем мСоставПланаОбмена;
Перем мИмяНастройкиПоУмолчанию Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ

// Разбирает строку выделяя из нее префикс и числовую часть
//
// Параметры:
//  Стр            - Строка. Разбираемая строка
//  ЧисловаяЧасть  - Число. Переменная в которую возвратится числовая часть строки
//  Режим          - Строка. Если "Число", то возвратит числовую часть иначе - префикс
//
// Возвращаемое значение:
//  Префикс строки
//              
Функция вПолучитьПрефиксЧислоНомера(Знач Стр, ЧисловаяЧасть="", Режим="") Экспорт
    
	Стр		=	СокрЛП(Стр);
	Префикс	=	Стр;
	Длина	=	СтрДлина(Стр);
	
	Для Сч = 1 По Длина Цикл
		Попытка
			ЧисловаяЧасть = Число(Стр);
		Исключение
		    Стр = Прав(Стр, Длина - Сч);
			Продолжить;
		КонецПопытки; 
		
	    Если (ЧисловаяЧасть > 0) И (СтрДлина(Формат(ЧисловаяЧасть, "ЧГ=0")) = Длина - Сч + 1) Тогда 
			Префикс	=	Лев(Префикс, Сч - 1);
			
			Пока Прав(Префикс, 1) = "0" Цикл
			    Префикс = Лев(Префикс, СтрДлина(Префикс)-1);
			КонецЦикла;
			
			Прервать;
	    Иначе
			Стр = Прав(Стр, Длина - Сч);
		КонецЕсли;
		
		Если ЧисловаяЧасть < 0 Тогда	ЧисловаяЧасть = - ЧисловаяЧасть		КонецЕсли;
			
	КонецЦикла;

	Если Режим = "Число" Тогда
	    Возврат(ЧисловаяЧасть);
	Иначе
		Возврат(Префикс);
	КонецЕсли;

КонецФункции // вПолучитьПрефиксЧислоНомера()

// Приводит номер (код) к требуемой длине. При этом выделяется префикс
// и числовая часть номера, остальное пространство между префиксом и
// номером заполняется нулями
//
// Параметры:
//  Стр            - Преобразовываемая строка
//  Длина          - Требуемая длина строки
//
// Возвращаемое значение:
//  Строка - код или номер, приведенная к требуемой длине
// 
Функция вПривестиНомерКДлине(Знач Стр, Длина) Экспорт
                            
	Стр			    =	СокрЛП(Стр);
		
	ЧисловаяЧасть	=	"";
	Результат		=	вПолучитьПрефиксЧислоНомера(Стр, ЧисловаяЧасть);
	Пока Длина - СтрДлина(Результат) - СтрДлина(Формат(ЧисловаяЧасть, "ЧГ=0")) > 0 Цикл
		Результат	=	Результат + "0";
	КонецЦикла;
	Результат	=	Результат + Формат(ЧисловаяЧасть, "ЧГ=0");
	
	Возврат(Результат);
	
КонецФункции // вПривестиНомерКДлине()

// Добавляет к префиксу номера или кода подстроку
//
// Параметры:
//  Стр            - Строка. Номер или код
//  Добавок        - Добаляемая к префиксу подстрока
//  Длина          - Требуемая результрирубщая длина строки
//  Режим          - "Слева" - подстрока добавляется слева к префиксу, иначе - справа
//
// Возвращаемое значение:
//  Строка - номер или код, к префиксу которого добавлена указанная подстрока
//                                                                                                     
Функция вДобавитьКПрефиксу(Знач Стр, Добавок="", Длина="", Режим="Слева") Экспорт

	Стр = СокрЛП(Стр);
	
	Если ПустаяСтрока(Длина) Тогда
		Длина = СтрДлина(Стр);
	КонецЕсли;
	
	ЧисловаяЧасть	=	"";
	Префикс			=	вПолучитьПрефиксЧислоНомера(Стр, ЧисловаяЧасть);
	Если Режим="Слева" Тогда
		Результат	=	СокрЛП(Добавок) + Префикс;
	Иначе
		Результат	=	Префикс + СокрЛП(Добавок);
	КонецЕсли;

	Пока Длина - СтрДлина(Результат) - СтрДлина(Формат(ЧисловаяЧасть, "ЧГ=0")) > 0 Цикл
	    Результат	=	Результат + "0";
	КонецЦикла;
	Результат	=	Результат + Формат(ЧисловаяЧасть, "ЧГ=0");
	
	Возврат(Результат);
	
КонецФункции // вДобавитьКПрефиксу()

// Дополняет строку указанным символом до указанной длины
//
// Параметры: 
//  Стр            - Дополняемая строка
//  Длина          - Требуемая длина результирующей строки
//  Чем            - Символ, которым дополняется строка
//
// Возвращаемое значение:
//  Строка дополненная указанным символом до указанной длины
//
Функция вДополнитьСтрокуСимволами(Стр="", Длина, Чем=" ") Экспорт
	Результат = СокрЛП(Стр);
	Пока Длина - СтрДлина(Результат) > 0 Цикл
		Результат	=	Результат + Чем;
	КонецЦикла;
	Возврат(Результат);
КонецФункции // вДополнитьСтрокуСимволами() 

#Если Клиент Тогда
	
// Выполняет обработку объектов.
//
// Параметры:
//  Нет.
//
Функция вВыполнитьГрупповуюОбработку(ФормаОбработки) Экспорт

	ТранзакцииРазрешены = Истина;
	Если Истина
		И ЗаписьНаСервере 
		И ирКэш.ЛиПортативныйРежимЛкс()
		И Не ирПортативный.ЛиСерверныйМодульДоступенЛкс(Ложь)
		И ирПортативный.ЭмуляцияЗаписиНаСервере
	Тогда
		Сообщить("В режиме эмуляции записи на сервере транзакции не поддерживаются");
		ТранзакцииРазрешены = Ложь;
		ОбщаяТранзакция = Ложь;
	КонецЕсли; 
	ПараметрыОбработки = Новый Структура;
	ФормаОбработки.ПередОбработкойВсех(ПараметрыОбработки);
	НайденныеОбъекты.ЗаполнитьЗначения("", мИмяКолонкиРезультатаОбработки);
	Если ОбщаяТранзакция Тогда
		НачатьТранзакцию();
	КонецЕсли;
	Попытка
		мСоставПланаОбмена = Неопределено;
		Если ЗначениеЗаполнено(УзелОтбораОбъектов) Тогда
			мСоставПланаОбмена = УзелОтбораОбъектов.Метаданные().Состав;
		КонецЕсли; 
		ТипТаблицы = ирОбщий.ПолучитьТипТаблицыБДЛкс(?(МноготабличнаяВыборка, ОбластьПоиска[0], ОбластьПоиска));
		СтруктураКлючаОбъекта = ирОбщий.ПолучитьСтруктуруКлючаТаблицыБДЛкс(?(МноготабличнаяВыборка, ОбластьПоиска[0], ОбластьПоиска), Ложь);
		СтруктураКлючаПолная = ирОбщий.ПолучитьСтруктуруКлючаТаблицыБДЛкс(?(МноготабличнаяВыборка, ОбластьПоиска[0], ОбластьПоиска), Истина);
		Если МноготабличнаяВыборка Тогда
			СтруктураКлючаОбъекта.Вставить(мИмяКолонкиПолногоИмениТаблицы);
			СтруктураКлючаПолная.Вставить(мИмяКолонкиПолногоИмениТаблицы);
		КонецЕсли;
		СтрокаКлюча = "";
		Для Каждого КлючИЗначение Из СтруктураКлючаОбъекта Цикл
			Если СтрокаКлюча <> "" Тогда
				СтрокаКлюча  = СтрокаКлюча + ", ";
			КонецЕсли; 
			СтрокаКлюча = СтрокаКлюча + КлючИЗначение.Ключ;
		КонецЦикла;
		Если ДинамическаяВыборка Тогда
			Если СтруктураКлючаОбъекта.Количество() > 1 Тогда
				Сообщить("Динамическая выборка по сложному ключу не поддерживается. Используйте статическую выборку.", СтатусСообщения.Внимание);
				Возврат 0;
			КонецЕсли; 
			Если СтруктураКлючаПолная.Количество() = СтруктураКлючаОбъекта.Количество() Тогда
				ВыборкаКлючей = мРезультатЗапроса.Выбрать();
				КоличествоОбъектов = ВыборкаКлючей.Количество();
				КоличествоСтрок = КоличествоОбъектов;
				Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(КоличествоОбъектов);
				Пока ВыборкаКлючей.Следующий() Цикл
					ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
					СтрокиДляОбработки = НайденныеОбъекты.СкопироватьКолонки();
					ЗаполнитьЗначенияСвойств(СтрокиДляОбработки.Добавить(), ВыборкаКлючей);
					РезультатОбработки = ОбработатьЭлементыОбъекта(ФормаОбработки, ТипТаблицы, СтруктураКлючаОбъекта, СтруктураКлючаПолная, ВыборкаКлючей, СтрокиДляОбработки, ПараметрыОбработки,
						ТранзакцииРазрешены, Индикатор.Счетчик = 1, Индикатор.Счетчик = КоличествоОбъектов);
				КонецЦикла;
			Иначе
				ЗапросКлючей = Новый Запрос();
				Фрагменты = ирОбщий.ПолучитьМассивИзСтрокиСРазделителемЛкс(мЗапрос.Текст, "//Секция_Упорядочить");
				ИсключаемоеПоле = Неопределено;
				Если СтруктураКлючаПолная <> СтруктураКлючаОбъекта Тогда
					ИсключаемоеПоле = "НомерСтроки";
				КонецЕсли; 
				СтрокаПорядка = ирОбщий.ПолучитьСтрокуПорядкаКомпоновкиЛкс(Компоновщик.Настройки.Порядок, ИсключаемоеПоле);
				СтрокаПолейПорядка = "";
				Для Каждого Колонка Из мРезультатЗапроса.Колонки Цикл
					Если Ложь
						Или СтруктураКлючаОбъекта.Свойство(Колонка.Имя) 
						Или ирОбщий.СтрокиРавныЛкс(ИсключаемоеПоле, Колонка.Имя)
					Тогда
						Продолжить;
					КонецЕсли; 
					СтрокаПолейПорядка = ", " + Колонка.Имя;
				КонецЦикла;
				Если ЗначениеЗаполнено(СтрокаПорядка) Тогда
					СтрокаПорядка = " УПОРЯДОЧИТЬ ПО " + СтрокаПорядка;
				КонецЕсли; 
				Если Ложь
					Или Не БезАвтоупорядочивания 
					//Или ЗначениеЗаполнено(СтрокаПорядка)
				Тогда
					СтрокаПорядка = СтрокаПорядка + "
					|АВТОУПОРЯДОЧИВАНИЕ";
				КонецЕсли; 
				ТекстЗапроса = "ВЫБРАТЬ РАЗЛИЧНЫЕ " + СтрокаКлюча + СтрокаПолейПорядка + "
				| ИЗ (" + Фрагменты[0] + ") КАК Т " + СтрокаПорядка; // Доделать имя таблицы (Т.) у полей
				ЗапросКлючей.Текст = ТекстЗапроса;
				ирОбщий.СкопироватьУниверсальнуюКоллекциюЛкс(мЗапрос.Параметры, ЗапросКлючей.Параметры);
				РезультатЗапроса = ЗапросКлючей.Выполнить();
				#Если Сервер И Не Сервер Тогда
					_Запрос = Новый Запрос;
				    ВыборкаЗапроса = _Запрос.Выполнить().Выбрать();
				#КонецЕсли
				ВыборкаКлючей = РезультатЗапроса.Выбрать();
				//Построитель = Новый ПостроительЗапроса;
				//Построитель.ИсточникДанных = Новый ОписаниеИсточникаДанных(мРезультатЗапроса);
				//Для Каждого КлючИЗначение Из СтруктураКлючаОбъекта Цикл
				//	Построитель.ИсточникДанных.Колонки.Ссылка.Измерение = Истина;
				//КонецЦикла; 
				//Построитель.ЗаполнитьНастройки();
				//Для Каждого КлючИЗначение Из СтруктураКлючаОбъекта Цикл
				//	Построитель.Измерения.Добавить(КлючИЗначение.Ключ);
				//КонецЦикла; 
				//ВыборкаКлючей = Построитель.Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				ПостроительЗапросаДеталей = Новый ПостроительЗапроса();
				ПостроительЗапросаДеталей.Текст = мЗапрос.Текст;
				ПостроительЗапросаДеталей.ЗаполнитьНастройки();
				Для Каждого КлючИЗначение Из СтруктураКлючаОбъекта Цикл
					ЭлементОтбора = ПостроительЗапросаДеталей.Отбор.Добавить(КлючИЗначение.Ключ);
					ЭлементОтбора.Использование = Истина;
				КонецЦикла;
				КоличествоОбъектов = ВыборкаКлючей.Количество();
				КоличествоСтрок = 0;
				Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(КоличествоОбъектов, "Обработка объектов");
				ирОбщий.СкопироватьУниверсальнуюКоллекциюЛкс(мЗапрос.Параметры, ПостроительЗапросаДеталей.Параметры);
				Пока ВыборкаКлючей.Следующий() Цикл
					ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
					Для Каждого КлючИЗначение Из СтруктураКлючаОбъекта Цикл
						ПостроительЗапросаДеталей.Отбор[КлючИЗначение.Ключ].Значение = ВыборкаКлючей[КлючИЗначение.Ключ];
					КонецЦикла;
					ТаблицаРезультатаДеталей = ПостроительЗапросаДеталей.Результат.Выгрузить();
					СтрокиДляОбработки = НайденныеОбъекты.СкопироватьКолонки();
					ирОбщий.ЗагрузитьВТаблицуЗначенийЛкс(ТаблицаРезультатаДеталей, СтрокиДляОбработки);
					РезультатОбработки = ОбработатьЭлементыОбъекта(ФормаОбработки, ТипТаблицы, СтруктураКлючаОбъекта, СтруктураКлючаПолная, ВыборкаКлючей, СтрокиДляОбработки, ПараметрыОбработки,
						ТранзакцииРазрешены, Индикатор.Счетчик = 1, Индикатор.Счетчик = КоличествоОбъектов);
					КоличествоСтрок = КоличествоСтрок + СтрокиДляОбработки.Количество();
				КонецЦикла;
			КонецЕсли; 
		Иначе
			// Порядок обработки строк таблицы БД сохраняется только в случае, если на каждый объект БД приходится только одна строка
			КлючиДляОбработки = НайденныеОбъекты.Скопировать(Новый Структура(мИмяКолонкиПометки, Истина));
			КоличествоСтрок = КлючиДляОбработки.Количество();
			КлючиДляОбработки.Колонки.Добавить("_ПорядокСтроки");
			Для Индекс = 0 По КлючиДляОбработки.Количество() - 1 Цикл
				СтрокаТаблицы  = КлючиДляОбработки[Индекс];
				СтрокаТаблицы._ПорядокСтроки = Индекс;
			КонецЦикла;
			КлючиДляОбработки.Свернуть(СтрокаКлюча, "_ПорядокСтроки");
			КлючиДляОбработки.Сортировать("_ПорядокСтроки");
			КоличествоОбъектов = КлючиДляОбработки.Количество();
			Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(КоличествоОбъектов, "Обработка объектов");
			СтруктураКлючаОбъекта.Вставить(мИмяКолонкиПометки, Истина);
			
			СтрокаИндекса = СтрокаКлюча;
			СтрокаИндекса = СтрокаИндекса + ", " + мИмяКолонкиПометки;
			Если МноготабличнаяВыборка Тогда
				СтрокаИндекса = СтрокаИндекса + ", "+ мИмяКолонкиПолногоИмениТаблицы;
			КонецЕсли;
			Индекс = "";
			Для Каждого Индекс Из НайденныеОбъекты.Индексы Цикл
				Если "" + Индекс = СтрокаИндекса Тогда
					Прервать;
				КонецЕсли; 
			КонецЦикла;
			Если Индекс <> СтрокаИндекса Тогда
				НайденныеОбъекты.Индексы.Добавить(СтрокаИндекса);
			КонецЕсли; 
			
			ПроверитьДобавитьИндексВНайденныеОбъекты();
			Для Индекс = 0 По КоличествоОбъектов - 1 Цикл
				ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
				СтрокаКлюча = КлючиДляОбработки[Индекс];
				ЗаполнитьЗначенияСвойств(СтруктураКлючаОбъекта, СтрокаКлюча); 
				СтрокиДанных = НайденныеОбъекты.НайтиСтроки(СтруктураКлючаОбъекта);
				СтрокиДляОбработки = НайденныеОбъекты.Скопировать(СтрокиДанных);
				РезультатОбработки = ОбработатьЭлементыОбъекта(ФормаОбработки, ТипТаблицы, СтруктураКлючаОбъекта, СтруктураКлючаПолная, СтрокаКлюча, СтрокиДляОбработки, ПараметрыОбработки,
					ТранзакцииРазрешены, Индикатор.Счетчик = 1, Индикатор.Счетчик = КоличествоОбъектов);
				Для Каждого СтрокаДанных Из СтрокиДанных Цикл
					СтрокаДанных[мИмяКолонкиРезультатаОбработки] = РезультатОбработки;
				КонецЦикла; 
			КонецЦикла;
		КонецЕсли; 
		Если Истина
			И КоличествоСтрок > 0 
			И КоличествоСтрок <> КоличествоОбъектов 
		Тогда
			Сообщить("Обработано " + КоличествоСтрок + " строк");
		КонецЕсли; 
		ирОбщий.ОсвободитьИндикаторПроцессаЛкс(, Истина);
		Если ОбщаяТранзакция Тогда
			ЗафиксироватьТранзакцию();
		КонецЕсли;
	Исключение
		Если ОбщаяТранзакция Тогда
			ОтменитьТранзакцию();
		КонецЕсли; 
		ВызватьИсключение;
	КонецПопытки;
	ФормаОбработки.ПослеОбработкиВсех(ПараметрыОбработки);
	мВопросНаОбновлениеСтрокДляОбработкиЗадавался = Ложь;
	Возврат Индекс;

КонецФункции // вВыполнитьОбработку()

Процедура ПроверитьДобавитьИндексВНайденныеОбъекты() Экспорт 
	
	Если НайденныеОбъекты.Индексы.Количество() = 0 Тогда
		//СтрокаИндекса = "";
		//Для Каждого ЭлементКлюча Из мСтруктураКлюча Цикл
		//	СтрокаИндекса = СтрокаИндекса + "," + ЭлементКлюча.Ключ;
		//КонецЦикла;
		//СтрокаИндекса = Сред(СтрокаИндекса, 2);
		//НайденныеОбъекты.Индексы.Добавить(СтрокаИндекса); // Закомментирвано из-за высоких расходов времени
		//СтрокаИндексаОбъекта = мИмяКолонкиПометки;
		СтрокаИндексаОбъекта = "";
		СтруктураКлючаОбъекта = ирОбщий.ПолучитьСтруктуруКлючаТаблицыБДЛкс(?(МноготабличнаяВыборка, ОбластьПоиска[0].Значение, ОбластьПоиска), Ложь);
		Для Каждого КлючИЗначение Из СтруктураКлючаОбъекта Цикл
			СтрокаИндексаОбъекта = СтрокаИндексаОбъекта + "," + КлючИЗначение.Ключ;
		КонецЦикла;
		НайденныеОбъекты.Индексы.Добавить(СтрокаИндексаОбъекта); // Для регистров с большим числом измерений тут будут высокие, но оправданные расходы
	КонецЕсли;

КонецПроцедуры

// <Описание процедуры>
//
// Параметры:
//  СтрокиДляОбработки – ТаблицаЗначений – ;
//  <Параметр2>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>.
// 
Функция ОбработатьЭлементыОбъекта(ФормаОбработки, ТипТаблицы, СтруктураКлючаОбъекта, СтруктураКлючаПолная, СтрокаКлюча, СтрокиДляОбработки, ПараметрыОбработки,
	ТранзакцииРазрешены, ЭтоПервыйОбъектБД, ЭтоПоследнийОбъектБД)

	Если РежимОбходаДанных = "Строки" Тогда
		Если СтрокиДляОбработки.Колонки.Найти("НомерСтроки") <> Неопределено Тогда
			СтрокиДляОбработки.Сортировать("НомерСтроки Убыв");
		КонецЕсли; 
	КонецЕсли; 
	Если МноготабличнаяВыборка Тогда
		ПолноеИмяТаблицыСтроки = СтруктураКлючаОбъекта[мИмяКолонкиПолногоИмениТаблицы];
	Иначе
		ПолноеИмяТаблицыСтроки = ОбластьПоиска;
	КонецЕсли; 
	//ЭтоРегистрБухгалтерии = ирОбщий.ЛиПолноеИмяРегистраБухгалтерииЛкс(ПолноеИмяТаблицыСтроки);
	МассивФрагментов = ирОбщий.ПолучитьМассивИзСтрокиСРазделителемЛкс(ПолноеИмяТаблицыСтроки);
	ОбъектМДЗаписи = мПлатформа.ПолучитьОбъектМДПоПолномуИмени(МассивФрагментов[0] + "." + МассивФрагментов[1]);
	ПроводитьПроведенные = Истина
		И ПроводитьПроведенныеДокументыПриЗаписи
		И ирОбщий.ПолучитьПервыйФрагментЛкс(ПолноеИмяТаблицыСтроки) = "Документ"
		И ОбъектМДЗаписи.Проведение = Метаданные.СвойстваОбъектов.Проведение.Разрешить;
	КоллекцияСтрок = Неопределено;
	ЗагрузитьСтрокиПослеОбработки = Ложь;
	ЭлементыОбъекта = Новый Массив();
	ПрименятьПообъектныеТранзакции = ПообъектныеТранзакции;
	Если Не ТранзакцииРазрешены Тогда
		ПрименятьПообъектныеТранзакции = Ложь;
		ОбщаяТранзакция = Ложь;
	КонецЕсли; 
	Если ПрименятьПообъектныеТранзакции Тогда
		НачатьТранзакцию();
	КонецЕсли; 
	Попытка
		Если Ложь
			Или ирОбщий.ЛиКорневойТипСсылочногоОбъектаБДЛкс(ТипТаблицы)
			Или ирОбщий.ЛиКорневойТипЖурналаДокументовЛкс(ТипТаблицы)
			Или ТипТаблицы = "Внешняя"
		Тогда
			Если РежимОбходаДанных = "КлючиОбъектов" Тогда
				ОбъектДляОбработки = СтрокаКлюча.Ссылка
			Иначе
				ирОбщий.ЗаблокироватьСсылкуВТранзакцииЛкс(СтрокаКлюча.Ссылка, Истина);
				ОбъектДляОбработки = СтрокаКлюча.Ссылка.ПолучитьОбъект();
			КонецЕсли; 
			ЭлементыОбъекта.Добавить(ОбъектДляОбработки);
		ИначеЕсли ирОбщий.ЛиКорневойТипКонстантыЛкс(ТипТаблицы) Тогда
			ОбъектДляОбработки = Новый (СтрЗаменить(СтрокаКлюча[мИмяКолонкиПолногоИмениТаблицы], ".", "МенеджерЗначения."));
			Если РежимОбходаДанных = "КлючиОбъектов" Тогда
				//
			Иначе
				ирОбщий.ЗаблокироватьКонстантуЛкс(ОбъектДляОбработки, Истина);
				ОбъектДляОбработки.Прочитать();
			КонецЕсли; 
			ЭлементыОбъекта.Добавить(ОбъектДляОбработки);
		ИначеЕсли ирОбщий.ЛиКорневойТипПеречисленияЛкс(ТипТаблицы) Тогда
			ОбъектДляОбработки = СтрокаКлюча.Ссылка;
			ЭлементыОбъекта.Добавить(ОбъектДляОбработки);
		ИначеЕсли ирОбщий.ЛиТипВложеннойТаблицыБДЛкс(ТипТаблицы) Тогда
			ирОбщий.ЗаблокироватьСсылкуВТранзакцииЛкс(СтрокаКлюча.Ссылка, Истина);
			ОбъектДляОбработки = СтрокаКлюча.Ссылка.ПолучитьОбъект();
			Если РежимОбходаДанных = "Строки" Тогда
				ИмяТЧ = ирОбщий.ПолучитьМассивИзСтрокиСРазделителемЛкс(ирОбщий.ПолучитьИмяТаблицыИзМетаданныхЛкс(ПолноеИмяТаблицыСтроки))[2];
				КоллекцияСтрок = ОбъектДляОбработки[ИмяТЧ];
				Для Каждого СтрокаДляОбработки Из СтрокиДляОбработки Цикл
					Если КоллекцияСтрок.Количество() < СтрокаДляОбработки.НомерСтроки Тогда
						ВызватьИсключение "Строка таблицы с номером " + СтрокаДляОбработки.НомерСтроки + " не найдена в объекте БД";
					КонецЕсли; 
					ЭлементыОбъекта.Добавить(КоллекцияСтрок[СтрокаДляОбработки.НомерСтроки - 1]);
				КонецЦикла;
			Иначе
				ЭлементыОбъекта.Добавить(ОбъектДляОбработки);
			КонецЕсли; 
		ИначеЕсли Ложь
			Или ирОбщий.ЛиКорневойТипРегистраБДЛкс(ТипТаблицы) 
			Или ирОбщий.ЛиКорневойТипПоследовательностиЛкс(ТипТаблицы)
		Тогда
			//ОбъектДляЗаписи = Новый (СтрЗаменить(ПолноеИмяТаблицыСтроки, ".", "НаборЗаписей."));
			//Для Каждого ЭлементОтбора Из ОбъектДляЗаписи.Отбор Цикл
			//	ЭлементОтбора.Использование = Истина;
			//	ЭлементОтбора.ВидСравнения = ВидСравнения.Равно;
			//	//ЭлементОтбора.Значение = СтруктураКлючаОбъекта[ЭлементОтбора.Имя];
			//	ЭлементОтбора.Значение = СтрокаКлюча[ЭлементОтбора.Имя];
			//КонецЦикла;
			ОбъектДляОбработки = ирОбщий.ПолучитьНаборЗаписейПоКлючуЛкс(ПолноеИмяТаблицыСтроки, СтрокаКлюча);
			Если РежимОбходаДанных <> "КлючиОбъектов" Тогда
				ирОбщий.ЗаблокироватьНаборЗаписейПоОтборуЛкс(ОбъектДляОбработки, Истина);
				ОбъектДляОбработки.Прочитать();
			КонецЕсли;
			Если РежимОбходаДанных = "Строки" Тогда
				КоллекцияСтрок = ОбъектДляОбработки.Выгрузить();
				СтараяКоллекцияСтрок = КоллекцияСтрок.Скопировать();
				ЗагрузитьСтрокиПослеОбработки = Истина;
				Если СтруктураКлючаПолная.Свойство("НомерСтроки") Тогда
					ИмяКлюча = "НомерСтроки";
					КлючСтроки = Новый Структура(ИмяКлюча);
				ИначеЕсли СтруктураКлючаПолная.Свойство("Период") Тогда
					ИмяКлюча = "Период";
					КлючСтроки = Новый Структура(ИмяКлюча);
				Иначе
					КлючСтроки = Неопределено;
				КонецЕсли; 
				Для Каждого СтрокаДляОбработки Из СтрокиДляОбработки Цикл
					Если КлючСтроки = Неопределено Тогда
						Если КоллекцияСтрок.Количество() = 0 Тогда
							ВызватьИсключение "Строка таблицы не найдена в объекте БД. Возможно она уже была удалена.";
						КонецЕсли; 
						СтрокаОбъекта = КоллекцияСтрок[0];
					Иначе
						ЗаполнитьЗначенияСвойств(КлючСтроки, СтрокаДляОбработки); 
						НайденныеСтроки = КоллекцияСтрок.НайтиСтроки(КлючСтроки);
						Если НайденныеСтроки.Количество() = 0 Тогда
							ВызватьИсключение "Строка таблицы по ключу " + КлючСтроки[ИмяКлюча] + " не найдена в объекте БД";
						КонецЕсли;
						//Если ЭтоРегистрБухгалтерии Тогда
							СтрокаОбъекта = НайденныеСтроки[0];
						//Иначе
						//	ИндексСтрокиНабора = КоллекцияСтрок.Индекс(НайденныеСтроки[0]);
						//	СтрокаОбъекта = ОбъектДляЗаписи[ИндексСтрокиНабора];
						//КонецЕсли; 
					КонецЕсли; 
					ЭлементыОбъекта.Добавить(СтрокаОбъекта);
				КонецЦикла;
			Иначе
				КоллекцияСтрок = Неопределено;
				ЭлементыОбъекта.Добавить(ОбъектДляОбработки);
			КонецЕсли; 
		Иначе
			ВызватьИсключение "Неподдерживаемый тип таблицы """ + ТипТаблицы + """";
		КонецЕсли;
		Если РежимОбходаДанных <> "КлючиОбъектов" Тогда
			ирОбщий.УстановитьПараметрыЗаписиОбъектаЛкс(ОбъектДляОбработки, ОтключатьКонтрольЗаписи, БезАвторегистрацииИзменений);
		КонецЕсли; 
		Если ОбъектДляОбработки = Неопределено Тогда
			РезультатОбработки = "Пропущен";
			Если ВыводитьСообщения Тогда
				Сообщить("Пропущен удаленный """ + СтрокаКлюча.Ссылка + """");
			КонецЕсли;
		Иначе
			ТекстСообщенияОбОбработкеОбъекта = "Обработка объекта " + ирОбщий.ПолучитьXMLКлючОбъектаБДЛкс(ОбъектДляОбработки);
			Если ВыводитьСообщения Тогда
				Сообщить(ТекстСообщенияОбОбработкеОбъекта);
			КонецЕсли;
			СчетчикЭлемента = 0;
			КоличествоЭлементов = ЭлементыОбъекта.Количество();
			ПринудительнаяЗапись = Ложь;
			Для Каждого ЭлементОбъекта Из ЭлементыОбъекта Цикл
				СчетчикЭлемента = СчетчикЭлемента + 1;
				ПараметрыОбработки.Вставить("ЭтоПервыйОбъектБД", ЭтоПервыйОбъектБД);
				ПараметрыОбработки.Вставить("ЭтоПоследнийОбъектБД", ЭтоПоследнийОбъектБД);
				ПараметрыОбработки.Вставить("ЭтоПервыйЭлемент", СчетчикЭлемента = 1);
				ПараметрыОбработки.Вставить("ЭтоПоследнийЭлемент", СчетчикЭлемента = КоличествоЭлементов);
				ПараметрыОбработки.Вставить("ПринудительнаяЗапись", ПринудительнаяЗапись);
				ФормаОбработки.вОбработатьОбъект(ЭлементОбъекта, КоллекцияСтрок, ОбъектДляОбработки, ПараметрыОбработки);
				ПринудительнаяЗапись = ПараметрыОбработки.ПринудительнаяЗапись;
			КонецЦикла;
			Если ЗагрузитьСтрокиПослеОбработки Тогда
				Если ПринудительнаяЗапись Или Не ирОбщий.ТаблицыЗначенийРавныЛкс(СтараяКоллекцияСтрок, КоллекцияСтрок) Тогда
					ОбъектДляОбработки.Загрузить(КоллекцияСтрок);
					ирОбщий.НаборЗаписейПослеЗагрузкиИзТаблицыЗначенийЛкс(ОбъектДляОбработки);
				КонецЕсли; 
			КонецЕсли; 
			Если Истина
				И РежимОбходаДанных <> "КлючиОбъектов"
				И Не ирОбщий.ЛиКорневойТипПеречисленияЛкс(ТипТаблицы)
			Тогда
				Попытка
					Модифицированность = ОбъектДляОбработки.Модифицированность() Или ПринудительнаяЗапись;
				Исключение
					// Объект мог быть удален
					Модифицированность = Ложь;
				КонецПопытки; 
				Если Модифицированность Тогда
					РежимЗаписи = Неопределено;
					Если Истина
						И ПроводитьПроведенные
						И ОбъектДляОбработки.Проведен
					Тогда
						РежимЗаписи = РежимЗаписиДокумента.Проведение;
					КонецЕсли;
					ирОбщий.ЗаписатьОбъектЛкс(ОбъектДляОбработки, ЗаписьНаСервере, РежимЗаписи);
				КонецЕсли;
			КонецЕсли; 
			РезультатОбработки = "Успех";
			Если ВыводитьСообщения Тогда
				Сообщить(Символы.Таб + РезультатОбработки);
			КонецЕсли; 
		КонецЕсли; 
		Если ПрименятьПообъектныеТранзакции Тогда
			ЗафиксироватьТранзакцию();
		КонецЕсли; 
	Исключение
		Если ПрименятьПообъектныеТранзакции Тогда
			ОтменитьТранзакцию();
		КонецЕсли; 
		РезультатОбработки = ОписаниеОшибки();
		Если Не ВыводитьСообщения Тогда
			Сообщить(ТекстСообщенияОбОбработкеОбъекта);
		КонецЕсли; 
		Сообщить(Символы.Таб + РезультатОбработки, СтатусСообщения.Внимание);
		Если Не ПропускатьОшибки Или ОбщаяТранзакция Тогда
			ВызватьИсключение;
		КонецЕсли; 
	КонецПопытки;
	Если Истина
		И РезультатОбработки = "Успех"
		И УдалятьРегистрациюНаУзлеПослеОбработкиОбъекта 
		И ЗначениеЗаполнено(УзелОтбораОбъектов)
	Тогда 
		Если мСоставПланаОбмена.Содержит(ОбъектДляОбработки.Метаданные()) Тогда
			ирОбщий.ИзменитьРегистрациюДляУзлаЛкс(УзелОтбораОбъектов, ОбъектДляОбработки, Ложь);
		КонецЕсли; 
	КонецЕсли; 
	Возврат РезультатОбработки;

КонецФункции

Функция ПолучитьОписаниеТиповОбрабатываемогоЭлементаИлиОбъекта(ИскомыйОбъект, НуженТипОбъекта = Ложь, выхПолноеИмяТаблицы = "") Экспорт
	
	МассивОбъектовМД = Новый Массив();
	Если ИскомыйОбъект <> Неопределено Тогда
		ТипТаблицы = ИскомыйОбъект.ТипТаблицы;
		Если МноготабличнаяВыборка Тогда
			МассивОбъектовМД = ИскомыйОбъект.МетаОбъект;
		Иначе
			МассивОбъектовМД.Добавить(ИскомыйОбъект.МетаОбъект);
		КонецЕсли; 
	КонецЕсли; 
	МассивТипов = Новый Массив();
	Если Ложь
		Или ирОбщий.ЛиКорневойТипСсылочногоОбъектаБДЛкс(ТипТаблицы) 
		Или ТипТаблицы = "Внешняя"
	Тогда
		Если РежимОбходаДанных = "КлючиОбъектов" Тогда
			РасширениеТипа = "Ссылка";
		Иначе
			РасширениеТипа = "Объект";
		КонецЕсли; 
		Для Каждого ОбъектМД Из МассивОбъектовМД Цикл
			ИмяТипа = ирОбщий.ИмяТипаИзПолногоИмениМДЛкс(ОбъектМД, РасширениеТипа);
			МассивТипов.Добавить(Тип(ИмяТипа));
		КонецЦикла;
	ИначеЕсли Ложь
		Или ирОбщий.ЛиКорневойТипЖурналаДокументовЛкс(ТипТаблицы) 
	Тогда
		Если РежимОбходаДанных = "КлючиОбъектов" Тогда
			РасширениеТипа = "Ссылка";
		Иначе
			РасширениеТипа = "Объект";
		КонецЕсли; 
		Поля = ирОбщий.ПолучитьПоляТаблицыБДЛкс(МассивОбъектовМД[0].ПолноеИмя());
		Поле = Поля.Найти("Ссылка", "Имя");
		Для Каждого ТипЗначения Из Поле.ТипЗначения.Типы() Цикл
			ИмяТипа = ирОбщий.ИмяТипаИзПолногоИмениМДЛкс(Метаданные.НайтиПоТипу(ТипЗначения), РасширениеТипа);
			МассивТипов.Добавить(Тип(ИмяТипа));
		КонецЦикла;
	ИначеЕсли ТипТаблицы = "Точки" Тогда
		РасширениеТипа = "ТочкаМаршрутаБизнесПроцессаСсылка";
		Для Каждого ОбъектМД Из МассивОбъектовМД Цикл
			ИмяТипа = СтрЗаменить(ОбъектМД.ПолноеИмя(), "БизнесПроцесс.", РасширениеТипа + ".");
			МассивТипов.Добавить(Тип(ИмяТипа));
		КонецЦикла;
	ИначеЕсли ирОбщий.ЛиКорневойТипПеречисленияЛкс(ТипТаблицы) Тогда
		РасширениеТипа = "Ссылка";
		Для Каждого ОбъектМД Из МассивОбъектовМД Цикл
			ИмяТипа = СтрЗаменить(ОбъектМД.ПолноеИмя(), ".", РасширениеТипа + ".");
			МассивТипов.Добавить(Тип(ИмяТипа));
		КонецЦикла;
	ИначеЕсли ирОбщий.ЛиКорневойТипКонстантыЛкс(ТипТаблицы) Тогда
		РасширениеТипа = "МенеджерЗначения";
		Для Каждого ОбъектМД Из МассивОбъектовМД Цикл
			ИмяТипа = СтрЗаменить(ОбъектМД.ПолноеИмя(), ".", РасширениеТипа + ".");
			МассивТипов.Добавить(Тип(ИмяТипа));
		КонецЦикла;
	ИначеЕсли ирОбщий.ЛиТипВложеннойТаблицыБДЛкс(ТипТаблицы) Тогда
		Для Каждого ОбъектМД Из МассивОбъектовМД Цикл
			МассивФрагментов = ирОбщий.ПолучитьМассивИзСтрокиСРазделителемЛкс(ирОбщий.ПолучитьИмяТаблицыИзМетаданныхЛкс(ОбъектМД.ПолноеИмя()));
			выхПолноеИмяТаблицы = МассивФрагментов[0] + "." + МассивФрагментов[1];
			Если Не НуженТипОбъекта И РежимОбходаДанных = "Строки" Тогда
				ИмяТипа = МассивФрагментов[0] + ТипТаблицы + "Строка." + МассивФрагментов[1];
				Если ТипТаблицы = "ТабличнаяЧасть" Тогда
					ИмяТипа = ИмяТипа + "." + МассивФрагментов[2];
					выхПолноеИмяТаблицы = выхПолноеИмяТаблицы + "." + МассивФрагментов[2];
				Иначе
					выхПолноеИмяТаблицы = выхПолноеИмяТаблицы + "." + ТипТаблицы;
				КонецЕсли; 
				МассивТипов.Добавить(Тип(ИмяТипа));
			ИначеЕсли РежимОбходаДанных = "КлючиОбъектов" Тогда
				МассивТипов.Добавить(Тип(МассивФрагментов[0] + "Ссылка." + МассивФрагментов[1]));
			Иначе
				МассивТипов.Добавить(Тип(МассивФрагментов[0] + "Объект." + МассивФрагментов[1]));
			КонецЕсли; 
		КонецЦикла;                                                 
	ИначеЕсли Ложь
		Или ирОбщий.ЛиКорневойТипРегистраБДЛкс(ТипТаблицы) 
		Или ирОбщий.ЛиКорневойТипПоследовательностиЛкс(ТипТаблицы)
	Тогда
		Если Не НуженТипОбъекта И РежимОбходаДанных = "Строки" Тогда
			РасширениеТипа = "Запись";
		Иначе
			РасширениеТипа = "НаборЗаписей";
		КонецЕсли; 
		Для Каждого ОбъектМД Из МассивОбъектовМД Цикл
			ИмяТаблицы = ирОбщий.ПолучитьИмяТаблицыИзМетаданныхЛкс(ОбъектМД);
			ТипЭлементаДанных = Тип(ирОбщий.ПолучитьИмяТипаДанныхТаблицыРегистраЛкс(ИмяТаблицы, РасширениеТипа));
			МассивТипов.Добавить(ТипЭлементаДанных);
		КонецЦикла; 
	Иначе
		ВызватьИсключение "Неподдерживаемый тип таблицы """ + ТипТаблицы + """";
	КонецЕсли; 
	Результат = Новый ОписаниеТипов(МассивТипов);
	Возврат Результат;

КонецФункции

#КонецЕсли

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТИРУЕМЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура вЗагрузитьОбработки(ДоступныеОбработки, ВыбранныеОбработки) Экспорт

	ТаблицаОбработок = ирОбщий.ПолучитьТаблицуИзТабличногоДокументаЛкс(ПолучитьМакет("Обработки"));
	Для каждого СтрокаОбработки из ТаблицаОбработок Цикл
		МетаФорма = Метаданные().Формы[СтрокаОбработки.Имя];
		НайденнаяСтрока = ДоступныеОбработки.Строки.Найти(МетаФорма.Имя, "ИмяФормы");
		Если НайденнаяСтрока = Неопределено Тогда
			НайденнаяСтрока = ДоступныеОбработки.Строки.Добавить();
			НайденнаяСтрока.ИмяФормы  = МетаФорма.Имя;
		КонецЕсли; 
		ЗаполнитьЗначенияСвойств(НайденнаяСтрока, СтрокаОбработки); 
		НайденнаяСтрока.Групповая = Вычислить(СтрокаОбработки.Групповая);
		НайденнаяСтрока.Многотабличная = Вычислить(СтрокаОбработки.Многотабличная);
		НайденнаяСтрока.Обработка = МетаФорма.Синоним;
		ФормаОбработки = ЭтотОбъект.ПолучитьФорму(МетаФорма.Имя);
		Если ФормаОбработки.КартинкаЗаголовка.Вид <> ВидКартинки.Пустая Тогда
			НайденнаяСтрока.Картинка = ФормаОбработки.КартинкаЗаголовка;
		КонецЕсли; 
		Попытка
			ИспользоватьНастройки = ФормаОбработки.мИспользоватьНастройки;
		Исключение
			ИспользоватьНастройки = Ложь;
		КонецПопытки; 
		Если Не ИспользоватьНастройки Тогда
			НайденнаяСтрока.Строки.Очистить();
		КонецЕсли;
	КонецЦикла;

	МассивДляУдаления = Новый Массив;
	
	Для каждого ДоступнаяОбработка из ДоступныеОбработки.Строки Цикл
		Если ТаблицаОбработок.Найти(ДоступнаяОбработка.ИмяФормы, "Имя") = Неопределено Тогда
			МассивДляУдаления.Добавить(ДоступнаяОбработка);
		КонецЕсли;
	КонецЦикла;

	Для Индекс = 0 по МассивДляУдаления.Количество() - 1 Цикл
		ДоступныеОбработки.Строки.Удалить(МассивДляУдаления[Индекс]);
	КонецЦикла;

	МассивДляУдаления.Очистить();
	
	Для каждого ВыбраннаяОбработка из ВыбранныеОбработки Цикл
		Если      ВыбраннаяОбработка.СтрокаДоступнойОбработки = Неопределено Тогда
			МассивДляУдаления.Добавить(ВыбраннаяОбработка);
		Иначе
			Если ВыбраннаяОбработка.СтрокаДоступнойОбработки.Родитель = Неопределено Тогда
				Если ДоступныеОбработки.Строки.Найти(ВыбраннаяОбработка.СтрокаДоступнойОбработки.ИмяФормы, "ИмяФормы") = Неопределено Тогда
					МассивДляУдаления.Добавить(ВыбраннаяОбработка);
				КонецЕсли;
			Иначе
				Если ДоступныеОбработки.Строки.Найти(ВыбраннаяОбработка.СтрокаДоступнойОбработки.Родитель.ИмяФормы, "ИмяФормы") = Неопределено Тогда
					МассивДляУдаления.Добавить(ВыбраннаяОбработка);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

	ДоступныеОбработки.Строки.Сортировать("Обработка", Истина);
	Для Индекс = 0 по МассивДляУдаления.Количество() - 1 Цикл
		ВыбранныеОбработки.Удалить(МассивДляУдаления[Индекс]);
	КонецЦикла;

КонецПроцедуры // вЗагрузитьОбработки()

//////////////////////////////////////////////////////////////////////////////////
//// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

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

ЭтотОбъект.НастройкиКомпоновки = Новый Соответствие;
ЭтотОбъект.АвтовВыбранныеПоляИзОтбора = Истина;
//ЭтотОбъект.ВыводитьСообщения = Истина;
ЭтотОбъект.ПообъектныеТранзакции = Истина;
ЭтотОбъект.ПропускатьОшибки = Истина;
ЭтотОбъект.РежимОбходаДанных = "Строки";
ЭтотОбъект.ОбластьПоиска = "";
ЭтотОбъект.ЗаписьНаСервере = ирОбщий.ПолучитьРежимЗаписиНаСервереПоУмолчаниюЛкс();
мПлатформа = ирКэш.Получить();
мИмяКолонкиПометки = "_ПометкаСлужебная";
мИмяКолонкиРезультатаОбработки = "_РезультатОбработки";
мИмяКолонкиПолногоИмениТаблицы = "_ПолноеИмяТаблицы";
мВопросНаОбновлениеСтрокДляОбработкиЗадавался = Истина;
мИмяНастройкиПоУмолчанию = "Новая настройка";
