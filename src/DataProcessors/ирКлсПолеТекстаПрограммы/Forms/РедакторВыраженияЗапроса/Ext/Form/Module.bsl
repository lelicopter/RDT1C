﻿Перем мИмяСлужебногоПоля;
Перем мПредставленияТиповВыражений;
Перем ДиалектSQL Экспорт;
Перем ПараметрыДиалектаSQL;
Перем мТекстПолейГруппировки;
Перем ВыражениеИсходное;

// @@@.КЛАСС.ПолеТекстаПрограммы
Функция КлсПолеТекстаПрограммыОбновитьКонтекст(Знач Компонента = Неопределено, Знач Кнопка = Неопределено) Экспорт 
КонецФункции

// @@@.КЛАСС.ПолеТекстаПрограммы
Процедура КлсПолеТекстаПрограммыНажатие(Кнопка)
	
	#Если Сервер И Не Сервер Тогда
		ПолеТекстаВыражения = Обработки.ирКлсПолеТекстаПрограммы.Создать();
	#КонецЕсли
	Если Кнопка = ирКлиент.КнопкаКоманднойПанелиЭкземпляраКомпонентыЛкс(ПолеТекстаВыражения, "ПерейтиКОпределению") Тогда
		НачальнаяСтрока = 0;
		НачальнаяКолонка = 0;
		Если ПерейтиКОпределениюВФорме(НачальнаяСтрока, НачальнаяКолонка) Тогда
			Возврат;
		КонецЕсли; 
	ИначеЕсли Кнопка = ирКлиент.КнопкаКоманднойПанелиЭкземпляраКомпонентыЛкс(ПолеТекстаВыражения, "КонструкторЗапросовИР") Тогда
		Если ПустаяСтрока(АктивноеПолеТекста().ВыделенныйТекст()) Тогда
			ПолеТекстаВыражения.ПолучитьНомерТекущейСтроки();
			КонструкторВложенногоЗапроса = ПолучитьКонструкторВложенногоЗапроса("ВЫБРАТЬ *");
			РезультатФормы = КонструкторВложенногоЗапроса.ОткрытьМодально();
			Если РезультатФормы <> Неопределено Тогда
				АктивноеПолеТекста().ВыделенныйТекст("(" + КонструкторВложенногоЗапроса.Текст + ")");
				ЭтаФорма.Модифицированность = Истина;
				КоманднаяПанельТекстаОбновитьЗапросы();
			КонецЕсли;
		Иначе
			Сообщить("Эта кнопка здесь служит только для создания запросов. Для открытия существующего запроса используйте список запросов");
		КонецЕсли; 
		Возврат;
	КонецЕсли;
	ПолеТекстаВыражения.Нажатие(Кнопка);
	
КонецПроцедуры

Функция ПерейтиКОпределениюВФорме(Знач НомерСтроки = 0, Знач НомерКолонки = 0) Экспорт 
	
	#Если Сервер И Не Сервер Тогда
	    ПолеТекстаВыражения = Обработки.ирКлсПолеТекстаПрограммы.Создать();
	#КонецЕсли
	ТекущееВыражение = ПолеТекстаВыражения.ТекущееОбъектноеВыражение(НомерСтроки, НомерКолонки);
	Если Лев(ТекущееВыражение, 1) = "&" Тогда
		ИмяПараметра = Сред(ТекущееВыражение, 2);
		ДоступныйПараметр = ЭлементыФормы.ДоступныеПоля.Значение.НайтиПоле(Новый ПолеКомпоновкиДанных("ПараметрыДанных." + ИмяПараметра));
		Если ДоступныйПараметр <> Неопределено Тогда
			ЭлементыФормы.ДоступныеПоля.ТекущаяСтрока = ДоступныйПараметр;
			ПараметрСхемы = Параметры.Найти(ирОбщий.ПоследнийФрагментЛкс(ДоступныйПараметр.Поле));
			Если ПараметрСхемы <> Неопределено Тогда
				//Если ПараметрСхемы.Выражение <> "" Тогда
				//	Попытка 
				//		ЗначениеПараметра = Вычислить(ПараметрСхемы.Выражение);
				//		ОткрытьЗначение(ЗначениеПараметра);
				//	Исключение
				//		ирОбщий.СообщитьСУчетомМодальностиЛкс("Ошибка при вычислении параметра """ + ПараметрСхемы.ИмяПараметра + """"
				//			+ Символы.ПС + ОписаниеОшибки(), МодальныйРежим, СтатусСообщения.Важное);
				//	КонецПопытки;
				//Иначе
					ЗначениеПараметра = ПараметрСхемы.Значение;
					ОткрытьЗначение(ЗначениеПараметра);
				//КонецЕсли;
			КонецЕсли; 
		КонецЕсли;
		Возврат Истина;
	Иначе
		ДоступноеПоле = ЭлементыФормы.ДоступныеПоля.Значение.НайтиПоле(Новый ПолеКомпоновкиДанных(ТекущееВыражение));
		Если ДоступноеПоле <> Неопределено Тогда
			ЭлементыФормы.ДоступныеПоля.ТекущаяСтрока = ДоступноеПоле;
		КонецЕсли; 
	КонецЕсли; 
	Возврат Ложь;

