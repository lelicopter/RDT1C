﻿Перем БазоваяФорма;

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	Если СписокИнструментов.Количество() = 0 Тогда
		ПрочитатьСписокИнструментов();
	КонецЕсли; 
	Если РасположениеПанелиЗапуска <= 0 ИЛИ РасположениеПанелиЗапуска > 4 Тогда
		РасположениеПанелиЗапуска = 3;
	КонецЕсли;
	Если ОпределениеСерверногоВремени <= 0 ИЛИ ОпределениеСерверногоВремени > 3 Тогда
		ОпределениеСерверногоВремени = 1;
	КонецЕсли;
	ЭлементыФормы.ЗапускатьПриСтарте.Доступность = ирКэш.ЛиПортативныйРежимЛкс();
	Если ЭлементыФормы.ЗапускатьПриСтарте.Доступность Тогда
		ЭтаФорма.ЗапускатьПриСтарте = ОпределитьФлагЗапускаПриСтарте();
	КонецЕсли; 
	ЭтаФорма.ИмяФайлаНастроек = ПолучитьПолноеИмяФайлаНастроек();
	мПлатформа = ирКэш.Получить();
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	ЭтаФорма.НеИспользоватьУправляемыеФормыИнструментов = мПлатформа.НеИспользоватьУправляемыеФормыИнструментов;
	ЭтаФорма.АвторегистрацияComКомпонент = мПлатформа.АвторегистрацияComКомпонент;
	ЭтаФорма.ИспользоватьЭмуляциюНажатияКлавиш = мПлатформа.ИспользоватьЭмуляциюНажатияКлавиш(Истина);
	ЭтаФорма.ВыделениеРезультатовПоиска = мПлатформа.ВыделениеРезультатовПоиска;
	ЭтаФорма.ПерехватКлавиатурногоВводаВОбычномПриложении = ирКлиент.ЛиПерехватКлавиатурногоВводаВОбычномПриложенииЛкс();
	Если Не ирКэш.ЛиПортативныйРежимЛкс() Тогда
		ЭтаФорма.КаталогОбъектовДляОтладки = ирОбщий.ВосстановитьЗначениеЛкс("КаталогОбъектовДляОтладки");
	КонецЕсли; 
	Если ирКэш.ЛиЭтоРасширениеКонфигурацииЛкс() Тогда
		ЭтаФорма.ДобавлятьРольИРВсемАдминистраторам = ирОбщий.ВосстановитьЗначениеЛкс("ДобавлятьРольИРВсемАдминистраторам", Истина) = Истина;
	КонецЕсли; 
	ЭтаФорма.ПроверятьПодпискиКонфигурации = ирОбщий.ВосстановитьЗначениеЛкс("ПроверятьПодпискиКонфигурации", Истина) <> Ложь;
	ЭлементыФормы.КаталогОбъектовДляОтладки.Доступность = Не ирКэш.ЛиПортативныйРежимЛкс();
	//ЭлементыФормы.СписокИнструментов.ОтборСтрок.Синоним.Использование = Истина;
	ЭлементыФормы.СписокИнструментов.ОтборСтрок.Синоним.ВидСравнения = ВидСравнения.Содержит;
	ЭлементыФормы.НеИспользоватьУправляемыеФормыИнструментов.Видимость = Не ирКэш.ЛиПортативныйРежимЛкс();
	
КонецПроцедуры

Процедура ОбновитьТекстОпределениеСерверногоВремени()
	
	Если ОпределениеСерверногоВремени = 1 Тогда 		
		ОпределениеСерверногоВремениСтрокой = "(Время клиента)"; 		
	ИначеЕсли ОпределениеСерверногоВремени = 2 Тогда    		
		ОпределениеСерверногоВремениСтрокой = "(Оперативная отметка времени)";  		
	ИначеЕсли ОпределениеСерверногоВремени = 3 Тогда    		
		ОпределениеСерверногоВремениСтрокой = "(Время сервера строки подключения с помощью скрипта)";  		
	КонецЕсли; 
	
КонецПроцедуры 

Процедура ОбновлениеОтображения()
	ОбновитьТекстОпределениеСерверногоВремени();
