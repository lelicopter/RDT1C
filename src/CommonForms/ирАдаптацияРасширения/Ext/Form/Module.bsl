﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ирОбщий.ПроверитьЧтоСеансТолстогоКлиентаЛкс() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	Элементы.ФормаВыполнить.Доступность = ирКэш.ЛиЭтоРасширениеКонфигурацииЛкс();
	ЭтаФорма.ОткрыватьАдаптациюПриОбновлении = ХранилищеОбщихНастроек.Загрузить(, "ирАдаптацияРасширения.ОткрыватьАдаптациюПриОбновлении",, ирКэш.ИмяПродукта());
	ИмяПользователяНовое = ХранилищеОбщихНастроек.Загрузить(, "ирАдаптацияРасширения.ИмяПользователя",, ирКэш.ИмяПродукта());
	Если ИмяПользователяНовое = Неопределено Тогда
		СохранитьНастройкиАдаптации(Истина);
	КонецЕсли;
	Если ИмяПользователяНовое <> Неопределено Тогда
		ЭтаФорма.ИмяПользователя = ИмяПользователяНовое;
	Иначе
		ЭтаФорма.ИмяПользователя = ПользователиИнформационнойБазы.ТекущийПользователь().Имя;
	КонецЕсли; 
	ПодключитьОтладкуВнешнихОбработокБСПНовое = ХранилищеОбщихНастроек.Загрузить(, "ирАдаптацияРасширения.ПодключитьОтладкуВнешнихОбработокБСП",, ирКэш.ИмяПродукта());
	Если ПодключитьОтладкуВнешнихОбработокБСПНовое <> Неопределено Тогда
		ЭтаФорма.ПодключитьОтладкуВнешнихОбработокБСП = ПодключитьОтладкуВнешнихОбработокБСПНовое;
	Иначе
		ЭтаФорма.ПодключитьОтладкуВнешнихОбработокБСП = Истина;
	КонецЕсли; 
	ирОбщий.ЗаполнитьСписокАдминистраторовБазыЛкс(Элементы.ИмяПользователя.СписокВыбора);
	Если Параметры.Автооткрытие Тогда
		ирОбщий.СообщитьЛкс("Открыть это окно можно командой ""Адаптация расширения""");
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОперацию(Команда)
	
	ЭтаФорма.ОткрыватьАдаптациюПриОбновлении = Истина;
	СохранитьНастройкиАдаптации();
	Если ирОбщий.АдаптироватьРасширениеЛкс(ИмяПользователя, ПарольПользователя) Тогда 
		Закрыть(Истина);
		ЗавершитьРаботуСистемы(, Истина, ирОбщий.ПараметрыЗапускаСеансаТекущиеЛкс() + " /C" + СтрЗаменить(ПараметрЗапуска, "ОткрытьАдаптациюИР", ""));
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиАдаптации(ПустуюСтруктуру = Ложь)
	
	ХранилищеОбщихНастроек.Сохранить(, "ирАдаптацияРасширения.ОткрыватьАдаптациюПриОбновлении", ОткрыватьАдаптациюПриОбновлении,, ирКэш.ИмяПродукта());
	ХранилищеОбщихНастроек.Сохранить(, "ирАдаптацияРасширения.ИмяПользователя", ИмяПользователя,, ирКэш.ИмяПродукта());
	ХранилищеОбщихНастроек.Сохранить(, "ирАдаптацияРасширения.ПодключитьОтладкуВнешнихОбработокБСП", ПодключитьОтладкуВнешнихОбработокБСП,, ирКэш.ИмяПродукта());

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не ирКэш.ЛиЭтоРасширениеКонфигурацииЛкс() Тогда
		ирОбщий.СообщитьЛкс("Операция доступна только в варианте ""Расширение""");
		//Отказ = Истина;
		//Возврат;
	КонецЕсли;
	#Если ТонкийКлиент Или ВебКлиент Тогда
		Отказ = Истина;
		ОткрытьФорму("Обработка.ирПортативный.Форма.ЗапускСеансаУправляемая");
	#КонецЕсли 
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Попытка
		СохранитьНастройкиАдаптации();
	Исключение
		Если Не ЗавершениеРаботы Тогда
			ВызватьИсключение;
		КонецЕсли; 
	КонецПопытки; 

КонецПроцедуры


