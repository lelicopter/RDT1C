﻿Перем мВыборкаРезультатаСтрокиТаблицы;

Функция СохраняемаяНастройкаФормы(выхНаименование, выхИменаСвойств) Экспорт 
	выхИменаСвойств = "Реквизит.ВыполнятьНаСервере, Реквизит.КоличествоОбъектовВПорции, Реквизит.КоличествоПотоков, Реквизит.ЛиВсеТипы, Реквизит.ТипыСсылокДляПоиска, Реквизит.ТолькоРегистраторы, Реквизит.УчитыватьВиртуальныеТаблицы, Реквизит.УчитыватьВсеКолонкиТаблицИзменений, Форма.ИмяПредставление";
	Возврат Неопределено;
КонецФункции

Процедура ЗагрузитьНастройкуВФорме(НастройкаФормы, ДопПараметры) Экспорт 
	
	ирОбщий.ЗагрузитьНастройкуФормыЛкс(ЭтаФорма, НастройкаФормы); 
	НастроитьЭлементыФормы();
	ИмяПредставлениеПриИзменении();

КонецПроцедуры

Процедура ПриОткрытии()

	ирОбщий.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ирОбщий.СоздатьМенеджерСохраненияНастроекФормыЛкс(ЭтаФорма);
	НастроитьЭлементыФормы();
	ирОбщий.УстановитьДоступностьВыполненияНаСервереЛкс(ЭтаФорма);
	ирОбщий.НастроитьПоляВводаПараметровПотоковЛкс(ЭтаФорма);
	
КонецПроцедуры 

Процедура БитыеСсылкиВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ирОбщий.ЯчейкаТабличногоПоляРасширенногоЗначения_ВыборЛкс(ЭтаФорма, Элемент, СтандартнаяОбработка);

КонецПроцедуры // НайденныеОбъектыВыбор()

Процедура ПредставлениеОбластиПоискаНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	Форма = ирКэш.Получить().ПолучитьФорму("ВыборОбъектаМетаданных", Элемент, ЭтаФорма);

	лСтруктураПараметров = Новый Структура;
	лНачальноеЗначениеВыбора = ТипыСсылокДляПоиска.ВыгрузитьЗначения();
	лСтруктураПараметров.Вставить("НачальноеЗначениеВыбора", лНачальноеЗначениеВыбора);
	лСтруктураПараметров.Вставить("ОтображатьСсылочныеОбъекты", Истина);
	//лСтруктураПараметров.Вставить("ОтображатьВнешниеИсточникиДанных", Истина);
	лСтруктураПараметров.Вставить("МножественныйВыбор", Истина);
	лСтруктураПараметров.Вставить("МножественныйВыборТолькоДляОднотипныхТаблиц", Ложь);
	Форма.НачальноеЗначениеВыбора = лСтруктураПараметров;
	Форма.ОткрытьМодально();
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

Процедура ОбновлениеОтображения()

	ЭтаФорма.СтрокаКоличествоСтрок = БитыеСсылки.Количество();
	
КонецПроцедуры

Процедура ПредставлениеОбластиПоискаПриИзменении(Элемент)

	НастроитьЭлементыФормы();
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
	
КонецПроцедуры

Процедура ПредставлениеОбластиПоискаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, ЭтаФорма);

КонецПроцедуры

Процедура ПредставлениеОбластиПоискаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Массив") Тогда
		СтандартнаяОбработка = Ложь;
		ТипыСсылокДляПоиска = Новый СписокЗначений;
		ТипыСсылокДляПоиска.ЗагрузитьЗначения(ВыбранноеЗначение);
		ПредставлениеОбластиПоискаПриИзменении(Элемент);
	ИначеЕсли ТипЗнч(ВыбранноеЗначение) = Тип("СписокЗначений") Тогда
		СтандартнаяОбработка = Ложь;
		ТипыСсылокДляПоиска = Новый СписокЗначений;
		ТипыСсылокДляПоиска.ЗагрузитьЗначения(ВыбранноеЗначение.ВыгрузитьЗначения());
		ПредставлениеОбластиПоискаПриИзменении(Элемент);
	КонецЕсли;
		
КонецПроцедуры