КонецФункции

// @@@.КЛАСС.ПолеТекстаПрограммы
Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	Если ПолеТекстаВыражения = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	#Если Сервер И Не Сервер Тогда
	    ПолеТекстаВыражения = Обработки.ирКлсПолеТекстаПрограммы.Создать();
	#КонецЕсли
	ПолеТекстаВыражения.ВнешнееСобытиеОбъекта(Источник, Событие, Данные);
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ирКлиент.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ирКэш.Получить().ИнициацияОписанияМетодовИСвойств();
	// +++.КЛАСС.ПолеТекстаПрограммы
	#Если Сервер И Не Сервер Тогда
		ПолеТекстаВыражения = Обработки.ирКлсПолеТекстаПрограммы.Создать();
	#КонецЕсли
	ПолеТекстаВыражения.Инициализировать(,
		ЭтаФорма, ЭлементыФормы.ПолеТекстаВыражения, ЭлементыФормы.КоманднаяПанельТекста, 1, "ПроверитьВыражение", ЭтаФорма, "Выражение");
	//ПолеТекстаВыражения.ЭтоЧастичныйЗапрос = Истина; // Заменил на локальный обработчик команды
	ирОбщий.ЗагрузитьВТаблицуЗначенийЛкс(ОбработкаОбъект.ДоступныеТаблицы, ПолеТекстаВыражения.ДоступныеТаблицы);
	Если ПолеТекстаВыражения.ПредпочитатьHTMLРедакторКода() Тогда
		ЭлементыФормы.ПанельРедактора.ТекущаяСтраница = ЭлементыФормы.ПанельРедактора.Страницы.РедакторHTML;
	КонецЕсли;
	// ---.КЛАСС.ПолеТекстаПрограммы
	
	СтрокаПредставленияТипаВыражения = мПредставленияТиповВыражений.НайтиПоЗначению(ТипВыражения);
	Если СтрокаПредставленияТипаВыражения <> Неопределено Тогда
		ирОбщий.ОбновитьТекстПослеМаркераЛкс(ЭтаФорма.Заголовок,, СтрокаПредставленияТипаВыражения.Представление);
	КонецЕсли; 
	Если мДиалектыSQL <> Неопределено Тогда
		ПараметрыДиалектаSQL = мДиалектыSQL.Найти(ДиалектSQL, "Диалект");
		ЭлементыФормы.КПЗапросы.Кнопки.ПеренестиВоВременнуюТаблицу.Доступность = Истина
			И ПараметрыДиалектаSQL.ВременныеТаблицы 
			И ПараметрыДиалектаSQL.Пакет;
	КонецЕсли; 
	УстановитьСхемуКомпоновки();
	//мПлатформа = ирКэш.Получить();
	Если ирОбщий.СтрокиРавныЛкс(мДиалектSQL, "1С") Тогда
		СтруктураТипаКонтекста = мПлатформа.НоваяСтруктураТипа();
		СтруктураТипаКонтекста.ИмяОбщегоТипа = "Локальный";
		СписокСлов = мПлатформа.СловаКонтекстаПредопределенные(СтруктураТипаКонтекста,,,,1);
		//ТаблицаСлов = мПлатформа.СловаКонтекстаПредопределенные(СтруктураТипа, 1);
		Для Каждого СтрокаСлова Из СписокСлов Цикл
			Если Не ирОбщий.СтрокиРавныЛкс(СтрокаСлова.ТипСлова, "Метод") Тогда
				Продолжить;
			КонецЕсли; 
			СтрокаФункции = ТаблицаФункций.Добавить();
			СтрокаФункции.Функция = СтрокаСлова.Слово;
			СтрокаФункции.СтруктураТипа = СтрокаСлова.ТаблицаТипов[0];
		КонецЦикла;
	КонецЕсли; 
	Если ТипЗнч(ВладелецФормы) = Тип("Форма") Тогда
		ВладелецФормы.Панель.Доступность = Ложь;
	КонецЕсли;
	ДоступныеПоляГруппировки = Новый Массив;
	Для Каждого ПапкаДоступныхПолей Из КомпоновщикНастроек.Настройки.ДоступныеПоляГруппировок.Элементы Цикл
		Для Каждого ДоступноеПоле Из ПапкаДоступныхПолей.Элементы Цикл
			Если Истина
				И ДоступноеПоле.ТипЗначения.СодержитТип(Тип("Строка"))
				И ДоступноеПоле.ТипЗначения.КвалификаторыСтроки.Длина = 0
			Тогда
				// По логике таких тут быть не должно, но они почему то есть
				Продолжить;
			КонецЕсли; 
			ДоступныеПоляГруппировки.Добавить("" + ДоступноеПоле.Поле);
		КонецЦикла;
	КонецЦикла;
	мТекстПолейГруппировки = ирОбщий.СтрСоединитьЛкс(ДоступныеПоляГруппировки, ", ");
	ПолеТекстаВыражения.УстановитьТекст(Выражение,, Выражение);
	ВыражениеИсходное = Выражение;
	ДоступноеПоле = КомпоновщикНастроек.Настройки.ДоступныеПоляОтбора.НайтиПоле(Новый ПолеКомпоновкиДанных(Выражение));
	Если ДоступноеПоле <> Неопределено Тогда
		ЭлементыФормы.ДоступныеПоля.ТекущаяСтрока = ДоступноеПоле;
		// https://partners.v8.1c.ru/forum/t/1625925/m/1625925
		ПодключитьОбработчикОжидания("УстановитьВыделениеОтложенно", 0.1, Истина);
	КонецЕсли; 
	КоманднаяПанельТекстаОбновитьЗапросы();
	ЭлементыФормы.ПанельРедактора.Страницы.РедакторHTML.Доступность = ирКэш.ДоступенРедакторМонакоЛкс();
	Если ЭлементыФормы.ПанельРедактора.Страницы.РедакторHTML.Доступность Тогда
		ЭлементыФормы.РедакторHTML.Перейти(ирКэш.Получить().БазовыйФайлРедактораКода());
	КонецЕсли; 

