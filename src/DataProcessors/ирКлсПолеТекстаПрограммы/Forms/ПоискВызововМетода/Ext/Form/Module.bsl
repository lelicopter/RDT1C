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
	Если Колонка = ЭлементыФормы.Вызовы.Колонки.Ссылка Тогда
		ДействияФормыПерейтиКОпределению();
	Иначе
		Если ВыбраннаяСтрока.КраткоеИмяФайла = "<МодульКонсолиКода>" Тогда 
			ФормаВладелец.Активизировать();
			ПолеТекстаЛ = ПолеТекста;
		Иначе
			ПолеТекстаЛ = ПолеТекстаМодуляКонфигурации(ВыбраннаяСтрока.КраткоеИмяФайла).ПолеТекста;
		КонецЕсли;
		ПолеТекстаЛ.УстановитьГраницыВыделения(ВыбраннаяСтрока.Позиция, ВыбраннаяСтрока.Позиция + СтрДлина(ВыбраннаяСтрока.Текст),,, Истина);
	КонецЕсли;
	
КонецПроцедуры

Функция ТекстФайлаСтроки(Знач ВыбраннаяСтрока = Неопределено)
	
	Если ВыбраннаяСтрока = Неопределено Тогда
		ВыбраннаяСтрока = ЭлементыФормы.Вызовы.ТекущаяСтрока;
	КонецЕсли;
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.Прочитать(мПлатформа.ПапкаКэшаМодулей.ПолноеИмя + "\" + ВыбраннаяСтрока.КраткоеИмяФайла + "." + РасширениеФайлаМодуля);
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

	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	ирКлиент.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(ЭлементыФормы.ПолноеИмяМетода, ЭтаФорма);
	ВызовыМетода.Очистить();   
	ФайлыМодулей = Новый Массив;
	ПоискВДинамическомМодуле = мМодульМетаданных <> Неопределено И Не ЗначениеЗаполнено(мИмяМодуля);
	Если ПоискВДинамическомМодуле Тогда
		ФайлыМодулей.Добавить(Неопределено);
	КонецЕсли;
	Если ИскатьНепрямые Или Не ПоискВДинамическомМодуле Тогда
		ирОбщий.ДополнитьМассивЛкс(ФайлыМодулей, НайтиФайлы(мПлатформа.ПапкаКэшаМодулей.ПолноеИмя, "*." + РасширениеФайлаМодуля, Истина));
	КонецЕсли;
	мПлатформа.ИнициацияОписанияМетодовИСвойств();
	Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(ФайлыМодулей.Количество());
	ИмяРодногоМодуля = ирОбщий.ПервыйФрагментЛкс(ПолноеИмяМетода,, Ложь);
	Если Не ЗначениеЗаполнено(ИмяРодногоМодуля) Тогда
		ИмяРодногоМодуля = мИмяМодуля;
	КонецЕсли;
	шРазделитель = мПлатформа.шРазделитель; 
	Если ИскатьНепрямые Тогда
		ШаблонВнешнегоВызова = ШаблонВызоваМетода("." + ирОбщий.ПоследнийФрагментЛкс(ПолноеИмяМетода));
	Иначе
		ШаблонВнешнегоВызова = ШаблонВызоваМетода(ПолноеИмяМетода);
	КонецЕсли;
	ШаблонВнутреннегоВызова = ШаблонВызоваМетода(ирОбщий.ПоследнийФрагментЛкс(ПолноеИмяМетода));
	// На 30% медленнее будет, но зато будет отсеиваться определение метода 
	//ШаблонВнешнегоВызова    = "(?:" + мПлатформа.шПустоеНачалоСтроки + "(?:Процедура|Функция)\s*)?" + ШаблонВнешнегоВызова;
	//ШаблонВнутреннегоВызова = "(?:" + мПлатформа.шПустоеНачалоСтроки + "(?:Процедура|Функция)\s*)?" + ШаблонВнутреннегоВызова;
	ШаблонПараметра = "(" + шВыражениеПрограммы + ")?" + шРазделитель + "*(?:$|,|\))";
	МаксЧислоПараметровВызовов = 0;
	ПерваяПорцияОтображена = Ложь;
	МоментНачала = ТекущаяДата();
	Для Каждого Файл Из ФайлыМодулей Цикл
		#Если Сервер И Не Сервер Тогда
			Файл = Новый Файл;
		#КонецЕсли
		ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
		Если Файл = Неопределено Тогда
			ПолноеИмяФайла = "";
			КраткоеИмяФайла = "<МодульКонсолиКода>";
			ТекстовыйДокумент = ПолеТекста;
		Иначе
			ПолноеИмяФайла = Файл.ПолноеИмя;
			КраткоеИмяФайла = Файл.ИмяБезРасширения;
			ТекстовыйДокумент = Новый ТекстовыйДокумент;
			ТекстовыйДокумент.Прочитать(ПолноеИмяФайла);
		КонецЕсли;
		Для Счетчик = 1 По 2 Цикл
			Если Счетчик = 1 Тогда
				Если ШаблонВнешнегоВызова = ШаблонВнутреннегоВызова Тогда
					Продолжить;
				КонецЕсли;
				ШаблонВызова = ШаблонВнешнегоВызова;
			ИначеЕсли Счетчик = 2 Тогда 
				Если Ложь
					Или ИскатьНепрямые И Не ЗначениеЗаполнено(ИмяРодногоМодуля) 
					Или ирОбщий.СтрНайтиЛкс("." + КраткоеИмяФайла + ".", "." + ИмяРодногоМодуля + ".",,,, Ложь) > 0
				Тогда
					ШаблонВызова = ШаблонВнутреннегоВызова;
				Иначе
					Продолжить;
				КонецЕсли;
			КонецЕсли;
			ВхожденияВызова = ирОбщий.НайтиРегВыражениеЛкс(ТекстовыйДокумент.ПолучитьТекст(), ШаблонВызова,,,,,, Истина,,, ВхожденияВызова); // Без подгрупп для ускорения
			#Если Сервер И Не Сервер Тогда
				ВхожденияВызова = Обработки.ирПлатформа.Создать().ВхожденияРегВыражения;
			#КонецЕсли
			Для Каждого ВхождениеВызова Из ВхожденияВызова Цикл
				ТекстВхождения = СокрЛ(ВхождениеВызова.ТекстВхождения);
				//Если Ложь
				//	Или ирОбщий.СтрНачинаетсяСЛкс(ТекстВхождения, "Процедура ")
				//	Или ирОбщий.СтрНачинаетсяСЛкс(ТекстВхождения, "Функция ")
				//Тогда
				//	Продолжить;
				//КонецЕсли;
				СтрокаВызова = ВызовыМетода.Добавить();
				СтрокаВызова.КраткоеИмяФайла = КраткоеИмяФайла;
				СтрокаВызова.Внутренний = Счетчик = 2;
				СтрокаВызова.Прямой = Не ИскатьНепрямые Или СтрокаВызова.Внутренний Или ирОбщий.СтрНайтиЛкс(ВхождениеВызова.ТекстВхождения, ПолноеИмяМетода) < 3;
				СтрокаВызова.Текст = ВхождениеВызова.ТекстВхождения;
				СтрокаВызова.Позиция = ВхождениеВызова.ПозицияВхождения + 1;
				//СтрокаВызова.Активно = Не ирОбщий.СтрНачинаетсяСЛкс(ВхождениеВызова.ТекстВхождения, "//");
				ТекстВызова = Сред(ВхождениеВызова.ТекстВхождения, Найти(ВхождениеВызова.ТекстВхождения, "(") + 1);
				ВхожденияПараметров = ирОбщий.НайтиРегВыражениеЛкс(ТекстВызова, ШаблонПараметра,,,,,, Истина,,, ВхожденияПараметров);
				ИндексПараметра = 0;
				Для Каждого ВхождениеПараметра Из ВхожденияПараметров Цикл
					Если ИндексПараметра = МаксЧислоПараметровФормы Тогда
						Прервать;
					КонецЕсли;
					СтрокаВызова["Параметр" + ИндексПараметра] = СокрЛП(ирОбщий.СтрокаБезКонцаЛкс(ВхождениеПараметра.ТекстВхождения));
					ИндексПараметра = ИндексПараметра + 1;
				КонецЦикла;
				СтрокаВызова.ЧислоПараметров = ИндексПараметра - 1;
				МаксЧислоПараметровВызовов = Макс(СтрокаВызова.ЧислоПараметров, МаксЧислоПараметровВызовов);
				Если ЗначениеЗаполнено(МаксЧислоРезультатов) И ВызовыМетода.Количество() >= МаксЧислоРезультатов Тогда
					ирОбщий.СообщитьЛкс("Поиск остановлен по достижению макс. числа результатов");
					Перейти ~КонецЦикла;
				КонецЕсли; 
				Если Истина
					И Не ПерваяПорцияОтображена 
					И (Ложь
						Или ВызовыМетода.Количество() >= 50 
						Или ВызовыМетода.Количество() >= 0 И ТекущаяДата() - МоментНачала > 2)
				Тогда
					ПерваяПорцияОтображена = Истина;
					ЭлементыФормы.Вызовы.ОбновитьСтроки();
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
~КонецЦикла:
	ВызовыМетода.Сортировать("КраткоеИмяФайла, Позиция");
	ЭтаФорма.КоличествоНайдено = ВызовыМетода.Количество();
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	
	Для ИндексПараметра = 0 По МаксЧислоПараметровФормы - 1 Цикл
		Колонка = ЭлементыФормы.Вызовы.Колонки["Параметр" + ИндексПараметра];
		Колонка.Видимость = ИндексПараметра < МаксЧислоПараметровВызовов;
	КонецЦикла; 
	
КонецПроцедуры

Процедура ВызовыПриАктивизацииСтроки(Элемент)
	
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	ТекущаяСтрока = ЭлементыФормы.Вызовы.ТекущаяСтрока;
	ЭлементыФормы.ПолеТекстаВызова.УстановитьТекст("");
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если ТекущаяСтрока.КраткоеИмяФайла = "<МодульКонсолиКода>" Тогда
		ЗагрузитьМетодМодуляПоПозиции(ТекущаяСтрока.Позиция);
		ТекущаяСтрока.НомерСтрокиМодуля = мПерваяСтрокаТелаМетодаМодуля;
		Если мМетодМодуля <> Неопределено Тогда
			ТекущаяСтрока.ВызывающийМетод = мМетодМодуля.Имя;
		Иначе
			ТекущаяСтрока.ВызывающийМетод = "<Инициация>";
		КонецЕсли;
	Иначе
		ирКлиент.ПоказатьПозициюМодуляЛкс(ТекущаяСтрока, мПлатформа.ПапкаКэшаМодулей.ПолноеИмя + "\" + ТекущаяСтрока.КраткоеИмяФайла + "." + РасширениеФайлаМодуля, ЭлементыФормы.ПолеТекстаВызова, РасширениеФайлаМодуля);
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
			СтруктураТипаКонтекста = ТаблицаСтруктурТиповКонтекста[0]; // первый вариант синтаксиса
		КонецЕсли;
		СтрокаОписания = СтруктураТипаКонтекста.СтрокаОписания;
		Если СтрокаОписания <> Неопределено Тогда
			ОткрытьПрикрепленнуюФормуВызоваМетода(СтруктураТипаКонтекста, ЭтаФорма);
			Если СтрокаОписания.Владелец().Колонки.Найти("ЛиЭкспорт") <> Неопределено Тогда
				ФормальныеПараметрыМетода = мПлатформа.ПараметрыМетодаМодуля(СтрокаОписания);
				Если ФормальныеПараметрыМетода <> Неопределено Тогда
					Для Каждого СтрокаПараметра Из ФормальныеПараметрыМетода Цикл
						ЭлементыФормы.Вызовы.Колонки["Параметр" + ИндексПараметра].ТекстШапки = СтрокаПараметра.Имя;
						ИндексПараметра = ИндексПараметра + 1;
					КонецЦикла; 
				КонецЕсли;
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

ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирКлсПолеТекстаПрограммы.Форма.ПоискВызововМетода");
#Если Сервер И Не Сервер Тогда
	ПолеТекста = Обработки.ирОболочкаПолеТекста.Создать();
#КонецЕсли                                                        
МаксЧислоПараметровФормы = 20;
РасширениеФайлаМодуля = "txt"; 
