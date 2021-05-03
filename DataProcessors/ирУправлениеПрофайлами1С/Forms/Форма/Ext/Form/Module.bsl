﻿Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ирОбщий.Форма_ПриОткрытииЛкс(ЭтаФорма);
	СистемнаяИнформация = Новый СистемнаяИнформация;
	ЭтотОбъект.ПользовательОС = ирКэш.ТекущийПользовательОСЛкс();
	УстановитьПараметрыВыбраннойБазы();
	
КонецПроцедуры

Процедура УстановитьПараметрыВыбраннойБазы(Знач НастройкиБазыНаКлиенте = Неопределено)
	
	Если НастройкиБазыНаКлиенте = Неопределено Тогда
		НастройкиБазыНаКлиенте = ирКэш.НастройкиБазыНаКлиентеЛкс();
	КонецЕсли; 
	Если НастройкиБазыНаКлиенте = Неопределено Тогда
		ЭтотОбъект.ИдентификаторБазы = "?";
		ЭтотОбъект.КаталогКэшейБазы = Неопределено;
		ЭтотОбъект.КаталогБазы = Неопределено;
		Возврат;
	КонецЕсли; 
	#Если Сервер И Не Сервер Тогда
		НастройкиБазыНаКлиенте = Обработки.ирПлатформа.Создать().СписокБазПользователя.Добавить();
	#КонецЕсли
	ЭтотОбъект.ИдентификаторБазы = НастройкиБазыНаКлиенте.ID;
	ВыбранаТекущаяБаза = НастройкиБазыНаКлиенте.ID = ирКэш.НастройкиБазыНаКлиентеЛкс().ID;
	Если ВыбранаТекущаяБаза Тогда
		КлючомЯвляетсяСтрокаСоединения = Неопределено;
		КлючБазыВСпискеПользователя = ирОбщий.КлючБазыВСпискеПользователяЛкс(КлючомЯвляетсяСтрокаСоединения);
	Иначе
		КлючомЯвляетсяСтрокаСоединения = Не ирОбщий.ЛиИдентификацияБазыВСпискеПоНаименованиюЛкс();
	КонецЕсли; 
	Если Не КлючомЯвляетсяСтрокаСоединения Тогда
		ЭтотОбъект.База = НастройкиБазыНаКлиенте.Наименование;
	Иначе
		ЭтотОбъект.База = НастройкиБазыНаКлиенте.Connect;
	КонецЕсли; 
	ЭтотОбъект.КаталогКэшейБазы = НастройкиБазыНаКлиенте.КаталогКэша;
	ЭтотОбъект.КаталогБазы = НастройкиБазыНаКлиенте.КаталогНастроек;
	УстановитьПараметрыПользователя1С(ВыбранаТекущаяБаза);
	ОбновитьТаблицуФайлов();

КонецПроцедуры

Процедура УстановитьПараметрыПользователя1С(ВыбранаТекущаяБаза = Неопределено)
	
	Если ВыбранаТекущаяБаза = Истина Или База = ирОбщий.КлючБазыВСпискеПользователяЛкс() Тогда
		Если Не ЗначениеЗаполнено(ЭтотОбъект.Пользователь1С) Тогда
			ТекущийПользователь1С = ПользователиИнформационнойБазы.ТекущийПользователь();
			ЭтотОбъект.Пользователь1С = ТекущийПользователь1С.Имя;
		КонецЕсли; 
		ЭтотОбъект.ИдентификаторПользователя1С = ПользователиИнформационнойБазы.НайтиПоИмени(ЭтотОбъект.Пользователь1С).УникальныйИдентификатор;
		КаталогПеремещаемыхФайлов = ирКэш.КаталогИзданияПлатформыВПрофилеЛкс(Ложь);
		КаталогПеремещаемыхФайловБазы = КаталогПеремещаемыхФайлов + "\" + ИдентификаторБазы;
		ЭтотОбъект.КаталогПользователя1С = КаталогПеремещаемыхФайлов + "\" + ИдентификаторБазы + "\" + ИдентификаторПользователя1С;
	Иначе
		ЭтотОбъект.ИдентификаторПользователя1С = "?";
		ЭтотОбъект.Пользователь1С = Неопределено;
		ЭтотОбъект.КаталогПользователя1С = Неопределено;
	КонецЕсли;

КонецПроцедуры

