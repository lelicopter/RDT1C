﻿
// Признак изменение пароля пользователя БД
Перем мМенялиПароль;

// Переменная хранит обладает ли пользователь правами администрирования или нет
Перем мЕстьПраваАдминистрирования;

Перем мЗакрытиеФормыИнициированоПользователем;

Перем мФормаМодифицирована;

Процедура мСообщитьОбОшибке(Текст)
	
	Сообщить(Текст, СтатусСообщения.Внимание);
	
КонецПроцедуры

// Процедура устанавливает доступность элементов формы, в зависимости от режима "Аутентификации" 
Процедура УстановитьДоступностьАутентификаций()
	
	ЭлементыФормы.Пароль.Доступность              			= АутентификацияСтандартная;
	ЭлементыФормы.НадписьПарольПользователяБД.Доступность 	= АутентификацияСтандартная;

	ЭлементыФормы.ПодтверждениеПароля.Доступность 			= АутентификацияСтандартная;
	ЭлементыФормы.НадписьПодтверждениеПароляБД.Доступность	= АутентификацияСтандартная;

	ЭлементыФормы.ПользовательОС.Доступность 				= АутентификацияОС;
	ЭлементыФормы.НадписьПользовательОС.Доступность 		= АутентификацияОС;
	
КонецПроцедуры

// нажатие на ОК в форме пользователя БД
Процедура ОсновныеДействияФормыОК(Кнопка)
	
	РезультатЗаписи = ЗаписатьПользователя();
	
	Если РезультатЗаписи = Истина Тогда
		
		мЗакрытиеФормыИнициированоПользователем = Истина;
		ЭтаФорма.Закрыть(Истина);	
		
	КонецЕсли;
	
КонецПроцедуры

// отмена
Процедура ОсновныеДействияФормыОтмена(Кнопка)
	
	мЗакрытиеФормыИнициированоПользователем = Истина;
	ЭтаФорма.Закрыть(Ложь);
	
КонецПроцедуры


// Процедура заполняет информацию о пользователе БД
Процедура ОбновитьДанныеПользователяБД(ПользовательНастроек, Знач ОтображатьИмя = Истина)
	
	Если ПользовательНастроек = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ОтображатьИмя Тогда
		
		Имя = ПользовательНастроек.Имя;
		ПолноеИмя = ПользовательНастроек.ПолноеИмя;
		
	КонецЕсли;
	
	Язык = ПользовательНастроек.Язык;
	ОсновнойИнтерфейс = ПользовательНастроек.ОсновнойИнтерфейс;
	
	АутентификацияСтандартная = ПользовательНастроек.АутентификацияСтандартная;
	мМенялиПароль = Ложь;
	
	Если ПользовательНастроек.ПарольУстановлен Тогда
		Пароль = "************";
		ПодтверждениеПароля = "************";
	Иначе
		Пароль = "";
		ПодтверждениеПароля = "";
	КонецЕсли; 

	Попытка
		ПользовательОС = ПользовательНастроек.ПользовательОС;
	Исключение
		ПользовательОС = "<Неверные данные>";
	КонецПопытки; 

 	ПоказыватьВСпискеВыбора = ПользовательНастроек.ПоказыватьВСпискеВыбора;
	АутентификацияОС = ПользовательНастроек.АутентификацияОС;
	
	Для Каждого СтрокаСпискаДоступныхРолей Из СписокДоступныхРолейПользователяБД Цикл
		СтрокаСпискаДоступныхРолей.Пометка = ПользовательНастроек.Роли.Содержит(СтрокаСпискаДоступныхРолей.Значение);
	КонецЦикла; 
	
	УстановитьДоступностьАутентификаций();
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ ДЛЯ РАБОТЫ С ИНФОРМАЦИЕЙ О ПОЛЬЗОВАТЕЛЕ БД

// Процедура - обработчик "При изменении" АутентификацияСтандартная
Процедура АутентификацияСтандартнаяПриИзменении(Элемент)
	
	УстановитьДоступностьАутентификаций();
	
КонецПроцедуры

// Процедура - обработчик "При изменении" АутентификацияОС
Процедура АутентификацияОСПриИзменении(Элемент)
	
	УстановитьДоступностьАутентификаций();
	
КонецПроцедуры

// Процедура - обработчик "При изменении" Пароль
Процедура ПарольПриИзменении(Элемент)
	
	мМенялиПароль = Истина;
	
КонецПроцедуры

// Процедура - обработчик "При изменении" ПодтверждениеПароля
Процедура ПодтверждениеПароляПриИзменении(Элемент)
	
	мМенялиПароль = Истина;
	
КонецПроцедуры



