﻿//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирПривилегированный Экспорт;

Перем мОписаниеТиповКолонки;

Функция ОбновитьДанные()
	
	ИсточникДействий = ЭтаФорма.ВладелецФормы;
	ОсновнойЭУ = ЭтаФорма.ЭлементыФормы.Значения;
	ДанныеКолонки = ирОбщий.ПутьКДаннымКолонкиТабличногоПоляЛкс(ИсточникДействий);
	ЗначениеТабличногоПоля = ирОбщий.ДанныеЭлементаФормыЛкс(ИсточникДействий);
	СтруктураТипа = Неопределено;
	ИмяТипаЗначения = ирОбщий.ОбщийТипДанныхТабличногоПоляЛкс(ИсточникДействий, , СтруктураТипа);
	ЭтаФорма.Отбор = Неопределено;
	Если ИмяТипаЗначения = "ТаблицаЗначений" Тогда 
	Иначе
		Если ИмяТипаЗначения = "ТабличнаяЧасть" Тогда 
			ЭтаФорма.Отбор = ИсточникДействий.ОтборСтрок;
			ЭтаФорма.ОтборПользовательский = ЭтаФорма.Отбор;
			НастройкаОтбораТабличногоПоля = ИсточникДействий.НастройкаОтбораСтрок;
		ИначеЕсли ИмяТипаЗначения = "НаборЗаписей" Тогда 
			ЭтаФорма.Отбор = ИсточникДействий.ОтборСтрок;
			ЭтаФорма.ОтборПользовательский = ЭтаФорма.Отбор;
			НастройкаОтбораТабличногоПоля = ИсточникДействий.НастройкаОтбораСтрок;
		ИначеЕсли ИмяТипаЗначения = "Список" Тогда 
			Если ТипЗнч(ИсточникДействий) = Тип("ТабличноеПоле") Тогда
				НастройкаОтбораТабличногоПоля = ИсточникДействий.НастройкаОтбора;
				НастройкаПорядкаТабличногоПоля = ИсточникДействий.НастройкаПорядка;
			КонецЕсли; 
			НастройкиСписка = ирОбщий.НастройкиДинамическогоСпискаЛкс(ЗначениеТабличногоПоля);
			ЭтаФорма.Отбор = НастройкиСписка.Отбор;
			НастройкиСписка = ирОбщий.НастройкиДинамическогоСпискаЛкс(ЗначениеТабличногоПоля, "Пользовательские");
			ЭтаФорма.ОтборПользовательский = НастройкиСписка.Отбор;
			ПолноеИмяТаблицы = ирОбщий.ИмяТаблицыБДДинамическогоСпискаЛкс(ИсточникДействий);
		Иначе
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	ВыгрузкаРезультата = ирОбщий.ТаблицаЗначенийИзТабличногоПоляЛкс(ИсточникДействий);
	Если Отбор <> Неопределено Тогда
		Если ТипЗнч(Отбор) = Тип("Отбор") Тогда
			ЭлементОтбора = Отбор[ДанныеКолонки];
			ДоступноеПоле = ЭлементОтбора;
		Иначе
			#Если Сервер И Не Сервер Тогда
			    Пустышка = Новый НастройкиКомпоновкиДанных;
				Отбор = Пустышка.Отбор;
			#КонецЕсли
			ЭлементОтбора = ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(Отбор, ДанныеКолонки);
			ДоступноеПоле = Отбор.ДоступныеПоляОтбора.НайтиПоле(Новый ПолеКомпоновкиДанных(ДанныеКолонки));
		КонецЕсли; 
		мОписаниеТиповКолонки = ДоступноеПоле.ТипЗначения;
		ЭтаФорма.ВидСравненияТекущий = ЭлементОтбора.ВидСравнения;
		//СписокВыбора = ЭтаФорма.ЭлементыФормы.ВидСравненияНовый.СписокВыбора;
		//СписокВыбора.Очистить();
		//СписокВыбора.Добавить(ВидСравнения.ВСписке);
		//СписокВыбора.Добавить(ВидСравнения.ВСпискеПоИерархии);
		//СписокВыбора.Добавить(ВидСравнения.НеВСписке);
		//СписокВыбора.Добавить(ВидСравнения.НеВСпискеПоИерархии);
		////СтароеИспользование = ЭлементОтбора.Использование;
		////СтарыйВидСравнения = ЭлементОтбора.ВидСравнения;
		////ЭлементОтбора.Использование = Ложь;
		////Для Счетчик = 1 По СписокВыбора.Количество() Цикл
		////	Попытка
		////		ЭлементОтбора.ВидСравнения = ЭлементСписка.Значение;
		////	Исключение
		////		ЭлементСписка
		////	КонецПопытки;
		////КонецЦикла;
		////ЭлементОтбора.Использование = СтароеИспользование;
		////ЭлементОтбора.ВидСравнения = СтарыйВидСравнения;
	Иначе
		мОписаниеТиповКолонки = ВыгрузкаРезультата.Колонки[ДанныеКолонки].ТипЗначения;
	КонецЕсли; 
	ЭлементыФормы.ВидСравненияНовый.Доступность = Отбор <> Неопределено;
	ЭлементыФормы.ОсновныеДействияФормы.Кнопки.ОК.Доступность = Отбор <> Неопределено;
	ЭлементыФормы.Значения.Колонки.Пометка.Доступность = Отбор <> Неопределено;
	ЭлементыФормы.УчитываяОтбор.Доступность = Отбор <> Неопределено;
	Если мОписаниеТиповКолонки.Типы().Количество() = 1 Тогда
		ОтображениеКартинки = Неопределено;
		ОсновнойЭУ.Колонки.ТипЗначения.Видимость = Ложь;
		ЭлементыФормы.ДействияФормы.Кнопки.РазличныеТипЗначений.Доступность = Ложь;
	Иначе
		ОтображениеКартинки = "ИзТипа";
		ОсновнойЭУ.Колонки.ТипЗначения.Видимость = Истина;
		ЭлементыФормы.ДействияФормы.Кнопки.РазличныеТипЗначений.Доступность = Истина;
	КонецЕсли;
	Если ОсновнойЭУ.ТекущаяСтрока <> Неопределено Тогда
		ТекущееЗначение = ОсновнойЭУ.ТекущаяСтрока.Значение;
	КонецЕсли;
	МассивПомеченных = ОсновнойЭУ.Значение.Выгрузить(Новый Структура("Пометка", Истина)).ВыгрузитьКолонку("Значение");
	ОсновнойЭУ.Значение.Очистить();
		
	ИмяПоляГруппировки = "_Поле6574573573";
	ИмяПоляКоличества = "_ИмяПоляКоличества234324";
	Если Ложь
		Или ИмяТипаЗначения = "НаборЗаписей"
		Или ИмяТипаЗначения = "ТабличнаяЧасть"
		Или ИмяТипаЗначения = "ТаблицаЗначений"
	Тогда
		ВыгрузкаРезультата.Колонки.Добавить(ИмяПоляКоличества);
		ИсточникДанных = Новый ОписаниеИсточникаДанных(ВыгрузкаРезультата);
		ИсточникДанных.Колонки[ДанныеКолонки].Измерение = Истина;
		//ИсточникДанных.Колонки[ДанныеКолонки].Отбор = Истина;
		ИсточникДанных.Колонки[ИмяПоляКоличества].Итог = "Количество(*)";
		Построитель = Новый ПостроительЗапроса;
		Построитель.ИсточникДанных = ИсточникДанных;
		Если Не Построитель.ДоступныеПоля[ДанныеКолонки].Измерение Тогда 
			Возврат Ложь;
		КонецЕсли; 
		Построитель.ВыбранныеПоля.Добавить(ИмяПоляКоличества);
		Построитель.ВыбранныеПоля.Добавить(ДанныеКолонки);
		Построитель.Порядок.Установить(ДанныеКолонки);
		Если Отбор <> Неопределено Тогда
			ирОбщий.СкопироватьОтборПостроителяЛкс(Построитель.Отбор, ИсточникДействий.ОтборСтрок);
			Построитель.Отбор[ДанныеКолонки].Использование = Ложь;
		КонецЕсли; 
		ЭтаФорма.ОтборИсточникаБезТекущейКолонки = "" + Построитель.Отбор;
		Если Не УчитываяОтбор Тогда
			Построитель.Отбор.Сбросить();
		КонецЕсли;
		ВыборкаРезультата = Построитель.Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, ДанныеКолонки);
		КолонкиТЧ = ОсновнойЭУ.Значение.ВыгрузитьКолонки().Колонки;
		Пока ВыборкаРезультата.Следующий() Цикл
			СтрокаТЧ = ОсновнойЭУ.Значение.Добавить();
			СтрокаТЧ.Количество = ВыборкаРезультата[ИмяПоляКоличества];
			СтрокаТЧ.Значение = ВыборкаРезультата[ДанныеКолонки];
			Если ОтображениеКартинки <> Неопределено Тогда
				ирОбщий.ОбновитьТипЗначенияВСтрокеТаблицыЛкс(СтрокаТЧ,,,,, КолонкиТЧ);
			КонецЕсли;
		КонецЦикла;
		// Антибаг построителя запроса. Иногда сортировку не выполняет
		ОсновнойЭУ.Значение.Сортировать("Значение");
	Иначе	
		КоличествоЗагружаем = 500000;
		//ИсточникДанных = Новый ОписаниеИсточникаДанных(ИсточникДействий.Значение);
		ТекстГДЕ = "";
		////Для Каждого КолонкаИсточника Из ИсточникДанных.Колонки Цикл
		//КомпоновщикОбъектаМД = ирКэш.ПолучитьКомпоновщикТаблицыМетаданныхЛкс(ПолноеИмяМД);
		ПоляТаблицыБД = ирОбщий.ПолучитьПоляТаблицыБДЛкс(ПолноеИмяТаблицы);
		#Если Сервер И Не Сервер Тогда
			ПоляТаблицыБД = ПолучитьСтруктуруХраненияБазыДанных().Колонки;
		#КонецЕсли
		Для Каждого ПолеТаблицыБД Из ПоляТаблицыБД Цикл
			Если ПолеТаблицыБД.ТипЗначения.СодержитТип(Тип("ТаблицаЗначений")) Тогда
				Продолжить;
			КонецЕсли;
			Если ТекстГДЕ <> "" Тогда
				ТекстГДЕ = ТекстГДЕ + ", ";
			КонецЕсли;
			Если Истина
				И ирОбщий.СтрокиРавныЛкс(ПолеТаблицыБД.Имя, ДанныеКолонки)
				И ДоступноеПоле.ТипЗначения.СодержитТип(Тип("Строка"))
				И ДоступноеПоле.ТипЗначения.КвалификаторыСтроки.Длина = 0
			Тогда
				ВыражениеПоля = "ВЫРАЗИТЬ(Т." + ПолеТаблицыБД.Имя + " КАК СТРОКА(100))";	
			Иначе
				ВыражениеПоля = "Т." + ПолеТаблицыБД.Имя;
			КонецЕсли;
			Если ирОбщий.СтрокиРавныЛкс(ПолеТаблицыБД.Имя, ДанныеКолонки) Тогда
				ВыражениеГруппировки = ВыражениеПоля;
				Если ОтображениеКартинки = Неопределено Тогда
					ТекстДопПолей = "";
					ТекстДопГруппировок = "";
				Иначе
					ТекстДопПолей = ", ТипЗначения(" + ВыражениеПоля + ") КАК ТипЗначения";
					ТекстДопГруппировок = ", ТипЗначения(" + ВыражениеПоля + ")";
				КонецЕсли;
			КонецЕсли;
			//ТекстГДЕ = ТекстГДЕ + ВыражениеПоля + ".* КАК " + ПолеТаблицыБД.Имя; // запрещенные имена например "Соединение" так вызывают ошибку
			ТекстГДЕ = ТекстГДЕ + ВыражениеПоля + ".*";
		КонецЦикла;
		Если Не ЗначениеЗаполнено(ВыражениеГруппировки) Тогда
			// Например ИдентификаторСсылкиЛкс
			Возврат Ложь;
		КонецЕсли; 
		ТекстЗапроса = "
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	" + ВыражениеГруппировки + " КАК Значение,
		|	КОЛИЧЕСТВО(*) КАК Количество" + ТекстДопПолей + "
		|ИЗ
		|	" + ПолноеИмяТаблицы + " КАК Т
		|{ГДЕ " + ТекстГДЕ + "}
		|СГРУППИРОВАТЬ ПО
		|	" + ВыражениеГруппировки + ТекстДопГруппировок + "
		|УПОРЯДОЧИТЬ ПО
		|	Значение";
		СхемаКомпоновки = ирОбщий.ПолучитьСхемуКомпоновкиПоЗапросуЛкс(ТекстЗапроса);
		НастройкаКомпоновки = Новый НастройкиКомпоновкиДанных;
		КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
		КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновки));
		Для Каждого ДоступноеПоле Из КомпоновщикНастроек.Настройки.ДоступныеПоляВыбора.Элементы Цикл
			Если Не ДоступноеПоле.Папка Тогда
				ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(НастройкаКомпоновки.Выбор, ДоступноеПоле.Поле);
			КонецЕсли; 
		КонецЦикла;
		ирОбщий.СкопироватьОтборЛюбойЛкс(НастройкаКомпоновки.Отбор, Отбор);
		ЭлементОтбораКолонки = ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(НастройкаКомпоновки.Отбор, ДанныеКолонки);
		Если ЭлементОтбораКолонки <> Неопределено Тогда
			ЭлементОтбораКолонки.Использование = Ложь;
		КонецЕсли; 
		ЭтаФорма.ОтборИсточникаБезТекущейКолонки = "" + НастройкаКомпоновки.Отбор;
		Если Не УчитываяОтбор Тогда
			НастройкаКомпоновки.Отбор.Элементы.Очистить();
		КонецЕсли;
		//Отладить(Запрос);
		Запрос = ирОбщий.ПолучитьЗапросИзКомпоновкиЛкс(СхемаКомпоновки, НастройкаКомпоновки);
		Запрос.Текст = Запрос.Текст + "
		|АВТОУПОРЯДОЧИВАНИЕ";
		РезультатЗапроса = Запрос.Выполнить();
		ВыборкаЗначений = РезультатЗапроса.Выбрать();
		КоличествоВсего = ВыборкаЗначений.Количество();
		Если КоличествоВсего > КоличествоЗагружаем Тогда
			ТекстИнтерфейса = "Количество различных значений составляет " + XMLСтрока(КоличествоВсего) + ", но отображены будут только " + XMLСтрока(КоличествоЗагружаем);
			Предупреждение(ТекстИнтерфейса);
			Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(КоличествоЗагружаем);
			Счетчик = 0;
			Пока ВыборкаЗначений.Следующий() Цикл
				Если Счетчик = КоличествоЗагружаем Тогда
					Прервать;
				КонецЕсли;
				ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
				ЗаполнитьЗначенияСвойств(ОсновнойЭУ.Значение.Добавить(), ВыборкаЗначений);
				Счетчик = Счетчик + 1;
			КонецЦикла;
			ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
		Иначе
			ВыгрузкаРезультата = РезультатЗапроса.Выгрузить();
			ОсновнойЭУ.Значение.Загрузить(ВыгрузкаРезультата);
		КонецЕсли;
	КонецЕсли;
	Если Отбор <> Неопределено Тогда
		Если Ложь
			Или ЭлементОтбора.ВидСравнения = ВидСравнения.НеРавно 
			Или ЭлементОтбора.ВидСравнения = ВидСравнения.НеВСписке 
		Тогда
			Если ЭтоБулеваКолонка() Тогда
				ЭтаФорма.ВидСравненияНовый = ВидСравнения.НеРавно;
			Иначе
				ЭтаФорма.ВидСравненияНовый = ВидСравнения.НеВСписке;
			КонецЕсли; 
		ИначеЕсли Ложь
			Или ЭлементОтбора.ВидСравнения = ВидСравнения.Равно 
			Или ЭлементОтбора.ВидСравнения = ВидСравнения.ВСписке 
		Тогда
			Если ЭтоБулеваКолонка() Тогда
				ЭтаФорма.ВидСравненияНовый = ВидСравнения.Равно;
			Иначе
				ЭтаФорма.ВидСравненияНовый = ВидСравнения.ВСписке;
			КонецЕсли; 
		ИначеЕсли Ложь
			Или ЭлементОтбора.ВидСравнения = ВидСравнения.НеВИерархии 
			Или ЭлементОтбора.ВидСравнения = ВидСравнения.НеВСпискеПоИерархии 
		Тогда
			ЭтаФорма.ВидСравненияНовый = ВидСравнения.НеВСпискеПоИерархии;
		ИначеЕсли Ложь
			Или ЭлементОтбора.ВидСравнения = ВидСравнения.ВИерархии 
			Или ЭлементОтбора.ВидСравнения = ВидСравнения.ВСпискеПоИерархии 
		Тогда
			ЭтаФорма.ВидСравненияНовый = ВидСравнения.ВСпискеПоИерархии;
		Иначе
			Если ЭтоБулеваКолонка() Тогда
				ЭтаФорма.ВидСравненияНовый = ВидСравнения.Равно;
			Иначе
				ЭтаФорма.ВидСравненияНовый = ВидСравнения.ВСписке;
			КонецЕсли; 
		КонецЕсли;
		Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбора") Тогда
			ЗначениеОтбора = ЭлементОтбора.Значение;
		Иначе
			ЗначениеОтбора = ЭлементОтбора.ПравоеЗначение;
		КонецЕсли; 
		Если Истина
			И МассивПомеченных.Количество() = 0
			И ЭлементОтбора.Использование 
		Тогда
			МассивПомеченных = Новый Массив;
			Если Ложь
				Или ЭлементОтбора.ВидСравнения = ВидСравнения.НеРавно 
				Или ЭлементОтбора.ВидСравнения = ВидСравнения.НеВИерархии 
			Тогда
				МассивПомеченных.Добавить(ЗначениеОтбора);
			ИначеЕсли Ложь
				Или ЭлементОтбора.ВидСравнения = ВидСравнения.Равно 
				Или ЭлементОтбора.ВидСравнения = ВидСравнения.ВИерархии 
			Тогда
				МассивПомеченных.Добавить(ЗначениеОтбора);
			ИначеЕсли Ложь
				Или ЭлементОтбора.ВидСравнения = ВидСравнения.НеВСписке 
				Или ЭлементОтбора.ВидСравнения = ВидСравнения.НеВСпискеПоИерархии 
			Тогда
				Для Каждого ЭлементСписка Из ЗначениеОтбора Цикл
					МассивПомеченных.Добавить(ЭлементСписка.Значение);
				КонецЦикла;
			ИначеЕсли Ложь
				Или ЭлементОтбора.ВидСравнения = ВидСравнения.ВСписке 
				Или ЭлементОтбора.ВидСравнения = ВидСравнения.ВСпискеПоИерархии 
			Тогда
				Для Каждого ЭлементСписка Из ЗначениеОтбора Цикл
					МассивПомеченных.Добавить(ЭлементСписка.Значение);
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
		Для Каждого Значение Из МассивПомеченных Цикл
			СтрокаЗначения = ОсновнойЭУ.Значение.Найти(Значение, "Значение");
			Если СтрокаЗначения = Неопределено Тогда
				СтрокаЗначения = ОсновнойЭУ.Значение.Добавить();
				СтрокаЗначения.Значение = Значение;
			КонецЕсли;
			СтрокаЗначения.Пометка = Истина;
		КонецЦикла;
	КонецЕсли; 
	Если ТекущееЗначение = Неопределено Тогда
		Если ИсточникДействий.ТекущиеДанные <> Неопределено Тогда
			Попытка
				ТекущееЗначение = ИсточникДействий.ТекущиеДанные[ДанныеКолонки];
			Исключение
				// Например ДатаИзменения в форме списка архива. Не смог понять, почему ее нет 
				ТекущееЗначение = Неопределено;
			КонецПопытки;
		КонецЕсли;
	КонецЕсли;
	Если ТекущееЗначение <> Неопределено Тогда
		СтрокаЗначения = ОсновнойЭУ.Значение.Найти(ТекущееЗначение, "Значение");
		Если СтрокаЗначения = Неопределено Тогда
			СтрокаЗначения = ОсновнойЭУ.Значение.Добавить();
			СтрокаЗначения.Значение = ТекущееЗначение;
		КонецЕсли;
		ОсновнойЭУ.ТекущаяСтрока = СтрокаЗначения;
	КонецЕсли;
	Возврат Истина;
	
