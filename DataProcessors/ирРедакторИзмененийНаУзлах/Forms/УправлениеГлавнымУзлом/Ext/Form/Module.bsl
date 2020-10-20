﻿
Процедура НовыйГлавныйУзелПриИзменении(Элемент = Неопределено)
	
	Если НовыйГлавныйУзел <> Неопределено Тогда
		ЭтаФорма.НовыйПланОбмена = НовыйГлавныйУзел.Метаданные().Представление();
	Иначе
		ЭтаФорма.НовыйПланОбмена = Неопределено;
	КонецЕсли; 
	ЭлементыФормы.ПодключитьсяКГлавномуУзлу.Доступность = НовыйГлавныйУзел <> Неопределено;

КонецПроцедуры

Процедура ПриОткрытии()
	
	ОбновитьТекущийГлавныйУзел();
	ЭтаФорма.НовыйГлавныйУзел = ирОбщий.ВосстановитьЗначениеЛкс("ирРедакторИзмененийНаУзлах.НовыйГлавныйУзел");
	Если НовыйГлавныйУзел <> Неопределено Тогда
		ЭтаФорма.НовыйПланОбмена = НовыйГлавныйУзел.Метаданные().Представление();
	КонецЕсли;
	ЭтаФорма.УстановитьВНовыйГлавныйУзел = Истина;
	
КонецПроцедуры

Процедура ОбновитьТекущийГлавныйУзел()
	
	ЭтаФорма.ТекущийГлавныйУзел = ПланыОбмена.ГлавныйУзел();
	Если ТекущийГлавныйУзел <> Неопределено Тогда
		ЭтаФорма.ТекущийПланОбмена = ТекущийГлавныйУзел.Метаданные().Представление();
	Иначе
		ЭтаФорма.ТекущийПланОбмена = Неопределено;
	КонецЕсли;
	ЭлементыФормы.ОтключитьсяОтГлавногоУзла.Доступность = ТекущийГлавныйУзел <> Неопределено;

КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирОбщий.СохранитьЗначениеЛкс("ирРедакторИзмененийНаУзлах.НовыйГлавныйУзел", ЭтаФорма.НовыйГлавныйУзел);
	
КонецПроцедуры

Процедура ПодключитьсяКГлавномуУзлуНажатие(Элемент)
	
	ПланыОбмена.УстановитьГлавныйУзел(НовыйГлавныйУзел);
	ОбновитьТекущийГлавныйУзел();

КонецПроцедуры

Процедура ОтключитьсяОтГлавногоУзлаНажатие(Элемент)
	
	Если УстановитьВНовыйГлавныйУзел Тогда
		ирОбщий.ИнтерактивноЗаписатьВЭлементУправленияЛкс(ЭлементыФормы.НовыйГлавныйУзел, ТекущийГлавныйУзел);
	КонецЕсли; 
	ПланыОбмена.УстановитьГлавныйУзел(Неопределено);
	ОбновитьТекущийГлавныйУзел();
	
КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	ПланыОбменаСРИБ = Новый Массив;
	Для Каждого МетаПланОбмена Из Метаданные.ПланыОбмена Цикл
		Если МетаПланОбмена.РаспределеннаяИнформационнаяБаза Тогда
			ПланыОбменаСРИБ.Добавить(ирОбщий.ПолучитьТипИзМетаданныхЛкс(МетаПланОбмена.ПолноеИмя()));
		КонецЕсли; 
	КонецЦикла;
	Если ПланыОбменаСРИБ.Количество() = 0 Тогда
		Сообщить("В конфигурации не обнаружено планов обмена РИБ");
		Отказ = Истина;
		Возврат;
	КонецЕсли; 
	ЭлементыФормы.НовыйГлавныйУзел.ОграничениеТипа = Новый ОписаниеТипов(ПланыОбменаСРИБ);
	ЭтаФорма.НовыйГлавныйУзел = ЭлементыФормы.НовыйГлавныйУзел.ОграничениеТипа.ПривестиЗначение(НовыйГлавныйУзел);

КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирОбщий.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирРедакторИзмененийНаУзлах.Форма.УправлениеГлавнымУзлом");

