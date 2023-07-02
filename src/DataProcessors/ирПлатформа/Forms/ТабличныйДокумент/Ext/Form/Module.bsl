﻿Перем ОбработчикРасшифровки Экспорт;

Функция ПолучитьРезультат()
	
	ирКлиент.ПолеТабличногоДокументаВосстановитьОформлениеТекущихСтрокЛкс(ЭтаФорма, ЭлементыФормы.ПолеТабличногоДокумента);
	Результат = ЭлементыФормы.ПолеТабличногоДокумента.ПолучитьОбласть();
	ЗаполнитьЗначенияСвойств(Результат, ЭлементыФормы.ПолеТабличногоДокумента); // Например свойство "Макет"
	Возврат Результат;
	
КонецФункции

Процедура УстановитьРедактируемоеЗначение(НовоеЗначение)
	
	#Если Сервер И Не Сервер Тогда
		НовоеЗначение = Новый ТабличныйДокумент;
	#КонецЕсли   
	Если ЭлементыФормы.КодЯзыка.Доступность Тогда
		ЭтаФорма.КодЯзыка = НовоеЗначение.КодЯзыка;
		Если Не ЗначениеЗаполнено(КодЯзыка) Тогда
			ЭтаФорма.КодЯзыка = ТекущийЯзык().КодЯзыка;
		КонецЕсли;
	КонецЕсли;
	Если ирКэш.ЭтоУчебнаяПлатформаЛкс() Тогда
		// Так только текущий язык останется
		ЭлементыФормы.ПолеТабличногоДокумента.ВставитьОбласть(НовоеЗначение.Область(),,, Ложь); 
	Иначе
		// Так будут потеряны несериализуемые расшифровки
		ИмяВременногоФайла = ПолучитьИмяВременногоФайла("mxl");
		НовоеЗначение.Записать(ИмяВременногоФайла);
		ЭлементыФормы.ПолеТабличногоДокумента.Прочитать(ИмяВременногоФайла);
		УдалитьФайлы(ИмяВременногоФайла);
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(ЭлементыФормы.ПолеТабличногоДокумента, НовоеЗначение); 
	ЭлементыФормы.ПолеТабличногоДокумента.ТолькоПросмотр = Не ЭлементыФормы.КоманднаяПанельТабличныйДокумент.Кнопки.Редактирование.Пометка;
	ЭлементыФормы.ПолеТабличногоДокумента.ОтображатьЗаголовки = Истина;
	//Если ПолеТабличногоДокумента <> Неопределено Тогда
	//	#Если Сервер И Не Сервер Тогда
	//		ПолеТабличногоДокумента = Новый ТабличныйДокумент;
	//	#КонецЕсли
	//	ЭлементыФормы.ПолеТабличногоДокумента.ТекущаяОбласть = ЭлементыФормы.ПолеТабличногоДокумента.Область(ПолеТабличногоДокумента.ТекущаяОбласть.Имя);
	//КонецЕсли;
	УстановитьВыделятьТекущиеСтроки(Истина);
	Если ЭлементыФормы.КодЯзыка.Доступность Тогда 
		СписокВыбораЯзыка = ЭлементыФормы.КодЯзыка.СписокВыбора;
		СписокВыбораЯзыка.Очистить();
		ОбработатьЯзыкиДокумента(ЭлементыФормы.ПолеТабличногоДокумента.ПолучитьОбласть(1,1),,, СписокВыбораЯзыка);
		Для Каждого Язык Из Метаданные.Языки Цикл
			#Если Сервер И Не Сервер Тогда
				Язык = Метаданные.Языки.Русский;
			#КонецЕсли 
			Если СписокВыбораЯзыка.НайтиПоЗначению(Язык.КодЯзыка) = Неопределено Тогда
				ДобавитьЯзыкВСписокВыбора(Язык.КодЯзыка, Язык.Имя, СписокВыбораЯзыка);
			КонецЕсли;
		КонецЦикла;
		СписокВыбораЯзыка.СортироватьПоПредставлению();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ирКлиент.Форма_ПриОткрытииЛкс(ЭтаФорма);
	//ЭлементыФормы.ОсновныеДействияФормы.Кнопки.ОК.Доступность = МодальныйРежим;
	Если НачальноеЗначениеВыбора = Неопределено Тогда
		НачальноеЗначениеВыбора = Новый ТабличныйДокумент;
	КонецЕсли;
	ирКлиент.ФормаОбъекта_ОбновитьЗаголовокЛкс(ЭтаФорма);
	Если ЭтаФорма.ТолькоПросмотр Тогда
		ЭлементыФормы.КоманднаяПанельТабличныйДокумент.Кнопки.Редактирование.Доступность = Ложь;
	ИначеЕсли НачальноеЗначениеВыбора.ВысотаТаблицы = 0 Тогда 
		КоманднаяПанельТабличныйДокументРедактирование();
	КонецЕсли; 
	ЭлементыФормы.КодЯзыка.Доступность = ирКэш.НомерВерсииПлатформыЛкс() >= 803007;
	УстановитьРедактируемоеЗначение(НачальноеЗначениеВыбора);
	ДопСвойства = ирКлиент.ДопСвойстваЭлементаФормыЛкс(ЭтаФорма, ЭлементыФормы.ПолеТабличногоДокумента);
	ДопСвойства.КнопкаОтображенияПодвала = ЭлементыФормы.КоманднаяПанельТабличныйДокумент.Кнопки.Автосумма;
	ДопСвойства.КнопкаОформленияТекущихСтрок = ЭлементыФормы.КоманднаяПанельТабличныйДокумент.Кнопки.ВыделятьТекущиеСтроки;
	Если ЗначениеЗаполнено(КодЯзыка) Тогда
		КодЯзыкаПриИзменении();
	КонецЕсли;