КонецПроцедуры

Процедура УстановитьВыделениеОтложенно()
	
	ирКлиент.ЗаменитьИВыделитьВыделенныйТекстПоляЛкс(ЭтаФорма, АктивноеПолеТекста());
	
КонецПроцедуры

Функция УстановитьСхемуКомпоновки()
	
	ТекстПроверочногоЗапроса = ПолучитьТекстПроверочногоЗапроса(, Истина);
	Если ТекстПроверочногоЗапроса = Неопределено Тогда
		ОбновитьКонтекстнуюПодсказку();
		Возврат Неопределено;
	КонецЕсли;
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	СхемаКомпоновки = Новый СхемаКомпоновкиДанных;
	ИсточникДанных = ирОбщий.ДобавитьЛокальныйИсточникДанныхЛкс(СхемаКомпоновки);
	НаборДанных = СхемаКомпоновки.НаборыДанных.Добавить(Тип("НаборДанныхЗапросСхемыКомпоновкиДанных"));
	НаборДанных.ИсточникДанных = ИсточникДанных.Имя;
	НаборДанных.Запрос = ТекстПроверочногоЗапроса;
	НаборДанных.АвтоЗаполнениеДоступныхПолей = Истина;
	ПолеНабора = НаборДанных.Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
	ПолеНабора.Поле = мИмяСлужебногоПоля;
	ПолеНабора.ПутьКДанным = мИмяСлужебногоПоля;
	ПолеНабора.ОграничениеИспользования.Условие = Истина;
	Если Параметры = Неопределено Тогда
		ирОбщий.СообщитьСУчетомМодальностиЛкс("Не передана таблица параметров", МодальныйРежим, СтатусСообщения.Внимание);
		Возврат Неопределено;
	КонецЕсли; 
	Для Каждого CтрокаПараметра Из Параметры Цикл
		ПараметрСхемы = СхемаКомпоновки.Параметры.Добавить();
		ПараметрСхемы.Имя = CтрокаПараметра.Имя;
		ПараметрСхемы.ТипЗначения = CтрокаПараметра.ТипЗначения;
	КонецЦикла;
	Попытка
		КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновки));
	Исключение
		ОписаниеОшибки = ОписаниеОшибки(); // Чтобы в отладчике сразу была понятна причина ошибки
	КонецПопытки; 
	ОбновитьКонтекстнуюПодсказку();
	
КонецФункции

Процедура ОбновитьКонтекстнуюПодсказку()
	
	ПолеТекстаВыражения.ОбновитьКонтекстВыраженияЗапросаПоНастройкеКомпоновкиЛкс(КомпоновщикНастроек.Настройки);
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирКлиент.Форма_ПриЗакрытииЛкс(ЭтаФорма);
	
	// +++.КЛАСС.ПолеТекстаПрограммы
	ПолеТекстаВыражения.Уничтожить();
	// ---.КЛАСС.ПолеТекстаПрограммы
	
	Если ТипЗнч(ВладелецФормы) = Тип("Форма") Тогда
		ВладелецФормы.Панель.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

Функция СохранитьИзменения()

	Если Не ПолеТекстаВыражения.ПроверитьПрограммныйКод() Тогда 
		Ответ = Вопрос("Выражение содержит ошибки. Продолжить?", РежимДиалогаВопрос.ОКОтмена);
		Если Ответ <> КодВозвратаДиалога.ОК Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли; 
	Текст = АктивноеПолеТекста().ПолучитьТекст();
	Если Не МодальныйРежим Тогда
		ирКлиент.ТекстВБуферОбменаОСЛкс(Текст, "ЯзыкЗапросов");
	КонецЕсли;
	Модифицированность = Ложь;
	Закрыть(Текст);
	Возврат Истина;

КонецФункции

Процедура ОсновныеДействияФормыОК(Кнопка)
	
	СохранитьИзменения();
	
КонецПроцедуры

