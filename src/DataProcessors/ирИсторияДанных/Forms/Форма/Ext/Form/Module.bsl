﻿Перем мОтборВерсий;
Перем мПолучатьПредставленияСсылокВНайденныхСсылках;

Функция СохраняемаяНастройкаФормы(выхНаименование, выхИменаСвойств) Экспорт 
	выхИменаСвойств = "Реквизит.ВычислятьПоля, Реквизит.МаксКоличествоВерсий, Форма.ИмяПредставление, Форма.НачалоПериода, Форма.КонецПериода";
	Возврат Неопределено;
КонецФункции

Процедура ЗагрузитьНастройкуВФорме(НастройкаФормы, ДопПараметры) Экспорт 
	
	ирКлиент.ЗагрузитьНастройкуФормыЛкс(ЭтаФорма, НастройкаФормы); 
	Если МаксКоличествоВерсий <= 0 Тогда
		МаксКоличествоВерсий = 1000;
	КонецЕсли; 
	ИмяПредставлениеПриИзменении();
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ирКлиент.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ирКлиент.СоздатьМенеджерСохраненияНастроекФормыЛкс(ЭтаФорма);
	ПроверятьНаличиеВерсийПриИзменении();
	УстановитьОтборПоРеквизитам(ОтборПоРеквизитам);
	КПТипыОбновить();
	
КонецПроцедуры

Процедура КПТипыОбновить(Кнопка = Неопределено) Экспорт 
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("ОтборВерсий", ОтборВерсий());
	#Если Сервер И Не Сервер Тогда
		РассчитатьИтогиИсторииПоТипам();
		ОбновитьТипыЗавершение();
	#КонецЕсли
	ирОбщий.ВыполнитьЗаданиеФормыЛкс("РассчитатьИтогиИсторииПоТипам", ПараметрыЗадания, ЭтаФорма, "ИтогиИсторииДанных",, ЭлементыФормы.КПТипы.Кнопки.Обновить,
		"ОбновитьТипыЗавершение",,,, Кнопка = Неопределено);

КонецПроцедуры

Процедура ОбновитьТипыЗавершение(СостояниеЗадания = Неопределено, РезультатЗадания = Неопределено) Экспорт 
	
	Если Ложь
		Или СостояниеЗадания = Неопределено
		Или СостояниеЗадания = СостояниеФоновогоЗадания.Завершено 
	Тогда
		СостояниеСтрокПоля = ирКлиент.ТабличноеПолеСостояниеСтрокЛкс(ЭлементыФормы.Поля, "ИмяПоля");
		СостояниеСтрокТипы = РезультатЗадания.СостояниеСтрокТипы;
		Если СостояниеСтрокТипы = Неопределено Тогда
			СостояниеСтрокТипы = ирКлиент.ТабличноеПолеСостояниеСтрокЛкс(ЭлементыФормы.Типы, "ПолноеИмяМД");
		КонецЕсли; 
		Если СостояниеЗадания <> Неопределено Тогда
			Поля.Очистить();
			ирОбщий.ЗагрузитьВТаблицуЗначенийЛкс(РезультатЗадания.Типы, Типы,,, Истина);
		КонецЕсли; 
		ирКлиент.ТабличноеПолеВосстановитьСостояниеСтрокЛкс(ЭлементыФормы.Типы, СостояниеСтрокТипы);
		ирКлиент.ТабличноеПолеВосстановитьСостояниеСтрокЛкс(ЭлементыФормы.Поля, СостояниеСтрокПоля);
		
		Если ЗначениеЗаполнено(ПараметрПолноеИмяМД) Тогда
			НайденнаяСтрока = Типы.Найти(ПараметрПолноеИмяМД, "ПолноеИмяМД");
			Если НайденнаяСтрока <> Неопределено Тогда
				ЭлементыФормы.Типы.ТекущаяСтрока = НайденнаяСтрока;
			КонецЕсли; 
			ЭтаФорма.ПараметрПолноеИмяМД = Неопределено;
		КонецЕсли; 
		Если ЗначениеЗаполнено(ПараметрКлючОбъекта) Тогда
			НайденнаяСтрока = Типы.Найти(Метаданные.НайтиПоТипу(ирОбщий.ТипОбъектаБДЛкс(ПараметрКлючОбъекта)).ПолноеИмя(), "ПолноеИмяМД");
			Если НайденнаяСтрока <> Неопределено Тогда
				ЭлементыФормы.Типы.ТекущаяСтрока = НайденнаяСтрока;
			КонецЕсли; 
			//ЭтаФорма.ПараметрКлючОбъекта = Неопределено; // Это делается в ОбновитьВерсииЗавершение()
		КонецЕсли; 
		Если ЗначениеЗаполнено(ПараметрИмяРеквизита) Тогда
			СтрокаРеквизита = Поля.Найти(ПараметрИмяРеквизита, "ИмяПоля");
			Если СтрокаРеквизита <> Неопределено Тогда
				ЭлементыФормы.Поля.ТекущаяСтрока = СтрокаРеквизита;
			КонецЕсли; 
			ЭтаФорма.ПараметрИмяРеквизита = Неопределено;
		КонецЕсли; 
	КонецЕсли; 

