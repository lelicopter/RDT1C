﻿Перем мСхемаКомпоновки;
Перем мИмяТаблицыОстатков;
Перем мОбъектМДРегистра;
Перем мИменаРесурсов;
Перем мИменаИзмерений; 
Перем мИменаИзмеренийСВидами; 
Перем ИмяСиноним;

Функция СохраняемаяНастройкаФормы(выхНаименование, выхИменаСвойств) Экспорт 
	выхИменаСвойств = "Форма.ИмяТаблицыРегистра, Форма.ТипРегистратора, Форма.Регистратор, Форма.Дата, Форма.КорСчет, Форма.ДляСвертки";
	Возврат Неопределено;
КонецФункции

Процедура ЗагрузитьНастройкуВФорме(НастройкаФормы, ДопПараметры) Экспорт 
	
	ирКлиент.ЗагрузитьНастройкуФормыЛкс(ЭтаФорма, НастройкаФормы); 
	Если НастройкаФормы = Неопределено Тогда
		ЭтаФорма.ИмяТаблицыРегистра = "";
	КонецЕсли;
	ИмяТаблицыРегистраПриИзменении();

КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	ирКлиент.Форма_ОбновлениеОтображенияЛкс(ЭтаФорма);
	ирКлиент.ТабличноеПолеСОтборомПросмотраОбновитьПредставлениеЛкс(ЭтаФорма, ЭлементыФормы.НаборЗаписей); 
	
КонецПроцедуры

Функция ПараметрыВыбораОбъектаМетаданных()
	Параметры = Новый Структура;
	ДоступныеОбъекты = Новый Массив;
	Для Каждого ОписаниеТаблицы Из ирКэш.ТаблицаВсехТаблицБДЛкс() Цикл
		Если ирОбщий.СтрКончаетсяНаЛкс(ОписаниеТаблицы.ПолноеИмя, ".Остатки") Тогда
			ДоступныеОбъекты.Добавить(ирОбщий.СтрокаБезПоследнегоФрагментаЛкс(ОписаниеТаблицы.ПолноеИмя));
		КонецЕсли;
	КонецЦикла;
	Параметры.Вставить("ДоступныеОбъекты", ДоступныеОбъекты);
	Параметры.Вставить("ОтображатьРегистры", Истина);
	Возврат Параметры;
КонецФункции

Процедура ИмяОсновнойТаблицыНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ирКлиент.ОбъектМетаданныхНачалоВыбораЛкс(Элемент, ПараметрыВыбораОбъектаМетаданных(), СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ИмяСинонимПриИзменении(Элемент = Неопределено)
	
	#Если Сервер И Не Сервер Тогда
		мСхемаКомпоновки = Новый СхемаКомпоновкиДанных;
	#КонецЕсли                                         
	Если ИмяСиноним Тогда
		ОсновноеПоле = "Имя";
	Иначе
		ОсновноеПоле = "Заголовок";
	КонецЕсли;
	мСхемаКомпоновки.НаборыДанных[0].Поля.Очистить();
	ПоляТаблицы = ирКэш.ПоляТаблицыБДЛкс(мИмяТаблицыОстатков);
	Для Каждого Колонка Из ПоляТаблицы Цикл
		КолонкаТП = ЭлементыФормы.НаборЗаписей.Колонки.Найти(Колонка.Имя);
		Если КолонкаТП <> Неопределено Тогда
			КолонкаТП.ТекстШапки = Колонка[ОсновноеПоле];
		КонецЕсли; 
		ПолеНабора = мСхемаКомпоновки.НаборыДанных[0].Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
		ПолеНабора.ПутьКДанным = Колонка.Имя;
		ПолеНабора.Поле = Колонка.Имя;
		Если ИмяСиноним Тогда
			ПолеНабора.Заголовок = Колонка.Имя;
		Иначе 
			ПолеНабора.Заголовок = Колонка.Заголовок;
		КонецЕсли;
	КонецЦикла;
	Компоновщик.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(мСхемаКомпоновки));

КонецПроцедуры

