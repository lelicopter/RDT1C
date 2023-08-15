﻿Перем мИменаОсновныхФорм;
Перем мВнешнееСоединение;
Перем мИнтерфейсИР;

Функция СохраняемаяНастройкаФормы(выхНаименование, выхИменаСвойств) Экспорт 
	выхИменаСвойств = "Реквизит.ВыводитьСообщения, Реквизит.КаталогВнешнихМетаданных, Реквизит.НедостающиеОбъекты, Реквизит.ОбъектыМетаданных, Реквизит.Ошибки, Реквизит.ПроверятьВРежимеВнешнееСоединение,
	|Реквизит.ПроверятьНеосновныеФормы, Реквизит.ПроверятьОбъекты, Реквизит.ПроверятьТолькоОшибочные, Реквизит.ПроверятьФормы, Реквизит.ПроверятьФормыОбработок, Реквизит.ПроверятьФормыОтчетов,
	|Реквизит.ПроверятьЭлементыФорм, Табличная часть.ИгнорируемыеСигнатуры";
	Возврат Неопределено;
КонецФункции

Процедура ЗагрузитьНастройкуВФорме(НастройкаФормы, ДопПараметры) Экспорт 
	
	ирКлиент.ЗагрузитьНастройкуФормыЛкс(ЭтаФорма, НастройкаФормы); 
	НастроитьЭлементыФормы();

КонецПроцедуры

Функция Тестироватьформу(Форма, ИмяОперации = "") Экспорт

	Форма.Открыть(); // К сожалению здесь исключения не ловятся http://partners.v8.1c.ru/forum/thread.jsp?id=1080350#1080350
	Если Форма.Открыта() Тогда
		Попытка
			ТестироватьЭлементыФормы(Форма);
		Исключение
			ОтменитьТранзакцию();
			ДобавитьСтрокуОшибкиЛкс(ИмяОперации, ИнформацияОбОшибке());
			НачатьТранзакцию();
		КонецПопытки; 
		Форма.Модифицированность = Ложь;
		Попытка
			Форма.Закрыть();
		Исключение
			ОтменитьТранзакцию();
			ДобавитьСтрокуОшибкиЛкс(ИмяОперации, ИнформацияОбОшибке());
			НачатьТранзакцию();
			Форма.УстановитьДействие("ПередЗакрытием", Неопределено);
			Форма.УстановитьДействие("ПриЗакрытии", Неопределено);
			Форма.Закрыть();
		КонецПопытки; 
	КонецЕсли;

КонецФункции

Функция ТестироватьЭлементыФормы(Форма) Экспорт
	
	Если Не ПроверятьЭлементыФорм Тогда
		Возврат Неопределено;
	КонецЕсли; 
	Если ТипЗнч(Форма) = Тип("Форма") Тогда
		Если Не Форма.Панель.Доступность Тогда
			Возврат Неопределено;
		КонецЕсли; 
		Для Каждого ЭлементФормы Из Форма.ЭлементыФормы Цикл
			Если ТипЗнч(ЭлементФормы) = Тип("ТабличноеПоле") Тогда
				ТестироватьТабличноеПоле(ЭлементФормы, Форма.ТолькоПросмотр);
			ИначеЕсли ТипЗнч(ЭлементФормы) = Тип("Панель") Тогда
				ТестироватьПанель(ЭлементФормы, Форма.ТолькоПросмотр);
			ИначеЕсли ТипЗнч(ЭлементФормы) = Тип("ПолеВвода") Тогда
				ТестироватьПолеВвода(ЭлементФормы, Форма.ТолькоПросмотр);
			КонецЕсли; 
		КонецЦикла;
	ИначеЕсли ТипЗнч(Форма) = ирОбщий.ТипУправляемаяФормаЛкс() Тогда
		Если Не Форма.Доступность Тогда
			Возврат Неопределено;
		КонецЕсли; 
		Для Каждого ЭлементФормы Из Форма.ПодчиненныеЭлементы Цикл
			Если ТипЗнч(ЭлементФормы) = Тип("ТаблицаФормы") Тогда
				ТестироватьТаблицуФормы(ЭлементФормы, Форма.ТолькоПросмотр);
			ИначеЕсли ТипЗнч(ЭлементФормы) = Тип("ГруппаФормы") Тогда
				ТестироватьГруппуФормы(ЭлементФормы, Форма.ТолькоПросмотр);
			ИначеЕсли ТипЗнч(ЭлементФормы) = Тип("ПолеФормы") Тогда
				ТестироватьПолеФормы(ЭлементФормы, Форма.ТолькоПросмотр);
			КонецЕсли; 
		КонецЦикла;
	КонецЕсли; 
	
КонецФункции

