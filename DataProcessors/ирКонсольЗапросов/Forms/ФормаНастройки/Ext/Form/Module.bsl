﻿// Управляет доступностью элементов управления
//
// Параметры:
//	Нет.
//
Процедура вУправлениеДиалогом()

	ЭлементыФормы.НадписьФрмИнтервалАвтосохранения.Доступность = фрмАвтосохранениеТекущегоФайла;
	ЭлементыФормы.ФрмИнтервалАвтосохранения.Доступность = фрмАвтосохранениеТекущегоФайла;

КонецПроцедуры // УправлениеДиалогом()

// Обработчик изменения флажка автосохранения
//
Процедура ИспользоватьАвтосохранениеПриИзменении(Элемент)

	вУправлениеДиалогом();

КонецПроцедуры // ИспользоватьАвтосохранениеПриИзменении()

// Обработчик нажатия кнопки ОК
//
Процедура КнопкаОКНажатие(Элемент)

	ЭтотОбъект.АвтосохранениеТекущегоФайла = фрмАвтосохранениеТекущегоФайла;
	ЭтотОбъект.АвтосохранениеФайлаВосстановления = фрмАвтосохранениеФайлаВосстановления;
	ЭтотОбъект.ИнтервалАвтосохранения = фрмИнтервалАвтосохранения;
	ЭтотОбъект.ВключатьДеревоЗапросаПриОтладке = фрмВключатьДеревоЗапросаПриОтладке;
	Закрыть();

КонецПроцедуры // КнопкаОКНажатие()

// Обработчик события перед открытием формы
//
Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)

	ФрмАвтосохранениеТекущегоФайла = ЭтотОбъект.АвтосохранениеТекущегоФайла;
	ФрмАвтосохранениеФайлаВосстановления = ЭтотОбъект.АвтосохранениеФайлаВосстановления;
	фрмИнтервалАвтосохранения = ЭтотОбъект.ИнтервалАвтосохранения;
	фрмВключатьДеревоЗапросаПриОтладке = ЭтотОбъект.ВключатьДеревоЗапросаПриОтладке;
	вУправлениеДиалогом();

КонецПроцедуры // ПередОткрытием()

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирКонсольЗапросов.Форма.ФормаНастройки");

СписокВыбора = ЭлементыФормы.ФрмИнтервалАвтосохранения.СписокВыбора;
СписокВыбора.Добавить(5);
СписокВыбора.Добавить(10);
СписокВыбора.Добавить(30);
СписокВыбора.Добавить(60);

ФрмИспользоватьАвтосохранениеФайлаВосстановления = Истина;