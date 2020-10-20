﻿Процедура ПриОткрытии()
	
	Для Каждого Метаданное из Метаданные.РегламентныеЗадания Цикл
		ЭлементыФормы.МетаданныеВыбор.СписокВыбора.Добавить(Метаданное, Метаданное.Представление());
	КонецЦикла;
	
	Если РегламентноеЗадание <> Неопределено Тогда
		ЭтаФорма.МетаданныеВыбор = РегламентноеЗадание.Метаданные;
		ЭтаФорма.МетаданныеИмя = РегламентноеЗадание.Метаданные.Имя;
		ЭлементыФормы.МетаданныеВыбор.ТолькоПросмотр = Истина;
		ЭтаФорма.Наименование = РегламентноеЗадание.Наименование;
		ЭтаФорма.Ключ = РегламентноеЗадание.Ключ;
		ЭтаФорма.Использование = РегламентноеЗадание.Использование;
		ЭтаФорма.ПользователиВыбор = РегламентноеЗадание.ИмяПользователя;
		ЭтаФорма.КоличествоПовторовПриАварийномЗавершении = РегламентноеЗадание.КоличествоПовторовПриАварийномЗавершении;
		ЭтаФорма.ИнтервалПовтораПриАварийномЗавершении = РегламентноеЗадание.ИнтервалПовтораПриАварийномЗавершении;
		ЭтаФорма.Предопределенное = РегламентноеЗадание.Предопределенное;
		ЭтаФорма.Расписание = РегламентноеЗадание.Расписание;
		ЭтаФорма.УникальныйИдентификатор = РегламентноеЗадание.УникальныйИдентификатор;
		Для Индекс = 0 По РегламентноеЗадание.Параметры.ВГраница() Цикл
			СтрокаПараметра = Параметры.Добавить();
			СтрокаПараметра.Значение = РегламентноеЗадание.Параметры[Индекс];
			ОбновитьПредставлениеИТипЗначенияВСтроке(СтрокаПараметра);
		КонецЦикла;
		МетаданныеВыборПриИзменении();
	Иначе
		ЭтаФорма.Расписание = Новый РасписаниеРегламентногоЗадания;
	КонецЕсли;
	
	
КонецПроцедуры

Процедура РасписаниеНажатие(Элемент)
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(Расписание);
	Если Диалог.ОткрытьМодально() Тогда
		ЭтаФорма.Расписание = Диалог.Расписание;
	КонецЕсли;
	
КонецПроцедуры

Процедура OK(Кнопка)
	Попытка
		Если МетаданныеВыбор = Неопределено Тогда
			ВызватьИсключение("Не выбраны метаданные регламентного задания.");
		КонецЕсли;
		
		Если РегламентноеЗадание = Неопределено Тогда
			РегламентноеЗадание = РегламентныеЗадания.СоздатьРегламентноеЗадание(МетаданныеВыбор);
		КонецЕсли;
		
		РегламентноеЗадание.Наименование = Наименование;
		РегламентноеЗадание.Ключ = Ключ;
		РегламентноеЗадание.Использование = Использование;
		РегламентноеЗадание.ИмяПользователя = ПользователиВыбор;
		РегламентноеЗадание.КоличествоПовторовПриАварийномЗавершении = КоличествоПовторовПриАварийномЗавершении;
		РегламентноеЗадание.ИнтервалПовтораПриАварийномЗавершении = ИнтервалПовтораПриАварийномЗавершении;
		РегламентноеЗадание.Расписание = Расписание;

		// Антибаг 8.2.15. Добавление в текущий массив не работает. http://partners.v8.1c.ru/forum/thread.jsp?id=1012620#1012620
		////РегламентноеЗадание.Параметры.Очистить();
		//Для Индекс = 0 По Параметры.Количество() - 1 Цикл
		//	РегламентноеЗадание.Параметры.Добавить(Параметры[Индекс].Значение);
		//КонецЦикла;
		РегламентноеЗадание.Параметры = Параметры.ВыгрузитьКолонку("Значение");

		РегламентноеЗадание.Записать();
		
		Закрыть(РегламентноеЗадание.УникальныйИдентификатор);
	Исключение	
		ПоказатьИнформациюОбОшибке(ИнформацияОбОшибке());	
	КонецПопытки;
КонецПроцедуры

Процедура ПараметрыЗначениеКонстантыПриИзменении(Элемент)
	
	ТабличноеПоле = ЭлементыФормы.Параметры;
	ТабличноеПоле.ТекущиеДанные.Значение = Элемент.Значение;
	ОбновитьПредставлениеИТипЗначенияВСтроке();
	
КонецПроцедуры

Процедура ПараметрыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ОформлениеСтроки.Ячейки.Номер.УстановитьТекст(Параметры.Индекс(ДанныеСтроки) + 1);
	ирОбщий.ТабличноеПолеОтобразитьПиктограммыТиповЛкс(ОформлениеСтроки, "Значение");

КонецПроцедуры

Процедура КоманднаяПанельПараметрыИсследоватьПараметры(Кнопка)
	
	ирОбщий.ИсследоватьЛкс(Параметры,,Истина);
	
КонецПроцедуры

Процедура ПараметрыЗначениеОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	ирОбщий.ПолеВвода_ОкончаниеВводаТекстаЛкс(Элемент, Текст, Значение, СтандартнаяОбработка);

КонецПроцедуры

Процедура ПараметрыЗначениеНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаКолонкиРасширенногоЗначения_НачалоВыбораЛкс(ЭтаФорма, ЭлементыФормы.Параметры, СтандартнаяОбработка, ЭлементыФормы.Параметры.ТекущаяСтрока.Значение);
	ОбновитьПредставлениеИТипЗначенияВСтроке();
	
КонецПроцедуры

Процедура МетаданныеВыборПриИзменении(Элемент = Неопределено)
	
	МетаЗадание = Метаданные.РегламентныеЗадания[МетаданныеВыбор.Имя];
	ЭтаФорма.Метод = МетаЗадание.ИмяМетода;
	ЭтаФорма.МетаданныеИмя = МетаЗадание.Имя;
	
КонецПроцедуры

Процедура ОбновитьПредставлениеИТипЗначенияВСтроке(СтрокаТаблицы = Неопределено)
	
	Если СтрокаТаблицы = Неопределено Тогда
		СтрокаТаблицы = ЭлементыФормы.Параметры.ТекущиеДанные;
	КонецЕсли; 
	СтрокаТаблицы.ТипЗначения = ТипЗнч(СтрокаТаблицы.Значение);
	СтрокаТаблицы.ПредставлениеЗначения = СтрокаТаблицы.Значение;
	
КонецПроцедуры

Процедура МетодОткрытие(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПерейтиКОпределениюМетодаВКонфигуратореЛкс(Метод);
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

Процедура ПользователиВыборНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаПользователя_НачалоВыбораЛкс(Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирОбщий.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирКонсольЗаданий.Форма.ДиалогРегламентногоЗадания");

ОписаниеТипов = Новый ОписаниеТипов();
Параметры.Колонки.Добавить("Значение", ОписаниеТипов);
