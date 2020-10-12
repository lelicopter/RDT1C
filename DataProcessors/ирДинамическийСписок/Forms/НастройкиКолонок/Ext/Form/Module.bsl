﻿Процедура ОсновныеДействияФормыПрименить(Кнопка)
	
	ОповеститьОВыборе(ПолучитьРезультат(Ложь));
	
КонецПроцедуры

Процедура ОсновныеДействияФормыПрименитьИЗакрыть(Кнопка)
	
	Закрыть(ПолучитьРезультат(Истина));
	
КонецПроцедуры

Функция ПолучитьРезультат(Сохранить)
	
	Результат = Новый Структура;
	Результат.Вставить("ПрименятьПорядок", ПрименятьПорядок);
	Результат.Вставить("Сохранить", Сохранить);
	Результат.Вставить("НастройкиКолонок", ОбработкаОбъектСлужебная.НастройкиКолонок.Выгрузить());
	Возврат Результат;

КонецФункции

Процедура ПриОткрытии()
	
	ЭтаФорма.ЗакрыватьПриВыборе = Ложь;
	СтрокаТекущейКолонки = ОбработкаОбъектСлужебная.НастройкиКолонок.Найти(ПараметрИмяТекущейКолонки, "Имя");
	Если СтрокаТекущейКолонки <> Неопределено Тогда
		ЭлементыФормы.НастройкиКолонок.ТекущаяСтрока = СтрокаТекущейКолонки;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДействияФормыУстановитьФлажки(Кнопка)
	
	Если ЭлементыФормы.НастройкиКолонок.ТекущаяКолонка <> Неопределено Тогда
		ирОбщий.ИзменитьПометкиВыделенныхИлиОтобранныхСтрокЛкс(ЭлементыФормы.НастройкиКолонок, "", Истина);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДействияФормыСнятьФлажки(Кнопка)
	
	Если ЭлементыФормы.НастройкиКолонок.ТекущаяКолонка <> Неопределено Тогда
		ирОбщий.ИзменитьПометкиВыделенныхИлиОтобранныхСтрокЛкс(ЭлементыФормы.НастройкиКолонок, "", Ложь);
	КонецЕсли; 

КонецПроцедуры

Процедура ДействияФормыМенеджерТабличногоПоля(Кнопка)
	
	ирОбщий.ОткрытьМенеджерТабличногоПоляЛкс(ЭлементыФормы.НастройкиКолонок, ЭтаФорма);
	
КонецПроцедуры

Процедура ДействияФормыОтборБезЗначенияВТекущейКолонке(Кнопка)
	
	ирОбщий.ТабличноеПолеОтборБезЗначенияВТекущейКолонке_КнопкаЛкс(ЭлементыФормы.НастройкиКолонок);
	
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ДействияФормыАктивизироватьКолонку(Кнопка = Неопределено)
	
	Если ЭлементыФормы.НастройкиКолонок.ТекущаяСтрока = Неопределено Или Не ЭлементыФормы.НастройкиКолонок.ТекущаяСтрока.Видимость Тогда
		Возврат;
	КонецЕсли; 
	Результат = Новый Структура;
	Результат.Вставить("ТекущаяКолонка", ЭлементыФормы.НастройкиКолонок.ТекущаяСтрока.Имя);
	ОповеститьОВыборе(Результат);
	
КонецПроцедуры

Процедура НастройкиКолонокВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если Колонка = ЭлементыФормы.НастройкиКолонок.Колонки.Имя Тогда
		ДействияФормыАктивизироватьКолонку();
	КонецЕсли; 
	
КонецПроцедуры

Процедура НастройкиКолонокПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

Процедура НастройкиКолонокПередНачаломДобавления(Элемент, Отказ, Копирование)
	
	Отказ = Истина;
	
КонецПроцедуры

Процедура ДействияФормыПереместитьВверх(Кнопка)
	
	Индекс = ЭлементыФормы.НастройкиКолонок.Значение.Индекс(ЭлементыФормы.НастройкиКолонок.ТекущаяСтрока);
	Если Индекс > 0 Тогда
		ЭлементыФормы.НастройкиКолонок.Значение.Сдвинуть(ЭлементыФормы.НастройкиКолонок.ТекущаяСтрока, -1);
		ЭтаФорма.ПрименятьПорядок = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ДействияФормыПереместитьВниз(Кнопка)
	
	Индекс = ЭлементыФормы.НастройкиКолонок.Значение.Индекс(ЭлементыФормы.НастройкиКолонок.ТекущаяСтрока);
	Если Индекс > -1 И Индекс < ЭлементыФормы.НастройкиКолонок.Значение.Количество() - 1 Тогда
		ЭлементыФормы.НастройкиКолонок.Значение.Сдвинуть(ЭлементыФормы.НастройкиКолонок.ТекущаяСтрока, +1);
		ЭтаФорма.ПрименятьПорядок = Истина;
	КонецЕсли;

КонецПроцедуры

Процедура НастройкиКолонокПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Колонка)
	
	ЭтаФорма.ПрименятьПорядок = Истина;
	
КонецПроцедуры

Процедура НастройкиКолонокПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	
КонецПроцедуры

Процедура НастройкиКолонокПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);

КонецПроцедуры

Процедура ДействияФормыЗагрузитьПорядокИзОсновнойФормы(Кнопка)
	
	Форма = ирОбщий.ПолучитьФормуСпискаЛкс(ПолноеИмяТаблицы,, Ложь, ВладелецФормы, РежимВыбора);
	Если Форма = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если ТипЗнч(Форма) = Тип("Форма") Тогда
		ТабличноеПоле = Неопределено;
		Для Каждого ЭлементФормы Из Форма.ЭлементыФормы Цикл
			Если ТипЗнч(ЭлементФормы) = Тип("ТабличноеПоле") Тогда
				ТабличноеПоле = ЭлементФормы;
				Прервать;
			КонецЕсли; 
		КонецЦикла;
	Иначе
		ТабличноеПоле = Неопределено;
		Для Каждого ЭлементФормы Из Форма.Элементы Цикл
			Если ТипЗнч(ЭлементФормы) = Тип("ТаблицаФормы") Тогда
				ТабличноеПоле = ЭлементФормы;
				Прервать;
			КонецЕсли; 
		КонецЦикла;
	КонецЕсли; 
	Если ТабличноеПоле <> Неопределено Тогда
		Для Каждого КолонкаТП Из ирОбщий.КолонкиТаблицыФормыИлиТабличногоПоляЛкс(ТабличноеПоле) Цикл
			ДанныеКолонки = ирОбщий.ПутьКДаннымКолонкиТабличногоПоляЛкс(ТабличноеПоле, КолонкаТП);
			Если Не ЗначениеЗаполнено(ДанныеКолонки) Тогда
				Продолжить;
			КонецЕсли;
			СтрокаКолонки = ЭлементыФормы.НастройкиКолонок.Значение.Найти(ДанныеКолонки, "Имя");
			Счетчик = 0;
			Если СтрокаКолонки <> Неопределено Тогда
				ЭлементыФормы.НастройкиКолонок.Значение.Сдвинуть(СтрокаКолонки, -ЭлементыФормы.НастройкиКолонок.Значение.Индекс(СтрокаКолонки)+Счетчик);
				Счетчик = Счетчик + 1;
			КонецЕсли; 
		КонецЦикла;
		ЭтаФорма.ПрименятьПорядок = Истина;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирДинамическийСписок.Форма.НастройкиКолонок");
