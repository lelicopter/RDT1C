﻿Перем мВыборкаРезультатаСтрокиТаблицы;
Перем ПараметрОтбор Экспорт;
Перем СтарыйОтбор;
Перем мСтруктураХраненияСРазмерами;

Функция СохраняемаяНастройкаФормы(выхНаименование, выхИменаСвойств) Экспорт 
	выхИменаСвойств = "Форма.УчитыватьВсеКолонкиТаблицИзменений, Форма.ВидСравненияНовый, Форма.ФильтрИменТаблиц, Форма.ФильтрИменКолонок, Форма.ИмяСиноним, Форма.ТолькоПростойТип, Форма.ТипБулевоЕсть, Форма.ТипДатаЕсть, Форма.ТипСтрокаЕсть, Форма.ТипЧислоЕсть, Форма.ТипСсылкаВнешняяЕсть, Форма.ТипСсылкаЛокальнаяЕсть, Форма.ТипУникальныйИдентификаторЕсть, Форма.ТипХранилищеЗначенияЕсть, Форма.ТипНеопределеноЕсть";
	Возврат Неопределено;
КонецФункции

Процедура ЗагрузитьНастройкуВФорме(НастройкаФормы, ДопПараметры) Экспорт 
	
	ирКлиент.ЗагрузитьНастройкуФормыЛкс(ЭтаФорма, НастройкаФормы); 
	ОбновитьОтборОтображения();

КонецПроцедуры

Процедура ПриОткрытии()
	
	ирКлиент.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ирКлиент.СоздатьМенеджерСохраненияНастроекФормыЛкс(ЭтаФорма);
	Если КлючУникальности = Неопределено И мПлатформа.мКолонкиБД <> Неопределено Тогда
		ЭтаФорма.ОбработкаОбъект = мПлатформа.мКолонкиБД;
	КонецЕсли; 
	ирКлиент.ПоследниеВыбранныеЗаполнитьПодменюЛкс(ЭтаФорма, ЭлементыФормы.ДействияФормы.Кнопки.ПоследниеВыбранные, ЭлементыФормы.КолонкиБД);
	// ЭлементыФормы.ДействияФормы.Кнопки.ТолькоВыбранные.Пометка
	ЭлементыФормы.КолонкиБД.Колонки.Пометка.Видимость = РежимВыбора;
	Если ПараметрОтбор <> Неопределено Тогда
		Для Каждого КлючИЗначение Из ПараметрОтбор Цикл
			ирОбщий.УстановитьЭлементОтбораЛкс(ЭлементыФормы.КолонкиБД.ОтборСтрок[КлючИЗначение.Ключ],, КлючИЗначение.Значение);
			ЭлементыФормы.КолонкиБД.НастройкаОтбораСтрок[КлючИЗначение.Ключ].Доступность = Ложь;
		КонецЦикла;
	КонецЕсли;
	Если РежимВыбора Тогда
		ЭтаФорма.Заголовок = ЭтаФорма.Заголовок + " (выбор)";
		СброситьПометкиУПомеченных();
	КонецЕсли; 
	Если КлючУникальности <> Неопределено Тогда
		ирОбщий.ОбновитьТекстПослеМаркераВСтрокеЛкс(ЭтаФорма.Заголовок,, КлючУникальности, ": ");
		//ЭлементыФормы.КолонкиБД.Колонки.ИмяТаблицы.Видимость = Ложь;
		//ЭлементыФормы.КолонкиБД.Колонки.ПредставлениеТаблицы.Видимость = Ложь;
		//ЭлементыФормы.КолонкиБД.Колонки.ПолноеИмяТаблицы.Видимость = Ложь;
	КонецЕсли; 
	ОбновитьПодменюПоследнихОтборов();
	ДействияФормыЗаполнитьТаблицу();
	
КонецПроцедуры

Процедура ДействияФормыЗаполнитьТаблицу(Кнопка = Неопределено, Знач РазрешитьАсинхронно = Истина)
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("ПолноеИмяТаблицыБД", КлючУникальности);
	#Если Сервер И Не Сервер Тогда
		ЗаполнитьТаблицуКолонок();
		ЗаполнитьТаблицуКолонокЗавершение();
	#КонецЕсли
	ПараметрыЗадания.Вставить("ВыполнятьНаСервере", РазрешитьАсинхронно <> Ложь И КлючУникальности = Неопределено И КолонкиБД.Количество() = 0);
	ирОбщий.ВыполнитьЗаданиеФормыЛкс("ЗаполнитьТаблицуКолонок", ПараметрыЗадания, ЭтаФорма,,,
		ЭлементыФормы.ДействияФормы.Кнопки.ЗаполнитьТаблицу, "ЗаполнитьТаблицуКолонокЗавершение",,, Истина);
КонецПроцедуры

