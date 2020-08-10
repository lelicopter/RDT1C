﻿Перем мПлатформа;
Перем мПоследняяВыбраннаяТаблицаБД;

Функция СохраняемаяНастройкаФормы(выхНаименование, выхИменаСвойств) Экспорт 
	выхИменаСвойств = "Реквизит.ВыводитьРазницуЧисловыхКолонокСравнения, Реквизит.НеВыводитьОдинаковыеСтроки, Реквизит.НеУчитыватьРегистр, Реквизит.ОбрезатьПробелы, Реквизит.ОтличаютсяЦветТекста,
	|Реквизит.ОтличаютсяЦветФона, Реквизит.РасполагатьСравниваемыеЯчейкиВертикально, Реквизит.ТолькоВТаблице1ЦветТекста, Реквизит.ТолькоВТаблице1ЦветФона, Реквизит.ТолькоВТаблице2ЦветТекста,
	|Реквизит.ТолькоВТаблице2ЦветФона, Реквизит.ТипИсточника1, Реквизит.ТипИсточника2";
	Возврат Неопределено;
КонецФункции

Процедура ЗагрузитьНастройкуВФорме(НастройкаФормы, ДопПараметры) Экспорт 
	
	ирОбщий.ЗагрузитьНастройкуФормыЛкс(ЭтаФорма, НастройкаФормы); 

КонецПроцедуры

Процедура ОсновныеДействияФормыСохранитьНастройки(Кнопка)
	
	ирОбщий.ВыбратьИСохранитьНастройкуФормыЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ОсновныеДействияФормыЗагрузитьНастройки(Кнопка)
	
	ирОбщий.ВыбратьИЗагрузитьНастройкуФормыЛкс(ЭтаФорма);

КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ирОбщий.ФормаОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура Файл1НачалоВыбора(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПолучитьРезультатВыбораФайла(Элемент, 1);
	
КонецПроцедуры

Процедура Файл2НачалоВыбора(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПолучитьРезультатВыбораФайла(Элемент, 2);
	
КонецПроцедуры

Функция ПолучитьРезультатВыбораФайла(ПолеВвода, НомерСтороны)
	
	Если ЭтотОбъект["ТипИсточника" + НомерСтороны] = "ТабличныйДокумент" Тогда
		ПолноеИмяФайла = ирОбщий.ВыбратьФайлЛкс(, "mxl,xls,xlsx,ods", "Табличный документ", ПолеВвода.Значение);
	Иначе
		ПолноеИмяФайла = ирОбщий.ВыбратьФайлЛкс(, "vt_", "Таблица значений", ПолеВвода.Значение);
	КонецЕсли; 
	Если ЗначениеЗаполнено(ПолноеИмяФайла) Тогда
		ирОбщий.ИнтерактивноЗаписатьВЭлементУправленияЛкс(ПолеВвода, ПолноеИмяФайла);
	КонецЕсли;
	
КонецФункции	

Процедура ДействияФормыКнопкаВыполнитьСравнение(Кнопка)
	
	СравнитьТаблицыВФорме();
	
КонецПроцедуры

// Вызывается из ирОбщий.СравнитьЗначенияИнтерактивноЧерезXMLСтрокуЛкс
Функция СравнитьТаблицыВФорме() Экспорт
	
	ВремяНачала = ТекущаяДата();
	ЛиСравнениеВыполнено = ВыполнитьСравнение(ЭлементыФормы.ВыбранныйРезультат);
	Если Не ЛиСравнениеВыполнено Тогда
		Возврат ЛиСравнениеВыполнено;
	КонецЕсли; 
	ОтображениеРезультатаУстановитьОтбор(ЭлементыФормы.ВыбранныйРезультат);
	ЭлементыФормы.Панель.ТекущаяСтраница = ЭлементыФормы.Панель.Страницы.ВыбранныйРезультат;
	РазницаВремени = ТекущаяДата() - ВремяНачала;
	ирОбщий.СообщитьЛкс("Найдено различий: " + ВсегоРазличий + ". Время выполнения: " + РазницаВремени + " сек");
	Возврат ЛиСравнениеВыполнено;

КонецФункции

// открытие первого файла на просмотр
Процедура Файл1Открытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФайлНаПросмотр(ИмяФайла1);
	
КонецПроцедуры

// открытие второго файла на просмотр
Процедура Файл2Открытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФайлНаПросмотр(ИмяФайла2);
	
КонецПроцедуры

// открытие файлов на просмотр
Процедура ОткрытьФайлНаПросмотр(Знач ИмяФайла)
	
	Файл = Новый Файл(ИмяФайла);
	Если ирОбщий.СтрокиРавныЛкс(Файл.Расширение, ".vt_") Тогда
		Таблица1Нажатие();
	ИначеЕсли ирОбщий.СтрокиРавныЛкс(Файл.Расширение, ".mxl") Тогда
		ТабДок = Новый ТабличныйДокумент;
		ТабДок.Прочитать(Файл.ПолноеИмя);
		ТабДок.Показать();
	Иначе
		ЗапуститьПриложение(Файл);
	КонецЕсли;	
	
КонецПроцедуры	

// передвижение к следующему отличию
Процедура КоманднаяПанельРезультатКнопкаПерейтиДалее(Кнопка)
	
	ТекущаяСтрока = ЭлементыФормы.ВыбранныйРезультат.ТекущаяСтрока;
	НачальныйИндекс = -1;
	Если ТекущаяСтрока <> Неопределено Тогда
		НачальныйИндекс = ВыбранныйРезультат.Индекс(ТекущаяСтрока);
	КонецЕсли; 
	Для ИндексСтроки = НачальныйИндекс + 1 По ВыбранныйРезультат.Количество() - 1 Цикл
		ПроверяемаяСтрока = ВыбранныйРезультат[ИндексСтроки];
		Если ПроверяемаяСтрока[мИмяКолонкиРезультатаСравнения] <> ПризнакРавно Тогда
			ЭлементыФормы.ВыбранныйРезультат.ТекущаяСтрока = ПроверяемаяСтрока;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// передвижение к предыдущему отличию
Процедура КоманднаяПанельРезультатКнопкаПерейтиРанее(Кнопка)
	
	ТекущаяСтрока = ЭлементыФормы.ВыбранныйРезультат.ТекущаяСтрока;
	НачальныйИндекс = ВыбранныйРезультат.Количество();
	Если ТекущаяСтрока <> Неопределено Тогда
		НачальныйИндекс = ВыбранныйРезультат.Индекс(ТекущаяСтрока);
	КонецЕсли; 
	Для ИндексСтроки = 1 По НачальныйИндекс Цикл
		ПроверяемаяСтрока = ВыбранныйРезультат[НачальныйИндекс - ИндексСтроки];
		Если ПроверяемаяСтрока[мИмяКолонкиРезультатаСравнения] <> ПризнакРавно Тогда
			ЭлементыФормы.ВыбранныйРезультат.ТекущаяСтрока = ПроверяемаяСтрока;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// отобразить все строки
Процедура КоманднаяПанельРезультатОтборВсе(Кнопка)
	
	ОтображениеРезультатаУстановитьОтбор(ЭлементыФормы.ВыбранныйРезультат, Кнопка.Имя);
	
КонецПроцедуры

// отобразить строки с различиями
Процедура КоманднаяПанельРезультатОтборОтличия(Кнопка)
	
	ОтображениеРезультатаУстановитьОтбор(ЭлементыФормы.ВыбранныйРезультат, Кнопка.Имя);
	
КонецПроцедуры

// отобразить строки только из первого файла
Процедура КоманднаяПанельРезультатОтбор1(Кнопка)
	
	ОтображениеРезультатаУстановитьОтбор(ЭлементыФормы.ВыбранныйРезультат, Кнопка.Имя);
	
КонецПроцедуры

// отобразить строки только из второго файла
Процедура КоманднаяПанельРезультатОтбор2(Кнопка)
	
	ОтображениеРезультатаУстановитьОтбор(ЭлементыФормы.ВыбранныйРезультат, Кнопка.Имя);
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ирОбщий.СоздатьМенеджерСохраненияНастроекФормыЛкс(ЭтаФорма);
	Если ПараметрТаблица1.Колонки.Количество() > 0 Тогда
		ЭтотОбъект.Таблица1 = ПараметрТаблица1.Скопировать();
		ЭтотОбъект.ТипИсточника1 = "ТаблицаЗначений";
	КонецЕсли; 
	Если ПараметрТаблица2.Колонки.Количество() > 0 Тогда
		ЭтотОбъект.Таблица2 = ПараметрТаблица2.Скопировать();
		ЭтотОбъект.ТипИсточника2 = "ТаблицаЗначений";
		ОбновитьСопоставлениеКолонокВФорме();
		ЗаполнитьСопоставлениеКолонок();
		ПодобратьКлючевыеИСравниваемыеКолонки();
	КонецЕсли; 
	НастроитьЭлементыФормы();
	
КонецПроцедуры

Процедура ОбновитьСопоставлениеКолонокВФорме()
	
	ТекущаяСтрока = ЭлементыФормы.КолонкиТаблица1.ТекущаяСтрока;
	Если ТекущаяСтрока <> Неопределено Тогда
		СтарыйКлюч1 = ТекущаяСтрока.ИмяКолонки;
	КонецЕсли; 
	ТекущаяСтрока = ЭлементыФормы.КолонкиТаблица2.ТекущаяСтрока;
	Если ТекущаяСтрока <> Неопределено Тогда
		СтарыйКлюч2 = ТекущаяСтрока.ИмяКолонки;
	КонецЕсли; 
	ОбновитьСопоставлениеКолонок();
	Если СтарыйКлюч1 <> Неопределено Тогда
		ТекущаяСтрока = КолонкиТаблица1.Найти(СтарыйКлюч1, "ИмяКолонки");
		Если ТекущаяСтрока <> Неопределено Тогда
			ЭлементыФормы.КолонкиТаблица1.ТекущаяСтрока = ТекущаяСтрока;
		КонецЕсли; 
	КонецЕсли; 
	Если СтарыйКлюч2 <> Неопределено Тогда
		ТекущаяСтрока = КолонкиТаблица2.Найти(СтарыйКлюч2, "ИмяКолонки");
		Если ТекущаяСтрока <> Неопределено Тогда
			ЭлементыФормы.КолонкиТаблица2.ТекущаяСтрока = ТекущаяСтрока;
		КонецЕсли; 
	КонецЕсли; 
	НастроитьЭлементыФормы();

КонецПроцедуры

Процедура Таблица1Нажатие(Элемент = Неопределено)
	
	КопияСсылкиТаблицы = Таблица1;
	Если ирОбщий.ОткрытьЗначениеЛкс(КопияСсылкиТаблицы, Истина) = Истина Тогда
		Если ТипИсточника1 <> "ТаблицаЗначений" Тогда
			Ответ = Вопрос("Предшествующие стадии получения данных будут отключены. Продолжить?", РежимДиалогаВопрос.ОКОтмена);
			Если Ответ = КодВозвратаДиалога.ОК Тогда
				ирОбщий.ИнтерактивноЗаписатьВЭлементУправленияЛкс(ЭлементыФормы.Файл1, "");
				ирОбщий.ИнтерактивноЗаписатьВЭлементУправленияЛкс(ЭлементыФормы.ТипИсточника1, "ТаблицаЗначений");
			КонецЕсли;
		КонецЕсли; 
		Если ТипИсточника1 = "ТаблицаЗначений" Тогда
			Таблица1 = КопияСсылкиТаблицы;
			ОбновитьСопоставлениеКолонокВФорме();
		КонецЕсли; 
	КонецЕсли; 

КонецПроцедуры

Процедура Таблица2Нажатие(Элемент = Неопределено)
	
	ОбновитьСопоставлениеКолонокВФорме();
	КопияСсылкиТаблицы = Таблица2;
	Если ирОбщий.ОткрытьЗначениеЛкс(КопияСсылкиТаблицы, Истина) = Истина Тогда 
		Если ТипИсточника2 <> "ТаблицаЗначений" Тогда
			Ответ = Вопрос("Предшествующие стадии получения данных будут отключены. Продолжить?", РежимДиалогаВопрос.ОКОтмена);
			Если Ответ = КодВозвратаДиалога.ОК Тогда
				ирОбщий.ИнтерактивноЗаписатьВЭлементУправленияЛкс(ЭлементыФормы.Файл2, "");
				ирОбщий.ИнтерактивноЗаписатьВЭлементУправленияЛкс(ЭлементыФормы.ТипИсточника2, "ТаблицаЗначений");
			КонецЕсли;
		КонецЕсли; 
		Если ТипИсточника2 = "ТаблицаЗначений" Тогда
			Таблица2 = КопияСсылкиТаблицы;
			ОбновитьСопоставлениеКолонокВФорме();
		КонецЕсли; 
	КонецЕсли; 

КонецПроцедуры

Процедура КоманднаяПанельВыводимыеКолонкиФайл1Очистить(Кнопка)
	
	Для Каждого СтрокаСопоставления Из КолонкиТаблица1 Цикл
		СопоставитьКолонку(СтрокаСопоставления);
	КонецЦикла;
	
КонецПроцедуры

Процедура КнопкаОбновитьФайл1Нажатие(Элемент)
	
	ОбновитьДанныеТаблицы("1");
	
КонецПроцедуры

Процедура КнопкаОбновитьФайл2Нажатие(Элемент)
	
	ОбновитьДанныеТаблицы("2");

КонецПроцедуры

Процедура КоманднаяПанельВыводимыеКолонкиФайл1Заполнить(Кнопка)
	
	ЗаполнитьСопоставлениеКолонок();
	
КонецПроцедуры

Процедура ДействияФормыНовоеОкно(Кнопка)
	
	ирОбщий.ОткрытьНовоеОкноОбработкиЛкс(ЭтотОбъект);
	
КонецПроцедуры

Процедура ДействияФормыСтруктураФормы(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруФормыЛкс(ЭтаФорма);

КонецПроцедуры

Процедура ДействияФормыОПодсистеме(Кнопка)
	
	ирОбщий.ОткрытьСправкуПоПодсистемеЛкс(ЭтотОбъект);

КонецПроцедуры

Процедура КоманднаяПанельВыводимыеКолонкиФайл1ПодобратьКлючевыеКолонки(Кнопка)
	
	ПодобратьКлючевыеИСравниваемыеКолонки();
	
КонецПроцедуры

Процедура Файл1Очистка(Элемент = Неопределено, СтандартнаяОбработка = Истина)
	
	//ЭтотОбъект.ЗагрузкаТабличныхДанных1 = Неопределено;
	НастроитьЭлементыФормы();

КонецПроцедуры

Процедура Файл2Очистка(Элемент, СтандартнаяОбработка)
	
	//ЭтотОбъект.ЗагрузкаТабличныхДанных2 = Неопределено;
	НастроитьЭлементыФормы();
	
КонецПроцедуры

Процедура КолонкиТаблица1ПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ОформлениеСтроки.Ячейки.КолонкаТаблицы2.Видимость = Ложь;
	ОформлениеСтроки.Ячейки.Выводить.ТолькоПросмотр = ДанныеСтроки.Ключевая Или ДанныеСтроки.Сравнивать;
	ОформлениеСтроки.Ячейки.Сравнивать.ТолькоПросмотр = ДанныеСтроки.Ключевая Или Не ЗначениеЗаполнено(ДанныеСтроки.ИмяКолонки2);
	ОформлениеСтроки.Ячейки.Ключевая.ТолькоПросмотр = Не ЗначениеЗаполнено(ДанныеСтроки.ИмяКолонки2);
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);

КонецПроцедуры

Процедура КолонкиТаблица2ПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ОформлениеСтроки.Ячейки.КолонкаТаблицы1.Видимость = Ложь;
	СтрокаСопоставления = КолонкиТаблица1.Найти(ДанныеСтроки.ИмяКолонки1, "ИмяКолонки");
	ОформлениеСтроки.Ячейки.Выводить.ТолькоПросмотр = Истина
		И СтрокаСопоставления <> Неопределено
		И (Ложь
			Или СтрокаСопоставления.Ключевая
			Или СтрокаСопоставления.Сравнивать);
	Если ОформлениеСтроки.Ячейки.Выводить.ТолькоПросмотр Тогда
		ОформлениеСтроки.ЦветТекста = ирОбщий.ЦветТекстаНеактивностиЛкс();
	КонецЕсли; 
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);

КонецПроцедуры

Процедура ВыбранныйРезультатПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки, ЭлементыФормы.КоманднаяПанельРезультат.Кнопки.Идентификаторы);
	КодОтличия = ДанныеСтроки[мИмяКолонкиРезультатаСравнения];
	ОформлениеСтроки.Ячейки[мИмяКолонкиРезультатаСравнения].УстановитьТекст(РезультатыСравненияСтрок[КодОтличия]);
	Если КодОтличия = ПризнакНеРавно Тогда
		ЦветФона = ОтличаютсяЦветФона;
		ЦветТекста = ОтличаютсяЦветТекста;
		Для Каждого СравниваемаяКолонка Из СравниваемыеКолонкиРезультата Цикл
			ОформитьСравниваемыеЯчейки(ОформлениеСтроки, СравниваемаяКолонка, ЦветФона, ЦветТекста);
		КонецЦикла;
	ИначеЕсли КодОтличия = ПризнакТолько1 Тогда
		ЦветФона = ТолькоВТаблице1ЦветФона;
		ЦветТекста = ТолькоВТаблице1ЦветТекста;
		ОформитьЯчейку(ОформлениеСтроки, ЦветФона, ЦветТекста);
	ИначеЕсли КодОтличия = ПризнакТолько2 Тогда
		ЦветФона = ТолькоВТаблице2ЦветФона;
		ЦветТекста = ТолькоВТаблице2ЦветТекста;
		ОформитьЯчейку(ОформлениеСтроки, ЦветФона, ЦветТекста);
	Иначе
		ЦветФона = Неопределено;
		ЦветТекста = Неопределено;
	КонецЕсли; 
	Если ЦветФона <> Неопределено Тогда
		ОформитьЯчейку(ОформлениеСтроки.Ячейки[мИмяКолонкиРезультатаСравнения], ЦветФона, ЦветТекста);
	КонецЕсли; 
	ТекущаяКолонка = Элемент.ТекущаяКолонка;
	Если ТекущаяКолонка <> Неопределено И ДанныеСтроки = Элемент.ТекущаяСтрока Тогда
		ЧистоеИмяКолонки = "";
		Если СтруктураКолонокРезультата.Свойство(ТекущаяКолонка.Имя, ЧистоеИмяКолонки) Тогда 
			Если СравниваемыеКолонкиРезультата.Найти(ЧистоеИмяКолонки + "1") <> Неопределено Тогда 
				ОформитьСравниваемыеЯчейки(ОформлениеСтроки, ТекущаяКолонка.Имя, ЦветаСтиля.ЦветФонаВыделенияПоля, ЦветаСтиля.ЦветТекстаВыделенияПоля, Ложь);
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 
	СкрытьЯчейкуЗаголовкаГруппыКолонокСтороны(мИмяГруппыКлючевыхКолонок, , ОформлениеСтроки);
	СкрытьЯчейкиЗаголовковГруппКолонокСтороны(ОформлениеСтроки, "1");
	СкрытьЯчейкиЗаголовковГруппКолонокСтороны(ОформлениеСтроки, "2");
	СкрытьЯчейкуЗаголовкаГруппыКолонокСтороны(мИмяГруппыРазностныхКолонок, , ОформлениеСтроки);