Процедура МноготабличнаяВыборкаПриИзменении(Элемент)

	Если Истина
		//И МноготабличнаяВыборка 
		И ТипЗнч(ТипыСсылокДляПоиска) <> Тип("СписокЗначений")
	Тогда
		лОбластьПоиска = Новый СписокЗначений;
		Если ЗначениеЗаполнено(ТипыСсылокДляПоиска) Тогда
			лОбластьПоиска.Добавить(ТипыСсылокДляПоиска);
		КонецЕсли; 
	ИначеЕсли Истина
		//И Не МноготабличнаяВыборка 
		И ТипЗнч(ТипыСсылокДляПоиска) = Тип("СписокЗначений")
	Тогда
		Если ТипыСсылокДляПоиска.Количество() > 0 Тогда
			лОбластьПоиска = ТипыСсылокДляПоиска[0].Значение;
		Иначе
			лОбластьПоиска = "";
		КонецЕсли; 
	КонецЕсли; 
	НастроитьЭлементыФормы();
	
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура КоманднаяПанельБитыеСсылкиОчистить(Кнопка)
	
	БитыеСсылки.Очистить();
	
КонецПроцедуры

Процедура УзелОтбораОбъектовНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, ЭтаФорма);
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	ирОбщий.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура КоманднаяПанельБитыеСсылкиИсполняемыйЗапрос(Кнопка)
	
	Запрос = ПолучитьЗапросВыборки(Новый Структура("ПолучатьДанные, ЭтаФорма", Ложь)).Запрос;
	ирОбщий.ОтладитьЛкс(Запрос);
	
КонецПроцедуры

Процедура КоманднаяПанельБитыеСсылкиВыполнитьПоиск(Кнопка)
	
	Если Кнопка.Картинка <> ирКэш.КартинкаПоИмениЛкс("ирОстановить") Тогда
		СтрокиТаблицыБД.Очистить();
		ЭлементыФормы.СтрокиТаблицыБД.ОбновитьСтроки();
		Если Истина
			И Не ЛиВсеТипы
			И ТипыСсылокДляПоиска.Количество() = 0 
		Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли; 
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("ПолучатьДанные", Истина);
	#Если Сервер И Не Сервер Тогда
		ПолучитьЗапросВыборки();
		ВыполнитьПоискЗавершение();
	#КонецЕсли
	ирОбщий.ВыполнитьЗаданиеФормыЛкс("ПолучитьЗапросВыборки", ПараметрыЗадания, ЭтаФорма, "Поиск",, Кнопка, "ВыполнитьПоискЗавершение",,, Истина);

КонецПроцедуры

