﻿
Процедура КнопкаВыполнитьНажатие(Кнопка)
	// Вставить содержимое обработчика.
КонецПроцедуры

Процедура УстановитьОбъектМетаданных(ПолноеИмяМД = Неопределено) Экспорт

	Если ПолноеИмяМД <> Неопределено Тогда
		ЭтаФорма.ОбъектМетаданных = ПолноеИмяМД;
	КонецЕсли; 
	МассивФрагментов = ирОбщий.ПолучитьМассивИзСтрокиСРазделителемЛкс(ОбъектМетаданных);
	ОсновнойЭУ = ЭлементыФормы.ДинамическийСписок;
	ИмяТипаСсылки = ирОбщий.ПолучитьИмяТипаИзМетаданныхЛкс(ОбъектМетаданных, "Список");
	ОсновнойЭУ.ТипЗначения = Новый ОписаниеТипов(ИмяТипаСсылки);
	ирОбщий.НастроитьАвтоТабличноеПолеДинамическогоСписка(ОсновнойЭУ);
	Заголовок = ОсновнойЭУ.ТипЗначения;
	КорневойТип = ирОбщий.ПолучитьПервыйФрагментЛкс(ОбъектМетаданных);
	ЭтоПеречисление = ирОбщий.ЛиКорневойТипПеречисленияЛкс(КорневойТип);
	ЭлементыФормы.КП_Список.Кнопки.УниверсальныйРедакторРеквизитов.Доступность = Не ЭтоПеречисление;

КонецПроцедуры // УстановитьОбъектМетаданных()

Процедура НайтиСсылкуВСписке(КлючСтроки, УстановитьОбъектМетаданных = Истина) Экспорт

	МетаданныеТаблицы = Метаданные.НайтиПоТипу(ТипЗнч(КлючСтроки));
	Если УстановитьОбъектМетаданных Тогда
		УстановитьОбъектМетаданных(МетаданныеТаблицы.ПолноеИмя());
	КонецЕсли; 
	ИмяXMLТипа = СериализаторXDTO.XMLТипЗнч(КлючСтроки).ИмяТипа;
	Если Ложь
		Или Найти(ИмяXMLТипа, "Ref.") > 0
		Или Найти(ИмяXMLТипа, "RecordKey.") > 0
	Тогда
		ЭлементыФормы.ДинамическийСписок.ТекущаяСтрока = КлючСтроки;
	Иначе
		ирОбщий.СкопироватьОтборДинамическогоСпискаЛкс(ЭлементыФормы.ДинамическийСписок.Значение.Отбор, КлючСтроки.Отбор);
	КонецЕсли; 

КонецПроцедуры

Процедура ОбъектМетаданныхНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	Форма = ирКэш.Получить().ПолучитьФорму("ВыборОбъектаМетаданных", Элемент, ЭтаФорма);
	лСтруктураПараметров = Новый Структура;
	лСтруктураПараметров.Вставить("НачальноеЗначениеВыбора", ОбъектМетаданных);
	лСтруктураПараметров.Вставить("ОтображатьСсылочныеОбъекты", Истина);
	лСтруктураПараметров.Вставить("ОтображатьПеречисления", Истина);
	лСтруктураПараметров.Вставить("ОтображатьВыборочныеТаблицы", Истина);
	лСтруктураПараметров.Вставить("ОтображатьРегистры", Истина);
	лСтруктураПараметров.Вставить("ОтображатьПоследовательности", Ложь);
	Форма.НачальноеЗначениеВыбора = лСтруктураПараметров;
	Форма.ОткрытьМодально();
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

Процедура ОбъектМетаданныхОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;

КонецПроцедуры

Процедура КП_СписокОткрытьУниверсальныйОтбор(Кнопка)
	
	ирОбщий.ПолучитьФормуЛкс("Обработка.ирМенеджерТабличногоПоля.Форма",, ЭтаФорма, ).УстановитьСвязь(ЭлементыФормы.ДинамическийСписок);

КонецПроцедуры

Процедура КП_СписокСжатьКолонки(Кнопка)
	
	ирОбщий.СжатьКолонкиТабличногоПоляЛкс(ЭлементыФормы.ДинамическийСписок);
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	Если КлючУникальности <> Неопределено Тогда
		ОбъектМД = Метаданные.НайтиПоПолномуИмени(КлючУникальности);
		Если ОбъектМД <> Неопределено Тогда
			УстановитьОбъектМетаданных(КлючУникальности);
		КонецЕсли;
	КонецЕсли; 
	Если Истина
		И ЗначениеЗаполнено(ОбъектМетаданных)
		И НачальноеЗначениеВыбора <> Неопределено 
	Тогда
		ЭлементыФормы.ДинамическийСписок.ТекущаяСтрока = НачальноеЗначениеВыбора;
	КонецЕсли; 
	