Процедура ПриПолученииДанныхДоступныхПолей(Элемент, ОформленияСтрок)

	ирКлиент.ПриПолученииДанныхТабличногоПоляКомпоновкиЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура ИмяТаблицыРегистраПриИзменении(Элемент = Неопределено)
	
	Элемент = ЭлементыФормы.ИмяТаблицыРегистра;
	мИменаРесурсов = Новый Массив;
	мИменаИзмерений = Новый Массив; 
	мОбъектМДРегистра = Неопределено;
	Компоновщик.ЗагрузитьНастройки(Новый НастройкиКомпоновкиДанных);
	Если ЗначениеЗаполнено(ИмяТаблицыРегистра) Тогда
		мОбъектМДРегистра = Метаданные.НайтиПоПолномуИмени(ИмяТаблицыРегистра);
		#Если Сервер И Не Сервер Тогда
			мОбъектМДРегистра = Метаданные.РегистрыБухгалтерии.Хозрасчетный;
		#КонецЕсли
	КонецЕсли;
	ЭлементыФормы.КорСчет.Доступность = мОбъектМДРегистра <> Неопределено И Метаданные.РегистрыБухгалтерии.Индекс(мОбъектМДРегистра) >= 0;
	Если мОбъектМДРегистра <> Неопределено Тогда
		мИмяТаблицыОстатков = ИмяТаблицыРегистра + ".Остатки";
		
		Запрос = Новый Запрос("ВЫБРАТЬ * ИЗ " + ИмяТаблицыРегистра + ".Остатки({&Период})");
		мСхемаКомпоновки = ирОбщий.СоздатьСхемуКомпоновкиПоЗапросу(Запрос);
		//
		//мСхемаКомпоновки = ирОбщий.СоздатьСхемуКомпоновкиТаблицыБДЛкс(мИмяТаблицыОстатков,,,,, ИмяСиноним, Истина);
		
		Компоновщик.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(мСхемаКомпоновки));
		Для Каждого ДоступноеПоле Из Компоновщик.Настройки.Выбор.ДоступныеПоляВыбора.Элементы Цикл
			Если ДоступноеПоле.Папка Тогда
				Продолжить;
			КонецЕсли;
			Если ЛиПолеОстатка(ДоступноеПоле.Поле) Тогда
				Если Не ирОбщий.СтрКончаетсяНаЛкс(ДоступноеПоле.Поле, "Остаток") Тогда
					// Регистр бухгалтерии - Дт/Кт/Развернутый
					Продолжить;
				КонецЕсли;
				мИменаРесурсов.Добавить(ирОбщий.СтрокаБезПоследнегоФрагментаЛкс(ДоступноеПоле.Поле, "Остаток"));
			Иначе
				мИменаИзмерений.Добавить("" + ДоступноеПоле.Поле);
			КонецЕсли;
		КонецЦикла;
		Если ЭлементыФормы.КорСчет.Доступность Тогда
			ПозицияСубконто = мИменаИзмерений.Найти("Субконто1");
			ПозицияСчета = мИменаИзмерений.Найти("Счет");
			Если ПозицияСубконто <> Неопределено И ПозицияСчета <> Неопределено И ПозицияСчета > ПозицияСубконто Тогда
				мИменаИзмерений.Вставить(ПозицияСубконто, "Счет");
				мИменаИзмерений.Удалить(ПозицияСчета + 1);
			КонецЕсли;
			ЭлементыФормы.КорСчет.ОграничениеТипа = ирКэш.ПоляТаблицыБДЛкс(ИмяТаблицыРегистра).Найти("СчетДт", "Имя").ТипЗначения;
		КонецЕсли;
		ГруппаИзмерения = Компоновщик.Настройки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		Для Каждого ИмяИзмерения Из мИменаИзмерений Цикл
			ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(ГруппаИзмерения, ИмяИзмерения);
			ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(Компоновщик.Настройки.Порядок, ИмяИзмерения);
		КонецЦикла;
		ГруппаРесурсы = Компоновщик.Настройки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		Для Каждого ИмяРесурса Из мИменаРесурсов Цикл
			ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(ГруппаРесурсы, ИмяРесурса + "Остаток");
		КонецЦикла;
	Иначе
		мСхемаКомпоновки = Новый СхемаКомпоновкиДанных;
		Компоновщик.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(мСхемаКомпоновки));
	КонецЕсли;
	
	ЭтаФорма.КорСчет = ЭлементыФормы.КорСчет.ОграничениеТипа.ПривестиЗначение(ЭтаФорма.КорСчет);
	Если ЗначениеЗаполнено(ИмяТаблицыРегистра) Тогда
		ЭлементыФормы.Регистратор.ОграничениеТипа = ирКэш.ПоляТаблицыБДЛкс(ИмяТаблицыРегистра).Найти("Регистратор", "Имя").ТипЗначения;
		ирКлиент.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
	КонецЕсли; 
	СоздатьТаблицуОстатков();

КонецПроцедуры

Функция ЛиПолеОстатка(ИмяПоля)
	
	ЛиПолеОстатка = ирОбщий.ЛиПолеРожденоРесурсомНакопленияЛкс(мОбъектМДРегистра, ИмяПоля);
	Возврат ЛиПолеОстатка;

КонецФункции

Процедура ДействияФормыПрочитатьОстатки(Кнопка = Неопределено)
	
	Если Не ЗначениеЗаполнено(ИмяТаблицыРегистра) Или Не ПодтвердитьПотерюИзменений() Тогда
		Возврат;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Дата) Тогда
		Дата = ТекущаяДата();
	КонецЕсли;
	Компоновщик.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("Период", Дата);
	НоваяТаблица = ирОбщий.СкомпоноватьВКоллекциюЗначенийПоСхемеЛкс(мСхемаКомпоновки, Компоновщик.Настройки);
	Если Не ЭлементыФормы.КорСчет.Доступность Тогда
		НоваяТаблица = ирОбщий.ТаблицаСКолонкамиБезТипаNullЛкс(НоваяТаблица);
	КонецЕсли;
	СостояниеСтрок = ирКлиент.ТабличноеПолеСостояниеСтрокЛкс(ЭлементыФормы.НаборЗаписей, ирОбщий.СтрСоединитьЛкс(мИменаИзмерений));
	УстановитьОстатки(НоваяТаблица);
	РегистраторПриИзменении();
	ирКлиент.ТабличноеПолеВосстановитьСостояниеСтрокЛкс(ЭлементыФормы.НаборЗаписей, СостояниеСтрок);
	