Процедура ЗаполнитьТаблицуКолонокЗавершение(СостояниеЗадания = Неопределено, РезультатЗадания = Неопределено) Экспорт 
	
	Если Ложь
		Или СостояниеЗадания = Неопределено
		Или СостояниеЗадания = СостояниеФоновогоЗадания.Завершено 
	Тогда
		Если СостояниеЗадания <> Неопределено Тогда
			КолонкиБД.Загрузить(РезультатЗадания.КолонкиБД);
		КонецЕсли; 
		Если КлючУникальности = Неопределено Тогда
			мПлатформа.мКолонкиБД = ЭтотОбъект;
		КонецЕсли;
		ЭтаФорма.КоличествоСтрок = КолонкиБД.Количество();
		ЭлементыФормы.ДействияФормы.Кнопки.Удалить(ЭлементыФормы.ДействияФормы.Кнопки.ЗаполнитьТаблицу);
		Если РежимВыбора Тогда
			Если НачальноеЗначениеВыбора <> Неопределено Тогда
				Если ТипЗнч(НачальноеЗначениеВыбора) = Тип("Массив") Тогда 
					МассивКлючей = НачальноеЗначениеВыбора;
					ЭтаФорма.МножественныйВыбор = Истина;
				Иначе
					МассивКлючей = Новый Массив;
					МассивКлючей.Добавить(НачальноеЗначениеВыбора);
				КонецЕсли; 
				Если МножественныйВыбор Тогда
					ЕстьПомеченные = Ложь;
					Для Каждого ПолноеИмяКолонки Из МассивКлючей Цикл
						Найденные = КолонкиБД.НайтиСтроки(Новый Структура("ПолноеИмяКолонки", ПолноеИмяКолонки));
						Если Найденные.Количество() > 0 Тогда
							Найденные[0].Пометка = Истина;
							ЕстьПомеченные = Истина;
						КонецЕсли; 
					КонецЦикла;
					ЭлементыФормы.ДействияФормы.Кнопки.ТолькоВыбранные.Пометка = ЕстьПомеченные;
				КонецЕсли;
				ОбновитьОтборОтображения();
			КонецЕсли;
			ЭлементыФормы.ОсновныеДействияФормы.Кнопки.ОК.Доступность = Истина;
		КонецЕсли;
		Если ПараметрТекущаяСтрока <> Неопределено Тогда
			Найденные = КолонкиБД.НайтиСтроки(Новый Структура("ПолноеИмяКолонки", ПараметрТекущаяСтрока));
			Если Найденные.Количество() > 0 Тогда
				ЭлементыФормы.КолонкиБД.ТекущаяСтрока = Найденные[0];
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 

КонецПроцедуры

Процедура ОчиститьКолонкиБД()
	КолонкиБД.Очистить();
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирКлиент.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Функция ПоследниеВыбранныеНажатие(Кнопка) Экспорт
	
	ирКлиент.ПоследниеВыбранныеНажатиеЛкс(ЭтаФорма, ЭлементыФормы.ТаблицаРедактируемыхТипов, Метаданные().ТабличныеЧасти.ТаблицаРедактируемыхТипов.Реквизиты.Имя.Имя, Кнопка);
	
КонецФункции

Процедура ПриЗакрытии()
	ирКлиент.Форма_ПриЗакрытииЛкс(ЭтаФорма);
КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирКлиент.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирКлиент.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура КолонкиБДПриАктивизацииСтроки(Элемент = Неопределено)

	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	Элемент = ЭлементыФормы.КолонкиБД;
	ирКлиент.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	ЭтаФорма.ПолноеИмяСвязаннойТаблицыБД = "";
	СтрокиТаблицыБД.Очистить();
	ЭлементыФормы.СтрокиТаблицыБД.Колонки.Очистить();
	СтрокаКолонкиБД = Элемент.ТекущаяСтрока;
	Если СтрокаКолонкиБД <> Неопределено Тогда 
		ИскомоеЗначениеНовое = Null;
		Если ИскатьЗначение Тогда
			СтруктураТипа = мПлатформа.СтруктураТипаИзЗначения(ИскомоеЗначение);
			Если СтрокаКолонкиБД["Тип" + СтруктураТипа.ИмяОбщегоТипа + "Есть"] Тогда 
				ИскомоеЗначениеНовое = ИскомоеЗначение;
				ЭтаФорма.ПолноеИмяСвязаннойТаблицыБД = СтрокаКолонкиБД.ПолноеИмяТаблицы;
				РезультатЗагрузки = ирКлиент.ЗагрузитьСвязанныеСтрокиТаблицыБДЛкс(ЭтаФорма, Элемент, ЭлементыФормы.СтрокиТаблицыБД, ЭлементыФормы.КоманднаяПанельСтрокиТаблицыБД,
					мВыборкаРезультатаСтрокиТаблицы, ИскомоеЗначениеНовое, ВидСравненияНовый);
				Если РезультатЗагрузки = Неопределено Тогда
					Возврат;
				КонецЕсли; 
				СтрокаКолонкиБД.КоличествоСтрокНайдено = СтрокиТаблицыБД.Количество();
				СтрокаКолонкиБД.ЕстьНайденные = СтрокаКолонкиБД.КоличествоСтрокНайдено > 0;
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбновитьРазмерДинамическойТаблицы() Экспорт

	ирКлиент.ПослеЗагрузкиВыборкиВТабличноеПолеЛкс(ЭтаФорма, мВыборкаРезультатаСтрокиТаблицы, ЭлементыФормы.КоманднаяПанельСтрокиТаблицыБД, ЭлементыФормы.КоличествоСтрокТаблицыБД);

