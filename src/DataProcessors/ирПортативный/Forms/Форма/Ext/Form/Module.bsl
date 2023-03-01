﻿Перем мСоответствиеРасположенийОкна Экспорт;
Перем ПриЗакрытииВызыватьДеструктор;
Перем ЗапретВнешнегоСобытия;

// переоткрытие формы обработки
Процедура ПереоткрытьФорму(ЦелеваяФорма) Экспорт
	
	ПриЗакрытииВызыватьДеструктор = Ложь;
	ЦелеваяФорма.Закрыть();
	ЭтотОбъект.ПолучитьФорму().Открыть();
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	Если ИмяСобытия = "ирПолучитьБазовуюФорму" Тогда
		Параметр.Вставить("ирПортативный", ирПортативный);
	КонецЕсли; 
	Если Не Открыта() Тогда
		Возврат;
	КонецЕсли; 
	
КонецПроцедуры

// перед открытием формы
Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирПортативный.Форма.Форма"); // Нельзя выполнять в разделе инциализации, т.к. будет рекурсия
	ПрочитатьСписокИнструментов();
	Отказ = мНеПодключеныОбработки = Истина;
	
	//каждый раз будем сохранять с новым ключом, чтобы настройки не смогли восстановиться при следующим открытии
	КлючСохраненияПоложенияОкна = Новый УникальныйИдентификатор;
	
	РазмерХ = 24;
	РазмерУ = 726;
	ШиринаПанели = 25;
	
	Если ЭтаФорма.ПоложениеПрикрепленногоОкна = ВариантПрикрепленияОкна.Верх ИЛИ ЭтаФорма.ПоложениеПрикрепленногоОкна = ВариантПрикрепленияОкна.Низ Тогда
		ЭлементыФормы.Удалить(ЭлементыФормы.КоманднаяПанельПравоЛево);
		КоманднаяПанель = ЭлементыФормы.КоманднаяПанельВерхНиз;
		ЭтаФорма.Высота = ШиринаПанели;
		КоманднаяПанель.Ширина = ЭтаФорма.Ширина - 10;
	Иначе
		ЭлементыФормы.Удалить(ЭлементыФормы.КоманднаяПанельВерхНиз);
		КоманднаяПанель = ЭлементыФормы.КоманднаяПанельПравоЛево;
		ЭтаФорма.Ширина = ШиринаПанели;
		КоманднаяПанель.Высота = ЭтаФорма.Высота - 10;
	КонецЕсли;	
	
	// заполним панель кнопками
	КоманднаяПанель.Лево = 0;
	КоманднаяПанель.Верх = 0;
	МассивКнопокАвтозапуска = Новый Массив;
	ЗаполнитьКнопкиПанели(КоманднаяПанель, МассивКнопокАвтозапуска);
	Если ПараметрТолькоОткрытьНастройки Тогда
		ОткрытьФормуНастроек();
		Отказ = Истина;
	КонецЕсли; 

	Если Не Отказ Тогда
		// автозапуск
		Для Каждого Кнопка Из МассивКнопокАвтозапуска Цикл
			ПриНажатииКнопкиОбработки(Кнопка);
		КонецЦикла;
	КонецЕсли;
	ирКлиент.ПроверитьЗакрытьФормуПриОтказеЛкс(ЭтаФорма, Отказ);
	
КонецПроцедуры

// закрытие формы
Процедура ПриЗакрытии()
	
	ирКлиент.Форма_ПриЗакрытииЛкс(ЭтаФорма);
	Если ПриЗакрытииВызыватьДеструктор Тогда
		Деструктор();
	КонецЕсли;
	
КонецПроцедуры