// Выполняет программный код в контексте.
//
// Параметры:
//  ТекстДляВыполнения - Строка;
//  *ЛиСинтаксическийКонтроль - Булево, *Ложь - признак вызова только для синтаксического контроля.
//
Функция ПроверитьВыражение(ТекстДляПроверки, ЛиСинтаксическийКонтроль = Ложь) Экспорт
	
	КоманднаяПанельТекстаОбновитьЗапросы();
	Если мДиалектSQL = "1С" Тогда
		ПроверочныйЗапрос = Новый Запрос;
		ПроверочныйЗапрос.Текст = ПолучитьТекстПроверочногоЗапроса(ТекстДляПроверки);
		ПроверочныйЗапрос.НайтиПараметры(); // Здесь будет возникать ошибка
	КонецЕсли; 

КонецФункции

Функция ПолучитьТекстПроверочногоЗапроса(Знач ТекстДляПроверки = "", ДляСхемы = Ложь)
	
	Если Истина
		И ДляСхемы
		И КомпоновщикНастроек.Настройки.ДоступныеПоляОтбора.Элементы.Количество() > 0
	Тогда
		Возврат Неопределено;
	КонецЕсли; 
	Если Не ЗначениеЗаполнено(ТекстДляПроверки) Тогда
		ТекстДляПроверки = АктивноеПолеТекста().ПолучитьТекст();
	КонецЕсли; 

	Если ТипВыражения = "ПараметрВиртуальнойТаблицы" Тогда
		Если Не ЗначениеЗаполнено(ШаблонПолноеИмяТаблицы) Тогда
			ВызватьИсключение "Не задан параметр ""ШаблонПолноеИмяТаблицы""";
		КонецЕсли; 
		Если Не ЗначениеЗаполнено(ШаблонНомерПараметра) Тогда
			ВызватьИсключение "Не задан параметр ""ШаблонНомерПараметра""";
		КонецЕсли; 
		Запятые = ирОбщий.СтрокаПовторомЛкс(",", ШаблонНомерПараметра - 1);
		ТекстЗапроса = "ВЫБРАТЬ 1 КАК " + мИмяСлужебногоПоля + " ИЗ " + ШаблонПолноеИмяТаблицы + "(" + Запятые + "
		|" + ТекстДляПроверки + "
		|) КАК Т";
	ИначеЕсли ТипВыражения = "УсловиеОтбора" Тогда
		Если ШаблонТекстИЗ = Неопределено Тогда
			ВызватьИсключение "Не задан параметр ""ШаблонТекстИЗ""";
		КонецЕсли; 
		Если Истина
			И ДляСхемы
			И Не ЗначениеЗаполнено(ТекстДляПроверки) 
		Тогда
			ТекстДляПроверки = "1=1";
		КонецЕсли; 
		ТекстЗапроса = "ВЫБРАТЬ 1 ";
		Если ЗначениеЗаполнено(ШаблонТекстИЗ) Тогда
			ТекстЗапроса = ТекстЗапроса + ШаблонТекстИЗ;
		КонецЕсли;
		Если ЕстьАгрегаты И Не АгрегатыЗапрещены Тогда
			ТекстЗапроса = ТекстЗапроса + " 
			|СГРУППИРОВАТЬ ПО " + мТекстПолейГруппировки + "
			|ИМЕЮЩИЕ ";
		Иначе
			ТекстЗапроса = ТекстЗапроса + " 
			|ГДЕ ";
		КонецЕсли; 
		ТекстЗапроса = ТекстЗапроса + " 
		|(" + ТекстДляПроверки + ")";
	ИначеЕсли ТипВыражения = "ВыбранноеПоле" Тогда
		Если ШаблонТекстИЗ = Неопределено Тогда
			ВызватьИсключение "Не задан параметр ""ШаблонТекстИЗ""";
		КонецЕсли; 
		Если Истина
			И ДляСхемы
			И Не ЗначениеЗаполнено(ТекстДляПроверки) 
		Тогда
			ТекстДляПроверки = "1";
		КонецЕсли; 
		ТекстЗапроса = "ВЫБРАТЬ 
		|(" + ТекстДляПроверки + ") 
		|КАК " + мИмяСлужебногоПоля + " ";
		Если ЗначениеЗаполнено(ШаблонТекстИЗ) Тогда
			ТекстЗапроса = ТекстЗапроса + ШаблонТекстИЗ;
		КонецЕсли; 
	ИначеЕсли ТипВыражения = "ПолеИтога" Тогда
		//Если Не ЗначениеЗаполнено(ШаблонТекстЗапроса) Тогда
		//	ВызватьИсключение "Не задан параметр ""ШаблонТекстЗапроса""";
		//КонецЕсли; 
		//ТекстЗапроса = ШаблонТекстЗапроса + " ИТОГИ
		ТекстЗапроса = "ВЫБРАТЬ 1 КАК " + мИмяСлужебногоПоля + " ИТОГИ
		|(" + ТекстДляПроверки + ")
		| КАК " + мИмяСлужебногоПоля + " ПО ОБЩИЕ";
	Иначе
		ТекстЗапроса = "";
	КонецЕсли; 
	Возврат ТекстЗапроса;

КонецФункции

