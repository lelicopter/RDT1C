﻿//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирПривилегированный Экспорт;

Перем РасширениеФайла;

Функция ПолучитьРезультат()
	
	Результат = Новый СписокЗначений;
	Результат.ТипЗначения = ОписаниеТипов;
	Для Каждого СтрокаТаблицы Из Таблица Цикл
		ЭлементСписка = Результат.Добавить();
		ЗаполнитьЗначенияСвойств(ЭлементСписка, СтрокаТаблицы); 
	КонецЦикла; 
	Возврат Результат;

КонецФункции

Процедура ОсновныеДействияФормыОК(Кнопка = Неопределено)
	
	Модифицированность = Ложь;
	ирОбщий.ПрименитьИзмененияИЗакрытьФормуЛкс(ЭтаФорма, ПолучитьРезультат());
	
КонецПроцедуры

Процедура УстановитьРедактируемоеЗначение(НовоеЗначение)
	
	ОписаниеТипов = НовоеЗначение.ТипЗначения;
	ЗагрузитьЭлементыСписка(НовоеЗначение);
	ОбновитьВидимостьКолонок();
	
КонецПроцедуры

Процедура ЗагрузитьЭлементыСписка(НовоеЗначение, ОчиститьПередЗагрузкой = Истина)

	Если ОчиститьПередЗагрузкой Тогда
		Таблица.Очистить();
	КонецЕсли; 
	Для Индекс = 0 По НовоеЗначение.Количество() - 1 Цикл
	    НоваяСтрока = Таблица.Добавить();
		ЗначениеЭлемента = НовоеЗначение[Индекс];
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ЗначениеЭлемента); 
		ОбновитьПредставлениеИТипЗначенияВСтроке(НоваяСтрока);
	КонецЦикла;

КонецПроцедуры

Процедура ПриОткрытии()
	
	Если ТипЗнч(НачальноеЗначениеВыбора) <> Тип("СписокЗначений") Тогда
		НачальноеЗначениеВыбора = Новый СписокЗначений();
	КонецЕсли;
	УстановитьРедактируемоеЗначение(НачальноеЗначениеВыбора);

КонецПроцедуры

Процедура ТабличноеПоле1ПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	 ОформлениеСтроки.Ячейки.ТипЗначения.УстановитьТекст(ТипЗнч(ДанныеСтроки.Значение));
	 ОформлениеСтроки.Ячейки.Номер.УстановитьТекст(Элемент.Значение.Индекс(ДанныеСтроки) + 1);
	
КонецПроцедуры

Процедура ОсновныеДействияФормыИсследовать()
	
	ирОбщий.ИсследоватьЛкс(ПолучитьРезультат());
	
КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	Количество = Таблица.Количество();
	
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если ЭтаФорма.Модифицированность Тогда
		Ответ = Вопрос("Данные в форме были изменены. Хотите сохранить изменения?", РежимДиалогаВопрос.ДаНетОтмена);
		Если Ответ = КодВозвратаДиалога.Отмена Тогда
			Отказ = Истина;
			Возврат;
		ИначеЕсли Ответ = КодВозвратаДиалога.Да Тогда
			Модифицированность = Ложь;
			ОсновныеДействияФормыОК();
		КонецЕсли;
	КонецЕсли; 

КонецПроцедуры

Процедура ОбновитьВидимостьКолонок()
	
	ЛиПростойСписок = ОписаниеТипов.Типы().Количество() = 1;
	ЭлементыФормы.Таблица.Колонки.ТипЗначения.Видимость = Не ЛиПростойСписок;
	
КонецПроцедуры

Процедура ОписаниеТиповНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	РезультатВыбора = ирОбщий.РедактироватьОписаниеРедактируемыхТиповЛкс(Элемент);
	Если РезультатВыбора <> Неопределено Тогда
		Элемент.Значение = РезультатВыбора;
		ОбновитьВидимостьКолонок();
	КонецЕсли; 
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

Процедура КоманднаяПанель1ЗагрузитьИзФайла(Кнопка)
	
	 Результат = ирОбщий.ЗагрузитьЗначениеИзФайлаЛкс(РасширениеФайла);
	 Если ТипЗнч(Результат) = Тип("СписокЗначений") Тогда
		 УстановитьРедактируемоеЗначение(Результат);
	 КонецЕсли; 
	 
