﻿Перем МаксЧислоПараметровФормы;
Перем РасширениеФайлаМодуля;

Функция СохраняемаяНастройкаФормы(выхНаименование, выхИменаСвойств) Экспорт 
	выхИменаСвойств = "Форма.ИскатьНепрямые, Форма.ПолноеИмяМетода, Форма.МаксЧислоРезультатов";
	Возврат Неопределено;
КонецФункции

Процедура ЗагрузитьНастройкуВФорме(НастройкаФормы, ДопПараметры) Экспорт 
	
	ирКлиент.ЗагрузитьНастройкуФормыЛкс(ЭтаФорма, НастройкаФормы); 
	ЗагрузитьОписаниеМетода();
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ирКлиент.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ирКлиент.СоздатьМенеджерСохраненияНастроекФормыЛкс(ЭтаФорма);
	ВызовыМетода.Очистить();
	Если ПараметрИскатьНепрямые <> Неопределено Тогда
		ЭтаФорма.ИскатьНепрямые = ПараметрИскатьНепрямые;
	КонецЕсли;
	Если ЗначениеЗаполнено(КлючУникальности) И Найти(КлючУникальности, "-") = 0 Тогда
		ЭтаФорма.ПолноеИмяМетода = КлючУникальности;
	КонецЕсли;
	СписокВыбора = ЭлементыФормы.МаксЧислоРезультатов.СписокВыбора;
	СписокВыбора.Добавить(100);
	СписокВыбора.Добавить(1000);
	СписокВыбора.Добавить(10000);
	СписокВыбора.Добавить(100000);
	ЗагрузитьОписаниеМетода();
	Если ЗначениеЗаполнено(КлючУникальности) Тогда
		//ПодключитьОбработчикОжидания("ОбновитьДанные", 0.1, Истина); // Нельзя прервать
	КонецЕсли;
	ЭтаФорма.ДатаОбновленияКэша = ирОбщий.ДатаОбновленияКэшаМодулейЛкс();

КонецПроцедуры

Процедура ОбновитьДанные() Экспорт  
	ДействияФормыНайти();
КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирКлиент.Форма_ПриЗакрытииЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ВызовыВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ТекущаяСтрока = ЭлементыФормы.Вызовы.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если Колонка = ЭлементыФормы.Вызовы.Колонки.Ссылка И ЗначениеЗаполнено(ВыбраннаяСтрока.Ссылка) Тогда 
		ДействияФормыПерейтиКОпределению();
	Иначе
		Если Не ирКлиент.ОткрытьСсылкуСтрокиМодуляЛкс(ВыбраннаяСтрока.Ссылка) Тогда 
			Если ВыбраннаяСтрока.Модуль = мПлатформа.ИмяДинамическогоМодуля() Тогда 
				ФормаВладелец.Активизировать();
				ПолеТекстаЛ = ПолеТекста;
			Иначе
				ПолеТекстаЛ = ирКлиент.ОткрытьПолеТекстаМодуляКонфигурацииЛкс(ВыбраннаяСтрока.Модуль).ПолеТекста;
			КонецЕсли;
			ПолеТекстаЛ.УстановитьГраницыВыделения(ВыбраннаяСтрока.Позиция, ВыбраннаяСтрока.Позиция + СтрДлина(ВыбраннаяСтрока.Текст),,, Истина);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция ТекстФайлаСтроки(Знач ВыбраннаяСтрока = Неопределено)
	
	Если ВыбраннаяСтрока = Неопределено Тогда
		ВыбраннаяСтрока = ЭлементыФормы.Вызовы.ТекущаяСтрока;
	КонецЕсли;
	ФайлМодуля = мПлатформа.ФайлМодуляИзКраткогоИмени(ВыбраннаяСтрока.Модуль);
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
	ПроверитьИнициировать();
КонецПроцедуры

