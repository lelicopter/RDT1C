﻿//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирПривилегированный Экспорт;

//Запомним ограничение типа
Перем мОграничениеТипа;

Процедура КнопкаВыполнитьНажатие(Кнопка)
	// Вставить содержимое обработчика.
КонецПроцедуры

Процедура КоманднаяПанель1ЗаписатьКонстанты(Кнопка)
	
	Для каждого Стр Из ТаблицаКонстант Цикл
		
		Если НЕ Стр.ПризнакМодификации Тогда
		
			Продолжить;
		
		КонецЕсли;
		
		Если ПравоДоступа("Изменение", Метаданные.Константы[Стр.ИдентификаторКонстанты], ПользователиИнформационнойБазы.ТекущийПользователь()) Тогда
		
			Константы[Стр.ИдентификаторКонстанты].Установить(Стр.ЗначениеКонстанты);
			Стр.ПризнакМодификации = Ложь;
			ЗаписьЖурналаРегистрации("Редактирование констант", УровеньЖурналаРегистрации.Информация, Метаданные.Константы[Стр.ИдентификаторКонстанты], Стр.ЗначениеКонстанты);
		
		КонецЕсли; 
		
	КонецЦикла;
	Модифицированность = Ложь;
	
КонецПроцедуры

Процедура ПрочитатьКонстантыИзБазы()

	ТаблицаКонстант.Очистить();
	
	Для каждого Конст Из Метаданные.Константы Цикл
		
		Если НЕ ПравоДоступа("Чтение", Конст, ПользователиИнформационнойБазы.ТекущийПользователь()) Тогда
			Продолжить;
		КонецЕсли;
		
		Если Конст.тип.Типы()[0] = Тип("ХранилищеЗначения") Тогда
		
			Продолжить;
		
		КонецЕсли; 
		
		НовСтр = ТаблицаКонстант.Добавить();
		НовСтр.ИдентификаторКонстанты = Конст.Имя;
		НовСтр.СинонимКонстанты = Конст.Синоним;
		НовСтр.ЗначениеКонстанты = Константы[Конст.имя].Получить();
		НовСтр.ТипЗначения = ТипЗнч(НовСтр.ЗначениеКонстанты);
		НовСтр.РазрешеноИзменение = ПравоДоступа("Изменение", Конст, ПользователиИнформационнойБазы.ТекущийПользователь())
	
	КонецЦикла;
	
КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
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
	Элемент.Колонки.ЗначениеКонстанты.ЭлементУправления.ОграничениеТипа = Метаданные.Константы[ЭлементыФормы.ТаблицаКонстант.ТекущиеДанные.ИдентификаторКонстанты].Тип;
	ЭлементыФормы.ТаблицаКонстант.ТекущиеДанные.ПризнакМодификации = ИСТИНА;
	ЭтаФорма.Модифицированность = Истина;
КонецПроцедуры

Процедура ТаблицаКонстантПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	Если ДанныеСтроки.ПризнакМодификации = Истина Тогда
		ОформлениеСтроки.ЦветТекста = WebЦвета.КожаноКоричневый;
	КонецЕсли; 
	
	Если НЕ ДанныеСтроки.РазрешеноИзменение Тогда
		ОформлениеСтроки.Ячейки.ЗначениеКонстанты.ТолькоПросмотр = ИСТИНА;
	КонецЕсли;

	Если Истина
		И ДанныеСтроки.РазрешеноИзменение
		И ТипЗнч(ДанныеСтроки.ЗначениеКонстанты) = Тип("Булево") 
	Тогда
		ОформлениеСтроки.Ячейки.ЗначениеКонстанты.УстановитьФлажок(ДанныеСтроки.ЗначениеКонстанты);
	КонецЕсли; 
	ирОбщий.ТабличноеПоле_ОтобразитьПиктограммыТиповЛкс(ОформлениеСтроки, "ЗначениеКонстанты");
	
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

	Если ЭтаФорма.Модифицированность Тогда
		Ответ = Вопрос("Данные в форме были изменены. Сохранить изменения?", РежимДиалогаВопрос.ДаНетОтмена);
		Если Ответ = КодВозвратаДиалога.Отмена Тогда
			Возврат Ложь;
		ИначеЕсли Ответ = КодВозвратаДиалога.Да Тогда
			КоманднаяПанель1ЗаписатьКонстанты(0);
		КонецЕсли;
	КонецЕсли;
	Возврат Истина;

КонецФункции // ПроверкаМодифицированностиФормы()

