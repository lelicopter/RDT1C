﻿Перем мСловарьПланаЗапроса;
Перем мНомерСамойТяжелойОперации;

Процедура ПриОткрытии()
	
	ирКлиент.Форма_ПриОткрытииЛкс(ЭтаФорма);
	мСловарьПланаЗапроса = ирОбщий.ТаблицаЗначенийИзТабличногоДокументаЛкс(ОбработкаОбъект.ПолучитьМакет("ОперацииПланаЗапросаMSSQL"),,,, Истина);
	#Если Сервер И Не Сервер Тогда
	    мСловарьПланаЗапроса = Новый ТаблицаЗначений;
	#КонецЕсли
	мСловарьПланаЗапроса.Индексы.Добавить("Ключ");
	УстановитьПлан();
	
КонецПроцедуры

Процедура УстановитьПлан()
	
	Если ирОбщий.СтрНачинаетсяСЛкс(СокрЛ(Текст), "<ShowPlanXML") Тогда
		ирОбщий.СообщитьЛкс("XML формат плана запроса не поддерживается. Нужен текстовый формат.",,, Истина);
		Возврат;
	КонецЕсли;
	КолонкиПланаЗапроса = ирОбщий.ТаблицаЗначенийИзТабличногоДокументаЛкс(ОбработкаОбъект.ПолучитьМакет("КолонкиПланаЗапросаMSSQL"));
	#Если Сервер И Не Сервер Тогда
	    КолонкиПланаЗапроса = Новый ТаблицаЗначений;
	#КонецЕсли
	Для Каждого СтрокаКолонки Из КолонкиПланаЗапроса Цикл
		ЭлементыФормы.ДеревоПлана.Колонки[СтрокаКолонки.ИмяКолонки].ПодсказкаВШапке = СтрокаКолонки.Описание;
		ЭлементыФормы.ДеревоПлана.Колонки[СтрокаКолонки.ИмяКолонки].ТекстШапки = СтрокаКолонки.ЗаголовокКолонки;
		ЭлементыФормы.ОператорыПланаЗапроса.Колонки[СтрокаКолонки.ИмяКолонки].ПодсказкаВШапке = СтрокаКолонки.Описание;
		ЭлементыФормы.ОператорыПланаЗапроса.Колонки[СтрокаКолонки.ИмяКолонки].ТекстШапки = СтрокаКолонки.ЗаголовокКолонки;
	КонецЦикла;
	RegExp = ирКэш.Получить().RegExp;
	RegExp.Global = Истина;
	RegExp.Multiline = Ложь;
	ШаблонЧисла = "([^,_\n]*),";
	ШаблонНепечатного = "\s*";
	RegExp.Pattern = ""
	+ ШаблонЧисла + ШаблонНепечатного //1
	+ ШаблонЧисла + ШаблонНепечатного //2
	+ ШаблонЧисла + ШаблонНепечатного //3
	+ ШаблонЧисла + ШаблонНепечатного //4
	+ ШаблонЧисла + ШаблонНепечатного //5
	+ ШаблонЧисла + ШаблонНепечатного //6
	+ ШаблонЧисла + ШаблонНепечатного //7
	+ ШаблонЧисла                     //8
	+ "([^\n]*)(?:\n|$)";             //9
	РезультатПоиска = RegExp.НайтиВхождения(Текст);
	МаркерИнструкции = "|--";
	НомерОперации = 1;
	ИндексПервойКолонкиПланаЗапрос = 1;
	ДеревоПлана.Строки.Очистить();
	Для Каждого Вхождение Из РезультатПоиска Цикл
		ТекстИнструкции = Вхождение.SubMatches(8);
		ПозицияПалки = Найти(ТекстИнструкции, МаркерИнструкции);
		Уровень = 0;
		Если ПозицияПалки > 0 Тогда
			Уровень = (ПозицияПалки - 4) / 5 + 1;
			ТекстИнструкции = Сред(ТекстИнструкции, ПозицияПалки + СтрДлина(МаркерИнструкции));
		Иначе
			ТекстИнструкции = СокрЛ(ТекстИнструкции);
		КонецЕсли; 
		СтрокаДерева = ДобавитьСтрокуДерева(Уровень);
		СтрокаДерева.Инструкция = ТекстИнструкции;
		СтрокаДерева.ОператорАнгл = ирОбщий.ПервыйФрагментЛкс(СтрокаДерева.Инструкция, "(");
		СтрокаСловаря = мСловарьПланаЗапроса.Найти(СтрокаДерева.ОператорАнгл, "Ключ");
		Если СтрокаСловаря <> Неопределено Тогда
			СтрокаДерева.Оператор = СтрокаСловаря.Название;
		КонецЕсли; 
		СтрокаДерева.НомерОперации = НомерОперации;
		Для Индекс = 0 По 7 Цикл
			СтрокаЗначения = Вхождение.SubMatches(Индекс);
			ТипКолонки = ТипЗнч(СтрокаДерева[КолонкиПланаЗапроса[Индекс].ИмяКолонки]);
			Если ТипКолонки = Тип("Число") Тогда
				Фрагменты = ирОбщий.СтрРазделитьЛкс(СтрокаЗначения, "E");
				Если Фрагменты.Количество() > 1 Тогда
					Попытка
						БазовоеЧисло = Число(Фрагменты[0])
					Исключение
						ВызватьИсключение "Неверный формат текста. Нужен текстовый формат.";
					КонецПопытки;
					СтрокаЗначения = БазовоеЧисло * pow(10, Число(Фрагменты[1]));
				КонецЕсли; 
			КонецЕсли; 
			СтрокаДерева[КолонкиПланаЗапроса[Индекс].ИмяКолонки] = СтрокаЗначения;
		КонецЦикла;
		НомерОперации = НомерОперации + 1;
	КонецЦикла;
	РасчитатьСтоимостьОпераций(ДеревоПлана.Строки);
	ирКлиент.ТабличноеПолеДеревоЗначений_РазвернутьВсеСтрокиЛкс(ЭлементыФормы.ДеревоПлана);
	ВсеСтрокиДерева = ирОбщий.ВсеСтрокиДереваЗначенийЛкс(ДеревоПлана);
	ОператорыПланаЗапроса.Очистить();
	Если ДеревоПлана.Строки.Количество() > 0 Тогда
		ОбщаяСтоимость = ДеревоПлана.Строки[0].СтоимостьПоддерева;
		Для Каждого СтрокаДерева Из ВсеСтрокиДерева Цикл
			Если ОбщаяСтоимость = 0 Тогда
				СтрокаДерева.СтоимостьПоддереваПроцент = 0;
				СтрокаДерева.СтоимостьОперацииПроцент = 0;
			Иначе
				СтрокаДерева.СтоимостьПоддереваПроцент = СтрокаДерева.СтоимостьПоддерева / ОбщаяСтоимость * 100;
				СтрокаДерева.СтоимостьОперацииПроцент = СтрокаДерева.СтоимостьОперации / ОбщаяСтоимость * 100;
			КонецЕсли; 
			ЗаполнитьЗначенияСвойств(ОператорыПланаЗапроса.Добавить(), СтрокаДерева); 
		КонецЦикла;
		ОператорыПланаЗапроса.Сортировать("СтоимостьОперации убыв");
		мНомерСамойТяжелойОперации = ОператорыПланаЗапроса[0].НомерОперации;
	КонецЕсли;

