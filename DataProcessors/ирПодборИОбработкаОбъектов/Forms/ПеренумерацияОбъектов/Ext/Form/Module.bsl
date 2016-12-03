﻿//Признак использования настроек
Перем мИспользоватьНастройки Экспорт;

//Типы объектов, для которых может использоваться обработка.
//По умолчанию для всех.
Перем мТипыОбрабатываемыхОбъектов Экспорт;

Перем мНастройка;

Перем мИмяТипаОбъектов;
Перем мТипНомера;
Перем мДлинаНомера;

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Определяет и устанавливает Тип и Длинну номера объекта
//
// Параметры:
//  Нет.
//
Процедура вОпределитьТипИДлиннуНомера(Отказ)
	
	Если ЭтаФорма.ВладелецФормы = Неопределено Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли; 
	
	ОбъектПоиска = ЭтаФорма.ВладелецФормы.мИскомыйОбъект;
	мИмяТипаОбъектов = ОбъектПоиска.КорневойТип;
	мМетаОбъект = ОбъектПоиска.МетаОбъект;
	
	Если Ложь
		Или мИмяТипаОбъектов = "Справочник"
		Или мИмяТипаОбъектов = "ПланВидовХарактеристик" 
	Тогда
		Если мИмяТипаОбъектов = "Справочник" Тогда
			мИмяТипаНомера = "ТипКода";
		Иначе
			мИмяТипаНомера = "";
		КонецЕсли;
		мИмяДлиныНомера = "ДлинаКода";
	ИначеЕсли Ложь
		Или мИмяТипаОбъектов = "Задача"
		Или мИмяТипаОбъектов = "Документ"
		Или мИмяТипаОбъектов = "БизнесПроцесс" 
	Тогда
		мИмяТипаНомера = "ТипНомера";
		мИмяДлиныНомера = "ДлинаНомера";
	КонецЕсли; 
	
	Если ТипЗнч(мМетаОбъект) = Тип("Массив") Тогда
		ТаблицаЗначений = Новый ТаблицаЗначений();
		Если ЗначениеЗаполнено(мИмяТипаНомера) Тогда
			ТаблицаЗначений.Колонки.Добавить(мИмяТипаНомера);
		КонецЕсли;
		ТаблицаЗначений.Колонки.Добавить(мИмяДлиныНомера);
		
		Для Каждого ЭлементМассива Из мМетаОбъект Цикл
			НоваяСтрока = ТаблицаЗначений.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ЭлементМассива);
		КонецЦикла;
		
		Если ЗначениеЗаполнено(мИмяТипаНомера) Тогда
			КолонкиГруппировок = мИмяТипаНомера + ", " + мИмяДлиныНомера;
		Иначе
			КолонкиГруппировок = мИмяДлиныНомера;
		КонецЕсли;
		ТаблицаЗначений.Свернуть(КолонкиГруппировок);
		
		Если ТаблицаЗначений.Количество() > 1 Тогда
			Отказ = Истина;
			Возврат;
		Иначе
			СтрокаТаблицыЗначений = ТаблицаЗначений.Получить(0);
			Если ЗначениеЗаполнено(мИмяТипаНомера) Тогда
				мТипНомера = Строка(СтрокаТаблицыЗначений[мИмяТипаНомера]);
			Иначе
				мТипНомера = "Строка";
			КонецЕсли;	
			мДлинаНомера = СтрокаТаблицыЗначений[мИмяДлиныНомера];
		КонецЕсли;
	Иначе
		Если ЗначениеЗаполнено(мИмяТипаНомера) Тогда
			мТипНомера = Строка(ОбъектПоиска.МетаОбъект[мИмяТипаНомера]);
		Иначе
			мТипНомера = "Строка";
		КонецЕсли;
		мДлинаНомера = ОбъектПоиска.МетаОбъект[мИмяДлиныНомера];
	КонецЕсли;
	
КонецПроцедуры // () 