КонецПроцедуры

Процедура ОсновныеДействияФормыОК(Кнопка = Неопределено)
	
	Если Не ЭтаФорма.МодальныйРежим И ЭтаФорма.ВладелецФормы = Неопределено Тогда 
		Если Не ЭтаФорма.Модифицированность Или КоманднаяПанельТабличныйДокументСохранитьВФайл() Тогда 
			Закрыть();
		Иначе
			Возврат;
		КонецЕсли;
	КонецЕсли;
	Модифицированность = Ложь;
	НовоеЗначение = ПолучитьРезультат();
	ирКлиент.ПрименитьИзмененияИЗакрытьФормуЛкс(ЭтаФорма, НовоеЗначение);
	
КонецПроцедуры

Процедура ОсновныеДействияФормыИсследовать(Кнопка)
	
	ирОбщий.ИсследоватьЛкс(ПолучитьРезультат());
	
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Ответ = ирКлиент.ЗапроситьСохранениеДанныхФормыЛкс(ЭтаФорма, Отказ);
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ОсновныеДействияФормыОК();
	КонецЕсли;
	
КонецПроцедуры

Процедура КоманднаяПанельТаблицаЗагрузитьИзФайла(Кнопка)
	
	ТабДок = ирКлиент.ЗагрузитьТабличныйДокументИнтерактивноЛкс();
	Если ТабДок <> Неопределено Тогда
		УстановитьРедактируемоеЗначение(ТабДок);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОсновныеДействияФормыРедактироватьКопию(Кнопка)
	
	ирКлиент.ПредложитьЗакрытьМодальнуюФормуЛкс(ЭтаФорма);
	ирКлиент.ОткрытьЗначениеЛкс(ПолучитьРезультат(),,, ирКлиент.ЗаголовокДляКопииОбъектаЛкс(ЭтаФорма), Ложь);
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	ирКлиент.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура ПолеТабличногоДокументаПриАктивизацииОбласти(_Элемент = Неопределено)
	
	Элемент = ЭлементыФормы.ПолеТабличногоДокумента;
	ЭлементыФормы.КоманднаяПанельТабличныйДокумент.Кнопки.РасшифровкаЯчейки.Доступность = Истина
		И ТипЗнч(ЭлементыФормы.ПолеТабличногоДокумента.ТекущаяОбласть) = Тип("ОбластьЯчеекТабличногоДокумента")
		И ЭлементыФормы.ПолеТабличногоДокумента.ТекущаяОбласть.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Прямоугольник
		И ЭлементыФормы.ПолеТабличногоДокумента.ТекущаяОбласть.Расшифровка <> Неопределено;
	Если Открыта() Тогда
		ирКлиент.ПолеТабличногоДокументаПриАктивизацииОбластиЛкс(ЭтаФорма, Элемент);
	КонецЕсли;