Процедура ДоступныеПоляНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	ЗначениеПеретаскивания = ВыражениеДоступногоПоля();
	Если ЗначениеЗаполнено(ЗначениеПеретаскивания) Тогда
		ПараметрыПеретаскивания.Значение = ЗначениеПеретаскивания;
	Иначе
		ПараметрыПеретаскивания.ДопустимыеДействия = ДопустимыеДействияПеретаскивания.НеОбрабатывать;
	КонецЕсли; 
	
КонецПроцедуры

Функция ВыражениеДоступногоПоля()
	
	Элемент = ЭлементыФормы.ДоступныеПоля;
	НрегПервыйФрагмент = ирОбщий.ПервыйФрагментЛкс(НРег(Элемент.ТекущаяСтрока.Поле));
	Если НрегПервыйФрагмент = НРег("ПараметрыДанных") Тогда
		ЗначениеПеретаскивания = ПараметрыДиалектаSQL.ПрефиксПараметра + ирОбщий.ПоследнийФрагментЛкс(Элемент.ТекущаяСтрока.Поле);
	ИначеЕсли Истина
		И ТипВыражения <> "ПолеИтога"
		И НрегПервыйФрагмент = НРег("СистемныеПоля") 
	Тогда
		//
	Иначе
		ЗначениеПеретаскивания = Элемент.ТекущаяСтрока.Поле;
	КонецЕсли;
	Возврат ЗначениеПеретаскивания;

КонецФункции

Процедура КоманднаяПанельТекстаСсылкаНаОбъектБД(Кнопка)
	
	//ПолеВстроенногоЯзыка.ВставитьСсылкуНаОбъектБД(СхемаКомпоновки, "");
	
КонецПроцедуры
                               
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Ответ = ирКлиент.ЗапроситьСохранениеДанныхФормыЛкс(ЭтаФорма, Отказ);
	Если Ответ = КодВозвратаДиалога.Да Тогда
		Отказ = Не СохранитьИзменения();
	КонецЕсли;
	Если Не Отказ Тогда
		ПолеТекстаВыражения.РедакторHTML_Уничтожить(ЭлементыФормы.РедакторHTML);
	КонецЕсли;
	
КонецПроцедуры

Процедура КонтекстноеМенюФункцийСинтаксПомощник(Кнопка)
	
	ТекущаяСтрокаФункций = ЭлементыФормы.ТаблицаФункций.ТекущаяСтрока;
	Если ТекущаяСтрокаФункций = Неопределено Тогда
		Возврат;
	КонецЕсли;
	СтруктураТипа = ТекущаяСтрокаФункций.СтруктураТипа;
	Если СтруктураТипа <> Неопределено Тогда
		СтрокаОписания = СтруктураТипа.СтрокаОписания;
		Если СтрокаОписания <> Неопределено Тогда
			ирКлиент.ОткрытьСтраницуСинтаксПомощникаЛкс(СтрокаОписания.ПутьКОписанию, , ЭтаФорма);
		КонецЕсли; 
	КонецЕсли; 

КонецПроцедуры

Процедура ТаблицаФункцийНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	ПараметрыПеретаскивания.Значение = Элемент.ТекущаяСтрока.Функция + "()";
	
КонецПроцедуры

Процедура ПриПолученииДанныхДоступныхПолей(Элемент, ОформленияСтрок)

	ирКлиент.ПриПолученииДанныхТабличногоПоляКомпоновкиЛкс(ЭтаФорма, Элемент, ОформленияСтрок,, Истина);

КонецПроцедуры

Процедура КоманднаяПанельТекстаОбновитьЗапросы(Кнопка = Неопределено)
	
	//ТекстПроверочногоЗапроса = ПолучитьТекстПроверочногоЗапроса();
	ТекстВыражения = АктивноеПолеТекста().ПолучитьТекст();
	Если ПустаяСтрока(ТекстВыражения) Тогда
		ТекстВыражения = "1";
	КонецЕсли; 
	ТекстПроверочногоЗапроса = "ВЫБРАТЬ 
	|" + ТекстВыражения;
	мПолеТекстаВременное.УстановитьТекст(ТекстПроверочногоЗапроса);
	НачальныйТокен = РазобратьТекстЗапроса(ТекстПроверочногоЗапроса,,, мПолеТекстаВременное,,,,, Ложь); // Здесь важно получать полное, а не сокращенное дерево, т.к. нужно ЕстьАгрегаты
	Запросы.Очистить();
	Если НачальныйТокен <> Неопределено Тогда
		ЗаполнитьСписокЗапросовПоТокену(НачальныйТокен);
		ЭтаФорма.ЕстьАгрегаты = Ложь;
		Попытка
			КонструкторЗапроса.СобратьВыражениеЗапроса(НачальныйТокен,,,,,, ЕстьАгрегаты);
		Исключение
			// если не ловить исключение, то при открытии некорректного текста с расширенной проверкой форма не показывается и сразу закрывается
			ОписаниеОшибки = ОписаниеОшибки();
		КонецПопытки; 
	КонецЕсли; 
	
КонецПроцедуры