Процедура ОбновитьТаблицуФайлов()
	
	СостояниеСтрокФайлы = ирОбщий.ТабличноеПолеСостояниеСтрокЛкс(ЭлементыФормы.Файлы, "КраткоеИмяФайла, ЛогическийПуть");
	Файлы.Очистить();
	ShellApplication = Новый COMobject("Shell.Application");
	КаталогПеремещаемыхФайлов = ирКэш.КаталогИзданияПлатформыВПрофилеЛкс(Ложь);
	КаталогПеремещаемыхФайловБазы = КаталогПеремещаемыхФайлов + "\" + ИдентификаторБазы;
	КаталогПеремещаемыхФайловПользователя1С = КаталогПеремещаемыхФайлов + "\" + ИдентификаторБазы + "\" + ИдентификаторПользователя1С;
	СтрокаФайла = Файлы.Добавить();
	СтрокаФайла.ЛогическийПуть = "$Local\$1Cv";
	СтрокаФайла.ПолноеИмяФайла = ShellApplication.Namespace(28).Self.Path + "\1C\1Cv8\appsrvrs.lst";
	СтрокаФайла.Описание = "Список центральных серверов 1С:Предприятия, зарегистрированных в утилите администрирования информационных баз в варианте клиент-сервер. Также содержит последний путь в дереве консоли.";
	СтрокаФайла = Файлы.Добавить();
	СтрокаФайла.ЛогическийПуть = "$Local\$1Cv";
	СтрокаФайла.ПолноеИмяФайла = ShellApplication.Namespace(28).Self.Path + "\1C\1Cv8\1cv8u.pfl";
	СтрокаФайла.Описание = "Какой то идентификатор клиента";
	СтрокаФайла = Файлы.Добавить();
	СтрокаФайла.ЛогическийПуть = "$Roaming\$1CEStart";
	СтрокаФайла.ПолноеИмяФайла = ShellApplication.Namespace(26).Self.Path + "\1C\1CEStart\ibases.v8i";
	СтрокаФайла.Описание = "Список баз.";
	СтрокаФайла = Файлы.Добавить();
	СтрокаФайла.ЛогическийПуть = "$Roaming\$1Cv";
	СтрокаФайла.ПолноеИмяФайла = КаталогПеремещаемыхФайлов + "\" + "1Cv8.pfl";
	СтрокаФайла.Описание = "Настройки конфигуратора. Примеры. Открыто ли табло. Настройки текстового редактора. Настройки приложений сравнения/объединения текстов.";
	СтрокаФайла = Файлы.Добавить();
	СтрокаФайла.ЛогическийПуть = "$Roaming\$1Cv";
	СтрокаФайла.ПолноеИмяФайла = КаталогПеремещаемыхФайлов + "\" + "1Cv8c.pfl";
	СтрокаФайла.Описание = "Настройки тонкого клиента.";
	СтрокаФайла = Файлы.Добавить();
	СтрокаФайла.ЛогическийПуть = "$Roaming\$1Cv";
	СтрокаФайла.ПолноеИмяФайла = КаталогПеремещаемыхФайлов + "\" + "1Cv8conn.pfl";
	СтрокаФайла.Описание = "Файлы клиентских настроек, информация о резервных кластерах и другая служебная информация.";
	СтрокаФайла = Файлы.Добавить();
	СтрокаФайла.ЛогическийПуть = "$Roaming\$1Cv";
	СтрокаФайла.ПолноеИмяФайла = КаталогПеремещаемыхФайлов + "\" + "1Cv8cmn.pfl";
	СтрокаФайла.Описание = "Настройки конфигуратора. Примеры. Расположение окон. Цвета редактора модулей. Расположение и состав панелей инструментов и меню. Список последних открытых файлов. Имя файла шаблонов.";
	СтрокаФайла = Файлы.Добавить();
	СтрокаФайла.ЛогическийПуть = "$Roaming\$1Cv";
	СтрокаФайла.ПолноеИмяФайла = КаталогПеремещаемыхФайлов + "\" + "1Cv8u.pfl";
	СтрокаФайла.Описание = "От содержимого этого файла зависит свойство СистемнаяИнформация.ИдентификаторКлиента";
	СтрокаФайла = Файлы.Добавить();
	СтрокаФайла.ЛогическийПуть = "$Roaming\$1Cv";
	СтрокаФайла.ПолноеИмяФайла = КаталогПеремещаемыхФайлов + "\" + "1Cv8strt.pfl";
	СтрокаФайла.Описание = "Параметры диалога выбора базы. Примеры. Размеры и расположение диалога запуска. Настройки диалогов установки параметров информационных баз.";
	СтрокаФайла = Файлы.Добавить();
	СтрокаФайла.ЛогическийПуть = "$Roaming\$1Cv";
	СтрокаФайла.ПолноеИмяФайла = КаталогПеремещаемыхФайлов + "\" + "1Cv8prim.pfl";
	СтрокаФайла.Описание = "Настройки клиент-серверного режима.";
	СтрокаФайла = Файлы.Добавить();
	СтрокаФайла.ЛогическийПуть = "$Roaming\$1Cv\$База";
	СтрокаФайла.ПолноеИмяФайла = КаталогПеремещаемыхФайловБазы + "\" + "1Cv8.pfl";
	СтрокаФайла.Описание = "Настройки конфигуратора. Примеры. Настройки сравнения файлов. Настройки глобального поиска по текстам конфигурации. Настройки отладки.";
	СтрокаФайла = Файлы.Добавить();
	СтрокаФайла.ЛогическийПуть = "$Roaming\$1Cv\$База";
	СтрокаФайла.ПолноеИмяФайла = КаталогПеремещаемыхФайловБазы + "\" + "1Cv8c.pfl";
	СтрокаФайла.Описание = "Настройки клиентского приложения. Примеры. Привязка окна заставки к монитору.";
	СтрокаФайла = Файлы.Добавить();
	СтрокаФайла.ЛогическийПуть = "$Roaming\$1Cv\$База";
	СтрокаФайла.ПолноеИмяФайла = КаталогПеремещаемыхФайловБазы + "\" + "def.usr";
	СтрокаФайла.Описание = "Последнее имя входа в базу";
	СтрокаФайла = Файлы.Добавить();
	СтрокаФайла.ЛогическийПуть = "$Roaming\$1Cv\$База\$Пользователь1С";
	СтрокаФайла.ПолноеИмяФайла = КаталогПеремещаемыхФайловПользователя1С + "\" + "1Cv8.pfl";
	СтрокаФайла.Описание = "Настройки конфигуратора. Примеры. Параметры подключения к хранилищу конфигурации. Расположение окна синтакс-помощника. Настройки окна табло. Список последних вычисленных выражений.";
	СтрокаФайла = Файлы.Добавить();
	СтрокаФайла.ЛогическийПуть = "$Roaming\$1Cv\$База\$Пользователь1С";
	СтрокаФайла.ПолноеИмяФайла = КаталогПеремещаемыхФайловПользователя1С + "\" + "1Cv8c.pfl";
	СтрокаФайла.Описание = "Настройки тонкого клиента";
	СтрокаФайла = Файлы.Добавить();
	СтрокаФайла.ЛогическийПуть = "$Roaming\$1Cv\$База\$Пользователь1С";
	СтрокаФайла.ПолноеИмяФайла = КаталогПеремещаемыхФайловПользователя1С + "\" + "1Cv8ccmn.pfl";
	СтрокаФайла.Описание = "Настройки клиентского приложения";
	
	// http://forum.infostart.ru/forum86/topic59725/message1344689/#message1344689
	СтрокаФайла = Файлы.Добавить();
	СтрокаФайла.ЛогическийПуть = "$Roaming\$1Cv\$База\$Пользователь1С";
	СтрокаФайла.ПолноеИмяФайла = КаталогПеремещаемыхФайловПользователя1С + "\" + "1Cv8cmn.pfl";
	СтрокаФайла.Описание = "Настройки клиентского приложения. Примеры. Расположение окон. Расположение и состав панелей инструментов и меню. Список последних открытых файлов.";
	
	Для Каждого СтрокаФайла Из Файлы Цикл
		Файл = Новый Файл(СтрокаФайла.ПолноеИмяФайла);
		СтрокаФайла.КраткоеИмяФайла = Файл.Имя;
		Если СтрокаФайла.ЛогическийПуть = "$Local\$1Cv" Тогда
			СтрокаФайла.ПринадлежностьДанных = "Пользователь ОС";
		ИначеЕсли СтрокаФайла.ЛогическийПуть = "$Roaming\$1Cv" Тогда
			СтрокаФайла.ПринадлежностьДанных = "Пользователь ОС";
		ИначеЕсли СтрокаФайла.ЛогическийПуть = "$Roaming\$1CEStart" Тогда
			СтрокаФайла.ПринадлежностьДанных = "Пользователь ОС";
		ИначеЕсли СтрокаФайла.ЛогическийПуть = "$Roaming\$1Cv\$База" Тогда
			СтрокаФайла.ПринадлежностьДанных = "Пользователь ОС, база";
		ИначеЕсли СтрокаФайла.ЛогическийПуть = "$Roaming\$1Cv\$База\$Пользователь1С" Тогда
			СтрокаФайла.ПринадлежностьДанных = "Пользователь ОС, база, пользователь 1С";
			Если Истина
				И База <> ирОбщий.КлючБазыВСпискеПользователяЛкс()
				И Не ЗначениеЗаполнено(Пользователь1С) 
			Тогда
				Продолжить;
			КонецЕсли; 
		КонецЕсли; 
		СтрокаФайла.ФайлСуществует = Файл.Существует(); // Возвращет Истина для путей с "?"
		Если СтрокаФайла.ФайлСуществует Тогда
			СтрокаФайла.ДатаИзменения = Файл.ПолучитьВремяИзменения();
			СтрокаФайла.РазмерБайт = Файл.Размер();
		КонецЕсли; 
	КонецЦикла;
	Файлы.Сортировать("ЛогическийПуть, КраткоеИмяФайла");
	ирОбщий.ТабличноеПолеВосстановитьСостояниеСтрокЛкс(ЭлементыФормы.Файлы, СостояниеСтрокФайлы);
	
