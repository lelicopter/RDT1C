﻿//Запомним ограничение типа
Перем МассивНередактируемыхТипов;

Процедура КнопкаВыполнитьНажатие(Кнопка)
	// Вставить содержимое обработчика.
КонецПроцедуры

Процедура КоманднаяПанель1ЗаписатьПараметрыСеанса(Кнопка)
	
	Для каждого Стр Из ТаблицаПараметровСеанса Цикл
		
		Если НЕ Стр.ПризнакМодификации Тогда
		
			Продолжить;
		                                                                               
		КонецЕсли;
		
		Если ПравоДоступа("Установка", Метаданные.ПараметрыСеанса[Стр.ИдентификаторПараметраСеанса], ПользователиИнформационнойБазы.ТекущийПользователь()) Тогда
		
			ПараметрыСеанса[Стр.ИдентификаторПараметраСеанса] = Стр.Значение;
			ЗаписьЖурналаРегистрации("Редактирование параметра сеанса", УровеньЖурналаРегистрации.Информация,
				Метаданные.ПараметрыСеанса[Стр.ИдентификаторПараметраСеанса], Стр.ЗначениеПараметраСеанса);
			Стр.ПризнакМодификации = Ложь;
			
		КонецЕсли; 
		
	КонецЦикла;
	Модифицированность = Ложь;
	
КонецПроцедуры

Процедура ПрочитатьПараметрыСеансаИзБазы()

	ТаблицаПараметровСеанса.Очистить();
	
	Для каждого ПарамСеанса Из Метаданные.ПараметрыСеанса Цикл
		
		Если НЕ ПравоДоступа("Чтение", ПарамСеанса, ПользователиИнформационнойБазы.ТекущийПользователь()) Тогда
			Продолжить;
		КонецЕсли;
		
		Если ПарамСеанса.Тип.Типы()[0] = Тип("ХранилищеЗначения") Тогда
		
			Продолжить;
		
		КонецЕсли; 
		
		НовСтр = ТаблицаПараметровСеанса.Добавить();
		НовСтр.ИдентификаторПараметраСеанса = ПарамСеанса.Имя;
		НовСтр.СинонимПараметраСеанса = ПарамСеанса.Синоним;
		НовСтр.ОписаниеТипов = ПарамСеанса.Тип;
		Попытка
			НовСтр.Значение = ПараметрыСеанса[ПарамСеанса.Имя];
			НовСтр.ЗначениеПараметраСеанса = ПараметрыСеанса[ПарамСеанса.Имя];
		Исключение
			НовСтр.ЗначениеПараметраСеанса = "<Не инициализирован>";
			НовСтр.Значение = НовСтр.ЗначениеПараметраСеанса;
		КонецПопытки; 
		НовСтр.ТипЗначения = ТипЗнч(НовСтр.Значение);
		НовСтр.РазрешеноИзменение = Истина
			И ПравоДоступа("Изменение", ПарамСеанса, ПользователиИнформационнойБазы.ТекущийПользователь())
	
	КонецЦикла;
	Модифицированность = Ложь;
	
КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	ПрочитатьПараметрыСеансаИзБазы();
КонецПроцедуры

Процедура ТаблицаПараметровСеансаПередНачаломДобавления(Элемент, Отказ, Копирование)
	Отказ = ИСТИНА;
КонецПроцедуры

Процедура ТаблицаПараметровСеансаПередУдалением(Элемент, Отказ)
	Отказ = ИСТИНА;
КонецПроцедуры

Процедура ТаблицаПараметровСеансаПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	Если ОтменаРедактирования Тогда
	
		Возврат;
	
	КонецЕсли;
	Элемент.ТекущаяКолонка.ЭлементУправления.ОграничениеТипа = Метаданные.ПараметрыСеанса[ЭлементыФормы.ТаблицаПараметровСеанса.ТекущиеДанные.ИдентификаторПараметраСеанса].Тип;
	ЭлементыФормы.ТаблицаПараметровСеанса.ТекущиеДанные.ПризнакМодификации = ИСТИНА;
	ЭтаФорма.Модифицированность = Истина;
КонецПроцедуры

Процедура ТаблицаПараметровСеансаПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	Если ДанныеСтроки.ПризнакМодификации = Истина Тогда
		ОформлениеСтроки.ЦветТекста = WebЦвета.КожаноКоричневый;
	КонецЕсли; 
	
	ирОбщий.ОформитьЯчейкуСРасширеннымЗначениемЛкс(ОформлениеСтроки.Ячейки.ЗначениеПараметраСеанса, ДанныеСтроки.Значение, Элемент.Колонки.ЗначениеПараметраСеанса);
	Если Ложь
		Или НЕ ДанныеСтроки.РазрешеноИзменение
	Тогда
		ОформлениеСтроки.Ячейки.ЗначениеПараметраСеанса.ТолькоПросмотр = Ложь;
		ОформлениеСтроки.Ячейки.ОформлениеЯчейки.ЦветФона = WebЦвета.СеребристоСерый;
	КонецЕсли;
	
	Если Истина
		И ДанныеСтроки.РазрешеноИзменение
		И ТипЗнч(ДанныеСтроки.ЗначениеПараметраСеанса) = Тип("Булево") 
	Тогда
		ОформлениеСтроки.Ячейки.ЗначениеПараметраСеанса.УстановитьФлажок(ДанныеСтроки.ЗначениеПараметраСеанса);
	КонецЕсли; 
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(Элемент, ОформлениеСтроки, ДанныеСтроки);

КонецПроцедуры

// <Описание функции>
//
// Параметры:
//  <Параметр1>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>;
//  <Параметр2>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>.
//
// Возвращаемое значение:
//               – <Тип.Вид> – <описание значения>
//                 <продолжение описания значения>;
//  <Значение2>  – <Тип.Вид> – <описание значения>
//                 <продолжение описания значения>.
//
Функция ПроверкаМодифицированностиФормы()

	Если ЭтаФорма.Модифицированность Тогда
		Ответ = Вопрос("Данные в форме были изменены. Сохранить изменения?", РежимДиалогаВопрос.ДаНетОтмена);
		Если Ответ = КодВозвратаДиалога.Отмена Тогда
			Возврат Ложь;
		ИначеЕсли Ответ = КодВозвратаДиалога.Да Тогда
			КоманднаяПанель1ЗаписатьПараметрыСеанса(0);
		КонецЕсли;
	КонецЕсли;
	Возврат Истина;

КонецФункции // ПроверкаМодифицированностиФормы()

Процедура КоманднаяПанель1Перечиать(Кнопка)
	
	Если Не ПроверкаМодифицированностиФормы() Тогда
		Возврат;
	КонецЕсли;
	ПрочитатьПараметрыСеансаИзБазы();
	
КонецПроцедуры

Процедура ТаблицаПараметровСеансаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	ТекДанные = Элемент.ТекущиеДанные;
	Элемент.Колонки.ЗначениеПараметраСеанса.ЭлементУправления.ОграничениеТипа = Метаданные.ПараметрыСеанса[Элемент.ТекущиеДанные.ИдентификаторПараметраСеанса].Тип;
КонецПроцедуры

Процедура правка(Кнопка)
	// Вставить содержимое обработчика.
КонецПроцедуры

Процедура ПриОткрытии()
	
	Если ЗначениеЗаполнено(НачальноеЗначениеВыбора) Тогда
		ТекущаяСтрока = ТаблицаПараметровСеанса.Найти(НачальноеЗначениеВыбора, "ИдентификаторПараметраСеанса");
		Если ТекущаяСтрока <> Неопределено Тогда
			ЭтаФорма.ЭлементыФормы.ТаблицаПараметровСеанса.ТекущаяСтрока = ТекущаяСтрока;
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Отказ = Не ПроверкаМодифицированностиФормы();
	
КонецПроцедуры

Процедура КоманднаяПанель1ОПодсистеме(Кнопка)
	ирОбщий.ОткрытьСправкуПоПодсистемеЛкс(ЭтотОбъект);
КонецПроцедуры

Процедура КоманднаяПанель1Исследовать(Кнопка)
	
	ирОбщий.ИсследоватьЛкс(ТаблицаПараметровСеанса,, Истина);
	