Функция ТестироватьТабличноеПоле(ТабличноеПоле, Знач ТолькоПросмотр) Экспорт
	
	Если Истина
		И ТабличноеПоле.Доступность 
		// Там нет никаких обработчиков событий, которое можно было бы вызвать
		// Если в них после добавления и изменения строки вызвать ТестироватьПолеВвода, то потом форму нельзя будет закрыть и даже главное окно приложения!
		И ТипЗнч(ТабличноеПоле.Значение) <> Тип("СписокЗначений") 
	Тогда
		ТолькоПросмотр = ТолькоПросмотр Или ТабличноеПоле.ТолькоПросмотр;
		Попытка
			СпособРедактирования = ТабличноеПоле.СпособРедактирования;
		Исключение
			СпособРедактирования = СпособРедактированияСписка.ВДиалоге;
		КонецПопытки;
		Попытка
			Пустышка = ТабличноеПоле.АвтоОбновление;
			ЭтоДинамическийСписок = Истина;
		Исключение
			ЭтоДинамическийСписок = Ложь;
		КонецПопытки;
		Если Истина
			И ЭтоДинамическийСписок
			И СпособРедактирования <> СпособРедактированияСписка.ВСписке 
		Тогда
			ТолькоПросмотр = Истина;
		КонецЕсли; 
		Если Истина
			И Не ТолькоПросмотр
			И ТабличноеПоле.ИзменятьСоставСтрок 
		Тогда
			// Добавляем строку
			ДействиеПередНачаломДобавления = ТабличноеПоле.ПолучитьДействие("ПередНачаломДобавления");
			Если Ложь
				Или ДействиеПередНачаломДобавления <> Неопределено // Здесь часто открываются дополнительные Формы
			Тогда
				// Защита от открытия дополнительных Форм
			Иначе
				ТабличноеПоле.ДобавитьСтроку();
			КонецЕсли; 
		КонецЕсли; 
		ТекущаяСтрока = ТабличноеПоле.ТекущаяСтрока;
		Если ТекущаяСтрока <> Неопределено Тогда
			Если Истина
				И Не ТолькоПросмотр 
				И (Ложь
					Или Не ЭтоДинамическийСписок
					Или СпособРедактирования = СпособРедактированияСписка.ВСписке)
			Тогда
				// Входим в режим редактирования и вызваем ПриИзменении для каждого поля ввода в текущей строке
				ТабличноеПоле.ИзменитьСтроку();
				Для Каждого КолонкаТП Из ТабличноеПоле.Колонки Цикл
					Если Истина
						И КолонкаТП.Доступность 
						И КолонкаТП.Видимость
					Тогда
						Если ТипЗнч(КолонкаТП.ЭлементУправления) = Тип("ПолеВвода") Тогда
							ТабличноеПоле.ТекущаяКолонка = КолонкаТП;
							ТестироватьПолеВвода(КолонкаТП.ЭлементУправления, ТолькоПросмотр Или КолонкаТП.ТолькоПросмотр);
						КонецЕсли; 
					КонецЕсли;
				КонецЦикла;
				ТабличноеПоле.ЗакончитьРедактированиеСтроки(Ложь);
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 

КонецФункции

Функция ТестироватьПанель(Панель, Знач ТолькоПросмотр) Экспорт
	
	Если Истина
		И Панель.Видимость
		И Панель.Доступность
	Тогда
		ТекущаяСтраница = Панель.ТекущаяСтраница;
		Для Каждого Страница Из Панель.Страницы Цикл
			Если Истина
				И Страница.Доступность 
				И Страница.Видимость
			Тогда
				Панель.ТекущаяСтраница = Страница;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли; 

КонецФункции

Процедура ТестироватьПолеВвода(ПолеВвода, Знач ТолькоПросмотр) Экспорт

	Если Истина
		И Не ТолькоПросмотр
		И Не ПолеВвода.ТолькоПросмотр
		И ПолеВвода.Доступность
	Тогда
		//ирКлиент.ИнтерактивноЗаписатьВПолеВводаЛкс(ПолеВвода, Неопределено);
		НепустоеЗначение = Неопределено;
		Если ПолеВвода.РежимВыбораИзСписка Тогда
			Если ПолеВвода.СписокВыбора.Количество() > 0 Тогда
				НепустоеЗначение = ПолеВвода.СписокВыбора[0].Значение;
			КонецЕсли; 
		Иначе
			НепустоеЗначение = НепустоеЗначениеПоОписаниюТипов(ПолеВвода.ТипЗначения);
		КонецЕсли; 
		//Если НепустоеЗначение <> Неопределено Тогда
			ДействиеНачалоВыбора = ПолеВвода.ПолучитьДействие("НачалоВыбора");
			Если ДействиеНачалоВыбора <> Неопределено Тогда
				// Здесь часто ограничивается множество выбора и потому высока вероятность установить некорректное с точки зрения смысла значение
			Иначе
				ирКлиент.ИнтерактивноЗаписатьВПолеВводаЛкс(ПолеВвода, НепустоеЗначение);
			КонецЕсли; 
		//КонецЕсли; 
	КонецЕсли; 

КонецПроцедуры

Функция ТестироватьТаблицуФормы(ТаблицаФормы, Знач ТолькоПросмотр) Экспорт
	
	Если ТаблицаФормы.Доступность Тогда
		ТолькоПросмотр = ТолькоПросмотр Или ТаблицаФормы.ТолькоПросмотр;
		Попытка
			СпособРедактирования = ТаблицаФормы.СпособРедактирования;
		Исключение
			СпособРедактирования = СпособРедактированияСписка.ВДиалоге;
		КонецПопытки;
		Попытка
			Пустышка = ТаблицаФормы.АвтоОбновление;
			ЭтоДинамическийСписок = Истина;
		Исключение
			ЭтоДинамическийСписок = Ложь;
		КонецПопытки;
		Если Истина
			И ЭтоДинамическийСписок
			И СпособРедактирования <> СпособРедактированияСписка.ВСписке 
		Тогда
			ТолькоПросмотр = Истина;
		КонецЕсли; 
		Если Истина
			И Не ТолькоПросмотр
			И ТаблицаФормы.ИзменятьСоставСтрок 
		Тогда
			// Добавляем строку
			ДействиеПередНачаломДобавления = Неопределено;
			//ДействиеПередНачаломДобавления = ТаблицаФормы.ПолучитьДействие("ПередНачаломДобавления"); // Доделать!
			Если Ложь
				Или ДействиеПередНачаломДобавления <> Неопределено // Здесь часто открываются дополнительные Формы
			Тогда
				// Защита от открытия дополнительных Форм
			Иначе
				ТаблицаФормы.ДобавитьСтроку();
			КонецЕсли; 
		КонецЕсли; 
		ТекущаяСтрока = ТаблицаФормы.ТекущаяСтрока;
		Если ТекущаяСтрока <> Неопределено Тогда
			Если Истина
				И Не ТолькоПросмотр 
				И (Ложь
					Или Не ЭтоДинамическийСписок
					Или СпособРедактирования = СпособРедактированияСписка.ВСписке)
			Тогда
				// Входим в режим редактирования и вызваем ПриИзменении для каждого поля ввода в текущей строке
				ТаблицаФормы.ИзменитьСтроку();
				Для Каждого ПолеФормы Из ТаблицаФормы.ПодчиненныеЭлементы Цикл
					Если Истина
						И ПолеФормы.Доступность 
						И ПолеФормы.Видимость
					Тогда
						ТаблицаФормы.ТекущийЭлемент = ПолеФормы;
						ТестироватьПолеФормы(ПолеФормы, ТолькоПросмотр);
					КонецЕсли;
				КонецЦикла;
				ТаблицаФормы.ЗакончитьРедактированиеСтроки(Ложь);
			КонецЕсли;
		КонецЕсли; 
	КонецЕсли; 