КонецПроцедуры

Процедура СборкиПлатформыВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ирОбщий.ОткрытьФайлВПроводникеЛкс(ВыбраннаяСтрока.ПолноеИмяФайла);
	
КонецПроцедуры

Процедура КПФайлыОбновить(Кнопка)
	
	ОбновитьТаблицуФайлов();
	
КонецПроцедуры

Процедура КПФайлыОткрытьФайл(Кнопка)
	
	Если ЭлементыФормы.Файлы.ТекущаяСтрока <> Неопределено Тогда
		ЗапуститьПриложение(ЭлементыФормы.Файлы.ТекущаяСтрока.ПолноеИмяФайла);
	КонецЕсли; 
	
КонецПроцедуры

Процедура КПФайлыНайтиВПроводнике(Кнопка)
	
	Если ЭлементыФормы.Файлы.ТекущаяСтрока <> Неопределено Тогда
		ирОбщий.ОткрытьФайлВПроводникеЛкс(ЭлементыФормы.Файлы.ТекущаяСтрока.ПолноеИмяФайла);
	КонецЕсли; 

КонецПроцедуры

Процедура КПФайлыУдалитьФайлы(Кнопка)
	
	ПомеченныеСтроки = Файлы.НайтиСтроки(Новый Структура("Пометка", Истина));
	Если ПомеченныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	Ответ = Вопрос("Закройте все клиентские процессы 1С текущего пользователя ОС, использующие файл. Затем нажмите ОК.", РежимДиалогаВопрос.ОКОтмена);
	Если Ответ = КодВозвратаДиалога.ОК Тогда
		Для Каждого ПомеченнаяСтрока Из ПомеченныеСтроки Цикл
			ИмяФайла = ЭлементыФормы.Файлы.ТекущаяСтрока.ПолноеИмяФайла;
			Файл = Новый Файл(ИмяФайла);
			Если Файл.Существует() Тогда
				УдалитьФайлы(Файл.ПолноеИмя);
			КонецЕсли; 
		КонецЦикла;
		ОбновитьТаблицуФайлов();
		Ответ = Вопрос("Текущий сеанс будет перезапущен без сохранения настроек. Иначе удаленные файлы могут восстановиться.", РежимДиалогаВопрос.ОКОтмена);
		Если Ответ = КодВозвратаДиалога.ОК Тогда
			ПрекратитьРаботуСистемы(Истина, ирОбщий.ПараметрыЗапускаСеансаТекущиеЛкс());
		КонецЕсли; 
	КонецЕсли;
	
