﻿Перем КорневаяСтрока;
Перем БазовоеВыражение Экспорт;
Перем _Значение_ Экспорт;
Перем МаркерСловаЗначения;
Перем СтруктураТипаЗначения;
Перем мСписокПоследнихИспользованныхВыражений;
Перем ИмяТекущегоСвойства Экспорт;
Перем мАвтоКонтекстнаяПомощь;
Перем ИсследуемоеЗначениеЗаменено; // Признак того, что исследуемое значение (ссылка на объект в памяти) было заменено (в результате редактирования в спец. редакторе)
Перем мПлатформа;

Процедура УстановитьИсследуемоеЗначение(пЗначение, пПутьКДанным = Неопределено, пСтруктураТипа = Неопределено) Экспорт 

	ИсследуемоеЗначениеЗаменено = Ложь;
	БазовоеВыражение = пПутьКДанным;
	ЭтаФорма[МаркерСловаЗначения] = пЗначение;
	Если БазовоеВыражение = Неопределено Тогда
		Выражение = МаркерСловаЗначения;
	Иначе
		Выражение = БазовоеВыражение;
	КонецЕсли;
	СтруктураТипаЗначения = пСтруктураТипа;
	ЭтаФорма.ЭлементыФормы.Выражение.ТолькоПросмотр = БазовоеВыражение <> Неопределено;
	ЭтаФорма.ЭлементыФормы.КоманднаяПанельДерева.Кнопки.ГлобальныйКонтекст.Доступность = (БазовоеВыражение = Неопределено);

КонецПроцедуры // УстановитьИсследуемоеЗначение()

Функция ПолучитьПолныйПуть(СтрокаДерева, Знач КромеВерхнего = Ложь)

	Результат = "";
	Если СтрокаДерева = Неопределено Тогда
	ИначеЕсли Истина
		И КромеВерхнего
		И СтрокаДерева.Родитель = Неопределено
	Тогда
	Иначе
		ПолныйПутьКРодителю = ПолучитьПолныйПуть(СтрокаДерева.Родитель, КромеВерхнего);
		Если ПолныйПутьКРодителю <> "" Тогда
			Результат = ПолныйПутьКРодителю;
		КонецЕсли;
		Если СтрокаДерева.ТипСлова <> "Группа" Тогда
			Если Результат <> "" Тогда
				Результат = Результат + ".";
			КонецЕсли; 
			Результат = Результат + СтрокаДерева.Слово; 
			Если СтрокаДерева.ТипСлова = "Метод" Тогда
				Результат = Результат + "()";
			КонецЕсли;
		КонецЕсли; 
	КонецЕсли;
	Возврат Результат;

КонецФункции // ПолучитьПолныйПуть()

Процедура ЗаполнитьСтрокуСлова(СтрокаДерева)

	СтрокаДерева.Строки.Очистить();
	ЗначениеСтроки = СтрокаДерева.Значение;
	Если Не СтрокаДерева.Успех Тогда 
		Если СтрокаДерева.ТипСлова <> "Метод" Тогда
			ТекстРодителя = "";
			Если СтрокаДерева.Родитель <> Неопределено Тогда
				ЗначениеРодителя = СтрокаДерева.Родитель.Значение;
				//Если НРег(ЗначениеРодителя) <> НРег("<ГлобальныйКонтекст>") Тогда
				Если СтрокаДерева.Родитель.ТипСлова <> "Группа" Тогда
					ТекстРодителя = "ЗначениеРодителя.";
				КонецЕсли; 
			КонецЕсли;
			Попытка
				ДочернееЗначение = Вычислить(ТекстРодителя + СтрокаДерева.Слово);
				НовыйУспех = Истина;
			Исключение
				ДочернееЗначение = ОписаниеОшибки();
				НовыйУспех = Ложь;
			КонецПопытки;
		Иначе
			НовыйУспех = Неопределено;
		КонецЕсли; 
	Иначе
		НовыйУспех = Истина;
		ДочернееЗначение = ЗначениеСтроки;
	КонецЕсли; 
	УстановитьЗначениеСловаВСтроке(СтрокаДерева, НовыйУспех, ДочернееЗначение);
	
	Если СтрокаДерева.ТипСлова <> "Группа" Тогда
		Если Ложь
			Или Не СтрокаДерева.Успех 
			Или СтрокаДерева.Значение = Неопределено
			Или СтрокаДерева.Значение = Null
		Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли; 
	
	Если СтрокаДерева.СтруктураТипа = Неопределено Тогда 
		Если Истина
			И СтрокаДерева.ТаблицаСтруктурТипов <> Неопределено
			И СтрокаДерева.ТаблицаСтруктурТипов.Количество() = 1 
		Тогда
			СтрокаДерева.СтруктураТипа = СтрокаДерева.ТаблицаСтруктурТипов[0];
		Иначе
			СтруктураТипаЗначения = мПлатформа.ПолучитьСтруктуруТипаИзЗначения(СтрокаДерева.Значение, ,
				Новый Структура("Метаданные", СтрокаДерева.Значение));
			Если СтрокаДерева.ТаблицаСтруктурТипов <> Неопределено Тогда
				НайденоСовпадение = Ложь;
				Для Каждого СтруктураТипа Из СтрокаДерева.ТаблицаСтруктурТипов Цикл
					Если Истина
						И СтруктураТипаЗначения.ИмяОбщегоТипа = СтруктураТипа.ИмяОбщегоТипа 
					Тогда
						СтрокаДерева.СтруктураТипа = СтруктураТипа;
						НайденоСовпадение = Истина;
					КонецЕсли;
				КонецЦикла;
				Если Не НайденоСовпадение Тогда
					СтрокаДерева.СтруктураТипа = СтруктураТипаЗначения;
				КонецЕсли; 
			КонецЕсли; 
		КонецЕсли;
	КонецЕсли;
	
	Если Истина
		И СтрокаДерева.СтруктураТипа <> Неопределено
		И (Ложь // Возможно эту ветку вообще лучше отключить
			Или СтрокаДерева.СтруктураТипа.Метаданные = Неопределено
			Или ТипЗнч(СтрокаДерева.СтруктураТипа.Метаданные) = ТипЗнч(СтрокаДерева.Значение)
			// "метаданные = метаданные" дает ложь
			Или ТипЗнч(СтрокаДерева.СтруктураТипа.Метаданные) = Тип("ОбъектМетаданныхКонфигурация"))
		И (Ложь
			Или мПлатформа.мМассивТиповВключающихМетаданные.Найти(СтрокаДерева.ТипЗначения) <> Неопределено
			Или мПлатформа.мМассивТиповЭлементовУправления.Найти(СтрокаДерева.ТипЗначения) <> Неопределено)
	Тогда
		СтрокаДерева.СтруктураТипа.Метаданные = СтрокаДерева.Значение;
	КонецЕсли;
	ЭтоАгрегатноеЗначение = Истина;
	//Если Выражение <> "<ГлобальныйКонтекст>" Тогда
	Если СтрокаДерева.ТипСлова <> "Группа" Тогда
		// %%%% Опасный прием
		СтрокаДерева.СтруктураТипа = мПлатформа.ПолучитьСтруктуруТипаИзЗначения(СтрокаДерева.Значение, Ложь, СтрокаДерева.СтруктураТипа);
		
		// Способ 1
		Попытка
			Пустышка = СтрокаДерева.Значение.а;
		Исключение
			ОписаниеОшибки = ОписаниеОшибки();
			Если Найти(ОписаниеОшибки, "объектного типа") > 0 Тогда
				ЭтоАгрегатноеЗначение = Ложь;
			КонецЕсли; 
		КонецПопытки; 
		
		//// Способ 2
		//КоличествоДочерних = ПолучитьТаблицуИнформатора(ДочернееЗначение, , ФЛАГ_ЗАПОЛНЕНИЯ_ПРОВЕРИТЬ_СУЩЕСТВОВАНИЕ_СВОЙСТВ_И_МЕТОДОВ);
		//ЭтоАгрегатноеЗначение = (КоличествоДочерних > 0);
	КонецЕсли; 
	
	Если ЭтоАгрегатноеЗначение Тогда 
		СтрокаДерева.Строки.Добавить();
	КонецЕсли; 