Функция ЗаполнитьСписокЗапросовПоТокену(Знач Токен)
	
	Данные = Токен.Data;
	Если Данные = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	ИмяПравила = Данные.ParentRule.RuleNonterminal.Text;
	Если ИмяПравила = "<EmbeddedRoot>" Тогда
		CтрокаЗапроса = Запросы.Добавить();
		CтрокаЗапроса.Номер = Запросы.Количество();
		CтрокаЗапроса.Текст = ПолучитьТекстИзТокена(Токен, CтрокаЗапроса.НачальнаяСтрока, CтрокаЗапроса.НачальнаяКолонка,
			CтрокаЗапроса.КонечнаяСтрока, CтрокаЗапроса.КонечнаяКолонка, мПолеТекстаВременное);
	Иначе
		Для ИндексТокена = 0 По Данные.TokenCount - 1 Цикл
			ТокенВниз = Данные.Tokens(Данные.TokenCount - 1 - ИндексТокена);
			Если ТокенВниз.Kind = 0 Тогда
				ПсевдонимСнизу = ЗаполнитьСписокЗапросовПоТокену(ТокенВниз);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли; 
	
КонецФункции

Процедура ЗапросыВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ИндексТекущейСтроки = Запросы.Индекс(ВыбраннаяСтрока);
	КоманднаяПанельТекстаОбновитьЗапросы();
	Если ИндексТекущейСтроки >= Запросы.Количество() Тогда
		Возврат;
	КонецЕсли; 
	ВыбраннаяСтрока = Запросы[ИндексТекущейСтроки];
	КонструкторВложенногоЗапроса = ПолучитьКонструкторВложенногоЗапроса(ВыбраннаяСтрока.Текст);
	РезультатФормы = КонструкторВложенногоЗапроса.ОткрытьМодально();
	Если РезультатФормы <> Неопределено Тогда
		АктивноеПолеТекста().УстановитьГраницыВыделения(ВыбраннаяСтрока.НачальнаяСтрока - 1, ВыбраннаяСтрока.НачальнаяКолонка,
			ВыбраннаяСтрока.КонечнаяСтрока - 1, ВыбраннаяСтрока.КонечнаяКолонка);
		АктивноеПолеТекста().ВыделенныйТекст(КонструкторВложенногоЗапроса.Текст);
		ЭтаФорма.Модифицированность = Истина;
		КоманднаяПанельТекстаОбновитьЗапросы();
	КонецЕсли; 
	
КонецПроцедуры

Функция ПолучитьКонструкторВложенногоЗапроса(Знач Текст = "")
	
	КонструкторВложенногоЗапроса = ПолучитьФорму("КонструкторЗапроса");
	ЗагрузитьТекстВКонструктор(Текст, КонструкторВложенногоЗапроса);
	Если КонструкторЗапроса <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(КонструкторВложенногоЗапроса, КонструкторЗапроса, "РасширеннаяПроверка, Английский1С, ТабличноеПолеКорневогоПакета, ПоказыватьИндексы");
	КонецЕсли;
	Возврат КонструкторВложенногоЗапроса;

КонецФункции

Процедура КПЗапросыПеренестиВоВременнуюТаблицу(Кнопка)

	ВыбраннаяСтрока = ЭлементыФормы.Запросы.ТекущаяСтрока;
	Если ВыбраннаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	КонструкторВложенногоЗапроса = ПолучитьКонструкторВложенногоЗапроса(ВыбраннаяСтрока.Текст);
	Если Не КонструкторЗапроса.ЛиПакетныйЗапрос Тогда
		КонструкторЗапроса.ЛиПакетныйЗапрос = Истина;
		КонструкторЗапроса.ЛиПакетныйЗапросПриИзменении();
	КонецЕсли; 
	ЗапросПакета = КонструкторЗапроса.ЗапросыПакета.Вставить(КонструкторЗапроса.ЗапросыПакета.Индекс(КонструкторЗапроса.ЭлементыФормы.ЗапросыПакета.ТекущаяСтрока));
	ЗаполнитьЗначенияСвойств(ЗапросПакета, КонструкторВложенногоЗапроса.ЗапросыПакета[0]);
	КонструкторЗапроса.ОбновитьНаименованиеЗапроса(ЗапросПакета);
	ЗапросПакета.ТипЗапроса = 1;
	ЗапросПакета.ИмяОсновнойТаблицы = ирОбщий.ИдентификаторИзПредставленияЛкс(ЗапросПакета.Имя);
	КонструкторЗапроса.ОбновитьДоступныеВременныеТаблицы();
	ТекстВыбор = "";
	Для Каждого ВыбранноеПоле Из ЗапросПакета.ЧастиОбъединения[0].ВыбранныеПоля Цикл
		Если ТекстВыбор <> "" Тогда
			ТекстВыбор = ТекстВыбор + ", ";
		КонецЕсли; 
		ТекстВыбор = ТекстВыбор + ЗапросПакета.ИмяОсновнойТаблицы + "." + ВыбранноеПоле.Имя;
	КонецЦикла; 
	АктивноеПолеТекста().УстановитьГраницыВыделения(ВыбраннаяСтрока.НачальнаяСтрока - 1, ВыбраннаяСтрока.НачальнаяКолонка,
		ВыбраннаяСтрока.КонечнаяСтрока - 1, ВыбраннаяСтрока.КонечнаяКолонка);
	АктивноеПолеТекста().ВыделенныйТекст( 
		КонструкторЗапроса.СловоЯзыкаЗапросовВФорме("SELECT") + " " + ТекстВыбор + " " + КонструкторЗапроса.СловоЯзыкаЗапросовВФорме("FROM") + " " 
		+ ЗапросПакета.ИмяОсновнойТаблицы + " " + КонструкторЗапроса.СловоЯзыкаЗапросовВФорме("AS") + " " + ЗапросПакета.ИмяОсновнойТаблицы);
	КоманднаяПанельТекстаОбновитьЗапросы();
	
