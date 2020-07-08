﻿Функция СохраняемаяНастройкаФормы(выхНаименование, выхИменаСвойств) Экспорт 
	выхИменаСвойств = "
	|БезОформления,
	|ВстроитьЗначенияВРасшифровки,
	|ВыбранныйПользовательWindows,
	|ВыводВТаблицуЗначений,
	|ИтогиЧисловыхКолонок,
	|КолонкиЗначений,
	|КолонкиИдентификаторов,
	|КолонкиРазмеров,
	|КолонкиТипов,
	|ОтображатьПустые,
	|ТолькоВыделенныеСтроки";
	Возврат Неопределено;
КонецФункции

Процедура ЗагрузитьНастройкуВФорме(НастройкаФормы, ДопПараметры) Экспорт 
	
	ирОбщий.ЗагрузитьНастройкуФормыЛкс(ЭтаФорма, НастройкаФормы); 
	ОбновитьДоступность();
	
КонецПроцедуры

Процедура ОсновныеДействияФормыСохранитьНастройки(Кнопка)
	
	ирОбщий.ВыбратьИСохранитьНастройкуФормыЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ОсновныеДействияФормыЗагрузитьНастройки(Кнопка)
	
	ирОбщий.ВыбратьИЗагрузитьНастройкуФормыЛкс(ЭтаФорма);

КонецПроцедуры

Процедура КПКолонкиТолькоВключенные(Кнопка)
	
	УстановитьОтборТолькоВключенные(Не Кнопка.Пометка);
	
КонецПроцедуры

Процедура УстановитьОтборТолькоВключенные(НовоеЗначение)
	
	ЭлементыФормы.КПКолонки.Кнопки.ТолькоВключенные.Пометка = НовоеЗначение;
	ЭлементыФормы.КолонкиТабличногоПоля.ОтборСтрок.Пометка.ВидСравнения = ВидСравнения.Равно;
	ЭлементыФормы.КолонкиТабличногоПоля.ОтборСтрок.Пометка.Использование = НовоеЗначение;
	ЭлементыФормы.КолонкиТабличногоПоля.ОтборСтрок.Пометка.Значение = Истина;
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ирОбщий.СоздатьМенеджерСохраненияНастроекФормыЛкс(ЭтаФорма);
	КолонкиТабличногоПоля.Очистить();
	Если ТипЗнч(ТабличноеПоле) = Тип("ТабличноеПоле") Тогда
		КолонкиТП = ТабличноеПоле.Колонки;
		ТекущаяКолонка = ТабличноеПоле.ТекущаяКолонка;
	Иначе
		КолонкиТП = ТабличноеПоле.ПодчиненныеЭлементы;
		ТекущаяКолонка = ТабличноеПоле.ТекущийЭлемент;
	КонецЕсли; 
	ДоступныДанныеПоля = ирОбщий.ДанныеЭлементаФормыЛкс(ТабличноеПоле) <> Неопределено;
	ЭтаФорма.ТолькоВыделенныеСтроки = ТабличноеПоле.ВыделенныеСтроки.Количество() > 1 Или Не ДоступныДанныеПоля;
	ЭлементыФормы.ТолькоВыделенныеСтроки.Доступность = ДоступныДанныеПоля;
	ДобавитьКолонки(КолонкиТП, ТекущаяКолонка);
	ЭлементыФормы.БезОформления.Доступность = ТипЗнч(ТабличноеПоле) = Тип("ТабличноеПоле");
	УстановитьОтборТолькоВключенные(Истина);
	ОбновитьДоступность();

КонецПроцедуры