КонецПроцедуры

Процедура УстановитьОстатки(Знач НоваяТаблица)
	
	#Если Сервер И Не Сервер Тогда
		НоваяТаблица = Новый ТаблицаЗначений;
		мОбъектМДРегистра = Метаданные.РегистрыБухгалтерии.Хозрасчетный;
	#КонецЕсли
	Если ЗначениеЗаполнено(мИмяТаблицыОстатков) Тогда
		мИменаИзмеренийСВидами = ирОбщий.СкопироватьУниверсальнуюКоллекциюЛкс(мИменаИзмерений); 
		Если Метаданные.РегистрыБухгалтерии.Индекс(мОбъектМДРегистра) >= 0 Тогда
			ОписаниеТиповВидаСубконто = Новый ОписаниеТипов(ирОбщий.ИмяТипаИзПолногоИмениМДЛкс(мОбъектМДРегистра.ПланСчетов.ВидыСубконто.ПолноеИмя()));
			Для Каждого КолонкаТЗ Из НоваяТаблица.СкопироватьКолонки().Колонки Цикл
				Если ирОбщий.СтрНачинаетсяСЛкс(КолонкаТЗ.Имя, "Субконто") Тогда
					ИмяНовойКолонки = "Вид" + КолонкаТЗ.Имя;
					НоваяТаблица.Колонки.Вставить(НоваяТаблица.Колонки.Индекс(НоваяТаблица.Колонки.Найти(КолонкаТЗ.Имя)), ИмяНовойКолонки, ОписаниеТиповВидаСубконто, ирОбщий.ПредставлениеИзИдентификатораЛкс(ИмяНовойКолонки));
					мИменаИзмеренийСВидами.Добавить(ИмяНовойКолонки);
				КонецЕсли;
			КонецЦикла;
			Для Каждого СтрокаОстатка Из НоваяТаблица Цикл
				Для Счетчик = 1 По СтрокаОстатка.Счет.ВидыСубконто.Количество() Цикл
					ВидСубконто = СтрокаОстатка.Счет.ВидыСубконто[Счетчик - 1].ВидСубконто;
					СтрокаОстатка["ВидСубконто" + Счетчик] = ВидСубконто;
				КонецЦикла;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	ЭтаФорма.НаборЗаписей = НоваяТаблица;
	ЭтаФорма.Модифицированность = Ложь;
	ирКлиент.ТабличноеПолеСОтборомПросмотраУстановитьДанныеЛкс(ЭтаФорма, ЭлементыФормы.НаборЗаписей);
	ирОбщий.СоздатьКолонкиТабличногоПоляЛкс(ЭлементыФормы.НаборЗаписей);
	Для Каждого КолонкаТП Из ЭлементыФормы.НаборЗаписей.Колонки Цикл
		Если КолонкаТП.ЭлементУправления <> Неопределено Тогда
			КолонкаТП.ЭлементУправления.КнопкаВыбора = Истина;
			#Если Сервер И Не Сервер Тогда
				ПолеВвода_ОкончаниеВводаТекста();
				ПолеВводаКолонки_НачалоВыбора();
			#КонецЕсли
			КолонкаТП.ЭлементУправления.УстановитьДействие("ОкончаниеВводаТекста", Новый Действие("ПолеВвода_ОкончаниеВводаТекста"));
			КолонкаТП.ЭлементУправления.УстановитьДействие("НачалоВыбора", Новый Действие("ПолеВводаКолонки_НачалоВыбора"));
		КонецЕсли; 
	КонецЦикла;
	Для Каждого КолонкаТП Из ЭлементыФормы.НаборЗаписей.Колонки Цикл
		Если ЛиПолеОстатка(КолонкаТП.Имя) Тогда
			НаборЗаписей.Колонки.Добавить(КолонкаТП.Имя + "Оригинал", НаборЗаписей.Колонки[КолонкаТП.Имя].ТипЗначения);
			НаборЗаписей.ЗагрузитьКолонку(НаборЗаписей.ВыгрузитьКолонку(КолонкаТП.Имя), КолонкаТП.Имя + "Оригинал");
		Иначе
			//КолонкаТП.ТолькоПросмотр = Истина;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

Процедура ПолеВвода_ОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	ирКлиент.ПолеВвода_ОкончаниеВводаТекстаЛкс(Элемент, Текст, Значение, СтандартнаяОбработка);

КонецПроцедуры

Процедура ПолеВводаКолонки_НачалоВыбора(Элемент, СтандартнаяОбработка)
	ПоляТаблицыБД = ирКэш.ПоляТаблицыБДЛкс(ИмяТаблицыРегистра);
	ИмяПоляТаблицы = ирОбщий.ПутьКДаннымКолонкиТабличногоПоляЛкс(ЭлементыФормы.НаборЗаписей);
	СтрокаПоля = ПоляТаблицыБД.Найти(ИмяПоляТаблицы, "Имя");
	Если СтрокаПоля <> Неопределено Тогда
		СтруктураОтбора = ирКлиент.СтруктураОтбораПоСвязямИПараметрамВыбораЛкс(СтрокаПоля.Метаданные, ЭлементыФормы.НаборЗаписей.ТекущаяСтрока);
	КонецЕсли; 
	РезультатВыбора = ирКлиент.ПолеВводаКолонкиРасширенногоЗначения_НачалоВыбораЛкс(ЭтаФорма, ЭлементыФормы.НаборЗаписей, СтандартнаяОбработка,, Истина, СтруктураОтбора);