КонецФункции

Процедура УчитываяОтборПриИзменении(Элемент)
	
	ОбновитьДанные();
	
КонецПроцедуры

Процедура ДействияФормыТолькоПомеченные(Кнопка)

	Кнопка = ЭлементыФормы.ДействияФормы.Кнопки.ТолькоПомеченные;
	Кнопка.Пометка = Не Кнопка.Пометка;
	ЭлементОтбора = ЭтаФорма.ЭлементыФормы.Значения.ОтборСтрок.Пометка;
	Если Кнопка.Пометка = Истина Тогда
		ЭлементОтбора.Установить(Истина);
	Иначе
		ЭлементОтбора.Использование = Ложь;
	КонецЕсли;

КонецПроцедуры

Процедура ОсновныеДействияФормыОК(Кнопка = Неопределено)
	
	ДанныеКолонки = ирОбщий.ПутьКДаннымКолонкиТабличногоПоляЛкс(ЭтаФорма.ВладелецФормы);
	Если Не ЗначениеЗаполнено(ДанныеКолонки) Тогда   //Наименование колонки
		Возврат;
	КонецЕсли;
	СписокЭлементовДляОтбора = Новый СписокЗначений;
	Для Каждого ЭлементСписка Из ЭтаФорма.Значения Цикл
		Если ЭлементСписка.Пометка Тогда
			СписокЭлементовДляОтбора.Добавить(ЭлементСписка.Значение);
		КонецЕсли;
	КонецЦикла;
	Если ОтборПользовательский = Неопределено Тогда
		ИсточникДействий = ЭтаФорма.ВладелецФормы;
		// Так выделенные строки не видно из-за отсутствия фокуса у той формы
		//СтрокиЗначения = ИсточникДействий.Значение.НайтиСтроки(Новый Структура(ДанныеКолонки, ЭлементыФормы.Значения.ТекущаяСтрока.Значение));
		//ИсточникДействий.ВыделенныеСтроки.Очистить();
		//Для Каждого СтрокаЗначения Из СтрокиЗначения Цикл
		//	ИсточникДействий.ВыделенныеСтроки.Добавить(СтрокаЗначения);
		//КонецЦикла;
		ЗначениеТабличногоПоля = ирОбщий.ДанныеЭлементаФормыЛкс(ИсточникДействий);
		ТекущаяСтрока = ЗначениеТабличногоПоля.НайтиСтроки(Новый Структура(ДанныеКолонки, ЭлементыФормы.Значения.ТекущаяСтрока.Значение));
		Если ТекущаяСтрока.Количество() > 0 Тогда
			ТекущаяСтрока = ТекущаяСтрока[0];
			Если ТипЗнч(ИсточникДействий) = Тип("ТаблицаФормы") Тогда
				ТекущаяСтрока = ТекущаяСтрока.ПолучитьИдентификатор();
			КонецЕсли; 
			ИсточникДействий.ТекущаяСтрока = ТекущаяСтрока;
		КонецЕсли; 
		Возврат;
	КонецЕсли; 
	Если ТипЗнч(ОтборПользовательский) = Тип("Отбор") Тогда
		ЭлементОтбора = ОтборПользовательский[ДанныеКолонки];
		ДоступноеПоле = ЭлементОтбора;
	Иначе
		#Если Сервер И Не Сервер Тогда
		    Пустышка = Новый НастройкиКомпоновкиДанных;
			ОтборПользовательский = Пустышка.Отбор;
		#КонецЕсли
		ЭлементОтбора = ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(ОтборПользовательский, ДанныеКолонки,,,,, Ложь);
		ДоступноеПоле = ОтборПользовательский.ДоступныеПоляОтбора.НайтиПоле(Новый ПолеКомпоновкиДанных(ДанныеКолонки));
	КонецЕсли; 
	Если Истина
		И ДоступноеПоле.ТипЗначения.СодержитТип(Тип("Строка"))
		И ДоступноеПоле.ТипЗначения.КвалификаторыСтроки.Длина = 0
	Тогда
		Сообщить("Установка такого отбора недопустима для строки неограниченной длины");
	Иначе
		Если СписокЭлементовДляОтбора.Количество() = 0 Тогда
			Ответ = Вопрос("Не выбрано ни одного элемента списка. Хотите отключить отбор по колонке?", РежимДиалогаВопрос.ОКОтмена);
			Если Ответ = КодВозвратаДиалога.ОК Тогда
				ЭлементОтбора.Использование = Ложь;
				ЭтаФорма.Закрыть();
				Возврат;
			КонецЕсли;
		КонецЕсли; 
		Если ЭтоБулеваКолонка() И СписокЭлементовДляОтбора.Количество() > 0 Тогда
			СписокЭлементовДляОтбора = СписокЭлементовДляОтбора[0].Значение;
			Если ТипЗнч(СписокЭлементовДляОтбора) <> Тип("Булево") Тогда
				Сообщить("Установка такого отбора недопустима для булево типа");
				Возврат;
			КонецЕсли; 
		КонецЕсли;
		Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбора") Тогда
			ЭлементОтбора.ВидСравнения = ЭтаФорма.ВидСравненияНовый;
			ЭлементОтбора.Значение = СписокЭлементовДляОтбора;
		Иначе
			мПлатформа = ирКэш.Получить();
			#Если Сервер И Не Сервер Тогда
				мПлатформа = Обработки.ирПлатформа.Создать()
			#КонецЕсли
			СтрокаВидаСравнения = мПлатформа.СоответствиеВидовСравнения.Найти(ЭтаФорма.ВидСравненияНовый, "Построитель");
			лВидСравнения = СтрокаВидаСравнения.Компоновка;
			ЭлементОтбора.ВидСравнения = лВидСравнения;
			ЭлементОтбора.ПравоеЗначение = СписокЭлементовДляОтбора;
		КонецЕсли; 
		Успех = Истина;
		Если Успех Тогда
			ЭлементОтбора.Использование = Ложь; 
			ЭлементОтбора.Использование = Истина;
			ЭтаФорма.Закрыть();
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗначенияВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если Отбор <> Неопределено Тогда
		Если ЭтоБулеваКолонка() Тогда
			Для Каждого СтрокаЗначения Из Значения Цикл
				СтрокаЗначения.Пометка = Ложь;
			КонецЦикла;
		КонецЕсли; 
		ЭлементыФормы.Значения.ТекущаяСтрока.Пометка = Истина;
	КонецЕсли; 
	ОсновныеДействияФормыОК();
	