КонецПроцедуры // ЗаполнитьСтрокуСлова()

Процедура мВычислитьВыражение() 

	//ОбновитьСписокПоследнихИспользованныхВыражений();
	ДеревоЗначений.Строки.Очистить();
	КорневаяСтрока = ДеревоЗначений.Строки.Добавить();
	КорневаяСтрока.Слово = Выражение;
	Если Выражение = "<ГлобальныйКонтекст>" Тогда
		Значение = Выражение;
		КорневаяСтрока.ТипСлова = "Группа";
	Иначе
		КорневаяСтрока.ТипСлова = "Свойство";
		Если Истина
			И БазовоеВыражение <> Неопределено
			И Найти(Выражение, БазовоеВыражение) = 1
		Тогда
			ВыражениеДляВычисления = "_Значение_" + Сред(Выражение, СтрДлина(БазовоеВыражение) + 1);
		Иначе
			ВыражениеДляВычисления = Выражение;
		КонецЕсли; 
		Попытка
			Значение = Вычислить(ВыражениеДляВычисления);
		Исключение
			//КорневаяСтрока.ПредставлениеЗначения = ирОбщий.ПолучитьИнформациюОбОшибкеБезВерхнегоМодуляЛкс(ИнформацияОбОшибке());
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			Если ИнформацияОбОшибке.Причина <> Неопределено Тогда
				ОписаниеОшибки = ИнформацияОбОшибке.Описание + ": " + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке.Причина);
			Иначе
				ОписаниеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
			КонецЕсли; 
			КорневаяСтрока.ПредставлениеЗначения = ОписаниеОшибки;
			КорневаяСтрока.ТипЗначения = "<Ошибка>";
			КорневаяСтрока.ПредставлениеТипаЗначения = КорневаяСтрока.ТипЗначения;
			КорневаяСтрока.ИмяТипаЗначения = КорневаяСтрока.ТипЗначения;
			ЭлементыФормы.ДеревоЗначений.Колонки.ПредставлениеЗначения.ВысотаЯчейки = 10;
			Возврат;
		КонецПопытки;
	КонецЕсли; 
	Если СтруктураТипаЗначения <> Неопределено Тогда
		КорневаяСтрока.СтруктураТипа = СтруктураТипаЗначения;
	Иначе
		ШаблонСтруктуры = Новый Структура;
		лТипЗначения = ТипЗнч(Значение);
		Если Ложь
			Или мПлатформа.мМассивТиповВключающихМетаданные.Найти(лТипЗначения) <> Неопределено
			Или мПлатформа.мМассивТиповЭлементовУправления.Найти(лТипЗначения) <> Неопределено
		Тогда 
			ШаблонСтруктуры.Вставить("Метаданные", Значение);
		ИначеЕсли лТипЗначения = Тип("ОбщийМодуль") Тогда 
			ОбъектМД = Метаданные.ОбщиеМодули.Найти(Выражение);
			Если ОбъектМД <> Неопределено Тогда
				ШаблонСтруктуры.Вставить("Метаданные", ОбъектМД);
			КонецЕсли; 
		КонецЕсли;
		КорневаяСтрока.СтруктураТипа = мПлатформа.ПолучитьСтруктуруТипаИзЗначения(Значение, , ШаблонСтруктуры);
	КонецЕсли;
	//КорневаяСтрока.ПредставлениеТипаЗначения = ТипЗнч(Значение);
	//КорневаяСтрока.ТипЗначения = ТипЗнч(Значение);
	//КорневаяСтрока.ПредставлениеЗначения = ирОбщий.ПолучитьРасширенноеПредставлениеЗначенияЛкс(Значение);
	Если КорневаяСтрока.ТипСлова <> "Группа" Тогда
		КорневаяСтрока.Значение = Значение;
	КонецЕсли; 
	КорневаяСтрока.Успех = Истина;
	ЗаполнитьСтрокуСлова(КорневаяСтрока);
	УстановитьЗначениеСловаВСтроке(КорневаяСтрока, Истина, Значение);
	ТекущаяСтрока = КорневаяСтрока;
	Если КорневаяСтрока.Строки.Количество() > 0 Тогда 
		НоваяВысотаЯчейки = 1;
		Если ЗначениеЗаполнено(ИмяТекущегоСвойства) Тогда
			ЭлементыФормы.ДеревоЗначений.Развернуть(КорневаяСтрока);
			СтрокаСвойства = КорневаяСтрока.Строки.Найти(ИмяТекущегоСвойства, "Слово");
			Если СтрокаСвойства <> Неопределено Тогда
				ТекущаяСтрока = СтрокаСвойства;
			КонецЕсли; 
			ИмяТекущегоСвойства = "";
		КонецЕсли; 
	Иначе
		НоваяВысотаЯчейки = 10;
	КонецЕсли; 
	ЭлементыФормы.ДеревоЗначений.Колонки.ПредставлениеЗначения.ВысотаЯчейки = НоваяВысотаЯчейки;
	ЭлементыФормы.ДеревоЗначений.ТекущаяСтрока = ТекущаяСтрока;

КонецПроцедуры // Вычислить()

Процедура ВыражениеОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	СтруктураТипаЗначения = Неопределено;
	мВычислитьВыражение();
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	//УстановитьСписокПоследнихИспользованныхВыражений();
	Если Выражение <> "" Тогда
		мВычислитьВыражение();
	Иначе
		//УстановитьГлобальныйКонтекст(); На больших конфигурациях долго отрабатывает из-за компиляции общих модулей
	КонецЕсли;
	
КонецПроцедуры