// Предопределеный метод
Процедура ПроверкаЗавершенияФоновыхЗаданий() Экспорт 
	
	ирОбщий.ПроверитьЗавершениеФоновыхЗаданийФормыЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ВыполнитьПоискЗавершение(СостояниеЗадания = Неопределено, РезультатЗадания = Неопределено) Экспорт 
	
	Если Ложь
		Или СостояниеЗадания = Неопределено
		Или СостояниеЗадания = СостояниеФоновогоЗадания.Завершено 
	Тогда
		Сообщить("Поиск выполнен за " + XMLСтрока(ТекущаяДата() - РезультатЗадания.НачалоЗадания) + " сек");
		Если РезультатЗадания.СвязанныеДанные <> СвязанныеДанные Тогда
			СвязанныеДанные.Загрузить(РезультатЗадания.СвязанныеДанные);
		КонецЕсли;
		ИтогиБитыхСсылок = СвязанныеДанные.Выгрузить();
		ИтогиБитыхСсылок.Свернуть("ИмяТипаСсылки, Ссылка", "КоличествоСсылающихся");
		БитыеСсылкиТЗ = БитыеСсылки.ВыгрузитьКолонки();
		БитыеСсылкиТЗ.Индексы.Добавить("Ссылка");
		ирОбщий.ЗагрузитьВТаблицуЗначенийЛкс(ИтогиБитыхСсылок, БитыеСсылкиТЗ);
		//БитыеСсылки.Сортировать("ИмяТипаСсылки, Ссылка"); // Заметно дольше и пользы мало
		БитыеСсылкиТЗ.Сортировать("ИмяТипаСсылки");
		Для Каждого БитаяСсылка Из БитыеСсылкиТЗ Цикл
			БитаяСсылка.ПредставлениеТипаСсылки = "" + Тип(ирОбщий.ИмяТипаИзПолногоИмениТаблицыБДЛкс(БитаяСсылка.ИмяТипаСсылки));
		КонецЦикла;
		ИтогиТипов = БитыеСсылкиТЗ.Скопировать();
		ИтогиТипов.Колонки.Добавить("КоличествоБитыхСсылок");
		ИтогиТипов.ЗаполнитьЗначения(1, "КоличествоБитыхСсылок");
		ИтогиТипов.Свернуть("ИмяТипаСсылки, ПредставлениеТипаСсылки", "КоличествоБитыхСсылок, КоличествоСсылающихся");
		ИтогиТипов.Сортировать("ПредставлениеТипаСсылки");
		ТипыНайденныхБитыхСсылок.Очистить();
		Для Каждого СтрокаИтогаИсточник Из ИтогиТипов Цикл
			СтрокаИтогаПриемник = ТипыНайденныхБитыхСсылок.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаИтогаПриемник, СтрокаИтогаИсточник); 
		КонецЦикла;
		ИтогиТипов.Свернуть(, "КоличествоБитыхСсылок, КоличествоСсылающихся");
		СтрокаВсехТипов = ТипыНайденныхБитыхСсылок.Вставить(0);
		СтрокаВсехТипов.ИмяТипаСсылки = "<Все>";
		СтрокаВсехТипов.ПредставлениеТипаСсылки = "<Все>";
		Если ИтогиТипов.Количество() > 0 Тогда
			ЗаполнитьЗначенияСвойств(СтрокаВсехТипов, ИтогиТипов[0]); 
		КонецЕсли; 
		ТаблицаВсехТаблиц = ирКэш.ТаблицаВсехТаблицБДЛкс();
		Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(СвязанныеДанные.Количество(), "Обработка результатов");
		Для Каждого СтрокаСвязанныхДанных Из СвязанныеДанные Цикл
			ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
			ПолноеИмяТаблицы = СтрокаСвязанныхДанных.ПолноеИмяТаблицы;
			ПоляТаблицыБД = ирКэш.ПоляТаблицыБДЛкс(ПолноеИмяТаблицы);
			Если ПоляТаблицыБД = Неопределено Тогда
				Продолжить;
			КонецЕсли; 
			#Если Сервер И Не Сервер Тогда
				ПоляТаблицыБД = НайтиПоСсылкам().Колонки;
			#КонецЕсли
			ОписаниеТаблицы = ТаблицаВсехТаблиц.Найти(НРег(ПолноеИмяТаблицы), "НПолноеИмя");
			СтрокаСвязанныхДанных.ИмяТаблицы = ОписаниеТаблицы.Имя;
			СтрокаСвязанныхДанных.ПредставлениеТаблицы = ОписаниеТаблицы.Представление;
			ПолеТаблицыБД = ПоляТаблицыБД.Найти(СтрокаСвязанныхДанных.ИмяКолонки, "Имя");
			СтрокаСвязанныхДанных.ПредставлениеКолонки = ПолеТаблицыБД.Заголовок;
			СтрокаСвязанныхДанных.КоличествоТипов = ПолеТаблицыБД.ТипЗначения.Типы().Количество();
			СтрокаБитойСсылки = БитыеСсылкиТЗ.Найти(СтрокаСвязанныхДанных.Ссылка, "Ссылка");
			Если Найти(Нрег(СтрокаБитойСсылки.ИменаСсылающихсяТаблиц), НРег(ПолноеИмяТаблицы)) = 0 Тогда
				Если ЗначениеЗаполнено(СтрокаБитойСсылки.ИменаСсылающихсяТаблиц) Тогда
					СтрокаБитойСсылки.ИменаСсылающихсяТаблиц = СтрокаБитойСсылки.ИменаСсылающихсяТаблиц + ", ";
					СтрокаБитойСсылки.ПредставленияСсылающихсяТаблиц = СтрокаБитойСсылки.ПредставленияСсылающихсяТаблиц + ", ";
				КонецЕсли; 
				СтрокаБитойСсылки.ИменаСсылающихсяТаблиц = СтрокаБитойСсылки.ИменаСсылающихсяТаблиц + СтрокаСвязанныхДанных.ИмяТаблицы;
				СтрокаБитойСсылки.ПредставленияСсылающихсяТаблиц = СтрокаБитойСсылки.ПредставленияСсылающихсяТаблиц + СтрокаСвязанныхДанных.ПредставлениеТаблицы;
			КонецЕсли; 
		КонецЦикла;
		ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
		ЭлементыФормы.ТипыНайденныхБитыхСсылок.ТекущаяСтрока = ТипыНайденныхБитыхСсылок[0];
		БитыеСсылки.Загрузить(БитыеСсылкиТЗ);
		Если БитыеСсылки.Количество() > 0 Тогда
			ЭлементыФормы.БитыеСсылки.ТекущаяСтрока = БитыеСсылки[0];
		КонецЕсли; 
	КонецЕсли; 