КонецПроцедуры

Процедура КП_СписокШиринаКолонок(Кнопка)
	
	ирОбщий.ВвестиИУстановитьШиринуКолонокТабличногоПоляЛкс(ЭлементыФормы.ДинамическийСписок);
	
КонецПроцедуры

Процедура КП_СписокУниверсальныйРедакторРеквизитов(Кнопка)
	
	ирОбщий.ОткрытьТекущуюСтрокуТабличногоПоляТаблицыБДВРедактореОбъектаБДЛкс(ЭлементыФормы.ДинамическийСписок);
	
КонецПроцедуры

Процедура КП_СписокОПодсистеме(Кнопка)
	
	ирОбщий.ОткрытьСправкуПоПодсистемеЛкс(ЭтотОбъект);

КонецПроцедуры

Процедура ГлавнаяКоманднаяПанельНовоеОкно(Кнопка)
	
	ирОбщий.ОткрытьНовоеОкноОбработкиЛкс(ЭтотОбъект);
	
КонецПроцедуры

Процедура ДинамическийСписокПриПолученииДанных(Элемент, ОформленияСтрок)
	
	КолонкаИдентфиикатор = Элемент.Колонки.Найти("ИдентификаторЛкс");
	Если КолонкаИдентфиикатор <> Неопределено Тогда
		КолонкаИдентификатораВидима = КолонкаИдентфиикатор.Видимость;
	Иначе
		КолонкаИдентификатораВидима = Ложь;
	КонецЕсли; 
	Для каждого ОформлениеСтроки Из ОформленияСтрок Цикл
		ДанныеСтроки = ОформлениеСтроки.ДанныеСтроки;
		Если ДанныеСтроки = неопределено Тогда
			Продолжить;
		КонецЕсли;
		Если КолонкаИдентификатораВидима Тогда
			ЯчейкаИдентификатора = ОформлениеСтроки.Ячейки["ИдентификаторЛкс"];
			ЯчейкаИдентификатора.УстановитьТекст("" + ДанныеСтроки.Ссылка.УникальныйИдентификатор());
		КонецЕсли;
		Если Истина
			И Не ЭтоПеречисление
			И Элемент.Значение.Колонки.Найти("Активность") <> Неопределено
			И ДанныеСтроки.Активность = Ложь 
		Тогда
			ОформлениеСтроки.ЦветТекста = Новый Цвет(100, 100, 100);
		КонецЕсли; 
	КонецЦикла;

КонецПроцедуры

Процедура КП_СписокОбъединитьСсылки(Кнопка)
	
	ПараметрКоманды = ЭлементыФормы.ДинамическийСписок.ВыделенныеСтроки;
	Если ПараметрКоманды.Количество() = 0 Тогда
		Предупреждение("Необходимо выбрать хотя бы один объект");
		Возврат;
	КонецЕсли; 
	ФормаОбработки = ирОбщий.ПолучитьФормуЛкс("Обработка.ирПоискДублейИЗаменаСсылок.Форма");
	ФормаОбработки.ОткрытьДляЗаменыПоСпискуСсылок(ПараметрКоманды);
	
КонецПроцедуры

Процедура КП_СписокОбработатьОбъекты(Кнопка)
	
	ирОбщий.ОткрытьПодборИОбработкуОбъектовИзТабличногоПоляДинамическогоСпискаЛкс(ЭлементыФормы.ДинамическийСписок);

КонецПроцедуры

Процедура КП_СписокОтборБезЗначенияВТекущейКолонке(Кнопка)
	
	ирОбщий.ТабличноеПоле_ОтборБезЗначенияВТекущейКолонке_КнопкаЛкс(ЭлементыФормы.ДинамическийСписок);

КонецПроцедуры

Процедура ОбъектМетаданныхПриИзменении(Элемент)
	
	УстановитьОбъектМетаданных(Элемент.Значение);
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, Метаданные().Имя);
	
КонецПроцедуры

Процедура ОбъектМетаданныхНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, Метаданные().Имя);

КонецПроцедуры

