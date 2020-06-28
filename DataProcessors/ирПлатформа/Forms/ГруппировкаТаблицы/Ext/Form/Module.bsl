﻿Перем мТаблицаИсточника;
Перем мСтруктураИсточника;
Перем мСхемаКомпоновки;
перем мСтрокаПолейКлюча;
Перем мСтарыйСнимокНастройкиКомпоновки;

Процедура ПриОткрытии()
	
	Если ЭтаФорма.ВладелецФормы <> Неопределено Тогда
		УстановитьИсточник();
		Если ЗначениеЗаполнено(ПараметрИменаКлючевыхКолонок) Тогда
			ИменаКолонок = ирОбщий.СтрРазделитьЛкс(ПараметрИменаКлючевыхКолонок, "," , Истина, Ложь);
			Для Каждого ИмяКолонки Из ИменаКолонок Цикл
				ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(Компоновщик.Настройки.Порядок, ИмяКолонки);
			КонецЦикла;
			МинимальныйРазмерГруппы = 2;
			КПКлючиСтрокВыполнить();
			КПКлючиСтрокВыделитьВИсточнике();
		КонецЕсли; 
		Если Компоновщик.Настройки.Отбор.Элементы.Количество() = 0 И ВладелецФормы.ТекущаяСтрока <> Неопределено Тогда
			Для Каждого ДоступноеПоле Из Компоновщик.Настройки.Отбор.ДоступныеПоляОтбора.Элементы Цикл
				ИмяКолонкиИсточника = "" + ДоступноеПоле.Поле;
				Если мТаблицаИсточника.Колонки.Найти(ИмяКолонкиИсточника) = Неопределено Тогда
					Продолжить;
				КонецЕсли; 
				ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(Компоновщик.Настройки.Отбор, ДоступноеПоле.Поле, ВладелецФормы.ТекущаяСтрока[ИмяКолонкиИсточника],,,, Ложь);
			КонецЦикла;
		КонецЕсли; 
	КонецЕсли; 
	СворачиватьСразуПриИзменении();
	
КонецПроцедуры

Функция УстановитьИсточник()
	
	мПлатформа = ирКэш.Получить();
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	ИсточникДействий = ЭтаФорма.ВладелецФормы;
	ДанныеКолонки = ирОбщий.ПутьКДаннымКолонкиТабличногоПоляЛкс(ИсточникДействий);
	ЗначениеТабличногоПоля = ирОбщий.ДанныеЭлементаФормыЛкс(ИсточникДействий);
	СтруктураТипа = Неопределено;
	ИмяТипаЗначения = ирОбщий.ОбщийТипДанныхТабличногоПоляЛкс(ИсточникДействий, , СтруктураТипа);
	ЭтаФорма.Отбор = Неопределено;
	Если ИмяТипаЗначения = "ТаблицаЗначений" Тогда 
	Иначе
		Если ИмяТипаЗначения = "ТабличнаяЧасть" Тогда 
			ЭтаФорма.Отбор = ИсточникДействий.ОтборСтрок;
		ИначеЕсли ИмяТипаЗначения = "НаборЗаписей" Тогда 
			ЭтаФорма.Отбор = ИсточникДействий.ОтборСтрок;
		Иначе
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	Если Отбор <> Неопределено Тогда
		ирОбщий.СкопироватьОтборЛюбойЛкс(Компоновщик.Настройки.Отбор, Отбор);
	КонецЕсли; 
	мТаблицаИсточника = ирОбщий.ТаблицаЗначенийИзТабличногоПоляЛкс(ИсточникДействий);
	мТаблицаИсточника = ирОбщий.ПолучитьТаблицуСМинимальнымиТипамиКолонокЛкс(мТаблицаИсточника);
	мСтруктураИсточника = Новый Структура("Таблица", мТаблицаИсточника);
	мСхемаКомпоновки = ирОбщий.СоздатьСхемуПоТаблицамЗначенийЛкс(мСтруктураИсточника);
	ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(мСхемаКомпоновки);
	Компоновщик.Инициализировать(ИсточникНастроек);
	ЭлементПорядка = ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(Компоновщик.Настройки.Порядок, "КоличествоСтрокАвто");
	ЭлементПорядка.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Убыв;
	ЭтаФорма.СтрокиТекущегоКлюча = мТаблицаИсточника.СкопироватьКолонки();
	//ЭлементыФормы.СтрокиТекущегоКлюча.Колонки.Очистить();
	ЭлементыФормы.СтрокиТекущегоКлюча.СоздатьКолонки();
	ирОбщий.НастроитьДобавленныеКолонкиТабличногоПоляЛкс(ЭлементыФормы.СтрокиТекущегоКлюча,,,, Истина);
	
