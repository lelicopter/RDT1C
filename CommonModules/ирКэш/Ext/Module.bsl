﻿//ирПортативный Перем ирПлатформа Экспорт; // Эта переменная нужна только здесь

//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирПривилегированный Экспорт;

#Если Не ТонкийКлиент И Не ВебКлиент Тогда

Функция Получить() Экспорт 
	
	//#Если Клиент Или ВнешнееСоединение Или Не Сервер Тогда
		Попытка
			ирПлатформа = Вычислить("ирПлатформа");
		Исключение
		КонецПопытки;
		Если ирПлатформа = Неопределено Тогда
			ирПлатформа = ирОбщий.ПолучитьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирПлатформа");
			#Если _ Тогда
			    ирПлатформа = Обработки.ирПлатформа.Создать();
			#КонецЕсли
		КонецЕсли; 
		Возврат ирПлатформа;
	// В 8.3 это уже не работает. http://partners.v8.1c.ru/forum/thread.jsp?id=1058206#1058206
	//#Иначе
	//	ИмяПараметраСеанса = "ирКэш";
	//	Попытка
	//		НадоИнициализировать = ПараметрыСеанса[ИмяПараметраСеанса] = Неопределено;
	//	Исключение
	//		НадоИнициализировать = Истина;
	//	КонецПопытки;
	//	Если Не НадоИнициализировать Тогда
	//		Кэш = ПолучитьИзВременногоХранилища(ПараметрыСеанса[ИмяПараметраСеанса]);
	//	КонецЕсли; 
	//	Если ТипЗнч(Кэш) <> Тип("Структура") Тогда
	//		Кэш = ирОбщий.ПолучитьОбъектПоПолномуИмениМетаданныхЛкс("Обработкп.ирПлатформа");
	//		//ПараметрыСеанса[ИмяПараметраСеанса] = "1";
	//		ПараметрыСеанса[ИмяПараметраСеанса] = ПоместитьВоВременноеХранилище(Кэш, Новый УникальныйИдентификатор);
	//	КонецЕсли;
	//	Возврат Кэш;
	//#КонецЕсли 
	
КонецФункции // Получить()