Процедура ДеревоЗначенийПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
	ЯчейкаЗначения = ОформлениеСтроки.Ячейки.ПредставлениеЗначения;
	Если Истина
		И ДанныеСтроки.ТипСлова = "Метод" 
		И ДанныеСтроки.Успех = Ложь
	Тогда
		ЯчейкаЗначения.ЦветТекста = ирОбщий.ЦветТекстаНеактивностиЛкс();
	КонецЕсли;
	ЯчейкаКартинки = ОформлениеСтроки.Ячейки.Слово;
	ЯчейкаКартинки.ОтображатьКартинку = Истина;
	ИндексКартинки = ирОбщий.ПолучитьИндексКартинкиСловаПодсказкиЛкс(ДанныеСтроки);
	Если ИндексКартинки >= 0 Тогда
		ЯчейкаКартинки.ИндексКартинки = ИндексКартинки;
	КонецЕсли; 
	
	Если ДанныеСтроки.Успех Тогда
		Если ТипЗнч(ДанныеСтроки.Значение) = Тип("Строка") Тогда
			ОформлениеСтроки.Ячейки.ПредставлениеЗначения.УстановитьТекст("""" + ДанныеСтроки.Значение + """");
		Иначе
			ирОбщий.ОформитьЯчейкуСРасширеннымЗначениемЛкс(ОформлениеСтроки.Ячейки.ПредставлениеЗначения, ДанныеСтроки.Значение, Элемент.Колонки.ПредставлениеЗначения);
		КонецЕсли; 
	КонецЕсли; 
	Если ДанныеСтроки.КоличествоЭлементов <> Неопределено Тогда
		КоличествоЭлементов = ОформлениеСтроки.Ячейки.КоличествоЭлементов;
		КоличествоЭлементов.ЦветФона = Новый Цвет(230, 240, 240);
	КонецЕсли; 

КонецПроцедуры

Процедура ДеревоЗначенийПередРазворачиванием(Элемент, СтрокаДерева, Отказ)
	
	Если Истина
		И СтрокаДерева.ТипСлова = "Группа" 
		И СтрокаДерева.Слово <> "<ГлобальныйКонтекст>"
	Тогда
		Возврат;
	КонецЕсли; 
	Отказ = Истина;
	ЗаполнитьДочерниеСтроки(СтрокаДерева);
	Отказ = Ложь;
	
КонецПроцедуры

Процедура ЗаполнитьДочерниеСтроки(Знач СтрокаДерева)
	
	//Перем ВнутренняяСтрокаСлова, ВнутренняяТаблицаСлов, ЗначениеДляИнформатора, ЗначениеСвойства, Индикатор, МетодыОтИнформатора, НоваяСтрока, СвойстваОтИнформатора, СтрокаМетодов, СтрокаОписанияМетода, СтрокаОписанияСвойства, СтрокаПредставления, СтруктураТипа;
	
	СтрокаДерева.Строки.Очистить();
	ВнутренняяТаблицаСлов = мПлатформа.ПолучитьТаблицуСловСтруктурыТипа(СтрокаДерева.СтруктураТипа);
	ВнутренняяТаблицаСлов.Сортировать("Слово, ТипСлова");
	Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(ВнутренняяТаблицаСлов.Количество());
	СтрокаМетодов = Неопределено;
	Для Каждого ВнутренняяСтрокаСлова Из ВнутренняяТаблицаСлов Цикл
		ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
		Если ВнутренняяСтрокаСлова.ТипСлова = "Метод" Тогда 
			Если СтрокаМетодов = Неопределено Тогда
				СтрокаМетодов = СтрокаДерева.Строки.Вставить(0);
				СтрокаМетодов.Слово = "<Методы>";
				СтрокаМетодов.ТипСлова = "Группа";
			КонецЕсли; 
			НоваяСтрока = СтрокаМетодов.Строки.Добавить();
			НоваяСтрока.ПредставлениеЗначения = "<Двойной клик для вычисления>";
		Иначе
			НоваяСтрока = СтрокаДерева.Строки.Добавить();
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ВнутренняяСтрокаСлова);
		СтрокаПредставления = "";
		Если ВнутренняяСтрокаСлова.ТаблицаСтруктурТипов <> Неопределено Тогда
			НоваяСтрока.ТаблицаСтруктурТипов = ВнутренняяСтрокаСлова.ТаблицаСтруктурТипов;
			Для Каждого СтруктураТипа Из НоваяСтрока.ТаблицаСтруктурТипов Цикл
				СтрокаПредставления = СтрокаПредставления + ", " + мПлатформа.ПолучитьСтрокуКонкретногоТипа(СтруктураТипа);
			КонецЦикла;
			НоваяСтрока.ПредставлениеДопустимыхТипов = Сред(СтрокаПредставления, 3);
		КонецЕсли; 
		ЗаполнитьСтрокуСлова(НоваяСтрока);
	КонецЦикла;
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс();

КонецПроцедуры

Процедура ВыражениеПриИзменении(Элемент)

	СтруктураТипаЗначения = Неопределено;
	мВычислитьВыражение();
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма, 40);
	
КонецПроцедуры

Процедура ДеревоЗначенийПриАктивизацииСтроки(Элемент = Неопределено)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	Элемент = ЭлементыФормы.ДеревоЗначений;
	Если Элемент.ТекущаяСтрока <> Неопределено Тогда
		Выражение = ПолучитьПолныйПуть(Элемент.ТекущаяСтрока);
	КонецЕсли;
	Элемент.Колонки.ПредставлениеЗначения.ТолькоПросмотр = Ложь
		Или Элемент.ТекущаяСтрока = Неопределено
		//Или Элемент.ТекущаяСтрока.Родитель = Неопределено
		Или Элемент.ТекущаяСтрока.ТипСлова = "Метод";
	//ЭтаФорма.ЭлементыФормы.КоманднаяПанельДерева.Кнопки.КонсольКода.Доступность = Истина
	//	И Элемент.ТекущаяСтрока <> Неопределено
	//	И Элемент.ТекущаяСтрока.ТипСлова = "Метод";
	Если мАвтоКонтекстнаяПомощь Тогда
		КоманднаяПанельДереваСправка();
	КонецЕсли; 
	
КонецПроцедуры

Процедура УстановитьЗначениеСловаВСтроке(СтрокаДерева, Успех, НовоеЗначение)
	
	СтрокаДерева.Успех = Успех;
	Если СтрокаДерева.ТипСлова = "Группа" Тогда
		Возврат;
	КонецЕсли;
	Если Успех = Истина Тогда
		СтрокаДерева.Значение = НовоеЗначение;
		//СтрокаДерева.ПредставлениеЗначения = ирОбщий.ПолучитьРасширенноеПредставлениеЗначенияЛкс(НовоеЗначение);
		СтрокаДерева.ПредставлениеЗначения = НовоеЗначение;
		СтрокаДерева.ТипЗначения = ТипЗнч(НовоеЗначение);
		СтрокаДерева.КоличествоЭлементов = ирОбщий.ПолучитьКоличествоЭлементовКоллекцииЛкс(НовоеЗначение);
		СтрокаДерева.ПредставлениеТипаЗначения = ТипЗнч(НовоеЗначение);
		ирОбщий.ОбновитьТипЗначенияВСтрокеТаблицыЛкс(СтрокаДерева,,, "ПредставлениеТипаЗначения");
	ИначеЕсли Успех = Ложь Тогда 
		СтрокаДерева.Значение = НовоеЗначение;
		СтрокаДерева.ПредставлениеЗначения = НовоеЗначение;
		СтрокаДерева.ТипЗначения = "<Ошибка>";
		СтрокаДерева.КоличествоЭлементов = Неопределено;
		СтрокаДерева.ПредставлениеТипаЗначения = СтрокаДерева.ТипЗначения;
		СтрокаДерева.ИмяТипаЗначения = СтрокаДерева.ТипЗначения;
	КонецЕсли;
	
