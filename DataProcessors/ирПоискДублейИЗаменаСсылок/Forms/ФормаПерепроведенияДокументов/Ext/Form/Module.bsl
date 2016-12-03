﻿//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирПривилегированный Экспорт;

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
				Сообщить("Ошибка перепроведения " + ДокументОбъект + ": " + ОписаниеОшибки, СтатусСообщения.Важное);
			КонецЕсли;
		КонецПопытки; 
		Если Успех Тогда
			Сообщить("Перепроведен " + ДокументОбъект);
		КонецЕсли;
		ДокументыДляУдаленияИзСписка.Добавить(Документ);
	КонецЦикла;
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	Для Каждого Документ Из ДокументыДляУдаленияИзСписка Цикл
		Строка = ТаблицаДокументов.Найти(Документ, "Документ");
		ТаблицаДокументов.Удалить(Строка);
	КонецЦикла; 
	
КонецПроцедуры

Процедура КлсУниверсальнаяКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработчикОжиданияСПараметрамиЛкс() Экспорт 
	
	ирОбщий.ОбработчикОжиданияСПараметрамиЛкс();

КонецПроцедуры

//ирПортативный #Если Клиент Тогда
//ирПортативный Контейнер = Новый Структура();
//ирПортативный Оповестить("ирПолучитьБазовуюФорму", Контейнер);
//ирПортативный Если Не Контейнер.Свойство("ирПортативный", ирПортативный) Тогда
//ирПортативный 	ПолноеИмяФайлаБазовогоМодуля = ВосстановитьЗначение("ирПолноеИмяФайлаОсновногоМодуля");
//ирПортативный 	ирПортативный = ВнешниеОбработки.ПолучитьФорму(ПолноеИмяФайлаБазовогоМодуля);
//ирПортативный КонецЕсли; 
//ирПортативный ирОбщий = ирПортативный.ПолучитьОбщийМодульЛкс("ирОбщий");
//ирПортативный ирКэш = ирПортативный.ПолучитьОбщийМодульЛкс("ирКэш");
//ирПортативный ирСервер = ирПортативный.ПолучитьОбщийМодульЛкс("ирСервер");
//ирПортативный ирПривилегированный = ирПортативный.ПолучитьОбщийМодульЛкс("ирПривилегированный");
//ирПортативный #КонецЕсли

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирПоискДублейИЗаменаСсылок.Форма.ФормаПерепроведенияДокументов");