Процедура КоманднаяПанель1Перечиать(Кнопка)
	
	Если Не ПроверкаМодифицированностиФормы() Тогда
		Возврат;
	КонецЕсли;
	ПрочитатьКонстантыИзБазы();
	
КонецПроцедуры

Процедура ТаблицаКонстантЗначениеКонстантыОчистка(Элемент, СтандартнаяОбработка)
	Элемент.ОграничениеТипа = мОграничениеТипа;
	//Сообщить("--");
КонецПроцедуры

Процедура ТаблицаКонстантПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	ТекДанные = Элемент.ТекущиеДанные;
	мОграничениеТипа = Метаданные.Константы[Элемент.ТекущиеДанные.ИдентификаторКонстанты].Тип;
КонецПроцедуры

Процедура ТаблицаКонстантЗначениеКонстантыНачалоВыбора(Элемент, СтандартнаяОбработка)
	Элемент.ОграничениеТипа = мОграничениеТипа;
КонецПроцедуры

Процедура ПриОткрытии()
	
	Если ЗначениеЗаполнено(НачальноеЗначениеВыбора) Тогда
		ТекущаяСтрока = ТаблицаКонстант.Найти(НачальноеЗначениеВыбора, "ИдентификаторКонстанты");
		Если ТекущаяСтрока <> Неопределено Тогда
			ЭтаФорма.ЭлементыФормы.ТаблицаКонстант.ТекущаяСтрока = ТекущаяСтрока;
			ЭтаФорма.ЭлементыФормы.ТаблицаКонстант.ТекущаяКолонка = ЭтаФорма.ЭлементыФормы.ТаблицаКонстант.Колонки.ЗначениеКонстанты;
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Отказ = Не ПроверкаМодифицированностиФормы();
	
КонецПроцедуры

Процедура КоманднаяПанель1ОПодсистеме(Кнопка)
	ирОбщий.ОткрытьСправкуПоПодсистемеЛкс(ЭтотОбъект);
КонецПроцедуры

Процедура ТаблицаКонстантЗначениеКонстантыПриИзменении(Элемент)
	
	ЭлементыФормы.ТаблицаКонстант.ТекущиеДанные.ТипЗначения = ТипЗнч(Элемент.Значение);
	
КонецПроцедуры

Процедура ТаблицаКонстантПриИзмененииФлажка(Элемент, Колонка)
	
	ирОбщий.ИнтерактивноЗаписатьВКолонкуТабличногоПоляЛкс(Элемент, Колонка, Не Элемент.ТекущаяСтрока[Колонка.Данные]);

КонецПроцедуры

Процедура ТаблицаКонстантЗначениеКонстантыОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	ирОбщий.ПолеВвода_ОкончаниеВводаТекстаЛкс(Элемент, Текст, Значение, СтандартнаяОбработка);

КонецПроцедуры

Процедура КоманднаяПанель1ЖурналРегистрации(Кнопка)
	
	ТекущаяСтрока = ЭлементыФормы.ТаблицаКонстант.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	АнализЖурналаРегистрации = ирОбщий.ПолучитьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирАнализЖурналаРегистрации");
	#Если _ Тогда
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

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ирОбщий.ФормаОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура КлсУниверсальнаяКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработчикОжиданияСПараметрамиЛкс() Экспорт 
	
	ирОбщий.ОбработчикОжиданияСПараметрамиЛкс();

КонецПроцедуры

//ирПортативный #Если Клиент Тогда
//ирПортативный Контейнер = Новый Структура();
//ирПортативный Оповестить("ирПолучитьБазовуюФорму", Контейнер);
//ирПортативный Если Не Контейнер.Свойство("ирПортативный", ирПортативный) Тогда
//ирПортативный 	ПолноеИмяФайлаБазовогоМодуля = ВосстановитьЗначение("ирПолноеИмяФайлаОсновногоМодуля");
//ирПортативный 	ирПортативный = ВнешниеОбработки.ПолучитьФорму(ПолноеИмяФайлаБазовогоМодуля);
//ирПортативный КонецЕсли; 
//ирПортативный ирОбщий = ирПортативный.ПолучитьОбщийМодульЛкс("ирОбщий");
//ирПортативный ирКэш = ирПортативный.ПолучитьОбщийМодульЛкс("ирКэш");
//ирПортативный ирСервер = ирПортативный.ПолучитьОбщийМодульЛкс("ирСервер");
//ирПортативный ирПривилегированный = ирПортативный.ПолучитьОбщийМодульЛкс("ирПривилегированный");
//ирПортативный #КонецЕсли

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирРедакторКонстант.Форма.Форма");