// Выполняет обработку объектов.
//
// Параметры:
//  Нет.
//
Функция вВыполнитьОбработку() Экспорт
	
	Если Ложь
		Или Не ЗначениеЗаполнено(мТипНомера)
		Или Не ЗначениеЗаполнено(мДлинаНомера) 
	Тогда
		Отказ = Ложь;
		вОпределитьТипИДлиннуНомера(Отказ);
		Если Отказ Тогда
			Возврат 0;
		КонецЕсли;
	КонецЕсли;

	Если (СпособОбработкиПрефиксов = 1) И (НеИзменятьЧисловуюНумерацию) Тогда
		Возврат 0;
	КонецЕсли;
	
	Если (НачальныйНомер = 0) И (Не НеИзменятьЧисловуюНумерацию) Тогда
		Предупреждение("Измените начальный номер!");
		Возврат 0;
	КонецЕсли;
	
	Если Не НеИзменятьЧисловуюНумерацию Тогда 
		ЧисловаяЧастьНомера = НачальныйНомер;
	КонецЕсли;

	НеУникальныеНомера = Новый Соответствие;
	МаксимальныйНомер  = Число(вДополнитьСтрокуСимволами("", мДлинаНомера, "9"));
	
	//--------------------------------------------------------------------------------------------------
	
	Если ОбщаяТранзакция Тогда
		НачатьТранзакцию();
	КонецЕсли;
	Попытка
		СтрокиДляОбработки = НайденныеОбъекты.НайтиСтроки(Новый Структура(мИмяКолонкиПометки, Истина));
		КоличествоОбъектов = СтрокиДляОбработки.Количество();
		Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(КоличествоОбъектов);
		Для Сч = 0 По КоличествоОбъектов - 1 Цикл
			ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
			Строка = СтрокиДляОбработки.Получить(Сч);
			Объект = Строка.Ссылка.ПолучитьОбъект();
			Объект.ОбменДанными.Загрузка = ОтключатьКонтрольЗаписи;
			Сообщить("Обработка объекта " + Объект);
			
			//Здесь может быть написан произвольный алгоритм обработки объектов.
		
			Если мТипНомера = "Число" Тогда 
				Если Не НеИзменятьЧисловуюНумерацию Тогда
					Если Ложь
						Или мИмяТипаОбъектов = "Задача"
						Или мИмяТипаОбъектов = "Документ"
						Или мИмяТипаОбъектов = "БизнесПроцесс"
					Тогда
						Объект.Номер = ЧисловаяЧастьНомера;
					Иначе
						Объект.Код = ЧисловаяЧастьНомера;
					КонецЕсли; 
					Попытка
						Объект.Записать();
					Исключение
						Если Ложь
							Или мИмяТипаОбъектов = "Задача"
							Или мИмяТипаОбъектов = "Документ"
							Или мИмяТипаОбъектов = "БизнесПроцесс"
						Тогда
							Объект.Номер = МаксимальныйНомер - Сч;
						Иначе
							Объект.Код = МаксимальныйНомер - Сч;
						КонецЕсли; 
						Объект.Записать();
						НеУникальныеНомера.Вставить(ЧисловаяЧастьНомера, Объект.Ссылка);
					КонецПопытки;		
					ЧисловаяЧастьНомера = ЧисловаяЧастьНомера + 1;
				КонецЕсли;
				Продолжить;
			КонецЕсли;

			Если Ложь
				Или мИмяТипаОбъектов = "Задача"
				Или мИмяТипаОбъектов = "Документ"
				Или мИмяТипаОбъектов = "БизнесПроцесс"
			Тогда
				ТекНомер = СокрЛП(Объект.Номер);
			Иначе
				ТекНомер = СокрЛП(Объект.Код);
			КонецЕсли;
			
			Если НеИзменятьЧисловуюНумерацию Тогда
				СтроковаяЧастьНомера = вПолучитьПрефиксЧислоНомера(ТекНомер, ЧисловаяЧастьНомера);
			Иначе
				СтроковаяЧастьНомера = вПолучитьПрефиксЧислоНомера(ТекНомер);
			КонецЕсли;				
			

			Если 	  СпособОбработкиПрефиксов = 1 Тогда
				НовыйНомер = СтроковаяЧастьНомера;
			ИначеЕсли СпособОбработкиПрефиксов = 2 Тогда
				НовыйНомер = СокрЛП(СтрокаПрефикса);
			ИначеЕсли СпособОбработкиПрефиксов = 3 Тогда
				НовыйНомер = СокрЛП(СтрокаПрефикса) + СтроковаяЧастьНомера;
			ИначеЕсли СпособОбработкиПрефиксов = 4 Тогда
				НовыйНомер = СтроковаяЧастьНомера + СокрЛП(СтрокаПрефикса);
			ИначеЕсли СпособОбработкиПрефиксов = 5 Тогда
				НовыйНомер = СтрЗаменить(СтроковаяЧастьНомера, СокрЛП(ЗаменяемаяПодстрока), СокрЛП(СтрокаПрефикса));
			КонецЕсли;
			
			Пока мДлинаНомера - СтрДлина(НовыйНомер) - СтрДлина(Формат(ЧисловаяЧастьНомера,"ЧГ=0")) > 0 Цикл
				НовыйНомер = НовыйНомер + "0";
			КонецЦикла;
			
			НовыйНомер = НовыйНомер + Формат(ЧисловаяЧастьНомера,"ЧГ=0");

			Если Ложь
				Или мИмяТипаОбъектов = "Задача"
				Или мИмяТипаОбъектов = "Документ"
				Или мИмяТипаОбъектов = "БизнесПроцесс"
			Тогда
				Объект.Номер = НовыйНомер;
			Иначе
				Объект.Код = НовыйНомер;
			КонецЕсли; 
			
			Попытка
				Объект.Записать();
			Исключение
				Если Ложь
					Или мИмяТипаОбъектов = "Задача"
					Или мИмяТипаОбъектов = "Документ"
					Или мИмяТипаОбъектов = "БизнесПроцесс"
				Тогда
					Объект.Номер = Формат(МаксимальныйНомер - Сч, "ЧГ=0");
				Иначе
					Объект.Код = Формат(МаксимальныйНомер - Сч, "ЧГ=0");
				КонецЕсли; 
				Объект.Записать();			
				НеУникальныеНомера.Вставить(НовыйНомер, Объект.Ссылка);
			КонецПопытки;		
			Если Не НеИзменятьЧисловуюНумерацию Тогда
				ЧисловаяЧастьНомера = ЧисловаяЧастьНомера + 1;
			КонецЕсли;
		КонецЦикла;
		ирОбщий.ОсвободитьИндикаторПроцессаЛкс(, Истина);
		Для каждого Зн Из НеУникальныеНомера Цикл
			НовыйНомер   = Зн.Ключ;
			Объект       = Зн.Значение.ПолучитьОбъект();
			Объект.ОбменДанными.Загрузка = ОтключатьКонтрольЗаписи;
			Если Ложь
				Или мИмяТипаОбъектов = "Задача"
				Или мИмяТипаОбъектов = "Документ"
				Или мИмяТипаОбъектов = "БизнесПроцесс"
			Тогда
				Объект.Номер = НовыйНомер;
			Иначе
				Объект.Код = НовыйНомер;
			КонецЕсли; 
			Попытка
				Объект.Записать();
			Исключение
				Сообщить("Повтор номера: " + НовыйНомер + " за пределами данной выборки!");
			КонецПопытки;		
		КонецЦикла;
	Исключение
		Если ОбщаяТранзакция Тогда
			ОтменитьТранзакцию();
		КонецЕсли;
		ВызватьИсключение;
	КонецПопытки;
	Если ОбщаяТранзакция Тогда
		ЗафиксироватьТранзакцию();
	КонецЕсли;

	Возврат Сч;