КонецПроцедуры

Процедура ИмяПредставлениеПриИзменении(Элемент = Неопределено)
	
	ТабличноеПоле = ЭлементыФормы.Типы;
	ТабличноеПоле.Колонки.ПредставлениеМД.Видимость = Не ИмяПредставление;
	ТабличноеПоле.Колонки.ИмяМД.Видимость = ИмяПредставление;
	СтараяКолонка = ТабличноеПоле.ТекущаяКолонка;
	Если СтараяКолонка <> Неопределено Тогда
		Если Найти(СтараяКолонка.Имя, "МД") > 0 Тогда
			Если ТабличноеПоле.Колонки.ПредставлениеМД.Видимость Тогда
				ТабличноеПоле.ТекущаяКолонка = ТабличноеПоле.Колонки.ПредставлениеМД;
			Иначе
				ТабличноеПоле.ТекущаяКолонка = ТабличноеПоле.Колонки.ИмяМД;
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 
	ТабличноеПоле = ЭлементыФормы.Поля;
	ТабличноеПоле.Колонки.ПредставлениеПоля.Видимость = Не ИмяПредставление;
	ТабличноеПоле.Колонки.ИмяПоля.Видимость = ИмяПредставление;
	СтараяКолонка = ТабличноеПоле.ТекущаяКолонка;
	Если СтараяКолонка <> Неопределено Тогда
		Если Найти(НРег(СтараяКолонка.Имя), "поля") > 0 Тогда
			Если ТабличноеПоле.Колонки.ПредставлениеПоля.Видимость Тогда
				ТабличноеПоле.ТекущаяКолонка = ТабличноеПоле.Колонки.ПредставлениеПоля;
			Иначе
				ТабличноеПоле.ТекущаяКолонка = ТабличноеПоле.Колонки.ИмяПоля;
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 

КонецПроцедуры

Процедура ТипыПриАктивизацииСтроки(Элемент)
	
	ирКлиент.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	мОтборВерсий = Новый Структура;
	КП_ОбновитьВерсии();
	ТекущаяСтрока = ЭлементыФормы.Типы.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ОбъектМД = ирКэш.ОбъектМДПоПолномуИмениЛкс(ТекущаяСтрока.ПолноеИмяМД);
	Поля.Загрузить(ИспользованиеПолей(ОбъектМД,, Истина));
	ОчиститьСпискоСсылок();
	
КонецПроцедуры

Процедура ОчиститьСпискоСсылок()
	
	ТекущаяСтрока = ЭлементыФормы.Типы.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ОбъектМД = ирКэш.ОбъектМДПоПолномуИмениЛкс(ТекущаяСтрока.ПолноеИмяМД);
	СписокСсылок.Очистить();
	НовоеОписаниеТипов = Новый ОписаниеТипов;
	ЭтоСсылочныйТип = ирОбщий.ЛиКорневойТипСсылкиЛкс(ирОбщий.ПервыйФрагментЛкс(ОбъектМД.ПолноеИмя()));
	Если ЭтоСсылочныйТип Тогда
		НовоеОписаниеТипов = Новый ОписаниеТипов(ирОбщий.ИмяТипаИзПолногоИмениМДЛкс(ОбъектМД));
	КонецЕсли;
	СписокСсылок.ТипЗначения = НовоеОписаниеТипов;
	ЭлементыФормы.СписокСсылок.Доступность = ЭтоСсылочныйТип;

КонецПроцедуры

Процедура ТипыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ирКлиент.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ОформлениеСтроки.Ячейки.ТипМетаданных.УстановитьКартинку(ирКлиент.КартинкаКорневогоТипаМДЛкс(ДанныеСтроки.ТипМетаданных));
	Если ДанныеСтроки.ЕстьДоступ = Ложь Тогда 
		ОформлениеСтроки.ЦветТекста = WebЦвета.Красный;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДанныеПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ирКлиент.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
	Если мПолучатьПредставленияСсылокВНайденныхСсылках <> Истина Тогда
		ПодключитьОбработчикОжидания("ОбновитьПредставленияСсылокВНайденныхСсылках", 0.1, Истина);
	КонецЕсли; 
	Если ЭлементыФормы.Типы.ТекущаяСтрока <> Неопределено Тогда
		ирКлиент.НайденныеСтандартноСсылкиПриВыводеСтрокиЛкс(ОформлениеСтроки, мПолучатьПредставленияСсылокВНайденныхСсылках = Истина, ЭлементыФормы.Типы.ТекущаяСтрока.ПолноеИмяМД);
		ирКлиент.ЗаполнитьИзмененыеПоляВСтрокеВерсииДанныхЛкс(ДанныеСтроки,, ЭлементыФормы.Типы.ТекущаяСтрока.ПолноеИмяМД);
	КонецЕсли;

КонецПроцедуры

Процедура ОбновитьПредставленияСсылокВНайденныхСсылках()
	мПолучатьПредставленияСсылокВНайденныхСсылках = Истина;
	ЭлементыФормы.Версии.ОбновитьСтроки();
	мПолучатьПредставленияСсылокВНайденныхСсылках = Ложь;
