﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ, ВЫЗЫВАЕМЫЕ ИЗ ОБРАБОТЧИКОВ ЭЛЕМЕНТОВ ФОРМЫ

// При октрытии формы
//
Процедура ПриОткрытии()
	
	ирКлиент.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ПолеВводаИмяШаблона = СтрЗаменить(ПолеВводаИмяШаблона, "__", "");
	КаталогСохранения = ПолучитьКаталогНастроекПриложения();
	
КонецПроцедуры

// Реакция на нажатие кнопки ОК
// 
Процедура КнопкаОКНажатие(Элемент)
	
	Если СписокСтандартныхШаблонов.НайтиПоЗначению(ПолеВводаИмяШаблона) <> Неопределено Тогда
		Предупреждение("Заданное имя шаблона совпадает с именем стандартного шаблона. Задайте шаблону уникальное имя.");
		Возврат;
	КонецЕсли;
	Если ПустаяСтрока(ПолеВводаИмяШаблона) Тогда
		Предупреждение("Необходимо задать имя шаблона!");
		Возврат;
	КонецЕсли;
	Закрыть("ОК");
	
КонецПроцедуры

// Реакция на нажатие кнопки Отмена
// 
Процедура КнопкаОтменаНажатие(Элемент)
	
	Закрыть("");
	
КонецПроцедуры

Процедура ДействияФормыСохранитьВФайл(Кнопка)
	
	ВыборФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	ВыборФайла.Фильтр = ирОбщий.ФильтрДляВыбораФайлаЛкс("xml", "Шаблон настройки техножурнала");
	Если Не ВыборФайла.Выбрать() Тогда
		Возврат;
	КонецЕсли;
	ЭтаФорма.Закрыть(ВыборФайла.ПолноеИмяФайла);

КонецПроцедуры

Процедура КаталогСохраненияОткрытие(Элемент, СтандартнаяОбработка)
	
	ЗапуститьПриложение(Элемент.Значение);
	
КонецПроцедуры

Процедура ПриЗакрытии()
	ирКлиент.Форма_ПриЗакрытииЛкс(ЭтаФорма);
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирКлиент.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирКлиент.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирНастройкаТехножурнала.Форма.СохранениеШаблона");
