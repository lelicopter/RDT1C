﻿Перем Колонки;

Процедура ПриОткрытии()
	
	Если КлючУникальности = "Автотест" Тогда
		Возврат;
	КонецЕсли;
	ирОбщий.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ТабличноеПоле = КлючУникальности;
	ирОбщий.ОбновитьТекстПослеМаркераВСтрокеЛкс(ЭтаФорма.Заголовок, , ТабличноеПоле.Имя, ": ");
	ОбновитьСоставСвойств();
	Если Не ЗначениеЗаполнено(ИмяТаблицыБД) Тогда
		ЭлементыФормы.СвязиИПараметрыВыбора.Доступность = Ложь;
		ЭлементыФормы.ДействияФормы.Кнопки.ИсследоватьМетаданные.Доступность = Ложь;
		ЭлементыФормы.ДействияФормы.Кнопки.АнализПравДоступа.Доступность = Ложь;
	КонецЕсли; 
	ЭлементыФормы.СвойстваСтроки.ТолькоПросмотр = ТолькоПросмотр; // Чтобы открытие ссылок из ячеек работало
	ирОбщий.УстановитьПрикреплениеФормыВУправляемомПриложенииЛкс(Этаформа);
	
КонецПроцедуры

Процедура ОбновитьСоставСвойств()
	
	ТабличноеПоле = КлючУникальности;
	СвойстваСтроки.Очистить();
	Если ТипЗнч(ТабличноеПоле) = Тип("ТабличноеПоле") Тогда
		Колонки = ТабличноеПоле.Колонки;
		КолонкиДанных = ТабличноеПоле.Значение.Колонки;
	Иначе
		Колонки = ТабличноеПоле.ПодчиненныеЭлементы;
		//КолонкиДанных = ирСервер.ПолучитьТаблицуДочернихРеквизитовЛкс(ТабличноеПоле, Истина);
	КонецЕсли; 
	Для Каждого Колонка Из Колонки Цикл
		ИмяКолонкиДанных = ирОбщий.ПутьКДаннымКолонкиТабличногоПоляЛкс(ТабличноеПоле, Колонка);
		Если Не ЗначениеЗаполнено(ИмяКолонкиДанных) Тогда
			Продолжить;
		КонецЕсли; 
		СтрокаСвойства = СвойстваСтроки.Добавить();
		СтрокаСвойства.Имя = Колонка.Имя;
		СтрокаСвойства.Данные = ИмяКолонкиДанных;
		Если ТипЗнч(Колонка) = Тип("КолонкаТабличногоПоля") Тогда
			СтрокаСвойства.Представление = Колонка.ТекстШапки;
			КолонкаДанных = КолонкиДанных[СтрокаСвойства.Данные];
			СтрокаСвойства.ОписаниеТипов = КолонкаДанных.ТипЗначения;
		Иначе
			СтрокаСвойства.Представление = Колонка.Заголовок;
			СтрокаСвойства.ОписаниеТипов = ирОбщий.ТипЗначенияЭлементаФормыЛкс(Колонка, Ложь);
		КонецЕсли; 
		СтрокаСвойства.Порядок = СвойстваСтроки.Количество();
	КонецЦикла;
	//СвойстваСтроки.Сортировать("Представление");
	ЗагрузитьДанныеСтроки(, Ложь);

КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	ирОбщий.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 
	Если Источник = КлючУникальности Тогда 
		Если ИмяСобытия = "ПриАктивизацииСтроки" Тогда 
			ЗагрузитьДанныеСтроки();
			ПодключитьОбработчикОжидания("ЗагрузитьДанныеСтрокиБезПараметров", 0.1, Истина); // Чтобы при копировании строки содержимое сразу отображалось тут
		ИначеЕсли ИмяСобытия = "ПриИзмененииЯчейки" Тогда
			ЗагрузитьДанныеСтроки(Истина);
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

Процедура ЗагрузитьДанныеСтрокиБезПараметров()
	
	ЗагрузитьДанныеСтроки();
	
КонецПроцедуры