КонецПроцедуры

Процедура ОформитьСравниваемыеЯчейки(Знач ОформлениеСтроки, Знач СравниваемаяКолонка, Знач ЦветФона, Знач ЦветТекста, ТолькоЕслиРазличаются = Истина)
	
	ДанныеСтроки = ОформлениеСтроки.ДанныеСтроки;
	ЧистоеИмяКолонки = СтруктураКолонокРезультата[СравниваемаяКолонка];
	Если Ложь
		Или Не ТолькоЕслиРазличаются
		Или Не СравнитьЗначенияЯчеек(ЧистоеИмяКолонки + "1", ЧистоеИмяКолонки + "2", ДанныеСтроки, ДанныеСтроки) 
	Тогда 
		ОформитьЯчейку(ОформлениеСтроки.Ячейки[ЧистоеИмяКолонки + "1"], ЦветФона, ЦветТекста);
		ОформитьЯчейку(ОформлениеСтроки.Ячейки[ЧистоеИмяКолонки + "2"], ЦветФона, ЦветТекста);
		ИмяРазностнойКолонки = ЧистоеИмяКолонки + "Разность";
		ЯчейкаРазностнойКолонки = ОформлениеСтроки.Ячейки.Найти(ИмяРазностнойКолонки);
		Если ЯчейкаРазностнойКолонки <> Неопределено Тогда
			ОформитьЯчейку(ЯчейкаРазностнойКолонки, ЦветФона, ЦветТекста);
		КонецЕсли; 
	КонецЕсли;