КонецПроцедуры

Процедура КоманднаяПанель1СохранитьВФайл(Кнопка)
	
	ирОбщий.СохранитьЗначениеВФайлИнтерактивноЛкс(ПолучитьРезультат(), РасширениеФайла);
	
КонецПроцедуры

Процедура КоманднаяПанель1Подбор(Кнопка)
	
	ТекущаяСтрока = ЭлементыФормы.Таблица.ТекущаяСтрока;
	Если ТекущаяСтрока <> Неопределено Тогда
		НачальноеЗначениеВыбора = ТекущаяСтрока.Значение;
	КонецЕсли; 
	ирОбщий.ОткрытьПодборСВыборомТипаЛкс(ЭлементыФормы.Таблица, ОписаниеТипов, НачальноеЗначениеВыбора);

КонецПроцедуры

Процедура ТаблицаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Истина
		И ТипЗнч(ВыбранноеЗначение) <> Тип("Массив") 
		И ТипЗнч(ВыбранноеЗначение) <> Тип("Структура")
	Тогда
		лЗначение = ВыбранноеЗначение;
		ВыбранноеЗначение = Новый Массив();
		ВыбранноеЗначение.Добавить(лЗначение);
	КонецЕсли; 
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Массив") Тогда 
		Для Каждого лЗначение Из ВыбранноеЗначение Цикл
			Если ОписаниеТипов.СодержитТип(ТипЗнч(лЗначение)) Тогда
				СтрокаТаблицы = Таблица.Добавить();
				СтрокаТаблицы.Значение = лЗначение;
				ЭлементыФормы.Таблица.ТекущаяСтрока = СтрокаТаблицы;
				ОбновитьПредставлениеИТипЗначенияВСтроке();
				ЭтаФорма.Модифицированность = Истина;
			КонецЕсли; 
		КонецЦикла;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОсновныеДействияФормыРедактироватьКопию(Кнопка)
	
	ирОбщий.ОткрытьФормуПроизвольногоЗначенияЛкс(ПолучитьРезультат(),,,, Ложь);

КонецПроцедуры

Процедура ТаблицаПредставлениеЗначенияПриИзменении(Элемент)
	
	ТабличноеПоле = ЭтаФорма.ЭлементыФормы.Таблица;
	ТабличноеПоле.ТекущиеДанные.Значение = Элемент.Значение;
	ОбновитьПредставлениеИТипЗначенияВСтроке();

КонецПроцедуры

Процедура ТаблицаПредставлениеЗначенияНачалоВыбора(Элемент, СтандартнаяОбработка)

	ирОбщий.ПолеВводаКолонкиРасширенногоЗначения_НачалоВыбораЛкс(ЭлементыФормы.Таблица, СтандартнаяОбработка, ЭлементыФормы.Таблица.ТекущаяСтрока.Значение, Истина);
	ОбновитьПредставлениеИТипЗначенияВСтроке();

КонецПроцедуры

Процедура ТаблицаПредставлениеЗначенияОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	ирОбщий.ПолеВвода_ОкончаниеВводаТекстаЛкс(Элемент, Текст, Значение, СтандартнаяОбработка, ЭлементыФормы.Таблица.ТекущаяСтрока.Значение);

КонецПроцедуры

Процедура ОбновитьПредставлениеИТипЗначенияВСтроке(СтрокаТаблицы = Неопределено)
	
	Если СтрокаТаблицы = Неопределено Тогда
		СтрокаТаблицы = ЭлементыФормы.Таблица.ТекущиеДанные;
	КонецЕсли; 
	//СтрокаТаблицы.ТипЗначения = ТипЗнч(СтрокаТаблицы.Значение);
	СтрокаТаблицы.ПредставлениеЗначения = СтрокаТаблицы.Значение;
	
КонецПроцедуры