Процедура ДействияФормыНайти(Кнопка = Неопределено)

	ирКлиент.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(ЭлементыФормы.ПолноеИмяМетода, ЭтаФорма);
	ВызовыМетода.Очистить();   
	ФайлыМодулей = Новый Массив;
	ПоискВДинамическомМодуле = Истина
		И мМодульМетаданных <> Неопределено 
		И Не ЗначениеЗаполнено(мИмяМодуля)
		И Найти(ПолноеИмяМетода, ".") = 0;
	Если ПоискВДинамическомМодуле Тогда
		ФайлыМодулей.Добавить(Неопределено);
	КонецЕсли;
	Если ИскатьНепрямые Или Не ПоискВДинамическомМодуле Тогда
		ирОбщий.ДополнитьМассивЛкс(ФайлыМодулей, НайтиФайлы(мПлатформа.ПапкаКэшаМодулей.ПолноеИмя, "*." + РасширениеФайлаМодуля, Истина));
	КонецЕсли;
	мПлатформа.ИнициацияОписанияМетодовИСвойств();
	Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(ФайлыМодулей.Количество());
	ИмяРодногоМодуляБезКонца = ирОбщий.СтрокаБезПоследнегоФрагментаЛкс(ПолноеИмяМетода);
	Если Не ЗначениеЗаполнено(ИмяРодногоМодуляБезКонца) Тогда
		ИмяРодногоМодуляБезКонца = ирОбщий.СтрокаБезПоследнегоФрагментаЛкс(мИмяМодуля);
	КонецЕсли;
	шРазделитель = мПлатформа.шРазделитель; 
	ШаблонВнешнегоПрямогоВызова = ШаблонВызоваМетода(ПолноеИмяМетода);
	ШаблонВнутреннегоВызова = ШаблонВызоваМетода(ирОбщий.ПоследнийФрагментЛкс(ПолноеИмяМетода));
	// На 30% медленнее будет, но зато будет отбрасываться определение метода 
	//ШаблонВнешнегоВызова    = "(?:" + мПлатформа.шПустоеНачалоСтроки + "(?:Процедура|Функция)\s*)?" + ШаблонВнешнегоВызова;
	//ШаблонВнутреннегоВызова = "(?:" + мПлатформа.шПустоеНачалоСтроки + "(?:Процедура|Функция)\s*)?" + ШаблонВнутреннегоВызова;
	ШаблонПараметра = "(" + шВыражениеПрограммы + ")?" + шРазделитель + "*(?:$|,|\))";
	МаксЧислоПараметровВызовов = 0;   
	СтруктураОбновленияТабличногПоля = ирКлиент.СтрукутраПервогоОбновленияТабличногоПоляЛкс();
	Для Каждого Файл Из ФайлыМодулей Цикл
		#Если Сервер И Не Сервер Тогда
			Файл = Новый Файл;
		#КонецЕсли
		Если Файл = Неопределено Тогда
			ПолноеИмяФайла = "";
			Модуль = мПлатформа.ИмяДинамическогоМодуля();
			ТекстовыйДокумент = ПолеТекста;
		Иначе
			ПолноеИмяФайла = Файл.ПолноеИмя;
			Модуль = Файл.ИмяБезРасширения;
			ТекстовыйДокумент = Новый ТекстовыйДокумент;
			ТекстовыйДокумент.Прочитать(ПолноеИмяФайла,, );
		КонецЕсли;
		ТекстМодуля = ТекстовыйДокумент.ПолучитьТекст();
		ирОбщий.ОбработатьИндикаторЛкс(Индикатор,, Модуль);
		Для Счетчик = 1 По 2 Цикл
			Если Счетчик = 1 Тогда
				ВызовыВсехМетодов = мПлатформа.ВызовыВсехМетодовПоМодулю(Модуль, ТекстовыйДокумент, Файл, ЭтотОбъект);
				НайденныеВызовы = ВызовыВсехМетодов.НайтиСтроки(Новый Структура("НИмяМетода", НРег(ирОбщий.ПоследнийФрагментЛкс(ПолноеИмяМетода))));
				Если ИскатьНепрямые Тогда 
					ВхожденияВызова = ирОбщий.НайтиРегВыражениеЛкс(ТекстМодуля, """" + ирОбщий.ПодготовитьТекстДляРегВыраженияЛкс(ПолноеИмяМетода) + """",,,,,, Истина,,, ВхожденияВызова); // Без подгрупп для ускорения
					Для Каждого Вхождение Из ВхожденияВызова Цикл
						НайденныеВызовы.Добавить(Вхождение);
					КонецЦикла;
				Иначе 
					Если ШаблонВнешнегоПрямогоВызова = ШаблонВнутреннегоВызова Тогда
						Продолжить;
					КонецЕсли;
					//ВхожденияВызова = ирОбщий.НайтиРегВыражениеЛкс(ТекстМодуля, ШаблонВнешнегоПрямогоВызова,,,,,, Истина,,, ВхожденияВызова); // Без подгрупп для ускорения
					//НайденныеВызовы = ВхожденияВызова;
				КонецЕсли;
			ИначеЕсли Счетчик = 2 Тогда 
				Если Ложь
					Или ИскатьНепрямые И Не ЗначениеЗаполнено(ИмяРодногоМодуляБезКонца) 
					Или ирОбщий.СтрНайтиЛкс("." + Модуль + ".", "." + ИмяРодногоМодуляБезКонца + ".",,,, Ложь) > 0 // TODO переделать на анализ основного объекта формы
				Тогда
					//
				Иначе
					Продолжить;
				КонецЕсли;
				ВхожденияВызова = ирОбщий.НайтиРегВыражениеЛкс(ТекстМодуля, ШаблонВнутреннегоВызова,,,,,, Истина,,, ВхожденияВызова); // Без подгрупп для ускорения
				НайденныеВызовы = ВхожденияВызова;
			КонецЕсли;
			Для Каждого ВхождениеВызова Из НайденныеВызовы Цикл
				Попытка
					ТекстВхождения = СокрЛ(ВхождениеВызова.ТекстВхождения);
				Исключение
					ТекстВхождения = Сред(ТекстМодуля, ВхождениеВызова.ПозицияВхождения, ВхождениеВызова.ДлинаВхождения);
				КонецПопытки;
				Если Лев(ТекстВхождения, 1) = "(" Тогда
					ТекстВхождения = Сред(ТекстВхождения, 2);
				КонецЕсли;
				Если Ложь
					//Или ирОбщий.СтрНачинаетсяСЛкс(ТекстВхождения, "Процедура ")
					//Или ирОбщий.СтрНачинаетсяСЛкс(ТекстВхождения, "Функция ")
					Или (Истина 
						И ИскатьНепрямые
						И Не ирОбщий.СтрНачинаетсяСЛкс(ТекстВхождения, ПолноеИмяМетода) 
						И (Ложь
							Или ирОбщий.ЕдинственноеИмяМДЛкс(ирОбщий.ПервыйФрагментЛкс(ТекстВхождения)) <> Неопределено
							Или Метаданные.ОбщиеМодули.Найти(ирОбщий.ПервыйФрагментЛкс(ТекстВхождения)) <> Неопределено))
				Тогда
					Продолжить;
				КонецЕсли;
				ЛиПрямойВызов = Не ИскатьНепрямые Или Счетчик = 2 Или ирОбщий.СтрНайтиЛкс(ТекстВхождения, ПолноеИмяМетода) < 4;
				Если Не ЛиПрямойВызов И Не ИскатьНепрямые Тогда
					Продолжить;
				КонецЕсли;
				СтрокаВызова = ВызовыМетода.Добавить();
				СтрокаВызова.Модуль = Модуль;
				СтрокаВызова.Внутренний = Счетчик = 2;
				СтрокаВызова.Прямой = ЛиПрямойВызов;
				СтрокаВызова.Текст = СокрЛ(ТекстВхождения);
				СтрокаВызова.Позиция = ВхождениеВызова.ПозицияВхождения + 1;
				//СтрокаВызова.Активно = Не ирОбщий.СтрНачинаетсяСЛкс(ВхождениеВызова.ТекстВхождения, "//");
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
				МаксЧислоПараметровВызовов = Макс(СтрокаВызова.ЧислоПараметров, МаксЧислоПараметровВызовов);
				Если ЗначениеЗаполнено(МаксЧислоРезультатов) И ВызовыМетода.Количество() >= МаксЧислоРезультатов Тогда
					ирОбщий.СообщитьЛкс("Поиск остановлен по достижению макс. числа результатов");
					Перейти ~КонецЦикла;
				КонецЕсли; 
				Если Не СтруктураОбновленияТабличногПоля.ПерваяПорцияОтображена Тогда
					УточнитьСтрокуРезультата(СтрокаВызова);
				КонецЕсли;
				ирКлиент.ПроверитьПервоеОбновлениеТабличногоПоляЛкс(ЭлементыФормы.Вызовы, СтруктураОбновленияТабличногПоля);
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
~КонецЦикла:
	ВызовыМетода.Сортировать("Модуль, Позиция");
	ЭтаФорма.КоличествоНайдено = ВызовыМетода.Количество();
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	
	Для ИндексПараметра = 0 По МаксЧислоПараметровФормы - 1 Цикл
		Колонка = ЭлементыФормы.Вызовы.Колонки["Параметр" + ИндексПараметра];
		Колонка.Видимость = ИндексПараметра < МаксЧислоПараметровВызовов;
	КонецЦикла;
	ЭтаФорма.ТекущийЭлемент = ЭлементыФормы.Вызовы;
	
КонецПроцедуры

Процедура ВызовыПриАктивизацииСтроки(Элемент)
	
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	ЭлементыФормы.ПолеТекстаВызова.УстановитьТекст("");
	ТекущаяСтрока = ЭлементыФормы.Вызовы.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	УточнитьСтрокуРезультата(ТекущаяСтрока);
	
КонецПроцедуры

//.
// Параметры:
//    ТекущаяСтрока - , ? - 
Процедура УточнитьСтрокуРезультата(ТекущаяСтрока) Экспорт
	Если ТекущаяСтрока.Модуль = мПлатформа.ИмяДинамическогоМодуля() Тогда
		ЗагрузитьМетодМодуляПоПозиции(ТекущаяСтрока.Позиция);
		ТекущаяСтрока.НомерСтрокиМодуля = НомерСтрокиИзПозиции(ТекущаяСтрока.Позиция);
		Если мМетодМодуля <> Неопределено Тогда
			ТекущаяСтрока.ВызывающийМетод = мМетодМодуля.Имя;
		Иначе
			ТекущаяСтрока.ВызывающийМетод = мПлатформа.ИмяМетодаИнициация();
		КонецЕсли;
	Иначе
		ирКлиент.РазобратьПозициюМодуляВСтрокеТаблицыЛкс(ТекущаяСтрока, ТекущаяСтрока.Модуль, ЭлементыФормы.ПолеТекстаВызова);
	КонецЕсли;
КонецПроцедуры

Процедура ВызовыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	ирКлиент.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
КонецПроцедуры

Процедура ДействияФормыПерейтиКОпределению(Кнопка = Неопределено)
	
	ТекущаяСтрока = ЭлементыФормы.Вызовы.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ирКлиент.ПоказатьСсылкуНаСтрокуМодуляЛкс(ТекущаяСтрока.Ссылка);
	
КонецПроцедуры

Процедура ПолноеИмяМетодаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка = Истина)
	ирОбщий.ПолеВводаСИсториейВыбора_ОбновитьСписокЛкс(Элемент, ЭтаФорма);
