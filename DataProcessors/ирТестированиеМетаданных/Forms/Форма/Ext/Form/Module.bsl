﻿Перем мНепустыеЗначения;
Перем мИменаОсновныхФорм;
Перем мПлатформа;

Функция ДобавитьСтрокуРезультата(ИмяОперации, Знач пИнформацияОбОшибке, ГлубинаОшибки = 0) Экспорт
	
	#Если _ Тогда
	    пИнформацияОбОшибке = ИнформацияОбОшибке();
	#КонецЕсли
	Если ГлубинаОшибки = 1 Тогда
		Если пИнформацияОбОшибке.Причина.Причина = Неопределено Тогда
			Возврат Неопределено;
		Иначе
			пИнформацияОбОшибке = пИнформацияОбОшибке.Причина;
		КонецЕсли; 
	КонецЕсли; 
	СтрокаРезультатов = Результаты.Добавить();
	СтрокаРезультатов.Операция = ИмяОперации;
	ОписаниеОшибки = пИнформацияОбОшибке.Описание;
	Если пИнформацияОбОшибке.Причина <> Неопределено Тогда
		ОписаниеОшибки = ОписаниеОшибки + ": " + ПодробноеПредставлениеОшибки(пИнформацияОбОшибке.Причина);
	КонецЕсли; 
	СтрокаРезультатов.ОписаниеОшибки = ОписаниеОшибки;
	СтрокаРезультатов.ИнформацияОбОшибке = пИнформацияОбОшибке;
	Размер = Размер + 1;
	Возврат СтрокаРезультатов;
	
КонецФункции