КонецПроцедуры

Процедура КоманднаяПанельТабличныйДокументСравнить(Кнопка)
	
	ирКлиент.ЗапомнитьСодержимоеЭлементаФормыДляСравненияЛкс(ЭтаФорма, ЭлементыФормы.ПолеТабличногоДокумента);
	
КонецПроцедуры

Процедура КоманднаяПанельТабличныйДокументРедактирование(Кнопка = Неопределено)
	
	Кнопка = ЭлементыФормы.КоманднаяПанельТабличныйДокумент.Кнопки.Редактирование;
	Кнопка.Пометка = Не Кнопка.Пометка;
	ЭлементыФормы.ПолеТабличногоДокумента.ТолькоПросмотр = Не Кнопка.Пометка;
	
КонецПроцедуры

Процедура КоманднаяПанельТабличныйДокументРедакторОбъектаБД(Кнопка)
	
	ЗначениеРасшифровки = ЭлементыФормы.ПолеТабличногоДокумента.ТекущаяОбласть.Расшифровка;
	Если ирОбщий.ЛиСсылкаНаОбъектБДЛкс(ЗначениеРасшифровки) Тогда
		ирКлиент.ПредложитьЗакрытьМодальнуюФормуЛкс(ЭтаФорма);
		ирКлиент.ОткрытьСсылкуВРедактореОбъектаБДЛкс(ЗначениеРасшифровки);
	КонецЕсли; 

КонецПроцедуры

Процедура КоманднаяПанельТабличныйДокументПередатьВПодборИОбработкуОбъектов(Кнопка)
	
	ТаблицаЗначений = ирОбщий.ТаблицаКлючейИзТабличногоДокументаЛкс(ЭлементыФормы.ПолеТабличногоДокумента);
	Если ТаблицаЗначений.Количество() > 0 Тогда
		ирКлиент.ПредложитьЗакрытьМодальнуюФормуЛкс(ЭтаФорма);
		ирКлиент.ОткрытьМассивОбъектовВПодбореИОбработкеОбъектовЛкс(ТаблицаЗначений.ВыгрузитьКолонку(0));
	КонецЕсли; 
	
КонецПроцедуры

Процедура КоманднаяПанельТабличныйДокументАвтоширина(Кнопка)
	
	ирКлиент.УстановитьАвтоширинуКолонокТабличногоДокументаЛкс(ЭлементыФормы.ПолеТабличногоДокумента);
	
КонецПроцедуры

Процедура КоманднаяПанельТабличныйДокументЗафиксировать(Кнопка)
	
	ЭлементыФормы.ПолеТабличногоДокумента.ФиксацияСлева = ЭлементыФормы.ПолеТабличногоДокумента.ТекущаяОбласть.Лево - 1;
	ЭлементыФормы.ПолеТабличногоДокумента.ФиксацияСверху = ЭлементыФормы.ПолеТабличногоДокумента.ТекущаяОбласть.Верх - 1;
	
КонецПроцедуры

Функция КоманднаяПанельТабличныйДокументСохранитьВФайл(Кнопка = Неопределено)
	
	Результат = ирКлиент.СохранитьТабличныйДокументИнтерактивноЛкс(ЭлементыФормы.ПолеТабличногоДокумента,,, УстанавливатьПризнакСодержитЗначение, ЭтаФорма);
	Возврат Результат;
	
КонецФункции