КонецФункции

Процедура ТестироватьПолеФормы(ПолеФормы, Знач ТолькоПросмотр) Экспорт

	Если Истина
		И Не ТолькоПросмотр
		И Не ПолеФормы.ТолькоПросмотр
		И ПолеФормы.Доступность
		И ПолеФормы.Вид = ВидПоляФормы.ПолеВвода
	Тогда
		Если ПолеФормы.Имя = "Код" Тогда
			// Грубая защита от поля ввода связанного с кодом, у которого нет простых признаков для определения возможности редактирования
			Возврат;
		КонецЕсли; 
		//ирКлиент.ИнтерактивноЗаписатьВПолеВводаЛкс(ПолеВвода, Неопределено);
		НепустоеЗначение = Неопределено;
		//Если ПолеФормы.РежимВыбораИзСписка Тогда
			Если ПолеФормы.СписокВыбора.Количество() > 0 Тогда
				НепустоеЗначение = ПолеФормы.СписокВыбора[0].Значение;
			КонецЕсли; 
		//Иначе
		//	//НепустоеЗначение = НепустоеЗначениеПоОписаниюТипов(ПолеФормы.ТипЗначения); // Доделать!
		//КонецЕсли; 
		//Если НепустоеЗначение <> Неопределено Тогда
			ДействиеНачалоВыбора = Неопределено;
			//ДействиеНачалоВыбора = ПолеФормы.ПолучитьДействие("НачалоВыбора"); // Доделать!
			Если ДействиеНачалоВыбора <> Неопределено Тогда
				// Здесь часто ограничивается множество выбора и потому высока вероятность установить некорректное с точки зрения смысла значение
			Иначе
				ирКлиент.ИнтерактивноЗаписатьВПолеВводаЛкс(ПолеФормы, НепустоеЗначение);
			КонецЕсли; 
		//КонецЕсли; 
	КонецЕсли; 

КонецПроцедуры

Функция ТестироватьГруппуФормы(ГруппаФормы, Знач ТолькоПросмотр) Экспорт
	
	Если ГруппаФормы.Вид = ВидГруппыФормы.ГруппаКолонок Тогда
		Для Каждого ЭлементГруппы Из ГруппаФормы.ПодчиненныеЭлементы Цикл
			Если ТипЗнч(ЭлементГруппы) = Тип("ГруппаФормы") Тогда
				ТестироватьГруппуФормы(ЭлементГруппы, ТолькоПросмотр);
			Иначе
				ТестироватьПолеФормы(ЭлементГруппы, ТолькоПросмотр)
			КонецЕсли; 
		КонецЦикла;
	ИначеЕсли ГруппаФормы.Вид = ВидГруппыФормы.Страницы Тогда
		Если Истина
			И ГруппаФормы.Видимость
			И ГруппаФормы.Доступность
		Тогда
			ТекущаяСтраница = ГруппаФормы.ТекущаяСтраница;
			Для Каждого Страница Из ГруппаФормы.ПодчиненныеЭлементы Цикл
				Если Истина
					И Страница.Доступность 
					И Страница.Видимость
				Тогда
					ГруппаФормы.ТекущаяСтраница = Страница;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли; 
	КонецЕсли; 

КонецФункции

Функция ПолучитьМетаФормыОбъектаДляПроверки(МетаОбъект)
	
	МетаФормы = Новый Массив();
	Для Каждого ИмяОсновнойФормы Из мИменаОсновныхФорм Цикл
		Попытка
			МетаФорма = МетаОбъект[ИмяОсновнойФормы];
		Исключение
			Продолжить;
		КонецПопытки;
		Если МетаФорма = Неопределено Тогда
			Продолжить;
		КонецЕсли; 
		Если МетаФормы.Найти(МетаФорма) <> Неопределено Тогда
			Продолжить;
		КонецЕсли; 
		МетаФормы.Добавить(МетаФорма);
	КонецЦикла;
	Возврат МетаФормы;
	
КонецФункции