Функция Тестироватьформу(Форма, ИмяОперации = "") Экспорт

	Форма.Открыть(); // К сожалению здесь исключения не ловятся http://partners.v8.1c.ru/forum/thread.jsp?id=1080350#1080350
	Попытка
		Форма = Форма.мСвойстваФормы.КонечнаяФорма; // Для системы 2iS
	Исключение
	КонецПопытки;
	Если Форма.Открыта() Тогда
		Попытка
			ТестироватьЭлементыФормы(Форма);
		Исключение
			ОтменитьТранзакцию();
			ДобавитьСтрокуРезультата(ИмяОперации, ИнформацияОбОшибке());
			НачатьТранзакцию();
		КонецПопытки; 
		Форма.Модифицированность = Ложь;
		Попытка
			Форма.Закрыть();
		Исключение
			ОтменитьТранзакцию();
			ДобавитьСтрокуРезультата(ИмяОперации, ИнформацияОбОшибке());
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
	ИначеЕсли ТипЗнч(Форма) = Тип("УправляемаяФорма") Тогда
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
		//ЛксИнтерактивноЗаписатьВЭлементУправления(ПолеВвода, Неопределено);
		НепустоеЗначение = Неопределено;
		Если ПолеВвода.РежимВыбораИзСписка Тогда
			Если ПолеВвода.СписокВыбора.Количество() > 0 Тогда
				НепустоеЗначение = ПолеВвода.СписокВыбора[0].Значение;
			КонецЕсли; 
		Иначе
			НепустоеЗначение = ПолучитьНепустоеЗначениеПоОписаниюТипов(ПолеВвода.ТипЗначения);
		КонецЕсли; 
		//Если НепустоеЗначение <> Неопределено Тогда
			ДействиеНачалоВыбора = ПолеВвода.ПолучитьДействие("НачалоВыбора");
			Если ДействиеНачалоВыбора <> Неопределено Тогда
				// Здесь часто ограничивается множество выбора и потому высока вероятность установить некорректное с точки зрения смысла значение
			Иначе
				ЛксИнтерактивноЗаписатьВЭлементУправления(ПолеВвода, НепустоеЗначение);
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
		//ЛксИнтерактивноЗаписатьВЭлементУправления(ПолеВвода, Неопределено);
		НепустоеЗначение = Неопределено;
		//Если ПолеФормы.РежимВыбораИзСписка Тогда
			Если ПолеФормы.СписокВыбора.Количество() > 0 Тогда
				НепустоеЗначение = ПолеФормы.СписокВыбора[0].Значение;
			КонецЕсли; 
		//Иначе
		//	//НепустоеЗначение = ПолучитьНепустоеЗначениеПоОписаниюТипов(ПолеФормы.ТипЗначения); // Доделать!
		//КонецЕсли; 
		//Если НепустоеЗначение <> Неопределено Тогда
			ДействиеНачалоВыбора = Неопределено;
			//ДействиеНачалоВыбора = ПолеФормы.ПолучитьДействие("НачалоВыбора"); // Доделать!
			Если ДействиеНачалоВыбора <> Неопределено Тогда
				// Здесь часто ограничивается множество выбора и потому высока вероятность установить некорректное с точки зрения смысла значение
			Иначе
				ЛксИнтерактивноЗаписатьВЭлементУправления(ПолеФормы, НепустоеЗначение);
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
	
	КлючВременнойФормы = "шщваопщв";

	// общие формы
	Если ПроверятьНеосновныеФормы Тогда
		МетаФормы = Метаданные.ОбщиеФормы;
	Иначе
		МетаФормы = ПолучитьМетаФормыОбъектаДляПроверки(Метаданные);
	КонецЕсли;
	Индикатор = ЛксПолучитьИндикаторПроцесса(МетаФормы.Количество(), "Общие формы");
	Счетчик = 0;
	Для Каждого МетаФорма Из МетаФормы Цикл
		Счетчик = Счетчик + 1;
		Если Счетчик < 11 Тогда
			Продолжить;
		КонецЕсли; 
		ЛксОбработатьИндикатор(Индикатор);
		ИмяОперации = МетаФорма.ПолноеИмя();
		Если ВыводитьСообщения Тогда
			Сообщить(ИмяОперации);
		КонецЕсли; 
		НачатьТранзакцию();
		Попытка
			Форма = ПолучитьФорму(МетаФорма.ПолноеИмя());
			Если Форма = Неопределено Тогда
				ОтменитьТранзакцию(); //
				Продолжить;
			КонецЕсли; 
			Тестироватьформу(Форма, ИмяОперации);
		Исключение
			ДобавитьСтрокуРезультата(ИмяОперации, ИнформацияОбОшибке());
		КонецПопытки;
		ОтменитьТранзакцию();
	КонецЦикла;
	ЛксОсвободитьИндикаторПроцесса();
	
	// Формы подчиненные объектам метаданных
	ТипыМетаданных = ирКэш.Получить().ПолучитьТаблицуТиповМетаОбъектов(Истина, Ложь, Истина);
	ИндикаторТиповМетаданных = ЛксПолучитьИндикаторПроцесса(ТипыМетаданных.Количество(), "Формы. Типы метаданных");
	Для Каждого СтрокаТипаМетаданных Из ТипыМетаданных Цикл
		ЛксОбработатьИндикатор(ИндикаторТиповМетаданных);
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
				КоллекцияМетаОбъектов = НайтиФайлы(КаталогВнешнихМетаданных, "*.epf", Истина);
				КоллекцияМетаОбъектов1 = НайтиФайлы(КаталогВнешнихМетаданных, "*.erf", Истина);
				ЛксСкопироватьУниверсальнуюКоллекцию(КоллекцияМетаОбъектов1, КоллекцияМетаОбъектов);
			Иначе
				Продолжить;
			КонецЕсли; 
		Иначе
			//Продолжить; ////////////
			КоллекцияМетаОбъектов = Метаданные[СтрокаТипаМетаданных.Множественное];
		КонецЕсли; 
		Индикатор2 = ЛксПолучитьИндикаторПроцесса(КоллекцияМетаОбъектов.Количество(), СтрокаТипаМетаданных.Множественное);
		Для Каждого МетаОбъект Из КоллекцияМетаОбъектов Цикл
			ЛксОбработатьИндикатор(Индикатор2);
			Если ТипЗнч(МетаОбъект) = Тип("Файл") Тогда
				МенеджерВнешнихМетаданных = Вычислить(СтрокаТипаМетаданных.Множественное);
				Попытка
					ВнешнийОбъект = МенеджерВнешнихМетаданных.Создать(МетаОбъект.ПолноеИмя, Ложь);
				Исключение
					ОписаниеОшибки = ОписаниеОшибки();
					Если Найти(НРег(ОписаниеОшибки), НРег("не может быть прочитан")) = 0 Тогда
						ДобавитьСтрокуРезультата(ВнешнийОбъект.ИспользуемоеИмяФайла, ИнформацияОбОшибке());
					КонецЕсли; 
					Продолжить;
				КонецПопытки; 
				МетаОбъект = ВнешнийОбъект.Метаданные();
			Иначе
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
				МенеджерОбъектаМетаданных = ЛксПолучитьМенеджер(МетаОбъект);
			КонецЕсли; 
			Для Каждого МетаФорма Из МетаФормы Цикл
				ИмяОперации = МетаФорма.ПолноеИмя();
				Если ВнешнийОбъект <> Неопределено Тогда
					ИмяОперации = Сред(ВнешнийОбъект.ИспользуемоеИмяФайла, СтрДлина(КаталогВнешнихМетаданных) + 2) + "." + ИмяОперации;
				КонецЕсли; 
				Если ВыводитьСообщения Тогда
					Сообщить(ИмяОперации);
				КонецЕсли; 
				НачатьТранзакцию();
				Попытка
					Форма = ПолучитьНовуюФорму(МетаФорма, ВнешнийОбъект, КлючВременнойФормы);
					Если Форма = Неопределено Тогда
						ОтменитьТранзакцию();
						Продолжить;
					КонецЕсли;
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
						МенеджерТипаОбъектаФормы = ЛксПолучитьМенеджер(СсылкаОбъекта);
						Выборка = МенеджерТипаОбъектаФормы.Выбрать();
						Если ТипЗнч(Форма) = Тип("Форма") Тогда
							Если Выборка.Следующий() Тогда
								СсылочныйОбъект = Выборка.ПолучитьОбъект();
								СсылочныйОбъект = СсылочныйОбъект.Скопировать();
							Иначе
								СсылочныйОбъект = ирНеглобальный.СоздатьСсылочныйОбъектПоМетаданнымЛкс(МетаОбъект);
								ЗаполнитьРеквизитыНепустымиЗначениями(СсылочныйОбъект, МетаОбъект);
							КонецЕсли; 
							Если МенеджерТипаОбъектаФормы = МенеджерОбъектаМетаданных Тогда
								Форма = СсылочныйОбъект.ПолучитьФорму(МетаФорма.Имя, , КлючВременнойФормы);
							Иначе
								// Дольше но универсальнее
								Форма = ПолучитьНовуюФорму(МетаФорма, ВнешнийОбъект, КлючВременнойФормы);
								Форма[мПлатформа.ПолучитьИмяОсновногоРеквизитаФормы(Форма)] = СсылочныйОбъект;
							КонецЕсли; 							
						Иначе
							ПараметрыФормы = Новый Структура;
							Если Выборка.Следующий() Тогда
								ПараметрыФормы.Вставить("ЗначениеКопирования", Выборка.Ссылка);
							КонецЕсли; 
							Форма = ирНеглобальный.ПолучитьФормуЛкс(МетаФорма.ПолноеИмя(), ПараметрыФормы, , КлючВременнойФормы);
						КонецЕсли; 
					КонецЕсли;
					Тестироватьформу(Форма, ИмяОперации);
				Исключение
					ДобавитьСтрокуРезультата(ИмяОперации, ИнформацияОбОшибке());
				КонецПопытки;
				ОтменитьТранзакцию();
			КонецЦикла;
		КонецЦикла;
		ЛксОсвободитьИндикаторПроцесса();
	КонецЦикла;
	ЛксОсвободитьИндикаторПроцесса();
	