КонецПроцедуры

Функция РасчитатьСтоимостьОпераций(СтрокиДерева)
	
	Сумма = 0;
	Для каждого СтрокаДерева Из СтрокиДерева Цикл 
		АккумуляторСтоимости = 0;
		Если СтрокаДерева.Строки.Количество() > 0 Тогда
			АккумуляторСтоимости = РасчитатьСтоимостьОпераций(СтрокаДерева.Строки);
		КонецЕсли;
		СтоимостьОперации = СтрокаДерева.СтоимостьПоддерева - АккумуляторСтоимости;
		СтрокаДерева.СтоимостьОперации = ?(СтоимостьОперации < 0, 0, СтоимостьОперации);
		Сумма = Сумма + СтрокаДерева.СтоимостьПоддерева;
	КонецЦикла;
	Возврат Сумма;
	
КонецФункции

Функция ДобавитьСтрокуДерева(Уровень)
	
	СтрокиУровня = ДеревоПлана.Строки;
	Для Счетчик = 2 По Уровень Цикл
		Если СтрокиУровня.Количество() = 0 Тогда
			ВызватьИсключение "Некорректный план запроса. Уровень очередной строки больше уровня предыдущей строки на 2 или более";
		КонецЕсли; 
		СтрокиУровня = СтрокиУровня[СтрокиУровня.Количество() - 1].Строки;
	КонецЦикла;
	Результат = СтрокиУровня.Добавить();
	
	Возврат Результат;
	
КонецФункции

Процедура ДеревоПланаПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ирКлиент.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
	СтрокаСловаря = мСловарьПланаЗапроса.Найти(ДанныеСтроки.ОператорАнгл, "Ключ");
	Если СтрокаСловаря <> Неопределено И ТипЗнч(СтрокаСловаря.Картинка) = Тип("Картинка") Тогда
		ОформлениеСтроки.Ячейки.Инструкция.УстановитьКартинку(СтрокаСловаря.Картинка);
	КонецЕсли; 
	Если ДанныеСтроки.НомерОперации = мНомерСамойТяжелойОперации Тогда
		ОформлениеСтроки.ЦветФона = ирОбщий.ЦветСтиляЛкс("ирЦветФонаОшибки");
	КонецЕсли; 
	//ирКлиент.ОформитьФонТекущейСтрокиЛкс(Элемент, ОформлениеСтроки, ДанныеСтроки);
	
КонецПроцедуры

Процедура ДеревоПланаПриАктивизацииСтроки(Элемент)
	
	ирКлиент.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	ЭтаФорма.ОписаниеОперации = "";
	ЭтаФорма.Инструкция = "";
	Если Элемент.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	СтрокаСловаря = мСловарьПланаЗапроса.Найти(Элемент.ТекущаяСтрока.ОператорАнгл, "Ключ");
	Если СтрокаСловаря = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ЭтаФорма.ОписаниеОперации = СтрокаСловаря.Описание;
	ЭтаФорма.Инструкция = Элемент.ТекущаяСтрока.Инструкция;
	
КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	ирКлиент.Форма_ОбновлениеОтображенияЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирКлиент.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирКлиент.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирКлиент.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт 
	
	ирКлиент.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирКлиент.Форма_ПриЗакрытииЛкс(ЭтаФорма);

КонецПроцедуры

Процедура КоманднаяПанель1УстановитьИзТекста(Кнопка)
	
	ФормаТекста = ирКлиент.ПолучитьФормуТекстаЛкс("", "Вставьте текст плана запроса", "Обычный",,, ЭтаФорма);
	РезультатФормы = ФормаТекста.ОткрытьМодально();
	Если РезультатФормы <> Неопределено Тогда
		ЭтаФорма.Текст = РезультатФормы;
		УстановитьПлан();
	КонецЕсли; 
	
КонецПроцедуры

Процедура КоманднаяПанель1ОткрытьОписаниеМеханизма(Кнопка)
	
	ЗапуститьПриложение("https://infostart.ru/1c/articles/877736/");
	
КонецПроцедуры

ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирАнализТехножурнала.Форма.ПланЗапросаMSSQL");