КонецПроцедуры

Процедура КолонкиБДПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ОформлениеСтроки.Ячейки.ГруппаТаблица.Видимость = Ложь;
	ОформлениеСтроки.Ячейки.ГруппаТипЗначения.Видимость = Ложь;
	ОформлениеСтроки.Ячейки.ГруппаАнализДанных.Видимость = Ложь;
	Ячейка = ОформлениеСтроки.Ячейки.ТипТаблицы;
	Ячейка.ОтображатьКартинку = Истина;
	Ячейка.ИндексКартинки = ирКлиент.ИндексКартинкиТипаТаблицыБДЛкс(ДанныеСтроки.ТипТаблицы);
	ОписаниеПоля = ирОбщий.ОписаниеПоляТаблицыБДЛкс(ДанныеСтроки.ПолноеИмяТаблицы, ДанныеСтроки.ИмяКолонки);
	Ячейка = ОформлениеСтроки.Ячейки.ИмяКолонки;
	Ячейка.ОтображатьКартинку = Истина;
	Ячейка.ИндексКартинки = ирКлиент.ИндексКартинкиТипаЗначенияБДЛкс(ОписаниеПоля.ТипЗначения);
	ирКлиент.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
	ОформлениеСтроки.Ячейки.ТипЗначения.УстановитьТекст(ирОбщий.РасширенноеПредставлениеЗначенияЛкс(ОписаниеПоля.ТипЗначения));

КонецПроцедуры

Процедура ДействияФормыРазличныеЗначенияКолонкиБД(Кнопка)
	
	ТекущаяСтрока = ЭлементыФормы.КолонкиБД.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	Форма = ирКлиент.ПолучитьФормуЛкс("Обработка.ирРазличныеЗначенияКолонки.Форма");
	Форма.ПараметрПолноеИмяКолонкиБД = ТекущаяСтрока.ПолноеИмяТаблицы + "." + ТекущаяСтрока.ИмяКолонки;
	Форма.ОткрытьМодально();
КонецПроцедуры

Процедура ДействияФормыОткрытьЗапросККолонкеБД(Кнопка)
	
	ТекущаяСтрока = ЭлементыФормы.КолонкиБД.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	Запрос = Новый Запрос;
	ТекстЗапроса = "ВЫБРАТЬ Т." + ТекущаяСтрока.ИмяКолонки + " ИЗ " + ТекущаяСтрока.ПолноеИмяТаблицы + " КАК Т";
	Если ТипЗнч(ТекущаяСтрока.КоличествоСтрокНайдено) = Тип("Число") Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|ГДЕ Т." + ТекущаяСтрока.ИмяКолонки + " " + ирОбщий.ВыражениеСравненияСПараметромВЗапросеЛкс("ЗначениеОтбора", ВидСравненияНовый);
		Запрос.Параметры.Вставить("ЗначениеОтбора", ИскомоеЗначение);
	КонецЕсли; 
	Запрос.Текст = ТекстЗапроса;
	ирОбщий.ОтладитьЛкс(Запрос,,,,,,, "Колонка " + ТекущаяСтрока.ИмяКолонки);

КонецПроцедуры

Процедура ИскомоеЗначениеПриИзменении(Элемент = Неопределено)
	
	Элемент = ЭлементыФормы.ИскомоеЗначение;
	ирКлиент.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
	ЭтаФорма.ИскатьЗначение = Истина;
	ИскатьЗначениеПриИзменении();
	СписокВыбора = ЭлементыФормы.ВидСравненияНовый.СписокВыбора;
	СписокВыбора.Очистить();
	СписокВыбора.Добавить(ВидСравненияКомпоновкиДанных.Равно);
	Если ТипЗнч(ИскомоеЗначение) = Тип("Строка") Тогда
		СписокВыбора.Добавить(ВидСравненияКомпоновкиДанных.Содержит);
	КонецЕсли; 
	Если СписокВыбора.НайтиПоЗначению(ВидСравненияНовый) = Неопределено Тогда
		ЭтаФорма.ВидСравненияНовый = ВидСравненияКомпоновкиДанных.Равно;
	КонецЕсли; 
	ОчиститьКоличествоСтрокНайдено();
	КолонкиБДПриАктивизацииСтроки();