КонецПроцедуры

Процедура БитыеСсылкиПередНачаломДобавления(Элемент, Отказ, Копирование)
	// Вставить содержимое обработчика.
КонецПроцедуры

Процедура БитыеСсылкиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
КонецПроцедуры

Процедура БитыеСсылкиПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	ТекущаяСтрока = Элемент.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		ЗначениеОтбора = Неопределено;
	Иначе
		ЗначениеОтбора = ТекущаяСтрока.Ссылка;
	КонецЕсли; 
	ЭлементыФормы.СвязанныеДанные.ОтборСтрок.Ссылка.Установить(ЗначениеОтбора, ЭлементыФормы.СвязанныеДанные.ОтборСтрок.Ссылка.Использование);
	
КонецПроцедуры

Процедура ИмяПредставлениеПриИзменении(Элемент = Неопределено)
	
	ТабличноеПоле = ЭлементыФормы.СвязанныеДанные;
	ТабличноеПоле.Колонки.ПредставлениеКолонки.Видимость = Не ИмяПредставление;
	ТабличноеПоле.Колонки.ПредставлениеТаблицы.Видимость = Не ИмяПредставление;
	ТабличноеПоле.Колонки.ИмяТаблицы.Видимость = ИмяПредставление;
	ТабличноеПоле.Колонки.ИмяКолонки.Видимость = ИмяПредставление;
	//Если Не ИмяПредставление Тогда
	//	ЭлементОтбора = ТабличноеПоле.ОтборСтрок.ИмяТаблицы;
	//Иначе
	//	ЭлементОтбора = ТабличноеПоле.ОтборСтрок.ПредставлениеТаблицы;
	//КонецЕсли;
	//ЭлементОтбора.Значение = "";
	//Если Не ИмяПредставление Тогда
	//	ЭлементОтбора = ТабличноеПоле.ОтборСтрок.ИмяКолонки;
	//Иначе
	//	ЭлементОтбора = ТабличноеПоле.ОтборСтрок.ПредставлениеКолонки;
	//КонецЕсли;
	//ЭлементОтбора.Значение = "";
	СтараяКолонка = ТабличноеПоле.ТекущаяКолонка;
	Если СтараяКолонка <> Неопределено Тогда
		Если Найти(НРег(СтараяКолонка.Имя), "таблицы") > 0 Тогда
			Если ТабличноеПоле.Колонки.ПредставлениеТаблицы.Видимость Тогда
				ТабличноеПоле.ТекущаяКолонка = ТабличноеПоле.Колонки.ПредставлениеТаблицы;
			Иначе
				ТабличноеПоле.ТекущаяКолонка = ТабличноеПоле.Колонки.ИмяТаблицы;
			КонецЕсли; 
		ИначеЕсли Найти(НРег(СтараяКолонка.Имя), "колонки") > 0 Тогда
			Если ТабличноеПоле.Колонки.ПредставлениеКолонки.Видимость Тогда
				ТабличноеПоле.ТекущаяКолонка = ТабличноеПоле.Колонки.ПредставлениеКолонки;
			Иначе
				ТабличноеПоле.ТекущаяКолонка = ТабличноеПоле.Колонки.ИмяКолонки;
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 
	//ОбновитьОтборСвязанныхДанных();
	
	ТабличноеПоле = ЭлементыФормы.БитыеСсылки;
	ТабличноеПоле.Колонки.ПредставленияСсылающихсяТаблиц.Видимость = Не ИмяПредставление;
	ТабличноеПоле.Колонки.ИменаСсылающихсяТаблиц.Видимость = ИмяПредставление;
	ТабличноеПоле.Колонки.ПредставлениеТипаСсылки.Видимость = Не ИмяПредставление;
	ТабличноеПоле.Колонки.ИмяТипаСсылки.Видимость = ИмяПредставление;
	СтараяКолонка = ТабличноеПоле.ТекущаяКолонка;
	Если СтараяКолонка <> Неопределено Тогда
		Если Найти(НРег(СтараяКолонка.Имя), "таблиц") > 0 Тогда
			Если ТабличноеПоле.Колонки.ПредставленияСсылающихсяТаблиц.Видимость Тогда
				ТабличноеПоле.ТекущаяКолонка = ТабличноеПоле.Колонки.ПредставленияСсылающихсяТаблиц;
			Иначе
				ТабличноеПоле.ТекущаяКолонка = ТабличноеПоле.Колонки.ИменаСсылающихсяТаблиц;
			КонецЕсли; 
		ИначеЕсли Найти(НРег(СтараяКолонка.Имя), "типассылки") > 0 Тогда
			Если ТабличноеПоле.Колонки.ПредставлениеТипаСсылки.Видимость Тогда
				ТабличноеПоле.ТекущаяКолонка = ТабличноеПоле.Колонки.ПредставлениеТипаСсылки;
			Иначе
				ТабличноеПоле.ТекущаяКолонка = ТабличноеПоле.Колонки.ИмяТипаСсылки;
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 
	
	ТабличноеПоле = ЭлементыФормы.ТипыНайденныхБитыхСсылок;
	ТабличноеПоле.Колонки.ПредставлениеТипаСсылки.Видимость = Не ИмяПредставление;
	ТабличноеПоле.Колонки.ИмяТипаСсылки.Видимость = ИмяПредставление;
	СтараяКолонка = ТабличноеПоле.ТекущаяКолонка;
	Если СтараяКолонка <> Неопределено Тогда
		Если Найти(НРег(СтараяКолонка.Имя), "типассылки") > 0 Тогда
			Если ТабличноеПоле.Колонки.ПредставлениеТипаСсылки.Видимость Тогда
				ТабличноеПоле.ТекущаяКолонка = ТабличноеПоле.Колонки.ПредставлениеТипаСсылки;
			Иначе
				ТабличноеПоле.ТекущаяКолонка = ТабличноеПоле.Колонки.ИмяТипаСсылки;
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