// Процедура заполняет списки выбора атрибутов для пользователя БД
Процедура ИнициализироватьЭлементыРедактированияПользователяБД()
	
	//Язык
	СписокВыбораЯзыка = ЭлементыФормы.Язык.СписокВыбора;
	Для Каждого мЯзык Из Метаданные.Языки Цикл
		СписокВыбораЯзыка.Добавить(мЯзык, мЯзык.Синоним);
	КонецЦикла; 
			
	//Интерфейс
	СписокВыбораИнтерфейса = ЭлементыФормы.ОсновнойИнтерфейс.СписокВыбора;
	Для Каждого мИнтерфейс Из Метаданные.Интерфейсы Цикл
		СписокВыбораИнтерфейса.Добавить(мИнтерфейс, мИнтерфейс.Синоним);
	КонецЦикла; 

	//Роль
	Для Каждого мРоль Из Метаданные.Роли Цикл
		СтрокаСпискаДоступныхРолей = СписокДоступныхРолейПользователяБД.Добавить();
		СтрокаСпискаДоступныхРолей.Представление = мРоль.Представление();
		СтрокаСпискаДоступныхРолей.Значение = мРоль;
	КонецЦикла; 
	
КонецПроцедуры

// Процедура выполняет запись пользователя ИБ
Функция ЗаписатьПользователя()
	
	Если ПользовательБД = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Имя = СокрЛП(Имя);
	
	Если НЕ ЗначениеЗаполнено(Имя) Тогда
		
		мСообщитьОбОшибке("Не заполнено имя пользователя базы данных!");
		Возврат Ложь;
		
	КонецЕсли;
	
	//проверим что бы было указано то что нужно
	Если АутентификацияОС
		И ПустаяСтрока(ПользовательОС) Тогда
		
		мСообщитьОбОшибке("Укажите пользователя Windows или запретите Windows-аутентификацию!");
		Возврат Ложь;
		
	КонецЕсли;
	
	ПользовательБД.Имя = Имя;
	ПользовательБД.ПолноеИмя = ПолноеИмя;
	ПользовательБД.ПользовательОС = ПользовательОС;
	Если мМенялиПароль = Истина Тогда
		
		Если Пароль <> ПодтверждениеПароля Тогда
			мСообщитьОбОшибке("Пароль и подтверждение пароля не совпадают!!!"); 
			Возврат Ложь;
		КонецЕсли;
			
		ПользовательБД.Пароль = Пароль;
		
	КонецЕсли; 
	
	ПользовательБД.АутентификацияСтандартная = АутентификацияСтандартная;
	ПользовательБД.ПоказыватьВСпискеВыбора = ПоказыватьВСпискеВыбора;
	ПользовательБД.АутентификацияОС = АутентификацияОС;
	ПользовательБД.Язык = Язык;
	ПользовательБД.ОсновнойИнтерфейс = ОсновнойИнтерфейс;
	
	// Роли сохраняем
	Для Каждого СтрокаСпискаДоступныхРолей Из СписокДоступныхРолейПользователяБД Цикл
		
		мРоль = СтрокаСпискаДоступныхРолей.Значение;
		СодержитРоль = ПользовательБД.Роли.Содержит(мРоль);
		Если СодержитРоль И Не СтрокаСпискаДоступныхРолей.Пометка Тогда
			ПользовательБД.Роли.Удалить(мРоль);
		ИначеЕсли Не СодержитРоль И СтрокаСпискаДоступныхРолей.Пометка Тогда
			ПользовательБД.Роли.Добавить(мРоль);
		КонецЕсли; 
	
	КонецЦикла;
	
	// запись пользователя БД
	Попытка
		
		ПользовательБД.Записать();
		
	Исключение
		
		мСообщитьОбОшибке("Ошибка при сохранении данных пользователя инфобазы. " + ОписаниеОшибки());
		Возврат Ложь;
				
	КонецПопытки;
	
	// удачно записан пользователь БД
	Оповестить("ИзмененПользовательБД", ПользовательБД, ЭтаФорма); 
	
	Возврат Истина;
		
КонецФункции

//Процедура - обаботчик события, при нажатии на кнопку "Снять флажки" Командной панели "КоманднаяПанельСпискаДоступныхРолей"
Процедура КоманднаяПанельСпискаДоступныхРолейСнятьФлажки(Кнопка)
	
	СписокДоступныхРолейПользователяБД.ЗаполнитьЗначения(0, "Пометка");
	
КонецПроцедуры

//Процедура - обаботчик события, при нажатии на кнопку "Установить флажки" Командной панели "КоманднаяПанельСпискаДоступныхРолей"
Процедура КоманднаяПанельСпискаДоступныхРолейУстановитьФлажки(Кнопка)
	
	СписокДоступныхРолейПользователяБД.ЗаполнитьЗначения(1, "Пометка");
	
КонецПроцедуры

//Процедура - обработчик события "НачалоВыбора" в: Поле ввода "Язык"
Процедура ЯзыкНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	СписокВыбора = Элемент.СписокВыбора.Скопировать();
	РезультатВыбора = СписокВыбора.ВыбратьЭлемент("Выберите язык", Элемент.Значение);
	Если РезультатВыбора <> Неопределено Тогда
		Элемент.Значение = РезультатВыбора.Значение;
	КонецЕсли; 
	