КонецФункции

Функция ПолучитьНовуюФорму(МетаФорма, ВнешнийОбъект = Неопределено, КлючВременнойФормы = Неопределено)

	Если ВнешнийОбъект <> Неопределено Тогда
		Форма = ВнешнийОбъект.ПолучитьФорму(МетаФорма.Имя, , КлючВременнойФормы);
	Иначе
		//Форма = МенеджерТипа.ПолучитьФорму(МетаФорма.Имя, , КлючВременнойФормы);
		Форма = ирНеглобальный.ПолучитьФормуЛкс(МетаФорма.ПолноеИмя(), , , КлючВременнойФормы);
	КонецЕсли; 
	Возврат Форма;

КонецФункции

Функция ГлобальныйТестОбъектов(НаСервере = Ложь) Экспорт
	
	ТипыМетаданных = ирКэш.Получить().ПолучитьТаблицуТиповМетаОбъектов(Истина, Ложь, Ложь);
	ИндикаторТиповМетаданных = ЛксПолучитьИндикаторПроцесса(ТипыМетаданных.Количество(), "Объекты. Типы метаданных");
	Для Каждого СтрокаТипаМетаданных Из ТипыМетаданных Цикл
		ЛксОбработатьИндикатор(ИндикаторТиповМетаданных);
		Если ЛксЛиКорневойТипРегистраБД(СтрокаТипаМетаданных.Единственное) Тогда
			Подтип = "НаборЗаписей";
		ИначеЕсли СтрокаТипаМетаданных.Единственное = "Константа" Тогда 
			Подтип = "МенеджерЗначения";
		Иначе //Если ЛксЛиКорневойТипСсылки(СтрокаТипаМетаданных.Единственное) Тогда
			Подтип = "Объект";
		КонецЕсли; 
		Если Ложь
			//Или СтрокаТипаМетаданных.Единственное = "ПланОбмена" // Временно. Антибаг платформы 8.2.16.352 http://partners.v8.1c.ru/forum/thread.jsp?id=1080147#1080147
			Или СтрокаТипаМетаданных.Единственное = "Перечисление"
		Тогда
			Продолжить;
		КонецЕсли; 
		КоллекцияМетаОбъектов = Метаданные[СтрокаТипаМетаданных.Множественное];
		Индикатор2 = ЛксПолучитьИндикаторПроцесса(КоллекцияМетаОбъектов.Количество(), СтрокаТипаМетаданных.Множественное);
		Для Каждого МетаОбъект Из КоллекцияМетаОбъектов Цикл
			ЛксОбработатьИндикатор(Индикатор2);
			ИмяОперации = МетаОбъект.ПолноеИмя() + ".Объект";
			ИмяТипаОбъекта = СтрЗаменить(МетаОбъект.ПолноеИмя(), ".", Подтип + ".");
			Попытка
				Объект = Новый (ИмяТипаОбъекта);
			Исключение
				ОписаниеОшибки = ИнформацияОбОшибке().Описание;
				Если Найти(ОписаниеОшибки, "Тип не определен") <> 1 Тогда
					ВызватьИсключение;
				Иначе
					Продолжить;
				КонецЕсли; 
			КонецПопытки; 
			Если ВыводитьСообщения Тогда
				Сообщить(ИмяОперации);
			КонецЕсли; 
			НачатьТранзакцию();
			Попытка
				Если Подтип = "Объект" Тогда
					МенеджерТипа = ЛксПолучитьМенеджер(МетаОбъект);
					Если ЛксЛиКорневойТипСсылки(СтрокаТипаМетаданных.Единственное) Тогда
						Выборка = МенеджерТипа.Выбрать();
						Если Выборка.Следующий() Тогда
							Объект = Выборка.ПолучитьОбъект();
							КопияОбъекта = Объект.Скопировать();
							ПроверитьСсылочныйОбъект(Объект, ИмяОперации, СтрокаТипаМетаданных.Единственное);
							ПроверитьСсылочныйОбъект(КопияОбъекта, ИмяОперации, СтрокаТипаМетаданных.Единственное);
						КонецЕсли; 
						Объект = ирНеглобальный.СоздатьСсылочныйОбъектПоМетаданнымЛкс(МетаОбъект);
						ЗаполнитьРеквизитыНепустымиЗначениями(Объект, МетаОбъект);
						Объект.Скопировать();
						ПроверитьСсылочныйОбъект(Объект, ИмяОперации, СтрокаТипаМетаданных.Единственное);
					КонецЕсли; 
				ИначеЕсли Подтип = "НаборЗаписей" Тогда
					МенеджерТипа = ЛксПолучитьМенеджер(МетаОбъект); // Создаем чисто для проверки компиляции модуля менеджера
					СтрокаНабора = Объект.Добавить();
					ЗаполнитьРеквизитыНепустымиЗначениями(СтрокаНабора, МетаОбъект);
					Попытка
						Объект.Записать(Ложь);
					Исключение
						ОтменитьТранзакцию();
						ДобавитьСтрокуРезультата(ИмяОперации, ИнформацияОбОшибке(), 1);
						НачатьТранзакцию();
					КонецПопытки;
				Иначе
					Попытка
						Объект.Записать();
					Исключение
						ОтменитьТранзакцию();
						ДобавитьСтрокуРезультата(ИмяОперации, ИнформацияОбОшибке(), 1);
						НачатьТранзакцию();
					КонецПопытки;
				КонецЕсли; 
			Исключение
				// Сюда попадаем при ошибках не при записи
				ДобавитьСтрокуРезультата(ИмяОперации, ИнформацияОбОшибке());
			КонецПопытки;
			ОтменитьТранзакцию();
		КонецЦикла;
		ЛксОсвободитьИндикаторПроцесса();
	КонецЦикла;
	ЛксОсвободитьИндикаторПроцесса();
	