Процедура СвязанныеДанныеПриАктивизацииСтроки(Элемент = Неопределено)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	Элемент = ЭлементыФормы.СвязанныеДанные;
	СтрокаСвязаннойКолонки = Элемент.ТекущаяСтрока;
	Если СтрокаСвязаннойКолонки = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	Если ЭлементыФормы.СвязанныеДанные.ОтборСтрок.Ссылка.Использование Или ОтборПоТекущейСсылкеВТаблицеБД Тогда
		ЗначениеОтбора = СтрокаСвязаннойКолонки.Ссылка;
	Иначе
		ПостроительТабличногоПоля = ирОбщий.ПостроительТабличногоПоляСОтборомКлиентаЛкс(Элемент);
		ПостроительТабличногоПоля.Отбор.ИмяКолонки.Установить(СтрокаСвязаннойКолонки.ИмяКолонки);
		ПостроительТабличногоПоля.Отбор.ПолноеИмяТаблицы.Установить(СтрокаСвязаннойКолонки.ПолноеИмяТаблицы);
		МассивСсылок = ПостроительТабличногоПоля.Результат.Выгрузить().ВыгрузитьКолонку("Ссылка");
		ЗначениеОтбора = Новый СписокЗначений;
		ЗначениеОтбора.ЗагрузитьЗначения(МассивСсылок);
	КонецЕсли; 
	РезультатЗагрузки = ирОбщий.ЗагрузитьСвязанныеСтрокиТаблицыБДЛкс(ЭтаФорма, Элемент, ЭлементыФормы.СтрокиТаблицыБД, ЭлементыФормы.КоманднаяПанельСтрокиТаблицыБД, 
		мВыборкаРезультатаСтрокиТаблицы, ЗначениеОтбора);
	Если РезультатЗагрузки = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ЭтаФорма.ПолноеИмяСвязаннойТаблицыБД = РезультатЗагрузки;
	СтрокаСвязанныхДанных = Элемент.ТекущаяСтрока;
	Если ОтборПоТекущейСсылкеВТаблицеБД Или ЭлементыФормы.СвязанныеДанные.ОтборСтрок.Ссылка.Использование Тогда
		СтрокаСвязанныхДанных.КоличествоСсылающихся = СтрокиТаблицыБД.Количество();
	КонецЕсли; 

