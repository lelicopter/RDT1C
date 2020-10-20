﻿Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	Отказ = Истина;
	ФормаОбработки = ирОбщий.ПолучитьФормуЛкс("Обработка.ирУдалениеОбъектовСКонтролемСсылок.Форма");
	КопияСтрокиДляОбработки = СтрокиДляОбработки.Скопировать(Новый Структура(мИмяКолонкиПометки, Истина));
	Объекты = КопияСтрокиДляОбработки.ВыгрузитьКолонку("Ссылка");
	ФормаОбработки.ДобавитьМассивОбъектовВУдаляемыеОбъекты(Объекты);
	ФормаОбработки.Открыть();

КонецПроцедуры // ПередОткрытием()

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирОбщий.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирПодборИОбработкаОбъектов.Форма.УдалитьСКонтролемСсылок");