КонецПроцедуры

Процедура КП_ДанныеРедакторОбъектаБД(Кнопка = Неопределено, НайтиВерсию = Неопределено)
	
	ТекущиеДанные = ЭлементыФормы.Версии.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	КлючОбъектаВерсии = КлючОбъектаВерсии(ТекущиеДанные);
	Если КлючОбъектаВерсии = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ФормаРедактора = ирКлиент.ОткрытьСсылкуВРедактореОбъектаБДЛкс(КлючОбъектаВерсии);
	Если НайтиВерсию <> Ложь Тогда
		ФормаРедактора.НайтиВерсию(ТекущиеДанные.НомерВерсии);
	КонецЕсли; 
	
КонецПроцедуры

Функция КлючОбъектаВерсии(Знач СтрокаТаблицыВерсий = Неопределено)
	
	Если СтрокаТаблицыВерсий = Неопределено Тогда
		СтрокаТаблицыВерсий = ЭлементыФормы.Версии.ТекущиеДанные;
	КонецЕсли; 
	Если СтрокаТаблицыВерсий = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли; 
	СсылкаОбъекта = ирКлиент.КлючОбъектаСтрокиВерсииДанныхЛкс(СтрокаТаблицыВерсий, ЭлементыФормы.Типы.ТекущаяСтрока.ПолноеИмяМД);
	Возврат СсылкаОбъекта;

КонецФункции

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	Если ирКэш.НомерРежимаСовместимостиЛкс() < 803011 Тогда
		ирОбщий.СообщитьЛкс("Инструмент доступен только в режиме совместимости 8.3.11 и выше",,, Истина);
		Отказ = Истина;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДанныеВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если Колонка = ЭлементыФормы.Версии.Колонки.Данные Тогда
		КлючОбъектаВерсии = КлючОбъектаВерсии(ВыбраннаяСтрока);
		Если КлючОбъектаВерсии = Неопределено Тогда
			Возврат;
		КонецЕсли;
		Если ирОбщий.ЛиКлючЗаписиРегистраЛкс(КлючОбъектаВерсии) Тогда
			ОбъектМД = ирКэш.ОбъектМДПоПолномуИмениЛкс(ЭлементыФормы.типы.ТекущаяСтрока.ПолноеИмяМД);
			#Если Сервер И Не Сервер Тогда
				ОбъектМД = Метаданные.РегистрыСведений.КурсыВалют;
			#КонецЕсли
			Если ОбъектМД.ОсновнаяФормаЗаписи <> Неопределено Тогда
				ОткрытьЗначение(КлючОбъектаВерсии);
			Иначе
				КП_ДанныеРедакторОбъектаБД(, Ложь);
			КонецЕсли; 
		Иначе
			ОткрытьЗначение(КлючОбъектаВерсии);
		КонецЕсли; 
	Иначе
		КП_ДанныеОткрытьОтчетПоВерсии();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ГлавнаяКоманднаяПанельИТС(Кнопка)
	
	ирКлиент.ОткрытьСсылкуИТСЛкс("https://its.1c.ru/db/v?doc#bookmark:dev:TI000001938");
	
КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирКлиент.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирКлиент.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирКлиент.Форма_ПриЗакрытииЛкс(ЭтаФорма);

КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	ирКлиент.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура КоманднаяПанельТипыОткрытьОбъектМетаданных(Кнопка)
	
	Если ЭлементыФормы.Типы.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ирКлиент.ОткрытьОбъектМетаданныхЛкс(ЭлементыФормы.Типы.ТекущаяСтрока.ПолноеИмяМД);
	
КонецПроцедуры

Процедура ГлавнаяКоманднаяПанельПараметрыЗаписи(Кнопка)
	
	ирКлиент.ОткрытьОбщиеПараметрыЗаписиЛкс();
	
КонецПроцедуры

Процедура ТипыПриИзмененииФлажка(Элемент, Колонка)
	
	ирКлиент.ТабличноеПолеПриИзмененииФлажкаЛкс(ЭтаФорма, Элемент, Колонка);
	
КонецПроцедуры