КонецФункции // вВыполнитьОбработку()

// Сохраняет значения реквизитов формы.
//
// Параметры:
//  Нет.
//
Процедура вСохранитьНастройку() Экспорт

	Если ПустаяСтрока(ЭлементыФормы.ТекущаяНастройка) Тогда
		Предупреждение("Задайте имя новой настройки для сохранения или выберите существующую настройку для перезаписи.");
	КонецЕсли;

    НоваяНастройка = Новый Структура();
	
	Для каждого РеквизитНастройки из мНастройка Цикл
		Выполнить("НоваяНастройка.Вставить(Строка(РеквизитНастройки.Ключ), " + Строка(РеквизитНастройки.Ключ) + ");");
	КонецЦикла;

	Если      ТекущаяНастройка.Родитель = Неопределено Тогда
		
		НоваяСтрока = ТекущаяНастройка.Строки.Добавить();
		НоваяСтрока.Обработка = ЭлементыФормы.ТекущаяНастройка.Значение;
		ТекущаяНастройка = НоваяСтрока;
		ЭтаФорма.ВладелецФормы.ЭлементыФормы.ДоступныеОбработки.ТекущаяСтрока = НоваяСтрока;
		
	ИначеЕсли НЕ ТекущаяНастройка.Обработка = ЭлементыФормы.ТекущаяНастройка.Значение Тогда
		
		НоваяСтрока           = ТекущаяНастройка.Родитель.Строки.Добавить();
		НоваяСтрока.Обработка = ЭлементыФормы.ТекущаяНастройка.Значение;
		ТекущаяНастройка      = НоваяСтрока;
		ЭтаФорма.ВладелецФормы.ЭлементыФормы.ДоступныеОбработки.ТекущаяСтрока = НоваяСтрока;
		
	КонецЕсли;
	
	ТекущаяНастройка.Настройка = НоваяНастройка;

	ЭтаФорма.Модифицированность = Ложь;

