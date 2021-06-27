﻿
Процедура НадписьКакСохранитьНажатие(Элемент)
	
	Форма = ирОбщий.ОткрытьФормуЛкс("Обработка.ирПортативный.Форма.ФормаНастроек");
	Форма.ЭлементыФормы.Панель.ТекущаяСтраница = Форма.ЭлементыФормы.Панель.Страницы.Настройки;
	
КонецПроцедуры

Процедура НадписьФункцииДляОтладкиНажатие(Элемент)
	
	ЗапуститьПриложение("http://" + ирОбщий.АдресОсновногоСайтаЛкс() + "/index/funkcii_dlja_otladki/0-33");
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ирОбщий.Форма_ПриОткрытииЛкс(ЭтаФорма);
	БазоваяФорма = ирОбщий.ПолучитьФормуЛкс("Обработка.ирПортативный.Форма.Форма");
	ЭтаФорма.ШаблонВызова = БазоваяФорма.ПолучитьВычисляемыйКонтекстОтладчика();
	ФункцииРежимаОтладки.Загрузить(ирОбщий.ТаблицаЗначенийИзТабличногоДокументаЛкс(ПолучитьМакет("ФункцииРежимаОтладки")));
	ирОбщий.ЗагрузитьВТаблицуЗначенийЛкс(ирОбщий.ТаблицаЗначенийИзТабличногоДокументаЛкс(ПолучитьМакет("ФункцияОтВарианты")), ФункцияОтВарианты);
	Для Каждого СтрокаФункции Из ФункцииРежимаОтладки Цикл
		СтрокаФункции.Вызов = СтрЗаменить(ирОбщий.ПервыйФрагментЛкс(ШаблонВызова, "()"), "*", СтрокаФункции.Имя) + "(" + СтрокаФункции.ОсновныеПараметры + ")";
	КонецЦикла;
	Для Каждого СтрокаФункции Из ФункцияОтВарианты Цикл
		СтрокаФункции.Вызов = СтрЗаменить(ирОбщий.ПервыйФрагментЛкс(ШаблонВызова, "()"), "*", "От") + "(" + СтрокаФункции.ТипПараметраОбъект + ?(ЗначениеЗаполнено(СтрокаФункции.ОстальныеПараметры), ", " + СтрокаФункции.ОстальныеПараметры, "") + ")";
	КонецЦикла;
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирОбщий.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура ОсновныеДействияФормыОбучающееВидео(Кнопка)
	
	ЗапуститьПриложение("https://youtu.be/-NJJP79TccI");
	
КонецПроцедуры

Процедура НадписьОписаниеНаСайтеНажатие(Элемент)
	ЗапуститьПриложение("http://" + ирОбщий.АдресОсновногоСайтаЛкс() + "/index/funkcii_dlja_otladki/0-33");
КонецПроцедуры

Процедура ФункцииПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	
КонецПроцедуры

Процедура ФункцииПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);

КонецПроцедуры

Процедура ФункцияОтВариантыПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	
КонецПроцедуры

Процедура ФункцияОтВариантыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ДействияФормыПерейтиКОпределениюМетода(Кнопка)
	
	Если Ложь
		Или ирКэш.ЛиПортативныйРежимЛкс() 
		Или ЭлементыФормы.Функции.ТекущаяСтрока = Неопределено 
	Тогда
		Возврат;
	КонецЕсли; 
	ирОбщий.ПерейтиКОпределениюМетодаВКонфигуратореЛкс(ирОбщий.ПервыйФрагментЛкс(ЭлементыФормы.Функции.ТекущаяСтрока.Вызов, "("));
	
КонецПроцедуры

Процедура ПриЗакрытии()
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	ирОбщий.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

ирОбщий.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.ФункцииРежимаОтладки");