КонецПроцедуры

Процедура ПолноеИмяМетодаПриИзменении(Элемент)
	ЭтаФорма.ПараметрСтруктураТипаКонтекста = Неопределено;
	ЗагрузитьОписаниеМетода();
КонецПроцедуры

Процедура ЗагрузитьОписаниеМетода()
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	//ЭлементыФормы.ИскатьНепрямые.Доступность = Найти(ПолноеИмяМетода, ".") > 0;
	ирОбщий.ОбновитьТекстПослеМаркераЛкс(ЭтаФорма.Заголовок,, ПолноеИмяМетода, ": "); 
	ИндексПараметра = 0; 
	ВызовыМетода.Очистить();
	ВариантыСинтаксиса = Новый СписокЗначений;
	Если ЗначениеЗаполнено(ПолноеИмяМетода) Тогда 
		Если ПараметрСтруктураТипаКонтекста <> Неопределено Тогда 
			СтруктураТипаКонтекста = ПараметрСтруктураТипаКонтекста;
		Иначе
			Фрагменты = ирОбщий.СтрРазделитьЛкс(ПолноеИмяМетода, " ");
			ПредшествующийТекст = "";
			Если Фрагменты.Количество() > 1 Тогда
				ПредшествующийТекст = Фрагменты[0];
				Фрагменты.Удалить(0);
			КонецЕсли;
			ТаблицаСтруктурТиповКонтекста = ВычислитьТипЗначенияВыражения(Фрагменты[0] + "(",, ПредшествующийТекст,, ЗначениеЗаполнено(ПредшествующийТекст));
			Если ТаблицаСтруктурТиповКонтекста.Количество() = 0 Тогда
				СтруктураТипаКонтекста = мПлатформа.НоваяСтруктураТипа();
			Иначе 
				СтруктураТипаКонтекста = ТаблицаСтруктурТиповКонтекста[0]; // первый вариант синтаксиса
			КонецЕсли;
		КонецЕсли;
		СтрокаОписания = СтруктураТипаКонтекста.СтрокаОписания;
		Если СтрокаОписания <> Неопределено Тогда
			ОткрытьПрикрепленнуюФормуВызоваМетода(СтруктураТипаКонтекста, ЭтаФорма);
			Если СтрокаОписания.Владелец().Колонки.Найти("ЛиЭкспорт") <> Неопределено Тогда
				ФормальныеПараметрыМетода = мПлатформа.ПараметрыМетодаМодуля(СтрокаОписания);
				Если ФормальныеПараметрыМетода <> Неопределено Тогда
					Для Каждого СтрокаПараметра Из ФормальныеПараметрыМетода Цикл
						КолонкаПараметра = ЭлементыФормы.Вызовы.Колонки["Параметр" + ИндексПараметра];
						КолонкаПараметра.ТекстШапки = СтрокаПараметра.Имя;
						ИндексПараметра = ИндексПараметра + 1;
						Если ирОбщий.СтрокиРавныЛкс(СтрокаПараметра.Имя, ПараметрИмяПараметра) Тогда
							КолонкаПараметра.Видимость = Истина;
							ЭлементыФормы.Вызовы.ТекущаяКолонка = КолонкаПараметра;
						КонецЕсли;
					КонецЦикла; 
				КонецЕсли;
				ЭтаФорма.ПараметрИмяПараметра = "";
			ИначеЕсли СтрокаОписания.Владелец().Колонки.Найти("ТипКонтекста") <> Неопределено Тогда
				ЛиТекущийВариантУстановленВручную = ЗначениеЗаполнено(ЭтаФорма.ТекущийВариант);
				КоличествоФактПараметров = 0;
				
				// Мультиметка06322413
				СтрокиПараметров = мПлатформа.ПараметрыМетодаПлатформы(СтрокаОписания);
				#Если Сервер И Не Сервер Тогда
					СтрокиПараметров = Новый ТаблицаЗначений;
				#КонецЕсли
				НомерВарианта = 0;
				//Если Не ЛиТекущийВариантУстановленВручную Тогда
					ТаблицаВариантов = СтрокиПараметров.Скопировать();
					ЭтаФорма.ТекущийВариант = мПлатформа.ПодобратьВариантСинтаксисаМетода(ТаблицаВариантов, КоличествоФактПараметров, ТекущийВариант, ЛиТекущийВариантУстановленВручную, НомерВарианта);
					ВариантыСинтаксиса.ЗагрузитьЗначения(ТаблицаВариантов.ВыгрузитьКолонку(0));
					Если ВариантыСинтаксиса.Количество() = 0 Тогда
						ВариантыСинтаксиса.Добавить();
					КонецЕсли; 
					ВариантыСинтаксиса.СортироватьПоЗначению();
				//КонецЕсли;
				
				Для Каждого СтрокаПараметра Из СтрокиПараметров.НайтиСтроки(Новый Структура("ВариантСинтаксиса", ТекущийВариант)) Цикл
					ЭлементыФормы.Вызовы.Колонки["Параметр" + ИндексПараметра].ТекстШапки = СтрокаПараметра.Параметр;
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
		Колонка = ЭлементыФормы.Вызовы.Колонки["Параметр" + ИндексПараметра];
		Если ИндексПараметра >= МаксЧислоПараметровВызовов Тогда
			Колонка.ТекстШапки = "Параметр" + (ИндексПараметра + 1);
		КонецЕсли;
		Колонка.Видимость = ИндексПараметра < МаксЧислоПараметровВызовов;
	КонецЦикла; 