Процедура КоманднаяПанельТабличныйДокументЗагрузитьВТаблицуЗначений(Кнопка)
	
	ирКлиент.ПолеТабличногоДокументаВосстановитьОформлениеТекущихСтрокЛкс(ЭтаФорма, ЭлементыФормы.ПолеТабличногоДокумента);
	Ответ = Вопрос("Использовать инструмент ""Загрузка табличных данных""? Иначе будет выполнена быстрая загрузка.", РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Да);
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		ВариантыОтвета = Новый СписокЗначений;  
		ВариантыОтвета.Добавить(0, "Первой строки");
		ВариантыОтвета.Добавить(1, "Текущей строки");
		ВариантыОтвета.Добавить(2, "Новой строки");
		Ответ = Вопрос("Установить имена колонок из", ВариантыОтвета,, 0);
		НомерСтрокиЗаголовков = 1;
		Если Ответ = 1 Тогда
			НомерСтрокиЗаголовков = ЭлементыФормы.ПолеТабличногоДокумента.ТекущаяОбласть.Верх;
		ИначеЕсли Ответ = 2 Тогда
			ТД = Новый ТабличныйДокумент;
			ЭлементыФормы.ПолеТабличногоДокумента.ВставитьОбласть(ТД.Область(1,1), ЭлементыФормы.ПолеТабличногоДокумента.Область(1, 1), ТипСмещенияТабличногоДокумента.ПоВертикали);
			Для НомерКолонки = 1 По ЭлементыФормы.ПолеТабличногоДокумента.ШиринаТаблицы Цикл
				ЭлементыФормы.ПолеТабличногоДокумента.ВставитьОбласть(ТД.Область(1,1), ЭлементыФормы.ПолеТабличногоДокумента.Область(1, НомерКолонки));
			КонецЦикла;
		КонецЕсли; 
		Для НомерКолонки = 1 По ЭлементыФормы.ПолеТабличногоДокумента.ШиринаТаблицы Цикл
			ЯчейкаЗаголовка = ЭлементыФормы.ПолеТабличногоДокумента.Область(НомерСтрокиЗаголовков, НомерКолонки);
			ИмяКолонки = ирОбщий.ИдентификаторИзПредставленияЛкс(ЯчейкаЗаголовка.Текст, "Колонка" + НомерКолонки);
			Запрос = Новый Запрос("ВЫБРАТЬ 1 КАК " + ИмяКолонки);
			Попытка
				Запрос.Выполнить();
			Исключение
				ИмяКолонки = ИмяКолонки + "_";
			КонецПопытки;
			ЯчейкаЗаголовка.Текст = ИмяКолонки;
		КонецЦикла;
		Построитель = ирОбщий.ПостроительЗапросаКТабличномуДокументуЛкс(ЭлементыФормы.ПолеТабличногоДокумента.Область(НомерСтрокиЗаголовков, 1, 
			ЭлементыФормы.ПолеТабличногоДокумента.ВысотаТаблицы, ЭлементыФормы.ПолеТабличногоДокумента.ШиринаТаблицы));
		ТаблицаЗначений = Построитель.Результат.Выгрузить();
		ирКлиент.ОткрытьТаблицуЗначенийЛкс(ТаблицаЗначений,, Ложь,,, Ложь);
	Иначе
		ирКлиент.ПредложитьЗакрытьМодальнуюФормуЛкс(ЭтаФорма);
		ЗагрузкаТабличныхДанных = ирОбщий.СоздатьОбъектПоИмениМетаданныхЛкс("Обработка.ирЗагрузкаТабличныхДанных");
		#Если Сервер И Не Сервер Тогда
		    ЗагрузкаТабличныхДанных = Обработки.ирЗагрузкаТабличныхДанных.Создать();
		#КонецЕсли
		Форма = ЗагрузкаТабличныхДанных.ПолучитьФорму();
		Форма.ПараметрТабличныйДокумент = ЭлементыФормы.ПолеТабличногоДокумента;
		Форма.Открыть();
		Если Открыта() Тогда
			ЭлементыФормы.ПолеТабличногоДокумента.ТекущаяОбласть = ЭлементыФормы.ПолеТабличногоДокумента.ТекущаяОбласть;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура КоманднаяПанельТабличныйДокументРасшифровкаЯчейки(Кнопка)
	
	ирОбщий.ИсследоватьЛкс(ЭлементыФормы.ПолеТабличногоДокумента.ТекущаяОбласть.Расшифровка);
	
КонецПроцедуры