КонецФункции

Функция ПроверитьСсылочныйОбъект(Объект, ИмяОперации, ТипМетаданных) Экспорт

	Попытка
		Объект.Записать();
	Исключение
		ОтменитьТранзакцию();
		ДобавитьСтрокуРезультата(ИмяОперации, ИнформацияОбОшибке(), 1);
		НачатьТранзакцию();
	КонецПопытки;
	//ФормаОбъекта = Объект.ПолучитьФорму();
	//ФормаОбъекта.ЗаписатьВФорме();
	Если ТипМетаданных = "Документ" Тогда
		Попытка
			Объект.Записать(РежимЗаписиДокумента.Проведение);
		Исключение
			ОтменитьТранзакцию();
			ДобавитьСтрокуРезультата(ИмяОперации, ИнформацияОбОшибке(), 1);
			НачатьТранзакцию();
		КонецПопытки;
		Попытка
			Объект.Проведен = Истина;
			Объект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
		Исключение
			ОтменитьТранзакцию();
			ДобавитьСтрокуРезультата(ИмяОперации, ИнформацияОбОшибке(), 1);
			НачатьТранзакцию();
		КонецПопытки;
	КонецЕсли; 

	Возврат Неопределено;

КонецФункции

Функция ЗаполнитьРеквизитыНепустымиЗначениями(Объект, ОбъектМД) Экспорт
	
	КомпоновщикТаблицы = ирКэш.ПолучитьКомпоновщикТаблицыМетаданныхЛкс(ОбъектМД.ПолноеИмя());;
	Для Каждого ДоступноеПоле Из КомпоновщикТаблицы.Настройки.ДоступныеПоляВыбора.Элементы Цикл
		Если ДоступноеПоле.Папка Тогда
			Продолжить;
		КонецЕсли;
		НепустоеЗначение = ПолучитьНепустоеЗначениеПоОписаниюТипов(ДоступноеПоле.Тип);
		ИмяПоля = "" + ДоступноеПоле.Поле;
		Попытка
			Объект[ИмяПоля] = НепустоеЗначение;
		Исключение
		КонецПопытки; 
	КонецЦикла; 
	