// заполнение панели кнопками
Процедура ЗаполнитьКнопкиПанели(ПанельКнопок, МассивКнопокАвтозапуска = Неопределено)
	
	ПереданМассивАвтозапуска = (МассивКнопокАвтозапуска <> Неопределено);
	ПанельКнопок.Видимость = Ложь; // Отключаем видимость командной панели на время обновления кнопок
	МассивКнопок = Новый Массив;
	Для Каждого Кнопка Из ПанельКнопок.Кнопки Цикл
		ИмяКнопки = Кнопка.Имя;
		Если Найти(ИмяКнопки,"Кнопка_") > 0 ИЛИ Найти(ИмяКнопки, "Кнопка_Разделитель") > 0 Тогда
			МассивКнопок.Добавить(Кнопка);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Кнопка Из МассивКнопок Цикл
		ПанельКнопок.Кнопки.Удалить(Кнопка);
	КонецЦикла;
	
	Индекс = 0;
	Для Каждого Строка Из СписокИнструментов Цикл
		ПолноеИмя = Строка.ПолноеИмя;
		Автозапуск = Строка.Автозапуск;
		Если НЕ Строка.Видимость Тогда
			Продолжить;
		КонецЕсли;
		// разделитель
		Если ПолноеИмя = "Разделитель" Тогда
			ИмяКнопки = "Кнопка_Разделитель"+(Индекс+1);
			ТипКнопки = ТипКнопкиКоманднойПанели.Разделитель;
			НоваяКнопка = ПанельКнопок.Кнопки.Вставить(Индекс,ИмяКнопки,ТипКнопки);
			Индекс = Индекс + 1;
		// произвольная подключаемая обработка	
		Иначе	
			ИмяКнопки = "Кнопка_" + XMLСтрока(СписокИнструментов.Индекс(Строка));
			ТипКнопки = ТипКнопкиКоманднойПанели.Действие;
			Действие = Новый Действие("ПриНажатииКнопкиОбработки");
			НоваяКнопка = ПанельКнопок.Кнопки.Вставить(Индекс, ИмяКнопки, ТипКнопки,, Действие);
			НоваяКнопка.Текст = Строка.Синоним;
			НоваяКнопка.Картинка = ирКэш.КартинкаПоИмениЛкс(Строка.ИмяКартинки);
			Если НоваяКнопка.Картинка.Вид = ВидКартинки.Пустая Тогда
				//КартинкаКнопки = БиблиотекаКартинок.Картинка; // В 8.2.13 такой картинки нет;
				НоваяКнопка.Картинка = БиблиотекаКартинок.Справка;
			КонецЕсли; 
			НоваяКнопка.Отображение = ОтображениеКнопкиКоманднойПанели.Картинка;
			НоваяКнопка.Подсказка = Строка.Синоним;
			НоваяКнопка.Пояснение = НоваяКнопка.Подсказка;
			Индекс = Индекс + 1;
			// при необходимости осуществим автозапуск обработки
			Если Автозапуск И ПереданМассивАвтозапуска Тогда
				МассивКнопокАвтозапуска.Добавить(НоваяКнопка);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	ПанельКнопок.Видимость = Истина;
	
КонецПроцедуры
	
// обработчик нажатия кнопки
Процедура ПриНажатииКнопкиОбработки(Кнопка)
	
	ИндексМодуля = СтрЗаменить(Кнопка.Имя, "Кнопка_", "");
	ИндексМодуля = Число(ИндексМодуля);
	СтрокаИнструмента = СписокИнструментов[ИндексМодуля];
	ОткрытьИнструмент(СтрокаИнструмента);
	
КонецПроцедуры	

Процедура ОткрытьИнструмент(СтрокаИнструмента) Экспорт
	
	Если ЗначениеЗаполнено(СтрокаИнструмента.Команда) Тогда
		Выполнить(СтрокаИнструмента.Команда + "()");
	Иначе
		ИмяВыбраннойФормы = ирКлиент.ИмяФормыИзСтрокиИнструментаЛкс(СтрокаИнструмента);
		Если ирОбщий.СтрНачинаетсяСЛкс(ИмяВыбраннойФормы, "Обработка.ирПлатформа.") Тогда
			Форма = ирКэш.Получить().ПолучитьФорму(ирОбщий.ПоследнийФрагментЛкс(ИмяВыбраннойФормы));
		Иначе
			Форма = ирКлиент.ПолучитьФормуЛкс(ИмяВыбраннойФормы,,,,, ирКэш.ЛиПортативныйРежимЛкс());
		КонецЕсли; 
		Если Форма = Неопределено Тогда
			Возврат;
		КонецЕсли; 
		Форма.Открыть();
	КонецЕсли; 

КонецПроцедуры

// сервисные кнопки
Процедура ПриНажатииСервиснойКнопки(Кнопка)
	
	ИмяКнопки = Кнопка.Имя;
	Если ИмяКнопки = "НастройкиИнструментов" Тогда
		ОткрытьФормуНастроек();
	ИначеЕсли ИмяКнопки = "ОПодсистеме" Тогда
		ирКлиент.ОткрытьСправкуПоПодсистемеЛкс(); 
	ИначеЕсли ИмяКнопки = "Закрыть" Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОткрытьФормуНастроек()
	
	ФормаНастроек = ПолучитьФорму("ФормаНастроек");
	Если Не Открыта() Тогда
		ФормаНастроек.Открыть();
	Иначе
		Если ФормаНастроек.Открыта() Тогда
			ФормаНастроек.Закрыть();
		КонецЕсли; 
		Если ФормаНастроек.Открыта() Тогда
			Возврат;
		КонецЕсли; 
		РезультатФормы = ФормаНастроек.ОткрытьМодально();
		Если РезультатФормы = Истина Тогда
			// изменение положения окна (придется переоткрыть форму)
			Если ЭтаФорма.ПоложениеПрикрепленногоОкна <> мСоответствиеРасположенийОкна[РасположениеПанелиЗапуска] Тогда
				ПереоткрытьФорму(ЭтаФорма);
				Возврат;
			КонецЕсли;
			// перезаполнение кнопок
			Для Каждого ЭлементФормы Из ЭлементыФормы Цикл
				ИмяЭлемента = ЭлементФормы.Имя;
				Если Найти(ИмяЭлемента,"КоманднаяПанельПравоЛево") = 0 И Найти(ИмяЭлемента,"КоманднаяПанельВерхНиз") = 0 Тогда
					Продолжить;
				КонецЕсли;
				ПанельКнопок = ЭлементФормы;
			КонецЦикла;
			ЗаполнитьКнопкиПанели(ПанельКнопок);
		КонецЕсли;
	КонецЕсли; 
	