КонецПроцедуры

Процедура ДействияФормыАнализДанных(Кнопка)
	
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	Если ИскатьЗначение Тогда
		СтруктураТипа = мПлатформа.СтруктураТипаИзЗначения(ИскомоеЗначение);
		СтрокиКолонокДляОбновления = КолонкиБД.Выгрузить(Новый Структура("Тип" + СтруктураТипа.ИмяОбщегоТипа + "Есть, ЕстьДоступ", Истина, Истина), "ПолноеИмяКолонки, ТипТаблицы");
		#Если Сервер И Не Сервер Тогда
			АнализДанныхЗавершение();
		#КонецЕсли
		Отбор = Новый Структура("ЗначениеОтбора, ВидСравнения", ИскомоеЗначение, ВидСравненияНовый);
		ирОбщий.ВычислитьКоличествоСтрокТаблицВДеревеМетаданныхЛкс(СтрокиКолонокДляОбновления, "ПолноеИмяКолонки",,, Отбор,,, 
			ЭтаФорма, ЭлементыФормы.ДействияФормы.Кнопки.АнализДанных, "АнализДанныхЗавершение");
	Иначе
		#Если Сервер И Не Сервер Тогда
			ОбновитьСтатистикуЗавершение();
		#КонецЕсли
		ирОбщий.ВычислитьКоличествоСтрокТаблицВДеревеМетаданныхЛкс(,,,,,,, ЭтаФорма, ЭлементыФормы.ДействияФормы.Кнопки.АнализДанных, "ОбновитьСтатистикуЗавершение");
	КонецЕсли; 
	
КонецПроцедуры

Процедура АнализДанныхЗавершение(СостояниеЗадания = Неопределено, РезультатЗадания = Неопределено) Экспорт 
	
	Если Ложь
		Или СостояниеЗадания = Неопределено
		Или СостояниеЗадания = СостояниеФоновогоЗадания.Завершено 
	Тогда
		ТаблицаКолонок = КолонкиБД.Выгрузить(, "ПолноеИмяКолонки, КоличествоСтрокНайдено, ЕстьНайденные");
		ирОбщий.ДобавитьИндексВТаблицуЛкс(ТаблицаКолонок, "ПолноеИмяКолонки");
		Для Каждого ТаблицаРезультата Из РезультатЗадания Цикл
			Для Каждого СтрокаРезультата Из ТаблицаРезультата Цикл
				СтрокаКолонкиБД = ТаблицаКолонок.Найти(СтрокаРезультата.ИмяТаблицы, "ПолноеИмяКолонки");
				СтрокаКолонкиБД.КоличествоСтрокНайдено = СтрокаРезультата.КоличествоСтрок;
				СтрокаКолонкиБД.ЕстьНайденные = СтрокаКолонкиБД.КоличествоСтрокНайдено > 0;
			КонецЦикла;
		КонецЦикла;
		КолонкиБД.ЗагрузитьКолонку(ТаблицаКолонок.ВыгрузитьКолонку("КоличествоСтрокНайдено"), "КоличествоСтрокНайдено");
		КолонкиБД.ЗагрузитьКолонку(ТаблицаКолонок.ВыгрузитьКолонку("ЕстьНайденные"), "ЕстьНайденные");
	КонецЕсли; 

КонецПроцедуры

Процедура ОбновитьСтатистикуЗавершение(СостояниеЗадания = Неопределено, РезультатЗадания = Неопределено) Экспорт 
	
	Если Ложь
		Или СостояниеЗадания = Неопределено
		Или СостояниеЗадания = СостояниеФоновогоЗадания.Завершено 
	Тогда
		#Если Сервер И Не Сервер Тогда
			ирСервер.ВыполнитьЗапросСтатистикиПоТаблицамЛкс();
		#КонецЕсли
		ирОбщий.ЗаполнитьКоличестваСтрокВТаблицеВсехТаблицЛкс(РезультатЗадания);
		ТаблицаВсехТаблиц = ирКэш.ТаблицаВсехТаблицБДЛкс();
		Для Каждого СтрокаКолонкиБД Из КолонкиБД Цикл
			ОписаниеТаблицы = ТаблицаВсехТаблиц.Найти(НРег(СтрокаКолонкиБД.ПолноеИмяТаблицы), "НПолноеИмя");
			Если ОписаниеТаблицы <> Неопределено Тогда
				СтрокаКолонкиБД.КоличествоСтрокВТаблице = ОписаниеТаблицы.КоличествоСтрок;
			КонецЕсли; 
		КонецЦикла;
	КонецЕсли; 

КонецПроцедуры