КонецФункции

Функция ПолучитьНепустоеЗначениеПоОписаниюТипов(ОписаниеТипов) Экспорт
	
	#Если _ Тогда
	    ОписаниеТипов = Новый ОписаниеТипов();
	#КонецЕсли
	Типы = ОписаниеТипов.Типы();
	Если Типы.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли; 
	Тип = Типы[0];
	НепустоеЗначение = мНепустыеЗначения[Тип];
	Если НепустоеЗначение <> Неопределено Тогда
	ИначеЕсли Перечисления.ТипВсеСсылки().СодержитТип(Тип) Тогда
		ОбъектМДТипа = Метаданные.НайтиПоТипу(Тип);
		НепустоеЗначение = Перечисления[ОбъектМДТипа.Имя][ОбъектМДТипа.ЗначенияПеречисления[0].Имя];
	Иначе
		МетаданныеТипа = Метаданные.НайтиПоТипу(Тип);
		Если МетаданныеТипа = Неопределено Тогда
			Попытка
				НепустоеЗначение = Новый (Тип);
			Исключение
			КонецПопытки; 
		Иначе
			МенеджерТипа = ЛксПолучитьМенеджер(МетаданныеТипа);
			Выборка = МенеджерТипа.Выбрать();
			Пока Выборка.Следующий() Цикл
				Попытка
					ЭтоГруппа = Выборка.ЭтоГруппа;
				Исключение
					ЭтоГруппа = Ложь;
				КонецПопытки; 
				Если Не ЭтоГруппа Тогда
					НепустоеЗначение = Выборка.Ссылка;
					Прервать;
				КонецЕсли;  
			КонецЦикла; 
			Если НепустоеЗначение = Неопределено Тогда
				Массив = Новый Массив();
				Массив.Добавить(Новый УникальныйИдентификатор());
				НепустоеЗначение = Новый (Тип, Массив);
			КонецЕсли; 
		КонецЕсли; 
		мНепустыеЗначения[Тип] = НепустоеЗначение;
	КонецЕсли;
	Возврат НепустоеЗначение;
	