Функция ГлобальныйТестФорм() Экспорт
	
	КлючВременнойФормы = "Автотест";

	// общие формы
	Если ПроверятьНеосновныеФормы Тогда
		МетаФормы = Метаданные.ОбщиеФормы;
	Иначе
		МетаФормы = ПолучитьМетаФормыОбъектаДляПроверки(Метаданные);
	КонецЕсли;
	Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(МетаФормы.Количество(), "Общие формы");
	Счетчик = 0;
	ПараметрыСозданияФормы = ирКлиент.ПараметрыБыстрогоСозданияФормыЛкс();
	Для Каждого МетаФорма Из МетаФормы Цикл
		Счетчик = Счетчик + 1;
		Если Счетчик < 11 Тогда
			Продолжить;
		КонецЕсли; 
		ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
		ИмяОперации = МетаФорма.ПолноеИмя();
		Если Истина
			И ОбъектыМетаданных.Количество() > 0
			И ОбъектыМетаданных.НайтиПоЗначению(ИмяОперации) = Неопределено
		Тогда
			Продолжить;
		КонецЕсли; 
		Если ВыводитьСообщения Тогда
			ирОбщий.СообщитьЛкс("" + ТекущаяДата() + " " + ИмяОперации);
		КонецЕсли; 
		НачатьТранзакцию();
		Попытка
			Форма = ПолучитьФорму(МетаФорма.ПолноеИмя(), ПараметрыСозданияФормы);
			Если Форма = Неопределено Тогда
				ОтменитьТранзакцию(); //
				Продолжить;
			КонецЕсли; 
			Тестироватьформу(Форма, ИмяОперации);
		Исключение
			ДобавитьСтрокуОшибкиЛкс(ИмяОперации, ИнформацияОбОшибке());
		КонецПопытки;
		ОтменитьТранзакцию();
	КонецЦикла;
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	
	// Формы подчиненные объектам метаданных
	ТипыМетаданных = ирКэш.ТипыМетаОбъектов(Истина, Ложь, Истина);
	ИндикаторТиповМетаданных = ирОбщий.ПолучитьИндикаторПроцессаЛкс(ТипыМетаданных.Количество(), "Формы. Типы метаданных");
	Для Каждого СтрокаТипаМетаданных Из ТипыМетаданных Цикл
		ирОбщий.ОбработатьИндикаторЛкс(ИндикаторТиповМетаданных);
		Если Ложь
			Или СтрокаТипаМетаданных.Единственное = "Перерасчет"
		Тогда
			Продолжить;
		КонецЕсли; 
		Если Истина
			И Не ПроверятьФормыОбработок
			И (Ложь
				Или СтрокаТипаМетаданных.Единственное = "ВнешняяОбработка"
				Или СтрокаТипаМетаданных.Единственное = "Обработка")
		Тогда
			Продолжить;
		КонецЕсли; 
		Если Истина
			И Не ПроверятьФормыОтчетов
			И (Ложь
				Или СтрокаТипаМетаданных.Единственное = "ВнешнийОтчет"
				Или СтрокаТипаМетаданных.Единственное = "Отчет")
		Тогда
			Продолжить;
		КонецЕсли; 
		Если Ложь
			Или СтрокаТипаМетаданных.Единственное = "ВнешняяОбработка"
			Или СтрокаТипаМетаданных.Единственное = "ВнешнийОтчет"
		Тогда
			Если ЗначениеЗаполнено(КаталогВнешнихМетаданных) Тогда
				Если Не ПроверятьТолькоОшибочные Тогда
					ОбновитьВнешниеМетаданные(Истина);
				КонецЕсли; 
				КоллекцияМетаОбъектов = НайтиФайлы(КаталогВнешнихМетаданных, "*.epf", Истина);
				КоллекцияМетаОбъектов1 = НайтиФайлы(КаталогВнешнихМетаданных, "*.erf", Истина);
				ирОбщий.СкопироватьКоллекциюЛкс(КоллекцияМетаОбъектов1, КоллекцияМетаОбъектов);
			Иначе
				Продолжить;
			КонецЕсли; 
		Иначе
			//Продолжить; ////////////
			КоллекцияМетаОбъектов = Метаданные[СтрокаТипаМетаданных.Множественное];
		КонецЕсли; 
		Индикатор2 = ирОбщий.ПолучитьИндикаторПроцессаЛкс(КоллекцияМетаОбъектов.Количество(), СтрокаТипаМетаданных.Множественное);
		Для Каждого МетаОбъект Из КоллекцияМетаОбъектов Цикл
			ирОбщий.ОбработатьИндикаторЛкс(Индикатор2);
			КоличествоОшибок = Ошибки.Количество();
			Если ТипЗнч(МетаОбъект) = Тип("Файл") Тогда
				Если Истина
					И ОбъектыМетаданных.Количество() > 0
					И ОбъектыМетаданных.НайтиПоЗначению(СтрокаТипаМетаданных.Единственное + "." + МетаОбъект.Имя) = Неопределено
				Тогда
					Продолжить;
				КонецЕсли; 
				МенеджерВнешнихМетаданных = Вычислить(СтрокаТипаМетаданных.Множественное);
				Попытка
					ВнешнийОбъект = МенеджерВнешнихМетаданных.Создать(МетаОбъект.ПолноеИмя, Ложь);
				Исключение
					ОписаниеОшибки = ОписаниеОшибки();
					Если Найти(НРег(ОписаниеОшибки), НРег("не может быть прочитан")) = 0 Тогда
						ДобавитьСтрокуОшибкиЛкс(ВнешнийОбъект.ИспользуемоеИмяФайла, ИнформацияОбОшибке());
					КонецЕсли; 
					Продолжить;
				КонецПопытки; 
				МетаОбъект = ВнешнийОбъект.Метаданные();
			Иначе
				ПолноеИмяМД = МетаОбъект.ПолноеИмя();
				Если Истина
					И ОбъектыМетаданных.Количество() > 0
					И ОбъектыМетаданных.НайтиПоЗначению(ПолноеИмяМД) = Неопределено
				Тогда
					Продолжить;
				КонецЕсли; 
				Если Истина
					И ОбъектыМетаданных.Количество() > 0
					И ОбъектыМетаданных.НайтиПоЗначению(ПолноеИмяМД) = Неопределено
				Тогда
					Продолжить;
				КонецЕсли; 
				ВнешнийОбъект = Неопределено;
			КонецЕсли;
			Если ПроверятьНеосновныеФормы Тогда
				Попытка
					МетаФормы = МетаОбъект.Формы;
				Исключение
					Продолжить;
				КонецПопытки;
			Иначе
				МетаФормы = ПолучитьМетаФормыОбъектаДляПроверки(МетаОбъект);
			КонецЕсли; 
			Если ВнешнийОбъект = Неопределено Тогда
				МенеджерОбъектаМетаданных = ирОбщий.ПолучитьМенеджерЛкс(МетаОбъект);
			КонецЕсли;
			ПараметрыСозданияФормы = Новый Структура;
			Если СтрокаТипаМетаданных.Единственное = "Справочник" Тогда
				Если МетаОбъект.Владельцы.Количество() > 0 Тогда
					СтруктураОбъекта = ирОбщий.ОбъектБДПоКлючуЛкс(МетаОбъект.ПолноеИмя());
					ЗаполнитьРеквизитыНепустымиЗначениями(СтруктураОбъекта.Данные, МетаОбъект);
					ВладелецОбъекта = СтруктураОбъекта.Данные.Владелец;
					ПараметрыСозданияФормы = Новый Структура("ПараметрВыборПоВладельцу, Владелец, Отбор", ВладелецОбъекта, ВладелецОбъекта, Новый Структура("Владелец", ВладелецОбъекта));
				КонецЕсли; 
			КонецЕсли; 
			Для Каждого МетаФорма Из МетаФормы Цикл
				ИмяОперации = МетаФорма.ПолноеИмя();
				Если ВнешнийОбъект <> Неопределено Тогда
					ИмяОперации = Сред(ВнешнийОбъект.ИспользуемоеИмяФайла, СтрДлина(КаталогВнешнихМетаданных) + 2) + "." + ИмяОперации;
				КонецЕсли; 
				Если ВыводитьСообщения Тогда
					ирОбщий.СообщитьЛкс("" + ТекущаяДата() + " " + ИмяОперации);
				КонецЕсли; 
				НачатьТранзакцию();
				Попытка
					Форма = ПолучитьНовуюФорму(МетаФорма, ВнешнийОбъект, КлючВременнойФормы, ПараметрыСозданияФормы);
					Если Форма <> Неопределено Тогда
						ЭтоФормаСсылочногоОбъекта = Ложь;
						Если ТипЗнч(Форма) = Тип("Форма") Тогда
							Попытка
								Пустышка = Форма.ЭтотОбъект.ЭтоНовый();
								ЭтоФормаСсылочногоОбъекта = Истина;
							Исключение
							КонецПопытки;
						Иначе
							Если Форма.Параметры.Свойство("Ключ") Тогда
								Попытка
									Пустышка = Форма.Параметры.Ключ.Ссылка;
									ЭтоФормаСсылочногоОбъекта = Истина;
								Исключение
								КонецПопытки;
							КонецЕсли; 
						КонецЕсли; 
						Если ЭтоФормаСсылочногоОбъекта Тогда
							Если ТипЗнч(Форма) = Тип("Форма") Тогда
								СсылкаОбъекта = Форма.Ссылка;
							Иначе
								СсылкаОбъекта = Форма.Параметры.Ключ;
							КонецЕсли; 
							МенеджерТипаОбъектаФормы = ирОбщий.ПолучитьМенеджерЛкс(СсылкаОбъекта);
							Выборка = МенеджерТипаОбъектаФормы.Выбрать();
							Если ТипЗнч(Форма) = Тип("Форма") Тогда
								Если Выборка.Следующий() Тогда
									СсылочныйОбъект = Выборка.ПолучитьОбъект();
									СсылочныйОбъект = СсылочныйОбъект.Скопировать();
								Иначе
									СсылочныйОбъект = ирОбщий.СоздатьСсылочныйОбъектПоМетаданнымЛкс(МетаОбъект);
									ЗаполнитьРеквизитыНепустымиЗначениями(СсылочныйОбъект, МетаОбъект);
								КонецЕсли; 
								Если МенеджерТипаОбъектаФормы = МенеджерОбъектаМетаданных Тогда
									Форма = СсылочныйОбъект.ПолучитьФорму(МетаФорма.Имя, , КлючВременнойФормы);
								Иначе
									// Дольше но универсальнее
									Форма = ПолучитьНовуюФорму(МетаФорма, ВнешнийОбъект, КлючВременнойФормы);
									Форма[мПлатформа.ИмяОсновногоРеквизитаФормы(Форма)] = СсылочныйОбъект;
								КонецЕсли; 							
							Иначе
								ПараметрыСозданияФормы = ирКлиент.ПараметрыБыстрогоСозданияФормыЛкс();
								Если Выборка.Следующий() Тогда
									ПараметрыСозданияФормы.Вставить("ЗначениеКопирования", Выборка.Ссылка);
								КонецЕсли; 
								Форма = ирКлиент.ПолучитьФормуЛкс(МетаФорма.ПолноеИмя(), ПараметрыСозданияФормы, , КлючВременнойФормы);
							КонецЕсли; 
						КонецЕсли;
					КонецЕсли; 
					Если Форма = Неопределено Тогда
						ОтменитьТранзакцию();
						Продолжить;
					КонецЕсли;
					Тестироватьформу(Форма, ИмяОперации);
				Исключение
					ДобавитьСтрокуОшибкиЛкс(ИмяОперации, ИнформацияОбОшибке());
				КонецПопытки;
				ОтменитьТранзакцию();
			КонецЦикла;
			Если КоличествоОшибок <> Ошибки.Количество() Тогда
				ОбновитьОтображение();
			КонецЕсли; 
		КонецЦикла;
		ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	КонецЦикла;
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	
КонецФункции