КонецПроцедуры

Процедура ОсновныеДействияФормыСтруктураФормы(Кнопка)
	
	ирКлиент.ОткрытьСтруктуруФормыЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ДоступныеПоляВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ирКлиент.ЗаменитьИВыделитьВыделенныйТекстПоляЛкс(ЭтаФорма, АктивноеПолеТекста(), ВыражениеДоступногоПоля());
	
КонецПроцедуры

Процедура КоманднаяПанельТекстаВыделитьВсе(Кнопка)
	
	АктивноеПолеТекста().УстановитьГраницыВыделения(1, 1 + СтрДлина(АктивноеПолеТекста().ПолучитьТекст()));
	ЭтаФорма.ТекущийЭлемент = АктивноеПолеТекста().ЭлементФормы;
	
КонецПроцедуры

Процедура ТаблицаФункцийВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если ВыбраннаяСтрока.Функция = "ЕСТЬNULL" Тогда
		ВыделенныйТекст = АктивноеПолеТекста().ВыделенныйТекст();
		ВыделенныйТекст = СтрЗаменить(ВыделенныйТекст, мПараметрыДиалектаSQL.ПрефиксПараметра, "ПараметрыДанных.");
		ДоступноеПоле = КомпоновщикНастроек.Настройки.ДоступныеПоляОтбора.НайтиПоле(Новый ПолеКомпоновкиДанных(ВыделенныйТекст));
		Если ДоступноеПоле <> Неопределено Тогда
			ПустоеЗначениеПоля = ДоступноеПоле.ТипЗначения.ПривестиЗначение();
			НовыйТекст = "ЕСТЬNULL(" + АктивноеПолеТекста().ВыделенныйТекст() + ", " + ирОбщий.ВыражениеПриведенияТипаНаЯзыкеЗапросовЛкс(ТипЗнч(ПустоеЗначениеПоля), ДоступноеПоле.ТипЗначения) + ")";
			ирКлиент.ЗаменитьИВыделитьВыделенныйТекстПоляЛкс(ЭтаФорма, АктивноеПолеТекста(), НовыйТекст);
			Возврат;
		КонецЕсли; 
	КонецЕсли; 
	ирКлиент.ЗаменитьИВыделитьВыделенныйТекстПоляЛкс(ЭтаФорма, АктивноеПолеТекста(), ВыбраннаяСтрока.Функция + "(" + АктивноеПолеТекста().ВыделенныйТекст() + ")");
	
КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирКлиент.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

///////////////////////////
//  HTML редактор кода 

Функция РедакторВстроенный()
	
	Возврат ЭлементыФормы.ПолеТекстаВыражения;

КонецФункции

Функция АктивноеПолеТекста(ЭлементФормы = Неопределено)
	Если ЭлементФормы = Неопределено Тогда
		Если ЭлементыФормы.ПанельРедактора.ТекущаяСтраница = ЭлементыФормы.ПанельРедактора.Страницы.РедакторHTML Тогда
			Результат = ЭлементыФормы.РедакторHTML;
		Иначе
			Результат = РедакторВстроенный();
		КонецЕсли;
	Иначе
		Результат = ЭлементФормы;
	КонецЕсли;
	Возврат ирКлиент.ОболочкаПоляТекстаЛкс(Результат);
КонецФункции

Функция РедакторHTML()
	Возврат ПолеТекстаВыражения.ПолеТекста.РедакторHTML();
КонецФункции

Процедура РедакторHTMLДокументСформирован(Элемент)
	#Если Сервер И Не Сервер Тогда
		ПолеТекстаВыражения = Обработки.ирКлсПолеТекстаПрограммы.Создать();
	#КонецЕсли
	ПолеТекстаВыражения.РедакторHTML_Инициировать(Элемент);
	Если ЭлементыФормы.ПанельРедактора.ТекущаяСтраница = ЭлементыФормы.ПанельРедактора.Страницы.РедакторHTML Тогда
		ПанельРедактораПриСменеСтраницы(ЭлементыФормы.ПанельРедактора,);
	КонецЕсли;

КонецПроцедуры

// Мультиметка343281883
Функция ВводДоступенЛкс() Экспорт 
	Если ЭтаФорма.ТекущийЭлемент = ЭлементыФормы.РедакторHTML Тогда
		РедакторHTML = РедакторHTML();
		Результат = Ложь
			Или РедакторHTML <> Неопределено И РедакторHTML.hasTextFocus()
			Или ВводДоступен();
	Иначе
		Результат = ВводДоступен();
	КонецЕсли; 
	Возврат Результат;
