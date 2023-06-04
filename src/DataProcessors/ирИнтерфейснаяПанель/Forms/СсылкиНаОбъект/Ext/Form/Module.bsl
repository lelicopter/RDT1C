﻿
Процедура СсылкиНаОбъектПриАктивизацииСтроки(Элемент)
	ирКлиент.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
КонецПроцедуры

Процедура ПриОткрытии()
	ирКлиент.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ирОбщий.ОбновитьТекстПослеМаркераЛкс(ЭтаФорма.Заголовок,, КлючУникальности, ": ");
	СсылкиНаОбъект.Сортировать("ПолноеИмя, ИмяСвойства");
КонецПроцедуры

Процедура ПриЗакрытии()
	ирКлиент.Форма_ПриЗакрытииЛкс(ЭтаФорма);
КонецПроцедуры

Процедура СсылкиНаОбъектВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	ирОбщий.ИсследоватьЛкс(Метаданные.НайтиПоПолномуИмени(ВыбраннаяСтрока.ПолноеИмя),,,,, ВыбраннаяСтрока.ИмяСвойства);
КонецПроцедуры 

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	ирКлиент.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт 
	ирКлиент.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);
КонецПроцедуры 

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	ирКлиент.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
КонецПроцедуры

ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирИнтерфейснаяПанель.Форма.СсылкиНаОбъект");