Процедура ОбъектМетаданныхОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		СтандартнаяОбработка = Ложь;
		лПолноеИмяОбъекта = Неопределено;
		Если ВыбранноеЗначение.Свойство("ПолноеИмяОбъекта", лПолноеИмяОбъекта) Тогда
			ОбъектМетаданных = ВыбранноеЗначение.ПолноеИмяОбъекта;
			ОбъектМетаданныхПриИзменении(Элемент);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура КП_СписокСколькоСтрок(Кнопка)
	
	ирОбщий.ТабличноеПоле_СколькоСтрокЛкс(ЭлементыФормы.ДинамическийСписок);

КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ПослеВосстановленияЗначений()
	
	УстановитьОбъектМетаданных();
	
КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	ЗначениеТабличногоПоля = ЭлементыФормы.ДинамическийСписок.Значение;
	Попытка
		ПредставлениеОтбора = "" + ЗначениеТабличногоПоля.Отбор;
	Исключение
		ПредставлениеОтбора = "";
	КонецПопытки; 
	Если ПредставлениеОтбора = "" Тогда
		ПредставлениеОтбора = "нет";
	КонецЕсли; 
	ЭлементыФормы.НадписьОтбор.Заголовок = "Отбор: " + ПредставлениеОтбора;
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ирОбщий.ФормаОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура ДинамическийСписокВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если РежимВыбора Тогда
		ОповеститьОВыборе(ВыбраннаяСтрока);
		СтандартнаяОбработка = Ложь;
	КонецЕсли; 
	
КонецПроцедуры

Процедура КП_СписокВыбратьНужноеКоличество(Кнопка)
	
	Количество = 0;
	Если Не ВвестиЧисло(Количество, "Введите количество", 6, 0) Тогда
		Возврат;
	КонецЕсли; 
	Построитель = Новый ПостроительЗапроса("ВЫБРАТЬ ПЕРВЫЕ " + XMLСтрока(Количество) + " * ИЗ " + ирОбщий.ПолучитьИмяТаблицыИзМетаданныхЛкс(ОбъектМетаданных) + " КАК Т");
	Построитель.ЗаполнитьНастройки();
	ирОбщий.СкопироватьОтборДинамическогоСпискаЛкс(Построитель.Отбор, ЭлементыФормы.ДинамическийСписок.Значение.Отбор);
	ирОбщий.СкопироватьПорядокЛкс(Построитель.Порядок, ЭлементыФормы.ДинамическийСписок.Значение.Порядок);
	Выборка = Построитель.Результат.Выбрать();
	ВыделенныеСтроки = ЭлементыФормы.ДинамическийСписок.ВыделенныеСтроки;
	Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(Выборка.Количество(), "Выделение");
	Пока Выборка.Следующий() Цикл
		ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
		ВыделенныеСтроки.Добавить(ирОбщий.ПолучитьКлючСтрокиТаблицыБДИзСтрокиТаблицыЗначенийЛкс(ОбъектМетаданных, Выборка));
	КонецЦикла;
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	Если Выборка.Количество() <> Количество Тогда
		Сообщить("Выделены все отобранные элементы, но меньшим количеством " + XMLСтрока(Выборка.Количество()));
	КонецЕсли; 
	
КонецПроцедуры

Процедура КлсУниверсальнаяКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработчикОжиданияСПараметрамиЛкс() Экспорт 
	
	ирОбщий.ОбработчикОжиданияСПараметрамиЛкс();

КонецПроцедуры

Процедура КП_СписокНайтиСсылкиНаКлючСтроки(Кнопка)
	
	ТекущаяСтрока = ЭлементыФормы.ДинамическийСписок.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
 	ПоискСсылокНаОбъект = ирОбщий.ПолучитьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирПоискСсылокНаОбъект");
	#Если _ Тогда
		ПоискСсылокНаОбъект = Обработки.ирПоискСсылокНаОбъект.Создать();
	#КонецЕсли
	ПоискСсылокНаОбъект.НайтиИПоказатьСсылки(ТекущаяСтрока);
	
КонецПроцедуры

Процедура КП_СписокКопироватьСсылку(Кнопка)
	
	ТекущийЭлементФормы = ЭлементыФормы.ДинамическийСписок;
	ТекущаяСтрока = ТекущийЭлементФормы.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ирОбщий.БуферОбмена_УстановитьЗначениеЛкс(ТекущаяСтрока);
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирДинамическийСписок.Форма.Форма");