Процедура ЗагрузитьДанныеСтроки(УстановитьТекущуюСтроку = Ложь, ПроверитьНеизменностьКолонок = Истина)
	
	ТабличноеПоле = КлючУникальности;
	Если ПроверитьНеизменностьКолонок Тогда
		Если ТипЗнч(ТабличноеПоле) = Тип("ТабличноеПоле") Тогда
			Для Каждого СтрокаСвойства Из СвойстваСтроки Цикл
				Если ТабличноеПоле.Значение.Колонки.Найти(СтрокаСвойства.Имя) = Неопределено Тогда
					// Изменились колонки источника
					ОбновитьСоставСвойств();
					Возврат;
				КонецЕсли; 
			КонецЦикла; 
		КонецЕсли; 
	КонецЕсли; 
	//ЭлементыФормы.СвойстваСтроки.ОбновитьСтроки();
	Если Истина
		И ТипЗнч(ТабличноеПоле) = Тип("ТабличноеПоле")
		И ТабличноеПоле.ТекущаяСтрока <> Неопределено 
	Тогда
		ОформлениеСтроки = ТабличноеПоле.ОформлениеСтроки(ТабличноеПоле.ТекущаяСтрока);
	КонецЕсли; 
	ТекущиеДанные = ирОбщий.ДанныеСтрокиТабличногоПоляЛкс(ТабличноеПоле);
	Для Каждого СтрокаСвойства Из СвойстваСтроки Цикл
		Если ТекущиеДанные = Неопределено Тогда
			СтрокаСвойства.Значение = СтрокаСвойства.ОписаниеТипов.ПривестиЗначение(Неопределено);
			СтрокаСвойства.ТолькоПросмотр = Истина;
		Иначе
			СтрокаСвойства.Значение = ТекущиеДанные[СтрокаСвойства.Данные];
			КолонкаТабличногоПоля = Колонки[СтрокаСвойства.Имя];
			Попытка
				ЯчейкаОформления = ОформлениеСтроки.Ячейки[СтрокаСвойства.Имя];
			Исключение
				ЯчейкаОформления = Неопределено; // Это новая строка таблицы
			КонецПопытки;
			СтрокаСвойства.ТолькоПросмотр = Ложь
				Или ТабличноеПоле.ТолькоПросмотр
				Или (ВладелецФормы.ТолькоПросмотр И ТабличноеПоле.ИзменяетДанные)
				Или КолонкаТабличногоПоля.ТолькоПросмотр
				Или Не КолонкаТабличногоПоля.Доступность
				Или (Истина
					И ЯчейкаОформления <> Неопределено
					И ЯчейкаОформления.ТолькоПросмотр);
		КонецЕсли; 
		СтрокаСвойства.ПредставлениеЗначения = СтрокаСвойства.Значение;
		ирОбщий.ОбновитьТипЗначенияВСтрокеТаблицыЛкс(СтрокаСвойства);
	КонецЦикла;
	Если УстановитьТекущуюСтроку Тогда
		ДействияФормыТекущаяКолонкаИсточника();
	КонецЕсли; 
	
КонецПроцедуры

Процедура СвойстваСтрокиПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки, ЭлементыФормы.ДействияФормы.Кнопки.Идентификаторы, "ПредставлениеЗначения",
		Новый Структура("ПредставлениеЗначения", "Значение"));
	
КонецПроцедуры

Процедура СвойстваСтрокиПредставлениеЗначенияПриИзменении(Элемент)
	
	ЭлементыФормы.СвойстваСтроки.ТекущиеДанные.Значение = Элемент.Значение;
	ОбновитьПредставлениеИТипЗначенияВСтроке();
	
КонецПроцедуры

// Фактический обработчик ПриИзменени
Процедура ОбновитьПредставлениеИТипЗначенияВСтроке(СтрокаТаблицы = Неопределено)
	
	Если СтрокаТаблицы = Неопределено Тогда
		СтрокаТаблицы = ЭлементыФормы.СвойстваСтроки.ТекущиеДанные;
	КонецЕсли; 
	СтрокаТаблицы.ПредставлениеЗначения = СтрокаТаблицы.Значение;
	ирОбщий.ОбновитьТипЗначенияВСтрокеТаблицыЛкс(СтрокаТаблицы);
	ДействияФормыТекущаяСтрока();
	
КонецПроцедуры