КонецПроцедуры	//УстановитьЗначениеСловаВСтроке

Процедура ДеревоЗначенийВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если ВыбраннаяСтрока.Успех Тогда
		ОткрытьТекущийЭлемент(Колонка = Элемент.Колонки.КоличествоЭлементов, СтандартнаяОбработка);
	ИначеЕсли ВыбраннаяСтрока.ТипСлова = "Метод" Тогда
		СтандартнаяОбработка = Ложь;
		ЗначениеРодителя = ВыбраннаяСтрока.Родитель.Родитель.Значение;
		ТекстРодителя = "";
		//Если НРег(ЗначениеРодителя) <> НРег("<ГлобальныйКонтекст>") Тогда
		Если ВыбраннаяСтрока.Родитель.Родитель.ТипСлова <> "Группа" Тогда
			ТекстРодителя = "ЗначениеРодителя.";
		КонецЕсли; 
		Попытка
			ДочернееЗначение = Вычислить(ТекстРодителя + ВыбраннаяСтрока.Слово + "()");
			Успех = Истина;
		Исключение
			//ИнформацияОбОшибке = ИнформацияОбОшибке();
			//Если ИнформацияОбОшибке.Причина <> Неопределено Тогда
			//	ИнформацияОбОшибке = ИнформацияОбОшибке.Причина;
			//КонецЕсли; 
			//ДочернееЗначение = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
			ДочернееЗначение = ирОбщий.ПолучитьИнформациюОбОшибкеБезВерхнегоМодуляЛкс(ИнформацияОбОшибке());
			Успех = Ложь;
		КонецПопытки;
		УстановитьЗначениеСловаВСтроке(ВыбраннаяСтрока, Успех, ДочернееЗначение);
		ЗаполнитьСтрокуСлова(ВыбраннаяСтрока);
	Иначе
		ОткрытьТекущийЭлемент(Колонка = Элемент.Колонки.КоличествоЭлементов, СтандартнаяОбработка);
    КонецЕсли;
	
КонецПроцедуры

Процедура ОткрытьТекущийЭлемент(ПредпочитатьИсследовательКоллекций = Ложь, СтандартнаяОбработка = Ложь)

	ТекущаяСтрока = ЭлементыФормы.ДеревоЗначений.ТекущаяСтрока;
	Если Ложь
		Или ТекущаяСтрока = Неопределено 
		Или ТекущаяСтрока.ТипСлова = "Группа"
	Тогда
		Возврат;
	КонецЕсли; 
	Если Ложь
		//Или ТекущаяСтрока.ТипЗначения = Тип("Строка")
		Или Не ТекущаяСтрока.Успех 
	Тогда
		СтандартнаяОбработка = Ложь;
		//ирОбщий.ОткрытьТекстЛкс(ТекущаяСтрока.Значение,,, Истина);
		ирОбщий.ОткрытьТекстЛкс(ТекущаяСтрока.ПредставлениеЗначения, , , Истина);
		Возврат;
	КонецЕсли;
	Если Ложь
		Или ТекущаяСтрока.ТипЗначения = Тип("Запрос")
		Или ТекущаяСтрока.ТипЗначения = Тип("ПостроительЗапроса")
		Или ТекущаяСтрока.ТипЗначения = Тип("ПостроительОтчета")
		Или ТекущаяСтрока.ТипЗначения = Тип("СхемаКомпоновкиДанных")
		Или ТекущаяСтрока.ТипЗначения = Тип("ДинамическийСписок")
		Или ТекущаяСтрока.ТипЗначения = Тип("МакетКомпоновкиДанных")
	Тогда
		СтандартнаяОбработка = Ложь;
		ирОбщий.ОтладитьЛкс(ТекущаяСтрока.Значение);
		Возврат;
	ИначеЕсли Ложь
		Или ТекущаяСтрока.ТипЗначения = Тип("НастройкиКомпоновкиДанных")
	Тогда
		СтандартнаяОбработка = Ложь;
		КонсольКомпоновкиДанных = ирОбщий.ПолучитьОбъектПоПолномуИмениМетаданныхЛкс("Отчет.ирКонсольКомпоновокДанных");
		#Если Сервер И Не Сервер Тогда
			КонсольКомпоновкиДанных = Отчеты.ирКонсольКомпоновокДанных.Создать();
		#КонецЕсли
		Результат = КонсольКомпоновкиДанных.ОткрытьДляОтладки(, ТекущаяСтрока.Значение);
		Возврат;
	КонецЕсли;
	ТипЗначения = ТипЗнч(ТекущаяСтрока.Значение);
	XMLТип = XMLТип(ТипЗначения);
	Если XMLТип <> Неопределено Тогда 
		Если ирОбщий.ЛиТипСсылкиБДЛкс(ТипЗначения) > 0 Тогда 
			СтандартнаяОбработка = Ложь;
			ирОбщий.ОткрытьСсылкуВРедактореОбъектаБДЛкс(ТекущаяСтрока.Значение);
			Возврат;
		ИначеЕсли ирОбщий.ЛиТипОбъектаБДЛкс(ТипЗначения) > 0 Тогда 
			СтандартнаяОбработка = Ложь;
			ирОбщий.ОткрытьОбъектВРедактореОбъектаБДЛкс(ТекущаяСтрока.Значение);
			Возврат;
		КонецЕсли; 
	КонецЕсли; 
	Если Ложь
		Или ТекущаяСтрока.ТипЗначения = Тип("МоментВремени")
		Или ТекущаяСтрока.ТипЗначения = Тип("Граница")
		Или ТекущаяСтрока.ТипЗначения = Тип("УникальныйИдентификатор")
		Или ТекущаяСтрока.ТипЗначения = Тип("Строка")
		Или ТекущаяСтрока.ТипЗначения = Тип("ТабличныйДокумент")
		Или ТекущаяСтрока.ТипЗначения = Тип("ДеревоЗначений")
		Или ТекущаяСтрока.ТипЗначения = Тип("ДвоичныеДанные")
		Или ТекущаяСтрока.ТипЗначения = Тип("ХранилищеЗначения")
		Или (Истина
			И Не ПредпочитатьИсследовательКоллекций
			И (Ложь
				Или ТекущаяСтрока.ТипЗначения = Тип("Массив")
				Или ТекущаяСтрока.ТипЗначения = Тип("ФиксированныйМассив")
				Или ТекущаяСтрока.ТипЗначения = Тип("СписокЗначений")
				Или ТекущаяСтрока.ТипЗначения = Тип("ТаблицаЗначений")))
	Тогда
		Если ирОбщий.ЯчейкаТабличногоПоляРасширенногоЗначения_ВыборЛкс(ЭлементыФормы.ДеревоЗначений, СтандартнаяОбработка, ТекущаяСтрока.Значение,, Истина) Тогда 
			УстановитьЗначениеСловаВСтроке(ТекущаяСтрока, Истина, ТекущаяСтрока.Значение);
		КонецЕсли; 
		Возврат;
	КонецЕсли;
	Если ТекущаяСтрока.ТипЗначения = Тип("ОбъектМетаданных") Тогда 
		СтандартнаяОбработка = Ложь;
		ирОбщий.ОткрытьОбъектМетаданныхЛкс(ТекущаяСтрока.Значение);
	КонецЕсли; 
	Если ТекущаяСтрока.СтруктураТипа = Неопределено Тогда
		Возврат;
	КонецЕсли;
	СтрокаОписанияСлова = ТекущаяСтрока.СтруктураТипа.СтрокаОписания;
	Если СтрокаОписанияСлова = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если СтрокаОписанияСлова.Владелец().Колонки.Найти("ТипЭлементаКоллекции") = Неопределено Тогда
		ПолучитьСтруктуруТипаИзЗначения = Истина;
		Если ЗначениеЗаполнено(СтрокаОписанияСлова.ТипЗначения) Тогда
			СтруктураКлюча = Новый Структура("БазовыйТип, ЯзыкПрограммы", СтрокаОписанияСлова.ТипЗначения, 0);
			НайденныеСтроки = мПлатформа.ТаблицаОбщихТипов.НайтиСтроки(СтруктураКлюча);
			Если НайденныеСтроки.Количество() > 0 Тогда
				СтрокаОписанияСлова = НайденныеСтроки[0];
				ПолучитьСтруктуруТипаИзЗначения = Ложь;
			КонецЕсли;
		КонецЕсли; 
		Если ПолучитьСтруктуруТипаИзЗначения Тогда
			СтруктураКонкретногоТипа = мПлатформа.ПолучитьСтруктуруТипаИзЗначения(ТекущаяСтрока.Значение);
			Если Не ирОбщий.СтрокиРавныЛкс(ирОбщий.ПолучитьПервыйФрагментЛкс(СтруктураКонкретногоТипа.ИмяОбщегоТипа), "COMОбъект") Тогда
				СтруктураКлюча = Новый Структура("Слово, ЯзыкПрограммы", СтруктураКонкретногоТипа.ИмяОбщегоТипа, 0);
				НайденныеСтроки = мПлатформа.ТаблицаОбщихТипов.НайтиСтроки(СтруктураКлюча);
				Если НайденныеСтроки.Количество() > 0 Тогда
					СтрокаОписанияСлова = НайденныеСтроки[0];
				Иначе
					Возврат;
				КонецЕсли;
			КонецЕсли; 
		КонецЕсли;
	КонецЕсли;
	
	ЭтоКоллекция = ирОбщий.ЭтоКоллекцияЛкс(ТекущаяСтрока.Значение);
	СтруктураТипаКоллекции = мПлатформа.ПолучитьНовуюСтруктуруТипа();
	ЗаполнитьЗначенияСвойств(СтруктураТипаКоллекции, ТекущаяСтрока.СтруктураТипа, , "СтрокаОписания");
	СтруктураТипаКоллекции.СтрокаОписания = СтрокаОписанияСлова;
	//Если СтрокаОписанияСлова.ТипЭлементаКоллекции <> "" Тогда 
	Если ЭтоКоллекция Тогда 
		СтандартнаяОбработка = Ложь;
		Форма = ПолучитьФорму("ИсследовательКоллекций", ЭтаФорма, Выражение);
		Форма.УстановитьИсследуемоеЗначение(ТекущаяСтрока.Значение, Выражение, СтруктураТипаКоллекции);
		Форма.Открыть();
	КонецЕсли;