КонецПроцедуры

Процедура ОформитьЯчейку(Ячейка, Знач ЦветФона, Знач ЦветТекста)
	
	Ячейка.ЦветФона = ЦветФона;
	Ячейка.ЦветТекста = ЦветТекста;

КонецПроцедуры

Процедура СкрытьЯчейкиЗаголовковГруппКолонокСтороны(Знач ОформлениеСтроки, НомерСтороны)
	
	СкрытьЯчейкуЗаголовкаГруппыКолонокСтороны(мИмяГруппыСравниваемыхКолонок, НомерСтороны, ОформлениеСтроки);
	СкрытьЯчейкуЗаголовкаГруппыКолонокСтороны(мИмяГруппыНесравниваемыхКолонок, НомерСтороны, ОформлениеСтроки);

КонецПроцедуры

Процедура СкрытьЯчейкуЗаголовкаГруппыКолонокСтороны(Знач ИмяГруппыКолонок, Знач НомерСтороны = "", Знач ОформлениеСтроки)
	
	Ячейка = ОформлениеСтроки.Ячейки.Найти(ИмяГруппыКолонок + НомерСтороны);
	Если Ячейка <> Неопределено Тогда
		Ячейка.Видимость = Ложь;
	КонецЕсли;

КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	ирОбщий.ОбновитьЗаголовкиСтраницПанелейЛкс(ЭтаФорма);