// Предопределеный метод
Процедура ПроверкаЗавершенияФоновыхЗаданий() Экспорт 
	
	ирКлиент.ПроверитьЗавершениеФоновыхЗаданийФормыЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ИскомоеЗначениеНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	Если ирКлиент.ПолеВводаРасширенногоЗначения_НачалоВыбораЛкс(Элемент, СтандартнаяОбработка, ЭтаФорма.ИскомоеЗначение) Тогда 
		ИскомоеЗначениеПриИзменении();
	КонецЕсли; 

КонецПроцедуры

Процедура ОбновитьОтборОтображения(ТекстИмениТаблицы = Неопределено, ТекстИмениКолонки = Неопределено)
	
	ТабличноеПоле = ЭлементыФормы.КолонкиБД;
	Если ТекстИмениТаблицы = Неопределено Тогда
		ТекстИмениТаблицы = ФильтрИменТаблиц;
	КонецЕсли; 
	Если ИмяСиноним Тогда
		ирОбщий.УстановитьОтборПоПодстрокеЛкс(ТабличноеПоле.ОтборСтрок.ИмяТаблицы, ТекстИмениТаблицы);
		ирОбщий.УстановитьОтборПоПодстрокеЛкс(ТабличноеПоле.ОтборСтрок.ПредставлениеТаблицы, "");
	Иначе
		ирОбщий.УстановитьОтборПоПодстрокеЛкс(ТабличноеПоле.ОтборСтрок.ИмяТаблицы, "");
		ирОбщий.УстановитьОтборПоПодстрокеЛкс(ТабличноеПоле.ОтборСтрок.ПредставлениеТаблицы, ТекстИмениТаблицы);
	КонецЕсли;

	Если ТекстИмениКолонки = Неопределено Тогда
		ТекстИмениКолонки = ФильтрИменКолонок;
	КонецЕсли; 
	Если ИмяСиноним Тогда
		ирОбщий.УстановитьОтборПоПодстрокеЛкс(ТабличноеПоле.ОтборСтрок.ИмяКолонки, ТекстИмениКолонки);
		ирОбщий.УстановитьОтборПоПодстрокеЛкс(ТабличноеПоле.ОтборСтрок.ПредставлениеКолонки, "");
	Иначе
		ирОбщий.УстановитьОтборПоПодстрокеЛкс(ТабличноеПоле.ОтборСтрок.ИмяКолонки, "");
		ирОбщий.УстановитьОтборПоПодстрокеЛкс(ТабличноеПоле.ОтборСтрок.ПредставлениеКолонки, ТекстИмениКолонки);
	КонецЕсли;
	
	ЭлементОтбора = ТабличноеПоле.ОтборСтрок.КоличествоТипов;
	ЭлементОтбора.Использование = ТолькоПростойТип;
	Если ТолькоПростойТип Тогда
		ЭлементОтбора.ВидСравнения = ВидСравнения.Равно;
		ЭлементОтбора.Значение = 1;
	КонецЕсли; 
	
	Для Каждого Реквизит Из Метаданные().ТабличныеЧасти.КолонкиБД.Реквизиты Цикл
		Если Истина
			И ирОбщий.СтрНачинаетсяСЛкс(Реквизит.Имя, "Тип")
			И ирОбщий.СтрКончаетсяНаЛкс(Реквизит.Имя, "Есть")
		Тогда
			ЭлементОтбора = ТабличноеПоле.ОтборСтрок[Реквизит.Имя];
			ЭлементОтбора.Использование = ЭтаФорма[Реквизит.Имя];
			ЭлементОтбора.Значение = Истина;
		КонецЕсли; 
	КонецЦикла;

	ЭлементОтбора = ТабличноеПоле.ОтборСтрок.ЕстьНайденные;
	ЭлементОтбора.ВидСравнения = ВидСравнения.Равно;
	ЭлементОтбора.Использование = ТолькоЕстьНайденные;
	ЭлементОтбора.Значение = Истина;
	ЭлементОтбора = ТабличноеПоле.ОтборСтрок.Пометка;
	ЭлементОтбора.Использование = ЭлементыФормы.ДействияФормы.Кнопки.ТолькоВыбранные.Пометка;
	ЭлементОтбора.Значение = Истина;

КонецПроцедуры

Процедура ФильтрИменТаблицПриИзменении(Элемент)
	
    ОбновитьОтборОтображения();
	ирКлиент.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
	
КонецПроцедуры

Процедура ФильтрИменКолонокПриИзменении(Элемент)
	
	ОбновитьОтборОтображения();
	ирКлиент.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);

КонецПроцедуры

Процедура ФильтрИменКолонокАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	
	Если ирКлиент.ПромежуточноеОбновлениеСтроковогоЗначенияПоляВводаЛкс(ЭтаФорма, Элемент, Текст) Тогда 
		ОбновитьОтборОтображения();
	КонецЕсли;

КонецПроцедуры