КонецПроцедуры // ОткрытьТекущийЭлемент()

Процедура КоманднаяПанельДереваОткрыть(Кнопка)
	
	ОткрытьТекущийЭлемент();
	
КонецПроцедуры

Процедура КоманднаяПанельДереваСправка(Кнопка = Неопределено)
	
	ТекущаяСтрока = ЭлементыФормы.ДеревоЗначений.ТекущаяСтрока;
	Если Ложь
		Или ТекущаяСтрока = Неопределено 
		Или ТекущаяСтрока.ТипСлова = "Группа"
	Тогда
		Возврат;
	КонецЕсли;
	Если Не ТекущаяСтрока.Успех Тогда
		СтруктураЦикла = Новый Соответствие;
		СтруктураЦикла.Вставить("Фактические типы:", ТекущаяСтрока.ТаблицаСтруктурТипов);
		мПлатформа.ВыбратьСтрокуОписанияИзМассиваСтруктурТипов(СтруктураЦикла, , ЭтаФорма);
	Иначе
		СтруктураТипа = ТекущаяСтрока.СтруктураТипа;
		Если СтруктураТипа = Неопределено Тогда
			Если ТекущаяСтрока.ТаблицаСтруктурТипов.Количество() > 0 Тогда
				СтруктураТипа = ТекущаяСтрока.ТаблицаСтруктурТипов[0];
			КонецЕсли; 
		КонецЕсли; 
		Если СтруктураТипа <> Неопределено Тогда
			СтрокаОписания = СтруктураТипа.СтрокаОписания;
			Если СтрокаОписания <> Неопределено Тогда
				ирОбщий.ОткрытьСтраницуСинтаксПомощникаЛкс(СтрокаОписания.ПутьКОписанию, , ЭтаФорма);
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли;

КонецПроцедуры

Процедура ДеревоЗначенийПередНачаломИзменения(Элемент, Отказ)
	
	ЭлементыФормы.ДеревоЗначений.ТекущаяКолонка = ЭлементыФормы.ДеревоЗначений.Колонки.ПредставлениеЗначения;
	
КонецПроцедуры

Процедура КоманднаяПанельДереваОПодсистеме(Кнопка)
	ирОбщий.ОткрытьСправкуПоПодсистемеЛкс(ЭтотОбъект);
КонецПроцедуры