КонецПроцедуры

Процедура ТекущийВариантПриИзменении(Элемент)
	ЗагрузитьОписаниеМетода();
КонецПроцедуры

Процедура НадписьКэшМодулейНажатие(Элемент)
	ПолучитьФорму("ФормаНастройки", ФормаВладелец).Открыть();
КонецПроцедуры

Процедура ДействияФормыНайтиВызовыМетода(Кнопка)
	ВыбраннаяСтрока = ЭлементыФормы.Вызовы.ТекущаяСтрока;
	Если ВыбраннаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ПолеТекстаВызывающее = ирОбщий.НовыйАнализаторКодаЛкс();
	ПолеТекстаВызывающее.ИнициироватьНеинтерактивно();
	ПолеТекстаВызывающее.УстановитьТекст(ТекстФайлаСтроки(),,,, ВыбраннаяСтрока.Модуль);
	ПолеТекстаВызывающее.ОткрытьПоискВызововМетода(ВыбраннаяСтрока.ВызывающийМетод, ИскатьНепрямые);
КонецПроцедуры

ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирКлсПолеТекстаПрограммы.Форма.СсылкиНаМетод");
#Если Сервер И Не Сервер Тогда
	ПолеТекста = Обработки.ирОболочкаПолеТекста.Создать();
#КонецЕсли                                                        
МаксЧислоПараметровФормы = 20;
РасширениеФайлаМодуля = "txt";