Процедура ФильтрИменТаблицАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	
	Если ирКлиент.ПромежуточноеОбновлениеСтроковогоЗначенияПоляВводаЛкс(ЭтаФорма, Элемент, Текст) Тогда 
		ОбновитьОтборОтображения();
	КонецЕсли;

КонецПроцедуры

Процедура ФильтрИменТаблицНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_ОбновитьСписокЛкс(Элемент, ЭтаФорма);

КонецПроцедуры

Процедура ФильтрИменКолонокНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_ОбновитьСписокЛкс(Элемент, ЭтаФорма);

КонецПроцедуры

Процедура ТолькоПростойТипПриИзменении(Элемент)
	
	ОбновитьОтборОтображения();

КонецПроцедуры

Процедура ИмяСинонимПриИзменении(Элемент)
	
	ОбновитьОтборОтображения();
	
КонецПроцедуры

Процедура ИскатьЗначениеПриИзменении(Элемент = Неопределено)
	
	Если Не ИскатьЗначение Тогда
		ОчиститьКоличествоСтрокНайдено();
		ЭтаФорма.ТолькоЕстьНайденные = Ложь;
		ОбновитьОтборОтображения();
	КонецЕсли; 
	КолонкиБДПриАктивизацииСтроки();
	
КонецПроцедуры

Процедура ОчиститьКоличествоСтрокНайдено()
	
	ирОбщий.ЗаполнитьКолонкуТабличнойЧастиЛкс(КолонкиБД, "КоличествоСтрокНайдено", "?");
	ирОбщий.ЗаполнитьКолонкуТабличнойЧастиЛкс(КолонкиБД, "ЕстьНайденные", Ложь);

КонецПроцедуры

Процедура КолонкиБДПриИзмененииФлажка(Элемент, Колонка)
	
	ирКлиент.ТабличноеПолеПриИзмененииФлажкаЛкс(ЭтаФорма, Элемент, Колонка);
	
КонецПроцедуры

Процедура ДействияФормыТолькоВыбранные(Кнопка)
	
	Кнопка.Пометка = Не Кнопка.Пометка;
	ОбновитьОтборОтображения();
	
КонецПроцедуры

Процедура ИскомоеЗначениеНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_ОбновитьСписокЛкс(Элемент, ЭтаФорма);
	
КонецПроцедуры

Процедура ТипЛюбойЕстьПриИзменении(Элемент)
	
	Если ТолькоПростойТип Тогда
		Для Каждого Реквизит Из Метаданные().ТабличныеЧасти.КолонкиБД.Реквизиты Цикл
			Если Истина
				И ирОбщий.СтрНачинаетсяСЛкс(Реквизит.Имя, "Тип")
				И ирОбщий.СтрКончаетсяНаЛкс(Реквизит.Имя, "Есть")
				И Элемент.Имя <> Реквизит.Имя
			Тогда
				ЭтаФорма[Реквизит.Имя] = Ложь;
			КонецЕсли; 
		КонецЦикла;
	КонецЕсли; 
	ОбновитьОтборОтображения();
	
КонецПроцедуры

Процедура КоманднаяПанельСтрокиТаблицыБДРедактировать(Кнопка)
	
	ирКлиент.ОткрытьТекущуюСтрокуТабличногоПоляТаблицыБДВРедактореОбъектаБДЛкс(ЭлементыФормы.СтрокиТаблицыБД, ЭлементыФормы.КолонкиБД.ТекущаяСтрока.ПолноеИмяТаблицы,,,,, Ложь,,,, ЭтаФорма);

КонецПроцедуры

Процедура КоманднаяПанельСтрокиТаблицыБДЗагрузитьПолностью(Кнопка)
	
	ирКлиент.ЗагрузитьВыборкуВТабличноеПолеПолностьюЛкс(ЭтаФорма, мВыборкаРезультатаСтрокиТаблицы, ЭлементыФормы.КоманднаяПанельСтрокиТаблицыБД);

КонецПроцедуры

Процедура КоманднаяПанельСтрокиТаблицыБДКонсольОбработки(Кнопка)
	
	ирКлиент.ОткрытьОбъектыИзВыделенныхЯчеекВПодбореИОбработкеОбъектовЛкс(ЭлементыФормы.СтрокиТаблицыБД,, ЭтаФорма, ПолноеИмяСвязаннойТаблицыБД);

КонецПроцедуры

Процедура СтрокиТаблицыБДВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	ирКлиент.ЯчейкаТабличногоПоляРасширенногоЗначения_ВыборЛкс(ЭтаФорма, Элемент, СтандартнаяОбработка);
КонецПроцедуры

Процедура СтрокиТаблицыБДПриАктивизацииСтроки(Элемент)
	ирКлиент.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
КонецПроцедуры

Процедура СтрокиТаблицыБДПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ирКлиент.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);

КонецПроцедуры

Процедура ВидСравненияНовыйПриИзменении(Элемент)
	
	КолонкиБДПриАктивизацииСтроки();

