﻿Перем РасширениеФайла;

Функция ПолучитьРезультат()
	
	Результат = Таблица.ВыгрузитьКолонку("Значение");
	Если ТипЗнч(НачальноеЗначениеВыбора) = Тип("ФиксированныйМассив") Тогда
		Результат = Новый ФиксированныйМассив(Результат);
	КонецЕсли;
	Возврат Результат;

КонецФункции

Процедура ОсновныеДействияФормыОК(Кнопка = Неопределено)
	
	Модифицированность = Ложь;
	ирКлиент.ПрименитьИзмененияИЗакрытьФормуЛкс(ЭтаФорма, ПолучитьРезультат());
	
КонецПроцедуры

Процедура УстановитьРедактируемоеЗначение(НовоеЗначение, РазрешитьПропускНеуникальных = Истина)
	
	ЗагрузитьЭлементыМассива(НовоеЗначение,, РазрешитьПропускНеуникальных); 
	
КонецПроцедуры

Процедура ЗагрузитьЭлементыМассива(НовоеЗначение, ОчиститьПередЗагрузкой = Истина, РазрешитьПропускНеуникальных = Истина)

	Если ОчиститьПередЗагрузкой Тогда
		Таблица.Очистить();
	КонецЕсли; 
	ТаблицаОбработкаВыбора(, НовоеЗначение,, РазрешитьПропускНеуникальных);

КонецПроцедуры

Процедура ПриОткрытии()
	
	ирКлиент.Форма_ПриОткрытииЛкс(ЭтаФорма);
	Если Истина
		И ТипЗнч(НачальноеЗначениеВыбора) <> Тип("Массив") 
		И ТипЗнч(НачальноеЗначениеВыбора) <> Тип("ФиксированныйМассив") 
	Тогда
		НачальноеЗначениеВыбора = Новый Массив();
	КонецЕсли; 
	ирКлиент.ФормаОбъекта_ОбновитьЗаголовокЛкс(ЭтаФорма);
	УстановитьРедактируемоеЗначение(НачальноеЗначениеВыбора, Ложь);
	ЭлементыФормы.Таблица.ТолькоПросмотр = ТолькоПросмотр; // Чтобы открытие ссылок из ячеек работало
	ЭтаФорма.Модифицированность = Ложь;

КонецПроцедуры

Процедура ТабличноеПоле1ПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ОформлениеСтроки.Ячейки.ТипЗначения.УстановитьТекст(ТипЗнч(ДанныеСтроки.Значение));
	ОформлениеСтроки.Ячейки.Номер.УстановитьТекст(XMLСтрока(Элемент.Значение.Индекс(ДанныеСтроки) + 1));
	ирКлиент.ОформитьЯчейкуСРасширеннымЗначениемЛкс(ОформлениеСтроки.Ячейки.ПредставлениеЗначения, ДанныеСтроки.Значение, Элемент.Колонки.ПредставлениеЗначения);
	
КонецПроцедуры

Процедура ОсновныеДействияФормыИсследовать()
	
	ирОбщий.ИсследоватьЛкс(ПолучитьРезультат());
	
КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	Количество = Таблица.Количество();
	
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Ответ = ирКлиент.ЗапроситьСохранениеДанныхФормыЛкс(ЭтаФорма, Отказ);
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ОсновныеДействияФормыОК();
	КонецЕсли;

КонецПроцедуры

Процедура КоманднаяПанель1ЗагрузитьИзФайла(Кнопка)
	
	 Результат = ирКлиент.ЗагрузитьЗначениеИзФайлаИнтерактивноЛкс(РасширениеФайла);
	 Если ТипЗнч(Результат) = Тип("Массив") Тогда
		 УстановитьРедактируемоеЗначение(Результат);
	 КонецЕсли; 
	
КонецПроцедуры

Процедура КоманднаяПанель1СохранитьВФайл(Кнопка)
	
	ирКлиент.СохранитьЗначениеВФайлИнтерактивноЛкс(ПолучитьРезультат(), РасширениеФайла);

КонецПроцедуры

