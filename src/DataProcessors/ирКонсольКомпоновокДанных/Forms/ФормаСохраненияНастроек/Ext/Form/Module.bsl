﻿
Процедура КнопкаВыполнитьНажатие(Элемент)
	
	Если НаименованиеНастройки = "" Тогда
		Вопрос(НСтр("ru='Необходимо ввести имя настройки'"), РежимДиалогаВопрос.ОК);
		Возврат;
	КонецЕсли;
	Закрыть(Истина);
	
КонецПроцедуры

Процедура ОтменаНажатие(Элемент)
	
	Закрыть(Ложь);
	
КонецПроцедуры

Процедура УдалитьНажатие(Элемент)
	
	Если ЭлементыФормы.Настройки.ТекущаяСтрока <> Неопределено Тогда
		Настройки.Удалить(ЭлементыФормы.Настройки.ТекущаяСтрока);
	КонецЕсли;
	
КонецПроцедуры

Процедура НастройкиПриИзмененииФлажка(Элемент, Колонка)
	
	Для Каждого ТЭ Из Настройки Цикл
		Если ТЭ <> Элемент.ТекущиеДанные Тогда
			ТЭ.Пометка = Ложь;
		КонецЕсли;
	КонецЦикла;
	ИспользоватьПриОткрытии = Элемент.ТекущиеДанные.Пометка;
	
КонецПроцедуры

Процедура НастройкиПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущиеДанные <> Неопределено Тогда 
		НаименованиеНастройки = Элемент.ТекущиеДанные.Представление;
		ИспользоватьПриОткрытии = Элемент.ТекущиеДанные.Пометка;
	КонецЕсли;
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирКлиент.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирКлиент.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирКонсольКомпоновокДанных.Форма.ФормаСохраненияНастроек");
