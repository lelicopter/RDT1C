﻿Перем ОбъектМД;
Перем ПолеБД;
Перем МетаРеквизит;

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирКлиент.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ирКлиент.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ЭтаФорма.ПолноеИмяПоля = ИмяТаблицы + "." + ИмяПоля;
	ирОбщий.ОбновитьТекстПослеМаркераВСтрокеЛкс(ЭтаФорма.Заголовок,, ирОбщий.ПоследнийФрагментЛкс(ИмяТаблицы) + "." + ИмяПоля, ": ");
	ПоляТаблицыБД = ирКэш.ПоляТаблицыБДЛкс(ИмяТаблицы);
	ПолеБД = ПоляТаблицыБД.Найти(ИмяПоля, "Имя");
	#Если Сервер И Не Сервер Тогда
		ПолеБД = Обработки.ирТипПолеБД.Создать();
	#КонецЕсли  
	ЭтаФорма.ТипЗначения = ирОбщий.РасширенноеПредставлениеЗначенияЛкс(ПолеБД.ТипЗначения);
	ЭтаФорма.ЗаголовокПоля = ПолеБД.Заголовок;
	ЭтаФорма.ПросмотрТипов = ирОбщий.ЛиЕстьПравоПросмотраТиповЛкс(ПолеБД.ТипЗначения);
	Если Не ПросмотрТипов Тогда
		ЭлементыФормы.ПросмотрТипов.ЦветТекстаПоля = WebЦвета.Красный;
	КонецЕсли;
	ОбъектМД = Неопределено;
	ТипТаблицы = ирОбщий.ТипТаблицыБДЛкс(ИмяТаблицы);
	Если Не ТипТаблицы = "ВиртуальнаяТаблица" Тогда
		СтруктураХраненияБД = ирОбщий.СтруктураХраненияТаблицыБДЛкс(ИмяТаблицы,, ОбъектМД);
		Если СтруктураХраненияБД.Количество() > 0 Тогда
			//ТаблицаХраненияПолей = СтруктураХраненияБД[0].Поля;
			//ПеревестиКолонкиСтруктурыХраненияБДПоляЛкс(ТаблицаХраненияПолей);
			ЭтаФорма.ИмяХранения = СтруктураХраненияБД[0].Поля.Найти(ИмяПоля, "ИмяПоля").ИмяПоляХранения;
			Для Каждого ИндексТаблицыБД Из СтруктураХраненияБД[0].Индексы Цикл
				Если Ложь
					Или ИндексТаблицыБД.Поля[0].ИмяПоля = ИмяПоля
					Или ИндексТаблицыБД.Поля.Количество() > 1 И ИндексТаблицыБД.Поля[0].ИмяПоля = ИмяПоля
				Тогда
					ПредставлениеИндекса = ирОбщий.ПредставлениеИндексаХраненияЛкс(ИндексТаблицыБД,, СтруктураХраненияБД[0]);
					ИндексыХранения.Добавить(ПредставлениеИндекса);
				КонецЕсли;
			КонецЦикла;
			ИндексыХранения.СортироватьПоЗначению();
		КонецЕсли;
	КонецЕсли;
	Если Не ирКэш.ДоступноИсторияДанныхЛкс() Тогда
		ЭлементыФормы.ИспользованиеИсторииДанных.Видимость = Ложь;
		ЭлементыФормы.НадписьИсторияДанных.Видимость = Ложь;
		ЭлементыФормы.ДействияФормы.Кнопки.НайтиВИсторииДанных.Доступность = Ложь;
	КонецЕсли;
	
	МетаРеквизит = ПолеБД.Метаданные;
	РолиПоля.Добавить(ирОбщий.РольПоляБДЛкс(МетаРеквизит, ИмяПоля));
	Если Истина
		И Не ирОбщий.ЛиКорневойТипПеречисленияЛкс(ирОбщий.ПервыйФрагментЛкс(ИмяТаблицы))
		И (Ложь
			Или ТипЗнч(МетаРеквизит) = Тип("ОбъектМетаданных") 
			Или ТипЗнч(МетаРеквизит) = Тип("ОписаниеСтандартногоРеквизита"))
	Тогда
		#Если Сервер И Не Сервер Тогда
			МетаРеквизит = Метаданные.Справочники.ирАлгоритмы.Реквизиты.Комментарий;
		#КонецЕсли 
		Если ирКэш.ДоступноИсторияДанныхЛкс() Тогда
			ИсторияДанныхМоя = ирОбщий.ИсторияДанныхЛкс();
			#Если Сервер И Не Сервер Тогда
				ИсторияДанныхМоя = ИсторияДанных;
			#КонецЕсли
			Попытка
				НастройкиИстории = ИсторияДанныхМоя.ПолучитьНастройки(ОбъектМД);
			Исключение
				// В этой версии платформы не поддерживается этот корневой тип метаданных
				ОписаниеОшибки = ОписаниеОшибки();
			КонецПопытки; 
			Если НастройкиИстории <> Неопределено И НастройкиИстории.Использование Тогда
				НастройкаИстории = ирОбщий.НайтиЭлементКоллекцииЛкс(НастройкиИстории.ИспользованиеПолей, "Ключ", ИмяПоля);
				ЭтаФорма.ИспользованиеИсторииДанных = НастройкаИстории = Неопределено Или НастройкаИстории.Значение;
			КонецЕсли; 
		КонецЕсли; 
		Попытка
			ЭтаФорма.Подсказка = МетаРеквизит.Подсказка;
			ЭтаФорма.Обязательный = МетаРеквизит.ПроверкаЗаполнения = ПроверкаЗаполнения.ВыдаватьОшибку;
		Исключение
			// Графа журнала документов
		КонецПопытки;
		ЭтаФорма.СвязиПараметровВыбора = ирОбщий.ПредставлениеСвязейПараметровВыбораЛкс(МетаРеквизит);
		ЭтаФорма.ПараметрыВыбора = ирОбщий.РасширенноеПредставлениеЗначенияЛкс(ирКлиент.СтруктураОтбораПоСвязямИПараметрамВыбораЛкс(МетаРеквизит));
		Если ТипЗнч(МетаРеквизит) = Тип("ОписаниеСтандартногоРеквизита") Тогда
			ЭтаФорма.ПравоПросмотр = ПравоДоступа("Просмотр", ОбъектМД,, ИмяПоля);
			ЭтаФорма.ПравоРедактирование = ПравоДоступа("Редактирование", ОбъектМД,, ИмяПоля);
		Иначе
			ЭтаФорма.ПравоПросмотр = ПравоДоступа("Просмотр", МетаРеквизит);
			ЭтаФорма.ПравоРедактирование = ПравоДоступа("Редактирование", МетаРеквизит);
		КонецЕсли;
		Если Не ПравоПросмотр Тогда
			ЭлементыФормы.ПравоПросмотр.ЦветТекстаПоля = WebЦвета.Красный;
		КонецЕсли;
		Если ТипЗнч(МетаРеквизит) = Тип("ОбъектМетаданных") Тогда
			ФункциональныеОпцииВключены = Неопределено;
			ирОбщий.ФункциональныеОпцииОбъектаМДЛкс(МетаРеквизит, ЗначенияФункОпций, ФункциональныеОпции, ФункциональныеОпцииВключены);
			Если Не ФункциональныеОпцииВключены Тогда
				ЭлементыФормы.ФункциональныеОпции.ЦветТекстаПоля = WebЦвета.Красный;
			КонецЕсли;
			ЭтаФорма.ФункциональныеОпцииНеВключены = Не ФункциональныеОпцииВключены;
			Если ирОбщий.ЛиКорневойТипВнешнегоИсточникаДанныхЛкс(ирОбщий.ПервыйФрагментЛкс(ИмяТаблицы)) Тогда 
				#Если Сервер И Не Сервер Тогда
					ОбъектМД = Метаданные.ВнешниеИсточникиДанных.ВнешнийИсточникДанных1.Таблицы.Таблица1;
				#КонецЕсли
				РолиПоля.Очистить();;
				Если ОбъектМД.ПоляКлюча.Найти(ИмяПоля) <> Неопределено Тогда
					РолиПоля.Добавить("Ключ");
				КонецЕсли; 
				Если ОбъектМД.ПолеПредставления = МетаРеквизит Тогда 
					РолиПоля.Добавить("Представление");
				КонецЕсли; 
				Если ОбъектМД.ПолеВерсииДанных = МетаРеквизит Тогда 
					РолиПоля.Добавить("Версия данных");
				КонецЕсли; 
				Если ОбъектМД.ПолеРодителя = МетаРеквизит Тогда 
					РолиПоля.Добавить("Родитель");
				КонецЕсли; 
				РолиПоля.СортироватьПоЗначению();
				РолиПоля = РолиПоля.ВыгрузитьЗначения();
				РолиПоля = ирОбщий.СтрСоединитьЛкс(РолиПоля);
			КонецЕсли; 
		КонецЕсли;
	Иначе
		ЭтаФорма.ПравоПросмотр = Истина;
		ЭтаФорма.ПравоРедактирование = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирКлиент.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирКлиент.Форма_ПриЗакрытииЛкс(ЭтаФорма);

КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	ирКлиент.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура ИмяТаблицыОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОткрытьДинамическийСписокИРНажатие();
КонецПроцедуры

Процедура ДействияФормыНайтиВСпискеКолонок(Кнопка = Неопределено)
	
	ФормаСписка = ирКлиент.ФормаВыбораКолонокБДЛкс(ЭтаФорма, ИмяТаблицы + "." + ИмяПоля, Новый Структура("ПолноеИмяТаблицы", ИмяТаблицы));
	ФормаСписка.Открыть();

КонецПроцедуры

Процедура ДействияФормыОткрытьВРедактореОбъектаБД(Кнопка)
	
	ирКлиент.ОткрытьРедакторОбъектаБДЛкс(ИмяТаблицы, ИмяПоля);
	
КонецПроцедуры

Процедура ДействияФормыАнализПравДоступа(Кнопка = Неопределено)
	
	ПолноеИмяПоляТаблицыБД = ИмяТаблицы + "." + ИмяПоля;
	Форма = ирКлиент.ПолучитьФормуЛкс("Отчет.ирАнализПравДоступа.Форма",,, "" + ПолноеИмяПоляТаблицыБД);
	Форма.НаборПолей.Добавить(ПолноеИмяПоляТаблицыБД);
	Форма.ПараметрКлючВарианта = "ПоПолямМетаданных";
	Форма.ВычислятьФункциональныеОпции = Истина;
	Форма.Открыть();
	
