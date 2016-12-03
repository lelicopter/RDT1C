﻿&НаКлиенте
Процедура ЗапуститьОбычноеПриложение(Команда)
	
	#Если ВебКлиент Тогда
		Сообщить("Команда недоступна веб клиенте");
	#Иначе
		ПараметрыЗапуска = "";
		СтрокаСоединения = СтрокаСоединенияИнформационнойБазы();
		ПараметрыЗапуска = ПараметрыЗапуска + " ENTERPRISE";
		ПараметрыЗапуска = ПараметрыЗапуска + " /IBConnectionString""" + СтрЗаменить(СтрокаСоединения, """", """""") + """";
		ПараметрыЗапуска = ПараметрыЗапуска + " /RunModeOrdinaryApplication";
		ПараметрыЗапуска = ПараметрыЗапуска + " /Debug";
		ПараметрыЗапуска = ПараметрыЗапуска + " /UC""" + КодРазрешения + """";
		ИспользуемоеИмяФайла = ПолучитьИспользуемоеИмяФайла(ИмяКомпьютера());
		Если ЗначениеЗаполнено(ИспользуемоеИмяФайла) Тогда
			ПараметрыЗапуска = ПараметрыЗапуска + " /Execute""" + ИспользуемоеИмяФайла + """";
		КонецЕсли; 
		Если ТекущийПользователь Тогда
			ПараметрыЗапуска = ПараметрыЗапуска + " /N""" + ИмяПользователя() + """";
		КонецЕсли; 
		
		Если ПодключитьОтладчик Тогда
			ДвоичныеДанные = ПолучитьДвоичныеДанныеВК();
			ИмяВременногоФайла = ПолучитьИмяВременногоФайла("dll");
			ДвоичныеДанные.Записать(ИмяВременногоФайла);
			Результат = ПодключитьВнешнююКомпоненту(ИмяВременногоФайла, "ирОбщая", ТипВнешнейКомпоненты.Native);
			Если Не Результат Тогда
				ВызватьИсключение "Не удалось подключить внешнюю компоненту Общая"; 
			КонецЕсли; 
			ВК = Новый ("AddIn.ирОбщая.AddIn");
			ИдентификаторПроцессаОС = ВК.PID();
			ПараметрыЗапускаДляОтладки = ПараметрыЗапускаСеансаДляПодключенияКТекущемуОтладчику(ИдентификаторПроцессаОС);
			ПараметрыЗапуска = ПараметрыЗапуска + " " + ПараметрыЗапускаДляОтладки;
		КонецЕсли; 
		
		ЗапуститьПриложение(КаталогПрограммы() + "1cv8.exe " + ПараметрыЗапуска);
		Если ЗакрытьФорму Тогда
			Закрыть();
		КонецЕсли; 
	#КонецЕсли 
	
КонецПроцедуры

#Если Не ВебКлиент Тогда
&НаКлиенте
// р5яф67оыйи
Функция ПараметрыЗапускаСеансаДляПодключенияКТекущемуОтладчику(Знач ИдентификаторПроцессаОС)
	
	ПараметрыЗапускаДляОтладки = "";
	ТекущийПроцесс = ПолучитьCOMОбъект("winmgmts:{impersonationLevel=impersonate}!\\.\root\CIMV2:Win32_Process.Handle='" + XMLСтрока(ИдентификаторПроцессаОС) + "'");
	КоманднаяСтрокаПроцесса = ТекущийПроцесс.CommandLine;
	ПозицияСтрокиАдресаОтладчика = Найти(НРег(КоманднаяСтрокаПроцесса), Нрег("/DebuggerUrl"));
	Если ЗначениеЗаполнено(ПозицияСтрокиАдресаОтладчика) Тогда
		СтрокаОтладчика = Сред(КоманднаяСтрокаПроцесса, ПозицияСтрокиАдресаОтладчика);
		ПозицияПробела = Найти(СтрокаОтладчика, " ");
		Если ЗначениеЗаполнено(ПозицияПробела) Тогда
			СтрокаОтладчика = Лев(СтрокаОтладчика, ПозицияПробела);
		КонецЕсли; 
		ПараметрыЗапускаДляОтладки = ПараметрыЗапускаДляОтладки + " " + СтрокаОтладчика;
	КонецЕсли; 
	ПозицияСтрокиТипаОтладчика = Найти(НРег(КоманднаяСтрокаПроцесса), Нрег("/Debug "));
	Если ЗначениеЗаполнено(ПозицияСтрокиТипаОтладчика) Тогда
		СтрокаОтладчика = Сред(КоманднаяСтрокаПроцесса, ПозицияСтрокиТипаОтладчика);
		ПозицияПробела = Найти(СтрокаОтладчика, " -attach");
		Если ЗначениеЗаполнено(ПозицияПробела) Тогда
			СтрокаОтладчика = Лев(СтрокаОтладчика, ПозицияПробела) + " -attach";
		Иначе
			ПозицияПробела = Найти(СтрокаОтладчика, " ");
			Если ЗначениеЗаполнено(ПозицияПробела) Тогда
				СтрокаОтладчика = Лев(СтрокаОтладчика, ПозицияПробела);
			КонецЕсли; 
		КонецЕсли; 
	Иначе
		СтрокаОтладчика = "/Debug";
	КонецЕсли;
	ПараметрыЗапускаДляОтладки = ПараметрыЗапускаДляОтладки + " " + СтрокаОтладчика;
	Возврат ПараметрыЗапускаДляОтладки;

КонецФункции
#КонецЕсли 

Функция ПолучитьДвоичныеДанныеВК()
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	Возврат ОбработкаОбъект.ПолучитьМакет("ВК");
КонецФункции

Функция ПолучитьИспользуемоеИмяФайла(ИмяКомпьютера)
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	Попытка
		ИспользуемоеИмяФайла = ОбработкаОбъект.ИспользуемоеИмяФайла;
	Исключение
	КонецПопытки; 
	Возврат ИспользуемоеИмяФайла;
	
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭтаФорма.ПодключитьОтладчик = Истина;
	ЭтаФорма.ЗакрытьФорму = Истина;
	ЭтаФорма.ТекущийПользователь = Истина;
	Если Метаданные.Обработки.Найти("ирПлатформа") = Неопределено Тогда
		Элементы.Текст.Заголовок = "Работа портативных инструментов разработчика в режиме управляемого приложения не поддерживается";
	Иначе
		Элементы.Текст.Заголовок = "Работа инструмента в режиме тонкого клиента не поддерживается";
	КонецЕсли; 
	
КонецПроцедуры
