﻿Перем ПолеТекстаПрограммы;

// @@@.КЛАСС.ПолеТекстаПрограммы
Функция КлсПолеТекстаПрограммыОбновитьКонтекст(Знач Компонента = Неопределено, Знач Кнопка = Неопределено) Экспорт 
КонецФункции

// @@@.КЛАСС.ПолеТекстаПрограммы
Процедура КлсПолеТекстаПрограммыНажатие(Кнопка)
	
	ПолеТекстаПрограммы.Нажатие(Кнопка);
	
КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	Отказ = Истина;
	Сообщить("Эта обработка - класс. Она не предназначена для непосредственного использования.");
	
КонецПроцедуры

Попытка
	Модуль = Вычислить("ирКлиент");
Исключение
	#Если Клиент Тогда
	Контейнер = Новый Структура();
	Оповестить("ирПолучитьБазовуюФорму", Контейнер);
	Модуль = Контейнер.ирПортативный.ОбщийМодульЛкс("ирКлиент");
	#КонецЕсли
КонецПопытки; 
Модуль.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирКлсПолеТекстаПрограммы.Форма.ФормаМакет");