КонецПроцедуры

Процедура ДействияФормыИдентификаторы(Кнопка)
	
	ирОбщий.КнопкаОтображатьПустыеИИдентификаторыНажатиеЛкс(Кнопка);
	ЭлементыФормы.Значения.ОбновитьСтроки();
	
КонецПроцедуры

Процедура ЗначенияПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(Элемент, ОформлениеСтроки, ДанныеСтроки, ЭлементыФормы.ДействияФормы.Кнопки.Идентификаторы);

КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	Строки = ЭтаФорма.Значения.НайтиСтроки(Новый Структура("Пометка", Истина));
	//Текст = "";
	//МаксимальноеЧисло = 5;
	//Счетчик = 0;
	//Для Каждого СтрокаЗначения Из Строки Цикл
	//	Если Текст <> "" Тогда
	//		Текст = Текст + ",";
	//	КонецЕсли;
	//	Текст = Текст + СтрокаЗначения.Значение;
	//	Счетчик = Счетчик + 1;
	//	Если МаксимальноеЧисло = Счетчик Тогда
	//		Текст = Текст + ",...";
	//		Прервать;
	//	КонецЕсли;
	//КонецЦикла;
	//ЭтаФорма.ЭлементыФормы.ПредставлениеВыбранных.Заголовок = Текст;
	ЭтаФорма.КоличествоВсего = ЭтаФорма.Значения.Количество();
	ЭтаФорма.КоличествоВыбранных = Строки.Количество();