КонецПроцедуры // вСохранитьНастройку()

// Восстанавливает сохраненные значения реквизитов формы.
//
// Параметры:
//  Нет.
//
Процедура вЗагрузитьНастройку() Экспорт

	Если Ложь
		Или ТекущаяНастройка = Неопределено
		Или ТекущаяНастройка.Родитель = Неопределено 
	Тогда
		вУстановитьИмяНастройки("Новая настройка");
	Иначе
        Если НЕ ТекущаяНастройка.Настройка = Неопределено Тогда
			мНастройка = ТекущаяНастройка.Настройка;
		КонецЕсли;
	КонецЕсли;

	Для каждого РеквизитНастройки из мНастройка Цикл
        Значение = мНастройка[РеквизитНастройки.Ключ];
		Выполнить(Строка(РеквизитНастройки.Ключ) + " = Значение;");
	КонецЦикла;
    
	СпособОбработкиПрефиксовПриИзменении("");
	НеИзменятьЧисловуюНумерациюПриИзменении("");

КонецПроцедуры //вЗагрузитьНастройку()

// Устанавливает значение реквизита "ТекущаяНастройка" по имени настройки или произвольно.
//
// Параметры:
//  ИмяНастройки   - произвольное имя настройки, которое необходимо установить.
//
Процедура вУстановитьИмяНастройки(ИмяНастройки = "") Экспорт

	Если ПустаяСтрока(ИмяНастройки) Тогда
		Если ТекущаяНастройка = Неопределено Тогда
			ЭлементыФормы.ТекущаяНастройка.Значение = "";
		Иначе
			ЭлементыФормы.ТекущаяНастройка.Значение = ТекущаяНастройка.Обработка;
		КонецЕсли;
	Иначе
		ЭлементыФормы.ТекущаяНастройка.Значение = ИмяНастройки;
	КонецЕсли;

КонецПроцедуры // вУстановитьИмяНастройки()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Процедура - обработчик события "ПередОткрытием" формы.
//
Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	вОпределитьТипИДлиннуНомера(Отказ);
	
	Если НЕ Отказ Тогда
		Если мТипНомера <> "Строка" Тогда
			ЭлементыФормы.Панель1.Видимость = Ложь; 
		КонецЕсли;
		
		Если мИспользоватьНастройки Тогда
			вУстановитьИмяНастройки();
			вЗагрузитьНастройку();
		Иначе
			ЭлементыФормы.ТекущаяНастройка.Доступность = Ложь;
			ЭлементыФормы.ОсновныеДействияФормы.Кнопки.СохранитьНастройку.Доступность = Ложь;
		КонецЕсли;
	Иначе
		Сообщить("Для этой выборки обработка неприменима");
	КонецЕсли;
	
КонецПроцедуры // ПередОткрытием()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ, ВЫЗЫВАЕМЫЕ ИЗ ЭЛЕМЕНТОВ ФОРМЫ