КонецПроцедуры

Процедура ТипРегистратораНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыбранныйТип = ирКлиент.ВыбратьРедактируемыйТипЛкс(ЭлементыФормы.Регистратор.ОграничениеТипа,, ТипЗнч(Регистратор));
	Если ВыбранныйТип <> Неопределено Тогда
		ОписаниеТипов = Новый ОписаниеТипов(ирОбщий.ЗначенияВМассивЛкс(ВыбранныйТип));
		ирКлиент.ИнтерактивноЗаписатьВПолеВводаЛкс(ЭлементыФормы.Регистратор, ОписаниеТипов.ПривестиЗначение(Регистратор));
	КонецЕсли;
	
КонецПроцедуры

Процедура ИмяТаблицыРегистраНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_ОбновитьСписокЛкс(Элемент, ЭтаФорма);

КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирКлиент.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура НаборЗаписейПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	Для Каждого Ячейка Из ОформлениеСтроки.Ячейки Цикл
		Если Истина
			И ЛиПолеОстатка(Ячейка.Имя) 
			И ДанныеСтроки[Ячейка.Имя] <> ДанныеСтроки[Ячейка.Имя + "Оригинал"] 
		Тогда
			ОформлениеСтроки.Ячейки[Ячейка.Имя].ЦветФона = WebЦвета.СветлоЗеленый;
		КонецЕсли;
	КонецЦикла; 
	ирКлиент.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки, ЭлементыФормы.КПНабораЗаписей.Кнопки.Идентификаторы);
	
КонецПроцедуры

Процедура НаборЗаписейПриАктивизацииСтроки(Элемент)
	ирКлиент.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
КонецПроцедуры

Процедура РегистраторПриИзменении(Элемент = Неопределено)
	
	ОбъектМДРегистратора = Метаданные.НайтиПоТипу(ТипЗнч(Регистратор));
	Если ОбъектМДРегистратора <> Неопределено Тогда
		ИмяДокумента = ОбъектМДРегистратора.Имя;
	Иначе
		ИмяДокумента = "";
	КонецЕсли;
	ирКлиент.ИнтерактивноЗаписатьВПолеВводаЛкс(ЭлементыФормы.ТипРегистратора, ИмяДокумента);
	Если Не ЗначениеЗаполнено(Регистратор) Тогда
		Возврат;
	КонецЕсли;
	СтруктураОбъекта = ирОбщий.ОбъектБДПоКлючуЛкс(ИмяТаблицыРегистра, Новый Структура("Регистратор", Регистратор));
	ОтборОстатковРанееУстановленнных = Новый Структура("Период", Дата);
	Если Не ЭлементыФормы.КорСчет.Доступность Тогда
		ОтборОстатковРанееУстановленнных.Вставить("ВидДвижения", ВидДвиженияНакопления.Приход);
	КонецЕсли;
	СтруктураКлючаСВидами = Новый Структура(ирОбщий.СтрСоединитьЛкс(мИменаИзмеренийСВидами));
	ТаблицаДвижений = СтруктураОбъекта.Методы.Выгрузить();
	Для Каждого РанееУстановленныйОстаток Из ТаблицаДвижений.НайтиСтроки(ОтборОстатковРанееУстановленнных) Цикл
		Если ЭлементыФормы.КорСчет.Доступность Тогда
			Если Не РанееУстановленныйОстаток.СчетДт.Забалансовый И РанееУстановленныйОстаток.СчетКт <> КорСчет Тогда 
				Продолжить;
			КонецЕсли;
        КонецЕсли;
		Для Каждого ИмяИзмерения Из мИменаИзмеренийСВидами Цикл
			ИмяКолонкиДвижений = ИмяКолонкиДвиженияИзИмениИзмерения(ИмяИзмерения, ТаблицаДвижений);
			СтруктураКлючаСВидами[ИмяИзмерения] = РанееУстановленныйОстаток[ИмяКолонкиДвижений];
		КонецЦикла;
		НайденныеСтроки = НаборЗаписей.НайтиСтроки(СтруктураКлючаСВидами);
		Если НайденныеСтроки.Количество() > 0 Тогда
			СтрокаОстатка = НайденныеСтроки[0];
		Иначе
			СтрокаОстатка = НаборЗаписей.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаОстатка, СтруктураКлючаСВидами);
		КонецЕсли;
		ПрочитатьОстаток(СтрокаОстатка);
		Для Каждого ИмяРесурса Из мИменаРесурсов Цикл
			ИмяКолонкиДвижений = ИмяКолонкиДвиженияИзИмениРесурса(ИмяРесурса);
			СтрокаОстатка[ИмяРесурса + "Остаток"] = РанееУстановленныйОстаток[ИмяКолонкиДвижений];
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

Функция ИмяКолонкиДвиженияИзИмениРесурса(Знач ИмяРесурса, Знач Сторона = "Дт")
	
	Суффикс = "";
	Если ЭлементыФормы.КорСчет.Доступность И Не мОбъектМДРегистра.Ресурсы[ИмяРесурса].Балансовый Тогда
		Суффикс = Сторона;
	КонецЕсли;
	ИмяКолонкиДвижений = ИмяРесурса + Суффикс;
	Возврат ИмяКолонкиДвижений;