КонецПроцедуры

Процедура ДействияФормыСнятьВсеПометки(Кнопка)
	
	ирОбщий.ИзменитьПометкиВыделенныхСтрокЛкс(ЭлементыФормы.Значения, , Ложь);
	
КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	ИсточникДействий = ЭтаФорма.ВладелецФормы;
	ДанныеКолонки = ирОбщий.ПутьКДаннымКолонкиТабличногоПоляЛкс(ИсточникДействий);
	Если Не ЗначениеЗаполнено(ДанныеКолонки) Тогда   //Наименование колонки
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	ЭтаФорма.Значения.Очистить();
	ЭтаФорма.УчитываяОтбор = Истина;
	Если Не ОбновитьДанные() Тогда 
		Отказ = Истина;
		Возврат;
	КонецЕсли; 
	СписокВыбора = ЭтаФорма.ЭлементыФормы.ВидСравненияНовый.СписокВыбора;
	СписокВыбора.Очистить();
	#Если Сервер И Не Сервер Тогда
	    мОписаниеТиповКолонки = Новый ОписаниеТипов;
	#КонецЕсли
	Если ЭтоБулеваКолонка() Тогда
		СписокВыбора.Добавить(ВидСравнения.Равно);
		СписокВыбора.Добавить(ВидСравнения.НеРавно);
		ЭлементыФормы.Значения.Колонки.Пометка.ТолькоПросмотр = Истина;
	Иначе
		СписокВыбора.Добавить(ВидСравнения.ВСписке);
		СписокВыбора.Добавить(ВидСравнения.ВСпискеПоИерархии);
		СписокВыбора.Добавить(ВидСравнения.НеВСписке);
		СписокВыбора.Добавить(ВидСравнения.НеВСпискеПоИерархии);
	КонецЕсли; 
	Если ТипЗнч(ИсточникДействий) = Тип("ТабличноеПоле") Тогда
		ПредставлениеКолонки = ИсточникДействий.ТекущаяКолонка.ТекстШапки;
	Иначе
		ПредставлениеКолонки = ИсточникДействий.ТекущийЭлемент.Заголовок;
	КонецЕсли; 
	ирОбщий.ОбновитьТекстПослеМаркераВСтрокеЛкс(ЭтаФорма.Заголовок,, ПредставлениеКолонки, " - ");

