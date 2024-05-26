﻿Перем МаксЧислоПараметровФормы;
Перем ПеречислениеТипСлова;
Перем РасширениеФайлаМодуля;

Функция СохраняемаяНастройкаФормы(выхНаименование, выхИменаСвойств) Экспорт 
	выхИменаСвойств = "Форма.ИскатьСлово, Форма.МаксЧислоРезультатов, Форма.ТипРодителя, Форма.ТипСлова, Форма.РежимПоиска, Форма.ФильтрПодсистем";
	Возврат Неопределено;
КонецФункции

Процедура ЗагрузитьНастройкуВФорме(НастройкаФормы, ДопПараметры) Экспорт 
	
	ирКлиент.ЗагрузитьНастройкуФормыЛкс(ЭтаФорма, НастройкаФормы); 
	//Если ПараметрИскатьНепрямые <> Неопределено Тогда
	//	ЭтаФорма.ИскатьНепрямые = ПараметрИскатьНепрямые;
	//КонецЕсли;
	Если ПараметрРежимПоиска <> Неопределено Тогда
		ЭтаФорма.РежимПоиска = ПараметрРежимПоиска;
		ЭтаФорма.ПараметрРежимПоиска = Неопределено;
	КонецЕсли;
	Если ПараметрЧтоИскать <> Неопределено  Тогда
		ЭтаФорма.ИскатьСлово = ПараметрЧтоИскать;
		ЭтаФорма.ТипСлова = "";
		ЭтаФорма.ТипРодителя = "";
		Если ПараметрСтруктураТипаРодителя <> Неопределено Тогда
			ЭтаФорма.ТипРодителя = мПлатформа.ИмяТипаИзСтруктурыТипа(ПараметрСтруктураТипаРодителя);
		КонецЕсли;
		ЭтаФорма.ПараметрЧтоИскать = Неопределено;
	КонецЕсли;
	ОбновитьДоступность();
	ЗагрузитьИскомоеСлово();
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ирКлиент.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ирКлиент.СоздатьМенеджерСохраненияНастроекФормыЛкс(ЭтаФорма,,, Новый Структура("ПриОткрытии"));
	ирКлиент.ДопСвойстваЭлементаФормыЛкс(ЭтаФорма, ЭлементыФормы.ВызовыСлова).МенеджерПоиска = ирКлиент.СоздатьМенеджерПоискаВТабличномПолеЛкс(Новый Структура("Текст")); // Для отключения раскраски
	ВызовыСлова.Очистить();
	СписокВыбора = ЭлементыФормы.МаксЧислоРезультатов.СписокВыбора;
	СписокВыбора.Добавить(100);
	СписокВыбора.Добавить(1000);
	СписокВыбора.Добавить(10000);
	СписокВыбора.Добавить(100000);  
	Если ЗначениеЗаполнено(ПараметрЧтоИскать) Тогда
		//ПодключитьОбработчикОжидания("ОбновитьДанные", 0.1, Истина); // Нельзя прервать
	КонецЕсли;
	ЭтаФорма.ДатаОбновленияКэша = ирОбщий.ДатаОбновленияКэшаМодулейЛкс();
	Если Не ЗначениеЗаполнено(ИскатьСлово) Тогда
		ЭтаФорма.ТекущийЭлемент = ЭлементыФормы.ИскатьСлово;
	КонецЕсли;

КонецПроцедуры

Процедура ОбновитьДанные() Экспорт  
	ДействияФормыНайти();
КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирКлиент.Форма_ПриЗакрытииЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ВызовыВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ТекущаяСтрока = ЭлементыФормы.ВызовыСлова.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если Колонка = ЭлементыФормы.ВызовыСлова.Колонки.Ссылка И ЗначениеЗаполнено(ВыбраннаяСтрока.Ссылка) Тогда 
		ДействияФормыПерейтиКОпределению();
	Иначе
		Если Не ирКлиент.ОткрытьСсылкуСтрокиМодуляЛкс(ВыбраннаяСтрока.Ссылка) Тогда 
			Если ВыбраннаяСтрока.Модуль = мПлатформа.ИмяДинамическогоМодуля() Тогда 
				ФормаВладелец.Активизировать();
				ПолеТекстаЛ = ПолеТекста;
			Иначе
				ПолеТекстаЛ = ирКлиент.ОткрытьПолеТекстаМодуляКонфигурацииЛкс(ВыбраннаяСтрока.Модуль).ПолеТекста;
			КонецЕсли;
			ПолеТекстаЛ.УстановитьГраницыВыделения(ВыбраннаяСтрока.Позиция, ВыбраннаяСтрока.Позиция + ВыбраннаяСтрока.ДлинаВхождения,,, Истина);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция ТекстФайлаСтроки(Знач ВыбраннаяСтрока = Неопределено)
	
	Если ВыбраннаяСтрока = Неопределено Тогда
		ВыбраннаяСтрока = ЭлементыФормы.ВызовыСлова.ТекущаяСтрока;
	КонецЕсли;
	ФайлМодуля = мПлатформа.ФайлМодуляИзИмениМодуля(ВыбраннаяСтрока.Модуль);
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.Прочитать(ФайлМодуля.ПолноеИмя);
	ТекстФайла = ТекстовыйДокумент.ПолучитьТекст();
	Возврат ТекстФайла;

КонецФункции

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирКлиент.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирКлиент.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	ирКлиент.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирКлиент.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	Если ирОбщий.ПроверитьПлатформаНеWindowsЛкс(Отказ,, Истина) Тогда
		Возврат;
	КонецЕсли;
	ЭтаФорма.ОбработкаОбъект = КопияКомпоненты();
	ПроверитьИнициировать();