КонецПроцедуры

Процедура ОбновитьРазмерДинамическойТаблицы() Экспорт

	ирОбщий.ПослеЗагрузкиВыборкиВТабличноеПолеЛкс(ЭтаФорма, мВыборкаРезультатаСтрокиТаблицы, ЭлементыФормы.КоманднаяПанельСтрокиТаблицыБД, ЭлементыФормы.КоличествоСтрокТаблицыБД);

КонецПроцедуры // ОбновитьРазмерТаблицы()

Процедура КоманднаяПанельСтрокиТаблицыБДЗагрузитьПолностью(Кнопка)
	
	ирОбщий.ЗагрузитьВыборкуВТабличноеПолеПолностьюЛкс(ЭтаФорма, мВыборкаРезультатаСтрокиТаблицы, 
		ЭлементыФормы.КоманднаяПанельСтрокиТаблицыБД);

КонецПроцедуры

Процедура КоманднаяПанельСтрокиТаблицыБДРедактировать(Кнопка)
	
	Если ЭлементыФормы.СвязанныеДанные.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ирОбщий.ОткрытьТекущуюСтрокуТабличногоПоляТаблицыБДВРедактореОбъектаБДЛкс(ЭлементыФормы.СтрокиТаблицыБД, ЭлементыФормы.СвязанныеДанные.ТекущаяСтрока.ПолноеИмяТаблицы,,,,, Ложь);
	
КонецПроцедуры

Процедура КоманднаяПанельСтрокиТаблицыБДКонсольОбработки(Кнопка)
	
	ирОбщий.ОткрытьОбъектыИзВыделенныхЯчеекВПодбореИОбработкеОбъектовЛкс(ЭлементыФормы.СтрокиТаблицыБД,, ЭтаФорма, ПолноеИмяСвязаннойТаблицыБД);
	
КонецПроцедуры

Процедура СвязанныеДанныеВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если ВыбраннаяСтрока.ТипТаблицы = "Константа" Тогда
		ФормаСписка = ирОбщий.ПолучитьФормуЛкс("Обработка.ирРедакторКонстант.Форма");
		ТекущаяСтрока = ирОбщий.ПоследнийФрагментЛкс(ВыбраннаяСтрока.ПолноеИмяТаблицы);
		ФормаСписка.НачальноеЗначениеВыбора = ТекущаяСтрока;
		ФормаСписка.Открыть();
	ИначеЕсли Истина
		И Не ирОбщий.ЛиТипВложеннойТаблицыБДЛкс(ВыбраннаяСтрока.ТипТаблицы)
		И ВыбраннаяСтрока.ТипТаблицы <> "Изменения"
	Тогда
		ирОбщий.ОткрытьФормуСпискаЛкс(ВыбраннаяСтрока.ПолноеИмяТаблицы, Новый Структура(ВыбраннаяСтрока.ИмяКолонки, ВыбраннаяСтрока.Ссылка));
	КонецЕсли; 

КонецПроцедуры

Процедура СтрокиТаблицыБДВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ирОбщий.ЯчейкаТабличногоПоляРасширенногоЗначения_ВыборЛкс(ЭтаФорма, Элемент, СтандартнаяОбработка);

КонецПроцедуры

Процедура ТипыНайденныхБитыхСсылокПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	ТекущаяСтрока = ЭлементыФормы.ТипыНайденныхБитыхСсылок.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		ИмяТипаСсылки = "<Все>";
	Иначе
		ИмяТипаСсылки = ТекущаяСтрока.ИмяТипаСсылки;
	КонецЕсли; 
	ЭлементыФормы.ОтборПоТипуСсылки.Доступность = ИмяТипаСсылки <> "<Все>";
	ЭлементыФормы.БитыеСсылки.ОтборСтрок.ИмяТипаСсылки.Установить(ИмяТипаСсылки, ИмяТипаСсылки <> "<Все>");
	ЭлементыФормы.СвязанныеДанные.ОтборСтрок.ИмяТипаСсылки.Установить(ИмяТипаСсылки, ЭлементыФормы.СвязанныеДанные.ОтборСтрок.ИмяТипаСсылки.Использование И ИмяТипаСсылки <> "<Все>");
	