КонецФункции

Процедура РегистраторНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ирКлиент.ПолеВводаРасширенногоЗначения_НачалоВыбораЛкс(Элемент, СтандартнаяОбработка,, Новый Структура("Дата", Дата));

КонецПроцедуры

Процедура ТипРегистратораПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ТипРегистратора) Тогда
		Возврат;
	КонецЕсли;
	НовыйТип = Тип("ДокументСсылка." + ТипРегистратора);
	Если ТипЗнч(Регистратор) <> НовыйТип Тогда
		ОписаниеТипов = Новый ОписаниеТипов(ирОбщий.ЗначенияВМассивЛкс(НовыйТип));
		ирКлиент.ИнтерактивноЗаписатьВПолеВводаЛкс(ЭлементыФормы.Регистратор, ОписаниеТипов.ПривестиЗначение(Регистратор));
	КонецЕсли;
	ирКлиент.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
	
КонецПроцедуры

Процедура КПНабораЗаписейЗаписать(Кнопка)
	
	Если Истина
		И ЭлементыФормы.КорСчет.Доступность 
		И Не ЗначениеЗаполнено(КорСчет) 
	Тогда
		ирОбщий.СообщитьЛкс("Необходимо указать кор. счет", СтатусСообщения.Внимание); 
		ЭтаФорма.ТекущийЭлемент = ЭлементыФормы.КорСчет;
		Возврат;
	КонецЕсли;
	Неуникальные = ирОбщий.НеуникальныеКлючиТаблицыЛкс(НаборЗаписей, мИменаИзмерений);
	Если Неуникальные.Количество() > 0 Тогда
		ирОбщий.СообщитьЛкс("Обнаружены дубли остатков. Выделены строки первой группы дублей.", СтатусСообщения.Внимание);
		ЭлементыФормы.НаборЗаписей.ВыделенныеСтроки.Очистить();
		ЭтаФорма.НаборЗаписейИспользоватьОтбор = Ложь;
		ирКлиент.ТабличноеПолеСОтборомПросмотраОтобратьЛкс(ЭтаФорма, ЭлементыФормы.НаборЗаписей);
		Для Каждого СтрокаНабора Из НаборЗаписей.НайтиСтроки(Неуникальные[0]) Цикл
			ЭлементыФормы.НаборЗаписей.ВыделенныеСтроки.Добавить(СтрокаНабора);
		КонецЦикла;
		ЭлементыФормы.НаборЗаписей.ТекущаяСтрока = ЭлементыФормы.НаборЗаписей.ВыделенныеСтроки[0];
		Возврат;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Регистратор) Тогда
		СтруктураОбъекта = ирОбщий.ОбъектБДПоКлючуЛкс("Документ." + ТипРегистратора);
		СтруктураОбъекта.Данные.Дата = Дата;
		СтруктураОбъекта.Методы.Записать();
		ЭтаФорма.Регистратор = СтруктураОбъекта.Методы.Ссылка;
	КонецЕсли;
	СтруктураОбъекта = ирОбщий.ОбъектБДПоКлючуЛкс(ИмяТаблицыРегистра, Новый Структура("Регистратор", Регистратор));
	Если СтруктураОбъекта.Данные.Количество() > 0 Тогда
		Ответ = Вопрос("У регистратора уже есть движения по этому регистру. Они будут замещены. Продолжить?", РежимДиалогаВопрос.ОКОтмена);
		Если Ответ <> КодВозвратаДиалога.ОК Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли; 
	СтруктураОбъекта.Данные.Очистить();
	КопияНабораЗаписей = СтруктураОбъекта.Методы.ВыгрузитьКолонки();
	Для Каждого СтрокаЗаписи Из НаборЗаписей Цикл
		Если Не ДляСвертки Тогда
			ЕстьРазличияСтроки = Ложь;
			Для Каждого ИмяРесурса Из мИменаРесурсов Цикл
				Если СтрокаЗаписи[ИмяРесурса + "Остаток"] <> СтрокаЗаписи[ИмяРесурса + "ОстатокОригинал"] Тогда 
					ЕстьРазличияСтроки = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Если Не ЕстьРазличияСтроки Тогда
				Продолжить;
			КонецЕсли;
			СтрокаСторно = КопияНабораЗаписей.Добавить();
			Если ЭлементыФормы.КорСчет.Доступность Тогда
				Если Не СтрокаЗаписи.Счет.Забалансовый Тогда
					СтрокаСторно.СчетДт = КорСчет;
				КонецЕсли;
			Иначе
				СтрокаСторно.ВидДвижения = ВидДвиженияНакопления.Расход;
			КонецЕсли;
			Для Каждого ИмяИзмерения Из мИменаИзмеренийСВидами Цикл
				ИмяКолонкиДвижений = ИмяКолонкиДвиженияИзИмениИзмерения(ИмяИзмерения, КопияНабораЗаписей, "Кт");
				СтрокаСторно[ИмяКолонкиДвижений] = СтрокаЗаписи[ИмяИзмерения];
			КонецЦикла;
			Для Каждого ИмяРесурса Из мИменаРесурсов Цикл
				ИмяКолонкиДвижений = ИмяКолонкиДвиженияИзИмениРесурса(ИмяРесурса, "Кт");
				СтрокаСторно[ИмяКолонкиДвижений] = СтрокаЗаписи[ИмяРесурса + "ОстатокОригинал"];
			КонецЦикла;
		КонецЕсли;
		СтрокаНовая = КопияНабораЗаписей.Добавить();
		Если ЭлементыФормы.КорСчет.Доступность Тогда
			Если Не СтрокаЗаписи.Счет.Забалансовый Тогда
				СтрокаНовая.СчетКт = КорСчет;
			КонецЕсли;
		Иначе
			СтрокаНовая.ВидДвижения = ВидДвиженияНакопления.Приход;
		КонецЕсли;
		Для Каждого ИмяИзмерения Из мИменаИзмеренийСВидами Цикл
			ИмяКолонкиДвижений = ИмяКолонкиДвиженияИзИмениИзмерения(ИмяИзмерения, КопияНабораЗаписей, "Дт");
			СтрокаНовая[ИмяКолонкиДвижений] = СтрокаЗаписи[ИмяИзмерения];
		КонецЦикла;
		Для Каждого ИмяРесурса Из мИменаРесурсов Цикл
			ИмяКолонкиДвижений = ИмяКолонкиДвиженияИзИмениРесурса(ИмяРесурса, "Дт");
			СтрокаНовая[ИмяКолонкиДвижений] = СтрокаЗаписи[ИмяРесурса + "Остаток"];
		КонецЦикла;
	КонецЦикла;
	ирОбщий.ЗагрузитьВТаблицуЗначенийЛкс(КопияНабораЗаписей, СтруктураОбъекта.Данные,, Новый Структура("Период, Активность", Дата, Истина));
	СтруктураОбъекта.Методы.Записать();
	ЭтаФорма.Модифицированность = Ложь;
	
