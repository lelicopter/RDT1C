﻿Перем мПлатформа;

Процедура ОсновныеДействияФормыПрименить(Кнопка)
	
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
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	ЭлементыФормы.НастройкиКолонок.Колонки.Положение.ЭлементУправления.СписокВыбора = мПлатформа.ДоступныеЗначенияТипа("ПоложениеКолонки");
	
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
	
	ПорядокИзменен = ирОбщий.ТабличноеПолеСдвинутьВыделенныеСтрокиЛкс(ЭлементыФормы.НастройкиКолонок, -1);
	Если ПорядокИзменен Тогда
		ЭтаФорма.ПрименятьПорядок = Истина;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДействияФормыПереместитьВниз(Кнопка)
	
	ПорядокИзменен = ирОбщий.ТабличноеПолеСдвинутьВыделенныеСтрокиЛкс(ЭлементыФормы.НастройкиКолонок, +1);
	Если ПорядокИзменен Тогда
		ЭтаФорма.ПрименятьПорядок = Истина;
	КонецЕсли; 

КонецПроцедуры

Процедура НастройкиКолонокПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Колонка)
	
	ЭтаФорма.ПрименятьПорядок = Истина;
	
КонецПроцедуры

Процедура НастройкиКолонокПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	
КонецПроцедуры

Процедура НастройкиКолонокПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);

КонецПроцедуры

Процедура ДействияФормыЗагрузитьПорядокИзОсновнойФормы(Кнопка)
	
	Если ЗначениеЗаполнено(СсылкаОбъекта) Тогда
		Форма = СсылкаОбъекта.ПолучитьФорму();
	Иначе
		Форма = ирОбщий.ПолучитьФормуСпискаЛкс(ПолноеИмяТаблицы,, Ложь, ВладелецФормы, РежимВыбора);
	КонецЕсли; 
	Если Форма = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если ТипЗнч(Форма) = Тип("Форма") Тогда
		ТабличноеПоле = Неопределено;
		Для Каждого ЭлементФормы Из Форма.ЭлементыФормы Цикл
			Если Истина
				И  ТипЗнч(ЭлементФормы) = Тип("ТабличноеПоле")
				И (Ложь
					Или Не ЗначениеЗаполнено(СсылкаОбъекта)
					Или Найти(НРег(ЭлементФормы.Имя), НРег(ирОбщий.ПоследнийФрагментЛкс(ПолноеИмяТаблицы))) > 0)
			Тогда
				ТабличноеПоле = ЭлементФормы;
				Прервать;
			КонецЕсли; 
		КонецЦикла;
	Иначе
		ТабличноеПоле = Неопределено;
		Для Каждого ЭлементФормы Из Форма.Элементы Цикл
			Если Истина
				И  ТипЗнч(ЭлементФормы) = Тип("ТаблицаФормы")
				И (Ложь
					Или Не ЗначениеЗаполнено(СсылкаОбъекта)
					Или Найти(НРег(ЭлементФормы.Имя), НРег(ирОбщий.ПоследнийФрагментЛкс(ПолноеИмяТаблицы))) > 0)
			Тогда
				ТабличноеПоле = ЭлементФормы;
				Прервать;
			КонецЕсли; 
		КонецЦикла;
	КонецЕсли; 
	Если ТабличноеПоле <> Неопределено Тогда
		Счетчик = 0;
		СтрокаКолонки = ЭлементыФормы.НастройкиКолонок.Значение.Найти("Картинка", "Имя");
		Если СтрокаКолонки <> Неопределено Тогда
			ЭлементыФормы.НастройкиКолонок.Значение.Сдвинуть(СтрокаКолонки, -ЭлементыФормы.НастройкиКолонок.Значение.Индекс(СтрокаКолонки)+Счетчик);
			Счетчик = Счетчик + 1;
		КонецЕсли; 
		Для Каждого КолонкаТП Из ирОбщий.КолонкиТаблицыФормыИлиТабличногоПоляЛкс(ТабличноеПоле) Цикл
			ДанныеКолонки = ирОбщий.ПутьКДаннымКолонкиТабличногоПоляЛкс(ТабличноеПоле, КолонкаТП);
			Если ЗначениеЗаполнено(ДанныеКолонки) Тогда
				СтрокаКолонки = ЭлементыФормы.НастройкиКолонок.Значение.Найти(ДанныеКолонки, "Имя");
			ИначеЕсли КолонкаТП.Имя = "Картинка" Тогда
				СтрокаКолонки = ЭлементыФормы.НастройкиКолонок.Значение.Найти(КолонкаТП.Имя, "Имя");
			КонецЕсли;
			Если СтрокаКолонки <> Неопределено Тогда
				ЭлементыФормы.НастройкиКолонок.Значение.Сдвинуть(СтрокаКолонки, -ЭлементыФормы.НастройкиКолонок.Значение.Индекс(СтрокаКолонки)+Счетчик);
				Счетчик = Счетчик + 1;
			КонецЕсли; 
		КонецЦикла;
		ЭтаФорма.ПрименятьПорядок = Истина;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирОбщий.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура НастройкиКолонокПриИзмененииФлажка(Элемент, Колонка)
	
	ирОбщий.ТабличноеПолеПриИзмененииФлажкаЛкс(ЭтаФорма, Элемент, Колонка);
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирДинамическийСписок.Форма.НастройкиКолонок");

мПлатформа = ирКэш.Получить();