Процедура КП_ОбновитьВерсии(Кнопка = Неопределено)
	
	ЭлементыФормы.КП_Данные.Кнопки.ОтключитьОтборВерсий.Доступность = мОтборВерсий.Количество() > 0;
	Если ЭлементыФормы.Типы.ТекущаяСтрока = Неопределено Тогда
		Версии.Очистить();
		Возврат;
	КонецЕсли; 
	Если МаксКоличествоВерсий = 0 Тогда
		Версии.Очистить();
		Возврат;
	КонецЕсли; 
	ПолноеИмяМД = ЭлементыФормы.Типы.ТекущаяСтрока.ПолноеИмяМД;
	Если ЭлементыФормы.Типы.ТекущаяСтрока.ЕстьДоступ = Ложь Тогда
		Версии.Очистить();
		ирОбщий.СообщитьЛкс("Нет прав на чтение истории данных """ + ПолноеИмяМД + """", СтатусСообщения.Внимание);
		Возврат;
	КонецЕсли; 
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("ПолноеИмяМД", ПолноеИмяМД);
	ПараметрыЗадания.Вставить("ОтборВерсий", ОтборВерсий());
	ПараметрыЗадания.Вставить("СписокСсылок", СписокСсылок);
	#Если Сервер И Не Сервер Тогда
		ВыбратьВерсииПоОбъектуМД();
		ОбновитьВерсииЗавершение();
	#КонецЕсли
	ирОбщий.ВыполнитьЗаданиеФормыЛкс("ВыбратьВерсииПоОбъектуМД", ПараметрыЗадания, ЭтаФорма, "ВыборкаВерсий",, ЭлементыФормы.КП_Данные.Кнопки.ОбновитьВерсии,
		"ОбновитьВерсииЗавершение",,,, Кнопка = Неопределено);

КонецПроцедуры

Процедура ОбновитьВерсииЗавершение(СостояниеЗадания = Неопределено, РезультатЗадания = Неопределено) Экспорт 
	
	Если Ложь
		Или СостояниеЗадания = Неопределено
		Или СостояниеЗадания = СостояниеФоновогоЗадания.Завершено 
	Тогда
		СостояниеСтрокВерсии = ирКлиент.ТабличноеПолеСостояниеСтрокЛкс(ЭлементыФормы.Версии, "Данные, НомерВерсии"); 
		Версии.Очистить();
		НадоСериализоватьКлюч = ирКлиент.НадоСериализоватьКлючДанныхДляОтображенияЛкс(ЭлементыФормы.Типы.ТекущаяСтрока.ТипМетаданных);
		Для Каждого СтрокаВыборки Из РезультатЗадания.ТаблицаВерсий Цикл
			СтрокаВерсии = Версии.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаВерсии, СтрокаВыборки); 
			Если НадоСериализоватьКлюч Тогда
				СтрокаВерсии.Данные = ЗначениеВСтрокуВнутр(СтрокаВыборки.Данные);
			КонецЕсли;
			СтрокаВерсии.ИзмененныеПоля = "?";
		КонецЦикла;
		ирКлиент.ТабличноеПолеВосстановитьСостояниеСтрокЛкс(ЭлементыФормы.Версии, СостояниеСтрокВерсии);
		Если ЗначениеЗаполнено(ПараметрКлючОбъекта) Тогда
			СтрокаВерсии = Версии.НайтиСтроки(Новый Структура("Данные", ПараметрКлючОбъекта));
			Если СтрокаВерсии.Количество() > 0 Тогда
				ЭлементыФормы.Версии.ТекущаяСтрока = СтрокаВерсии[0];
			КонецЕсли;
		КонецЕсли;
		Если ЗначениеЗаполнено(ПараметрНомерВерсии) Тогда
			СтрокаВерсии = Версии.НайтиСтроки(Новый Структура("Данные, НомерВерсии", ПараметрКлючОбъекта, ПараметрНомерВерсии));
			Если СтрокаВерсии.Количество() > 0 Тогда
				ЭлементыФормы.Версии.ТекущаяСтрока = СтрокаВерсии[0];
			Иначе
				Сообщить("Версия не найдена по текущим условиям отбора");
			КонецЕсли;
		КонецЕсли;
		ЭтаФорма.ПараметрКлючОбъекта = Неопределено;
		ЭтаФорма.ПараметрНомерВерсии = Неопределено;
	КонецЕсли; 

КонецПроцедуры

Функция ОтборВерсий()
	
	ОтборВерсий = ирОбщий.СкопироватьУниверсальнуюКоллекциюЛкс(мОтборВерсий);
	Если ЗначениеЗаполнено(НачалоПериода) Тогда
		ОтборВерсий.Вставить("ДатаНачала", НачалоПериода);
	КонецЕсли; 
	Если ЗначениеЗаполнено(КонецПериода) Тогда
		ОтборВерсий.Вставить("ДатаОкончания", КонецПериода);
	КонецЕсли; 
	Если ОтборПоРеквизитам Тогда
		МассивРеквизитов = Новый Массив;
		Для Каждого СтрокаРеквизита Из ЭлементыФормы.Поля.ВыделенныеСтроки Цикл
			МассивРеквизитов.Добавить(СтрокаРеквизита.ИмяПоля);
		КонецЦикла;
		Если МассивРеквизитов.Количество() > 0 Тогда
			ОтборВерсий.Вставить("ИзменениеЗначенийПолей", МассивРеквизитов);
		КонецЕсли; 
	КонецЕсли;
	Возврат ОтборВерсий;

КонецФункции

Процедура МаксКоличествоВерсийПриИзменении(Элемент)
	
	КП_ОбновитьВерсии();

КонецПроцедуры

Процедура ГлавнаяКоманднаяПанельОбновитьИсторию(Кнопка)
	
	ПараметрыЗадания = Новый Структура;
	#Если Сервер И Не Сервер Тогда
		ОбновитьИсториюДанных();
		ОбновитьИсториюЗавершение();
	#КонецЕсли
	ирОбщий.ВыполнитьЗаданиеФормыЛкс("ОбновитьИсториюДанных", ПараметрыЗадания, ЭтаФорма,,, Кнопка, "ОбновитьИсториюЗавершение");

КонецПроцедуры

Процедура ОбновитьИсториюЗавершение(СостояниеЗадания = Неопределено, РезультатЗадания = Неопределено) Экспорт 
	
	Если Ложь
		Или СостояниеЗадания = Неопределено
		Или СостояниеЗадания = СостояниеФоновогоЗадания.Завершено 
	Тогда
		КПТипыОбновить();
	КонецЕсли; 

КонецПроцедуры

// Предопределеный метод
Процедура ПроверкаЗавершенияФоновыхЗаданий() Экспорт 
	
	ирКлиент.ПроверитьЗавершениеФоновыхЗаданийФормыЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура КП_ДанныеНайтиВФормеСпискаВерсий(Кнопка)
	
	КлючОбъекта = КлючОбъектаВерсии();
	Если КлючОбъекта = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ТекущиеДанные = ЭлементыФормы.Версии.ТекущиеДанные;
	ирКлиент.ОткрытьСистемнуюФормуСписокВерсийОбъектаЛкс(КлючОбъекта, ТекущиеДанные.НомерВерсии);
	
КонецПроцедуры

Процедура КП_ДанныеОткрытьОтчетПоВерсии(Кнопка = Неопределено)
	
	КлючОбъекта = КлючОбъектаВерсии();
	Если КлючОбъекта = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ТекущиеДанные = ЭлементыФормы.Версии.ТекущиеДанные;
	ирКлиент.ОткрытьСистемнуюФормуОтчетПоВерсииЛкс(КлючОбъекта, ТекущиеДанные.НомерВерсии);
	
КонецПроцедуры

Процедура ПоляПриИзмененииФлажка(Элемент, Колонка)
	
	Если ЭлементыФормы.Типы.ТекущаяСтрока = Неопределено Тогда
		Поля.Очистить();
		Возврат;
	КонецЕсли; 
	ирКлиент.ТабличноеПолеПриИзмененииФлажкаЛкс(ЭтаФорма, Элемент, Колонка);
	
КонецПроцедуры

Процедура ПроверятьНаличиеВерсийПриИзменении(Элемент = Неопределено)
	
	Если ВычислятьКоличествоВерсий Тогда
		КПТипыОбновить();
		ЭлементыФормы.Типы.Колонки.КоличествоВерсий.Видимость = Истина;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПоляПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ИндексКартинки = ирКлиент.ИндексКартинкиТипаЗначенияБДЛкс(мОписанияТиповПолей.Найти(ДанныеСтроки.ИмяПоля, "Имя").ОписаниеТипов);
	Если ИндексКартинки <> Неопределено Тогда
		ОформлениеСтроки.Ячейки.ОписаниеТипов.ОтображатьКартинку = Истина;
		ОформлениеСтроки.Ячейки.ОписаниеТипов.ИндексКартинки = ИндексКартинки;
	КонецЕсли; 
	ирКлиент.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
	
КонецПроцедуры

Процедура ИзменитьИспользованиеУВыделенныхИлиВсехСтрокПолей(Знач НовоеЗначениеПометки)
	
	Если ЭлементыФормы.Типы.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ТабличноеПоле = ЭлементыФормы.Поля;
	ВыделенныеСтроки = ТабличноеПоле.ВыделенныеСтроки;
	Если ВыделенныеСтроки.Количество() <= 1 Тогда
		ВыделенныеСтроки = ТабличноеПоле.Значение; 
		Попытка
			ОтборСтрок = ТабличноеПоле.ОтборСтрок;
		Исключение
		КонецПопытки; 
		Если ОтборСтрок <> Неопределено Тогда
			Построитель = ирКлиент.ПостроительТабличногоПоляСОтборомКлиентаЛкс(ТабличноеПоле);
			#Если Сервер И Не Сервер Тогда
				Построитель = Новый ПостроительЗапроса;
			#КонецЕсли
			Построитель.ВыбранныеПоля.Очистить();
			Построитель.ВыбранныеПоля.Добавить("ИмяПоля");
			НомераОтобранныхСтрок = Построитель.Результат.Выгрузить();
			НомераОтобранныхСтрок.Индексы.Добавить("ИмяПоля");
		КонецЕсли; 
	КонецЕсли; 
	ОбъектМД = ирКэш.ОбъектМДПоПолномуИмениЛкс(ЭлементыФормы.Типы.ТекущаяСтрока.ПолноеИмяМД);
	ИспользованиеПолей = Новый Соответствие;
	Для каждого СтрокаПоля из ВыделенныеСтроки Цикл
		Если Истина
			И НомераОтобранныхСтрок <> Неопределено
			И НомераОтобранныхСтрок.Найти(СтрокаПоля.ИмяПоля, "ИмяПоля") = Неопределено
		Тогда
			// Строка не отвечает отбору
			Продолжить;
		КонецЕсли;
		СтрокаПоля.Использование = НовоеЗначениеПометки;
		Если СтрокаПоля.ИспользованиеВМетаданных <> СтрокаПоля.Использование Тогда
			ИспользованиеПолей.Вставить(СтрокаПоля.ИмяПоля, СтрокаПоля.Использование);
		КонецЕсли; 
	КонецЦикла;
	НастройкиИстории = ирОбщий.УстановитьИспользованиеИсторииДанныхЛкс(ЭлементыФормы.Типы.ТекущаяСтрока.ПолноеИмяМД,, ИспользованиеПолей);
	ЗаполнитьНастройкиИсторииВСтрокеТипа(НастройкиИстории[0], ОбъектМД, ЭлементыФормы.Типы.ТекущаяСтрока, ВычислятьПоля);
	ТабличноеПоле.ОбновитьСтроки();

КонецПроцедуры

Процедура ВыбратьДатуИзСписка(Элемент, СтандартнаяОбработка, Знач ПарнаяДата, Знак)
	
	СимволЗнака = ?(Знак = 1, "+", "-");
	ИмяПарнойДаты = ?(Знак = 1, "Начало", "Конец");
	СписокВыбора = Новый СписокЗначений;
	СписокВыбора.Добавить(1*60,          ИмяПарнойДаты + " " + СимволЗнака + " 1 минута");
	СписокВыбора.Добавить(10*60,       ИмяПарнойДаты + " " + СимволЗнака + " 10 минут");
	СписокВыбора.Добавить(2*60*60,       ИмяПарнойДаты + " " + СимволЗнака + " 2 часа");
	СписокВыбора.Добавить(1*24*60*60,    ИмяПарнойДаты + " " + СимволЗнака + " 1 день");
	СписокВыбора.Добавить(7*24*60*60,    ИмяПарнойДаты + " " + СимволЗнака + " 7 дней");
	СписокВыбора.Добавить(30*24*60*60,   ИмяПарнойДаты + " " + СимволЗнака + " 30 дней");
	РезультатВыбора = ЭтаФорма.ВыбратьИзСписка(СписокВыбора, Элемент);
	Если РезультатВыбора <> Неопределено Тогда
		Если Знак = -1 Тогда
			Если Не ЗначениеЗаполнено(ПарнаяДата) Тогда
				ПарнаяДата = ТекущаяДата();
			КонецЕсли; 
		КонецЕсли; 
		Элемент.Значение = ПарнаяДата + Знак * РезультатВыбора.Значение;
	КонецЕсли;
	СтандартнаяОбработка = Ложь;

КонецПроцедуры

Процедура КонецПериодаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ВыбратьДатуИзСписка(Элемент, СтандартнаяОбработка, НачалоПериода, 1);
	
КонецПроцедуры

Процедура НачалоПериодаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ВыбратьДатуИзСписка(Элемент, СтандартнаяОбработка, КонецПериода, -1);

КонецПроцедуры

Процедура КнопкаВыбораПериодаНажатие(Элемент)
	
	НастройкаПериода = Новый НастройкаПериода;
	НастройкаПериода.УстановитьПериод(НачалоПериода, ?(КонецПериода='0001-01-01', КонецПериода, КонецДня(КонецПериода)));
	НастройкаПериода.РедактироватьКакИнтервал = Истина;
	НастройкаПериода.РедактироватьКакПериод = Истина;
	НастройкаПериода.ВариантНастройки = ВариантНастройкиПериода.Период;
	Если НастройкаПериода.Редактировать() Тогда
		НачалоПериода = НастройкаПериода.ПолучитьДатуНачала();
		КонецПериода = НастройкаПериода.ПолучитьДатуОкончания();
	КонецЕсли;

КонецПроцедуры

Процедура ПоляВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если Колонка = ЭлементыФормы.Поля.Колонки.ОписаниеТипов Тогда
		ирКлиент.ОткрытьЗначениеЛкс(мОписанияТиповПолей.Найти(ВыбраннаяСтрока.ИмяПоля, "Имя").ОписаниеТипов, Ложь, СтандартнаяОбработка);
	КонецЕсли; 
	
КонецПроцедуры

Процедура КП_ДанныеУдалитьВерсии(Кнопка)
	
	ТекущиеДанные = ЭлементыФормы.Версии.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	Ответ = Вопрос("Вы действительно хотите удалить все версии этого типа данных старше выбранной версии?", РежимДиалогаВопрос.ОКОтмена);
	Если Ответ = КодВозвратаДиалога.ОК Тогда
		ИсторияДанныхМоя = ИсторияДанныхМоя();
		#Если Сервер И Не Сервер Тогда
			ИсторияДанныхМоя = ИсторияДанных;
		#КонецЕсли
		ИсторияДанныхМоя.УдалитьВерсии(ирКэш.ОбъектМДПоПолномуИмениЛкс(ЭлементыФормы.Типы.ТекущаяСтрока.ПолноеИмяМД), ТекущиеДанные.Дата);
		КП_ОбновитьВерсии();
	КонецЕсли;
	
КонецПроцедуры

Процедура КПТипыУдалитьВерсии(Кнопка)
	
	ВыделенныеСтроки = ЭлементыФормы.Типы.ВыделенныеСтроки;
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли; 
	Ответ = Вопрос("Вы действительно хотите удалить все версии выделенных типов данных (" + ВыделенныеСтроки.Количество() + ")?", РежимДиалогаВопрос.ОКОтмена);
	Если Ответ = КодВозвратаДиалога.ОК Тогда
		ИсторияДанныхМоя = ИсторияДанныхМоя();
		#Если Сервер И Не Сервер Тогда
			ИсторияДанныхМоя = ИсторияДанных;
		#КонецЕсли
		Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
			ИсторияДанныхМоя.УдалитьВерсии(ирКэш.ОбъектМДПоПолномуИмениЛкс(ВыделеннаяСтрока.ПолноеИмяМД));
			ВыделеннаяСтрока.КоличествоВерсий = 0;
		КонецЦикла;
		КП_ОбновитьВерсии();
	КонецЕсли;

КонецПроцедуры

Процедура ГлавнаяКоманднаяПанельОчиститьИсторию(Кнопка)
	
	Ответ = Вопрос("Вы действительно хотите очистить всю историю данных?", РежимДиалогаВопрос.ОКОтмена);
	Если Ответ = КодВозвратаДиалога.ОК Тогда
		ИсторияДанныхМоя = ИсторияДанныхМоя();
		#Если Сервер И Не Сервер Тогда
			ИсторияДанныхМоя = ИсторияДанных;
		#КонецЕсли
		Для Каждого СтрокаТипа Из Типы Цикл
			ОбъектМД = ирКэш.ОбъектМДПоПолномуИмениЛкс(СтрокаТипа.ПолноеИмяМД);
			Попытка
				ИсторияДанныхМоя.УдалитьВерсии(ОбъектМД);
			Исключение
				ирОбщий.СообщитьЛкс("Ошибка удаления версий " + ОбъектМД.ПолноеИмя() + ": " + ОписаниеОшибки());
			КонецПопытки; 
		КонецЦикла;
		КПТипыОбновить();
	КонецЕсли;
	
КонецПроцедуры

Процедура КП_ДанныеИсследоватьВерсию(Кнопка)
	
	КлючОбъекта = КлючОбъектаВерсии();
	Если КлючОбъекта = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ТекущиеДанные = ЭлементыФормы.Версии.ТекущиеДанные;
	ирКлиент.ИсследоватьВерсиюОбъектаДанныхЛкс(КлючОбъекта, ТекущиеДанные.НомерВерсии);
	
КонецПроцедуры

Процедура ПоляИспользованиеПриИзменении(Элемент)
	
	ИспользованиеПолей = Новый Соответствие;
	Для Каждого СтрокаПоля Из Поля Цикл
		Если СтрокаПоля.ИспользованиеВМетаданных <> СтрокаПоля.Использование Тогда
			ИспользованиеПолей.Вставить(СтрокаПоля.ИмяПоля, СтрокаПоля.Использование);
		КонецЕсли; 
	КонецЦикла;
	НастройкиИстории = ирОбщий.УстановитьИспользованиеИсторииДанныхЛкс(ЭлементыФормы.Типы.ТекущаяСтрока.ПолноеИмяМД,, ИспользованиеПолей);
	ОбъектМД = ирКэш.ОбъектМДПоПолномуИмениЛкс(ЭлементыФормы.Типы.ТекущаяСтрока.ПолноеИмяМД);
	ЗаполнитьНастройкиИсторииВСтрокеТипа(НастройкиИстории[0], ОбъектМД, ЭлементыФормы.Типы.ТекущаяСтрока, Истина);

КонецПроцедуры

Процедура ВерсииПриАктивизацииСтроки(Элемент)
	
	ирКлиент.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);

КонецПроцедуры

Процедура ВычислятьПоляПриИзменении(Элемент)
	
	КПТипыОбновить();
	
КонецПроцедуры

Процедура КП_ДанныеОтборПоРеквизитам(Кнопка)
	
	УстановитьОтборПоРеквизитам(Не ОтборПоРеквизитам);
	КП_ОбновитьВерсии();
	
КонецПроцедуры

Процедура УстановитьОтборПоРеквизитам(Знач НовоеИспользование)
	
	ЭтаФорма.ОтборПоРеквизитам = НовоеИспользование;
	ЭлементыФормы.КП_Данные.Кнопки.ОтборПоРеквизитам.Пометка = ЭтаФорма.ОтборПоРеквизитам;

КонецПроцедуры

Процедура ПоляПриАктивизацииСтроки(Элемент)
	
	Если ОтборПоРеквизитам Тогда
		КП_ОбновитьВерсии();
	КонецЕсли; 
	
КонецПроцедуры

Процедура КПТипыСоздатьВерсии(Кнопка)
	
	ОбработкаОбъектов = ирОбщий.СоздатьОбъектПоИмениМетаданныхЛкс("Обработка.ирПодборИОбработкаОбъектов");
	#Если Сервер И Не Сервер Тогда
	    ОбработкаОбъектов = Обработки.ирПодборИОбработкаОбъектов.Создать();
	#КонецЕсли
	ФормаОбработки = ОбработкаОбъектов.ПолучитьФорму();
	ФормаОбработки.Открыть();
	ПолныеИменаТаблиц = Новый СписокЗначений;
	ПолныеИменаТаблиц.ЗагрузитьЗначения(ирОбщий.ЗначенияСвойстваКоллекцииЛкс(ЭлементыФормы.Типы.ВыделенныеСтроки, "ПолноеИмяМД"));
	Если ПолныеИменаТаблиц.Количество() = 1 Тогда
		ОбластьПоиска = ПолныеИменаТаблиц[0].Значение;
	Иначе
		ОбластьПоиска = ПолныеИменаТаблиц;
	КонецЕсли; 
	ФормаОбработки.УстановитьОбластьПоиска(ОбластьПоиска);
	Сообщить("После выбора объектов используйте обработку ""Записать версию""");
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирКлиент.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТипыИспользованиеПриИзменении(Элемент)
	
	ирОбщий.УстановитьИспользованиеИсторииДанныхЛкс(ЭлементыФормы.Типы.ТекущаяСтрока.ПолноеИмяМД, ЭлементыФормы.Типы.ТекущаяСтрока.Использование);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирКлиент.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура КП_ДанныеОтборВерсий(Кнопка)
	
	Если Версии.Количество() = 0 Тогда
		Возврат;
	КонецЕсли; 
	ОписаниеОповещения = ирКлиент.ОписаниеОповещенияЛкс("УстановкаОтбораВерсийЗавершение", ЭтаФорма);
	ирКлиент.ОткрытьСистемнуюФормуНастройкаОтбораВерсийЛкс(ирКлиент.КлючОбъектаСтрокиВерсииДанныхЛкс(Версии[0], ЭлементыФормы.Типы.ТекущаяСтрока.ПолноеИмяМД), мОтборВерсий, ОписаниеОповещения);
	
