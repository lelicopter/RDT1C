﻿// http://www.hostedredmine.com/issues/882395

&НаКлиенте
Процедура ВывестиСообщениеЛкс(Знач ТекстСообщения) Экспорт 
	Если Не Открыта() Тогда
		АктивнаяФорма = ирКлиент.АктивнаяФормаЛкс();
		Если АктивнаяФорма = Неопределено Тогда
			Возврат;
		КонецЕсли; 
		ПодключитьОбработчикОжидания("ЗавершитьВывод", 0.1, Истина);
		Открыть();
		АктивнаяФорма.Открыть();
	КонецЕсли; 
	Элементы.ГруппаОсновная.Видимость = Истина;
	Если ТекстСообщения <> Неопределено Тогда
		НовыйТекст = ТекстСообщения;
		Если ЗначениеЗаполнено(Текст) Тогда
			НовыйТекст = Текст + Символы.ПС + НовыйТекст;
		КонецЕсли; 
		ТекстовыйДокумент = Новый ТекстовыйДокумент;
		ТекстовыйДокумент.УстановитьТекст(НовыйТекст);
		СделанаОбрезка = Ложь;
		Пока ТекстовыйДокумент.КоличествоСтрок() > 14 Цикл
			ТекстовыйДокумент.УдалитьСтроку(1);
			СделанаОбрезка = Истина;
		КонецЦикла; 
		Если СделанаОбрезка Тогда
			ТекстовыйДокумент.ВставитьСтроку(1, "...");
		КонецЕсли; 
		ЭтаФорма.Текст = ТекстовыйДокумент.ПолучитьТекст();
	КонецЕсли; 
	Если ТекущаяДата() - ПоследнееОбновлениеОтображения >= 1 Тогда
		// Таким образом вызываем синхронную перерисовку не чаще раза в 1 сек
		Элементы.Текст.Видимость = Ложь; // 3мс
		Элементы.Текст.Видимость = Истина; // 5мс
		ЭтаФорма.ПоследнееОбновлениеОтображения = ТекущаяДата();
		НомерСтроки = Макс(1, ТекстовыйДокумент.КоличествоСтрок());
		Элементы.Текст.УстановитьГраницыВыделения(НомерСтроки, 1, НомерСтроки, 1);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьВывод() Экспорт 
	
	Если Открыта() Тогда
		Закрыть();
	КонецЕсли; 
	ЭтаФорма.Текст = "";
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Без этого иногда сообщения после завершения потока кода будут выводиться в эту же форму и сразу исчезать вместе с ее закрытиием https://www.hostedredmine.com/issues/924211
	ЭтаФорма.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс; 
	
КонецПроцедуры