КонецФункции

Процедура КПКлючиСтрокВыполнить(Кнопка = Неопределено, РежимОтладки = Неопределено)
	
	Если мСхемаКомпоновки = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	КлючиСтрок.Очистить();
	КлючиСтрок.Колонки.Очистить();
	ЭлементыФормы.КлючиСтрок.Колонки.Очистить();
	ВременныеНастройки = Компоновщик.ПолучитьНастройки();
	Если ВременныеНастройки.Структура.Количество() = 0 Тогда
		ирОбщий.НайтиДобавитьЭлементСтруктурыГруппировкаКомпоновкиЛкс(ВременныеНастройки.Структура);
	КонецЕсли;
	ПоляГруппировки = ВременныеНастройки.Структура[0].ПоляГруппировки.Элементы;
	ПоляГруппировки.Очистить();
	ВременныеНастройки.Выбор.Элементы.Очистить();
	мСтрокаПолейКлюча = Новый Массив;
	Для Каждого ЭлементПорядка Из ВременныеНастройки.Порядок.Элементы Цикл
		Если ЭлементПорядка.Использование Тогда
			Если "" + ЭлементПорядка.Поле <> "КоличествоСтрокАвто" Тогда
				мСтрокаПолейКлюча.Добавить("" + ЭлементПорядка.Поле);
				ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(ПоляГруппировки, ЭлементПорядка.Поле);
			КонецЕсли; 
			ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(ВременныеНастройки.Выбор, ЭлементПорядка.Поле);
		КонецЕсли; 
	КонецЦикла;
	ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(ВременныеНастройки.Выбор, "КоличествоСтрокАвто");
	ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(ВременныеНастройки.Структура[0].Отбор, "КоличествоСтрокАвто", МинимальныйРазмерГруппы, ВидСравненияКомпоновкиДанных.БольшеИлиРавно);
	ирОбщий.СкомпоноватьВКоллекциюЗначенийПоСхемеЛкс(мСхемаКомпоновки, ВременныеНастройки, КлючиСтрок, мСтруктураИсточника,,,,, РежимОтладки);
	мСтарыйСнимокНастройкиКомпоновки = ирОбщий.СохранитьОбъектВВидеСтрокиXMLЛкс(Компоновщик.Настройки);
	ЭтаФорма.КлючиСтрокКоличество = КлючиСтрок.Количество();
	ЭтаФорма.СтрокиТекущегоКлючаКоличество = 0;
	ЭлементыФормы.КлючиСтрок.СоздатьКолонки();
	ирОбщий.НастроитьДобавленныеКолонкиТабличногоПоляЛкс(ЭлементыФормы.КлючиСтрок,,,, Истина);
	мСтрокаПолейКлюча = ирОбщий.СтрСоединитьЛкс(мСтрокаПолейКлюча);
	Если КлючиСтрок.Количество() > 0 Тогда
		ЭлементыФормы.КлючиСтрок.ТекущаяСтрока = КлючиСтрок[0];
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПриПолученииДанныхДоступныхПолей(Элемент, ОформленияСтрок)

	ирОбщий.ПриПолученииДанныхДоступныхПолейКомпоновкиЛкс(ОформленияСтрок);

КонецПроцедуры

Процедура КлючиСтрокПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки, ЭлементыФормы.КПКлючиСтрок.Кнопки.Идентификаторы);
	
КонецПроцедуры

Процедура МинимальныйРазмерГруппыПриИзменении(Элемент)
	
	ПроверитьИСгруппировать();
	
КонецПроцедуры

Процедура ПроверитьИСгруппировать()
	
	Если СворачиватьСразу Тогда
		КПКлючиСтрокВыполнить();
	КонецЕсли; 
	
КонецПроцедуры

Процедура КлючевыеКолонкиПриИзмененииФлажка(Элемент, Колонка)
	
	ПроверитьИСгруппировать();
	
КонецПроцедуры

Процедура СтрокиТекущегоКлючаПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки, ЭлементыФормы.КПСтрокиТекущегоКлюча.Кнопки.Идентификаторы);

КонецПроцедуры

Процедура КПСтрокиТекущегоКлючаИдентификаторы(Кнопка)
	
	ирОбщий.КнопкаОтображатьПустыеИИдентификаторыНажатиеЛкс(Кнопка);
	ЭлементыФормы.СтрокиТекущегоКлюча.ОбновитьСтроки();
	
КонецПроцедуры

Процедура КПКлючиСтрокИдентификаторы(Кнопка)
	
	ирОбщий.КнопкаОтображатьПустыеИИдентификаторыНажатиеЛкс(Кнопка);
	ЭлементыФормы.КлючиСтрок.ОбновитьСтроки();

