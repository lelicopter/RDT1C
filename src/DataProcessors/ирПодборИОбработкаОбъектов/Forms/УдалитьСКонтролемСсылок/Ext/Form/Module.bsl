﻿Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	Отказ = Истина;
	ФормаОбработки = ирКлиент.ПолучитьФормуЛкс("Обработка.ирУдалениеОбъектовСКонтролемСсылок.Форма");
	КопияСтрокиДляОбработки = СтрокиДляОбработки.Скопировать(Новый Структура(мИмяКолонкиПометки, Истина));
	Объекты = КопияСтрокиДляОбработки.ВыгрузитьКолонку("Ссылка");
	ФормаОбработки.ДобавитьМассивОбъектовВУдаляемыеОбъекты(Объекты);
	ФормаОбработки.Открыть();

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирКлиент.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирПодборИОбработкаОбъектов.Форма.УдалитьСКонтролемСсылок");


