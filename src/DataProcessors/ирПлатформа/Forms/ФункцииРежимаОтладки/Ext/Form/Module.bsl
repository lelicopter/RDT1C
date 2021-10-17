﻿
Процедура НадписьКакСохранитьНажатие(Элемент)
	
	ирОбщий.ОткрытьПанельИнструментовЛкс(Истина, Истина);
	
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
		СтрокаФункции.Вызов = СтрЗаменить(ирОбщий.ПервыйФрагментЛкс(ШаблонВызова, "()"), "*", "От") + "(" + СтрокаФункции.ТипПараметраОбъект + 
			?(ЗначениеЗаполнено(СтрокаФункции.ОстальныеПараметры), ", " + СтрокаФункции.ОстальныеПараметры, "") + ")";
	КонецЦикла;
	Если ирКэш.ЛиЭтоРасширениеКонфигурацииЛкс() Тогда
		ЭлементыФормы.ШаблонВызова.Подсказка = ЭлементыФормы.ШаблонВызова.Подсказка +
			". Вызов через общий модуль необходим, т.к. платформа не позволяет добавлять в расширении конфигурации глобальные серверные модули.";
	КонецЕсли;
	
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

Процедура ФункцииВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	Если Колонка = ЭлементыФормы.Функции.Колонки.Пример Тогда
		Если ирОбщий.СтрНачинаетсяСЛкс(ВыбраннаяСтрока.Пример, "http") Тогда 
			ЗапуститьПриложение(ирОбщий.ПервыйФрагментЛкс(ВыбраннаяСтрока.Пример, " "));
		КонецЕсли; 
	КонецЕсли; 
КонецПроцедуры

Процедура КПВариантыОтНезависимыйСоздательСнимка(Кнопка)
	
	ТекущаяСтрока = ЭлементыФормы.ФункцияОтВарианты.ТекущаяСтрока;
	Если ТекущаяСтрока.ТипПараметраОбъект = "Запрос" Тогда
		#Если Сервер И Не Сервер Тогда
			Запрос = Новый Запрос;
		#КонецЕсли
		Текст = """Текст,Параметры,Таблицы"",Запрос.Текст,Запрос.Параметры";
		Если ирКэш.ДоступныТаблицыМенеджераВременныхТаблицЛкс() Тогда
			ТекстКлючей = "";
			ТекстЗначений = "";
			РазделительКлючей = "+"",""+";
			//// В окне "Вычислить выражение" макс. длина строки - 255
			//Для Счетчик = 1 По 5 Цикл 
			//	ТекстКлючей = ТекстКлючей + ирОбщий.СтрШаблонЛкс(РазделительКлючей + "?(Запрос.МенеджерВременныхТаблиц.Таблицы.Количество()>%1, Запрос.МенеджерВременныхТаблиц.Таблицы[%1].ПолноеИмя, ""_%1"")", Счетчик - 1);
			//	ТекстЗначений = ТекстЗначений + ирОбщий.СтрШаблонЛкс(",?(Запрос.МенеджерВременныхТаблиц.Таблицы.Количество()>%1, Запрос.МенеджерВременныхТаблиц.Таблицы[%1].ПолучитьДанные(), 0)", Счетчик - 1);
			//КонецЦикла;
			Для Счетчик = 1 По 1 Цикл
				ТекстКлючей = ТекстКлючей + ирОбщий.СтрШаблонЛкс(РазделительКлючей + "Запрос.МенеджерВременныхТаблиц.Таблицы[%1].ПолноеИмя", Счетчик - 1);
				ТекстЗначений = ТекстЗначений + ирОбщий.СтрШаблонЛкс(",Запрос.МенеджерВременныхТаблиц.Таблицы[%1].ПолучитьДанные()", Счетчик - 1);
			КонецЦикла;
			Текст = Текст + ",Новый Структура(" + Сред(ТекстКлючей, СтрДлина(РазделительКлючей) + 1) + ТекстЗначений + ")";
		КонецЕсли;
		Текст = "ЗначениеВСтрокуВнутр(Новый Структура(" + Текст + "))";
	КонецЕсли;
	ирОбщий.ОткрытьТекстЛкс(Текст, "Выражение независимого создания снимка " + ТекущаяСтрока.ТипПараметраОбъект);
	
КонецПроцедуры

ирОбщий.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.ФункцииРежимаОтладки");