Процедура СвойстваСтрокиПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	Если ЭлементыФормы.СвойстваСтроки.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ЭлементыФормы.СвойстваСтроки.Колонки.ПредставлениеЗначения.ТолькоПросмотр = ЭлементыФормы.СвойстваСтроки.ТекущаяСтрока.ТолькоПросмотр;
	
КонецПроцедуры

Процедура ДействияФормыТекущаяКолонкаИсточника(Кнопка = Неопределено)
	
	ТабличноеПоле = КлючУникальности;
	ИмяКолонкиДанных = ирОбщий.ПутьКДаннымКолонкиТабличногоПоляЛкс(ТабличноеПоле);
	Если ЗначениеЗаполнено(ИмяКолонкиДанных) Тогда
		ЭлементыФормы.СвойстваСтроки.ТекущаяСтрока = СвойстваСтроки.Найти(ИмяКолонкиДанных, "Данные");
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДействияФормыТекущаяСтрока(Кнопка = Неопределено)
	
	ТабличноеПоле = КлючУникальности;
	ТекущаяСтрокаИсточника = ирОбщий.ДанныеСтрокиТабличногоПоляЛкс(ТабличноеПоле);
	Если ТабличноеПоле = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	Если ТекущаяСтрокаИсточника = Неопределено Тогда
		ЗагрузитьДанныеСтроки();
		Возврат;
	КонецЕсли; 
	ТекущаяСтрокаСвойства = ЭлементыФормы.СвойстваСтроки.ТекущаяСтрока;
	Если Колонки[ТекущаяСтрокаСвойства.Имя].Видимость Тогда
		КолонкаИсточника = Колонки.Найти(ТекущаяСтрокаСвойства.Имя);
		Если ТипЗнч(ТабличноеПоле) = Тип("ТабличноеПоле") Тогда 
			ТабличноеПоле.ТекущаяКолонка = КолонкаИсточника;
		Иначе
			ТабличноеПоле.ТекущийЭлемент = КолонкаИсточника;
		КонецЕсли;
	КонецЕсли; 
	ТекущаяСтрокаИсточника[ТекущаяСтрокаСвойства.Данные] = ТекущаяСтрокаСвойства.Значение;
	Если ТабличноеПоле.ИзменяетДанные Тогда
		ВладелецФормы.Модифицированность = Истина;
	КонецЕсли; 
	
КонецПроцедуры

Процедура СвойстваСтрокиПредставлениеЗначенияНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ТабличноеПоле = КлючУникальности;
	Если СвязиИПараметрыВыбора Тогда
		Если ЗначениеЗаполнено(ИмяТаблицыБД) Тогда
			ПоляТаблицыБД = ирКэш.ПоляТаблицыБДЛкс(ИмяТаблицыБД);
			ИмяПоляТаблицы = ТабличноеПоле.ТекущаяКолонка.Имя;
			МетаРеквизит = ПоляТаблицыБД.Найти(ИмяПоляТаблицы, "Имя").Метаданные;
			СтруктураОтбора = ирОбщий.ПолучитьСтруктуруОтбораПоСвязямИПараметрамВыбораЛкс(ТабличноеПоле.ТекущаяСтрока, МетаРеквизит);
		КонецЕсли; 
	КонецЕсли; 
	ЭлементыФормы.СвойстваСтроки.Колонки.ПредставлениеЗначения.ЭлементУправления.ОграничениеТипа = ЭлементыФормы.СвойстваСтроки.ТекущаяСтрока.ОписаниеТипов;
	Если ирОбщий.ПолеВводаКолонкиРасширенногоЗначения_НачалоВыбораЛкс(ЭтаФорма, ЭлементыФормы.СвойстваСтроки, СтандартнаяОбработка, ЭлементыФормы.СвойстваСтроки.ТекущаяСтрока.Значение, Истина, СтруктураОтбора) Тогда 
		ОбновитьПредставлениеИТипЗначенияВСтроке();
	КонецЕсли; 
	
КонецПроцедуры

Процедура СвойстваСтрокиПредставлениеЗначенияОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	ирОбщий.ПолеВвода_ОкончаниеВводаТекстаЛкс(Элемент, Текст, Значение, СтандартнаяОбработка, ЭлементыФормы.СвойстваСтроки.ТекущаяСтрока.Значение);