КонецПроцедуры

Процедура КолонкиТаблица1ИмяКолонки2НачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ТабличноеПоле = ЭлементыФормы.КолонкиТаблица1;
	СписокВыбора = ТабличноеПоле.Колонки.ИмяКолонки2.ЭлементУправления.СписокВыбора;
	#Если Сервер И Не Сервер Тогда
	    СписокВыбора = Новый СписокЗначений;
	#КонецЕсли
	СписокВыбора.Очистить();
	Если ЗначениеЗаполнено(ТабличноеПоле.ТекущиеДанные.ИмяКолонки2) Тогда
		СписокВыбора.Добавить(ТабличноеПоле.ТекущиеДанные.ИмяКолонки2, ТабличноеПоле.ТекущиеДанные.ИмяКолонки2);
	КонецЕсли; 
	Для Каждого СтрокаНесопоставленнойКолонки Из КолонкиТаблица2.Выгрузить(Новый Структура("ИмяКолонки1", "")) Цикл
		СписокВыбора.Добавить(СтрокаНесопоставленнойКолонки.ИмяКолонки, СтрокаНесопоставленнойКолонки.СинонимКолонки);
	КонецЦикла;
	СписокВыбора.СортироватьПоПредставлению();
	
КонецПроцедуры

Процедура КолонкиТаблица1СинонимКолонки2НачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ТабличноеПоле = ЭлементыФормы.КолонкиТаблица1;
	СписокВыбора = ТабличноеПоле.Колонки.СинонимКолонки2.ЭлементУправления.СписокВыбора;
	#Если Сервер И Не Сервер Тогда
	    СписокВыбора = Новый СписокЗначений;
	#КонецЕсли
	СписокВыбора.Очистить();
	Если ЗначениеЗаполнено(ТабличноеПоле.ТекущиеДанные.ИмяКолонки2) Тогда
		СписокВыбора.Добавить(ТабличноеПоле.ТекущиеДанные.ИмяКолонки2, ТабличноеПоле.ТекущиеДанные.СинонимКолонки2);
	КонецЕсли; 
	Для Каждого СтрокаНесопоставленнойКолонки Из КолонкиТаблица2.Выгрузить(Новый Структура("ИмяКолонки1", "")) Цикл
		СписокВыбора.Добавить(СтрокаНесопоставленнойКолонки.ИмяКолонки, СтрокаНесопоставленнойКолонки.СинонимКолонки);
	КонецЦикла;
	СписокВыбора.СортироватьПоПредставлению();