Процедура КоманднаяПанельТабличныйДокументОткрытьВExcel(Кнопка)
	
	ПолноеИмяФайла = ПолучитьИмяВременногоФайла("xlsx");
	ирКлиент.СохранитьТабличныйДокументИнтерактивноЛкс(ЭлементыФормы.ПолеТабличногоДокумента, ПолноеИмяФайла, Истина, УстанавливатьПризнакСодержитЗначение, ЭтаФорма);
	
КонецПроцедуры

Процедура ПолеТабличногоДокументаОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ОбработчикРасшифровки <> Неопределено И ирКэш.НомерВерсииПлатформыЛкс() >= 803003 Тогда
		Выполнить("ВыполнитьОбработкуОповещения(ОбработчикРасшифровки, Расшифровка)");
	Иначе
		ирКлиент.ОткрытьЗначениеЛкс(Расшифровка, , СтандартнаяОбработка);
	КонецЕсли; 

КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	ЭтаФорма.КоличествоСтрок = ЭлементыФормы.ПолеТабличногоДокумента.ВысотаТаблицы;
	ЭтаФорма.КоличествоКолонок = ЭлементыФормы.ПолеТабличногоДокумента.ШиринаТаблицы;
	
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

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	ирКлиент.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
КонецПроцедуры

Процедура КоманднаяПанельТабличныйДокументВыделятьТекущиеСтроки(Кнопка)
	
	УстановитьВыделятьТекущиеСтроки(Не Кнопка.Пометка);
	
КонецПроцедуры

Процедура УстановитьВыделятьТекущиеСтроки(Знач НовыйРежим = Истина)
	
	ЭлементыФормы.КоманднаяПанельТабличныйДокумент.Кнопки.ВыделятьТекущиеСтроки.Пометка = НовыйРежим;
	ирКлиент.ПолеТабличногоДокументаПриАктивизацииОбластиЛкс(ЭтаФорма, ЭлементыФормы.ПолеТабличногоДокумента);

КонецПроцедуры

Процедура КодЯзыкаПриИзменении(Элемент = Неопределено)
	
	ЭлементыФормы.ПолеТабличногоДокумента.КодЯзыка = КодЯзыка;
	СписокВыбора = ЭлементыФормы.КодЯзыка.СписокВыбора;
	Если СписокВыбора.НайтиПоЗначению(КодЯзыка) = Неопределено Тогда
		СписокВыбора.Добавить(КодЯзыка);
		СписокВыбора.СортироватьПоПредставлению();
	КонецЕсли;
	
КонецПроцедуры

Процедура КоманднаяПанельТабличныйДокументОчиститьРасшифровки(Кнопка)
	
	ТабличныйДокумент = ЭлементыФормы.ПолеТабличногоДокумента;
	ТекущаяОбласть = ТабличныйДокумент.ТекущаяОбласть;
	Для НомерСтроки = Макс(1, ТекущаяОбласть.Верх) По Макс(ТекущаяОбласть.Низ, ТабличныйДокумент.ВысотаТаблицы) Цикл
		Для НомерКолонки = Макс(1, ТекущаяОбласть.Лево) По Макс(ТекущаяОбласть.Право, ТабличныйДокумент.ШиринаТаблицы) Цикл
			ЭлементыФормы.ПолеТабличногоДокумента.Область(НомерСтроки, НомерКолонки).Расшифровка = Неопределено;
		КонецЦикла;
	КонецЦикла;
	ЭтаФорма.Модифицированность = Истина;
	ПолеТабличногоДокументаПриАктивизацииОбласти();
	
КонецПроцедуры

Процедура НадписьУдалитьЯзыкНажатие(Элемент)
	
	БылиУдаления = Ложь;
	НовыйДокумент = УдалитьЯзыкиТабличногоДокумента(ПолучитьРезультат(), КодЯзыка, БылиУдаления);
	Если БылиУдаления Тогда
		УстановитьРедактируемоеЗначение(НовыйДокумент);
	КонецЕсли;
	
КонецПроцедуры