КонецФункции

Процедура ПанельРедактораПриСменеСтраницы(Элемент, ТекущаяСтраница)
	Перем КонечнаяКолонка, КонечнаяСтрока, НачальнаяКолонка, НачальнаяСтрока, НачальнаяПозиция, КонечнаяПозиция;
	
	Поле1 = АктивноеПолеТекста(РедакторВстроенный());
	Поле2 = АктивноеПолеТекста(ЭлементыФормы.РедакторHTML);
	ПолеТекстаВыражения.ПанельРедактораКодаПриСменеСтраницы(ЭлементыФормы.ПанельРедактора, Поле1, Поле2, ВыражениеИсходное);

КонецПроцедуры

Процедура РедакторHTMLonclick(Элемент, ДанныеСобытия)
	РедакторHTMLonclickДинамический(ДанныеСобытия);
КонецПроцедуры

// Для подключения через ДобавитьОбработчик внутри ПолеТекстаАлгоритма.РедакторHTML_Инициировать
Процедура РедакторHTMLonclickДинамический(ДанныеСобытия) Экспорт
	
	#Если Сервер И Не Сервер Тогда
		ПолеТекстаВыражения = Обработки.ирКлсПолеТекстаПрограммы.Создать();
	#КонецЕсли
	Событие = ДанныеСобытия.eventData1C;
	Если Событие <> Неопределено Тогда
		Если Событие.event = "EVENT_CONTENT_CHANGED" Тогда
			ЭтаФорма.Модифицированность = Истина;
		ИначеЕсли Событие.event = "EVENT_ON_LINK_CLICK" Тогда
			#Если Сервер И Не Сервер Тогда
				ПерейтиКОпределениюВФорме();
				ВычислитьВыражение();
			#КонецЕсли
			ПолеТекстаВыражения.РедакторHTML_ОбработатьКликНаГиперссылке(Событие, "ПерейтиКОпределениюВФорме", "ВычислитьВыражение");
		ИначеЕсли Событие.event = "EVENT_BEFORE_HOVER" Тогда
			#Если Сервер И Не Сервер Тогда
				ВычислитьВыражение();
			#КонецЕсли
			ПолеТекстаВыражения.РедакторHTML_ПередПоказомПодсказкиУдержания(Событие, "ВычислитьВыражение");
		Иначе
			ПолеТекстаВыражения.РедакторHTML_ОбработатьСобытие(Событие);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция ВычислитьВыражение(Знач ТекущееВыражение, выхУспехВычисления = Истина) Экспорт 
	
	выхУспехВычисления = Ложь;
	ИмяПараметра = Сред(ТекущееВыражение, 2);
	СтрокаПараметра = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных(ИмяПараметра));
	Если СтрокаПараметра <> Неопределено Тогда
		ЗначениеПараметра = СтрокаПараметра.Значение;
		ЭлементыФормы.ДоступныеПоля.ТекущаяСтрока = КомпоновщикНастроек.Настройки.ДоступныеПоляВыбора.НайтиПоле(Новый ПолеКомпоновкиДанных("ПараметрыДанных." + СтрокаПараметра.Параметр));
		выхУспехВычисления = Истина;
	КонецЕсли;
	Возврат ЗначениеПараметра;

КонецФункции

ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирКлсПолеТекстаПрограммы.Форма.РедакторВыраженияЗапроса");

#Если Сервер И Не Сервер Тогда
	ПриПолученииДанныхДоступныхПолей();
#КонецЕсли
ирКлиент.ПодключитьОбработчикиСобытийДоступныхПолейКомпоновкиЛкс(ЭлементыФормы.ДоступныеПоля);

Запросы.Колонки.Добавить("НачальнаяКолонка", Новый ОписаниеТипов("Число"));
Запросы.Колонки.Добавить("НачальнаяСтрока", Новый ОписаниеТипов("Число"));
Запросы.Колонки.Добавить("КонечнаяКолонка", Новый ОписаниеТипов("Число"));
Запросы.Колонки.Добавить("КонечнаяСтрока", Новый ОписаниеТипов("Число"));
ЭтаФорма.ТипВыражения = "Параметр";
мПредставленияТиповВыражений = Новый СписокЗначений;
мПредставленияТиповВыражений.Добавить("УсловиеОтбора", "Отбор");
мПредставленияТиповВыражений.Добавить("ПараметрВиртуальнойТаблицы", "Параметр таблицы");
мПредставленияТиповВыражений.Добавить("УсловиеСвязи", "Связь таблиц");
мПредставленияТиповВыражений.Добавить("ВыбранноеПоле", "Выбранное поле");
мПредставленияТиповВыражений.Добавить("Группировка", "Группировка");
мПредставленияТиповВыражений.Добавить("ПолеИтога", "Итоги");

ТаблицаФункций.Колонки.Добавить("СтруктураТипа");
мИмяСлужебногоПоля = "_СлужебноеПоле" + ирОбщий.СуффиксСлужебногоСвойстваЛкс();
//! КонструкторЗапроса = ПолучитьФорму("КонструкторЗапроса");
