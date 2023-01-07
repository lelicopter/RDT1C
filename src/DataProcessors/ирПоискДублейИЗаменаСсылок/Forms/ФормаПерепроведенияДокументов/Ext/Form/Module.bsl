﻿
Процедура КнопкаВыполнитьНажатие(Кнопка)

	Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(ТаблицаДокументов.Количество(), "Перепроведение");
	ДокументыДляУдаленияИзСписка = Новый Массив;
	Для Каждого Строка Из ТаблицаДокументов Цикл
		ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
		Документ = Строка.Документ;
		ДокументОбъект = Документ.ПолучитьОбъект();
		Успех = Истина;
		Попытка
			ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
		Исключение
			Успех = Ложь;
			Если ОстанавливатьсяПоОшибке Тогда
				ВызватьИсключение;
			Иначе
				ОписаниеОшибки = ИнформацияОбОшибке().Описание;
				ирОбщий.СообщитьЛкс("Ошибка перепроведения " + ДокументОбъект + ": " + ОписаниеОшибки, СтатусСообщения.Важное);
			КонецЕсли;
		КонецПопытки; 
		Если Успех Тогда
			ирОбщий.СообщитьЛкс("Перепроведен " + ДокументОбъект);
		КонецЕсли;
		ДокументыДляУдаленияИзСписка.Добавить(Документ);
	КонецЦикла;
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	Для Каждого Документ Из ДокументыДляУдаленияИзСписка Цикл
		Строка = ТаблицаДокументов.Найти(Документ, "Документ");
		ТаблицаДокументов.Удалить(Строка);
	КонецЦикла; 
	
КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирКлиент.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработчикОжиданияСПараметрамиЛкс() Экспорт 
	
	ирКлиент.ОбработчикОжиданияСПараметрамиЛкс();

КонецПроцедуры

Процедура ТаблицаДокументовПриАктивизацииСтроки(Элемент)
	
	ирКлиент.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);

КонецПроцедуры

Процедура ТаблицаДокументовПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ирКлиент.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);

КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирКлиент.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирКлиент.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирПоискДублейИЗаменаСсылок.Форма.ФормаПерепроведенияДокументов");