КонецПроцедуры

Функция ИмяКолонкиДвиженияИзИмениИзмерения(Знач ИмяИзмерения, Знач ТаблицаДвижений, Знач Сторона = "Дт")
	
	ИмяПриемника = ИмяИзмерения;
	Если ЭлементыФормы.КорСчет.Доступность Тогда 
		Если ирОбщий.СтрНачинаетсяСЛкс(ИмяИзмерения, "Субконто") Тогда
			ИмяПриемника = СтрЗаменить(ИмяПриемника, "Субконто", "Субконто" + Сторона);
		ИначеЕсли ирОбщий.СтрНачинаетсяСЛкс(ИмяИзмерения, "ВидСубконто") Тогда
			ИмяПриемника = СтрЗаменить(ИмяПриемника, "ВидСубконто", "ВидСубконто" + Сторона);
		ИначеЕсли ТаблицаДвижений.Колонки.Найти(ИмяПриемника) = Неопределено Тогда 
			ИмяПриемника = ИмяПриемника + Сторона;
		КонецЕсли;
	КонецЕсли;
	Возврат ИмяПриемника;

КонецФункции

Процедура ТипРегистратораНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_ОбновитьСписокЛкс(Элемент, ЭтаФорма);

КонецПроцедуры

Процедура ИмяТаблицыРегистраОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(ИмяТаблицыРегистра) Тогда
		ирКлиент.ОткрытьОбъектМетаданныхЛкс(ИмяТаблицыРегистра);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт 
	ирКлиент.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);
КонецПроцедуры

Процедура ПриОткрытии()  
	ирКлиент.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ирКлиент.СоздатьМенеджерСохраненияНастроекФормыЛкс(ЭтаФорма);
	Если КлючУникальности <> Неопределено И ТипЗнч(КлючУникальности) = Тип("Строка") Тогда
		ОбъектМД = ирКэш.ОбъектМДПоПолномуИмениЛкс(КлючУникальности);
		Если ОбъектМД <> Неопределено Тогда
			ирКлиент.ИнтерактивноЗаписатьВПолеВводаЛкс(ЭлементыФормы.ИмяТаблицыРегистра, ОбъектМД.ПолноеИмя());
		КонецЕсли; 
	КонецЕсли; 
КонецПроцедуры

Процедура ПриЗакрытии()
	ирКлиент.Форма_ПриЗакрытииЛкс(ЭтаФорма);
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если Не ПодтвердитьПотерюИзменений() Тогда
		Отказ = Истина;
	КонецЕсли;

КонецПроцедуры

Функция ПодтвердитьПотерюИзменений()

	Результат = Истина;
	Если Модифицированность Тогда
		Ответ = Вопрос("Данные были изменены. Продолжить не сохраняя изменения?", РежимДиалогаВопрос.ОКОтмена);
		Если Ответ = КодВозвратаДиалога.Отмена Тогда
			Результат = Ложь;
		КонецЕсли;
	КонецЕсли;
	Возврат Результат;

КонецФункции

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт 
	
	ирКлиент.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура КПНабораЗаписейОткрытьДвиженияРегистратора(Кнопка)
	
	СтруктураОбъекта = ирОбщий.ОбъектБДПоКлючуЛкс(ИмяТаблицыРегистра, Новый Структура("Регистратор", Регистратор));
	ФормаРедактора = ирКлиент.ОткрытьОбъектВРедактореОбъектаБДЛкс(СтруктураОбъекта);
	//ФормаРедактора.ПоказатьЯчейкуДанныхОбъекта(, ИмяКолонки, КлючСтроки);