КонецПроцедуры

Функция ЭтоБулеваКолонка()
	
	Возврат Истина
		И мОписаниеТиповКолонки.Типы().Количество() = 1
		И мОписаниеТиповКолонки.СодержитТип(Тип("Булево"));

КонецФункции

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ДействияФормыРазличныеТипЗначений(Кнопка)
	
	ТабличноеПоле = ЭлементыФормы.Значения;
	ТабличноеПоле.ТекущаяКолонка = ТабличноеПоле.Колонки.ТипЗначения;
	ирОбщий.ОткрытьРазличныеЗначенияКолонкиЛкс(ТабличноеПоле);
	
КонецПроцедуры

Процедура ДействияФормыОбработатьОбъекты(Кнопка)
	
	Если МодальныйРежим Тогда
		Закрыть();
	КонецЕсли; 
	ирОбщий.ОткрытьОбъектыИзВыделенныхЯчеекВПодбореИОбработкеОбъектовЛкс(ЭлементыФормы.Значения, "Значение");
	
КонецПроцедуры

Процедура ДействияФормыВСписок(Кнопка)
	
	Список = Новый СписокЗначений;
	Список.ТипЗначения = мОписаниеТиповКолонки;
	Для Каждого ВыделеннаяСтрока Из ЭлементыФормы.Значения.ВыделенныеСтроки Цикл
		Список.Добавить(ВыделеннаяСтрока.Значение,, ВыделеннаяСтрока.Пометка);
	КонецЦикла;
	ирОбщий.ОткрытьЗначениеЛкс(Список,,,, Ложь);
	