Процедура ТаблицаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если Истина
		И НоваяСтрока 
		И Не Копирование
	Тогда
		СтрокаТаблицы = ЭлементыФормы.Таблица.ТекущиеДанные;
		СтрокаТаблицы.Значение = ОписаниеТипов.ПривестиЗначение(Неопределено);
		СтрокаТаблицы.ПредставлениеЗначения = СтрокаТаблицы.Значение;
	КонецЕсли; 
	
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура КоманднаяПанель1ЗаполнитьЗапросом(Кнопка)
	
	КоллекцияДляЗаполнения = Новый ТаблицаЗначений;
	КоллекцияДляЗаполнения.Колонки.Добавить("Значение", ОписаниеТипов);
	КонсольЗапросов = ирОбщий.ПолучитьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирКонсольЗапросов");
	#Если Сервер И Не Сервер Тогда
		КонсольЗапросов = Обработки.ирКонсольЗапросов.Создать();
	#КонецЕсли
	РезультатЗапроса = КонсольЗапросов.ОткрытьДляЗаполненияКоллекции(КоллекцияДляЗаполнения);
	Если РезультатЗапроса = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ОчиститьТаблицу = Ложь;
	Если Таблица.Количество() > 0 Тогда
		Ответ = Вопрос("Очистить строки таблицы перед загрузкой результата запроса?", РежимДиалогаВопрос.ДаНет);
		Если Ответ = КодВозвратаДиалога.Да Тогда
			ОчиститьТаблицу = Истина;
		КонецЕсли;
	КонецЕсли; 
	ЗагрузитьЭлементыСписка(РезультатЗапроса, ОчиститьТаблицу);
	
КонецПроцедуры

Процедура КлсУниверсальнаяКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработчикОжиданияСПараметрамиЛкс() Экспорт 
	
	ирОбщий.ОбработчикОжиданияСПараметрамиЛкс();

КонецПроцедуры

Процедура КоманднаяПанель1РедакторОбъектаБД(Кнопка)
	
	ирОбщий.ОткрытьСсылкуЯчейкиВРедактореОбъектаБДЛкс(ЭлементыФормы.Таблица, "Значение");
	
КонецПроцедуры

Процедура КоманднаяПанель1ВМассив(Кнопка)
	
	ирОбщий.ОткрытьФормуПроизвольногоЗначенияЛкс(ПолучитьРезультат().ВыгрузитьЗначения(),,,, Ложь);
	
КонецПроцедуры

Процедура КоманднаяПанель1ИзМассива(Кнопка)
	
	 Результат = ирОбщий.ЗагрузитьЗначениеИзФайлаЛкс("VA_");
	 Если ТипЗнч(Результат) = Тип("Массив") Тогда
		 Список = Новый СписокЗначений;
		 Список.ЗагрузитьЗначения(Результат);
		 УстановитьРедактируемоеЗначение(Список);
	 КонецЕсли; 
	
КонецПроцедуры

Процедура КоманднаяПанель1КонсольОбработки(Кнопка)
	
	ирОбщий.ОткрытьОбъектыИзВыделенныхЯчеекВПодбореИОбработкеОбъектовЛкс(ЭлементыФормы.Таблица, "Значение");
	
КонецПроцедуры

//ирПортативный #Если Клиент Тогда
//ирПортативный Контейнер = Новый Структура();
//ирПортативный Оповестить("ирПолучитьБазовуюФорму", Контейнер);
//ирПортативный Если Не Контейнер.Свойство("ирПортативный", ирПортативный) Тогда
//ирПортативный 	ПолноеИмяФайлаБазовогоМодуля = ВосстановитьЗначение("ирПолноеИмяФайлаОсновногоМодуля");
//ирПортативный 	ирПортативный = ВнешниеОбработки.ПолучитьФорму(ПолноеИмяФайлаБазовогоМодуля);
//ирПортативный КонецЕсли; 
//ирПортативный ирОбщий = ирПортативный.ПолучитьОбщийМодульЛкс("ирОбщий");
//ирПортативный ирКэш = ирПортативный.ПолучитьОбщийМодульЛкс("ирКэш");
//ирПортативный ирСервер = ирПортативный.ПолучитьОбщийМодульЛкс("ирСервер");
//ирПортативный ирПривилегированный = ирПортативный.ПолучитьОбщийМодульЛкс("ирПривилегированный");
//ирПортативный #КонецЕсли

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.СписокЗначений");

РасширениеФайла = "VL_";

ОписаниеТипов = Новый ОписаниеТипов();
Таблица.Колонки.Добавить("Значение", ОписаниеТипов);