КонецПроцедуры

Процедура КолонкиТаблица1ИмяКолонки2ПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Элемент.Значение) Тогда
		Колонка2 = Таблица2.Колонки[Элемент.Значение];
		СопоставитьКолонку(ЭлементыФормы.КолонкиТаблица1.ТекущаяСтрока, Колонка2);
	КонецЕсли; 
	ОбновитьСопоставлениеКолонокВФорме();
	
КонецПроцедуры

Процедура КолонкиТаблица1СинонимКолонки2ПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Элемент.Значение) Тогда
		Колонка2 = Таблица2.Колонки[Элемент.Значение];
		СопоставитьКолонку(ЭлементыФормы.КолонкиТаблица1.ТекущаяСтрока, Колонка2);
		Элемент.Значение = Колонка2.Заголовок;
	КонецЕсли; 
	ОбновитьСопоставлениеКолонокВФорме();
	
КонецПроцедуры

Процедура КоманднаяПанельРезультатКонсольОбработки(Кнопка)
	
	ирОбщий.ОткрытьОбъектыИзВыделенныхЯчеекВПодбореИОбработкеОбъектовЛкс(ЭлементыФормы.ВыбранныйРезультат,, ЭтаФорма);

КонецПроцедуры

Процедура КоманднаяПанельРезультатРазличныеЗначенияКолонки(Кнопка)
	
	ирОбщий.ОткрытьРазличныеЗначенияКолонкиЛкс(ЭлементыФормы.ВыбранныйРезультат);

КонецПроцедуры

Процедура КоманднаяПанельРезультатМенеджерТабличногоПоля(Кнопка)
	
	ирОбщий.ОткрытьМенеджерТабличногоПоляЛкс(ЭлементыФормы.ВыбранныйРезультат, ЭтаФорма);

КонецПроцедуры

Процедура КоманднаяПанельРезультатШиринаКолонок(Кнопка)
	
	ирОбщий.РасширитьКолонкиТабличногоПоляЛкс(ЭлементыФормы.ВыбранныйРезультат);

КонецПроцедуры

Процедура КоманднаяПанельРезультатСжатьКолонки(Кнопка)
	
	ирОбщий.СжатьКолонкиТабличногоПоляЛкс(ЭлементыФормы.ВыбранныйРезультат);
	
КонецПроцедуры

Процедура КоманднаяПанельРезультатИдентификаторы(Кнопка)
	
	ирОбщий.КнопкаОтображатьПустыеИИдентификаторыНажатиеЛкс(Кнопка);
	ЭлементыФормы.ВыбранныйРезультат.ОбновитьСтроки();
	
КонецПроцедуры

Процедура Файл1ПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(ИмяФайла1) Тогда
		ОбновитьДанныеТаблицы("1", Истина, Истина);
	КонецЕсли; 
	НастроитьЭлементыФормы();
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма,,, ТипИсточника1);

КонецПроцедуры

Процедура Файл2ПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(ИмяФайла2) Тогда
		ОбновитьДанныеТаблицы("2", Истина, Истина);
	КонецЕсли; 
	НастроитьЭлементыФормы();
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма,,, ТипИсточника2);

КонецПроцедуры

Процедура НастроитьЭлементыФормы()
	
	Файл1 = Новый файл(ИмяФайла1);
	Файл2 = Новый файл(ИмяФайла2);
	ЭлементыФормы.Файл1.Доступность = ТипИсточника1 <> "Запрос";
	ЭлементыФормы.Файл2.Доступность = ТипИсточника2 <> "Запрос";
	ЭлементыФормы.НастройкаКонвертации1.Доступность = ТипИсточника1 <> "ТаблицаЗначений";
	ЭлементыФормы.НастройкаКонвертации2.Доступность = ТипИсточника2 <> "ТаблицаЗначений"; 
	ЭлементыФормы.СкопироватьНастройкиКонвертации.Доступность = Истина
		И ТипИсточника1 = "ТабличныйДокумент"
		И ТипИсточника2 = "ТабличныйДокумент";
	ЭлементыФормы.КнопкаОбновитьФайл1.Доступность = ТипИсточника1 <> "ТаблицаЗначений";
	ЭлементыФормы.КнопкаОбновитьФайл2.Доступность = ТипИсточника2 <> "ТаблицаЗначений";
	ЭлементыФормы.НадписьНеуникальные1.Гиперссылка = КоличествоНеуникальныхКлючей1 > 0;
	ЭлементыФормы.НадписьНеуникальные2.Гиперссылка = КоличествоНеуникальныхКлючей2 > 0;
	
КонецПроцедуры

Процедура НастройкаКонвертации1Нажатие(Элемент)
	
	ОбновитьДанныеТаблицы("1", Истина);
	
КонецПроцедуры

Процедура НастройкаКонвертации2Нажатие(Элемент)
	
	ОбновитьДанныеТаблицы("2", Истина);