КонецПроцедуры

Процедура ПравоПросмотрОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ДействияФормыАнализПравДоступа();
КонецПроцедуры

Процедура ПравоРедактированиеОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ДействияФормыАнализПравДоступа();
КонецПроцедуры

Процедура ПросмотрТиповОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ДействияФормыАнализПравДоступа();
КонецПроцедуры

Процедура ДействияФормыИсследоватьМетаданные(Кнопка)
	Если МетаРеквизит <> Неопределено Тогда
		ирОбщий.ИсследоватьЛкс(МетаРеквизит);
	КонецЕсли;
КонецПроцедуры

Процедура ДействияФормыПоказатьСтруктуруХранения(Кнопка = Неопределено)
	Форма = ирКлиент.ФормаСтруктурыХраненияТаблицыБДЛкс();
	Форма.ПараметрИмяТаблицы = ИмяТаблицы;
	Форма.ПараметрИмяПоля = ИмяПоля;
	Форма.Открыть();
КонецПроцедуры

Процедура ИмяХраненияОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ДействияФормыПоказатьСтруктуруХранения();
КонецПроцедуры

Процедура СвязиПараметровВыбораОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(СвязиПараметровВыбора) Тогда
		СписокВыбора = Новый СписокЗначений;
		СписокВыбора.ЗагрузитьЗначения(ирОбщий.СтрРазделитьЛкс(СвязиПараметровВыбора, ",", Истина));
		СписокВыбора.СортироватьПоЗначению();
		РезультатВыбора = СписокВыбора.ВыбратьЭлемент("Переход к влияющей колонке БД");
		Если РезультатВыбора <> Неопределено Тогда
			ирКлиент.ОткрытьКолонкуБДЛкс(ИмяТаблицы, РезультатВыбора.Значение);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ПараметрыВыбораОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(ПараметрыВыбора) Тогда
		ирОбщий.ИсследоватьЛкс(МетаРеквизит.ПараметрыВыбора);
	КонецЕсли;
КонецПроцедуры

Процедура ТипЗначенияОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ирКлиент.ОткрытьЗначениеЛкс(ПолеБД.ТипЗначения, Ложь);
КонецПроцедуры

Процедура ДействияФормыОткрытьОбъектМетаданныхТаблицы(Кнопка)
	ирКлиент.ОткрытьОбъектМетаданныхЛкс(ОбъектМД);
КонецПроцедуры

Процедура ОткрытьДинамическийСписокИРНажатие(Кнопка = Неопределено)
	ирКлиент.ОткрытьФормуСпискаЛкс(ИмяТаблицы,, Истина,,,,,,, ИмяПоля);
КонецПроцедуры

Процедура ДействияФормыНайтиВИсторииДанных(Кнопка = Неопределено)
	ФормаИнструмента = ирКлиент.ПолучитьФормуЛкс("Обработка.ирИсторияДанных.Форма");
	ФормаИнструмента.ПараметрПолноеИмяМД = ОбъектМД.ПолноеИмя();
	ФормаИнструмента.ПараметрИмяРеквизита = ИмяПоля;
	ФормаИнструмента.Открыть();
КонецПроцедуры

Процедура ИспользованиеИсторииДанныхОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ДействияФормыНайтиВИсторииДанных();
КонецПроцедуры

ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.КолонкаБД");