КонецПроцедуры

//Процедура - обработчик события "НачалоВыбора" в: Поле ввода "ОсновнойИнтерфейс"
Процедура ОсновнойИнтерфейсНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	СписокВыбора = Элемент.СписокВыбора.Скопировать();
	РезультатВыбора = СписокВыбора.ВыбратьЭлемент("Выберите основной интерфейс", Элемент.Значение);
	Если РезультатВыбора <> Неопределено Тогда
		Элемент.Значение = РезультатВыбора.Значение;
	КонецЕсли; 
	
КонецПроцедуры

//Процедура - обработчик события "НачалоВыбора" в: Поле ввода "ПользовательОС"
Процедура ПользовательОСНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ФормаВыбораПользователяWindows = ПолучитьФорму("ВыборПользователяWindows", , ЭтаФорма);
	ФормаВыбораПользователяWindows.ВыбранныйПользовательWindows = ПользовательОС;
	Результат = ФормаВыбораПользователяWindows.ОткрытьМодально();
	Если Результат <> Неопределено Тогда
		ПользовательОС = Результат;
	КонецЕсли; 
	
КонецПроцедуры

//Процедура - обаботчик события, "При изменении" у имени пользователя БД
Процедура ИмяПриИзменении(Элемент)
	
	Элемент.Значение = СокрЛП(Имя);
	
	// полное имя пользователя БД тоже ставим если оно пустое
	Если НЕ ЗначениеЗаполнено(ПолноеИмя) Тогда
		ПолноеИмя = Элемент.Значение
	КонецЕсли;
	
КонецПроцедуры

// перед открытием
Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	ИнициализироватьЭлементыРедактированияПользователяБД();
	
	Если ПользовательДляКопированияНастроек = Неопределено Тогда
		ОбновитьДанныеПользователяБД(ПользовательБД);
	Иначе
		ОбновитьДанныеПользователяБД(ПользовательДляКопированияНастроек, Ложь);
	КонецЕсли;
	
	ТолькоПросмотр = НЕ мЕстьПраваАдминистрирования;
	
	мФормаМодифицирована = Модифицированность;
		
КонецПроцедуры

// перед закрытием
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если мЗакрытиеФормыИнициированоПользователем Тогда
		
		мЗакрытиеФормыИнициированоПользователем = Ложь;
		Возврат;
		
	КонецЕсли;
	
	// форму принудительно пытаются закрыть	
	Если Модифицированность Тогда
		
		// есть права на изменение пользователя БД
		ОтветПользователя = Вопрос("Настройки пользователя БД были изменены. Сохранить?", РежимДиалогаВопрос.ДаНетОтмена, ,
			КодВозвратаДиалога.Да);
			
		Если ОтветПользователя = КодВозвратаДиалога.Да Тогда
			
			// записываем внесенные изменения
			РезультатЗаписи = ЗаписатьПользователя();
			Отказ = Не РезультатЗаписи;
			
			Если Не Отказ Тогда
				мЗакрытиеФормыИнициированоПользователем = Истина;
				Закрыть(Истина);
			КонецЕсли;			
				
		ИначеЕсли ОтветПользователя = КодВозвратаДиалога.Нет Тогда	
			
			// ничего делать не надо
			
		Иначе	
			
			Отказ = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	Модифицированность = мФормаМодифицирована;
	
КонецПроцедуры

// копирование настроек пользователя БД
Процедура КоманднаяПанельОбщаяСкопироватьНастройки(Кнопка)
	
	СписокВыбора = Новый СписокЗначений;
	
	МассивПользователей = ПользователиИнформационнойБазы.ПолучитьПользователей();
	
	Для каждого ВремПользователь Из МассивПользователей Цикл
		
		СписокВыбора.Добавить(ВремПользователь.Имя);
								
	КонецЦикла; 
	
	СписокВыбора.СортироватьПоЗначению();
		
	ВыбранныйПользователь = СписокВыбора.ВыбратьЭлемент("Выберите пользователя, от которого копировать настройки", 
		СписокВыбора);
		
	Если ВыбранныйПользователь = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВыбранныйПользовательБД = ПользователиИнформационнойБазы.НайтиПоИмени(ВыбранныйПользователь.Значение);
	
	// настройки устанавливаются на форму
	ОбновитьДанныеПользователяБД(ВыбранныйПользовательБД, Ложь);
	
КонецПроцедуры

мЕстьПраваАдминистрирования = ПравоДоступа("Администрирование", Метаданные);

//Заполняем параметры пользователя БД
СписокДоступныхРолейПользователяБД.Колонки.Добавить("Значение");
мЗакрытиеФормыИнициированоПользователем = Ложь;
ПользовательДляКопированияНастроек = Неопределено;