КонецПроцедуры

Процедура ОтборПоТекущейСсылкеВТаблицеБДПриИзменении(Элемент)
	
	СвязанныеДанныеПриАктивизацииСтроки();

КонецПроцедуры

Процедура ОтборПоСсылкеПриИзменении(Элемент)
	
	НастроитьЭлементыФормы();
	
КонецПроцедуры

Процедура НастроитьЭлементыФормы()
	
	ЭлементыФормы.ОтборПоТекущейСсылкеВТаблицеБД.Доступность = Не ЭлементыФормы.СвязанныеДанные.ОтборСтрок.Ссылка.Использование;
	ЭлементыФормы.ТипыСсылокДляПоиска.Доступность = Не ЛиВсеТипы;
	ЭлементыФормы.УчитыватьВиртуальныеТаблицы.Доступность = Не ТолькоРегистраторы;
	ДоступностьМногопоточности = ВыполнятьНаСервере И ЭлементыФормы.ВыполнятьНаСервере.Доступность И Не ирКэш.ЭтоФайловаяБазаЛкс();
	ЭлементыФормы.КоличествоПотоков.Доступность = ДоступностьМногопоточности;
	ЭлементыФормы.КоличествоОбъектовВПорции.Доступность = КоличествоПотоков > 1 И ДоступностьМногопоточности;
	
КонецПроцедуры

Процедура СвязанныеДанныеПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
	Ячейка = ОформлениеСтроки.Ячейки.ТипТаблицы;
	Ячейка.ОтображатьКартинку = Истина;
	Ячейка.ИндексКартинки = ирОбщий.ПолучитьИндексКартинкиТипаТаблицыБДЛкс(ДанныеСтроки.ТипТаблицы);

КонецПроцедуры

Процедура ВсеТипыПриИзменении(Элемент)
	
	НастроитьЭлементыФормы();
	
КонецПроцедуры

Процедура ТолькоРегистраторыПриИзменении(Элемент)
	
	НастроитьЭлементыФормы();
	
КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработчикОжиданияСПараметрамиЛкс() Экспорт 
	
	ирОбщий.ОбработчикОжиданияСПараметрамиЛкс();

КонецПроцедуры

Процедура СтрокиТаблицыБДПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки, ЭлементыФормы.КоманднаяПанельСтрокиТаблицыБД.Кнопки.Идентификаторы);

КонецПроцедуры

Процедура КоманднаяПанельНайденныеОбъектыРедакторОбъектаБД(Кнопка)
	
	Если ЭлементыФормы.БитыеСсылки.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ирОбщий.ОткрытьСсылкуВРедактореОбъектаБДЛкс(ЭлементыФормы.БитыеСсылки.ТекущаяСтрока.Ссылка);

КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура СтрокиТаблицыБДПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);

КонецПроцедуры

Процедура БитыеСсылкиПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);

КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирОбщий.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура ТипыНайденныхБитыхСсылокПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
	
КонецПроцедуры

Процедура ВыполнятьНаСервереПриИзменении(Элемент)
	
	НастроитьЭлементыФормы();
	
КонецПроцедуры

Процедура КоличествоПотоковОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Элемент.Значение = 1;

КонецПроцедуры

Процедура КоличествоПотоковПриИзменении(Элемент)
	
	НастроитьЭлементыФормы();
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирПоискБитыхСсылок.Форма.Форма");
ЭтаФорма.ПолноеИмяСвязаннойТаблицыБД = "<Полное имя таблицы>";
ЭтаФорма.ЛиВсеТипы = Истина;
// Антибаг платформы. Очищаются свойство данные, если оно указывает на отбор табличной части
ЭлементыФормы.ОтборПоСсылке.Данные = "ЭлементыФормы.СвязанныеДанные.Отбор.Ссылка.Использование";
ЭлементыФормы.ОтборПоТипуСсылки.Данные = "ЭлементыФормы.СвязанныеДанные.Отбор.ИмяТипаСсылки.Использование";
