﻿Перем ЗначенияКонстант;

Процедура КнопкаВыполнитьНажатие(Кнопка)
	// Вставить содержимое обработчика.
КонецПроцедуры

Процедура КоманднаяПанель1ЗаписатьКонстанты(Кнопка)
	
	Для каждого СтрокаКонстанты Из ТаблицаКонстант Цикл
		Если НЕ СтрокаКонстанты.ПризнакМодификации Тогда
			Продолжить;
		КонецЕсли;
		Если ПравоДоступа("Изменение", Метаданные.Константы[СтрокаКонстанты.ИдентификаторКонстанты], ПользователиИнформационнойБазы.ТекущийПользователь()) Тогда
			//МенеджерЗначения = Константы[СтрокаКонстанты.ИдентификаторКонстанты].СоздатьМенеджерЗначения();
			СтруктураОбъекта = ирОбщий.ОбъектБДПоКлючуЛкс("Константа." + СтрокаКонстанты.ИдентификаторКонстанты);
			ТекущиеДанные = ЗначенияКонстант.Найти(СтрокаКонстанты.ИдентификаторКонстанты, "ИдентификаторКонстанты");
			СтруктураОбъекта.Данные.Значение = ТекущиеДанные.РасширенноеЗначение;
			Попытка
				ирОбщий.ЗаписатьОбъектЛкс(СтруктураОбъекта.Методы);
			Исключение
				ирОбщий.СообщитьЛкс("Ошибка записи константы """ + СтрокаКонстанты.ИдентификаторКонстанты + """:" + ОписаниеОшибки());
				Продолжить;
			КонецПопытки;
			СтрокаКонстанты.ПризнакМодификации = Ложь;
			СтруктураОбъекта.Методы.Прочитать();
			УстановитьСчитанноеЗначениеКонстанты(СтрокаКонстанты, СтруктураОбъекта.Данные.Значение);
			//ЗаписьЖурналаРегистрации("Редактирование константы", УровеньЖурналаРегистрации.Информация, Метаданные.Константы[СтрокаКонстанты.ИдентификаторКонстанты], СтрокаКонстанты.Значение);
		КонецЕсли; 
	КонецЦикла;
	Модифицированность = Ложь;
	
КонецПроцедуры

Процедура ПрочитатьКонстантыИзБазы()
	
	#Если Сервер И Не Сервер Тогда
		ЗначенияКонстант = Новый ТаблицаЗначений;
	#КонецЕсли
	СостояниеСтрокТП = ирОбщий.ТабличноеПолеСостояниеСтрокЛкс(ЭлементыФормы.ТаблицаКонстант, "ИдентификаторКонстанты");
	ТаблицаКонстант.Очистить();
	ЗначенияКонстант.Очистить();
	ЭлементыФормы.НадписьЕстьНедоступныеКонстанты.Видимость = Ложь;
	ХранениеФункОпций = Новый ТаблицаЗначений;
	ХранениеФункОпций.Колонки.Добавить("ИмяОпции");
	ХранениеФункОпций.Колонки.Добавить("ИмяКонстанты");
	Для Каждого МетаФункциональнаяОпция Из Метаданные.ФункциональныеОпции Цикл
		ОбъектМДХранения = МетаФункциональнаяОпция.Хранение;
		Если ирОбщий.ЛиКорневойТипКонстантыЛкс(ирОбщий.ПервыйФрагментЛкс(ОбъектМДХранения.ПолноеИмя())) Тогда
			СтрокаХранения = ХранениеФункОпций.Добавить();
			СтрокаХранения.ИмяОпции = МетаФункциональнаяОпция.Имя;
			СтрокаХранения.ИмяКонстанты = ОбъектМДХранения.Имя;
		КонецЕсли; 
	КонецЦикла;
	ХранениеФункОпций.Индексы.Добавить("ИмяКонстанты");
	Для каждого Константа Из Метаданные.Константы Цикл
		//Если НЕ ПравоДоступа("Чтение", Константа, ПользователиИнформационнойБазы.ТекущийПользователь()) Тогда
		//    Продолжить;
		//КонецЕсли;
		КонстантаМенеджер = Константы[Константа.имя];
		ЗначенияФункОпций = Неопределено;
		СписокФункОпций = Неопределено;
		ФункциональныеОпцииВключены = Неопределено;
		ирОбщий.ФункциональныеОпцииОбъектаМДЛкс(Константа, ЗначенияФункОпций, СписокФункОпций, ФункциональныеОпцииВключены);
		ТекущиеДанные = ЗначенияКонстант.Добавить();
		ТекущиеДанные.ИдентификаторКонстанты = Константа.Имя;
		ТекущиеДанные.ФункциональныеОпции = СписокФункОпций;
		ТекущиеДанные.ЗначенияФункОпций = ЗначенияФункОпций;
		ТекущиеДанные.ОписаниеТипов = Константа.Тип;
		НоваяСтрока = ТаблицаКонстант.Добавить();
		НоваяСтрока.ИдентификаторКонстанты = Константа.Имя;
		НоваяСтрока.СинонимКонстанты = Константа.Синоним;
		НоваяСтрока.Подсказка = Константа.Подсказка;
		НоваяСтрока.ОписаниеТипов = Константа.Тип;
		НоваяСтрока.РазрешеноИзменение = ПравоДоступа("Изменение", Константа, ПользователиИнформационнойБазы.ТекущийПользователь());
		НоваяСтрока.ЕстьДоступ = ПравоДоступа("Чтение", Константа, ПользователиИнформационнойБазы.ТекущийПользователь());
		СтрокаХранения = ХранениеФункОпций.Найти(Константа.Имя, "ИмяКонстанты");
		Если СтрокаХранения <> Неопределено Тогда
			НоваяСтрока.ХранимаяФункциональнаяОпция = СтрокаХранения.ИмяОпции;
		КонецЕсли; 
		НоваяСтрока.ФункциональныеОпцииНеВключены = Не ФункциональныеОпцииВключены;
		НоваяСтрока.ФункциональныеОпции = СписокФункОпций;
	КонецЦикла;
	ЧитаемыеКонстанты = ТаблицаКонстант.НайтиСтроки(Новый Структура("ЕстьДоступ", Истина));
	
	ИменаКонстант = ТаблицаКонстант.Выгрузить(ЧитаемыеКонстанты).ВыгрузитьКолонку("ИдентификаторКонстанты");
	МаксРазмерПорции = 50;
	ПозицияПорции = 0;
	Разделитель = ",";
	ЗаписьXML = Неопределено;
	Пока Истина Цикл
		Если ЗаписьXML = Неопределено Тогда
			ЗаписьXML = Новый ЗаписьXML;
			ЗаписьXML.УстановитьСтроку();
			ТекРазмерПорции = 0;
		КонецЕсли; 
		ИмяКонстанты = ИменаКонстант[ПозицияПорции + ТекРазмерПорции];
		ЗаписьXML.ЗаписатьБезОбработки("" + ИмяКонстанты + ", " );
		ТекРазмерПорции = ТекРазмерПорции + 1;
		ЭтоКонец = ПозицияПорции + ТекРазмерПорции = ЧитаемыеКонстанты.Количество() - 1;
		Если Ложь
			Или ТекРазмерПорции = МаксРазмерПорции 
			Или ЭтоКонец
		Тогда
			Запрос = Новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ " + ЗаписьXML.Закрыть() + "1
			|ИЗ Константы КАК Константы";
			ТаблицаРезультата = Запрос.Выполнить().Выгрузить();
			Для Индекс = 0 По ТекРазмерПорции - 1 Цикл 
				КолонкаРезультата = ТаблицаРезультата.Колонки[Индекс];
				УстановитьСчитанноеЗначениеКонстанты(ЧитаемыеКонстанты[ПозицияПорции + Индекс], ТаблицаРезультата[0][КолонкаРезультата.Имя]);
			КонецЦикла;
			Если ЭтоКонец Тогда
				Прервать;
			КонецЕсли; 
			ЗаписьXML = Неопределено;
			ПозицияПорции = ПозицияПорции + МаксРазмерПорции;
		КонецЕсли; 
	КонецЦикла;
	
	ирОбщий.ТабличноеПолеВосстановитьСостояниеСтрокЛкс(ЭлементыФормы.ТаблицаКонстант, СостояниеСтрокТП);
	
КонецПроцедуры

Процедура УстановитьСчитанноеЗначениеКонстанты(Знач НоваяСтрока, Знач ЗначениеКонстанты)
	
	ТекущиеДанные = ЗначенияКонстант.Найти(НоваяСтрока.ИдентификаторКонстанты, "ИдентификаторКонстанты");
	ТекущиеДанные.РасширенноеЗначение = ЗначениеКонстанты;
	НоваяСтрока.Значение = ЗначениеКонстанты;
	ирОбщий.ОбновитьТипЗначенияВСтрокеТаблицыЛкс(НоваяСтрока, Неопределено, ТекущиеДанные.ОписаниеТипов,,, ТаблицаКонстант.ВыгрузитьКолонки().Колонки, ЗначениеКонстанты);

КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	ЗначенияКонстант = Новый ТаблицаЗначений;
	ЗначенияКонстант.Колонки.Добавить("ИдентификаторКонстанты", Новый ОписаниеТипов("Строка"));
	ЗначенияКонстант.Колонки.Добавить("РасширенноеЗначение");
	ЗначенияКонстант.Колонки.Добавить("ЗначенияФункОпций");
	ЗначенияКонстант.Колонки.Добавить("ОписаниеТипов", Новый ОписаниеТипов("ОписаниеТипов"));
	ЗначенияКонстант.Колонки.Добавить("ФункциональныеОпции", Новый ОписаниеТипов("СписокЗначений"));
	ЗначенияКонстант.Индексы.Добавить("ИдентификаторКонстанты");
	ПрочитатьКонстантыИзБазы();
КонецПроцедуры

Процедура ТаблицаКонстантПередНачаломДобавления(Элемент, Отказ, Копирование)
	Отказ = ИСТИНА;
КонецПроцедуры

Процедура ТаблицаКонстантПередУдалением(Элемент, Отказ)
	Отказ = ИСТИНА;
КонецПроцедуры

Процедура ТаблицаКонстантПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	Элемент.Колонки.Значение.ЭлементУправления.ОграничениеТипа = Метаданные.Константы[ЭлементыФормы.ТаблицаКонстант.ТекущиеДанные.ИдентификаторКонстанты].Тип;
	ЭлементыФормы.ТаблицаКонстант.ТекущиеДанные.ПризнакМодификации = ИСТИНА;
	ЭтаФорма.Модифицированность = Истина;
	МетодыПоследниеВыбранныеДобавить();
КонецПроцедуры

Процедура ТаблицаКонстантПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ТекущиеДанные = ЗначенияКонстант.Найти(ДанныеСтроки.ИдентификаторКонстанты, "ИдентификаторКонстанты");
	РасширенныеКолонки = Новый Структура("Значение, ФункциональныеОпции", "РасширенноеЗначение", "ФункциональныеОпции");
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки, , "Значение", РасширенныеКолонки, Истина, ТекущиеДанные);
	Если ДанныеСтроки.ФункциональныеОпцииНеВключены Или Не ДанныеСтроки.ЕстьДоступ Тогда
		ОформлениеСтроки.ЦветТекста = WebЦвета.Красный;
	КонецЕсли; 
	Если ДанныеСтроки.ПризнакМодификации = Истина Тогда
		ОформлениеСтроки.ЦветТекста = ирОбщий.ЦветТекстаИзмененныхДанныхЛкс();
	КонецЕсли; 
	Если Не ДанныеСтроки.РазрешеноИзменение Или Не ДанныеСтроки.ЕстьДоступ Тогда
		ОформлениеСтроки.Ячейки.Значение.ТолькоПросмотр = ИСТИНА;
	КонецЕсли;
	Если Не ДанныеСтроки.ЕстьДоступ Тогда
		ОформлениеСтроки.Ячейки.Значение.Текст = "<Недоступно>";
	КонецЕсли; 
	
КонецПроцедуры

// <Описание функции>
//
// Параметры:
//  <Параметр1>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>;
//  <Параметр2>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>.
//
// Возвращаемое значение:
//               – <Тип.Вид> – <описание значения>
//                 <продолжение описания значения>;
//  <Значение2>  – <Тип.Вид> – <описание значения>
//                 <продолжение описания значения>.
//
Функция ПроверкаМодифицированностиФормы()

	Результат = Истина;
	Ответ = ирОбщий.ЗапроситьСохранениеДанныхФормыЛкс(ЭтаФорма);
	Если Ответ = КодВозвратаДиалога.Отмена Тогда
		Результат = Ложь;
	ИначеЕсли Ответ = КодВозвратаДиалога.Да Тогда
		КоманднаяПанель1ЗаписатьКонстанты(0);
	КонецЕсли;
	Возврат Результат;

КонецФункции

Процедура КоманднаяПанель1Перечитать(Кнопка)
	
	Если Не ПроверкаМодифицированностиФормы() Тогда
		Возврат;
	КонецЕсли;
	ПрочитатьКонстантыИзБазы();
	
КонецПроцедуры

Процедура ТаблицаКонстантПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	ЭлементыФормы.ТаблицаКонстант.Колонки.Значение.ЭлементУправления.ОграничениеТипа = Метаданные.Константы[Элемент.ТекущиеДанные.ИдентификаторКонстанты].Тип;
КонецПроцедуры

Процедура ПриОткрытии()
	
	ирОбщий.Форма_ПриОткрытииЛкс(ЭтаФорма);
	Если ЗначениеЗаполнено(НачальноеЗначениеВыбора) Тогда
		ТекущаяСтрока = ТаблицаКонстант.Найти(НачальноеЗначениеВыбора, "ИдентификаторКонстанты");
		Если ТекущаяСтрока <> Неопределено Тогда
			ЭтаФорма.ЭлементыФормы.ТаблицаКонстант.ТекущаяСтрока = ТекущаяСтрока;
			ЭтаФорма.ЭлементыФормы.ТаблицаКонстант.ТекущаяКолонка = ЭтаФорма.ЭлементыФормы.ТаблицаКонстант.Колонки.Значение;
		КонецЕсли; 
	КонецЕсли; 
	ОбновитьПодменюПоследниеВыбранные();
	
КонецПроцедуры

Процедура ОбновитьПодменюПоследниеВыбранные()
	
	ирОбщий.ПоследниеВыбранныеЗаполнитьПодменюЛкс(ЭтаФорма, ЭлементыФормы.КоманднаяПанель1.Кнопки.ПоследниеВыбранные, ЭлементыФормы.ТаблицаКонстант);

КонецПроцедуры

Функция ПоследниеВыбранныеНажатие(Кнопка) Экспорт
	
	ирОбщий.ПоследниеВыбранныеНажатиеЛкс(ЭтаФорма, ЭлементыФормы.ТаблицаКонстант, "ИдентификаторКонстанты", Кнопка);
	
КонецФункции

Процедура МетодыПоследниеВыбранныеДобавить(Знач ТекущиеДанные = Неопределено)
	
	Если ТекущиеДанные = Неопределено Тогда
		ТекущиеДанные = ЭлементыФормы.ТаблицаКонстант.ТекущиеДанные;
	КонецЕсли; 
	ирОбщий.ПоследниеВыбранныеДобавитьЛкс(ЭтаФорма, ТекущиеДанные.ИдентификаторКонстанты, ТекущиеДанные.СинонимКонстанты, ЭлементыФормы.ТаблицаКонстант);
	ОбновитьПодменюПоследниеВыбранные();

КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Отказ = Не ПроверкаМодифицированностиФормы();
	
КонецПроцедуры

Процедура ТаблицаКонстантЗначениеКонстантыПриИзменении(Элемент)
	
	ТекущиеДанные = ЗначенияКонстант.Найти(ЭлементыФормы.ТаблицаКонстант.ТекущиеДанные.ИдентификаторКонстанты, "ИдентификаторКонстанты");
	ТекущиеДанные.РасширенноеЗначение = ЭлементыФормы.ТаблицаКонстант.ТекущиеДанные.Значение;
	ОбновитьТипЗначенияВСтрокеТаблицы();
	
КонецПроцедуры

Процедура ТаблицаКонстантПриИзмененииФлажка(Элемент, Колонка)
	
	ирОбщий.ТабличноеПолеПриИзмененииФлажкаЛкс(Элемент, Колонка);

КонецПроцедуры

Процедура ТаблицаКонстантЗначениеКонстантыОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	ирОбщий.ПолеВвода_ОкончаниеВводаТекстаЛкс(Элемент, Текст, Значение, СтандартнаяОбработка);

КонецПроцедуры

Процедура КоманднаяПанель1ЖурналРегистрации(Кнопка)
	
	ТекущаяСтрока = ЭлементыФормы.ТаблицаКонстант.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	АнализЖурналаРегистрации = ирОбщий.СоздатьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирАнализЖурналаРегистрации");
	#Если Сервер И Не Сервер Тогда
		АнализЖурналаРегистрации = Обработки.ирАнализЖурналаРегистрации.Создать();
	#КонецЕсли
	АнализЖурналаРегистрации.ОткрытьСПараметром("Метаданные", "Константа." + ТекущаяСтрока.ИдентификаторКонстанты);
	
КонецПроцедуры

Процедура КоманднаяПанель1РедакторОбъектаБДСтроки(Кнопка)
	
	ТекущаяСтрока = ЭлементыФормы.ТаблицаКонстант.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	КлючОбъекта = Новый ("КонстантаМенеджерЗначения." + ТекущаяСтрока.ИдентификаторКонстанты);
	ирОбщий.ОткрытьСсылкуВРедактореОбъектаБДЛкс(КлючОбъекта);
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	ирОбщий.ФормаОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработчикОжиданияСПараметрамиЛкс() Экспорт 
	
	ирОбщий.ОбработчикОжиданияСПараметрамиЛкс();

КонецПроцедуры

Процедура ТаблицаКонстантВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ТекущиеДанные = ЗначенияКонстант.Найти(ВыбраннаяСтрока.ИдентификаторКонстанты, "ИдентификаторКонстанты");
	Если Колонка = ЭлементыФормы.ТаблицаКонстант.Колонки.ХранимаяФункциональнаяОпция Тогда
		Если ЗначениеЗаполнено(ВыбраннаяСтрока.ХранимаяФункциональнаяОпция) Тогда
			ирОбщий.ИсследоватьЛкс(Метаданные.ФункциональныеОпции[ВыбраннаяСтрока.ХранимаяФункциональнаяОпция]);
		КонецЕсли; 
	ИначеЕсли Колонка = ЭлементыФормы.ТаблицаКонстант.Колонки.Подсказка Тогда
		Если ЗначениеЗаполнено(ВыбраннаяСтрока[Колонка.Имя]) Тогда
			ирОбщий.ОткрытьТекстЛкс(ВыбраннаяСтрока[Колонка.Имя]);
		КонецЕсли; 
	ИначеЕсли Колонка = ЭлементыФормы.ТаблицаКонстант.Колонки.ФункциональныеОпции Тогда 
		Если ТекущиеДанные.ЗначенияФункОпций = Неопределено Или ТекущиеДанные.ЗначенияФункОпций.Количество() = 0 Тогда
			Возврат;
		КонецЕсли; 
		мПлатформа = ирКэш.Получить();
		#Если Сервер И Не Сервер Тогда
		    мПлатформа = Обработки.ирПлатформа.Создать();
		#КонецЕсли
		ФормаПросмотра = мПлатформа.ПолучитьФорму("ЗначенияФункциональныхОпций", , ТекущиеДанные.ЗначенияФункОпций);
		ФормаПросмотра.НачальноеЗначениеВыбора = ТекущиеДанные.ЗначенияФункОпций;
		ФормаПросмотра.Открыть();
	Иначе
		Если ирОбщий.ЯчейкаТабличногоПоляРасширенногоЗначения_ВыборЛкс(ЭтаФорма, Элемент, СтандартнаяОбработка, ТекущиеДанные.РасширенноеЗначение) Тогда 
			ОбновитьТипЗначенияВСтрокеТаблицы();
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбновитьТипЗначенияВСтрокеТаблицы()
	
	ТекущиеДанные = ЗначенияКонстант.Найти(ЭлементыФормы.ТаблицаКонстант.ТекущиеДанные.ИдентификаторКонстанты, "ИдентификаторКонстанты");
	ирОбщий.ОбновитьТипЗначенияВСтрокеТаблицыЛкс(ЭлементыФормы.ТаблицаКонстант.ТекущиеДанные, Неопределено, ТекущиеДанные.ОписаниеТипов,,, ТаблицаКонстант.ВыгрузитьКолонки().Колонки, ТекущиеДанные.РасширенноеЗначение);

КонецПроцедуры

Процедура ТаблицаКонстантЗначениеНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаКолонкиРасширенногоЗначения_НачалоВыбораЛкс(ЭтаФорма, ЭлементыФормы.ТаблицаКонстант, СтандартнаяОбработка);
		
КонецПроцедуры

Процедура _КоманднаяПанель1СправкаМетаданного(Кнопка)
	
	Если ЭлементыФормы.ТаблицаКонстант.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ОткрытьСправку(ирКэш.ОбъектМДПоПолномуИмениЛкс("Константа." + ЭлементыФормы.ТаблицаКонстант.ТекущаяСтрока.ИдентификаторКонстанты));
	
КонецПроцедуры

Процедура КоманднаяПанель1ВключитьВсеФункциональныеОпции(Кнопка)
	
	Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(ТаблицаКонстант.Количество());
	Для каждого СтрокаКонстанты из ТаблицаКонстант Цикл
		ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
		ТекущиеДанные = ЗначенияКонстант.Найти(СтрокаКонстанты.ИдентификаторКонстанты, "ИдентификаторКонстанты");
		Если Истина
			И ЗначениеЗаполнено(СтрокаКонстанты.ХранимаяФункциональнаяОпция) 
			И СтрокаКонстанты.РазрешеноИзменение
			И ТекущиеДанные.ОписаниеТипов.СодержитТип(Тип("Булево")) 
		Тогда
			ТекущиеДанные.РасширенноеЗначение = Истина;
			СтрокаКонстанты.Значение = ТекущиеДанные.РасширенноеЗначение;
			СтрокаКонстанты.ПризнакМодификации = Истина;
			ЭтаФорма.Модифицированность = Истина;
		КонецЕсли; 
	КонецЦикла;
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	
КонецПроцедуры

Процедура ТаблицаКонстантЗначениеОткрытие(Элемент, СтандартнаяОбработка)
	
	РасширенноеЗначение = ЭлементыФормы.ТаблицаКонстант.ТекущаяСтрока.Значение;
	Если Ложь
		Или ТипЗнч(РасширенноеЗначение) = Тип("ХранилищеЗначения")
	Тогда
		СтандартнаяОбработка = Ложь;
		ирОбщий.ИсследоватьЛкс(РасширенноеЗначение);
	КонецЕсли; 

КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура КоманднаяПанель1ОткрытьОбъектМетаданных(Кнопка)
	
	Если ЭлементыФормы.ТаблицаКонстант.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ирОбщий.ОткрытьОбъектМетаданныхЛкс("Константа." + ЭлементыФормы.ТаблицаКонстант.ТекущаяСтрока.ИдентификаторКонстанты);
	
КонецПроцедуры

Процедура КоманднаяПанель1ПараметрыЗаписи(Кнопка)
	
	ирОбщий.ОткрытьОбщиеПараметрыЗаписиЛкс();
	
КонецПроцедуры

Процедура ФильтрПредставлениеПриИзменении(Элемент)
	
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
	ПрименитьФильтрПоПодстрокеБезСохранения();

КонецПроцедуры

Процедура ФильтрИмяПриИзменении(Элемент)
	
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
	ПрименитьФильтрПоПодстрокеБезСохранения();
	
КонецПроцедуры

Процедура ФильтрИмяНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, ЭтаФорма);
	
КонецПроцедуры

Процедура ФильтрПредставлениеНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, ЭтаФорма);
	
КонецПроцедуры

Процедура ПрименитьФильтрПоПодстрокеБезСохранения()
	
	ЭлементыФормы.ТаблицаКонстант.ОтборСтрок.ИдентификаторКонстанты.ВидСравнения = ВидСравнения.Содержит;
	ЭлементыФормы.ТаблицаКонстант.ОтборСтрок.ИдентификаторКонстанты.Использование = Истина;
	ЭлементыФормы.ТаблицаКонстант.ОтборСтрок.СинонимКонстанты.ВидСравнения = ВидСравнения.Содержит;
	ЭлементыФормы.ТаблицаКонстант.ОтборСтрок.СинонимКонстанты.Использование = Истина;

КонецПроцедуры

Процедура ФильтрИмяАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	
	ирОбщий.ПромежуточноеОбновлениеСтроковогоЗначенияПоляВводаЛкс(Элемент, Текст);
	ПрименитьФильтрПоПодстрокеБезСохранения();

КонецПроцедуры

Процедура ФильтрПредставлениеАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	
	ирОбщий.ПромежуточноеОбновлениеСтроковогоЗначенияПоляВводаЛкс(Элемент, Текст);
	ПрименитьФильтрПоПодстрокеБезСохранения();

КонецПроцедуры

Процедура ТаблицаКонстантПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);

КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирОбщий.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирРедакторКонстант.Форма.Форма");
// Антибаг платформы. Очищаются свойство данные, если оно указывает на отбор табличной части
ЭлементыФормы.ФильтрИмя.Данные = "ЭлементыФормы.ТаблицаКонстант.Отбор.ИдентификаторКонстанты.Значение";
ЭлементыФормы.ФильтрИмя.КнопкаВыбора = Ложь;
ЭлементыФормы.ФильтрИмя.КнопкаСпискаВыбора = Истина;
ЭлементыФормы.ФильтрИмя.КнопкаОчистки = Истина;
ЭлементыФормы.ФильтрПредставление.Данные = "ЭлементыФормы.ТаблицаКонстант.Отбор.СинонимКонстанты.Значение";
ЭлементыФормы.ФильтрПредставление.КнопкаВыбора = Ложь;
ЭлементыФормы.ФильтрПредставление.КнопкаСпискаВыбора = Истина;
ЭлементыФормы.ФильтрПредставление.КнопкаОчистки = Истина;