КонецПроцедуры

Процедура КоманднаяПанельРезультатРедакторОбъектаБДЯчейки(Кнопка)
	
	ирОбщий.ОткрытьСсылкуЯчейкиВРедактореОбъектаБДЛкс(ЭлементыФормы.ВыбранныйРезультат);

КонецПроцедуры

Процедура ВыбранныйРезультатПриАктивизацииЯчейки(Элемент)
	
	ЭлементыФормы.ВыбранныйРезультат.ОбновитьСтроки();
	
КонецПроцедуры

Процедура КолонкиТаблица1ПриИзмененииФлажка(Элемент, Колонка)
	
	ирОбщий.ТабличноеПолеПриИзмененииФлажкаЛкс(Элемент, Колонка);
	Если ЭлементыФормы.КолонкиТаблица1.ТекущаяКолонка = ЭлементыФормы.КолонкиТаблица1.Колонки.Ключевая Тогда
		Если Истина
			И Не ЭлементыФормы.КолонкиТаблица1.ТекущиеДанные.Ключевая
			И Не ЭлементыФормы.КолонкиТаблица1.ТекущиеДанные.Сравнивать
		Тогда
			ирОбщий.ИнтерактивноЗаписатьВКолонкуФлажкаЛкс(ЭлементыФормы.КолонкиТаблица1, ЭлементыФормы.КолонкиТаблица1.Колонки.Сравнивать, Истина);
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

Процедура ВыбранныйРезультатВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ирОбщий.ЯчейкаТабличногоПоляРасширенногоЗначения_ВыборЛкс(ЭтаФорма, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ДействияФормыСравнитьЧерезТабличныеДокументы(Кнопка)
	
	СравниваемыйДокумент1 = ирОбщий.ВывестиТаблицуВТабличныйДокументИлиТаблицуЗначенийЛкс(Таблица1); 
	СравниваемыйДокумент2 = ирОбщий.ВывестиТаблицуВТабличныйДокументИлиТаблицуЗначенийЛкс(Таблица2); 
	ирОбщий.СравнитьЗначенияИнтерактивноЧерезXMLСтрокуЛкс(СравниваемыйДокумент1, СравниваемыйДокумент2);
	
КонецПроцедуры

Процедура Файл1НачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, ЭтаФорма, ТипИсточника1);
	
КонецПроцедуры

Процедура Файл2НачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, ЭтаФорма, ТипИсточника2);

КонецПроцедуры

Процедура СкопироватьНастройкиКонвертацииНажатие(Элемент)
	
	Если НастройкаЗагрузки1 <> Неопределено Тогда
		ЭтотОбъект.НастройкаЗагрузки2 = НастройкаЗагрузки1; // Опасно
	КонецЕсли; 
	
КонецПроцедуры

Процедура КоманднаяПанельКолонкиТаблицы1УстановитьФлажки(Кнопка)
	
	КолонкиТаблица1УстановитьСнятьФлажки(Истина);
	
КонецПроцедуры

Процедура КолонкиТаблица1УстановитьСнятьФлажки(НовоеЗначениеПометки)
	
	Если Ложь
		Или ЭлементыФормы.КолонкиТаблица1.ТекущаяКолонка = ЭлементыФормы.КолонкиТаблица1.Колонки.Ключевая
		Или ЭлементыФормы.КолонкиТаблица1.ТекущаяКолонка = ЭлементыФормы.КолонкиТаблица1.Колонки.Сравнивать
		Или ЭлементыФормы.КолонкиТаблица1.ТекущаяКолонка = ЭлементыФормы.КолонкиТаблица1.Колонки.Выводить
	Тогда
		ирОбщий.ИзменитьПометкиВыделенныхИлиОтобранныхСтрокЛкс(ЭлементыФормы.КолонкиТаблица1, ЭлементыФормы.КолонкиТаблица1.ТекущаяКолонка.Имя, НовоеЗначениеПометки);
	КонецЕсли;

КонецПроцедуры

Процедура КоманднаяПанельКолонкиТаблицы1СнятьФлажки(Кнопка)
	
	КолонкиТаблица1УстановитьСнятьФлажки(Ложь);

КонецПроцедуры

Процедура НадписьНеуникальные2Нажатие(Элемент)
	
	ПоказатьНеуникальныеКлючи("2");
	
КонецПроцедуры

Процедура НадписьНеуникальные1Нажатие(Элемент)
	
	ПоказатьНеуникальныеКлючи("1");
	
КонецПроцедуры

Процедура ПоказатьНеуникальныеКлючи(Знач НомерСтороны)
	
	СтрокаКлючаИсточника = "";
	КлючиНеуникальные = ВыявитьНеуникальныеКлючи(НомерСтороны, СтрокаКлючаИсточника);
	ТаблицаЛок = ЭтотОбъект["Таблица" + НомерСтороны];
	ФормаТаблицы = мПлатформа.ПолучитьФорму("ТаблицаЗначений", , ТаблицаЛок);
	ФормаТаблицы.УстановитьРедактируемоеЗначение(ТаблицаЛок);
	ФормаТаблицы.ПараметрИменаКлючевыхКолонок = СтрокаКлючаИсточника;
	ФормаТаблицы.ОткрытьМодально();