Процедура ДобавитьКолонки(Знач КолонкиТП, Знач ТекущаяКолонка)
	
	Для Каждого КолонкаТП Из КолонкиТП Цикл
		Если Истина
			И Не КолонкаТП.Видимость 
			И (Ложь
				Или ТипЗнч(КолонкаТП) <> Тип("КолонкаТабличногоПоля")
				Или Не КолонкаТП.ИзменятьВидимость // В управляемой форме нет свойства ИзменятьВидимость
				)
		Тогда
			Продолжить;
		КонецЕсли; 
		Если ТипЗнч(КолонкаТП) = Тип("ГруппаФормы") Тогда
			ДобавитьКолонки(КолонкаТП.ПодчиненныеЭлементы, ТекущаяКолонка);
			Продолжить;
		КонецЕсли; 
		СтрокаКолонки = КолонкиТабличногоПоля.Добавить();
		СтрокаКолонки.Имя = КолонкаТП.Имя;
		Если ТипЗнч(КолонкаТП) = Тип("ПолеФормы") Тогда
			СтрокаКолонки.Заголовок = КолонкаТП.Заголовок;
		Иначе
			СтрокаКолонки.Заголовок = КолонкаТП.ТекстШапки;
		КонецЕсли; 
		СтрокаКолонки.Пометка = КолонкаТП.Видимость;
		СтрокаКолонки.Данные = ирОбщий.ПутьКДаннымКолонкиТабличногоПоляЛкс(ТабличноеПоле, КолонкаТП);
		//СтрокаКолонки.ТипЗначения = 
		Если ТекущаяКолонка = КолонкаТП Тогда
			ЭлементыФормы.КолонкиТабличногоПоля.ТекущаяСтрока = СтрокаКолонки;
		КонецЕсли; 
	КонецЦикла;

КонецПроцедуры

Процедура КПКолонкиСнятьФлажки(Кнопка)
	
	ТекущаяСтрока = ЭлементыФормы.КолонкиТабличногоПоля.ТекущаяСтрока;
	ирОбщий.ИзменитьПометкиВыделенныхИлиОтобранныхСтрокЛкс(ЭлементыФормы.КолонкиТабличногоПоля,, Ложь);
	Если КолонкиТабличногоПоля.Найти(Истина, "Пометка") = Неопределено Тогда
		УстановитьОтборТолькоВключенные(Ложь);
		ЭлементыФормы.КолонкиТабличногоПоля.ТекущаяСтрока = ТекущаяСтрока;
	КонецЕсли; 
	
КонецПроцедуры

Процедура КПКолонкиУстановитьФлажки(Кнопка)
	
	ирОбщий.ИзменитьПометкиВыделенныхИлиОтобранныхСтрокЛкс(ЭлементыФормы.КолонкиТабличногоПоля,, Истина);

КонецПроцедуры

Процедура ОсновныеДействияФормыОК(Кнопка)
	
	Закрыть(Истина);
	
КонецПроцедуры

Процедура БезОформленияПриИзменении(Элемент)
	
	ОбновитьДоступность();
	
КонецПроцедуры

Процедура ОбновитьДоступность()
	
	//ЭлементыФормы.ВыводВТаблицуЗначений.Доступность = БезОформления;
	ЭлементыФормы.КолонкиИдентификаторов.Доступность = БезОформления;
	ЭлементыФормы.КолонкиТипов.Доступность = БезОформления;
	ЭлементыФормы.КолонкиЗначений.Доступность = БезОформления;
	ЭлементыФормы.ОтображатьПустые.Доступность = БезОформления;
	ЭлементыФормы.ИтогиЧисловыхКолонок.Доступность = БезОформления;
	ЭлементыФормы.КолонкиРазмеров.Доступность = БезОформления;
	ЭлементыФормы.ОсновныеДействияФормы.Кнопки.ИсполняемаяКомпоновка.Доступность = БезОформления;
	
КонецПроцедуры

Процедура ОсновныеДействияФормыИсполняемаяКомпоновка(Кнопка)
	
	ирОбщий.ВывестиСтрокиТабличногоПоляЛкс(ТабличноеПоле, ЭтаФорма, Истина);
	
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура КолонкиТабличногоПоляПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)

	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
	
КонецПроцедуры

Процедура КолонкиТабличногоПоляПриИзмененииФлажка(Элемент, Колонка)
	
	ирОбщий.ТабличноеПолеПриИзмененииФлажкаЛкс(Элемент, Колонка);

КонецПроцедуры

Процедура КолонкиТабличногоПоляПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);

КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);

КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.ПараметрыВыводаСтрокТаблицы");
БезОформления = Истина;
КолонкиЗначений = Истина;
ВстроитьЗначенияВРасшифровки = Истина;