КонецПроцедуры

Процедура УстановкаОтбораВерсийЗавершение(Результат, ДопПараметры) Экспорт 
	Если Истина
		И Результат <> КодВозвратаДиалога.Отмена 
		И Результат <> Неопределено
	Тогда 
		мОтборВерсий = Результат;
		КП_ОбновитьВерсии();
	КонецЕсли;
КонецПроцедуры

Процедура КП_ДанныеОтключитьОтборВерсий(Кнопка)
	
	мОтборВерсий = Новый Структура;
	КП_ОбновитьВерсии();

КонецПроцедуры

Процедура СписокСсылокНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ирКлиент.ОткрытьСписокЗначенийЛкс(Элемент.Значение);
	
КонецПроцедуры

Процедура СписокСсылокОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОчиститьСпискоСсылок();
КонецПроцедуры

Процедура ОбновитьОтбор()
	
	Реквизиты = Метаданные().ТабличныеЧасти.Типы.Реквизиты;
	КолонкиПоиска = Новый Структура;
	КолонкиПоиска.Вставить(Реквизиты.ИмяМД.Имя);
	КолонкиПоиска.Вставить(Реквизиты.ПредставлениеМД.Имя);
	ирКлиент.ТабличноеПолеСДаннымиПоискаУстановитьОтборПоПодстрокеЛкс(ЭтаФорма, ЭлементыФормы.Типы, ПодстрокаПоиска, КолонкиПоиска);