КонецПроцедуры

// параметры расположения формы панели кнопок
Процедура НастроитьПараметрыОткрытияФормы()
	
	ЭтаФорма.ПоложениеПрикрепленногоОкна = мСоответствиеРасположенийОкна[РасположениеПанелиЗапуска];
	
КонецПроцедуры                   

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
		Структура = Новый Структура("Ответ", Ложь);
		ирКлиент.ОповеститьФормыПодсистемыЛкс("ЕстьОткрытыеФормыИнструментовРазработчика", Структура);
		Оповестить("ЕстьОткрытыеФормыИнструментовРазработчика", Структура); // Пока не все формы инструментов региструют себя в списке открытых форм
		Если Структура.Ответ Тогда
			Ответ = Вопрос("Перед закрытием основной формы инструментов разработчика будут закрыты формы всех инструментов. Продолжить?", РежимДиалогаВопрос.ОКОтмена);
			Структура = Новый Структура("Отказ", Ложь);
			Если Ответ = КодВозвратаДиалога.ОК Тогда
				ирКлиент.ОповеститьФормыПодсистемыЛкс("ЗакрытьВсеФормыИнструментовРазработчика", Структура);
				ирКлиент.ОповеститьФормыПодсистемыЛкс("ЗакрытьВсеФормыИнструментовРазработчика", Структура); // Второй проход нужен для двух шагового закрытия форм, например КонсольКода+ВызовМетода
				ирКэш.ОткрытыеФормыВсеЛкс().Очистить();
				Оповестить("ЗакрытьВсеФормыИнструментовРазработчика", Структура);
			Иначе
				Структура.Отказ = Истина;
			КонецЕсли;
			Отказ = Структура.Отказ;
		КонецЕсли;
	ИначеЕсли ирКэш.ЛиЭтоРасширениеКонфигурацииЛкс() Тогда
		// Надоедливый вопрос. Пока не придумал способ как задавать его только при прямом закрытии пользователем.
		//Ответ = Вопрос("Закрытие основной формы инструментов разработчика сделает невозможным ее повторное открытие в текущем сеансе. Продолжить?", РежимДиалогаВопрос.ОКОтмена,, КодВозвратаДиалога.Отмена);
		//Структура = Новый Структура("Отказ", Ложь);
		//Если Ответ <> КодВозвратаДиалога.ОК Тогда
		//	Отказ = Истина;
		//КонецЕсли;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	// Здесь нельзя вызывать общий обработчик, т.к. он отключит обработчик оповещения, через который эта форма обнаруживается всеми объектами в портативном варианте
	//ирКлиент.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ирКлиент.ДобавитьВСписокОткрытыхФормЛкс(ЭтаФорма);
	
	Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
		ирОбщий.ОбновитьТекстПослеМаркераВСтрокеЛкс(ЭтаФорма.Заголовок,, мВерсия);
	Иначе
		ЭтаФорма.Заголовок = Метаданные.Подсистемы.ИнструментыРазработчикаTormozit.Синоним;
		УстановитьДействие("ВнешнееСобытие", Неопределено);
	КонецЕсли; 
	ирКлиент.УстановитьПрикреплениеФормыВУправляемомПриложенииЛкс(Этаформа);
	ОбработатьПараметрЗапускаДляВсехРежимовЛкс();
	
КонецПроцедуры

Процедура ПриПовторномОткрытии(СтандартнаяОбработка)
	
	Если ПараметрТолькоОткрытьНастройки Тогда
		ОткрытьФормуНастроек();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	Если ЗапретВнешнегоСобытия = Истина Тогда
		Возврат;
	КонецЕсли; 
	Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
		ЗапретВнешнегоСобытия = Истина;
		Попытка
			ВнешнееСобытиеЛкс(Источник, Событие, Данные);
		Исключение
			ЗапретВнешнегоСобытия = Ложь;
			ВызватьИсключение;
		КонецПопытки; 
		ЗапретВнешнегоСобытия = Ложь;
	КонецЕсли; 

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирКлиент.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

ПриЗакрытииВызыватьДеструктор = Истина;

// соответствие расположений окна
мСоответствиеРасположенийОкна = Новый Соответствие;
мСоответствиеРасположенийОкна.Вставить(0, ВариантПрикрепленияОкна.Верх);
мСоответствиеРасположенийОкна.Вставить(1, ВариантПрикрепленияОкна.Лево);
мСоответствиеРасположенийОкна.Вставить(2, ВариантПрикрепленияОкна.Право);
мСоответствиеРасположенийОкна.Вставить(3, ВариантПрикрепленияОкна.Верх);
мСоответствиеРасположенийОкна.Вставить(4, ВариантПрикрепленияОкна.Низ);
НастроитьПараметрыОткрытияФормы();