// Обработчик действия "НачалоВыбораИзСписка" реквизита "ТекущаяНастройка".
//
Процедура ТекущаяНастройкаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)

	Элемент.СписокВыбора.Очистить();

	Если ТекущаяНастройка.Родитель = Неопределено Тогда
		КоллекцияСтрок = ТекущаяНастройка.Строки;
	Иначе
		КоллекцияСтрок = ТекущаяНастройка.Родитель.Строки;
	КонецЕсли;

	Для каждого Строка из КоллекцияСтрок Цикл
		Элемент.СписокВыбора.Добавить(Строка, Строка.Обработка);
	КонецЦикла;

КонецПроцедуры // ТекущаяНастройкаНачалоВыбораИзСписка()

// Обработчик действия "ОбработкаВыбора" реквизита "ТекущаяНастройка".
//
Процедура ТекущаяНастройкаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	Если Истина
		И НЕ ТекущаяНастройка = ВыбранноеЗначение
		И Элемент.СписокВыбора.НайтиПоЗначению(ВыбранноеЗначение) <> Неопределено
	Тогда

		Если ЭтаФорма.Модифицированность Тогда
			Если Вопрос("Сохранить текущую настройку?", РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Да) = КодВозвратаДиалога.Да Тогда
				вСохранитьНастройку();
			КонецЕсли;
		КонецЕсли;

		ТекущаяНастройка = ВыбранноеЗначение;
		вУстановитьИмяНастройки();

		вЗагрузитьНастройку();

	КонецЕсли;

КонецПроцедуры // ТекущаяНастройкаОбработкаВыбора()

// Обработчик действия "Выполнить" командной панели "ОсновныеДействияФормы".
//
Процедура ОсновныеДействияФормыВыполнить(Кнопка)

	ОбработаноОбъектов = вВыполнитьОбработку();

	Предупреждение("Обработка <" + СокрЛП(ЭтаФорма.Заголовок) + "> завершена!
                   |Обработано объектов: " + ОбработаноОбъектов + ".");

КонецПроцедуры // ОсновныеДействияФормыВыполнить()

// Обработчик действия "СохранитьНастройку" командной панели "ОсновныеДействияФормы".
//
Процедура ОсновныеДействияФормыСохранитьНастройку(Кнопка)

	вСохранитьНастройку();

КонецПроцедуры // ОсновныеДействияФормыСохранитьНастройку()

// Обработчик события "ПриИзменении" элемена формы "НеИзменятьЧисловуюНумерацию"
//
Процедура НеИзменятьЧисловуюНумерациюПриИзменении(Элемент)
	
	Если НеИзменятьЧисловуюНумерацию = 1 Тогда 
		ЭлементыФормы.НачальныйНомер.Доступность = Ложь;
	Иначе 
		ЭлементыФормы.НачальныйНомер.Доступность = Истина;
	КонецЕсли;	    
	
КонецПроцедуры

// Обработчик события "ПриИзменении" элемена формы "СпособОбработкиПрефиксов"
//
Процедура СпособОбработкиПрефиксовПриИзменении(Элемент)

	Если СпособОбработкиПрефиксов = 1 Тогда 
		ЭлементыФормы.СтрокаПрефикса.Доступность      = Ложь;
		ЭлементыФормы.ЗаменяемаяПодстрока.Доступность = Ложь;
	ИначеЕсли СпособОбработкиПрефиксов = 5 Тогда 
		ЭлементыФормы.СтрокаПрефикса.Доступность      = Истина;
		ЭлементыФормы.ЗаменяемаяПодстрока.Доступность = Истина;
	Иначе
		ЭлементыФормы.СтрокаПрефикса.Доступность      = Истина;
		ЭлементыФормы.ЗаменяемаяПодстрока.Доступность = Ложь;
    КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ИНИЦИАЛИЗАЦИЯ МОДУЛЬНЫХ ПЕРЕМЕННЫХ

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирПодборИОбработкаОбъектов.Форма.ПеренумерацияОбъектов");
мИспользоватьНастройки = Истина;

//Реквизиты настройки и значения по умолчанию.
мНастройка = Новый Структура("НачальныйНомер,НеИзменятьЧисловуюНумерацию,СтрокаПрефикса,ЗаменяемаяПодстрока,СпособОбработкиПрефиксов");

мНастройка.НачальныйНомер              = 1;
мНастройка.НеИзменятьЧисловуюНумерацию = Ложь;
мНастройка.СпособОбработкиПрефиксов    = 1;

мТипыОбрабатываемыхОбъектов = Неопределено;