КонецПроцедуры

Процедура ДействияФормыОткрытьТип(Кнопка)
	
	Если ЭлементыФормы.Значения.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ирОбщий.ОткрытьЗначениеЛкс(Тип(ЭлементыФормы.Значения.ТекущаяСтрока.ИмяТипаЗначения), Ложь);
	
КонецПроцедуры

Процедура ДействияФормыРедакторОбъектаБД(Кнопка)
	
	Если ЭлементыФормы.Значения.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ирОбщий.ОткрытьЗначениеЛкс(ЭлементыФормы.Значения.ТекущаяСтрока.Значение);
	
КонецПроцедуры

Процедура ДействияФормыМенеджерТабличногоПоля(Кнопка)
	
	ирОбщий.ОткрытьМенеджерТабличногоПоляЛкс(ЭлементыФормы.Значения, ЭтаФорма);
	
КонецПроцедуры

//ирПортативный #Если Клиент Тогда
//ирПортативный Контейнер = Новый Структура();
//ирПортативный Оповестить("ирПолучитьБазовуюФорму", Контейнер);
//ирПортативный Если Не Контейнер.Свойство("ирПортативный", ирПортативный) Тогда
//ирПортативный 	ПолноеИмяФайлаБазовогоМодуля = ирОбщий.ВосстановитьЗначениеЛкс("ирПолноеИмяФайлаОсновногоМодуля");
//ирПортативный 	ирПортативный = ВнешниеОбработки.ПолучитьФорму(ПолноеИмяФайлаБазовогоМодуля);
//ирПортативный КонецЕсли; 
//ирПортативный ирОбщий = ирПортативный.ПолучитьОбщийМодульЛкс("ирОбщий");
//ирПортативный ирКэш = ирПортативный.ПолучитьОбщийМодульЛкс("ирКэш");
//ирПортативный ирСервер = ирПортативный.ПолучитьОбщийМодульЛкс("ирСервер");
//ирПортативный ирПривилегированный = ирПортативный.ПолучитьОбщийМодульЛкс("ирПривилегированный");
//ирПортативный #КонецЕсли

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирРазличныеЗначенияКолонки.Форма.Форма");