КонецПроцедуры

Процедура ДействияФормыНайти(Кнопка = Неопределено)
	
	Если Не ЗначениеЗаполнено(ИскатьСлово) Тогда
		Возврат;
	КонецЕсли;
	ПолноеИмяСлова = ИскатьСлово;
	Если РежимПоиска = "Ссылки" Тогда
		Если ТипСлова = ПеречислениеТипСлова.Конструктор Тогда
			ПолноеИмяСлова = "Новый " + ПолноеИмяСлова;
		Иначе
			ПолноеИмяСлова = ТипРодителя + "." + ПолноеИмяСлова;
			Если ТипСлова <> ПеречислениеТипСлова.Свойство Тогда
				ПолноеИмяСлова = ПолноеИмяСлова + "(";
			КонецЕсли;
		КонецЕсли;
	КонецЕсли; 
	Если РезультатСодержитПолныеСтроки() Тогда 
		ЭтаФорма.ВызовыСловаСтрокаПоиска = ИскатьСлово; 
	Иначе 
		ЭтаФорма.ВызовыСловаСтрокаПоиска = "";
	КонецЕсли;
	ирКлиент.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(ЭлементыФормы.ИскатьСлово, ЭтаФорма,,, РежимПоиска, ПолноеИмяСлова);
	ВызовыСлова.Очистить();   
	ЭлементыФормы.ВызовыСлова.ОбновитьСтроки();
	ФайлыМодулей = Новый Массив; // Массив из Файл
	ПоискВДинамическомМодуле = Истина
		И мМодульМетаданных <> Неопределено 
		И Не ЗначениеЗаполнено(мИмяМодуля)
		И Найти(ИскатьСлово, ".") = 0;
	Если ПоискВДинамическомМодуле Тогда
		ФайлыМодулей.Добавить(Неопределено);
	КонецЕсли;
	ирОбщий.ДополнитьМассивЛкс(ФайлыМодулей, НайтиФайлы(мПлатформа.ПапкаКэшаМодулей.ПолноеИмя, "*." + РасширениеФайлаМодуля, Истина)); 
	мПлатформа.ИнициацияОписанияМетодовИСвойств();
	Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(ФайлыМодулей.Количество());
	ИмяРодногоМодуляБезКонца = ирОбщий.СтрокаБезПоследнегоФрагментаЛкс(ирОбщий.ТекстМеждуМаркерамиЛкс(ИскатьСлово, "[", "]"));
	Если Истина
		И Не ЗначениеЗаполнено(ИмяРодногоМодуляБезКонца) 
		И мМодульМетаданных <> Неопределено
		И мМодульМетаданных.Методы.Найти(НРег(ИскатьСлово), "НИмя") <> Неопределено  
	Тогда
		ИмяРодногоМодуляБезКонца = ирОбщий.СтрокаБезПоследнегоФрагментаЛкс(мИмяМодуля);
	КонецЕсли;
	шРазделитель = мПлатформа.шРазделитель; 
	ШаблонПараметра = "(" + шВыражениеПрограммы + ")?" + шРазделитель + "*(?:$|,|\))";  
	ШаблонИскатьСлово = ирОбщий.ПодготовитьТекстДляРегВыраженияЛкс(ИскатьСлово);
	Если ирОбщий.СтрНачинаетсяСЛкс(ТипРодителя, "ОбщийМодуль") Тогда
		ШаблонИскатьСлово = "(?:" + ирОбщий.ТекстМеждуМаркерамиЛкс(ТипРодителя, "[", "]", Ложь) + "\.)?" + ШаблонИскатьСлово;
	КонецЕсли;
	ШаблонЛитерала = """" + ШаблонИскатьСлово + """";
	НИскатьСлово = Нрег(ИскатьСлово);
	РегВыражениеКэш = Неопределено;
	МаксЧислоПараметровВызовов = 0; 
	ДлинаПредФрагмента = 20;
	Если РежимПоиска = "Ссылки" Тогда
		НачальныйСчетчик = 1;
		ШаблонПрямогоВызова = ШаблонПрямогоВызоваСлова(ИскатьСлово, ТипСлова);
		ШаблонПрямогоВызова = ШаблонПрямогоВызова + "|" + ШаблонЛитерала;
	Иначе 
		НачальныйСчетчик = 2;
		Если РежимПоиска = "Регулярный" Тогда
			ШаблонПрямогоВызова = ИскатьСлово;
		Иначе 
			ШаблонПрямогоВызова = ШаблонИскатьСлово;
		КонецЕсли;
	КонецЕсли;
	Если ФильтрПодсистем.Количество() > 0 Тогда
		ОбъектыВыбранныхПодсистем = ирОбщий.ОбъектыПодсистемЛкс(ФильтрПодсистем);
	КонецЕсли;
	ОбъектМД = Неопределено;
	СтруктураОбновленияТабличногПоля = ирКлиент.СтрукутраПервогоОбновленияТабличногоПоляЛкс();
	ПриоритетныеФайлы = Новый Массив;    
	РазделительПутиКФайлу = ирОбщий.РазделительПутиКФайлуЛкс();
	Для Каждого Файл Из ФайлыМодулей Цикл
		Если ирОбщий.СтрНайтиЛкс(Файл.ПолноеИмя, РазделительПутиКФайлу + ИмяРодногоМодуляБезКонца + ".",,,, Ложь) > 0 Тогда
			ПриоритетныеФайлы.Добавить(Файл);
		КонецЕсли;
	КонецЦикла;
	Для Каждого Файл Из ПриоритетныеФайлы Цикл
		ФайлыМодулей.Удалить(ФайлыМодулей.Найти(Файл));
		ФайлыМодулей.Вставить(0, Файл);
	КонецЦикла;
	Для Каждого Файл Из ФайлыМодулей Цикл
		#Если Сервер И Не Сервер Тогда
			Файл = Новый Файл;
		#КонецЕсли
		Если Файл = Неопределено Тогда
			ПолноеИмяФайла = "";
			ИмяМодуля = мПлатформа.ИмяДинамическогоМодуля();
			ТекстовыйДокумент = ПолеТекста;
		Иначе
			ПолноеИмяФайла = Файл.ПолноеИмя;
			ИмяМодуля = СтрЗаменить(ирОбщий.ПоследнийФрагментЛкс(Файл.ПолноеИмя, мПлатформа.ПапкаКэшаМодулей.ПолноеИмя + "\"), "\", " ");
			ИмяМодуля = ирОбщий.СтрокаБезПоследнегоФрагментаЛкс(ИмяМодуля);
			ТекстовыйДокумент = Неопределено;
		КонецЕсли;
		Если ирОбщий.ОбработатьИндикаторЛкс(Индикатор,, ИмяМодуля) Тогда 
			ЭтаФорма.КоличествоНайдено = ВызовыСлова.Количество();
		КонецЕсли;
		Если ТекстовыйДокумент = Неопределено Тогда
			Если ФильтрПодсистем.Количество() > 0 Тогда
				ОбъектМД = ирКэш.ОбъектМДПоПолномуИмениЛкс(ирОбщий.ПервыеФрагментыЛкс(Файл.ИмяБезРасширения));
				Если ОбъектМД <> Неопределено Тогда
					Если ОбъектыВыбранныхПодсистем[ОбъектМД] = Неопределено тогда
						Продолжить;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			ТекстовыйДокумент = Новый ТекстовыйДокумент;
			ТекстовыйДокумент.Прочитать(ПолноеИмяФайла);
		КонецЕсли;
		ТекстМодуля = ТекстовыйДокумент.ПолучитьТекст();
		Для ЭтапВнутренний = НачальныйСчетчик По 2 Цикл
			Если ЭтапВнутренний = 1 Тогда 
				НайденныеВызовы = мПлатформа.НепрямыеВызовыСловаВМодуле(ИмяМодуля, ТекстовыйДокумент, Файл, ЭтотОбъект, ирОбщий.ПоследнийФрагментЛкс(ИскатьСлово), ТипСлова <> ПеречислениеТипСлова.Свойство);
			ИначеЕсли ЭтапВнутренний = 2 Тогда 
				Если Ложь
					Или РежимПоиска <> "Ссылки"
					Или ТипСлова = ПеречислениеТипСлова.Конструктор
					Или (Истина
						//И ИскатьНепрямые 
						И Не ЗначениеЗаполнено(ИмяРодногоМодуляБезКонца))
					Или ирОбщий.СтрНайтиЛкс("." + ИмяМодуля + ".", "." + ИмяРодногоМодуляБезКонца + ".",,,, Ложь) > 0 // TODO переделать на анализ основного объекта формы
				Тогда
					ВхожденияВызова = ирОбщий.НайтиРегВыражениеЛкс(ТекстМодуля, ШаблонПрямогоВызова,,,,,, Истина, РегВыражениеКэш,, ВхожденияВызова); // Без подгрупп для ускорения
					НайденныеВызовы = ВхожденияВызова;
				ИначеЕсли ЗначениеЗаполнено(ШаблонЛитерала) Тогда
					ВхожденияВызова = ирОбщий.НайтиРегВыражениеЛкс(ТекстМодуля, СтрЗаменить(ШаблонЛитерала, ")?", ")"),,,,,, Истина, РегВыражениеКэш,, ВхожденияВызова); // Без подгрупп для ускорения
					НайденныеВызовы = ВхожденияВызова;
				Иначе
					Продолжить;
				КонецЕсли;
			КонецЕсли; 
			//
			//Если ЭтапВнутренний = 1 Тогда
			//	Продолжить;
			//КонецЕсли;
			//Если РежимПоиска = "Ссылки" Тогда 
			//	Если ТипСлова = ПеречислениеТипСлова.Метод Тогда
			//		ШаблонВнешнегоВызова = шПредИмяПрямое+"(?:"+шИмяСТочками+"\.)?("+ШаблонИскатьСлово+")\s*\((?:(?:"+шВыражениеПрограммы+")?"+шРазделитель+"*(?=[,\)])|,)*\)";
			//	Иначе 
			//		ШаблонВнешнегоВызова = шПредИмяПрямое+"(?:"+шИмяСТочками+"\.)?("+ШаблонИскатьСлово+")(?!\s*[\(])"+шПостИмяСвойства;
			//	КонецЕсли;
			//	ШаблонВнешнегоВызова = ШаблонВнешнегоВызова + "|" + ШаблонЛитерала;
			//Иначе 
			//	ШаблонВнешнегоВызова = ШаблонПрямогоВызова;
			//КонецЕсли;
			//ВхожденияВызова = ирОбщий.НайтиРегВыражениеЛкс(ТекстМодуля, ШаблонВнешнегоВызова,,,,,, Истина, РегВыражениеКэш,, ВхожденияВызова); // Без подгрупп для ускорения
			//НайденныеВызовы = ВхожденияВызова;
			
			Для Каждого ВхождениеВызова Из НайденныеВызовы Цикл
				Попытка
					ТекстВхождения = ВхождениеВызова.ТекстВхождения;
				Исключение
					ТекстВхождения = Сред(ТекстМодуля, ВхождениеВызова.ПозицияВхождения + 1, ВхождениеВызова.ДлинаВхождения);
				КонецПопытки;
				Если РежимПоиска = "Ссылки" Тогда
					НТекстВхождения = НРег(ТекстВхождения);
					Если ВхождениеВызова.ПозицияВхождения > 1 Тогда
						ПредФрагмент = Лев(ТекстВхождения, 1);
						ТекстВхождения = Сред(ТекстВхождения, 2);
					Иначе 
						ПредФрагмент = "";
					КонецЕсли;
					ПозицияПредФрагмента = ВхождениеВызова.ПозицияВхождения + 1 - ДлинаПредФрагмента;
					Если ПозицияПредФрагмента < 1 Тогда
						ДлинаПредФрагментаЦикл = ДлинаПредФрагмента + ПозицияПредФрагмента - 1;
					Иначе 
						ДлинаПредФрагментаЦикл = ДлинаПредФрагмента;
					КонецЕсли;
					ПредФрагмент = СокрП(Сред(ТекстМодуля, ПозицияПредФрагмента, ДлинаПредФрагментаЦикл) + ПредФрагмент);
					ПервыйПредСимвол = Прав(ПредФрагмент, 1);
					ПервыйПостСимвол = Сред(ТекстМодуля, ВхождениеВызова.ПозицияВхождения + 1 + ВхождениеВызова.ДлинаВхождения, 1);
					РезультатИспользован = Ложь
						Или ПервыйПостСимвол = "["
						Или ПервыйПостСимвол = "."
						Или (Истина
								И ПервыйПредСимвол <> """"
								И ПервыйПредСимвол <> ";"
								И ПервыйПредСимвол <> ")"
								И Прав(ПредФрагмент, 2) <> "//"
								И (Ложь
									Или НРег(ПервыйПредСимвол) = "и" // или, и, если
									Или НРег(ПервыйПредСимвол) = "з" // из
									Или ирОбщий.СтрКончаетсяНаЛкс(ПредФрагмент, "Не") // целиком чтобы отделить от "Иначе"
									Или ирОбщий.СтрКончаетсяНаЛкс(ПредФрагмент, "Возврат") // целиком чтобы отделить от "Экспорт"
									Или ирОбщий.СтрКончаетсяНаЛкс(ПредФрагмент, "Пока") // целиком чтобы отделить от "Тогда"
									Или Не ирОбщий.ПроверитьКатегорииСимволаЛкс(ПервыйПредСимвол,,,, Истина) // спец. символ
									));
					ЛиПрямойВызов = Ложь
						//Или Не ИскатьНепрямые 
						Или ЭтапВнутренний = 2 
						Или ирОбщий.СтрНайтиЛкс(НТекстВхождения, НИскатьСлово) < 4;
					//Если Не ЛиПрямойВызов И Не ИскатьНепрямые Тогда
					//	Продолжить;
					//КонецЕсли;
				КонецЕсли;
				СтрокаВызова = ВызовыСлова.Добавить();
				СтрокаВызова.Модуль = ИмяМодуля; 
				СтрокаВызова.Текст = СокрЛ(ТекстВхождения);
				СтрокаВызова.Позиция = ВхождениеВызова.ПозицияВхождения + 1;
				СтрокаВызова.ДлинаВхождения = ВхождениеВызова.ДлинаВхождения - 1;  
				СтрокаВызова.ТипРодителя = "??";
				Если РежимПоиска = "Ссылки" Тогда
					СтрокаВызова.Позиция = СтрокаВызова.Позиция + 1;
					СтрокаВызова.Внутренний = ЭтапВнутренний = 2;
					СтрокаВызова.Прямой = ЛиПрямойВызов;
					СтрокаВызова.Результат = РезультатИспользован; 
					ПозицияСкобки = Найти(ТекстВхождения, "(");      
					Если ПозицияСкобки > 0 Тогда 
						ТекстПараметровВызова = СокрЛП(Сред(ТекстВхождения, ПозицияСкобки + 1));
						Если ТекстПараметровВызова <> ")" Тогда
							ВхожденияПараметров = ирОбщий.НайтиРегВыражениеЛкс(ТекстПараметровВызова, ШаблонПараметра,,,,,, Истина,,, ВхожденияПараметров);
							ИндексПараметра = 0; 
							Для Каждого ВхождениеПараметра Из ВхожденияПараметров Цикл
								Если ИндексПараметра = МаксЧислоПараметровФормы Тогда
									Прервать;
								КонецЕсли;
								СтрокаВызова["Параметр" + ИндексПараметра] = СокрЛП(ирОбщий.СтрокаБезКонцаЛкс(ВхождениеПараметра.ТекстВхождения));
								ИндексПараметра = ИндексПараметра + 1;
							КонецЦикла;
							СтрокаВызова.ЧислоПараметров = ИндексПараметра - 1;
						КонецЕсли;
					КонецЕсли;
					Если ТипСлова <> ПеречислениеТипСлова.Конструктор Тогда
						СтрокаВызова.ВыражениеРодитель = ирОбщий.ПервыйФрагментЛкс(СокрЛ(НТекстВхождения), "." + НИскатьСлово, Ложь);
					КонецЕсли;
				КонецЕсли;
				МаксЧислоПараметровВызовов = Макс(СтрокаВызова.ЧислоПараметров, МаксЧислоПараметровВызовов);
				Если ЗначениеЗаполнено(МаксЧислоРезультатов) И ВызовыСлова.Количество() >= МаксЧислоРезультатов Тогда
					ирОбщий.СообщитьЛкс("Поиск остановлен по достижению максимального числа результатов");
					Перейти ~КонецЦикла;
				КонецЕсли; 
				//Если Не СтруктураОбновленияТабличногПоля.ПерваяПорцияОтображена Тогда
					УточнитьСтрокуРезультата(СтрокаВызова);
				//КонецЕсли;
				ирКлиент.ПроверитьПервоеОбновлениеТабличногоПоляЛкс(ЭлементыФормы.ВызовыСлова, СтруктураОбновленияТабличногПоля);
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
~КонецЦикла:
	ВызовыСлова.Сортировать("Модуль, Позиция");
	ЭтаФорма.КоличествоНайдено = ВызовыСлова.Количество();
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	
	Для ИндексПараметра = 0 По МаксЧислоПараметровФормы - 1 Цикл
		Колонка = ЭлементыФормы.ВызовыСлова.Колонки["Параметр" + ИндексПараметра];
		Колонка.Видимость = ИндексПараметра < МаксЧислоПараметровВызовов;
	КонецЦикла;
	ЭлементыФормы.ВызовыСлова.Колонки.Параметры.Видимость = ЭлементыФормы.ВызовыСлова.Колонки.Параметр0.Видимость;
	ЭлементыФормы.ВызовыСлова.Колонки.ЧислоПараметров.Видимость = ТипСлова <> ПеречислениеТипСлова.Свойство;
	ЭтаФорма.ТекущийЭлемент = ЭлементыФормы.ВызовыСлова;
	
КонецПроцедуры

Функция РезультатСодержитПолныеСтроки() Экспорт
	Возврат РежимПоиска <> "Ссылки" Или ТипСлова = ПеречислениеТипСлова.Свойство;
КонецФункции

Процедура ВызовыПриАктивизацииСтроки(Элемент)
	
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	ЭлементыФормы.ПолеТекстаВхождения.УстановитьТекст("");
	ТекущаяСтрока = ЭлементыФормы.ВызовыСлова.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	УточнитьСтрокуРезультата(ТекущаяСтрока, Ложь);
	Если ТекущаяСтрока.ТипРодителя = "??" Тогда
		ПолеТекстаМодуля = мПлатформа.ПолеТекстаМодуля(ТекущаяСтрока.Модуль);
		ПолеТекстаМодуля.КончитьОбработкуКоманды();
		ПолеТекстаМодуля.УстановитьГраницыВыделения(ТекущаяСтрока.Позиция, ТекущаяСтрока.Позиция);
		ПолеТекстаМодуля.РазобратьТекущийКонтекст(,,,,, Истина, ТекущаяСтрока.Позиция);
		ТекущаяСтрока.Язык = ПолеТекстаМодуля.ПредставлениеЯзыкаВыражения();
		Если РежимПоиска = "Ссылки" И ТипСлова <> ПеречислениеТипСлова.Конструктор Тогда
			Если Не ЗначениеЗаполнено(ТекущаяСтрока.ВыражениеРодитель) Тогда
				ТекущаяСтрока.ТипРодителя = мПлатформа.ИмяТипаИзСтруктурыТипа(ПолеТекстаМодуля.мМодульМетаданных.СтруктураТипа);
			Иначе 
				ТаблицаТиповРодителя = ПолеТекстаМодуля.ВычислитьТипЗначенияВыражения(ТекущаяСтрока.ВыражениеРодитель);
				ТекущаяСтрока.ТипРодителя = мПлатформа.ПредставлениеМассиваСтруктурТипов(ТаблицаТиповРодителя);
			КонецЕсли;
			ОбновитьПризнакТипРодителяПодходит(ТекущаяСтрока);
		Иначе 
			ТекущаяСтрока.ТипРодителя = "?";
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

//.
// Параметры:
//    ДанныеСтроки - Неопределено - 
Процедура ОбновитьПризнакТипРодителяПодходит(Знач ДанныеСтроки) Экспорт
	Если ДанныеСтроки.ТипРодителя <> "??" Тогда
		ДанныеСтроки.ТипРодителяПодходит = Истина
			И ЗначениеЗаполнено(ТипРодителя)
			И (Ложь
				Или Найти(", " + ДанныеСтроки.ТипРодителя + ",", ", " + ТипРодителя + ",") > 0 
				Или (Истина
					И ирОбщий.МножественноеИмяМДЛкс(ирОбщий.ПервыйФрагментЛкс(ТипРодителя)) <> Неопределено
					И (Ложь
						Или Найти(", " + ДанныеСтроки.ТипРодителя + ",", ", " + СтрЗаменить(ТипРодителя, ".", "Объект.") + ",") > 0 
						Или Найти(", " + ДанныеСтроки.ТипРодителя + ",", ", " + СтрЗаменить(ТипРодителя, ".", "Ссылка.") + ",") > 0)));
	КонецЕсли;
КонецПроцедуры

//.
// Параметры:
//    ТекущаяСтрока - , ? - 
Процедура УточнитьСтрокуРезультата(Знач ТекущаяСтрока, Знач Групповое = Истина) Экспорт
	Если ТекущаяСтрока.Модуль = мПлатформа.ИмяДинамическогоМодуля() Тогда
		ЗагрузитьМетодМодуляПоПозиции(ТекущаяСтрока.Позиция);
		ТекущаяСтрока.НомерСтрокиМодуля = НомерСтрокиИзПозиции(ТекущаяСтрока.Позиция);
		Если мМетодМодуля <> Неопределено Тогда
			ТекущаяСтрока.ВызывающийМетод = мМетодМодуля.Имя;
		Иначе
			ТекущаяСтрока.ВызывающийМетод = мПлатформа.ИмяМетодаИнициация();
		КонецЕсли;
		Если РежимПоиска <> "Ссылки" Тогда
			ТекущаяСтрока.Текст = ПолеТекста.ПолучитьСтроку(ТекущаяСтрока.НомерСтрокиМодуля);
		КонецЕсли;
	Иначе
		Если Не Групповое Тогда
			ПолеФрагмента = ЭлементыФормы.ПолеТекстаВхождения;
		КонецЕсли;
		ирКлиент.РазобратьПозициюМодуляВСтрокеТаблицыЛкс(ТекущаяСтрока, ТекущаяСтрока.Модуль, ПолеФрагмента,,,,, РезультатСодержитПолныеСтроки());
	КонецЕсли;
КонецПроцедуры

Процедура ВызовыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	ОформлениеСтроки.Ячейки.Параметры.Видимость = Ложь;
	Если ДанныеСтроки.ТипРодителяПодходит = Истина Тогда
		ОформлениеСтроки.Ячейки.ТипРодителя.ЦветФона = ирОбщий.ЦветФонаТекущегоЗначенияЛкс();
	КонецЕсли;
	ирКлиент.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
КонецПроцедуры

Процедура ДействияФормыПерейтиКОпределению(Кнопка = Неопределено)
	
	ТекущаяСтрока = ЭлементыФормы.ВызовыСлова.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ирКлиент.ПоказатьСсылкуНаСтрокуМодуляЛкс(ТекущаяСтрока.Ссылка);
	
КонецПроцедуры

Процедура ИскатьСловоНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка = Истина)
	ирОбщий.ПолеВводаСИсториейВыбора_ОбновитьСписокЛкс(Элемент, ЭтаФорма, РежимПоиска);
КонецПроцедуры

Процедура ИскатьСловоПриИзменении(Элемент)
	ЭтаФорма.ПараметрСтруктураТипаКонтекста = Неопределено;
	ЗагрузитьИскомоеСлово();
КонецПроцедуры

Процедура ЗагрузитьИскомоеСлово(Знач ОчиститьРезультаты = Истина)
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	Если ОчиститьРезультаты Тогда
		ВызовыСлова.Очистить();
	КонецЕсли;
	Если РежимПоиска = "Ссылки" Тогда
		Если ирОбщий.СтрНачинаетсяСЛкс(ИскатьСлово, "Новый ") Тогда
			ЭтаФорма.ТипРодителя = "";
			ЭтаФорма.ТипСлова = ПеречислениеТипСлова.Конструктор;
			ЭтаФорма.ИскатьСлово = СокрЛП(ирОбщий.ПоследнийФрагментЛкс(ИскатьСлово, " "));
			Если ирОбщий.СтрКончаетсяНаЛкс(ИскатьСлово, "(") Тогда
				ЭтаФорма.ИскатьСлово = СокрЛП(ирОбщий.СтрокаБезКонцаЛкс(ЭтаФорма.ИскатьСлово));
			КонецЕсли;
		ИначеЕсли ирОбщий.СтрКончаетсяНаЛкс(ИскатьСлово, "(") Тогда
			ЭтаФорма.ТипСлова = ПеречислениеТипСлова.Метод;
			ЭтаФорма.ИскатьСлово = СокрЛП(ирОбщий.СтрокаБезКонцаЛкс(ЭтаФорма.ИскатьСлово));
		ИначеЕсли Найти(ИскатьСлово, ".") > 0 Или Не ЗначениеЗаполнено(ТипСлова) Тогда
			ЭтаФорма.ТипСлова = ПеречислениеТипСлова.Свойство;
		КонецЕсли;
		Если Найти(ИскатьСлово, ".") > 0 Тогда 
			ЭтаФорма.ТипРодителя = ирОбщий.СтрокаБезПоследнегоФрагментаЛкс(ИскатьСлово, ".");
			ЭтаФорма.ИскатьСлово = ирОбщий.ПоследнийФрагментЛкс(ИскатьСлово);
		КонецЕсли;
	КонецЕсли;
	ирОбщий.ОбновитьТекстПослеМаркераЛкс(ЭтаФорма.Заголовок,, ИскатьСлово , ": "); 
	ИндексПараметра = 0; 
	ВариантыСинтаксиса = Новый СписокЗначений;
	Если ЗначениеЗаполнено(ИскатьСлово) Тогда 
		СтруктураТипаКонтекста = Неопределено;
		Если ПараметрСтруктураТипаКонтекста <> Неопределено Тогда 
			СтруктураТипаКонтекста = ПараметрСтруктураТипаКонтекста;
		ИначеЕсли ЗначениеЗаполнено(ТипРодителя) Тогда 
			СтруктураТипаРодителя = мПлатформа.СтруктураТипаИзКонкретногоТипа(ТипРодителя);
			ТаблицаТипов = ВычислитьТипДочернегоЭлемента(ирОбщий.ЗначенияВМассивЛкс(СтруктураТипаРодителя), ИскатьСлово, ТипСлова);
			Если ТаблицаТипов.Количество() > 0 Тогда
				СтруктураТипаКонтекста = ТаблицаТипов[0];
			КонецЕсли;
		КонецЕсли;
		Если СтруктураТипаКонтекста = Неопределено Тогда
			ПредшествующийТекст = "";
			Если ТипСлова = ПеречислениеТипСлова.Конструктор Тогда
				ПредшествующийТекст = "Новый";
			КонецЕсли;
			Выражение = ИскатьСлово;
			Если ТипСлова <> ПеречислениеТипСлова.Свойство Тогда
				Выражение = Выражение + "(";
			КонецЕсли;
			ТаблицаСтруктурТиповКонтекста = ВычислитьТипЗначенияВыражения(Выражение,, ПредшествующийТекст,, ЗначениеЗаполнено(ПредшествующийТекст));
			Если ТаблицаСтруктурТиповКонтекста.Количество() = 0 Тогда
				СтруктураТипаКонтекста = мПлатформа.НоваяСтруктураТипа();
			Иначе 
				СтруктураТипаКонтекста = ТаблицаСтруктурТиповКонтекста[0]; // первый вариант синтаксиса
			КонецЕсли;
		КонецЕсли;
		СтрокаОписания = СтруктураТипаКонтекста.СтрокаОписания;
		Если СтрокаОписания <> Неопределено И ТипСлова <> ПеречислениеТипСлова.Свойство Тогда
			Если СтрокаОписания.Владелец().Колонки.Найти("ТелоБезВозвратов") <> Неопределено Тогда
				ОткрытьПрикрепленнуюФормуВызоваМетода(СтруктураТипаКонтекста, ЭтаФорма);
				ФормальныеПараметрыМетода = мПлатформа.ПараметрыМетодаМодуля(СтрокаОписания);
				Если ФормальныеПараметрыМетода <> Неопределено Тогда
					Для Каждого СтрокаПараметра Из ФормальныеПараметрыМетода Цикл
						КолонкаПараметра = ЭлементыФормы.ВызовыСлова.Колонки["Параметр" + ИндексПараметра];
						КолонкаПараметра.ТекстШапки = СтрокаПараметра.Имя;
						ИндексПараметра = ИндексПараметра + 1;
						Если ирОбщий.СтрокиРавныЛкс(СтрокаПараметра.Имя, ПараметрИмяПараметра) Тогда
							КолонкаПараметра.Видимость = Истина;
							ЭлементыФормы.ВызовыСлова.ТекущаяКолонка = КолонкаПараметра;
						КонецЕсли;
					КонецЦикла; 
				КонецЕсли;
				ЭтаФорма.ПараметрИмяПараметра = "";
			ИначеЕсли Истина
				И СтрокаОписания.Владелец().Колонки.Найти("ТипКонтекста") <> Неопределено 
				И (Ложь
					Или СтрокаОписания.ТипСлова = ПеречислениеТипСлова.Метод 
					Или СтрокаОписания.ТипСлова = ПеречислениеТипСлова.Конструктор) 
			Тогда
				ЛиТекущийВариантУстановленВручную = ЗначениеЗаполнено(ЭтаФорма.ТекущийВариант);
				
				// Мультиметка06322413
				СтрокиПараметров = мПлатформа.ПараметрыМетодаПлатформы(СтрокаОписания);
				#Если Сервер И Не Сервер Тогда
					СтрокиПараметров = Новый ТаблицаЗначений;
				#КонецЕсли
				НомерВарианта = 0;
				//Если Не ЛиТекущийВариантУстановленВручную Тогда
					ТаблицаВариантов = СтрокиПараметров.Скопировать();
					ЭтаФорма.ТекущийВариант = мПлатформа.ПодобратьВариантСинтаксисаМетода(ТаблицаВариантов,, ТекущийВариант, ЛиТекущийВариантУстановленВручную, НомерВарианта);
					ВариантыСинтаксиса.ЗагрузитьЗначения(ТаблицаВариантов.ВыгрузитьКолонку(0));
					Если ВариантыСинтаксиса.Количество() = 0 Тогда
						ВариантыСинтаксиса.Добавить();
					КонецЕсли; 
					ВариантыСинтаксиса.СортироватьПоЗначению();
				//КонецЕсли;
				
				ОткрытьПрикрепленнуюФормуВызоваМетода(СтруктураТипаКонтекста, ЭтаФорма);
				Для Каждого СтрокаПараметра Из СтрокиПараметров.НайтиСтроки(Новый Структура("ВариантСинтаксиса", ТекущийВариант)) Цикл
					ЭлементыФормы.ВызовыСлова.Колонки["Параметр" + ИндексПараметра].ТекстШапки = СтрокаПараметра.Параметр;
					ИндексПараметра = ИндексПараметра + 1;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	Если ВариантыСинтаксиса.Количество() = 0 Тогда
		ЭтаФорма.ТекущийВариант = Неопределено;
	КонецЕсли;
	ЭлементыФормы.ТекущийВариант.СписокВыбора = ВариантыСинтаксиса;
	//ЭтаФорма.ТекущийВариант = ЭтаФорма.ТекущийВариант; // Чтобы текст в поле стал отображаться
	ЭлементыФормы.ТекущийВариант.ТолькоПросмотр = ЭлементыФормы.ТекущийВариант.СписокВыбора.Количество() < 2;
	МаксЧислоПараметровВызовов = ИндексПараметра;
	Для ИндексПараметра = 0 По МаксЧислоПараметровФормы - 1 Цикл
		Колонка = ЭлементыФормы.ВызовыСлова.Колонки["Параметр" + ИндексПараметра];
		Если ИндексПараметра >= МаксЧислоПараметровВызовов Тогда
			Колонка.ТекстШапки = "Параметр" + (ИндексПараметра + 1);
		КонецЕсли;
		Если ОчиститьРезультаты Тогда
			Колонка.Видимость = ИндексПараметра < МаксЧислоПараметровВызовов;
		КонецЕсли;
	КонецЦикла; 
КонецПроцедуры

Процедура ТекущийВариантПриИзменении(Элемент)
	ЗагрузитьИскомоеСлово(Ложь);
КонецПроцедуры

Процедура НадписьКэшМодулейНажатие(Элемент)
	ПолучитьФорму("ФормаНастройки", ФормаВладелец).Открыть();
КонецПроцедуры

Процедура ДействияФормыНайтиВызовыМетода(Кнопка)
	ВыбраннаяСтрока = ЭлементыФормы.ВызовыСлова.ТекущаяСтрока;
	Если ВыбраннаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ПолеТекстаВызывающее = ирОбщий.НовыйАнализаторКодаЛкс();
	ПолеТекстаВызывающее.ИнициироватьНеинтерактивно();
	ПолеТекстаВызывающее.УстановитьТекст(ТекстФайлаСтроки(),,,, ВыбраннаяСтрока.Модуль);
	ПолеТекстаВызывающее.ОткрытьПоискВызововСлова(ВыбраннаяСтрока.ВызывающийМетод + "(",
		//ИскатьНепрямые
	);
КонецПроцедуры

Процедура ТипРодителяПриИзменении(Элемент)
	Для Каждого Строка Из ВызовыСлова Цикл
		ОбновитьПризнакТипРодителяПодходит(Строка);
	КонецЦикла;
КонецПроцедуры

Процедура ТипСловаПриИзменении(Элемент)
	ЗагрузитьИскомоеСлово();
КонецПроцедуры

Процедура ОбновитьДоступность()
	ЭлементыФормы.ТипСлова.Доступность = РежимПоиска = "Ссылки";
	ЭлементыФормы.ТипРодителя.Доступность = РежимПоиска = "Ссылки";
	ЭлементыФормы.ТекущийВариант.Доступность = РежимПоиска = "Ссылки";
	//ЭлементыФормы.ИскатьНепрямые.Доступность = РежимПоиска = "Ссылки";
	ЭлементыФормы.ВызовыСлова.Колонки.Прямой.Видимость = РежимПоиска = "Ссылки";
	ЭлементыФормы.ВызовыСлова.Колонки.Внутренний.Видимость = РежимПоиска = "Ссылки";
	ЭлементыФормы.ВызовыСлова.Колонки.ТипРодителя.Видимость = РежимПоиска = "Ссылки";
	ЭлементыФормы.ВызовыСлова.Колонки.ТипРодителяПодходит.Видимость = РежимПоиска = "Ссылки";
	ЭлементыФормы.ВызовыСлова.Колонки.Результат.Видимость = РежимПоиска = "Ссылки";
	//ЭлементыФормы.ВызовыСлова.Колонки.ВыражениеРодитель.Видимость = РежимПоиска = "Ссылки";
	Если РежимПоиска = "Ссылки" Тогда
		//ЭтаФорма.Заголовок = "Ссылки на слово";
	Иначе
		//ЭтаФорма.Заголовок = "Поиск в модулях";
		ЭтаФорма.ТипСлова = ПеречислениеТипСлова.Свойство;
	КонецЕсли;
КонецПроцедуры

Процедура РежимПоискаПриИзменении(Элемент)
	
	ОбновитьДоступность();
	
КонецПроцедуры  

Процедура ФильтрПодсистем_НачалоВыбора(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ФормаВыбора = ирКэш.Получить().ПолучитьФорму("ВыборПодсистемы", Элемент);
	ФормаВыбора.МножественныйВыбор = Истина;
	ФормаВыбора.НачальноеЗначениеВыбора = ФильтрПодсистем;
	ФормаВыбора.РежимВыбора = Истина;
	ФормаВыбора.Открыть();
	
КонецПроцедуры

Процедура ФильтрПодсистем_ПриИзменении(Элемент)

	ирКлиент.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
	
КонецПроцедуры

Процедура ФильтрПодсистемОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Элемент.Значение = ВыбранноеЗначение; // Без этого выбор из списка последних использованных не устанавливал значение
	
КонецПроцедуры 

Процедура ФильтрПодсистемНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_ОбновитьСписокЛкс(Элемент, ЭтаФорма);

КонецПроцедуры

Процедура ПриПовторномОткрытии(СтандартнаяОбработка)
	// Вставить содержимое обработчика.
КонецПроцедуры

Процедура КПФайлыНайтиВПроводнике(Кнопка)
	
	Если ЭлементыФормы.ВызовыСлова.ТекущаяСтрока <> Неопределено Тогда
		ирКлиент.ОткрытьФайлВПроводникеЛкс(мПлатформа.ФайлМодуляИзИмениМодуля(ЭлементыФормы.ВызовыСлова.ТекущаяСтрока.Модуль).ПолноеИмя);
	КонецЕсли; 

КонецПроцедуры

ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирКлсПолеТекстаПрограммы.Форма.ПоискВМодулях");
#Если Сервер И Не Сервер Тогда
	ПолеТекста = Обработки.ирОболочкаПолеТекста.Создать();
#КонецЕсли    
МаксЧислоРезультатов = 10000;
МаксЧислоПараметровФормы = 20;
РасширениеФайлаМодуля = "txt";
ПеречислениеТипСлова = мПлатформа.ПеречислениеТипСлова();
ТипСлова = ПеречислениеТипСлова.Метод;