КонецПроцедуры

Процедура НадписьОбщиеПараметрыЗаписиНажатие(Элемент)
	ирКлиент.ОткрытьОбщиеПараметрыЗаписиЛкс();
КонецПроцедуры

Процедура КПНабораЗаписейОткрытьРегистратор(Кнопка)
	ирКлиент.ОткрытьСсылкуВРедактореОбъектаБДЛкс(Регистратор);
КонецПроцедуры

Процедура ДатаПриИзменении(Элемент)
	Если Не ЗначениеЗаполнено(Дата) Тогда
		Дата = НачалоДня(НачалоДня(ТекущаяДата()) - 1);
	КонецЕсли;
	ирКлиент.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
	Если Регистратор <> Неопределено Тогда
		ЭтаФорма.Регистратор = Новый (ТипЗнч(Регистратор));
	КонецЕсли;
	СоздатьТаблицуОстатков();

КонецПроцедуры

Процедура СоздатьТаблицуОстатков()
	
	НоваяТаблица = Новый ТаблицаЗначений;
	Если ЗначениеЗаполнено(мИмяТаблицыОстатков) Тогда
		ирОбщий.СкомпоноватьВКоллекциюЗначенийПоСхемеЛкс(мСхемаКомпоновки, Компоновщик.Настройки, НоваяТаблица,, Истина);
	КонецЕсли;
	УстановитьОстатки(НоваяТаблица);

КонецПроцедуры

Процедура ДатаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	ирОбщий.ПолеВводаСИсториейВыбора_ОбновитьСписокЛкс(Элемент, ЭтаФорма);
КонецПроцедуры

Процедура ДействияФормыОбработатьПредшествующиеСтроки(Кнопка)
	НастройкиПредшествующие = Компоновщик.ПолучитьНастройки();
	ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(НастройкиПредшествующие.Отбор, "Период", Дата, ВидСравненияКомпоновкиДанных.Меньше);
	Форма = ирКлиент.ПолучитьФормуЛкс("Обработка.ирПодборИОбработкаОбъектов.Форма",,, ИмяТаблицыРегистра);
	Форма.ПараметрНастройкаКомпоновки = НастройкиПредшествующие;
	Форма.Открыть();
КонецПроцедуры

Процедура КПНабораЗаписейОбнулитьОстатки(Кнопка)
	
	Для Каждого СтрокаДляОбработки Из ВыбранныеСтроки() Цикл
		Для Каждого ИмяРесурса Из мИменаРесурсов Цикл
			СтрокаДляОбработки[ИмяРесурса + "Остаток"] = 0;
		КонецЦикла;
	КонецЦикла;
	ЭтаФорма.Модифицированность = Истина;
	
КонецПроцедуры

Процедура КПНабораЗаписейВосстановитьОстатки(Кнопка)
	Для Каждого СтрокаДляОбработки Из ВыбранныеСтроки() Цикл
		Для Каждого ИмяРесурса Из мИменаРесурсов Цикл
			СтрокаДляОбработки[ИмяРесурса + "Остаток"] = СтрокаДляОбработки[ИмяРесурса + "ОстатокОригинал"];
		КонецЦикла;
	КонецЦикла;
	ЭтаФорма.Модифицированность = Истина;
КонецПроцедуры  

Функция ВыбранныеСтроки()
	
	СтрокиДляОбработки = ЭлементыФормы.НаборЗаписей.ВыделенныеСтроки;
	Если СтрокиДляОбработки.Количество() < 2 Тогда
		Ответ = Вопрос("Хотите обработать остатки во всех загруженных строках?", РежимДиалогаВопрос.ДаНет);
		Если Ответ = КодВозвратаДиалога.Да Тогда
			СтрокиДляОбработки = НаборЗаписей;
		КонецЕсли;
	КонецЕсли;
	Возврат СтрокиДляОбработки;

КонецФункции

Процедура НаборЗаписейИспользоватьОтборПриИзменении(Элемент = Неопределено)
	
	ирКлиент.ТабличноеПолеСОтборомПросмотраОтобратьЛкс(ЭтаФорма, ЭлементыФормы.НаборЗаписей);

КонецПроцедуры

Процедура ИмяТаблицыРегистраОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	ПараметрыВыбора = ПараметрыВыбораОбъектаМетаданных();
	Если ПараметрыВыбора.ДоступныеОбъекты.Найти(ВыбранноеЗначение) = Неопределено Тогда
		СтандартнаяОбработка = Ложь;
	ИначеЕсли Не ПодтвердитьПотерюИзменений() Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура НаборЗаписейПриАктивизацииКолонки(Элемент)
	
	ирКлиент.ТабличноеПолеПриАктивацииКолонкиЛкс(ЭтаФорма, Элемент);
	
КонецПроцедуры

Процедура НаборЗаписейПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
КонецПроцедуры

Процедура НаборЗаписейПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Для Каждого ИмяИзмерения Из мИменаИзмеренийСВидами Цикл
		ЭлементыФормы.НаборЗаписей.Колонки[ИмяИзмерения].ЭлементУправления.ТолькоПросмотр = Не НоваяСтрока;
	КонецЦикла;