// Функция - Удалить языки табличного документа лкс
//
// Параметры:
//  ТабДок			 -ТабличныйДокумент - 
//  КодЯзыкаУдалить	 - Строка - если не указан, удаляются все языки отсутствующие в конфигурации
//  выхБылиУдаления	 - Булево - возвращает признак изменности документа
// 
// Возвращаемое значение:
//   - 
//
Функция УдалитьЯзыкиТабличногоДокумента(Знач ТабДок, Знач КодЯзыкаУдалить = "", выхБылиУдаления = Ложь) Экспорт 
	#Если Сервер И Не Сервер Тогда
		ТабДок = Новый ТабличныйДокумент;
	#КонецЕсли
	КодыУдаленныхЯзыков = Новый Массив;  
    Результат = ОбработатьЯзыкиДокумента(ТабДок, КодЯзыкаУдалить, КодыУдаленныхЯзыков);
	выхБылиУдаления = КодыУдаленныхЯзыков.Количество() > 0;
	Если ЗначениеЗаполнено(КодЯзыкаУдалить) И КодыУдаленныхЯзыков.Количество() = 0 Тогда
		КодыУдаленныхЯзыков.Добавить(КодЯзыкаУдалить);
	КонецЕсли;
	Для Каждого КодЯзыкаУдалить Из КодыУдаленныхЯзыков Цикл
		Результат.КодЯзыка = КодЯзыкаУдалить;
		Для НомерСтроки = 1 По Результат.ВысотаТаблицы Цикл
			Для НомерКолонки = 1 По Результат.ШиринаТаблицы Цикл
				Ячейка = Результат.Область(НомерСтроки, НомерКолонки);
				Если ЗначениеЗаполнено(Ячейка.Текст) Тогда
					Ячейка.Текст = "";
					выхБылиУдаления = Истина;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	Возврат Результат;
	
КонецФункции

Функция ОбработатьЯзыкиДокумента(Знач ТабДок, Знач КодЯзыкаУдалить = "", КодыУдаленныхЯзыков = Неопределено, ЯзыкиДокумента = Неопределено)
	
	ДокументДом = ирОбщий.ТекстВДокументDOMЛкс(ирОбщий.ОбъектВСтрокуXMLЛкс(ТабДок));
	#Если Сервер И Не Сервер Тогда
		ТабДок = Новый ТабличныйДокумент;
		ДокументДом = Новый ДокументDOM;
	#КонецЕсли
	КодНачальногоЯзыка = ТабДок.КодЯзыка;
	ЯзыкиКонфигурации = Новый Соответствие;
	Для Каждого МетаЯзык Из Метаданные.Языки Цикл
		ЯзыкиКонфигурации[МетаЯзык.КодЯзыка] = 1;
	КонецЦикла;
	Если ЯзыкиДокумента = Неопределено Тогда
		ЯзыкиДокумента = Новый СписокЗначений;
	КонецЕсли;
	Если КодыУдаленныхЯзыков = Неопределено Тогда
		КодыУдаленныхЯзыков = Новый Массив;
	КонецЕсли;
	ЭлементЯзыки = ДокументДом.ПолучитьЭлементыПоИмени("languageSettings");
	Для Каждого УзелЯзыка Из ЭлементЯзыки[0].ПолучитьЭлементыПоИмени("languageInfo") Цикл
		КодЯзыкаДокумента = УзелЯзыка.ПолучитьЭлементыПоИмени("id")[0].ТекстовоеСодержимое;
		ПредставлениеЯзыкаДокумента = УзелЯзыка.ПолучитьЭлементыПоИмени("code")[0].ТекстовоеСодержимое;
		ДобавитьЯзыкВСписокВыбора(КодЯзыкаДокумента, ПредставлениеЯзыкаДокумента, ЯзыкиДокумента);
		УдалитьЯзык = Ложь;
		Если ЗначениеЗаполнено(КодЯзыкаУдалить) Тогда
			Если КодЯзыкаДокумента = КодЯзыкаУдалить Тогда
				УдалитьЯзык = Истина;
			КонецЕсли;
		ИначеЕсли ЯзыкиКонфигурации[КодЯзыкаДокумента] = Неопределено Тогда
			УдалитьЯзык = Истина;
		КонецЕсли;
		Если УдалитьЯзык Тогда
			КодыУдаленныхЯзыков.Добавить(КодЯзыкаДокумента);
			УзелЯзыка.РодительскийУзел.УдалитьДочерний(УзелЯзыка);
		КонецЕсли;
	КонецЦикла; 
	Если КодыУдаленныхЯзыков.Количество() > 0 Тогда
		Результат = ирОбщий.ОбъектИзСтрокиXMLЛкс(ирОбщий.ДокументDOMВСтрокуЛкс(ДокументДом));
		Результат.КодЯзыка = КодНачальногоЯзыка;
	Иначе
		Результат = ТабДок;
	КонецЕсли;
	Возврат Результат;