КонецПроцедуры

Процедура КолонкиТаблица2ПриИзмененииФлажка(Элемент, Колонка)
	
	ирОбщий.ТабличноеПолеПриИзмененииФлажкаЛкс(Элемент, Колонка);

КонецПроцедуры

Процедура КолонкиТаблица1КлючеваяПриИзменении(Элемент)
	
	Если ЭлементыФормы.КолонкиТаблица1.ТекущаяСтрока.Ключевая Тогда
		ЭлементыФормы.КолонкиТаблица1.ТекущаяСтрока.Сравнивать = Ложь;
	КонецЕсли; 
	ВыявитьНеуникальныеКлючи("1");
	ВыявитьНеуникальныеКлючи("2");
	НастроитьЭлементыФормы();

КонецПроцедуры

Процедура КолонкиТаблица1ПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);

КонецПроцедуры

Процедура ВыбранныйРезультатПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);

КонецПроцедуры

Процедура КолонкиТаблица2ПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	
КонецПроцедуры

Процедура ТипИсточника1ПриИзменении(Элемент = Неопределено)
	
	ИмяФайла1 = "";
	НастроитьЭлементыФормы();
	
КонецПроцедуры

Процедура ТипИсточника2ПриИзменении(Элемент = Неопределено)
	
	ИмяФайла2 = "";
	НастроитьЭлементыФормы();
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	Если КонсольЗапросов1 <> Неопределено Тогда
		КонсольЗапросов1.УничтожитьКомпоненты();
	КонецЕсли; 
	Если КонсольЗапросов2 <> Неопределено Тогда
		КонсольЗапросов2.УничтожитьКомпоненты();
	КонецЕсли; 
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура КоманднаяПанельРезультатОткрытьТаблицу(Кнопка)
	
	ирОбщий.ОткрытьЗначениеЛкс(ЭлементыФормы.ВыбранныйРезультат.Значение.Скопировать(),,,, Ложь,, ЭлементыФормы.ВыбранныйРезультат);
	
КонецПроцедуры

Процедура УстановитьСтандартныеЦветаНажатие(Элемент)
	
	УстановитьСтандартныеЦвета();
	
КонецПроцедуры

Процедура КоманднаяПанельКолонкиТаблицы1УстановитьКлючевыеКолонкиПоТаблицеБД(Кнопка)
	
	ФормаВыбораОбъектаБД = ирОбщий.ПолучитьФормуВыбораОбъектаМетаданныхЛкс(,, мПоследняяВыбраннаяТаблицаБД,,,, Истина, Истина,,, Истина, Истина);
	РезультатВыбора = ФормаВыбораОбъектаБД.ОткрытьМодально();
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	мПоследняяВыбраннаяТаблицаБД = РезультатВыбора.ПолноеИмяОбъекта;
	СтруктураКлюча = ирОбщий.СтруктураКлючаТаблицыБДЛкс(ирОбщий.ИмяТаблицыИзМетаданныхЛкс(мПоследняяВыбраннаяТаблицаБД),,, Ложь);
	#Если Сервер И Не Сервер Тогда
		СтруктураКлюча = Новый Структура;
	#КонецЕсли
	Для Каждого КлючИЗначение Из СтруктураКлюча Цикл
		СтрокаПоля = КолонкиТаблица1.Найти(КлючИЗначение.Ключ, "ИмяКолонки");
		Если СтрокаПоля <> Неопределено Тогда
			Если ЗначениеЗаполнено(СтрокаПоля.ИмяКолонки2) Тогда
				СтрокаПоля.Ключевая = Истина;
				СтрокаПоля.Выводить = Истина;
				СтрокаПоля.Сравнивать = Ложь;
			Иначе
				ирОбщий.СообщитьЛкс("Колонка поля """ + КлючИЗначение.Ключ + """ ключа не сопоставлена стороне 2");
			КонецЕсли; 
		Иначе
			ирОбщий.СообщитьЛкс("Поле """ + КлючИЗначение.Ключ + """ ключа не найдено в списке колонок");
		КонецЕсли; 
	КонецЦикла;
	
КонецПроцедуры

Процедура КлсУниверсальнаяКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры


ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирСравнениеТаблиц.Форма.Форма");
мПлатформа = ирКэш.Получить();
ТипИсточника1 = "ТабличныйДокумент";
ЭлементыФормы.ТипИсточника1.СписокВыбора.Добавить("Запрос");
ЭлементыФормы.ТипИсточника1.СписокВыбора.Добавить("ТабличныйДокумент", "Табличный документ");
ЭлементыФормы.ТипИсточника1.СписокВыбора.Добавить("ТаблицаЗначений", "Таблица значений");
ТипИсточника2 = "ТабличныйДокумент";
ЭлементыФормы.ТипИсточника2.СписокВыбора = ЭлементыФормы.ТипИсточника1.СписокВыбора;
