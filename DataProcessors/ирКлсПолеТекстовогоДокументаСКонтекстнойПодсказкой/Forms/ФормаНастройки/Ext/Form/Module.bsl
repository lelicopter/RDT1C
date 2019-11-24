﻿Процедура ОсновныеДействияФормыОК(Кнопка)
	
	ирОбщий.СохранитьЗначениеЛкс(ИмяКласса + ".ФайлШаблоновТекста", ФайлШаблоновТекста);
	ирКэш.Получить().ПолучитьТаблицуШаблоновТекста(ИмяКласса, мСообщенияЧерезПредупреждения, Истина);
	ирОбщий.СохранитьЗначениеЛкс(ИмяКласса + ".ЛиОткрыватьПустойСписок", ЛиОткрыватьПустойСписок);
	ирОбщий.СохранитьЗначениеЛкс(ИмяКласса + ".ВычислятьТипыВСписке", ВычислятьТипыВСписке);
	ирОбщий.СохранитьЗначениеЛкс(ИмяКласса + ".ЛиАктивизироватьОкноСправкиПриЕгоОткрытии", ЛиАктивизироватьОкноСправкиПриЕгоОткрытии);
	ирОбщий.СохранитьЗначениеЛкс(ИмяКласса + ".ИспользоватьПромежуточныеДополнения", ИспользоватьПромежуточныеДополнения);
	ирОбщий.СохранитьЗначениеЛкс(ИмяКласса + ".ПредпочитаюСобственныйКонструкторЗапроса", ПредпочитаюСобственныйКонструкторЗапроса);
	Закрыть();
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ФайлШаблоновТекста = ирОбщий.ВосстановитьЗначениеЛкс(ИмяКласса + ".ФайлШаблоновТекста");
	ЛиОткрыватьПустойСписок = ирОбщий.ВосстановитьЗначениеЛкс(ИмяКласса + ".ЛиОткрыватьПустойСписок");
	ВычислятьТипыВСписке = ирОбщий.ВосстановитьЗначениеЛкс(ИмяКласса + ".ВычислятьТипыВСписке");
	ЛиАктивизироватьОкноСправкиПриЕгоОткрытии = ирОбщий.ВосстановитьЗначениеЛкс(ИмяКласса + ".ЛиАктивизироватьОкноСправкиПриЕгоОткрытии");
	ИспользоватьПромежуточныеДополнения = ирОбщий.ВосстановитьЗначениеЛкс(ИмяКласса + ".ИспользоватьПромежуточныеДополнения");
	ПредпочитаюСобственныйКонструкторЗапроса = ирОбщий.ВосстановитьЗначениеЛкс(ИмяКласса + ".ПредпочитаюСобственныйКонструкторЗапроса");
	ОбновитьИнфоПапкиКэшаМодулей();

КонецПроцедуры

Процедура ОбновитьИнфоПапкиКэшаМодулей()
	
	ирПлатформа = ирКэш.Получить();
	#Если Сервер И Не Сервер Тогда
		ирПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	ПапкаКэшаМодулей = ирПлатформа.ПапкаКэшаМодулей;
	#Если Сервер И Не Сервер Тогда
		ПапкаКэшаМодулей = Новый Файл;
	#КонецЕсли
	ЭтаФорма.КаталогКэшаМодулей = ПапкаКэшаМодулей.ПолноеИмя;
	Если ПапкаКэшаМодулей.Существует() Тогда
		ФайлыКэша = НайтиФайлы(ПапкаКэшаМодулей.ПолноеИмя, "*Модул*");
		Если ФайлыКэша.Количество() > 0 Тогда
			ЭтаФорма.ДатаОбновленияКэшаМодулей = ФайлыКэша[0].ПолучитьВремяИзменения();
		КонецЕсли; 
	КонецЕсли;

КонецПроцедуры

Процедура ФайлШаблоновНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	лПолноеИмяФайла = ирОбщий.ВыбратьФайлЛкс(, "st", "Файл шаблонов текста 1С", Элемент.Значение);
	Если лПолноеИмяФайла = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Элемент.Значение = лПолноеИмяФайла;
	
КонецПроцедуры

Процедура ФайлШаблоновТекстаОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТаблицаШаблоновТекста = ирКэш.Получить().ПолучитьТаблицуШаблоновТекста(ИмяКласса, мСообщенияЧерезПредупреждения);
	ТаблицаШаблоновТекста.Сортировать("Шаблон");
	ирОбщий.ИсследоватьЛкс(ТаблицаШаблоновТекста, Ложь, Истина);
	
КонецПроцедуры

Процедура КоманднаяПанель1СтруктураФормы(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруФормыЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура КоманднаяПанель1ОбновитьКэшМодулей(Кнопка)
	
	Ответ = Вопрос("Обновление кэша модулей использует конфигуратор текущей базы и может занять до нескольких минут. Продолжить?", РежимДиалогаВопрос.ОКОтмена);
	Если Ответ = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	УдалитьФайлы(КаталогКэшаМодулей, "*");
	ТекстЛога = "";
	Успех = ирОбщий.ВыполнитьКомандуКонфигуратораЛкс("/DumpConfigFiles """ + КаталогКэшаМодулей + """ -Module", СтрокаСоединенияИнформационнойБазы(), ТекстЛога, Ложь, "Выгрузка модулей конфигурации");
	Если Не Успех Тогда 
		Сообщить(ТекстЛога);
		Возврат;
	КонецЕсли;
	ОбновитьИнфоПапкиКэшаМодулей();
	
КонецПроцедуры

Процедура КаталогКэшаМодулейОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗапуститьПриложение(КаталогКэшаМодулей);
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирКлсПолеТекстовогоДокументаСКонтекстнойПодсказкой.Форма.ФормаНастройки");