КонецПроцедуры

Процедура ПриПовторномОткрытии(СтандартнаяОбработка)
	
	ОбновитьСоставСвойств();

КонецПроцедуры

Процедура СвойстваСтрокиВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если Ложь
		Или Колонка = ЭлементыФормы.СвойстваСтроки.Колонки.Имя
		Или Колонка = ЭлементыФормы.СвойстваСтроки.Колонки.Представление 
	Тогда
		ДействияФормыТекущаяСтрока();
	ИначеЕсли Колонка = ЭлементыФормы.СвойстваСтроки.Колонки.ПредставлениеЗначения Тогда 
		ирОбщий.ЯчейкаТабличногоПоляРасширенногоЗначения_ВыборЛкс(ЭтаФорма, Элемент, СтандартнаяОбработка);
	ИначеЕсли Ложь
		Или Колонка = ЭлементыФормы.СвойстваСтроки.Колонки.ТипЗначения
		Или Колонка = ЭлементыФормы.СвойстваСтроки.Колонки.ИмяТипаЗначения
	Тогда 
		ирОбщий.ОткрытьОбъектМДИзТаблицыСИменамиТиповЛкс(ВыбраннаяСтрока);
	КонецЕсли; 
	
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура СвойстваСтрокиПриИзмененииФлажка(Элемент, Колонка)
	
	ирОбщий.ТабличноеПолеПриИзмененииФлажкаЛкс(ЭтаФорма, Элемент, Колонка);
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирОбщий.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);

КонецПроцедуры

Процедура ДействияФормыИсследовать(Кнопка)
	
	ТекущаяСтрока = ЭлементыФормы.СвойстваСтроки.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	МетаданныеПоля = МетаданныеПоля(ТекущаяСтрока);
	Если МетаданныеПоля = Неопределено Тогда
		МетаданныеПоля = ирОбщий.ОбъектМДПоПолномуИмениТаблицыБДЛкс(ИмяТаблицыБД);
	КонецЕсли; 
	ирОбщий.ОткрытьОбъектМетаданныхЛкс(МетаданныеПоля);
	
КонецПроцедуры

Функция МетаданныеПоля(Знач ТекущаяСтрока = Неопределено)
	
	Если ТекущаяСтрока = Неопределено Тогда
		ТекущаяСтрока = ЭлементыФормы.СвойстваСтроки.ТекущаяСтрока;
	КонецЕсли; 
	ИмяТаблицыБДВсеПоля = ИмяТаблицыБД;
	Если ирОбщий.ЛиКорневойТипРегистраБухгалтерииЛкс(ирОбщий.ТипТаблицыБДЛкс(ИмяТаблицыБД)) Тогда
		ИмяТаблицыБДВсеПоля = ИмяТаблицыБДВсеПоля + ".ДвиженияССубконто";
	КонецЕсли; 
	ПоляТаблицыБД = ирКэш.ПоляТаблицыБДЛкс(ИмяТаблицыБДВсеПоля);
	ПолеТаблицы = ПоляТаблицыБД.Найти(ТекущаяСтрока.Имя);
	МетаданныеПоля = ПолеТаблицы.Метаданные;
	Возврат МетаданныеПоля;

КонецФункции

Процедура ДействияФормыАнализПравДоступа(Кнопка)
	
	Если ЭлементыФормы.СвойстваСтроки.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ПолноеИмяПоляТаблицы = ИмяТаблицыБД + "." + ЭлементыФормы.СвойстваСтроки.ТекущаяСтрока.Имя;
	Форма = ирОбщий.ПолучитьФормуЛкс("Отчет.ирАнализПравДоступа.Форма",,, "" + ПолноеИмяПоляТаблицы);
	Форма.НаборПолей.Добавить(ПолноеИмяПоляТаблицы);
	Форма.ВычислятьФункциональныеОпции = Истина;
	Форма.ПараметрКлючВарианта = "ПоПолямМетаданных";
	Форма.Открыть();
	
КонецПроцедуры

ирОбщий.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.СтрокаТаблицы");
СвойстваСтроки.Колонки.Добавить("Значение");
ЭтаФорма.СвязиИПараметрыВыбора = Истина;