Функция ПолучитьНовуюФорму(МетаФорма, ВнешнийОбъект = Неопределено, КлючВременнойФормы = Неопределено, ПараметрыФормы = Неопределено)

	Если ВнешнийОбъект <> Неопределено Тогда
		Форма = ВнешнийОбъект.ПолучитьФорму(МетаФорма.Имя, , КлючВременнойФормы);
	Иначе
		//Форма = МенеджерТипа.ПолучитьФорму(МетаФорма.Имя, , КлючВременнойФормы);
		Форма = ирКлиент.ПолучитьФормуЛкс(МетаФорма.ПолноеИмя(), ПараметрыФормы, , КлючВременнойФормы);
	КонецЕсли; 
	Если Форма <> Неопределено И ПараметрыФормы <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(Форма, ПараметрыФормы); 
	КонецЕсли; 
	Возврат Форма;

КонецФункции

Процедура КнопкаВыполнитьНажатие(Кнопка = Неопределено) Экспорт 
	
	ПодключитьОбработчикОжидания("НастроитьЭлементыФормы", 0.1, Истина);
	Если ПроверятьТолькоОшибочные И Ошибки.Количество() > 0 Тогда
		НовыеМетаданные = Ошибки.ВыгрузитьКолонку("Метаданные");
	КонецЕсли; 
	ИнициализироватьНепустыеЗначения();
	Ошибки.Очистить();
	ЭлементыФормы.Ошибки.ОбновитьСтроки();
	НедостающиеОбъекты.Очистить();
	ВыполнитьТесты(НовыеМетаданные);
	