Процедура КоманднаяПанельДереваОтображениеXML(Кнопка)
	
	Значение = ЭтаФорма.ЭлементыФормы.ДеревоЗначений.ТекущаяСтрока.Значение;
	Если ЛиЕстьЦиклическиеСсылки(Значение) Тогда
		Возврат;
	КонецЕсли; 
	ЗаписьХмл = Новый ЗаписьXML;
	ЗаписьХмл.УстановитьСтроку();
	Если Истина
		И ТипЗнч(Значение) <> Тип("ОбъектXDTO") 
		И ТипЗнч(Значение) <> Тип("ЗначениеXDTO")
	Тогда
		Попытка
			СериализаторXDTO.ЗаписатьXML(ЗаписьХмл, Значение, НазначениеТипаXML.Явное);
		Исключение
			Сообщить(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке().Причина));
			Возврат;
		КонецПопытки; 
	Иначе
		Попытка
			ФабрикаXDTO.ЗаписатьXML(ЗаписьХмл, Значение,,,, НазначениеТипаXML.Явное);
		Исключение
			Сообщить(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке().Причина));
			Возврат;
		КонецПопытки; 
	КонецЕсли; 
	Текст = ЗаписьХмл.Закрыть();
	ирОбщий.ОткрытьТекстЛкс(Текст, "HTML", , Истина);
	
КонецПроцедуры

Процедура КоманднаяПанельДереваОтображениеJSON(Кнопка)
	
	Значение = ЭтаФорма.ЭлементыФормы.ДеревоЗначений.ТекущаяСтрока.Значение;
	Если ЛиЕстьЦиклическиеСсылки(Значение) Тогда
		Возврат;
	КонецЕсли; 
	ЗаписьJSON = ирОбщий.МойЗаписьJSON();
	#Если Сервер И Не Сервер Тогда
		ЗаписьJSON = Новый ЗаписьJSON;
	#КонецЕсли
	ЗаписьJSON.УстановитьСтроку();
	Если Истина
		И ТипЗнч(Значение) <> Тип("ОбъектXDTO") 
		И ТипЗнч(Значение) <> Тип("ЗначениеXDTO")
	Тогда
		Попытка
			СериализаторXDTO.ЗаписатьJSON(ЗаписьJSON, Значение, НазначениеТипаXML.Явное);
		Исключение
			Сообщить(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке().Причина));
			Возврат;
		КонецПопытки; 
	Иначе
		Попытка
			ФабрикаXDTO.ЗаписатьJSON(ЗаписьJSON, Значение, НазначениеТипаXML.Явное);
		Исключение
			Сообщить(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке().Причина));
			Возврат;
		КонецПопытки; 
	КонецЕсли; 
	Текст = ЗаписьJSON.Закрыть();
	ирОбщий.ОткрытьТекстЛкс(Текст, , , Истина);

КонецПроцедуры
Процедура ДеревоЗначенийПредставлениеЗначенияПриИзменении(Элемент)
	
	ТекущиеДанные = ЭлементыФормы.ДеревоЗначений.ТекущиеДанные;
	Родитель = ТекущиеДанные.Родитель;
	Если Родитель = Неопределено Тогда
		_Значение_ = Элемент.Значение;
		ИсследуемоеЗначениеЗаменено = Истина;
	Иначе
		Попытка
			Родитель.Значение[ТекущиеДанные.Слово] = Элемент.Значение;
			БылаОшибка = Ложь;
		Исключение
			БылаОшибка = Истина;
			Сообщить(ирОбщий.ПолучитьИнформациюОбОшибкеБезВерхнегоМодуляЛкс(ИнформацияОбОшибке(), 1), СтатусСообщения.Внимание);
		КонецПопытки;
		ТекущиеДанные.Значение = Родитель.Значение[ТекущиеДанные.Слово];
	КонецЕсли; 
	УстановитьЗначениеСловаВСтроке(ТекущиеДанные, Истина, ТекущиеДанные.Значение);
	
КонецПроцедуры

Процедура КоманднаяПанельДереваКонсольКода(Кнопка)
	
	ТекущаяСтрока = ЭлементыФормы.ДеревоЗначений.ТекущаяСтрока;
	Если Ложь
		Или ТекущаяСтрока = Неопределено 
		Или ТекущаяСтрока.ТипСлова = "Группа"
	Тогда
		Возврат;
	КонецЕсли; 
	СтруктураПараметров = Новый Структура();
	Если ТекущаяСтрока.ТипСлова = "Метод" Тогда
		ТипКонтекста = ТекущаяСтрока.Родитель.Родитель.СтруктураТипа.ИмяОбщегоТипа;
		СтрокиПараметров = мПлатформа.ТаблицаПараметров.Скопировать(Новый Структура("ТипКонтекста, Слово, ЯзыкПрограммы", ТипКонтекста, ТекущаяСтрока.Слово, 0));
		СтрокиПараметров.Сортировать("Номер");
		ТекстПараметров = "";
		Для Каждого СтрокаПараметра Из СтрокиПараметров Цикл
			ИмяПараметра = СтрокаПараметра.Параметр;
			ИмяПараметра = СтрЗаменить(ИмяПараметра, "&lt;", "");
			ИмяПараметра = СтрЗаменить(ИмяПараметра, "&gt;", "");
			ИмяПараметра = мПлатформа.ПолучитьИдентификаторИзПредставления(ИмяПараметра);
			Если ТекстПараметров <> "" Тогда
				ТекстПараметров = ТекстПараметров + ", ";
			КонецЕсли; 
			ТекстПараметров = ТекстПараметров + ИмяПараметра;
			Попытка
				Тип = Новый ОписаниеТипов(СтрокаПараметра.ТипЗначения);
			Исключение
				Тип = Новый ОписаниеТипов();
			КонецПопытки; 
			СтруктураПараметров.Вставить(ИмяПараметра, Тип.ПривестиЗначение(Неопределено));
		КонецЦикла;
	КонецЕсли; 
	ТекстПрограммы = "";
	РодительскийПуть = "";
	Если ЗначениеЗаполнено(БазовоеВыражение) Тогда
		РодительскийПуть = "_Значение_.";
	ИначеЕсли Ложь
		Или Найти(Нрег(СокрЛ(Выражение)), НРег("Новый")) = 1
		Или Найти(Нрег(СокрЛ(Выражение)), НРег("Новый(")) = 1
	Тогда
		ТекстПрограммы = ТекстПрограммы + "Объект = " + ПолучитьПолныйПуть(ТекущаяСтрока.Владелец().Строки[0]) + ";" + Символы.ПС;
		РодительскийПуть = "Объект.";
	КонецЕсли; 
	Если ЗначениеЗаполнено(ТекущаяСтрока.ПредставлениеДопустимыхТипов) Тогда
		ТекстПрограммы = ТекстПрограммы + "Результат = ";
	КонецЕсли;
	ОтносительныйПуть = ПолучитьПолныйПуть(ТекущаяСтрока.Родитель, РодительскийПуть <> "");
	Если ЗначениеЗаполнено(ОтносительныйПуть) Тогда
		РодительскийПуть = РодительскийПуть + ОтносительныйПуть + ".";
	КонецЕсли; 
	ТекстПрограммы = ТекстПрограммы + РодительскийПуть; 
	//Если РодительскийПуть <> "" Тогда
	//	ТекстПрограммы = ТекстПрограммы + ".";
	//КонецЕсли; 
	ТекстПрограммы = ТекстПрограммы + ТекущаяСтрока.Слово;
	Если ТекущаяСтрока.ТипСлова = "Метод" Тогда
		 ТекстПрограммы = ТекстПрограммы + "(" + ТекстПараметров + ")";
	КонецЕсли; 
	//Если Найти(Выражение, КорневаяСтрока.Слово) = 1 Тогда
	//	СтруктураПараметров.Вставить(КорневаяСтрока.Слово, _Значение_); 
	//КонецЕсли; 
	//Если Найти(Выражение, "_Значение_") = 1 Тогда
	Если Ложь
		Или Найти(РодительскийПуть, "_Значение_") = 1
		Или (Истина
			И ирОбщий.СтрокиРавныЛкс(ТекущаяСтрока.Слово, "_Значение_")
			И ТекущаяСтрока.Родитель = Неопределено)
	Тогда
		СтруктураПараметров.Вставить("_Значение_", _Значение_); 
	КонецЕсли; 
	ирОбщий.ОперироватьСтруктуройЛкс(ТекстПрограммы, , СтруктураПараметров);
	
