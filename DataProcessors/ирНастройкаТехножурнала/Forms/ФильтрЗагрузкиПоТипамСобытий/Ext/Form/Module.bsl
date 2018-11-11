﻿
Процедура КнопкаОКНажатие(Кнопка)

	Закрыть(ТипыСобытий.Выгрузить(Новый Структура("Пометка", Истина)).ВыгрузитьКолонку("Имя"));
	
КонецПроцедуры


Процедура ДействияФормыТолькоПомеченные(Кнопка)
	
	ЛиТолькоПомеченныеСобытия = Не Кнопка.Пометка;
	ОбновитьОтборТаблицыСобытий();
	
КонецПроцедуры

Процедура ОбновитьОтборТаблицыСобытий()
	
	Если ТипыСобытий.Найти(Истина, "Пометка") = Неопределено Тогда
		ЛиТолькоПомеченныеСобытия = Ложь;
	КонецЕсли; 
	ЭлементыФормы.События.ОтборСтрок.Пометка.Использование = ЛиТолькоПомеченныеСобытия;
	ЭлементыФормы.ДействияФормы.Кнопки.ТолькоПомеченные.Пометка = ЛиТолькоПомеченныеСобытия;
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ЗаполнитьТаблицуТиповСобытий();
	СтрокаВсе = ТипыСобытий.Найти("<ALL>", "Имя");
	ТипыСобытий.Удалить(СтрокаВсе);
	Если НачальноеЗначениеВыбора <> Неопределено Тогда
		Для Каждого ВыбранноеСобытие Из НачальноеЗначениеВыбора Цикл
			СтрокаСобытия = ТипыСобытий.Найти(ВыбранноеСобытие, "Имя");
			Если СтрокаСобытия <> Неопределено Тогда
				СтрокаСобытия.Пометка = Истина;
			КонецЕсли; 
		КонецЦикла;
	КонецЕсли; 
	ОбновитьОтборТаблицыСобытий();
	
КонецПроцедуры

Процедура ДействияФормыУстановитьФлажки(Кнопка)
	
	ирОбщий.ИзменитьПометкиВыделенныхИлиОтобранныхСтрокЛкс(ЭлементыФормы.События, , Истина);
	
КонецПроцедуры


Процедура ДействияФормыСнятьФлажки(Кнопка)
	
	ирОбщий.ИзменитьПометкиВыделенныхИлиОтобранныхСтрокЛкс(ЭлементыФормы.События, , Ложь);

КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирНастройкаТехножурнала.Форма.ФильтрЗагрузкиПоТипамСобытий");
ЛиТолькоПомеченныеСобытия = Истина;
ЭлементыФормы.События.ОтборСтрок.Пометка.Значение = Истина;