КонецПроцедуры

Процедура ВыполнитьТесты(ОбъектыМДДляТеста = Неопределено)
	
	Если ОбъектыМДДляТеста = Неопределено Тогда
		мОбъектыМДДляТеста = ОбъектыМетаданных;
	Иначе
		мОбъектыМДДляТеста = Новый СписокЗначений;
		мОбъектыМДДляТеста.ЗагрузитьЗначения(ирОбщий.СвернутьМассивЛкс(ОбъектыМДДляТеста));
	КонецЕсли;
	Для Каждого Сигнатура Из ИгнорируемыеСигнатуры Цикл
		Если ПустаяСтрока(Сигнатура) Тогда
			Сигнатура.Пометка = Ложь;
		КонецЕсли; 
	КонецЦикла;
	ЭлементыФормы.Панель1.ТекущаяСтраница = ЭлементыФормы.Панель1.Страницы.Ошибки;
	ОбновитьОтображение();
	Если ПроверятьОбъекты Тогда
		Если ПроверятьВРежимеВнешнееСоединение Тогда
			Если мВнешнееСоединение = Неопределено Тогда
				мВнешнееСоединение = ирОбщий.ПолучитьСобственноеВнешнееСоединениеЛкс(Истина, мИнтерфейсИР);
			КонецЕсли; 
			ОбработкаCOM = мИнтерфейсИР.ирОбщий.СоздатьОбъектПоИмениМетаданныхЛкс("Обработка.ирТестированиеМетаданных");
			ОбъектМД = ЭтотОбъект.Метаданные();
			Для Каждого Реквизит Из ОбъектМД.Реквизиты Цикл
				Если Ложь
					Или Реквизит = ОбъектМД.Реквизиты.Ошибки
					Или Реквизит = ОбъектМД.Реквизиты.НедостающиеОбъекты
				Тогда
					Продолжить;
				КонецЕсли; 
				ОбработкаCOM[Реквизит.Имя] = ЭтотОбъект[Реквизит.Имя];
			КонецЦикла;
			СтрокаВнутр = ЗначениеВСтрокуВнутр(ОбъектыМетаданных.ВыгрузитьЗначения());
			МассивCOM = мВнешнееСоединение.ЗначениеИзСтрокиВнутр(СтрокаВнутр);
			ОбработкаCOM.ОбъектыМетаданных.ЗагрузитьЗначения(МассивCOM);
			СтрокаВнутр = ЗначениеВСтрокуВнутр(ИгнорируемыеСигнатуры.Выгрузить());
			ТаблицаЗначенийCOM = мВнешнееСоединение.ЗначениеИзСтрокиВнутр(СтрокаВнутр);
			ОбработкаCOM.ИгнорируемыеСигнатуры.Загрузить(ТаблицаЗначенийCOM);
			Состояние("Тест объектов во внешнем соединении...");
			ОписаниеОшибки = "";
			Пока Истина Цикл
				Попытка
					ОбработкаCOM.ГлобальныйТестОбъектов();
					Прервать;
				Исключение
					Если ОбработкаCOM.мТекущееПолноеИмяМД = Неопределено Тогда
						ВызватьИсключение;
					КонецЕсли; 
					ДобавитьСтрокуОшибкиЛкс(ОбработкаCOM.мТекущееПолноеИмяМД + ".Объект", ИнформацияОбОшибке().Причина, , "ВнешнееСоединение");
				КонецПопытки;
				ОбработкаПрерыванияПользователя();
			КонецЦикла; 
			Состояние("");
			СтрокаВнутр = мВнешнееСоединение.ЗначениеВСтрокуВнутр(ОбработкаCOM.Ошибки);
			ОшибкиНовые = ЗначениеИзСтрокиВнутр(СтрокаВнутр);
			ирОбщий.ЗагрузитьВТаблицуЗначенийЛкс(ОшибкиНовые, Ошибки, , Новый Структура("Контекст", "ВнешнееСоединение"));
		КонецЕсли; 
		ОбновитьОтображение();
		ГлобальныйТестОбъектов(ЭтаФорма);
	КонецЕсли; 
	Если ПроверятьФормы Тогда
		ГлобальныйТестФорм();
	КонецЕсли; 
	Ошибки.Сортировать("Метаданные, Операция, Контекст");
	НедостающиеОбъекты.Сортировать("Метаданные, Свойства");
	НастроитьЭлементыФормы();

КонецПроцедуры

Процедура РезультатыВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если Колонка = ЭлементыФормы.Ошибки.Колонки.Метаданные Тогда
		ирКлиент.ОткрытьОбъектМетаданныхЛкс(ВыбраннаяСтрока.Метаданные);
	ИначеЕсли Колонка = ЭлементыФормы.Ошибки.Колонки.СнимокОбъекта Тогда
		ирКлиент.ОткрытьТекстЛкс(ВыбраннаяСтрока.СнимокОбъекта,, "");
	Иначе
		Если ВыбраннаяСтрока.ИнформацияОбОшибке <> Неопределено Тогда
			ПоказатьИнформациюОбОшибке(ВыбраннаяСтрока.ИнформацияОбОшибке);
		Иначе
			ирКлиент.ОткрытьТекстЛкс(ВыбраннаяСтрока.ОписаниеОшибки);
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

Процедура КаталогВнешнихМетаданныхНачалоВыбора(Элемент, СтандартнаяОбработка)

	ирКлиент.ПолеФайловогоКаталога_НачалоВыбораЛкс(Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура КаталогВнешнихМетаданныхНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)

	ирОбщий.ПолеВводаСИсториейВыбора_ОбновитьСписокЛкс(Элемент, ЭтаФорма);
	