КонецПроцедуры

Процедура ДействияФормыИТС(Кнопка)
	
	ЗапуститьПриложение("https://its.1c.ru/db/metod8dev/content/1591/hdoc/_top/1cv8.pfl");

КонецПроцедуры

Процедура ДействияФормыВыгрузитьФайлы(Кнопка)
	
	РезультатВыбора = ирОбщий.ВыбратьФайлЛкс(Ложь, "zip", "Архив файлов настроек клиента 1С");
	Если РезультатВыбора <> Неопределено Тогда
		ВременныйКаталог = ПолучитьИмяВременногоФайла();
		СоздатьКаталог(ВременныйКаталог);
		Для Каждого ПомеченнаяСтрока Из Файлы.НайтиСтроки(Новый Структура("Пометка", Истина)) Цикл
			ИмяФайлаПриемника = ВременныйКаталог + "\" + ПомеченнаяСтрока.ЛогическийПуть;
			СоздатьКаталог(ИмяФайлаПриемника);
			ФайлСтроки = Новый Файл(ПомеченнаяСтрока.ПолноеИмяФайла);
			Если Не ФайлСтроки.Существует() Тогда
				Продолжить;
			КонецЕсли; 
			КопироватьФайл(ПомеченнаяСтрока.ПолноеИмяФайла, ИмяФайлаПриемника + "\" + ПомеченнаяСтрока.КраткоеИмяФайла);
		КонецЦикла;
		Архив = Новый ЗаписьZipФайла(РезультатВыбора);
		Архив.Добавить(ВременныйКаталог + "\*.*", РежимСохраненияПутейZIP.СохранятьОтносительныеПути, РежимОбработкиПодкаталоговZIP.ОбрабатыватьРекурсивно);
		Архив.Записать();
		УдалитьФайлы(ВременныйКаталог);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДействияФормыЗагрузитьФайлы(Кнопка)

	РезультатВыбора = ирОбщий.ВыбратьФайлЛкс(Истина, "zip", "Архив файлов настроек клиента 1С");
	Если РезультатВыбора <> Неопределено Тогда
		Архив = Новый ЧтениеZipФайла(РезультатВыбора);
		Для Каждого СтрокаФайла Из Файлы Цикл
			СтрокаФайла.Пометка = Ложь;
		КонецЦикла;
		ЕстьНастройкиКонфигуратора = Ложь;
		Для Каждого ЭлементАрхива Из Архив.Элементы Цикл
			СтрокаФайла = НайтиЛогическиеФайлыЭлементаАрхива(ЭлементАрхива);
			Если СтрокаФайла.Количество() > 0 Тогда
				СтрокаФайла = СтрокаФайла[0];
				СтрокаФайла.Пометка = Истина;
				Если Найти(СтрокаФайла.Описание, "конфигуратор") > 0 Тогда
					ЕстьНастройкиКонфигуратора = Истина;
				КонецЕсли; 
			Иначе
				ирОбщий.СообщитьЛкс("Файлу настроек " + ЭлементАрхива.ПолноеИмя + " из архива не найдено сопоставление");
			КонецЕсли; 
		КонецЦикла;
		Если ЕстьНастройкиКонфигуратора Тогда
			Ответ = Вопрос("Перед загрузкой настроек конфигуратора необходимо закрыть все конфигураторы под текущим пользователем ОС. Продолжить?", РежимДиалогаВопрос.ОКОтмена);
			Если Ответ <> КодВозвратаДиалога.ОК Тогда
				Возврат;
			КонецЕсли;
		КонецЕсли; 
		Ответ = Вопрос("Будут заменены " + Файлы.НайтиСтроки(Новый Структура("Пометка", Истина)).Количество() + " файлов настроек (обозначены пометками). Продолжить?", РежимДиалогаВопрос.ОКОтмена);
		Если Ответ <> КодВозвратаДиалога.ОК Тогда
			Возврат;
		КонецЕсли;
		ВременныйКаталог = ПолучитьИмяВременногоФайла();
		СоздатьКаталог(ВременныйКаталог);
		Архив.ИзвлечьВсе(ВременныйКаталог);
		Для Каждого ЭлементАрхива Из Архив.Элементы Цикл
			СтрокаФайла = НайтиЛогическиеФайлыЭлементаАрхива(ЭлементАрхива);
			Если СтрокаФайла.Количество() > 0 Тогда
				СтрокаФайла = СтрокаФайла[0];
				КопироватьФайл(ВременныйКаталог + "\" + ЭлементАрхива.Путь + ЭлементАрхива.Имя, СтрокаФайла.ПолноеИмяФайла);
			КонецЕсли; 
		КонецЦикла;
		УдалитьФайлы(ВременныйКаталог);
		ОбновитьТаблицуФайлов();
	КонецЕсли; 
	
КонецПроцедуры

Функция НайтиЛогическиеФайлыЭлементаАрхива(ЭлементАрхива)
	
	#Если Сервер И Не Сервер Тогда
		ЭлементАрхива = Новый ЧтениеZipФайла;
		ЭлементАрхива = ЭлементАрхива.Элементы.Получить();
	#КонецЕсли
	ЛогическийПуть = СтрЗаменить(ирОбщий.СтрокаБезКонцаЛкс(ЭлементАрхива.Путь, 1), "/", "\");
	СтрокаФайла = Файлы.НайтиСтроки(Новый Структура("ЛогическийПуть, КраткоеИмяФайла", ЛогическийПуть, ЭлементАрхива.Имя));
	Возврат СтрокаФайла;

КонецФункции

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	ирОбщий.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 
	
КонецПроцедуры

Процедура КПФайлыВсеНастройкиКонфигуратора(Кнопка)
	
	Для Каждого СтрокаФайла Из Файлы Цикл
		СтрокаФайла.Пометка = Ложь;
	КонецЦикла;  
	Для Каждого СтрокаФайла Из Файлы Цикл
		Если Найти(СтрокаФайла.Описание, "конфигуратор") > 0 Тогда
			СтрокаФайла.Пометка = Истина;
		КонецЕсли; 
	КонецЦикла;  
	
КонецПроцедуры

Процедура ИдентификаторБазыНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	мПлатформа = ирКэш.Получить();
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	ФормаВыбора = мПлатформа.ПолучитьФорму("СписокБазПользователяОС");
	ФормаВыбора.РежимВыбора = Истина;
	ФормаВыбора.НачальноеЗначениеВыбора = Элемент.Значение;
	РезультатВыбора = ФормаВыбора.ОткрытьМодально();
	Если РезультатВыбора <> Неопределено Тогда
		УстановитьПараметрыВыбраннойБазы(РезультатВыбора);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ИдентификаторПользователя1СНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	Если База <> ирОбщий.КлючБазыВСпискеПользователяЛкс() Тогда
		Возврат;
	КонецЕсли; 
	ФормаВыбора = ирОбщий.ПолучитьФормуЛкс("Обработка.ирРедакторПользователей.Форма",, Элемент);
	ФормаВыбора.РежимВыбора = Истина;
	ФормаВыбора.НачальноеЗначениеВыбора = Элемент.Значение;
	РезультатВыбора = ФормаВыбора.ОткрытьМодально();
	Если РезультатВыбора <> Неопределено Тогда
		ЭтотОбъект.Пользователь1С = РезультатВыбора;
		УстановитьПараметрыПользователя1С();
		ОбновитьТаблицуФайлов();
	КонецЕсли; 
	
КонецПроцедуры

Процедура КаталогКэшейБазыОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗапуститьПриложение(Элемент.Значение);
	
КонецПроцедуры

Процедура КаталогБазыОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗапуститьПриложение(Элемент.Значение);

КонецПроцедуры

Процедура КаталогПользователя1СОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗапуститьПриложение(Элемент.Значение);

КонецПроцедуры

Процедура ФайлыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	Если ДанныеСтроки.Пометка Тогда
		ОформлениеСтроки.ЦветФона = WebЦвета.СветлоЖелтыйЗолотистый;
	КонецЕсли; 
	// Пометками обозначаются и файлы перед загрузкой
	//Если Не ЗначениеЗаполнено(ДанныеСтроки.ДатаИзменения) Тогда
	//	ОформлениеСтроки.Ячейки.Пометка.ТолькоПросмотр = Истина;
	//КонецЕсли; 
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
	
КонецПроцедуры

Процедура ФайлыПриИзмененииФлажка(Элемент, Колонка)
	
	ирОбщий.ТабличноеПолеПриИзмененииФлажкаЛкс(ЭтаФорма, Элемент, Колонка);

КонецПроцедуры

Процедура ФайлыПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);

КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирОбщий.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);

КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирУправлениеПрофайлами1С.Форма.Форма");