Процедура ТаблицаОбработкаВыбора(Элемент = Неопределено, ВыбранноеЗначение, СтандартнаяОбработка = Неопределено, РазрешитьПропускНеуникальных = Истина)
	
	Если Истина
		И ТипЗнч(ВыбранноеЗначение) <> Тип("Массив") 
		И ТипЗнч(ВыбранноеЗначение) <> Тип("ФиксированныйМассив") 
		И ТипЗнч(ВыбранноеЗначение) <> Тип("Структура")
	Тогда
		лЗначение = ВыбранноеЗначение;
		ВыбранноеЗначение = Новый Массив();
		ВыбранноеЗначение.Добавить(лЗначение);
	КонецЕсли; 
	Если Ложь
		Или ТипЗнч(ВыбранноеЗначение) = Тип("Массив")
		Или ТипЗнч(ВыбранноеЗначение) = Тип("ФиксированныйМассив")
	Тогда 
		ПропускатьНеуникальные = РазрешитьПропускНеуникальных = Истина И Уникальные И ВыбранноеЗначение.Количество() < 1000;
		Для Каждого лЗначение Из ВыбранноеЗначение Цикл
			Если ПропускатьНеуникальные Тогда 
				СтрокаТаблицы = Таблица.Найти(лЗначение, "Значение");
			Иначе
				СтрокаТаблицы = Неопределено;
			КонецЕсли;
			Если СтрокаТаблицы = Неопределено Тогда
				СтрокаТаблицы = Таблица.Добавить();
				СтрокаТаблицы.Значение = лЗначение;
				ОбновитьПредставлениеИТипЗначенияВСтроке(СтрокаТаблицы);
				ЭтаФорма.Модифицированность = Истина;
			КонецЕсли; 
		КонецЦикла;
		Если СтрокаТаблицы <> Неопределено Тогда
			ЭлементыФормы.Таблица.ТекущаяСтрока = СтрокаТаблицы;
		КонецЕсли; 
	КонецЕсли; 

КонецПроцедуры

Процедура КоманднаяПанель1Подбор(Кнопка)
	
	ТекущаяСтрока = ЭлементыФормы.Таблица.ТекущаяСтрока;
	Если ТекущаяСтрока <> Неопределено Тогда
		НачальноеЗначениеВыбораИсходящий = ТекущаяСтрока.Значение;
	КонецЕсли; 
	ирКлиент.ОткрытьПодборСВыборомТипаЛкс(ЭлементыФормы.Таблица,, НачальноеЗначениеВыбораИсходящий);
	
КонецПроцедуры

Процедура ОсновныеДействияФормыРедактироватьКопию(Кнопка)
	
	ирКлиент.ПредложитьЗакрытьМодальнуюФормуЛкс(ЭтаФорма);
	ирКлиент.ОткрытьЗначениеЛкс(ПолучитьРезультат(),,, ирКлиент.ЗаголовокДляКопииОбъектаЛкс(ЭтаФорма), Ложь);

КонецПроцедуры

Процедура ТаблицаПредставлениеЗначенияПриИзменении(Элемент)
	
	ТабличноеПоле = ЭтаФорма.ЭлементыФормы.Таблица;
	ТабличноеПоле.ТекущиеДанные.Значение = Элемент.Значение;
	ОбновитьПредставлениеИТипЗначенияВСтроке();

КонецПроцедуры

Процедура ТаблицаПредставлениеЗначенияНачалоВыбора(Элемент, СтандартнаяОбработка)

	ирКлиент.ПолеВводаКолонкиРасширенногоЗначения_НачалоВыбораЛкс(ЭтаФорма, ЭлементыФормы.Таблица, СтандартнаяОбработка, ЭлементыФормы.Таблица.ТекущаяСтрока.Значение);
	ОбновитьПредставлениеИТипЗначенияВСтроке();

КонецПроцедуры

Процедура ТаблицаПредставлениеЗначенияОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	ирКлиент.ПолеВвода_ОкончаниеВводаТекстаЛкс(Элемент, Текст, Значение, СтандартнаяОбработка, ЭлементыФормы.Таблица.ТекущаяСтрока.Значение);

КонецПроцедуры

Процедура ОбновитьПредставлениеИТипЗначенияВСтроке(СтрокаТаблицы = Неопределено)
	
	Если СтрокаТаблицы = Неопределено Тогда
		СтрокаТаблицы = ЭлементыФормы.Таблица.ТекущиеДанные;
	КонецЕсли; 
	//СтрокаТаблицы.ТипЗначения = ТипЗнч(СтрокаТаблицы.Значение);
	СтрокаТаблицы.ПредставлениеЗначения = СтрокаТаблицы.Значение;
	
КонецПроцедуры

Процедура КоманднаяПанель1ЗаполнитьЗапросом(Кнопка)
	
	КоллекцияДляЗаполнения = Новый ТаблицаЗначений;
	КоллекцияДляЗаполнения.Колонки.Добавить("Значение");
	КонсольЗапросов = ирОбщий.СоздатьОбъектПоИмениМетаданныхЛкс("Обработка.ирКонсольЗапросов");
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
	ЗагрузитьЭлементыМассива(РезультатЗапроса.ВыгрузитьКолонку("Значение"), ОчиститьТаблицу);
	
КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирКлиент.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработчикОжиданияСПараметрамиЛкс() Экспорт 
	
	ирКлиент.ОбработчикОжиданияСПараметрамиЛкс();

КонецПроцедуры

Процедура КоманднаяПанель1РедакторОбъектаБД(Кнопка)
	
	ирКлиент.ОткрытьСсылкуЯчейкиВРедактореОбъектаБДЛкс(ЭлементыФормы.Таблица, "Значение");
	
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирКлиент.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура КоманднаяПанель1ИзСписка(Кнопка)
	
	 Результат = ирКлиент.ЗагрузитьЗначениеИзФайлаИнтерактивноЛкс("VL_");
	 Если ТипЗнч(Результат) = Тип("СписокЗначений") Тогда
		 УстановитьРедактируемоеЗначение(Результат.ВыгрузитьЗначения());
	 КонецЕсли; 
	 
 КонецПроцедуры

Процедура КоманднаяПанель1ИзТекста(Кнопка)
	
	ФормаРазбивки = ПолучитьФорму("РазбивкаТекста");
	РезультатФормы = ФормаРазбивки.ОткрытьМодально();
	Если РезультатФормы <> Неопределено Тогда
		РезультатФормы = ирКлиент.ИнтерактивноКонвертироватьМассивСтрокЛкс(РезультатФормы);
		УстановитьРедактируемоеЗначение(РезультатФормы);
	КонецЕсли; 
	
КонецПроцедуры

Процедура КоманднаяПанель1КонсольОбработки(Кнопка)
	
	ирКлиент.ОткрытьОбъектыИзВыделенныхЯчеекВПодбореИОбработкеОбъектовЛкс(ЭлементыФормы.Таблица, "Значение", ЭтаФорма);
	
КонецПроцедуры

Процедура КоманднаяПанель1ВТаблицу(Кнопка)
	
	ТаблицаЛ = Новый ТаблицаЗначений;
	ТаблицаЛ.Колонки.Добавить("Значение");
	Для Каждого СтрокаСписка Из Таблица Цикл
		ЗаполнитьЗначенияСвойств(ТаблицаЛ.Добавить(), СтрокаСписка); 
	КонецЦикла;
	ирКлиент.ОткрытьЗначениеЛкс(ТаблицаЛ,,,, Ложь);
	
КонецПроцедуры

Процедура КоманднаяПанель1ВСписок(Кнопка)
	
	Список = Новый СписокЗначений;
	Список.ЗагрузитьЗначения(ПолучитьРезультат());
	ирКлиент.ОткрытьЗначениеЛкс(Список,,,, Ложь);

КонецПроцедуры

Процедура ТаблицаВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если Колонка = ЭлементыФормы.Таблица.Колонки.ПредставлениеЗначения Тогда 
		ирКлиент.ЯчейкаТабличногоПоляРасширенногоЗначения_ВыборЛкс(ЭтаФорма, Элемент, СтандартнаяОбработка, ВыбраннаяСтрока.Значение);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирКлиент.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирКлиент.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура ПриЗакрытии()
	ирКлиент.Форма_ПриЗакрытииЛкс(ЭтаФорма);
КонецПроцедуры

Процедура КоманднаяПанельВБуферОбмена(Кнопка)
	
	ирКлиент.БуферОбменаПриложения_УстановитьЗначениеЛкс(ПолучитьРезультат());
	
КонецПроцедуры

Процедура КоманднаяПанельИзБуферОбмена(Кнопка)
	
	ОбъектИзБуфера = ирКлиент.БуферОбменаПриложения_ЗначениеЛкс();
	Если Ложь
		Или ТипЗнч(ОбъектИзБуфера) = Тип("Массив") 
		Или ТипЗнч(ОбъектИзБуфера) = Тип("ФиксированныйМассив")
	Тогда
		УстановитьРедактируемоеЗначение(ОбъектИзБуфера);
		ЭтаФорма.Модифицированность = Истина;
	ИначеЕсли ТипЗнч(ОбъектИзБуфера) = Тип("СписокЗначений") Тогда
		УстановитьРедактируемоеЗначение(ОбъектИзБуфера.ВыгрузитьЗначения());
		ЭтаФорма.Модифицированность = Истина;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	ирКлиент.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура ТаблицаПриАктивизацииСтроки(Элемент)
	ирКлиент.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
КонецПроцедуры

ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.Массив");
РасширениеФайла = "VA_";
Уникальные = Истина;
ОписаниеТипов = Новый ОписаниеТипов();
Таблица.Колонки.Добавить("Значение", ОписаниеТипов);
