﻿
Процедура ОсновныеДействияФормыОсновныеДействияФормыОК(Кнопка)
	
	ирОбщий.СохранитьЗначениеЛкс("ИсполняемыйФайлRegexBuddy", ЭтаФорма.ИсполняемыйФайлRegexBuddy);
	Закрыть();
	
КонецПроцедуры

Процедура ИсполняемыйФайлRegexBuddyНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	РезультатВыбора = ирКлиент.ВыбратьФайлЛкс(, "exe", "Исполняемый файл", ЭтаФорма.ИсполняемыйФайлRegexBuddy);
	Если РезультатВыбора <> Неопределено Тогда
		ирКлиент.ИнтерактивноЗаписатьВПолеВводаЛкс(ЭлементыФормы.ИсполняемыйФайлRegexBuddy, РезультатВыбора);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ЭтаФорма.ИсполняемыйФайлRegexBuddy = ирОбщий.ВосстановитьЗначениеЛкс("ИсполняемыйФайлRegexBuddy");
	
КонецПроцедуры