КонецПроцедуры

Процедура КолонкиБДПометкаПриИзменении(Элемент = Неопределено)
	
	ТекущаяСтрока = ЭлементыФормы.КолонкиБД.ТекущаяСтрока;
	НоваяПометка = ТекущаяСтрока.Пометка;
	Если Не МножественныйВыбор И НоваяПометка Тогда
		СброситьПометкиУПомеченных(, Истина);
	КонецЕсли;

КонецПроцедуры

Процедура СброситьПометкиУПомеченных(ВременнаяТаблица = Неопределено, КромеТекущейСтроки = Ложь)

	Если ВременнаяТаблица = Неопределено Тогда
		ВременнаяТаблица = ПомеченныеСтрокиТаблицы();
	КонецЕсли;
	Признак = Ложь;
	Для каждого ВременнаяСтрока Из ВременнаяТаблица Цикл
		СтрокаТипа = КолонкиБД.Найти(ВременнаяСтрока.ПолноеИмяКолонки, "ПолноеИмяКолонки");
		Если КромеТекущейСтроки И СтрокаТипа = ЭлементыФормы.КолонкиБД.ТекущаяСтрока Тогда
			Продолжить;
		КонецЕсли; 
		СтрокаТипа.Пометка = Признак;
	КонецЦикла;
	//ПодключитьОбработчикОжидания("ОбновитьСтроки", 0.1, Истина);

КонецПроцедуры

Функция ПомеченныеСтрокиТаблицы() Экспорт

	Результат = КолонкиБД.Выгрузить(Новый Структура("Пометка", Истина));
	Результат.Колонки.Добавить("ПолноеИмяКолонкиМД");
	Для Каждого СтрокаКолонкиБД Из Результат Цикл
		СтрокаКолонкиБД.ПолноеИмяКолонкиМД = СтрокаКолонкиБД.ПолноеИмяТаблицы + "." + СтрокаКолонкиБД.РольМетаданных + "." + СтрокаКолонкиБД.ИмяКолонки;
	КонецЦикла;
	Возврат Результат;

КонецФункции

Процедура ОсновныеДействияФормыОК(Кнопка)
	
	ЗакрытьССохранением();

КонецПроцедуры

Процедура ЗакрытьССохранением()

	ирКлиент.ПрименитьИзмененияИЗакрытьФормуЛкс(ЭтаФорма, ПомеченныеСтрокиТаблицы());

КонецПроцедуры

Процедура КолонкиБДВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если Не ТолькоПросмотр И РежимВыбора Тогда
		ирКлиент.ИнтерактивноЗаписатьВКолонкуТабличногоПоляЛкс(Элемент, Элемент.Колонки.Пометка, Истина);
		Если ЗакрыватьПриВыборе Тогда
			ЗакрытьССохранением();
		КонецЕсли; 
	ИначеЕсли Ложь
		Или ирОбщий.СтрНачинаетсяСЛкс(Колонка.Имя, "Тип") И Колонка <> ЭлементыФормы.КолонкиБД.Колонки.ТипТаблицы
		Или Колонка = ЭлементыФормы.КолонкиБД.Колонки.КоличествоТипов
		Или Колонка = ЭлементыФормы.КолонкиБД.Колонки.КоличествоСсылочныхТипов
	Тогда 
		ОписаниеПоля = ирОбщий.ОписаниеПоляТаблицыБДЛкс(ВыбраннаяСтрока.ПолноеИмяКолонки);
		ирКлиент.ОткрытьЗначениеЛкс(ОписаниеПоля.ТипЗначения, Ложь, СтандартнаяОбработка);
	Иначе
		ОткрытьДинамичекийСписокТаблицы();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбновитьПодменюПоследнихОтборов()
	
	ирКлиент.ОбновитьПодменюПоследнихОтборовЛкс(ЭтаФорма, ЭлементыФормы.ДействияФормы, ЭлементыФормы.КолонкиБД);

КонецПроцедуры

Процедура ПроверитьИзменениеОтбораДляИсторииОтложенно()
	
	ТабличноеПоле = ЭлементыФормы.КолонкиБД;
	ДобавленВСписок = ирКлиент.ДобавитьОтборВИсториюТабличногоПоляЛкс(ЭтаФорма, ТабличноеПоле, ТабличноеПоле.ОтборСтрок, СтарыйОтбор);
	Если ДобавленВСписок Тогда
		ОбновитьПодменюПоследнихОтборов();
	КонецЕсли;

КонецПроцедуры