КонецПроцедуры

Процедура ДействияФормыСтруктураФормы(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруФормыЛкс(ЭтаФорма);

КонецПроцедуры

Процедура ДействияФормыОПодсистеме(Кнопка)
	
	ирОбщий.ОткрытьСправкуПоПодсистемеЛкс(ЭтотОбъект);
	
КонецПроцедуры

Процедура КПКлючиСтрокОткрытьТаблицу(Кнопка)
	
	ирОбщий.ОткрытьЗначениеЛкс(КлючиСтрок,,,,,, ЭлементыФормы.КлючиСтрок);
	
КонецПроцедуры

Процедура КПСтрокиТекущегоКлючаАвтовидимостьКолонок(Кнопка)
	
	ЭтаФорма.АвтовидимостьКолонокСоставаГруппы = Не Кнопка.Пометка;
	ПриИзмененииАвтовидимостьКолонокСоставаГруппы();
	
КонецПроцедуры

Процедура ПриИзмененииАвтовидимостьКолонокСоставаГруппы()
	
	ЭлементыФормы.КПСтрокиТекущегоКлюча.Кнопки.АвтовидимостьКолонок.Пометка = АвтовидимостьКолонокСоставаГруппы;
	ирОбщий.СкрытьПоказатьОднозначныеКолонкиТабличногоПоляЛкс(ЭлементыФормы.СтрокиТекущегоКлюча, АвтовидимостьКолонокСоставаГруппы);
	
КонецПроцедуры

Процедура КлючиСтрокПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	СтрокиТекущегоКлюча.Очистить();
	ЭтаФорма.СтрокиТекущегоКлючаКоличество = 0;
	Если ЭлементыФормы.КлючиСтрок.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ВременныеНастройки = Компоновщик.ПолучитьНастройки();
	ТекущийКлюч = Новый Структура(мСтрокаПолейКлюча);
	ЗаполнитьЗначенияСвойств(ТекущийКлюч, ЭлементыФормы.КлючиСтрок.ТекущаяСтрока); 
	Для Каждого КлючИЗначение Из ТекущийКлюч Цикл
		ЭлементОтбора = ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(ВременныеНастройки.Отбор, КлючИЗначение.Ключ, КлючИЗначение.Значение);
		#Если Сервер И Не Сервер Тогда
			ЭлементОтбора = ВременныеНастройки.Отбор.Элементы.Добавить();
		#КонецЕсли
		ЭлементОтбора.Использование = Истина;
	КонецЦикла;
	ВременныеНастройки.Выбор.Элементы.Очистить();
	Для Каждого ДоступноеПоле Из ВременныеНастройки.ДоступныеПоляВыбора.Элементы Цикл
		Если Не ДоступноеПоле.Папка И "" + ДоступноеПоле.Поле <> "КоличествоСтрокАвто" Тогда
			ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(ВременныеНастройки.Выбор, ДоступноеПоле.Поле);
		КонецЕсли;
	КонецЦикла;
	ирОбщий.СкомпоноватьВКоллекциюЗначенийПоСхемеЛкс(мСхемаКомпоновки, ВременныеНастройки, СтрокиТекущегоКлюча, мСтруктураИсточника);
	ЭтаФорма.СтрокиТекущегоКлючаКоличество = СтрокиТекущегоКлюча.Количество();
	ПриИзмененииАвтовидимостьКолонокСоставаГруппы();
	
КонецПроцедуры

Процедура СтрокиТекущегоКлючаПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);

КонецПроцедуры

Процедура КПКлючиСтрокРедакторОбъектаБД(Кнопка)
	
	ирОбщий.ОткрытьСсылкуЯчейкиВРедактореОбъектаБДЛкс(ЭлементыФормы.КлючиСтрок);
	
КонецПроцедуры

Процедура КПКлючиСтрокМенеджерТабличногоПоля(Кнопка)
	
	ирОбщий.ОткрытьМенеджерТабличногоПоляЛкс(ЭлементыФормы.КлючиСтрок, ЭтаФорма);
	
КонецПроцедуры

Процедура КПКлючиСтрокОбработатьОбъекты(Кнопка)
	
	ирОбщий.ОткрытьОбъектыИзВыделенныхЯчеекВПодбореИОбработкеОбъектовЛкс(ЭтаФорма.ЭлементыФормы.КлючиСтрок);
	
КонецПроцедуры

Процедура КПСтрокиТекущегоКлючаОбработатьОбъекты(Кнопка)
	
	ирОбщий.ОткрытьОбъектыИзВыделенныхЯчеекВПодбореИОбработкеОбъектовЛкс(ЭтаФорма.ЭлементыФормы.СтрокиТекущегоКлюча);
	