КонецПроцедуры

Процедура ТаблицаПараметровСеансаЗначениеПараметраСеансаОткрытие(Элемент, СтандартнаяОбработка)
	
	ВыбраннаяСтрока = ЭлементыФормы.ТаблицаПараметровСеанса.ТекущаяСтрока;
	Если МассивНередактируемыхТипов.Найти(ТипЗнч(ВыбраннаяСтрока.Значение)) <> Неопределено Тогда
		ирОбщий.ИсследоватьЛкс(ВыбраннаяСтрока.Значение);
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ТаблицаПараметровСеансаЗначениеПараметраСеансаПриИзменении(Элемент)
	
	ВыбраннаяСтрока = ЭлементыФормы.ТаблицаПараметровСеанса.ТекущаяСтрока;
	ВыбраннаяСтрока.Значение = Элемент.Значение;
	ВыбраннаяСтрока.ТипЗначения = ТипЗнч(ВыбраннаяСтрока.Значение);
	
КонецПроцедуры

Процедура ТаблицаПараметровСеансаПриИзмененииФлажка(Элемент, Колонка)
	
	ирОбщий.ИнтерактивноЗаписатьВКолонкуТабличногоПоляЛкс(Элемент, Колонка, Не Элемент.ТекущаяСтрока[Колонка.Данные]);

КонецПроцедуры

Процедура ТаблицаПараметровСеансаЗначениеПараметраСеансаОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	ирОбщий.ПолеВвода_ОкончаниеВводаТекстаЛкс(Элемент, Текст, Значение, СтандартнаяОбработка, ЭлементыФормы.ТаблицаПараметровСеанса.ТекущаяСтрока.Значение);
	
КонецПроцедуры

Процедура КоманднаяПанель1ЖурналРегистрации(Кнопка)
	
	ТекущаяСтрока = ЭлементыФормы.ТаблицаПараметровСеанса.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	АнализЖурналаРегистрации = ирОбщий.ПолучитьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирАнализЖурналаРегистрации");
	#Если _ Тогда
		АнализЖурналаРегистрации = Обработки.ирАнализЖурналаРегистрации.Создать();
	#КонецЕсли
	АнализЖурналаРегистрации.ОткрытьСПараметром("Метаданные", "ПараметрСеанса." + ТекущаяСтрока.ИдентификаторПараметраСеанса);

КонецПроцедуры

Процедура ТаблицаПараметровСеансаЗначениеПараметраСеансаНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ЗначениеИзменено = ирОбщий.ПолеВводаРасширенногоЗначения_НачалоВыбораЛкс(ЭлементыФормы.ТаблицаПараметровСеанса, СтандартнаяОбработка,
		ЭлементыФормы.ТаблицаПараметровСеанса.ТекущаяСтрока.Значение);
	Если ЗначениеИзменено Тогда
		ВыбраннаяСтрока = ЭлементыФормы.ТаблицаПараметровСеанса.ТекущаяСтрока;
		ВыбраннаяСтрока.Значение = ВыбраннаяСтрока.Значение;
		ВыбраннаяСтрока.ТипЗначения = ТипЗнч(ВыбраннаяСтрока.Значение);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ирОбщий.ФормаОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура КлсУниверсальнаяКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработчикОжиданияСПараметрамиЛкс() Экспорт 
	
	ирОбщий.ОбработчикОжиданияСПараметрамиЛкс();

КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирРедакторПараметровСеанса.Форма.Форма");
МассивНередактируемыхТипов = Новый массив;
МассивНередактируемыхТипов.Добавить(Тип("ФиксированныйМассив"));
МассивНередактируемыхТипов.Добавить(Тип("ФиксированнаяСтруктура"));
МассивНередактируемыхТипов.Добавить(Тип("ФиксированноеСоответствие"));
МассивНередактируемыхТипов.Добавить(Тип("ХранилищеЗначения"));
МассивНередактируемыхТипов.Добавить(Тип("УникальныйИдентификатор"));

ТаблицаПараметровСеанса.Колонки.Добавить("Значение");
