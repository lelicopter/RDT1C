﻿Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	ЭтаФорма.СтароеСлово = ТекущееОбъектноеВыражение();
	Если Ложь
		Или Не ЗначениеЗаполнено(СтароеСлово)
		Или Найти(СтароеСлово, ".") > 0
	Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	ЭтаФорма.НовоеСлово = СтароеСлово;
	Вхождения = ВхожденияПеременной(СтароеСлово);
	Если Вхождения.Количество() = 0 Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	ирОбщий.ОбновитьТекстПослеМаркераВСтрокеЛкс(ЭлементыФормы.НадписьНайдено.Заголовок,, Вхождения.Количество(), ": ");
КонецПроцедуры

Процедура ПриОткрытии()
	
	ирКлиент.Форма_ПриОткрытииЛкс(ЭтаФорма); 
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирКлиент.Форма_ПриЗакрытииЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирКлиент.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ВпередНажатие(Элемент)
	
	НайтиПоказатьСловоВТексте(СтароеСлово, "Переменная",, Истина);
	
КонецПроцедуры

Функция ВхожденияПеременной(ИмяПеременной)
	
	ШаблонПоискаПеременной = ирОбщий.ШаблонПоискаСловаЛкс(ИмяПеременной, ШаблонПоискаПеременной());
	Вхождения = ирОбщий.НайтиРегВыражениеЛкс(ПолеТекста.ПолучитьТекст(), ШаблонПоискаПеременной,,,,,,,, Истина);
	Возврат Вхождения;

КонецФункции

Процедура ОсновныеДействияФормыПрименитьИЗакрыть(Кнопка)
	
	Если Не ЗначениеЗаполнено(НовоеСлово) Тогда
		Предупреждение("Нужно указать новое имя");
		Возврат;
	КонецЕсли; 
	Если Не ирОбщий.ЛиИмяПеременнойЛкс(НовоеСлово) Тогда
		Предупреждение("Некорректное новое имя");
		Возврат;
	КонецЕсли;
	Если НайтиПоказатьСловоВТексте(НовоеСлово, "Переменная",, Истина, Истина) Тогда 
		Ответ = Вопрос("Новое имя уже используется. Продолжить?", РежимДиалогаВопрос.ОКОтмена);
		Если Ответ <> КодВозвратаДиалога.ОК Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	Пока НайтиПоказатьСловоВТексте(СтароеСлово, "Переменная",,, Истина) Цикл
		ВыделенныйТекст(НовоеСлово);
	КонецЦикла;
	Закрыть(ЭтаФорма);
	
КонецПроцедуры

Процедура НовоеСловоПриИзменении(Элемент)
	ирКлиент.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
КонецПроцедуры

Процедура НовоеСловоНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	ирОбщий.ПолеВводаСИсториейВыбора_ОбновитьСписокЛкс(Элемент, ЭтаФорма);
КонецПроцедуры

ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирКлсПолеТекстаПрограммы.Форма.ПереименоватьСлово");