КонецПроцедуры

Процедура НаборЗаписейПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	Если НоваяСтрока И Не ОтменаРедактирования Тогда
		ПрочитатьОстаток(ЭлементыФормы.НаборЗаписей.ТекущаяСтрока);
	КонецЕсли;
КонецПроцедуры

Процедура ПрочитатьОстаток(Знач ТекущаяСтрока)
	
	СтруктураКлюча = КлючСтроки(ТекущаяСтрока, Ложь);
	МенеджерРегистра = ирОбщий.ПолучитьМенеджерЛкс(ИмяТаблицыРегистра);
	Если ЭлементыФормы.КорСчет.Доступность Тогда 
		Попытка
			СчитанныеОстатки = МенеджерРегистра.Остатки(Дата,, СтруктураКлюча);
		Исключение
			ирОбщий.СообщитьЛкс("Не удалось прочитать остаток " + ирОбщий.РасширенноеПредставлениеЗначенияЛкс(СтруктураКлюча), СтатусСообщения.Внимание);
			Возврат;
		КонецПопытки;
		#Если Сервер И Не Сервер Тогда
			СчитанныеОстатки = Новый ТаблицаЗначений;
		#КонецЕсли
		Если СчитанныеОстатки.Количество() > 0 Тогда
			Для Каждого ИмяРесурса Из мИменаРесурсов Цикл
				СчитанныеОстатки.Колонки.Добавить(ИмяРесурса);
				СчитанныеОстатки[0][ИмяРесурса] = СчитанныеОстатки[0][ИмяРесурса + "ОстатокДт"] - СчитанныеОстатки[0][ИмяРесурса + "ОстатокКт"];
			КонецЦикла;
		КонецЕсли;
	Иначе
		Попытка
			СчитанныеОстатки = МенеджерРегистра.Остатки(Дата, СтруктураКлюча);
		Исключение
			ирОбщий.СообщитьЛкс("Не удалось прочитать остаток " + ирОбщий.РасширенноеПредставлениеЗначенияЛкс(СтруктураКлюча), СтатусСообщения.Внимание);
			Возврат;
		КонецПопытки;
	КонецЕсли;
	Для Каждого ИмяРесурса Из мИменаРесурсов Цикл
		Если СчитанныеОстатки.Количество() > 0 Тогда
			ОстатокРесурса = СчитанныеОстатки[0][ИмяРесурса];
		Иначе
			ОстатокРесурса = 0;
		КонецЕсли;
		ТекущаяСтрока[ИмяРесурса + "ОстатокОригинал"] = ОстатокРесурса;
		Если Не ЗначениеЗаполнено(ТекущаяСтрока[ИмяРесурса + "Остаток"]) Тогда
			ТекущаяСтрока[ИмяРесурса + "Остаток"] = ОстатокРесурса;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

Функция КлючСтроки(Знач ТекущаяСтрока = Неопределено, Знач РазрешитьNull = Истина)
	
	Если ТекущаяСтрока = Неопределено Тогда
		ТекущаяСтрока = ЭлементыФормы.НаборЗаписей.ТекущаяСтрока;
	КонецЕсли;
	СтруктураКлюча = Новый Структура(ирОбщий.СтрСоединитьЛкс(мИменаИзмерений));
	ЗаполнитьЗначенияСвойств(СтруктураКлюча, ТекущаяСтрока);
	Если РазрешитьNull Тогда
		Для Каждого КлючИЗначение Из СтруктураКлюча Цикл
			Если КлючИЗначение.Значение = Null Тогда
				СтруктураКлюча.Вставить(КлючИЗначение.Ключ, Неопределено);
				ирОбщий.СообщитьЛкс(ирОбщий.СтрШаблонЛкс("Отбор по измерению ""%1"" заменен с Null на Неопределено", КлючИЗначение.Ключ));
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	Возврат СтруктураКлюча;

КонецФункции

Процедура КПНабораЗаписейДвиженияОстатка(Кнопка)
	ирКлиент.ОткрытьФормуСпискаЛкс(ИмяТаблицыРегистра,,,,,,,, КлючСтроки());
КонецПроцедуры

Процедура НаборЗаписейВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ирКлиент.ЯчейкаТабличногоПоляРасширенногоЗначения_ВыборЛкс(ЭтаФорма, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ДатаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ПодтвердитьПотерюИзменений() Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;

КонецПроцедуры

Процедура ИмяТаблицыРегистраОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	Если Не ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		Значение = ИмяТаблицыРегистра;
		Возврат;
	КонецЕсли;
	ирКлиент.ОбъектМетаданныхОкончаниеВводаТекстаЛкс(Элемент, ПараметрыВыбораОбъектаМетаданных(), Текст, Значение, СтандартнаяОбработка);
КонецПроцедуры

ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирРедакторОстатков.Форма.Форма");

#Если Сервер И Не Сервер Тогда
	ПриПолученииДанныхДоступныхПолей();
#КонецЕсли
ирКлиент.ПодключитьОбработчикиСобытийДоступныхПолейКомпоновкиЛкс(ЭлементыФормы.ДоступныеПоляОтбора);