КонецПроцедуры

Процедура ПодстрокаПоискаПриИзменении(Элемент)
	ирКлиент.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
	ОбновитьОтбор();
КонецПроцедуры

Процедура ПодстрокаПоискаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	ирОбщий.ПолеВводаСИсториейВыбора_ОбновитьСписокЛкс(Элемент, ЭтаФорма);
КонецПроцедуры

Процедура ПодстрокаПоискаАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	Если ирКлиент.ПромежуточноеОбновлениеСтроковогоЗначенияПоляВводаЛкс(ЭтаФорма, Элемент, Текст) Тогда 
		ОбновитьОтбор();
	КонецЕсли;
КонецПроцедуры

Процедура КППоляПерейтиКОпределению(Кнопка)
	
	ДоступноеПоле = ЭлементыФормы.Поля.ТекущаяСтрока;
	Если ДоступноеПоле = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ИмяПоля = ДоступноеПоле.ИмяПоля;
	Фрагменты = ирОбщий.СтрРазделитьЛкс(ИмяПоля);
	ПолноеИмяМД = ЭлементыФормы.Типы.ТекущаяСтрока.ПолноеИмяМД;
	Если Фрагменты.Количество() = 2 Тогда
		ПолноеИмяМД = ПолноеИмяМД + "." + Фрагменты[0];
		Фрагменты.Удалить(0);
	КонецЕсли;
	ирКлиент.ОткрытьРедакторОбъектаБДЛкс(ПолноеИмяМД, Фрагменты[0]);
	
КонецПроцедуры

ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирИсторияДанных.Форма.Форма");
ЭлементыФормы.МаксКоличествоВерсий.СписокВыбора.Добавить(10);
ЭлементыФормы.МаксКоличествоВерсий.СписокВыбора.Добавить(100);
ЭлементыФормы.МаксКоличествоВерсий.СписокВыбора.Добавить(1000);
ЭлементыФормы.МаксКоличествоВерсий.СписокВыбора.Добавить(10000);
мОтборВерсий = Новый Структура;