КонецПроцедуры

Процедура ДеревоЗначенийПредставлениеЗначенияОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	ирОбщий.ПолеВвода_ОкончаниеВводаТекстаЛкс(Элемент, Текст, Значение, СтандартнаяОбработка, ЭлементыФормы.ДеревоЗначений.ТекущаяСтрока.Значение);

КонецПроцедуры

Процедура УстановитьГлобальныйКонтекст() Экспорт 
	
	Выражение = "<ГлобальныйКонтекст>";
	СтруктураТипаЗначения = мПлатформа.ПолучитьНовуюСтруктуруТипа();
	СтруктураТипаЗначения.ИмяОбщегоТипа = "Глобальный контекст";
	СтруктураТипаЗначения.Метаданные = Метаданные;
	мВычислитьВыражение();

КонецПроцедуры

Процедура КоманднаяПанельДереваГлобальныйКонтекст(Кнопка)
	
	УстановитьГлобальныйКонтекст();
	
КонецПроцедуры

Процедура КоманднаяПанельДереваНовоеОкно(Кнопка)
	
	ирОбщий.ОткрытьНовоеОкноОбработкиЛкс(ЭтотОбъект);
	
КонецПроцедуры

Процедура КоманднаяПанельДереваАвтоКонтекстнаяПомощь(Кнопка)
	
	мАвтоКонтекстнаяПомощь = Не Кнопка.Пометка;
	Кнопка.Пометка = мАвтоКонтекстнаяПомощь;
	Если мАвтоКонтекстнаяПомощь Тогда
		ДеревоЗначенийПриАктивизацииСтроки();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДеревоЗначенийПредставлениеЗначенияНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ТекущиеДанные = ЭлементыФормы.ДеревоЗначений.ТекущиеДанные;
	Попытка
		ЗначениеИзменено = ирОбщий.ПолеВводаКолонкиРасширенногоЗначения_НачалоВыбораЛкс(ЭлементыФормы.ДеревоЗначений, СтандартнаяОбработка, ТекущиеДанные.Значение);
	Исключение
		Сообщить(ирОбщий.ПолучитьИнформациюОбОшибкеБезВерхнегоМодуляЛкс(ИнформацияОбОшибке()), СтатусСообщения.Внимание);
		Возврат;
	КонецПопытки;
	Если ЗначениеИзменено Тогда
		Родитель = ТекущиеДанные.Родитель;
		Если Родитель = Неопределено Тогда
			_Значение_ = ТекущиеДанные.Значение;
			ИсследуемоеЗначениеЗаменено = Истина;
		Иначе
			Попытка
				Родитель.Значение[ТекущиеДанные.Слово] = ТекущиеДанные.Значение;
				БылаОшибка = Ложь;
			Исключение
				БылаОшибка = Истина;
				Сообщить(ирОбщий.ПолучитьИнформациюОбОшибкеБезВерхнегоМодуляЛкс(ИнформацияОбОшибке(), 1), СтатусСообщения.Внимание);
			КонецПопытки;
			ТекущиеДанные.Значение = Родитель.Значение[ТекущиеДанные.Слово];
		КонецЕсли; 
		УстановитьЗначениеСловаВСтроке(ТекущиеДанные, Истина, ТекущиеДанные.Значение);
	КонецЕсли; 
	
КонецПроцедуры

Процедура КоманднаяПанельДереваЗначениеВСтрокуВнутр(Кнопка)

	Значение = ЭтаФорма.ЭлементыФормы.ДеревоЗначений.ТекущаяСтрока.Значение;
	Если ЛиЕстьЦиклическиеСсылки(Значение) Тогда
		Возврат;
	КонецЕсли; 
	Текст = ЗначениеВСтрокуВнутр(Значение);
	ирОбщий.ОткрытьТекстЛкс(Текст, , , Истина);
	
КонецПроцедуры

Процедура КоманднаяПанельДереваОтображениеXDTO(Кнопка)

	Значение = ЭтаФорма.ЭлементыФормы.ДеревоЗначений.ТекущаяСтрока.Значение;
	Если ЛиЕстьЦиклическиеСсылки(Значение) Тогда
		Возврат;
	КонецЕсли; 
	Попытка
		ОбъектXDTO = СериализаторXDTO.ЗаписатьXDTO(Значение);
	Исключение
		Сообщить(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке().Причина));
		Возврат;
	КонецПопытки;
	ирОбщий.ИсследоватьЛкс(ОбъектXDTO);
	
КонецПроцедуры

Функция ЛиЕстьЦиклическиеСсылки(Значение)
	
	Если ирОбщий.ПроверитьЦиклическиеСсылкиВстроенногоЯзыкаЛкс(Значение, "Значение").Количество() > 0 Тогда 
		Сообщить("Операция отменена из-за наличия циклических ссылок внутри значения");
		Результат = Истина;
	Иначе
		Результат = Ложь;
	КонецЕсли;
	Возврат Результат;

КонецФункции

Процедура КоманднаяПанельДереваМенеджерТабличногоПоля(Кнопка)
	
	ирОбщий.ОткрытьМенеджерТабличногоПоляЛкс(ЭлементыФормы.ДеревоЗначений, ЭтаФорма);

КонецПроцедуры

Процедура ВыражениеНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, ЭтаФорма);

КонецПроцедуры

Процедура ПриЗакрытии()
	
	Если ИсследуемоеЗначениеЗаменено Тогда
		ОповеститьОВыборе(_Значение_);
	КонецЕсли; 
	ИсследуемоеЗначениеЗаменено = Ложь;
	
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
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

Процедура КоманднаяПанельДереваОбновить(Кнопка)
	
	ТекущаяСтрока = ЭлементыФормы.ДеревоЗначений.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	КлючТекущейСтроки = Новый Структура("Слово, ТипСлова");
	ЗаполнитьЗначенияСвойств(КлючТекущейСтроки, ТекущаяСтрока); 
	ТекущийРодитель = ТекущаяСтрока.Родитель;
	Если ТекущийРодитель = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ЗаполнитьДочерниеСтроки(ТекущийРодитель);
	НайденныеСтроки = ТекущийРодитель.Строки.НайтиСтроки(КлючТекущейСтроки);
	Если НайденныеСтроки.Количество() > 0 Тогда
		ЭлементыФормы.ДеревоЗначений.ТекущаяСтрока = НайденныеСтроки[0];
	КонецЕсли; 
	