КонецФункции

Процедура ДобавитьЯзыкВСписокВыбора(Знач КодЯзыкаДокумента, Знач ПредставлениеЯзыкаДокумента, Знач ЯзыкиДокумента)
	
	ЯзыкиДокумента.Добавить(КодЯзыкаДокумента, ПредставлениеЯзыкаДокумента + " [" + КодЯзыкаДокумента + "]");

КонецПроцедуры

Процедура КоманднаяПанельТабличныйДокументЗагрузитьИзМакета(Кнопка)
	
	ФормаВыбора = ирКлиент.ФормаВыбораМакетаКонфигурацииЛкс(ЭтаФорма);
	ФормаВыбора.ПараметрТипМакета = Тип("ТабличныйДокумент");
	РезультатФормы = ФормаВыбора.ОткрытьМодально();
	Если РезультатФормы <> Неопределено Тогда
		УстановитьРедактируемоеЗначение(РезультатФормы);
	КонецЕсли;
	
КонецПроцедуры

Процедура КоманднаяПанельТабличныйДокументИзБуфераСравнения(Кнопка)
	
	МассивСравнения = ирКэш.БуферСравненияЛкс("" + Тип("ТабличныйДокумент"));
	Если МассивСравнения.Количество() > 0 Тогда
		ТаблицаИзБуфера = МассивСравнения[МассивСравнения.ВГраница()];
		УстановитьРедактируемоеЗначение(ТаблицаИзБуфера);
		ЭтаФорма.Модифицированность = Истина;
	КонецЕсли; 

КонецПроцедуры

Процедура ПараметрыМакетаНажатие(Элемент)
	
	ПараметрыМакета = Новый СписокЗначений;
	ПараметрыМакета.ТипЗначения = Новый ОписаниеТипов("Строка");
	Текст = ирОбщий.ОбъектВСтрокуXMLЛкс(ПолучитьРезультат());
	ирОбщий.ТекстВДокументDOMЛкс(Текст);
	// <detailparameter>
	Вхождения = ирОбщий.НайтиРегВыражениеЛкс(Текст, "<parameter>(.+)</parameter>");
	#Если Сервер И Не Сервер Тогда
		Вхождения = Обработки.ирПлатформа.Создать().ВхожденияРегВыражения;
	#КонецЕсли
	Для Каждого Вхождение Из Вхождения Цикл
		ПараметрыМакета.Добавить(Вхождение.Подгруппа0);
	КонецЦикла;
	ПараметрыМакета.СортироватьПоЗначению();
	ТекущаяОбласть = ЭлементыФормы.ПолеТабличногоДокумента.ТекущаяОбласть;
	Если ТекущаяОбласть <> Неопределено Тогда
		ТекущийЭлементСписка = ПараметрыМакета.НайтиПоЗначению(ТекущаяОбласть.Параметр);
	КонецЕсли;
	РезультатВыбора = ирКлиент.ВыбратьЭлементСпискаЗначенийЛкс(ПараметрыМакета, ТекущийЭлементСписка,, "Выберите параметр для поиска");
	Если РезультатВыбора <> Неопределено Тогда
		Область = ЭлементыФормы.ПолеТабличногоДокумента.НайтиТекст(РезультатВыбора.Значение,,,, Истина,, Истина);
		Если Область <> Неопределено Тогда
			ЭлементыФормы.ПолеТабличногоДокумента.ТекущаяОбласть = Область;
			ЭтаФорма.ТекущийЭлемент = ЭлементыФормы.ПолеТабличногоДокумента;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.ТабличныйДокумент");
УстанавливатьПризнакСодержитЗначение = Истина;