КонецПроцедуры
      
Процедура ОсновныеДействияФормыСохранитьНастройки(Кнопка = Неопределено)
	
	мПлатформа = ирКэш.Получить();
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	мПлатформа.АвторегистрацияComКомпонент = ЭтаФорма.АвторегистрацияComКомпонент;
	мПлатформа.ИспользоватьЭмуляциюНажатияКлавиш = ЭтаФорма.ИспользоватьЭмуляциюНажатияКлавиш;
	мПлатформа.ВыделениеРезультатовПоиска = ЭтаФорма.ВыделениеРезультатовПоиска;
	мПлатформа.ПерехватКлавиатурногоВводаВОбычномПриложении = ПерехватКлавиатурногоВводаВОбычномПриложении;
	мПлатформа.НеИспользоватьУправляемыеФормыИнструментов = НеИспользоватьУправляемыеФормыИнструментов;
	мПлатформа.ПодключитьПерехватКлавиатуры();
	мПлатформа.СохранитьОбщиеНастройки();
	ирОбщий.СохранитьЗначениеЛкс("ПроверятьПодпискиКонфигурации", ЭтаФорма.ПроверятьПодпискиКонфигурации, Истина); // Для всех пользователей!
	Если Не ирКэш.ЛиПортативныйРежимЛкс() Тогда
		ирОбщий.СохранитьЗначениеЛкс("КаталогОбъектовДляОтладки", ЭтаФорма.КаталогОбъектовДляОтладки);
	КонецЕсли; 
	Если ирКэш.ЛиЭтоРасширениеКонфигурацииЛкс() Тогда
		ирОбщий.СохранитьЗначениеЛкс("ДобавлятьРольИРВсемАдминистраторам", ЭтаФорма.ДобавлятьРольИРВсемАдминистраторам, Истина);
	КонецЕсли; 
	ЗаписатьНастройки();
	Если ЭлементыФормы.ЗапускатьПриСтарте.Доступность Тогда
		// запишем путь к обработке для автозапуска в файл *.v8i
		СохранитьПараметрыАвтозапуска(ЗапускатьПриСтарте);
	КонецЕсли;
	ЭтаФорма.Модифицированность = Ложь;
	Закрыть(Истина);
	
КонецПроцедуры
  
Процедура ОпределениеСерверногоВремениОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