КонецФункции

Процедура КнопкаВыполнитьНажатие(Кнопка)
	
	Результаты.Очистить();
	Размер = 0;
	Если ПроверятьОбъекты Тогда
		ГлобальныйТестОбъектов();
	КонецЕсли; 
	Если ПроверятьФормы Тогда
		ГлобальныйТестФорм();
	КонецЕсли; 
	
КонецПроцедуры

Процедура РезультатыВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ПоказатьИнформациюОбОшибке(ВыбраннаяСтрока.ИнформацияОбОшибке);
	
КонецПроцедуры

Процедура ОсновныеДействияФормыОПодсистеме(Кнопка)
	
	ЛксОткрытьСправкуПоПодсистеме(ЭтотОбъект);

КонецПроцедуры

Процедура КаталогВнешнихМетаданныхНачалоВыбора(Элемент, СтандартнаяОбработка)

	ирНеглобальный.ПолеФайловогоКаталога_НачалоВыбораЛкс(Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура КаталогВнешнихМетаданныхНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)

	ирНеглобальный.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, Метаданные().Имя);
	
КонецПроцедуры

Процедура КаталогВнешнихМетаданныхПриИзменении(Элемент)

	ирНеглобальный.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, Метаданные().Имя);
	
КонецПроцедуры

Процедура ПроверятьЭлементыФормПриИзменении(Элемент)
	
	Если ЭтотОбъект.ПроверятьЭлементыФорм Тогда
		ЭтотОбъект.ПроверятьФормы = Истина;
	КонецЕсли; 
	
КонецПроцедуры

мНепустыеЗначения = Новый Соответствие();
мНепустыеЗначения.Вставить(Тип("Дата"), Дата(2000,1,1));
мНепустыеЗначения.Вставить(Тип("Число"), 1);
мНепустыеЗначения.Вставить(Тип("Строка"), "а");
мНепустыеЗначения.Вставить(Тип("Булево"), Истина);
мНепустыеЗначения.Вставить(Тип("ХранилищеЗначения"), Новый ХранилищеЗначения(Новый Структура));
мНепустыеЗначения.Вставить(Тип("ОписаниеТипов"), Новый ОписаниеТипов);
мНепустыеЗначения.Вставить(Тип("УникальныйИдентификатор"), Новый УникальныйИдентификатор());
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
ЭтотОбъект.ПроверятьФормы = Истина;
Результаты.Колонки.Добавить("ИнформацияОбОшибке");
//ФормаВыбораМетаданных = мПлатформа.ПолучитьФорму("ВыборОбъектаМетаданных", ЭлементыФормы.ДеревоМетаданных, ЭтаФорма);
//лСтруктураПараметров = Новый Структура;
//лСтруктураПараметров.Вставить("ОтображатьРегистры", Истина);
//лСтруктураПараметров.Вставить("ОтображатьСсылочныеОбъекты", Истина);
//лСтруктураПараметров.Вставить("ОтображатьВыборочныеТаблицы", Истина);
//лСтруктураПараметров.Вставить("МножественныйВыбор", Истина);
//ФормаВыбораМетаданных.НачальноеЗначениеВыбора = лСтруктураПараметров;
//ФормаВыбораМетаданных.ОткрытьМодально();   