КонецПроцедуры

Процедура КаталогВнешнихМетаданныхПриИзменении(Элемент)

	ирКлиент.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
	ОбновитьВнешниеМетаданные();
	
КонецПроцедуры

Процедура ОбновитьВнешниеМетаданные(ЗаполнитьТолькоЕслиНет = Ложь)
	
	НачальноеКоличество = ОбъектыМетаданных.Количество();
	Для СчетчикОбъектыМетаданных = 1 По НачальноеКоличество Цикл
		ПолноеИмяМД = ОбъектыМетаданных[НачальноеКоличество - СчетчикОбъектыМетаданных];
		Если Ложь
			Или ирОбщий.ПервыйФрагментЛкс(ПолноеИмяМД) = "ВнешняяОбработка" 
			Или ирОбщий.ПервыйФрагментЛкс(ПолноеИмяМД) = "ВнешнийОтчет"
		Тогда
			Если ЗаполнитьТолькоЕслиНет Тогда 
				Возврат;
			КонецЕсли; 
			ОбъектыМетаданных.Удалить(ПолноеИмяМД);
		КонецЕсли;
	КонецЦикла;
	Файлы = НайтиФайлы(КаталогВнешнихМетаданных, "*.epf", Истина);
	Для Каждого Файл Из Файлы Цикл
		ОбъектыМетаданных.Добавить("ВнешняяОбработка." + Файл.Имя);
	КонецЦикла;
	Файлы = НайтиФайлы(КаталогВнешнихМетаданных, "*.erf", Истина);
	Для Каждого Файл Из Файлы Цикл
		ОбъектыМетаданных.Добавить("ВнешнияОтчет." + Файл.Имя);
	КонецЦикла;

КонецПроцедуры

Процедура ПроверятьЭлементыФормПриИзменении(Элемент)
	
	Если ЭтотОбъект.ПроверятьЭлементыФорм Тогда
		ЭтотОбъект.ПроверятьФормы = Истина;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	ирКлиент.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура ОбъектыМетаданныхНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	Форма = ирКэш.Получить().ПолучитьФорму("ВыборОбъектаМетаданных", Элемент, ЭтаФорма);
	лСтруктураПараметров = Новый Структура;
	лНачальноеЗначениеВыбора = ОбъектыМетаданных.ВыгрузитьЗначения();
	лСтруктураПараметров.Вставить("НачальноеЗначениеВыбора", лНачальноеЗначениеВыбора);
	лСтруктураПараметров.Вставить("ОтображатьКонстанты", Истина);
	лСтруктураПараметров.Вставить("ОтображатьРегистры", Истина);
	лСтруктураПараметров.Вставить("ОтображатьПерерасчеты", Ложь);
	лСтруктураПараметров.Вставить("ОтображатьПоследовательности", Истина);
	лСтруктураПараметров.Вставить("ОтображатьСсылочныеОбъекты", Истина);
	лСтруктураПараметров.Вставить("ОтображатьОбработки", Истина);
	лСтруктураПараметров.Вставить("ОтображатьОтчеты", Истина);
	лСтруктураПараметров.Вставить("ОтображатьВыборочныеТаблицы", Истина);
	лСтруктураПараметров.Вставить("ОтображатьВнешниеИсточникиДанных", Истина);
	лСтруктураПараметров.Вставить("МножественныйВыбор", Истина);
	Форма.НачальноеЗначениеВыбора = лСтруктураПараметров;
	ВыбранноеЗначение = Форма.ОткрытьМодально();
	СтандартнаяОбработка = Ложь;
	Если ВыбранноеЗначение <> Неопределено Тогда
		ОбъектыМетаданных.ЗагрузитьЗначения(ВыбранноеЗначение);
	КонецЕсли; 
	
КонецПроцедуры

Процедура РезультатыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ирКлиент.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
	КорневойТип = ирОбщий.ПервыйФрагментЛкс(ДанныеСтроки.Метаданные);
	КартинкаКорневогоТипа = ирКлиент.КартинкаКорневогоТипаМДЛкс(КорневойТип);
	ОформлениеСтроки.Ячейки.Метаданные.УстановитьКартинку(КартинкаКорневогоТипа);
	
КонецПроцедуры

Процедура КоманднаяПанель2ОтобратьПоМетаданным(Кнопка)
	
	ирКлиент.ИзменитьОтборКлиентаПоМетаданнымЛкс(ЭлементыФормы.Ошибки);
	
КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	ирКлиент.Форма_ОбновлениеОтображенияЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ОбновитьОтображение() Экспорт 
	
	ЭлементыФормы.Ошибки.ОбновитьСтроки();
	ОбновлениеОтображения();
	
КонецПроцедуры

Процедура НедостающиеОбъектыВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ирКлиент.ОткрытьФормуСпискаЛкс(ВыбраннаяСтрока.Метаданные, ВыбраннаяСтрока.Свойства);
	
КонецПроцедуры

Процедура ПроверятьФормыПриИзменении(Элемент)
	
	НастроитьЭлементыФормы();
	
КонецПроцедуры

Процедура НастроитьЭлементыФормы()
	
	ЭлементыФормы.ПроверятьДополнительныеФормы.Доступность = ПроверятьФормы;
	ЭлементыФормы.ПроверятьФормыОбработок.Доступность = ПроверятьФормы;
	ЭлементыФормы.ПроверятьФормыОтчетов.Доступность = ПроверятьФормы;
	ЭлементыФормы.ПроверятьЭлементыФорм.Доступность = ПроверятьФормы;
	ЭлементыФормы.ПроверятьВРежимеВнешнееСоединение.Доступность = ПроверятьОбъекты;
	ЭлементыФормы.ПроверятьТолькоОшибочные.Доступность = Ошибки.Количество() > 0;
	ЭлементыФормы.ОбъектыМетаданных.Доступность = Не ПроверятьТолькоОшибочные Или Ошибки.Количество() = 0;
	