Процедура ОбработчикИзмененияДанных(ПутьКДанным) Экспорт 
	
	ПутьКДаннымОтбораНайденных = "ЭлементыФормы." + ЭлементыФормы.КолонкиБД.Имя + ".Отбор";
	Если ирОбщий.СтрНачинаетсяСЛкс(ПутьКДанным, ПутьКДаннымОтбораНайденных) Тогда
		#Если Сервер И Не Сервер Тогда
			ПроверитьИзменениеОтбораДляИсторииОтложенно();
		#КонецЕсли
		ПодключитьОбработчикОжидания("ПроверитьИзменениеОтбораДляИсторииОтложенно", 0.1, Истина);
		ПодключитьОбработчикИзмененияДанных(ПутьКДаннымОтбораНайденных, "ОбработчикИзмененияДанных", Истина);
	КонецЕсли; 

КонецПроцедуры

Процедура ТолькоНайденныеПриИзменении(Элемент)
	
	ОбновитьОтборОтображения();
	
КонецПроцедуры

Процедура ОткрытьДинамичекийСписокТаблицы(ИспользоватьДинамическийСписокИР = Неопределено)
	
	ВыбраннаяСтрока = ирКлиент.ДанныеСтрокиТабличногоПоляЛкс(ЭлементыФормы.КолонкиБД);
	Если ВыбраннаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	Если ВыбраннаяСтрока.ТипТаблицы = "Константы" Тогда
		ФормаСписка = ирКлиент.ПолучитьФормуЛкс("Обработка.ирРедакторКонстант.Форма");
		ФормаСписка.НачальноеЗначениеВыбора = ВыбраннаяСтрока.ИмяКолонки;
		ФормаСписка.Открыть();
	ИначеЕсли ВыбраннаяСтрока.ТипТаблицы = "Константа" Тогда
		ФормаСписка = ирКлиент.ПолучитьФормуЛкс("Обработка.ирРедакторКонстант.Форма");
		ТекущаяСтрока = ирОбщий.ПоследнийФрагментЛкс(ВыбраннаяСтрока.ПолноеИмяТаблицы);
		ФормаСписка.НачальноеЗначениеВыбора = ТекущаяСтрока;
		ФормаСписка.Открыть();
	Иначе
		ПараметрОтбор = Неопределено;
		Если ТипЗнч(ВыбраннаяСтрока.КоличествоСтрокНайдено) = Тип("Число") Тогда
			ПараметрОтбор = Новый Структура(ВыбраннаяСтрока.ИмяКолонки, ИскомоеЗначение);
		КонецЕсли; 
		ирКлиент.ОткрытьФормуСпискаЛкс(ВыбраннаяСтрока.ПолноеИмяТаблицы,, ИспользоватьДинамическийСписокИР,,,,,, ПараметрОтбор);
	КонецЕсли;

КонецПроцедуры

Процедура ДействияФормыФормаСписка(Кнопка)
	
	ОткрытьДинамичекийСписокТаблицы(Ложь);
	
КонецПроцедуры

Процедура ДействияФормыДинамическойСписок(Кнопка)
	
	ОткрытьДинамичекийСписокТаблицы(Истина);

КонецПроцедуры

Процедура ДействияФормыОткрытьОбъектМетаданных(Кнопка)
	
	ВыбраннаяСтрока = ЭлементыФормы.КолонкиБД.ТекущаяСтрока;
	Если ВыбраннаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ирКлиент.ОткрытьОбъектМетаданныхЛкс(ирОбщий.ОбъектМДПоПолномуИмениТаблицыБДЛкс(ВыбраннаяСтрока.ПолноеИмяТаблицы));

КонецПроцедуры

Процедура ДействияФормыМетаданныеКолонкиБД(Кнопка)
	
	ТекущаяСтрока = ЭлементыФормы.КолонкиБД.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ПоляТаблицыБД = ирКэш.ПоляТаблицыБДЛкс(ТекущаяСтрока.ПолноеИмяТаблицы);
	ОписаниеПоля = ПоляТаблицыБД.Найти(ТекущаяСтрока.ИмяКолонки, "Имя");
	Если ОписаниеПоля.Метаданные <> Неопределено Тогда
		ирОбщий.ИсследоватьЛкс(ОписаниеПоля.Метаданные);
	КонецЕсли; 

КонецПроцедуры

Процедура ИскомоеЗначениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЭтаФорма.ИскомоеЗначение = ВыбранноеЗначение;
	ИскомоеЗначениеПриИзменении();
	
КонецПроцедуры

Процедура ДействияФормыПоказатьСтруктуруХранения(Кнопка)
	
	ТекущаяСтрока = ЭлементыФормы.КолонкиБД.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	Форма = ирКлиент.ФормаСтруктурыХраненияТаблицыБДЛкс();
	Форма.ПараметрИмяТаблицы = ТекущаяСтрока.ПолноеИмяТаблицы;
	Форма.ПараметрИмяПоля = ТекущаяСтрока.ИмяКолонки;
	Форма.Открыть();
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	ирКлиент.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирКолонкиБД.Форма.Форма");
ЭтаФорма.ВидСравненияНовый = ВидСравнения.Равно;