// запишем путь к обработке для автозапуска в файл *.v8i
Процедура СохранитьПараметрыАвтозапуска(ЗапускатьПриСтарте)
	
	// имя этого файла
	Попытка
		ИмяФайлаОбработки = ЭтотОбъект.ИспользуемоеИмяФайла;
	Исключение
		ИмяФайлаОбработки = "";
	КонецПопытки; 
	ДеревоСписка = ПолучитьДеревоINIFile();
	Если ДеревоСписка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	// определим, какая база в этом списке наша
	СтрокаСоединения = НРег(СтрокаСоединенияИнформационнойБазы());
	Отбор = Новый Структура("ЗначениеПараметра", СтрокаСоединения);
	СтрокиДерева = ДеревоСписка.Строки.НайтиСтроки(Отбор);
	Если СтрокиДерева.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	// изменим значение
	ПараметрНайден = Ложь;
	СтрокаДерева = СтрокиДерева[0];
	МаркерНачала = "/Execute""";
	МаркерКонца = """";
	Для Каждого Параметр Из СтрокаДерева.Строки Цикл
		ИмяПараметра = Параметр.ИмяПараметра;
		Если ИмяПараметра <> "AdditionalParameters" Тогда
			Продолжить;
		КонецЕсли;
		НовоеЗначениеПараметра = "";
		СтараяСтрокаЗапуска = ирОбщий.СтрокаМеждуМаркерамиЛкс(Параметр.ЗначениеПараметра, МаркерНачала, МаркерКонца, Ложь, Истина);
		Если ЗапускатьПриСтарте Тогда
			НовоеЗначениеПараметра = МаркерНачала + ИмяФайлаОбработки + МаркерКонца;
		КонецЕсли;
		Если ЗначениеЗаполнено(СтараяСтрокаЗапуска) Тогда
			НовоеЗначениеПараметра = ирОбщий.СтрЗаменитьЛкс(Параметр.ЗначениеПараметра, СтараяСтрокаЗапуска, НовоеЗначениеПараметра);
		ИначеЕсли ЗначениеЗаполнено(Параметр.ЗначениеПараметра) Тогда  
			НовоеЗначениеПараметра = Параметр.ЗначениеПараметра + " " + НовоеЗначениеПараметра;
		КонецЕсли; 
		Параметр.ЗначениеПараметра = НовоеЗначениеПараметра;
		ПараметрНайден = Истина;
		Прервать;
	КонецЦикла;
	// если параметра не было - надо добавить
	Если НЕ ПараметрНайден И ЗапускатьПриСтарте Тогда
		Параметр = СтрокаДерева.Строки.Добавить();
		Параметр.ИмяПараметра = "AdditionalParameters";
		Параметр.ЗначениеПараметра = МаркерНачала + ИмяФайлаОбработки + МаркерКонца;
	КонецЕсли;
	// сохраним дерево назад в файлик
	СохранитьДеревоINIFile(ДеревоСписка);
	
КонецПроцедуры	

// определение значения флага запуска при старте
Функция ОпределитьФлагЗапускаПриСтарте() 
	
	ЗначениеФлага = Ложь;
	ТекущийМодульАвтозапуска = "";
	
	// имя этого файла
	Попытка
		ИмяФайлаОбработки = ЭтотОбъект.ИспользуемоеИмяФайла;
	Исключение
		ИмяФайлаОбработки = "";
	КонецПопытки; 
	
	// получим структуру списка баз
	ДеревоСписка = ПолучитьДеревоINIFile();
	Если ДеревоСписка = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// определим, какая база в этом списке наша
	СтрокаСоединения = НРег(СтрокаСоединенияИнформационнойБазы());
	Отбор = Новый Структура("ЗначениеПараметра", СтрокаСоединения);
	СтрокиДерева = ДеревоСписка.Строки.НайтиСтроки(Отбор);
	Если СтрокиДерева.Количество() = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	МаркерИР = НРег("ирПортативный.epf");
	СтрокаДерева = СтрокиДерева[0];
	Для Каждого Параметр Из СтрокаДерева.Строки Цикл
		ИмяПараметра = Параметр.ИмяПараметра;
		Если ИмяПараметра <> "AdditionalParameters" Тогда
			Продолжить;
		КонецЕсли;
		ИмяфайлаЗапуска = ирОбщий.СтрокаМеждуМаркерамиЛкс(Параметр.ЗначениеПараметра, "/Execute""", """");
		Если Найти(НРег(ИмяфайлаЗапуска), МаркерИР) > 0 Тогда
			ЗначениеФлага = Истина;
			ТекущийМодульАвтозапуска = ИмяфайлаЗапуска;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ЗначениеФлага;
	
КонецФункции

// получение дерева из INI-файла
Функция ПолучитьДеревоINIFile()
	
	мИмяФайлаСписка = ирОбщий.ИмяФайлаСпискаИнфобазПользователяОСЛкс();
	// открываем файл в кодировке UTF8
	мФайлСписка = Новый ЧтениеТекста;
	Попытка
		мФайлСписка.Открыть(мИмяФайлаСписка, КодировкаТекста.UTF8);
	Исключение
		Сообщить("Не удалось открыть файл "+мИмяФайлаСписка);
		Возврат Неопределено;
	КонецПопытки;
	
	// подготовим результирующее дерево
	ДеревоСписка = Новый ДеревоЗначений;
	ДеревоСписка.Колонки.Добавить("ИмяПараметра");
	ДеревоСписка.Колонки.Добавить("ЗначениеПараметра");
	Разделитель 		= "=";
	СтрокаДерева		= Неопределено;
	// читаем файл
	ТекущаяСтрока = мФайлСписка.ПрочитатьСтроку();
	Пока ТекущаяСтрока <> Неопределено Цикл
		ТекущаяСтрока = СокрЛП(ТекущаяСтрока);
		Если НЕ ЗначениеЗаполнено(ТекущаяСтрока) Тогда
			ТекущаяСтрока = мФайлСписка.ПрочитатьСтроку();
			Продолжить;
		КонецЕсли;
		ПервыйСимвол = Лев(ТекущаяСтрока,1);
		// начало раздела
		Если ПервыйСимвол = "[" Тогда
			СтрокаДерева = ДеревоСписка.Строки.Добавить();
			ИмяБазы = Сред(ТекущаяСтрока, 2);
			ИмяБазы = Лев(ИмяБазы, СтрДлина(СокрП(ИмяБазы)) - 1);
			СтрокаДерева.ИмяПараметра = ИмяБазы;
			ТекущаяСтрока = мФайлСписка.ПрочитатьСтроку();
		Иначе
			ПозицияРазделителя 	= Найти(ТекущаяСтрока,Разделитель);
			ИмяПараметра 		= Лев(ТекущаяСтрока,ПозицияРазделителя-1);
			ЗначениеПараметра 	= Сред(ТекущаяСтрока,ПозицияРазделителя+1);
			СтрокаПараметра		= СтрокаДерева.Строки.Добавить();
			СтрокаПараметра.ИмяПараметра 		= ИмяПараметра;
			СтрокаПараметра.ЗначениеПараметра 	= ЗначениеПараметра;
			
			// пропишем отдельно в таблице строку соединения базы
			Если ИмяПараметра = "Connect" Тогда
				ЗначениеПараметра = СокрЛП(ЗначениеПараметра);
				Если Прав(ЗначениеПараметра, 1) <> ";" Тогда
					ЗначениеПараметра = ЗначениеПараметра + ";";
				КонецЕсли; 
				СтрокаДерева.ЗначениеПараметра = Нрег(ЗначениеПараметра);
			КонецЕсли;
			ТекущаяСтрока = мФайлСписка.ПрочитатьСтроку();
		КонецЕсли;
	КонецЦикла;
	Возврат ДеревоСписка;
	
КонецФункции	

// сохранение дерева в INI-файл
Процедура СохранитьДеревоINIFile(ДеревоСписка)
	
	мИмяФайлаСписка = ирОбщий.ИмяФайлаСпискаИнфобазПользователяОСЛкс();
	// открываем файл в кодировке UTF8
	мФайлСписка = Новый ЗаписьТекста;
	Попытка
		мФайлСписка.Открыть(мИмяФайлаСписка, КодировкаТекста.UTF8);
	Исключение
		Сообщить("Не удалось открыть файл "+мИмяФайлаСписка);
		Возврат;
	КонецПопытки;
	Для Каждого СтрокаДерева Из ДеревоСписка.Строки Цикл
		СтрокаФайла = "["+СтрокаДерева.ИмяПараметра+"]";
		мФайлСписка.ЗаписатьСтроку(СтрокаФайла);
		Для Каждого Параметр Из СтрокаДерева.Строки Цикл
			СтрокаФайла = ""+Параметр.ИмяПараметра+"="+Параметр.ЗначениеПараметра;
			мФайлСписка.ЗаписатьСтроку(СтрокаФайла);
		КонецЦикла;
	КонецЦикла;
	мФайлСписка.Закрыть();
	
КонецПроцедуры

// выбор како-либо обработки для открытия
Процедура ТаблицаОбъектовВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если Колонка = ЭлементыФормы.СписокИнструментов.Колонки.Описание Тогда
		ЗапуститьПриложение("http://" + ирОбщий.АдресОсновногоСайтаЛкс() + "/" + ВыбраннаяСтрока.Описание);
	Иначе
		ОткрытьТекущийИнструмент();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОткрытьТекущийИнструмент(ВосстанливатьНастройкуФормы = Истина)
	
	ТекущиеДанные = ЭлементыФормы.СписокИнструментов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ПолноеИмя = ТекущиеДанные.ПолноеИмя;
	Если ПолноеИмя <> "Разделитель" Тогда
		Если МодальныйРежим Тогда
			Ответ = Вопрос("Хотите применить изменения, закрыть форму настроек и открыть инструмент немодально?", РежимДиалогаВопрос.ДаНет);
			Если Ответ = КодВозвратаДиалога.Да Тогда
				ОсновныеДействияФормыСохранитьНастройки();
			КонецЕсли;
		КонецЕсли; 
		Если БазоваяФорма = Неопределено Тогда
			БазоваяФорма = ирКлиент.ПолучитьФормуЛкс("Обработка.ирПортативный.Форма.Форма");
		КонецЕсли; 
		БазоваяФорма.ОткрытьИнструмент(ЭлементыФормы.СписокИнструментов.ТекущиеДанные);
	КонецЕсли;

КонецПроцедуры

Процедура КоманднаяПанельСписокОбработокУстановитьФлажки(Кнопка)
	ирКлиент.ИзменитьПометкиВыделенныхИлиОтобранныхСтрокЛкс(ЭтаФорма, ЭлементыФормы.СписокИнструментов, "Видимость", Истина,,, Истина);
КонецПроцедуры

Процедура КоманднаяПанельСписокОбработокСнятьФлажки(Кнопка)
	ирКлиент.ИзменитьПометкиВыделенныхИлиОтобранныхСтрокЛкс(ЭтаФорма, ЭлементыФормы.СписокИнструментов, "Видимость", Ложь,,, Истина);
КонецПроцедуры

// восстановление стандартных настроек для списка обработок
Процедура КоманднаяПанельСписокОбработокВосстановитьСтандартныеНастройки(Кнопка)
	
	ЗаполнитьСписокИнструментовСтандартныеНастройки();
	
КонецПроцедуры

Процедура СписокИнструментовПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ирКлиент.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
	ОформлениеСтроки.Ячейки.Автозапуск.ТолькоПросмотр = ДанныеСтроки.ПолноеИмя = "ирКлиент.ОткрытьОтладчикЛкс";
	Если ДанныеСтроки.ПолноеИмя = "Разделитель" Тогда
		ОформлениеСтроки.Ячейки.Видимость.ТолькоПросмотр = Истина;
		ОформлениеСтроки.Ячейки.Автозапуск.ТолькоПросмотр = Истина;
	Иначе
		Если ЗначениеЗаполнено(ДанныеСтроки.ИмяКартинки) Тогда
			ОформлениеСтроки.Ячейки.Синоним.УстановитьКартинку(ирКэш.КартинкаПоИмениЛкс(ДанныеСтроки.ИмяКартинки));
		КонецЕсли; 
		Если ЗначениеЗаполнено(ДанныеСтроки.Описание) Тогда
			ОформлениеСтроки.Ячейки.Описание.УстановитьТекст("описание");
		КонецЕсли; 
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	ирКлиент.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура КоманднаяПанельСписокОбработокОткрыть(Кнопка)
	
	ОткрытьТекущийИнструмент();

КонецПроцедуры

Процедура ФильтрЗначениеОчистка(Элемент, СтандартнаяОбработка)
	
	ЭлементыФормы.СписокИнструментов.ОтборСтрок.Синоним.Значение = "";
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

Процедура ФильтрЗначениеНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_ОбновитьСписокЛкс(Элемент, ЭтаФорма);

КонецПроцедуры

Процедура ФильтрЗначениеПриИзменении(Элемент)
	
	ирКлиент.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
	ЭлементыФормы.СписокИнструментов.ОтборСтрок.Синоним.Использование = Истина;

КонецПроцедуры

Процедура ПриОткрытии()
	
	ирКлиент.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ЭлементыФормы.НадписьКлиентСерверногоЗапуска.Видимость = Истина
		И ирКэш.ЛиПортативныйРежимЛкс()
		И Не ирКэш.ЛиФайловаяБазаЛкс()
		И Не ирОбщий.ЭтоИмяЛокальногоКомпьютераЛкс(ирОбщий.ИмяКомпьютераКластераЛкс())
		И Лев(ЭтотОбъект.ИспользуемоеИмяФайла, 2) <> "\\";
	ЭлементыФормы.ДобавлятьРольИРВсемАдминистраторам.Видимость = ирКэш.ЛиЭтоРасширениеКонфигурацииЛкс();
	ЭлементыФормы.СписокИнструментов.Колонки.Видимость.Видимость = ирКэш.ЛиПортативныйРежимЛкс() Или ирКэш.ЛиЭтоРасширениеКонфигурацииЛкс();
	ЭлементыФормы.СписокИнструментов.Колонки.Автозапуск.Видимость = ирКэш.ЛиПортативныйРежимЛкс();
	ЭлементыФормы.КоманднаяПанельСписокОбработок.Кнопки.СнятьФлажки.Доступность = ЭлементыФормы.СписокИнструментов.Колонки.Видимость.Видимость;
	ЭлементыФормы.КоманднаяПанельСписокОбработок.Кнопки.УстановитьФлажки.Доступность = ЭлементыФормы.СписокИнструментов.Колонки.Видимость.Видимость;
	
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирКлиент.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОсновныеДействияФормыСтруктураФормы(Кнопка)
	
	ирКлиент.ОткрытьСтруктуруФормыЛкс(ЭтаФорма);

КонецПроцедуры

Процедура КоманднаяПанельСписокОбработокПоискПоТекстамИнтерфейса(Кнопка)
	
	Форма = ирКэш.Получить().ПолучитьФорму("СтруктураФормы",, "ВсеИнструменты");
	Форма.Открыть();
	ирКлиент.УстановитьПрикреплениеФормыВУправляемомПриложенииЛкс(Форма);
	
КонецПроцедуры

Процедура КаталогОбъектовДляОтладкиНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ирКлиент.ВыбратьКаталогВФормеЛкс(КаталогОбъектовДляОтладки, ЭтаФорма, "Выберите каталог объектов для отладки");
	
КонецПроцедуры

Процедура Надпись4Нажатие(Элемент)
	
	ЗапуститьПриложение("http://" + ирОбщий.АдресОсновногоСайтаЛкс() + "/index/funkcii_dlja_otladki/0-33");
	
КонецПроцедуры

Процедура СписокИнструментовПриАктивизацииСтроки(Элемент)
	
	ирКлиент.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);

КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирКлиент.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ПерехватКлавиатурногоВводаПодробнееНажатие(Элемент)
	
	ЗапуститьПриложение("https://www.hostedredmine.com/issues/891475");
	
КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирКлиент.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура ОбщиеПараметрыЗаписиНажатие(Элемент)
	
	ирКлиент.ОткрытьОбщиеПараметрыЗаписиЛкс();
	
КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирКлиент.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ФильтрЗначениеАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	
	ЭлементыФормы.СписокИнструментов.ОтборСтрок.Синоним.Использование = Истина;
	ирКлиент.ПромежуточноеОбновлениеСтроковогоЗначенияПоляВводаЛкс(ЭтаФорма, Элемент, Текст);
	
КонецПроцедуры

Процедура СписокИнструментовПриИзмененииФлажка(Элемент, Колонка)
	
	ирКлиент.ТабличноеПолеПриИзмененииФлажкаЛкс(ЭтаФорма, Элемент, Колонка);
	
КонецПроцедуры

Процедура ПриЗакрытии()
	ирКлиент.Форма_ПриЗакрытииЛкс(ЭтаФорма);
КонецПроцедуры

Процедура ВыделениеРезультатовПоискаПодробнееНажатие(Элемент)
	ЗапуститьПриложение("https://www.hostedredmine.com/issues/950166");
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Ответ = ирКлиент.ЗапроситьСохранениеДанныхФормыЛкс(ЭтаФорма, Отказ);
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ОсновныеДействияФормыСохранитьНастройки();
	КонецЕсли; 
	
КонецПроцедуры

ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирПортативный.Форма.ФормаНастроек");

// Антибаг платформы. Очищаются свойство данные, если оно указывает на отбор табличной части
ЭлементыФормы.ФильтрЗначение.Данные = "ЭлементыФормы.СписокИнструментов.Отбор.Синоним.Значение";
ЭлементыФормы.ФильтрЗначение.КнопкаВыбора = Ложь;
ЭлементыФормы.ФильтрЗначение.КнопкаСпискаВыбора = Истина;