КонецПроцедуры

Процедура КоманднаяПанельДереваСвернутьОстальные(Кнопка)
	
	ирОбщий.ТабличноеПолеДеревоЗначений_СвернутьВсеСтрокиЛкс(ЭлементыФормы.ДеревоЗначений, Истина);
	
КонецПроцедуры

Процедура КоманднаяПанельДереваСравнить(Кнопка)
	
	ирОбщий.СравнитьСодержимоеЭлементаУправленияЛкс(ЭлементыФормы.ДеревоЗначений);

КонецПроцедуры

Процедура КоманднаяПанельДереваПроверитьЦиклическиеСсылки(Кнопка)
	
	Значение = ЭтаФорма.ЭлементыФормы.ДеревоЗначений.ТекущаяСтрока.Значение;
	Результат = ирОбщий.ПроверитьЦиклическиеСсылкиВстроенногоЯзыкаЛкс(Значение, "<Значение>", Истина);
	Если Результат.Количество() > 0 Тогда
		ирОбщий.ОткрытьЗначениеЛкс(Результат);
	Иначе
		Сообщить("Циклических ссылок не найдено");
	КонецЕсли; 
	
КонецПроцедуры

Процедура КоманднаяПанельДереваИзXML(Кнопка)
	
	Текст = "";
	ирОбщий.ОткрытьЗначениеЛкс(Текст, ,, "Введите текст XML сериализованного объекта");
	Если Не ЗначениеЗаполнено(Текст) Тогда
		Возврат;
	КонецЕсли; 
	Объект = ирОбщий.ВосстановитьОбъектИзСтрокиXMLЛкс(Текст);
	Если Объект = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	УстановитьИсследуемоеЗначение(Объект);
	мВычислитьВыражение();
	
КонецПроцедуры

Процедура КоманднаяПанельДереваИзJSON(Кнопка)
	
	Текст = "";
	ирОбщий.ОткрытьЗначениеЛкс(Текст, ,, "Введите текст JSON сериализованного объекта");
	Если Не ЗначениеЗаполнено(Текст) Тогда
		Возврат;
	КонецЕсли;
	Чтение = ирОбщий.МойЧтениеJSON();
	#Если Сервер И Не Сервер Тогда
		Чтение = Новый ЧтениеJSON;
	#КонецЕсли
	Чтение.УстановитьСтроку(Текст);
	Попытка
		Объект = СериализаторXDTO.ПрочитатьJSON(Чтение);
	Исключение
		Сообщить(ОписаниеОшибки());
		Возврат;
	КонецПопытки;
	УстановитьИсследуемоеЗначение(Объект);
	мВычислитьВыражение();
	
КонецПроцедуры

Процедура КоманднаяПанельДереваИзВнутр(Кнопка)
	
	Текст = "";
	ирОбщий.ОткрытьЗначениеЛкс(Текст, ,, "Введите текст Внутр сериализованного объекта");
	Если Не ЗначениеЗаполнено(Текст) Тогда
		Возврат;
	КонецЕсли;
	Попытка
		Объект = ЗначениеИзСтрокиВнутр(Текст);
	Исключение
		Сообщить(ОписаниеОшибки());
		Возврат;
	КонецПопытки;
	УстановитьИсследуемоеЗначение(Объект);
	мВычислитьВыражение();
	
КонецПроцедуры

Процедура КоманднаяПанельДереваИзJSONВСтруктуру(Кнопка)
	
	Текст = "";
	ирОбщий.ОткрытьЗначениеЛкс(Текст, ,, "Введите текст JSON сериализованного объекта");
	Если Не ЗначениеЗаполнено(Текст) Тогда
		Возврат;
	КонецЕсли;
	Чтение = ирОбщий.МойЧтениеJSON();
	#Если Сервер И Не Сервер Тогда
		Чтение = Новый ЧтениеJSON;
	#КонецЕсли
	Чтение.УстановитьСтроку(Текст);
	Попытка
		Объект = Вычислить("ПрочитатьJSON(Чтение)");
	Исключение
		Сообщить(ОписаниеОшибки());
		Возврат;
	КонецПопытки;
	УстановитьИсследуемоеЗначение(Объект);
	мВычислитьВыражение();
	
КонецПроцедуры

Процедура КоманднаяПанельДереваИзJSONВСоответствие(Кнопка)
	
	Текст = "";
	ирОбщий.ОткрытьЗначениеЛкс(Текст, ,, "Введите текст JSON сериализованного объекта");
	Если Не ЗначениеЗаполнено(Текст) Тогда
		Возврат;
	КонецЕсли;
	Чтение = ирОбщий.МойЧтениеJSON();
	#Если Сервер И Не Сервер Тогда
		Чтение = Новый ЧтениеJSON;
	#КонецЕсли
	Чтение.УстановитьСтроку(Текст);
	Попытка
		Объект = Вычислить("ПрочитатьJSON(Чтение, Истина)");
	Исключение
		Сообщить(ОписаниеОшибки());
		Возврат;
	КонецПопытки;
	УстановитьИсследуемоеЗначение(Объект);
	мВычислитьВыражение();
	
КонецПроцедуры

Процедура КоманднаяПанельДереваОтображениеJSONПрямое(Кнопка)
	
	Значение = ЭтаФорма.ЭлементыФормы.ДеревоЗначений.ТекущаяСтрока.Значение;
	Если ЛиЕстьЦиклическиеСсылки(Значение) Тогда
		Возврат;
	КонецЕсли; 
	ЗаписьJSON = ирОбщий.МойЗаписьJSON();
	#Если Сервер И Не Сервер Тогда
		ЗаписьJSON = Новый ЗаписьJSON;
	#КонецЕсли
	ЗаписьJSON.УстановитьСтроку();
	Попытка
		Выполнить("ЗаписатьJSON(ЗаписьJSON, Значение)");
	Исключение
		Сообщить(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке().Причина));
		Возврат;
	КонецПопытки; 
	Текст = ЗаписьJSON.Закрыть();
	ирОбщий.ОткрытьТекстЛкс(Текст, , , Истина);
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирИсследовательОбъектов.Форма.ИсследовательОбъектов");

мПлатформа = ирКэш.Получить();
ИсследуемоеЗначениеЗаменено = Ложь;
мАвтоКонтекстнаяПомощь = Ложь;
МаркерСловаЗначения = "_Значение_";
ДеревоЗначений.Колонки.Добавить("Значение");
ДеревоЗначений.Колонки.Добавить("ТипЗначения");
ДеревоЗначений.Колонки.Добавить("СтруктураТипа");
ДеревоЗначений.Колонки.Добавить("ТаблицаСтруктурТипов");
ЭлементыФормы.ДеревоЗначений.Колонки.ПредставлениеЗначения.АвтоВысотаЯчейки = Истина;