// Медленный в среднем вариант
Функция ПолучитьКомпоновщикТаблицыМетаданныхЛкс(Знач ПолноеИмяМД, ВызыватьИсключениеПриОтсутствииПрав = Истина, ИндексПараметраПериодичность = Неопределено,
	ВыражениеПараметраПериодичность = "", ИменаВместоПредставлений = Ложь) Экспорт
	
	СхемаКомпоновкиДанных = ирОбщий.ПолучитьСхемуКомпоновкиПоОбъектуМетаданныхЛкс(ПолноеИмяМД,, Ложь,, ИндексПараметраПериодичность, ВыражениеПараметраПериодичность,
		ИменаВместоПредставлений);
	#Если _ Тогда
	    СхемаКомпоновкиДанных = Новый СхемаКомпоновкиДанных;
	#КонецЕсли
	Попытка
		ИсточникДоступныхНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных);
	Исключение
		// Антибаг платформы 8.2.18
		// Ошибка при вызове конструктора (ИсточникДоступныхНастроекКомпоновкиДанных)
		//  ИсточникДоступныхНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных);
		//по причине:
		//Ошибка получения информации набора данных
		//по причине:
		//Ошибка в запросе набора данных
		//по причине:
		//{(1, 17)}: Неверное присоединение
		//ВЫБРАТЬ Т.* ИЗ  <<?>>КАК Т
		ОбъектМД = Метаданные.НайтиПоПолномуИмени(ПолноеИмяМД);
		Если ОбъектМД = Неопределено Тогда
			// Возможно эта логика уже есть в какой то функции
			лПолноеИмяМД = ПолноеИмяМД;
			Фрагменты = ирОбщий.ПолучитьМассивИзСтрокиСРазделителемЛкс(ПолноеИмяМД);
			Если Фрагменты.Количество() > 1 Тогда
				Фрагменты.Удалить(Фрагменты.Количество() - 1);
				лПолноеИмяМД = ирОбщий.ПолучитьСтрокуСРазделителемИзМассиваЛкс(Фрагменты, ".");
			КонецЕсли; 
			ОбъектМД = Метаданные.НайтиПоПолномуИмени(лПолноеИмяМД);
		КонецЕсли; 
		Если Ложь
			Или ОбъектМД = Неопределено
			Или Не ПравоДоступа("Чтение", ОбъектМД) 
		Тогда
			Если ВызыватьИсключениеПриОтсутствииПрав Тогда
				ВызватьИсключение "Таблица отсутствует или нет прав на ее чтение """ + ПолноеИмяМД + """";
			Иначе
				Возврат Неопределено;
			КонецЕсли; 
		Иначе
			ВызватьИсключение;
		КонецЕсли; 
	КонецПопытки; 
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроек.Инициализировать(ИсточникДоступныхНастроек);
	
	// Для сравнения скорости в отладчике. Примерно та же скорость через построитель.
	//ПсевдонимТаблицы = "Т";
	//ПолноеИмяИлиОбъектМД = ПолноеИмяМД;
	//Если ТипЗнч(ПолноеИмяИлиОбъектМД) = Тип("Строка") Тогда
	//	ПолноеИмяМД = ПолноеИмяИлиОбъектМД;
	//Иначе
	//	ПолноеИмяМД = ПолноеИмяИлиОбъектМД.ПолноеИмя();
	//КонецЕсли; 
	//ПолноеИмяТаблицыБД = ирОбщий.ПолучитьИмяТаблицыИзМетаданныхЛкс(ПолноеИмяМД);
	//Если ИндексПараметраПериодичность <> Неопределено Тогда
	//	ПолноеИмяТаблицыБД = ПолноеИмяТаблицыБД + "(";
	//	Для Индекс = 1 По ИндексПараметраПериодичность Цикл
	//		ПолноеИмяТаблицыБД = ПолноеИмяТаблицыБД + ",";
	//	КонецЦикла;
	//	ПолноеИмяТаблицыБД = ПолноеИмяТаблицыБД + ВыражениеПараметраПериодичность + ")";
	//КонецЕсли; 
	//ТекстЗапроса = "ВЫБРАТЬ " + ПсевдонимТаблицы + ".* ИЗ " + ПолноеИмяТаблицыБД + " КАК " + ПсевдонимТаблицы;
	//Построитель = Новый ПостроительЗапроса(ТекстЗапроса);
	//Построитель.ЗаполнитьНастройки();
	Возврат КомпоновщикНастроек;
	
КонецФункции

Функция ПолучитьКомпоновщикВсехТаблицБДЛкс() Экспорт
	
	Если ЛиПортативныйРежимЛкс() Тогда
		КомпоновщикНастроек = ирПортативный.мКэшФункций["ПолучитьКомпоновщикВсехТаблицБДЛкс"];
		Если КомпоновщикНастроек <> Неопределено Тогда
			Возврат КомпоновщикНастроек;
		КонецЕсли; 
	КонецЕсли; 
	ТаблицаВсехТаблицБД = ирКэш.ПолучитьТаблицуВсехТаблицБДЛкс();
	СхемаКомпоновкиДанных = ирОбщий.ПолучитьСхемуКомпоновкиПоВсемТаблицамБДЛкс(ТаблицаВсехТаблицБД,, Ложь);
	#Если _ Тогда
	    СхемаКомпоновкиДанных = Новый СхемаКомпоновкиДанных;
	#КонецЕсли
	ИсточникДоступныхНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных);
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроек.Инициализировать(ИсточникДоступныхНастроек);
	#Если Клиент Тогда
		Состояние("Описание колонок БД...");
	#КонецЕсли 
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	Если ЛиПортативныйРежимЛкс() Тогда
		ирПортативный.мКэшФункций["ПолучитьКомпоновщикВсехТаблицБДЛкс"] = КомпоновщикНастроек;
	КонецЕсли; 
	Возврат КомпоновщикНастроек;
	
КонецФункции

Функция ИндивидуальныеТаблицыКонстантДоступныЛкс() Экспорт 
	
	мПлатформа = ирКэш.Получить();
	Результат = Истина
		И мПлатформа.ВерсияПлатформы >= 802014
		И Метаданные.РежимСовместимости <> Метаданные.СвойстваОбъектов.РежимСовместимости.Версия8_2_13
		И Метаданные.РежимСовместимости <> Метаданные.СвойстваОбъектов.РежимСовместимости.Версия8_1;
	Возврат Результат;

КонецФункции

Функция ПолучитьТаблицуВсехТаблицБДЛкс() Экспорт 
	
	Если ЛиПортативныйРежимЛкс() Тогда
		ТаблицаВсехТаблицБД = ирПортативный.мКэшФункций["ПолучитьТаблицуВсехТаблицБДЛкс"];
		Если ТаблицаВсехТаблицБД <> Неопределено Тогда
			Возврат ТаблицаВсехТаблицБД;
		КонецЕсли; 
	КонецЕсли; 
	ТаблицаВсехТаблицБД = Новый ТаблицаЗначений;
	ТаблицаВсехТаблицБД.Колонки.Добавить("НПолноеИмя");
	ТаблицаВсехТаблицБД.Колонки.Добавить("ПолноеИмя");
	ТаблицаВсехТаблицБД.Колонки.Добавить("Имя");
	ТаблицаВсехТаблицБД.Колонки.Добавить("Представление");
	ТаблицаВсехТаблицБД.Колонки.Добавить("Тип");
	ТаблицаВсехТаблицБД.Колонки.Добавить("Схема");
	мПлатформа = ирКэш.Получить();
	КоллекцияКорневыхТипов = Новый Массив;
	СтрокиМетаОбъектов = ирКэш.Получить().ТаблицаТиповМетаОбъектов.НайтиСтроки(Новый Структура("Категория", 0));
	Для Каждого СтрокаТаблицыМетаОбъектов Из СтрокиМетаОбъектов Цикл
		Единственное = СтрокаТаблицыМетаОбъектов.Единственное;
		Если Ложь
			Или (Истина
				И Единственное = "Константа"
				И ирКэш.ИндивидуальныеТаблицыКонстантДоступныЛкс())
			Или Единственное = "КритерийОтбора"
			Или Единственное = "ЖурналДокументов"
			Или ирОбщий.ЛиКорневойТипПеречисленияЛкс(Единственное)
			Или ирОбщий.ЛиКорневойТипСсылочногоОбъектаБДЛкс(Единственное)
			Или ирОбщий.ЛиКорневойТипРегистраБДЛкс(Единственное)
			Или ирОбщий.ЛиКорневойТипПоследовательностиЛкс(Единственное)
		Тогда
			КоллекцияКорневыхТипов.Добавить(Единственное);
		КонецЕсли;
	КонецЦикла;
	Если ирКэш.Получить().ВерсияПлатформы >= 802014 Тогда
		Для Каждого МетаВнешнийИсточникДанных Из Метаданные.ВнешниеИсточникиДанных Цикл
			КоллекцияКорневыхТипов.Добавить(МетаВнешнийИсточникДанных.ПолноеИмя());
		КонецЦикла; 
	КонецЕсли; 
	Если Метаданные.Константы.Количество() > 0 Тогда
		ирОбщий.ДобавитьДоступнуюТаблицуБДЛкс(ТаблицаВсехТаблицБД, "Константы");
	КонецЕсли; 
	мСтрокаТипаВнешнегоИсточникаДанных = мПлатформа.ПолучитьСтрокуТипаМетаОбъектов("ВнешнийИсточникДанных", , 0);
	ИндикаторТипов = ирОбщий.ПолучитьИндикаторПроцессаЛкс(КоллекцияКорневыхТипов.Количество(), "Анализ структуры БД");
	Для Каждого КорневойТип Из КоллекцияКорневыхТипов Цикл
		ирОбщий.ОбработатьИндикаторЛкс(ИндикаторТипов);
		СтрокаКорневогоТипа = мПлатформа.ПолучитьСтрокуТипаМетаОбъектов(КорневойТип);
		Если СтрокаКорневогоТипа = Неопределено Тогда
			СтрокаКорневогоТипа = мСтрокаТипаВнешнегоИсточникаДанных;
			МножественноеКорневогоТипа = СтрокаКорневогоТипа.Множественное;
			ОбъектМДКорневогоТипа = Метаданные.НайтиПоПолномуИмени(КорневойТип);
			КоллекцияМетаданных = ОбъектМДКорневогоТипа.Таблицы;
			ПредставлениеКатегории = ОбъектМДКорневогоТипа.Представление();
			СхемаТаблиц = ОбъектМДКорневогоТипа.Имя;
			КорневойТип = "Внешняя";
		Иначе
			МножественноеКорневогоТипа = СтрокаКорневогоТипа.Множественное;
			ПредставлениеКатегории = ирОбщий.ПолучитьПредставлениеИзИдентификатораЛкс(МножественноеКорневогоТипа);
			СхемаТаблиц = "";
			Если КорневойТип = "Перерасчет" Тогда 
				КоллекцияМетаданных = Новый Массив;
				Для Каждого МетаРегистрРасчета Из Метаданные.РегистрыРасчета Цикл
					Для Каждого Перерасчет Из МетаРегистрРасчета.Перерасчеты Цикл
						КоллекцияМетаданных.Добавить(Перерасчет);
					КонецЦикла;
				КонецЦикла;
			Иначе
				КоллекцияМетаданных = Метаданные[МножественноеКорневогоТипа];
			КонецЕсли; 
		КонецЕсли; 
		Если КоллекцияМетаданных.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		//ПредставлениеТипаТаблицы = ирОбщий.ПолучитьПредставлениеИзИдентификатораЛкс(МножественноеКорневогоТипа);
		ИндикаторТипа = ирОбщий.ПолучитьИндикаторПроцессаЛкс(КоллекцияМетаданных.Количество(), "Анализ " + КорневойТип);
		Для Каждого МетаИсточник Из КоллекцияМетаданных Цикл
			ирОбщий.ОбработатьИндикаторЛкс(ИндикаторТипа);
			ПолноеИмяМД = МетаИсточник.ПолноеИмя();
			СтрокаОсновнойТаблицы = ирОбщий.ДобавитьДоступнуюТаблицуБДЛкс(ТаблицаВсехТаблицБД, ирОбщий.ПолучитьИмяТаблицыИзМетаданныхЛкс(ПолноеИмяМД,, Ложь), КорневойТип, МетаИсточник.Имя,
				МетаИсточник.Представление(), СхемаТаблиц, , МетаИсточник);
			Если ирОбщий.ЛиКорневойТипСсылочногоОбъектаБДЛкс(КорневойТип) Тогда
				СтруктураТЧ = ирОбщий.ПолучитьТабличныеЧастиОбъектаЛкс(МетаИсточник);
				Для Каждого КлючИЗначение Из СтруктураТЧ Цикл
					ирОбщий.ДобавитьДоступнуюТаблицуБДЛкс(ТаблицаВсехТаблицБД, ПолноеИмяМД + "." + КлючИЗначение.Ключ, "ТабличнаяЧасть", ,
						МетаИсточник.Представление() + "." + КлючИЗначение.Значение);
				КонецЦикла;
			КонецЕсли; 
			Если ирОбщий.ЕстьТаблицаИзмененийОбъектаМетаданных(МетаИсточник) Тогда
				//Если Ложь
				//	Или ирОбщий.ЛиКорневойТипСсылочногоОбъектаБДЛкс(КорневойТип)
				//	Или ирОбщий.ЛиКорневойТипРегистраБДЛкс(КорневойТип)
				//	Или ирОбщий.ЛиКорневойТипПоследовательностиЛкс(КорневойТип)
				//Тогда
					ирОбщий.ДобавитьДоступнуюТаблицуБДЛкс(ТаблицаВсехТаблицБД, СтрокаОсновнойТаблицы.ПолноеИмя + ".Изменения", "Изменения", СтрокаОсновнойТаблицы.Имя,
						СтрокаОсновнойТаблицы.Представление + "." + "Изменения");
				//КонецЕсли; 
			КонецЕсли;
			Если КорневойТип = "РегистрСведений" Тогда 
				Если МетаИсточник.ПериодичностьРегистраСведений <> Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический Тогда
					ирОбщий.ДобавитьДоступнуюТаблицуБДЛкс(ТаблицаВсехТаблицБД, ПолноеИмяМД + ".СрезПоследних", "ВиртуальнаяТаблица", , МетаИсточник.Представление() + "." + "Срез последних");
					ирОбщий.ДобавитьДоступнуюТаблицуБДЛкс(ТаблицаВсехТаблицБД, ПолноеИмяМД + ".СрезПервых", "ВиртуальнаяТаблица", , МетаИсточник.Представление() + "." + "Срез первых");
				КонецЕсли;
			ИначеЕсли КорневойТип = "РегистрНакопления" Тогда 
				ирОбщий.ДобавитьДоступнуюТаблицуБДЛкс(ТаблицаВсехТаблицБД, ПолноеИмяМД + ".Обороты", "ВиртуальнаяТаблица", , МетаИсточник.Представление() + "." + "Обороты");
				Если МетаИсточник.ВидРегистра = Метаданные.СвойстваОбъектов.ВидРегистраНакопления.Остатки Тогда
					ирОбщий.ДобавитьДоступнуюТаблицуБДЛкс(ТаблицаВсехТаблицБД, ПолноеИмяМД + ".Остатки", "ВиртуальнаяТаблица", , МетаИсточник.Представление() + "." + "Остатки");
					ирОбщий.ДобавитьДоступнуюТаблицуБДЛкс(ТаблицаВсехТаблицБД, ПолноеИмяМД + ".ОстаткиИОбороты", "ВиртуальнаяТаблица", ,
						МетаИсточник.Представление() + "." + "Остатки и обороты");
				КонецЕсли;
			ИначеЕсли КорневойТип = "РегистрБухгалтерии" Тогда 
				ирОбщий.ДобавитьДоступнуюТаблицуБДЛкс(ТаблицаВсехТаблицБД, ПолноеИмяМД + ".ДвиженияССубконто", "ДвиженияССубконто", ,
					МетаИсточник.Представление() + "." + "Движения с субконто");
				Если МетаИсточник.ПланСчетов.МаксКоличествоСубконто > 0 Тогда
					ирОбщий.ДобавитьДоступнуюТаблицуБДЛкс(ТаблицаВсехТаблицБД, ПолноеИмяМД + ".Субконто", "Субконто", , МетаИсточник.Представление() + "." + "Субконто");
				КонецЕсли; 
				ирОбщий.ДобавитьДоступнуюТаблицуБДЛкс(ТаблицаВсехТаблицБД, ПолноеИмяМД + ".Обороты", "ВиртуальнаяТаблица", , МетаИсточник.Представление() + "." + "Обороты");
				ирОбщий.ДобавитьДоступнуюТаблицуБДЛкс(ТаблицаВсехТаблицБД, ПолноеИмяМД + ".ОборотыДтКт", "ВиртуальнаяТаблица", , МетаИсточник.Представление() + "." + "Обороты Дт Кт");
				ирОбщий.ДобавитьДоступнуюТаблицуБДЛкс(ТаблицаВсехТаблицБД, ПолноеИмяМД + ".Остатки", "ВиртуальнаяТаблица", , МетаИсточник.Представление() + "." + "Остатки");
				ирОбщий.ДобавитьДоступнуюТаблицуБДЛкс(ТаблицаВсехТаблицБД, ПолноеИмяМД + ".ОстаткиИОбороты", "ВиртуальнаяТаблица", , МетаИсточник.Представление() + "." + "Остатки и обороты");
			//ИначеЕсли КорневойТип = "РегистрРасчета" Тогда 
			//	Для Каждого Перерасчет Из МетаИсточник.Перерасчеты Цикл
			//		ирОбщий.ДобавитьДоступнуюТаблицуБДЛкс(ТаблицаВсехТаблицБД, ирОбщий.ПолучитьИмяТаблицыИзМетаданныхЛкс(Перерасчет), "Перерасчет", Перерасчет.Имя, Перерасчет.Представление(), , , Перерасчет);
			//	КонецЦикла;
			ИначеЕсли КорневойТип = "Последовательность" Тогда 
				ирОбщий.ДобавитьДоступнуюТаблицуБДЛкс(ТаблицаВсехТаблицБД, ПолноеИмяМД + ".Границы", "Границы", , МетаИсточник.Представление() + "." + "Границы");
			КонецЕсли;
		КонецЦикла;
		ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	КонецЦикла;
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	ТаблицаВсехТаблицБД.Индексы.Добавить("НПолноеИмя");
	Если ЛиПортативныйРежимЛкс() Тогда
		ирПортативный.мКэшФункций["ПолучитьТаблицуВсехТаблицБДЛкс"] = ТаблицаВсехТаблицБД;
	КонецЕсли; 
	Возврат ТаблицаВсехТаблицБД;
	
КонецФункции

// Быстрый в среднем вариант. Долгое первое выполнение на больших конфигурациях!
Функция ПолучитьКомпоновщикТаблицыБДПоМетаданнымЛкс(Знач ПолноеИмяМД) Экспорт
	
	ПолноеИмяТаблицыБД = ирОбщий.ПолучитьИмяТаблицыИзМетаданныхЛкс(ПолноеИмяМД);
	Результат = ПолучитьКомпоновщикТаблицыБДПоПолномуИмениЛкс(ПолноеИмяТаблицыБД);
	Возврат Результат;
	
КонецФункции

// Быстрый в среднем вариант. Долгое первое выполнение на больших конфигурациях!
Функция ПолучитьКомпоновщикТаблицыБДПоПолномуИмениЛкс(Знач ПолноеИмяТаблицыБД) Экспорт
	
	Компоновщик = ирКэш.ПолучитьКомпоновщикВсехТаблицБДЛкс();
	#Если _ Тогда
		Компоновщик = Новый КомпоновщикНастроекКомпоновкиДанных;
	#КонецЕсли
	ТаблицаВсехТаблицБД = ирКэш.ПолучитьТаблицуВсехТаблицБДЛкс();
	СтрокаОписанияТаблицы = ТаблицаВсехТаблицБД.Найти(НРег(ПолноеИмяТаблицыБД), "НПолноеИмя");
	ИндексВложеннойСхемы = ТаблицаВсехТаблицБД.Индекс(СтрокаОписанияТаблицы);
	Результат = Компоновщик.Настройки.Структура[ИндексВложеннойСхемы];
	Возврат Результат;
	
КонецФункции

Функция ЛиПортативныйРежимЛкс() Экспорт
	
	Попытка
		Пустышка = Вычислить("ИспользуемоеИмяФайла");
		Результат = Истина;
	Исключение
		Результат = Ложь;
	КонецПопытки; 
	Возврат Результат;
	
КонецФункции

Функция ПолучитьСтруктуруХраненияБДЛкс(ЛиИменаБД = Ложь, ВычислитьИменаИндексов = Истина) Экспорт

	Результат = ПолучитьСтруктуруХраненияБазыДанных(, ЛиИменаБД);
	#Если _ Тогда
	    Результат = Новый ТаблицаЗначений;
	#КонецЕсли
	//Результат.Колонки.ИмяТаблицыХранения.Имя = "ИмяТаблицыХраненияСРегистромБукв";
	Результат.Колонки.Добавить("КраткоеИмяТаблицыХранения", Новый ОписаниеТипов("Строка"));
	//Результат.Колонки.Добавить("ИмяТаблицыХранения", Новый ОписаниеТипов("Строка"));
	Для Каждого СтрокаТаблицыХранения Из Результат Цикл
		// Антибаг платформы 8.2.16 У ряда назначений таблиц ИмяТаблицы пустое http://partners.v8.1c.ru/forum/thread.jsp?id=1090307#1090307 
		Если ПустаяСтрока(СтрокаТаблицыХранения.ИмяТаблицы) Тогда
			МетаПолноеИмяТаблицы = "";
			Если ЗначениеЗаполнено(СтрокаТаблицыХранения.Метаданные) Тогда
				МетаПолноеИмяТаблицы = СтрокаТаблицыХранения.Метаданные + ".";
			КонецЕсли; 
			Если СтрокаТаблицыХранения.Назначение = "РегистрацияИзменений" Тогда
				СтрокаТаблицыХранения.ИмяТаблицы = МетаПолноеИмяТаблицы + "Изменения";
			Иначе
				СтрокаТаблицыХранения.ИмяТаблицы = МетаПолноеИмяТаблицы + СтрокаТаблицыХранения.Назначение;
			КонецЕсли; 
		КонецЕсли; 
		//СтрокаТаблицыХранения.ИмяТаблицыХранения = НРег(ирОбщий.ПолучитьПоследнийФрагментЛкс(СтрокаТаблицыХранения.ИмяТаблицыХраненияСРегистромБукв));
		СтрокаТаблицыХранения.КраткоеИмяТаблицыХранения = НРег(ирОбщий.ПолучитьПоследнийФрагментЛкс(СтрокаТаблицыХранения.ИмяТаблицыХранения));
		Если ВычислитьИменаИндексов Тогда
			СтрокаТаблицыХранения.Индексы.Колонки.Добавить("ИмяИндекса", Новый ОписаниеТипов("Строка"));
			Для Каждого СтрокаИндексаХранения Из СтрокаТаблицыХранения.Индексы Цикл
				ПредставлениеИндекса = ирОбщий.ПолучитьПредставлениеИндексаХраненияЛкс(СтрокаИндексаХранения, ЛиИменаБД, СтрокаТаблицыХранения);
				СтрокаИндексаХранения.ИмяИндекса = "Индекс(" + ПредставлениеИндекса + ")";
			КонецЦикла;
		КонецЕсли; 
	КонецЦикла;
	Результат.Индексы.Добавить("КраткоеИмяТаблицыХранения");
	Возврат Результат;

КонецФункции

// Получить словарь метаданных состоящий из шаблонов имен таблиц
//
// Параметры:
//  ЛиИменаБД - Булево
//
// Возвращаемое значение:
//  Соответствие - словарь шаблонов имен метаданных. Ключ - наименование объекта
//                 метаданных, где его номер заменен на номер позиции этого
//                 числа в строке; Значение - количество чисел в строке
//
Функция ПолучитьСловарьШаблоновМетаданных(ЛиИменаБД = Ложь) Экспорт

	Перем ПозицияЧисла;
	Перем КоличествоСимволов;
	
	СтруктураХраненияБД = ирКэш.ПолучитьСтруктуруХраненияБДЛкс(ЛиИменаБД);
	// Создать словарь метаданных
	СловарьМетаданных = Новый Соответствие;
	// Обработать структуру базы
	Для Каждого СтрокаСтруктурыБазы Из СтруктураХраненияБД Цикл
		
		// Скопировать имя таблицы
		ИмяТаблицыХранения = НРег(Лев(СтрокаСтруктурыБазы.ИмяТаблицыХранения, СтрДлина(СтрокаСтруктурыБазы.ИмяТаблицыХранения)));
		ШаблонИмениТаблицыХранения = "";
		КоличествоЧисел = 0;
		ПоследнееИмяШаблона = "";
		
		// Получить шаблон имени
		Пока ирОбщий.НайтиЧислоВСтрокеЛкс(ИмяТаблицыХранения, ПозицияЧисла, КоличествоСимволов) Цикл
			КоличествоЧисел = КоличествоЧисел + 1;
			ПоследнееИмяШаблона = Лев(ИмяТаблицыХранения, ПозицияЧисла - 1);
			ШаблонИмениТаблицыХранения = ШаблонИмениТаблицыХранения + ПоследнееИмяШаблона + XMLСтрока(КоличествоЧисел);
			ИмяТаблицыХранения = Прав(ИмяТаблицыХранения, СтрДлина(ИмяТаблицыХранения) - ПозицияЧисла - КоличествоСимволов + 1);
		КонецЦикла;
		
		ШаблонИмениТаблицыХранения = ШаблонИмениТаблицыХранения + ИмяТаблицыХранения;
		СловарьМетаданных.Вставить(ШаблонИмениТаблицыХранения, КоличествоЧисел);
		
		Если Не ЛиИменаБД Тогда
			// Сохранить шаблон дочерней таблицы независимо
			Если КоличествоЧисел > 1 Тогда
				Если Лев(ПоследнееИмяШаблона, 1) = "." Тогда
					ПоследнееИмяШаблона = Сред(ПоследнееИмяШаблона, 2);
				КонецЕсли; 
				СловарьМетаданных.Вставить(ПоследнееИмяШаблона + "1", 1);
			КонецЕсли; 
		КонецЕсли; 
	КонецЦикла;
	
	// Предобразовать соответствие в ТЗ и отсортировать ее по ключу в обратном порядке
	СловарьТаблица = Новый ТаблицаЗначений;
	СловарьТаблица.Колонки.Добавить("Ключ");
	СловарьТаблица.Колонки.Добавить("Значение");
	Для Каждого СтрокаСловаря Из СловарьМетаданных Цикл
		СтрокаТаблицыСловаря = СловарьТаблица.Добавить();
		СтрокаТаблицыСловаря.Ключ = НРег(СтрокаСловаря.Ключ);
		СтрокаТаблицыСловаря.Значение = СтрокаСловаря.Значение;
	КонецЦикла;
	СловарьТаблица.Сортировать("Ключ Убыв");
	
	Возврат СловарьТаблица;

КонецФункции

Функция ПолучитьСеансПустойИнфобазы1С8Лкс(Знач ТипCOMОбъекта = "Application", Знач Видимость = Ложь, Знач ОбработатьИсключениеПодключения = Ложь,
	ОписаниеОшибки = "", ИмяСервераПроцессов = "") Экспорт
	
	СтрокаСоединения = ирОбщий.ПолучитьСтрокуСоединенияПустойИнфобазыЛкс();
	Сеанс = ирОбщий.СоздатьСеансИнфобазы1С8Лкс(СтрокаСоединения, , , ТипCOMОбъекта, Видимость, ОбработатьИсключениеПодключения,
		ОписаниеОшибки, ИмяСервераПроцессов);
	Возврат Сеанс;
	
КонецФункции

Функция ПолучитьБуферСравненияЛкс(КлючСравнения) Экспорт
	
	Попытка
		ирПлатформа = Вычислить("ирПлатформа");
	Исключение
	КонецПопытки;
	Если ирПлатформа = Неопределено Тогда
		Результат = Новый Массив();
	Иначе
		Результат = ирПлатформа.БуферСравнения; 
	КонецЕсли; 
	Возврат Результат;
	
КонецФункции

Функция ПолучитьWinAPI() Экспорт 
	
	мПлатформа = ирКэш.Получить();
	WinAPI = мПлатформа.ПолучитьWinAPI();
	Возврат WinAPI;
	
КонецФункции

Функция ПолучитьФорматБуфераОбмена1СЛкс() Экспорт 
	
	WinAPI = ирКэш.ПолучитьWinAPI();
	ФорматБуфераОбмена1С = WinAPI.RegisterClipboardFormat("V8Value");
	Возврат ФорматБуфераОбмена1С;
	
КонецФункции

//#Если Клиент Тогда
	
Функция ПолучитьАнализТехножурналаЛкс() Экспорт
	
	Результат = ирОбщий.ПолучитьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирАнализТехножурнала");
	Возврат Результат;
	
КонецФункции

//#КонецЕсли

#КонецЕсли

Функция ЭтоФайловаяБазаЛкс() Экспорт 

	ФайловыйКаталог = НСтр(СтрокаСоединенияИнформационнойБазы(), "File");
	ЭтоФайловаяБаза = Не ПустаяСтрока(ФайловыйКаталог);
	Возврат ЭтоФайловаяБаза;

КонецФункции // ЭтоФайловаяБазаИис()

Функция ПолучитьСтрокуСоединенияСервераЛкс() Экспорт
	
	Результат = ирСервер.ПолучитьСтрокуСоединенияСервераЛкс();
	Возврат Результат;
	
КонецФункции

Функция ПолучитьCOMОбъектWMIЛкс(Знач ИмяСервера = Неопределено, Знач ИмяСервераИсполнителя = Неопределено, Знач ТочкаПодключения = Неопределено) Экспорт
	
	//http://msdn.microsoft.com/en-us/library/windows/desktop/aa389763(v=vs.85).aspx
	Если Не ЗначениеЗаполнено(ИмяСервераИсполнителя) Тогда 
		Locator = Новый COMОбъект("WbemScripting.SWbemLocator");
	Иначе
		Locator = Новый COMОбъект("WbemScripting.SWbemLocator", ИмяСервераИсполнителя);
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ИмяСервера) Тогда 
		ИмяСервера = ".";
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ТочкаПодключения) Тогда 
		ТочкаПодключения = "root\cimv2";
	КонецЕсли;
	Попытка
		СлужбаWMI = Locator.ConnectServer(ИмяСервера, ТочкаПодключения, , , ТекущийЯзыкСистемы()); 
	Исключение
		СлужбаWMI = Неопределено;
		Сообщить(ОписаниеОшибки(), СтатусСообщения.Внимание);
	КонецПопытки;
	Возврат СлужбаWMI;
	
КонецФункции