КонецПроцедуры

Процедура ПроверятьОбъектыПриИзменении(Элемент)

	НастроитьЭлементыФормы();
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ирКлиент.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ирКлиент.СоздатьМенеджерСохраненияНастроекФормыЛкс(ЭтаФорма);
	ФиксированныеСигнатуры = Новый Массив;
	ФиксированныеСигнатуры.Добавить(" Не удалось записать");
	ФиксированныеСигнатуры.Добавить(" Не удалось провести");
	ФиксированныеСигнатуры.Добавить(" Не удалось сделать непроведенным");
	ФиксированныеСигнатуры.Добавить(" Запись с такими ключевыми полями существует!");
	ФиксированныеСигнатуры.Добавить(" Из текущего сеанса недопустимо использовать указанные значения разделителей");
	Для Каждого ФиксированнаяСигнатура Из ФиксированныеСигнатуры Цикл
		Если ИгнорируемыеСигнатуры.Найти(ФиксированнаяСигнатура, "Строка") = Неопределено Тогда
			СтрокаСигнатуры = ИгнорируемыеСигнатуры.Добавить();
			СтрокаСигнатуры.Строка = ФиксированнаяСигнатура;
			СтрокаСигнатуры.Пометка = Истина;
		КонецЕсли; 
	КонецЦикла;
	ИгнорируемыеСигнатуры.Сортировать("Строка");
	НастроитьЭлементыФормы();
	
КонецПроцедуры

Процедура ПослеВосстановленияЗначений()
	
	НастроитьЭлементыФормы();
	
КонецПроцедуры

Процедура ОшибкиПослеУдаления(Элемент)
	
	НастроитьЭлементыФормы();

КонецПроцедуры

Процедура ИгнорируемыеСигнатурыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда 
		Элемент.ТекущиеДанные.Пометка = Истина;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОшибкиПередНачаломДобавления(Элемент, Отказ, Копирование)
	
	Отказ = Истина;
	
КонецПроцедуры

Процедура ПриЗакрытии()

	ирКлиент.Форма_ПриЗакрытииЛкс(ЭтаФорма);

КонецПроцедуры

Процедура ДействияФормыПараметрыЗаписи(Кнопка)
	
	ирКлиент.ОткрытьОбщиеПараметрыЗаписиЛкс();
	
КонецПроцедуры

Процедура ОшибкиПриАктивизацииСтроки(Элемент)
	
	ирКлиент.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);

КонецПроцедуры

Процедура ИгнорируемыеСигнатурыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ирКлиент.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);

КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирКлиент.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирКлиент.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирКлиент.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура ПроверятьТолькоОшибочныеПриИзменении(Элемент)
	НастроитьЭлементыФормы();
КонецПроцедуры

Процедура КПОшибкиПеревыполнить(Кнопка)
	
	ВыполнитьТесты(Ошибки.Скопировать(ирКлиент.ВыделенныеСтрокиТабличногоПоляЛкс(ЭлементыФормы.Ошибки)).ВыгрузитьКолонку("Метаданные"));
	
КонецПроцедуры

Процедура КПОшибкиУдалитьИсправленные(Кнопка)
	
	Для Каждого Строка Из Ошибки.НайтиСтроки(Новый Структура("ОписаниеОшибки", "")) Цикл
		Ошибки.Удалить(Строка);
	КонецЦикла;
	
КонецПроцедуры

Процедура ДействияФормыПараметрЗапуска(Кнопка)
	
	ирОбщий.СообщитьЛкс(ирКлиент.ОписаниеПараметраЗапускаТестированияМетаданныхЛкс());
	
КонецПроцедуры

ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирТестированиеМетаданных.Форма.Форма");
мИменаОсновныхФорм = Новый Массив();
мИменаОсновныхФорм.Добавить("ОсновнаяФорма");
мИменаОсновныхФорм.Добавить("ОсновнаяФормаСписка");
мИменаОсновныхФорм.Добавить("ОсновнаяФормаДляВыбора");
мИменаОсновныхФорм.Добавить("ОсновнаяФормаДляВыбораГруппы");
мИменаОсновныхФорм.Добавить("ОсновнаяФормаОбъекта");
мИменаОсновныхФорм.Добавить("ОсновнаяФормаГруппы");
мИменаОсновныхФорм.Добавить("ОсновнаяФормаЗаписи");
мИменаОсновныхФорм.Добавить("ОсновнаяФормаНастроек");
мИменаОсновныхФорм.Добавить("ОсновнаяФормаСохранения");
мИменаОсновныхФорм.Добавить("ОсновнаяФормаЗагрузки");
мИменаОсновныхФорм.Добавить("ОсновнаяФормаКонстант");
мИменаОсновныхФорм.Добавить("ДополнительнаяФорма");
мИменаОсновныхФорм.Добавить("ДополнительнаяФормаСписка");
мИменаОсновныхФорм.Добавить("ДополнительнаяФормаДляВыбора");
мИменаОсновныхФорм.Добавить("ДополнительнаяФормаДляВыбораГруппы");
мИменаОсновныхФорм.Добавить("ДополнительнаяФормаОбъекта");
мИменаОсновныхФорм.Добавить("ДополнительнаяФормаГруппы");
мИменаОсновныхФорм.Добавить("ДополнительнаяФормаЗаписи");
мИменаОсновныхФорм.Добавить("ДополнительнаяФормаНастроек");
мИменаОсновныхФорм.Добавить("ДополнительнаяФормаСохранения");
мИменаОсновныхФорм.Добавить("ДополнительнаяФормаЗагрузки");
мИменаОсновныхФорм.Добавить("ДополнительнаяФормаКонстант");
мПлатформа = ирКэш.Получить();
ЭтотОбъект.ПроверятьОбъекты = Истина;
ЭтотОбъект.ПроверятьТолькоОшибочные = Истина;