КонецПроцедуры

Процедура ДействияФормыИсходнаяТаблица(Кнопка)
	
	ирОбщий.ОткрытьЗначениеЛкс(мТаблицаИсточника);
	
КонецПроцедуры

Процедура КлючиСтрокВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ирОбщий.ЯчейкаТабличногоПоляРасширенногоЗначения_ВыборЛкс(ЭтаФорма, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура СтрокиТекущегоКлючаВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ирОбщий.ЯчейкаТабличногоПоляРасширенногоЗначения_ВыборЛкс(ЭтаФорма, Элемент, СтандартнаяОбработка);

КонецПроцедуры

Процедура КПКлючиСтрокВыделитьВИсточнике(Кнопка = Неопределено)
	
	Если ЭлементыФормы.КлючиСтрок.ТекущаяСтрока = Неопределено Или Не ЗначениеЗаполнено(мСтрокаПолейКлюча) Тогда
		Возврат;
	КонецЕсли; 
	ирОбщий.ВыделитьСтрокиТабличногоПоляПоКлючуЛкс(ЭтаФорма.ВладелецФормы, ЭлементыФормы.КлючиСтрок.ТекущаяСтрока, мСтрокаПолейКлюча);
	
КонецПроцедуры

Процедура КПСтрокиТекущегоКлючаРазличныеЗначенияКолонки(Кнопка)
	
	ирОбщий.ОткрытьРазличныеЗначенияКолонкиЛкс(ЭлементыФормы.СтрокиТекущегоКлюча);
	
КонецПроцедуры

Процедура КПКлючиСтрокРазличныеЗначенияКолонки(Кнопка)
	
	ирОбщий.ОткрытьРазличныеЗначенияКолонкиЛкс(ЭлементыФормы.КлючиСтрок);

КонецПроцедуры

Процедура ДействияФормыИсполняемаяКомпоновка(Кнопка)
	
	КПКлючиСтрокВыполнить(, Истина);
	
КонецПроцедуры

Процедура ПослеВосстановленияЗначений()
	
	ПриИзмененииАвтовидимостьКолонокСоставаГруппы();
	СворачиватьСразуПриИзменении();
	
КонецПроцедуры

Процедура МинимальныйРазмерГруппыОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Элемент.Значение = Элемент.МинимальноеЗначение;
	
КонецПроцедуры

Процедура СворачиватьСразуПриИзменении(Элемент = Неопределено)
	
	Если СворачиватьСразу Тогда
		ПроверитьИСгруппировать();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	ЭлементыФормы.НадписьОтбор.Заголовок = ирОбщий.ПредставлениеОтбораЛкс(Компоновщик.Настройки.Отбор);
	Если СворачиватьСразу Тогда
		Если мСтарыйСнимокНастройкиКомпоновки <> ирОбщий.СохранитьОбъектВВидеСтрокиXMLЛкс(Компоновщик.Настройки) Тогда
			КПКлючиСтрокВыполнить();
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДоступныеПоляВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(ЭлементыФормы.КлючевыеКолонки, ВыбраннаяСтрока.Поле,,, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура КлючевыеКолонкиВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ирОбщий.ТабличноеПолеПорядкаКомпоновкиВыборЛкс(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОтборПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	
КонецПроцедуры

Процедура КлючевыеКолонкиПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);

КонецПроцедуры

Процедура КлючевыеКолонкиПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
	
КонецПроцедуры

Процедура ОтборПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);

КонецПроцедуры

Процедура КлсУниверсальнаяКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура КПСтрокиТекущегоКлючаВыделитьВИсточнике(Кнопка)
	
	ирОбщий.ВыделитьСтрокиТабличногоПоляПоКлючуЛкс(ЭтаФорма.ВладелецФормы, ЭлементыФормы.СтрокиТекущегоКлюча.ТекущаяСтрока,, Ложь);
	
КонецПроцедуры

Процедура КПСтрокиТекущегоКлючаОткрытьТаблицу(Кнопка)
	
	ирОбщий.ОткрытьЗначениеЛкс(СтрокиТекущегоКлюча,,,,,, ЭлементыФормы.СтрокиТекущегоКлюча);
	
КонецПроцедуры

Процедура КлючевыеКолонкиПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Колонка)
	
	ирОбщий.ТабличноеПолеЭлементовКомпоновкиПеретаскиваниеЛкс(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Колонка);
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.ГруппировкаТаблицы");
ирОбщий.ПодключитьОбработчикиСобытийДоступныхПолейКомпоновкиЛкс(ЭлементыФормы.ДоступныеПоля);
АвтовидимостьКолонокСоставаГруппы = Истина;
