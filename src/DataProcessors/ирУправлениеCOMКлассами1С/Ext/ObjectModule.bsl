﻿//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирКлиент Экспорт;
Перем мИзданияПлатформы Экспорт;
Перем мПлатформа Экспорт;

Функция ВыполнитьРегистрацию() Экспорт

	//http://msdn.microsoft.com/en-us/library/windows/desktop/ms687653%28v=vs.85%29.aspx
	// http://icodeguru.com/VC%26MFC/APracticalGuideUsingVisualCandATL/133.htm
	// Коды ошибок http://msdn.microsoft.com/en-us/library/windows/desktop/dd542647%28v=vs.85%29.aspx
	КаталогПриложений = Новый COMОбъект("COMAdmin.COMAdminCatalog");
	КаталогПриложений.Connect(ИмяКомпьютера());
	ПриложенияСистемы = КаталогПриложений.GetCollection("Applications");
	ПриложенияСистемы.Populate();
	Для Каждого СтрокаКласса Из Классы Цикл
		НовыйСборкаПлатформы = СтрокаКласса.НовыйСборкаПлатформы;
		Если ЗначениеЗаполнено(НовыйСборкаПлатформы) Тогда
			ЗарегистрироватьCOMКлассСборкиПлатформы(ТипыComКлассов.Найти(СтрокаКласса.ТипКласса, "Имя"), СтрокаКласса.x64, НовыйСборкаПлатформы);
			СтрокаКласса.СборкаПлатформы = НовыйСборкаПлатформы;
		КонецЕсли;
		НовыйСборкаПлатформы = СтрокаКласса.НовыйСборкаПлатформыПользователь;
		Если ЗначениеЗаполнено(НовыйСборкаПлатформы) Тогда
			ЗарегистрироватьCOMКлассСборкиПлатформы(ТипыComКлассов.Найти(СтрокаКласса.ТипКласса, "Имя"), СтрокаКласса.x64, НовыйСборкаПлатформы, Истина);
			СтрокаКласса.СборкаПлатформыПользователь = НовыйСборкаПлатформы;
		КонецЕсли;
	КонецЦикла; 
	Если Не ИзменитьПриложения Тогда
		Возврат Истина;
	КонецЕсли; 
	Если Ложь
		#Если Не Клиент Тогда
		Или ирКэш.Это64битныйПроцессЛкс() 
		#КонецЕсли 
	Тогда
		Сообщить("Изменение COM+ приложений из 64-битного процесса (на сервере) не реализовано");
	Иначе
		ИзданияПлатформыДляПеререгистрации = Новый Массив;
		ТипКласса = ТипыComКлассов.Найти("ComConnector", "Имя");
		Для Каждого СтрокаПриложения Из Приложения.НайтиСтроки(Новый Структура("Добавленный, Создать", Истина, Истина)) Цикл
			#Если Сервер И Не Сервер Тогда
				СтрокаПриложения = Приложения.Добавить();
			#КонецЕсли
			Если Не ЗначениеЗаполнено(СтрокаПриложения.ИзданиеПлатформы) Тогда
				Продолжить;
			КонецЕсли; 
			СтрокаБазовогоПриложения = Приложения.НайтиСтроки(Новый Структура("Добавленный, ИзданиеПлатформы, x64", Ложь, СтрокаПриложения.ИзданиеПлатформы, СтрокаПриложения.x64))[0];
			СтрокаБазовогоПриложения.Создать = Истина;
		КонецЦикла;
		Приложения.Сортировать("ИзданиеПлатформы Убыв, Добавленный");
		Для Каждого СтрокаПриложения Из Приложения Цикл
			ПриложениеОбъект = Неопределено;
			Если ЗначениеЗаполнено(СтрокаПриложения.Идентификатор) Тогда
				ПриложениеОбъект = НайтиУдалитьОбъектКоллекции(ПриложенияСистемы, СтрокаПриложения.Идентификатор, Не СтрокаПриложения.Создать);
				Если Не СтрокаПриложения.Создать Тогда
					ИзданияПлатформыДляПеререгистрации.Добавить(СтрокаПриложения.ИзданиеПлатформы);
					Продолжить;
				КонецЕсли; 
			КонецЕсли; 
			Если СтрокаПриложения.Создать Тогда
				ИмяФайла = "";
				Если СтрокаПриложения.Добавленный Тогда
					Если Не ЗначениеЗаполнено(СтрокаПриложения.СборкаПлатформы) Тогда
						ирОбщий.СообщитьЛкс("Для добавленного класса " + СтрокаПриложения.ИмяКласса + " COM+ приложения не указана сборка платформы");
						Продолжить;
					КонецЕсли; 
				Иначе
					СтрокаКласса = Классы.НайтиСтроки(Новый Структура("ИмяКласса, x64", СтрокаПриложения.ИмяКласса, СтрокаПриложения.x64))[0];
					#Если Сервер И Не Сервер Тогда
						СтрокаКласса = Классы[0];
					#КонецЕсли
					СтрокаПриложения.СборкаПлатформы = СтрокаКласса.СборкаПлатформы;
				КонецЕсли; 
				ОписаниеСборкиПлатформы = ОписаниеСборкиПлатформы(СтрокаПриложения.СборкаПлатформы, СтрокаПриложения.x64);
				#Если Сервер И Не Сервер Тогда
					ОписаниеСборкиПлатформы = СборкиПлатформы.Найти();
				#КонецЕсли
				Если ОписаниеСборкиПлатформы <> Неопределено Тогда 
					ИмяФайла = ОписаниеСборкиПлатформы.Каталог + "bin\" + ТипКласса.КлючевойФайл;
				КонецЕсли; 
				Если ЗначениеЗаполнено(ИмяФайла) Тогда 
					Если ПриложениеОбъект = Неопределено Тогда
						ПриложениеОбъект = ПриложенияСистемы.Add();
					КонецЕсли; 
					//http://msdn.microsoft.com/en-us/library/windows/desktop/ms687653%28v=vs.85%29.aspx
					ИмяПриложения = СтрокаПриложения.ИмяКласса + "_" + ?(СтрокаПриложения.x64, "64", "32");
					//http://msdn.microsoft.com/en-us/library/windows/desktop/ms686107%28v=vs.85%29.aspx
					ирОбщий.УстановитьЗначениеПоФункциональнойСсылкеЛкс(ПриложениеОбъект, ИмяПриложения, "Value", "Name");
					//ирОбщий.УстановитьЗначениеПоФункциональнойСсылкеЛкс(ПриложениеОбъект, "", "Value", "Description");
					ирОбщий.УстановитьЗначениеПоФункциональнойСсылкеЛкс(ПриложениеОбъект, ?(СтрокаПриложения.Добавленный Или СтрокаПриложения.ОтдельнаяАктивация, 1, 0), "Value", "Activation");
					//ирОбщий.УстановитьЗначениеПоФункциональнойСсылкеЛкс(ПриложениеОбъект, СтрокаПриложения.Включено, "Value", "IsEnabled"); 
					ирОбщий.УстановитьЗначениеПоФункциональнойСсылкеЛкс(ПриложениеОбъект, Истина, "Value", "IsEnabled"); 
					ирОбщий.УстановитьЗначениеПоФункциональнойСсылкеЛкс(ПриложениеОбъект, 100, "Value", "ConcurrentApps"); 
					ирОбщий.УстановитьЗначениеПоФункциональнойСсылкеЛкс(ПриложениеОбъект, 1, "Value", "RecycleActivationLimit"); 
					ирОбщий.УстановитьЗначениеПоФункциональнойСсылкеЛкс(ПриложениеОбъект, 1440, "Value", "RecycleExpirationTimeout");
					Если ЗначениеЗаполнено(ПриложениеПользовательОС) Тогда
						ирОбщий.УстановитьЗначениеПоФункциональнойСсылкеЛкс(ПриложениеОбъект, ПриложениеПользовательОС, "Value", "Identity");
						ирОбщий.УстановитьЗначениеПоФункциональнойСсылкеЛкс(ПриложениеОбъект, ПриложениеПарольПользователяОС, "Value", "Password");
					КонецЕсли; 
					//ирОбщий.УстановитьЗначениеПоФункциональнойСсылкеЛкс(ПриложениеОбъект, Истина, "Value", "RunForever");
					Попытка
						ПриложенияСистемы.SaveChanges();
					Исключение
						ОписаниеОшибки = ОписаниеОшибки();
						Если Найти(ОписаниеОшибки, "0x80110414") > 0 Тогда
							ВызватьИсключение "Новые имя или пароль пользователя COM+ приложений указаны неверно";
						ИначеЕсли Найти(ОписаниеОшибки, "0x80070005") > 0 Тогда
							ВызватьИсключение "Нет разрешения на изменение COM+ приложений. Запустите приложение от имени администратора или отключите флажок ""Изменить приложения"".";
						Иначе
							ВызватьИсключение;
						КонецЕсли; 
					КонецПопытки;
					СтрокаПриложения.Идентификатор = ПриложениеОбъект.Key; 
					Если Не СтрокаПриложения.Добавленный Тогда
						Для Каждого СтрокаКонкурентногоПриложения Из Приложения.НайтиСтроки(Новый Структура("ИзданиеПлатформы, x64", СтрокаПриложения.ИзданиеПлатформы, СтрокаПриложения.x64)) Цикл
							Если Не ЗначениеЗаполнено(СтрокаКонкурентногоПриложения.Идентификатор) Тогда
								Продолжить;
							КонецЕсли; 
							Компоненты = ПриложенияСистемы.GetCollection("Components", СтрокаКонкурентногоПриложения.Идентификатор);
							Компоненты.Populate();
							НайтиУдалитьОбъектКоллекции(Компоненты);
						КонецЦикла;
						КаталогПриложений.InstallComponent(ПриложениеОбъект.Key, ИмяФайла, "", "");
						ИзданияПлатформыДляПеререгистрации.Добавить(СтрокаПриложения.ИзданиеПлатформы);
					Иначе
						СтрокаБазовогоПриложения = Приложения.НайтиСтроки(Новый Структура("Добавленный, ИзданиеПлатформы, x64", Ложь, СтрокаПриложения.ИзданиеПлатформы, СтрокаПриложения.x64))[0];
						Компоненты = ПриложенияСистемы.GetCollection("Components", СтрокаБазовогоПриложения.Идентификатор);
						Компоненты.Populate();
						КомпонентаОбъект = НайтиУдалитьОбъектКоллекции(Компоненты,, Ложь);
						НовыйИдентификатор = "{" + Новый УникальныйИдентификатор + "}";
						КаталогПриложений.AliasComponent(СтрокаБазовогоПриложения.Идентификатор, КомпонентаОбъект.Key, ПриложениеОбъект.Key, СтрокаПриложения.ИмяКласса, НовыйИдентификатор);
						мПлатформа = ирКэш.Получить();
						#Если Сервер И Не Сервер Тогда
							мПлатформа = Обработки.ирПлатформа.Создать();
						#КонецЕсли 
						СкриптРегистрации = ПолучитьМакет("ComConnectorReg").ПолучитьТекст();
						РезультатКоманды = мПлатформа.ВнестиФайлCOMКомпонентыВРеестр(СкриптРегистрации, СтрЗаменить(ИмяФайла, "\", "\\"), НовыйИдентификатор, СтрокаПриложения.x64);
					КонецЕсли; 
					
					Роли = ПриложенияСистемы.GetCollection("Roles", ПриложениеОбъект.Key);
					Роли.Populate();
					Роль = Неопределено;
					Для Каждого лРоль Из Роли Цикл
						Роль = лРоль;
						Прервать;
					КонецЦикла;
					Если Роль = Неопределено Тогда
						Роль = Роли.Add();
						ирОбщий.УстановитьЗначениеПоФункциональнойСсылкеЛкс(Роль, "CreatorOwner", "Value", "Name");
						Роли.SaveChanges();
					КонецЕсли; 
					
					ПользователиИБ = Роли.GetCollection("UsersInRole", Роль.Key);
					ПользователиИБ.Populate();
					// Добавляем пользователя "Все" ("Everyone")
					Для Каждого лПользователь Из ПользователиИБ Цикл
						//Если ирОбщий.СтрокиРавныЛкс("Everyone", лПользователь.Value("User")) Тогда
						//	Пользователь = лПользователь;
						//	Прервать;
						//КонецЕсли; 
						ПользователиИБ.Remove(0);
					КонецЦикла;
					Пользователь = ПользователиИБ.Add();
					//ИмяПользователяИнициатора = ИмяСистемногоПользователяEveryone();
					ИмяПользователяИнициатора = ИмяСлужебногоПользователяОСAuthenticatedUsers();
					ирОбщий.УстановитьЗначениеПоФункциональнойСсылкеЛкс(Пользователь, ИмяПользователяИнициатора, "Value", "User");
					ПользователиИБ.SaveChanges();
				КонецЕсли; 
			КонецЕсли; 
		КонецЦикла;
		Для Каждого ИзданиеПлатформы Из ирОбщий.СвернутьМассивЛкс(ИзданияПлатформыДляПеререгистрации) Цикл
			// При вызове InstallComponent удаляются все разрядности класса устанавливаемой компоненты. Поэтому нужно заново зарегистрировать их.
			СтрокиКлассов = Классы.НайтиСтроки(Новый Структура("ИзданиеПлатформы, ТипКласса, Добавленный", ИзданиеПлатформы, ТипКласса.Имя, Ложь));
			Для Каждого СтрокаКласса Из СтрокиКлассов Цикл
				#Если Сервер И Не Сервер Тогда
					СтрокаКласса = Классы[0];
				#КонецЕсли
				ЗарегистрироватьCOMКлассСборкиПлатформы(ТипКласса, СтрокаКласса.x64, СтрокаКласса.СборкаПлатформы);
			КонецЦикла;
		КонецЦикла;
	КонецЕсли; 
	Результат = Истина;
	Возврат Результат;
		
КонецФункции

Функция НайтиУдалитьОбъектКоллекции(Знач КоллекцияОбъектов, Знач Идентификатор = "", Удалить = Истина)
	Перем Объект;
	НачальноеКоличество = КоллекцияОбъектов.Count;
	Для ОбратныйИндекс = 1 По НачальноеКоличество Цикл
		Индекс = НачальноеКоличество - ОбратныйИндекс;
		Объект = КоллекцияОбъектов.Item(Индекс);
		Если Ложь
			Или Не ЗначениеЗаполнено(Идентификатор)
			Или Объект.Key = Идентификатор 
		Тогда
			Если Удалить Тогда
				КоллекцияОбъектов.Remove(Индекс);
			Иначе
				ПриложениеОбъект = Объект;
				Прервать;
			КонецЕсли; 
		КонецЕсли; 
	КонецЦикла;
	Если Удалить Тогда
		КоллекцияОбъектов.SaveChanges();
	КонецЕсли; 
	Возврат ПриложениеОбъект;
	
КонецФункции

Функция ИмяСлужебногоПользователяОСAuthenticatedUsers() Экспорт 
	
	Результат = Неопределено;
	СлужбаWMI = ирКэш.ПолучитьCOMОбъектWMIЛкс();
	ПользователиОС = СлужбаWMI.ExecQuery("SELECT Name 
	|FROM Win32_SystemAccount
	|WHERE SID = 'S-1-5-11'");
	Для Каждого Пользователь Из ПользователиОС Цикл
		Результат = Пользователь.Name;
	КонецЦикла;
	Возврат Результат;

КонецФункции

Процедура ЗарегистрироватьCOMКлассСборкиПлатформы(Знач ТипКласса, Знач х64 = Неопределено, Знач СборкаПлатформы = Неопределено, Знач ДляПользователя = Ложь) Экспорт 
	
	СтрокаТаблицыНовойСборки = ОписаниеСборкиПлатформы(СборкаПлатформы, х64);
	Если СтрокаТаблицыНовойСборки <> Неопределено Тогда 
		#Если Сервер И Не Сервер Тогда
			ТипКласса = ТипыComКлассов.Найти();
		#КонецЕсли
		ЗарегистрироватьCOMКлассИзКаталогаФайлов(ТипКласса, х64, СтрокаТаблицыНовойСборки.Каталог + "bin", СборкаПлатформы, ДляПользователя);
	Иначе
		ВызватьИсключение "Файл регистрации класса " + ТипКласса.Имя + " для сборки платформы " + СборкаПлатформы + " не найден";
	КонецЕсли;

КонецПроцедуры

Функция ОписаниеСборкиПлатформы(СборкаПлатформы, х64 = Неопределено)
	
	Если х64 = Неопределено Тогда
		х64 = ирКэш.Это64битныйПроцессЛкс();
	КонецЕсли; 
	ОтборСтрок = Новый Структура;
	Если СборкаПлатформы <> "<Удалить>" Тогда
		ОтборСтрок.Вставить("СборкаПлатформы", СборкаПлатформы);
	КонецЕсли;
	ОтборСтрок.Вставить("x64", х64);
	СтрокиТаблицы = СборкиПлатформы.НайтиСтроки(ОтборСтрок);
	Если СтрокиТаблицы.Количество() > 0 Тогда
		СтрокаТаблицыНовогоРелиза = СтрокиТаблицы[0];
	КонецЕсли;
	Возврат СтрокаТаблицыНовогоРелиза;

КонецФункции

Функция ЗарегистрироватьCOMКлассИзКаталогаФайлов(ТипКласса, х64 = Неопределено, пКаталогФайла = Неопределено, СборкаПлатформы = Неопределено, Знач ДляПользователя = Ложь) Экспорт 
	
	Если Не ЗначениеЗаполнено(пКаталогФайла) Тогда
		КаталогФайла = КаталогПрограммы();
		СборкаПлатформы = ТекущаяСборкаПлатформы;
	Иначе
		КаталогФайла = пКаталогФайла;
	КонецЕсли; 
	Если ТипКласса.Внутрипроцессный Тогда
		Если х64 <> Неопределено И ирКэш.Это64битнаяОСЛкс() Тогда
			Если х64 Тогда
				Команда = "%systemroot%\System32\regsvr32.exe";
			Иначе
				Команда = "%systemroot%\SysWoW64\regsvr32.exe";
			КонецЕсли; 
		Иначе
			Команда = "regsvr32.exe";
		КонецЕсли; 
		ПолноеИмяФайла = КаталогФайла + "\" + ТипКласса.КлючевойФайл;
		Команда = Команда + " """ + ПолноеИмяФайла + """";
		Если ТипКласса.Имя = "ServerAdminScope" И ДляПользователя Тогда
			//Команда = Команда + " /n /i:user";
			Команда = Команда + " /i:user";
		КонецЕсли; 
		Если Не ПоказыватьРезультатРегистрации Тогда
			Команда = Команда + " /s";
		КонецЕсли;
		Если СборкаПлатформы = "<Удалить>" Тогда
			Команда = Команда + " /u";
		КонецЕсли;
	Иначе
		#Если Не Клиент Тогда
			Если Не ЗначениеЗаполнено(пКаталогФайла) Тогда
				ВызватьИсключение "Регистрация COM класса типа """ + ТипКласса.Имя + """ отменена, т.к. определение пути к исполняемому файлу клиентского приложения на сервере не реализовано.";
			КонецЕсли; 
		#КонецЕсли
		ПолноеИмяФайла = КаталогФайла + "\" + ТипКласса.КлючевойФайл;
		Команда = """" + ПолноеИмяФайла + """ /";
		Если СборкаПлатформы = "<Удалить>" Тогда
			Команда = Команда + " /UnregServer";
		Иначе
			Команда = Команда + " /RegServer";
		КонецЕсли;
		Если ДляПользователя Тогда
			Команда = Команда + " -CurrentUser";
		КонецЕсли;
	КонецЕсли;
	Если ЗначениеЗаполнено(Команда) Тогда
		Файл = Новый Файл(ПолноеИмяФайла);
		Если Не Файл.Существует() Тогда
			ВызватьИсключение "При регистрации COM класса типа """ + ТипКласса.Имя + """ не найден файл """ + Файл.ПолноеИмя + """
				|Переустановите платформу с необходимой компонентой";
		Иначе
			РезультатКоманды = ирОбщий.ВыполнитьКомандуОСЛкс(Команда,,, Истина); // Тут всегда пустой результат
		КонецЕсли; 
	КонецЕсли;
	#Если Сервер И Не Клиент Тогда
		Текст = "серверном контексте";
	#Иначе
		Текст = "клиентском контексте";
	#КонецЕсли
	Если ДляПользователя Тогда
		Текст = Текст + " для пользователя";
	Иначе
		Текст = Текст + " для компьютера";
	КонецЕсли;
	ПроцессОС = ирОбщий.ПолучитьПроцессОСЛкс("текущий");
	//#Если Клиент Тогда
	//	Текст = Текст + " из процесса " + ПроцессОС.Name + "(" + XMLСтрока(ПроцессОС.ProcessID) + ")";
	//#КонецЕсли 
	ТекстСообщения = "Выполнена локальная регистрация COM класса """ + ТипКласса.Имя + """ " + СборкаПлатформы + " в " + Текст;
	ирОбщий.СообщитьЛкс(ТекстСообщения);
	//#Если Клиент Тогда
	//	Сообщить("! После регистрации для возможности использовать класс может потребоваться перезапуск процесса 1С !", СтатусСообщения.Внимание);
	//#КонецЕсли 
	Возврат РезультатКоманды;

КонецФункции

Процедура ЗаполнитьКлассыИзКоллекции(Компоненты, x64)

	Компоненты.Populate();    
	РеестрОС = ПолучитьCOMОбъект("winmgmts:{impersonationLevel=impersonate}!\\.\root\default:StdRegProv");
	Для Каждого Компонента Из Компоненты Цикл
		ИмяКласса = Компонента.Name;
		Если Найти(НРег(ИмяКласса), "v8") = 1 Тогда 
			Для Каждого СтрокаТипаКласса Из ТипыComКлассов Цикл
				Если Найти(НРег(ИмяКласса), НРег(СтрокаТипаКласса.ИмяКлассаПослеV8)) = 4 Тогда
					ИдентификаторКомпоненты = Компонента.Key;
					НомерИзданияПлатформы = Число(Сред(ИмяКласса, 3, 1));
					ПолноеИмяФайлаПользователя = "";
					Если СтрокаТипаКласса.Внутрипроцессный Тогда
						ИмяТипаСервера = "InprocServer32";
					Иначе
						ИмяТипаСервера = "LocalServer32";
					КонецЕсли;
					ПолноеИмяФайла = Компонента.Value(ИмяТипаСервера); 
					Если x64 Тогда
						РазделРеестра = "SOFTWARE\Classes\CLSID";
					Иначе
						РазделРеестра = "SOFTWARE\Classes\WOW6432Node\CLSID";
					КонецЕсли;
					Если ирКэш.Это64битныйПроцессЛкс() Или Не x64 Тогда 
						РеестрОС.GetStringValue("2147483649", РазделРеестра + "\" + ИдентификаторКомпоненты + "\" + ИмяТипаСервера,, ПолноеИмяФайлаПользователя); // 2147483649 = HKEY_CURRENT_USER
					Иначе
						ПолноеИмяФайлаПользователя = "<Недоступно из x32 приложения>";
					КонецЕсли;
					ИмяКласса = "V8" + НомерИзданияПлатформы + СтрокаТипаКласса.ИмяКлассаПослеV8;
					СтрокиКлассов = Классы.НайтиСтроки(Новый Структура("ИмяКласса, x64", ИмяКласса, x64));
					Если СтрокиКлассов.Количество() > 0 Тогда
						СтрокаПриложения = СтрокиКлассов[0];
						СтрокаПриложения.ИмяФайла = ПолноеИмяФайла;
						СтрокаПриложения.ИмяФайлаПользователя = ПолноеИмяФайлаПользователя;
						СтрокаПриложения.Идентификатор = Компонента.Key;
						СтрокаПриложения.Зарегистрирован = Истина;
					КонецЕсли; 
				КонецЕсли; 
			КонецЦикла;
		КонецЕсли; 
	КонецЦикла;

КонецПроцедуры

Процедура ОбновитьТаблицуКлассов(ЗаполнятьТолькоВнешниеСоединения = Ложь) Экспорт 
	
	Классы.Очистить();
	Приложения.Очистить();
	МассивРазрядностей = Новый Массив();
	МассивРазрядностей.Добавить(Ложь);
	Если ирКэш.Это64битнаяОСЛкс() Тогда
		МассивРазрядностей.Добавить(Истина);
		//Если ЗаполнятьТолькоВнешниеСоединения Тогда 
		//	Если КэшКонтекстаИис.Это64битныйПроцессИис() Тогда
		//		МассивРазрядностей.Удалить(0);
		//	Иначе
		//		МассивРазрядностей.Удалить(1);
		//	КонецЕсли; 
		//КонецЕсли; 
	КонецЕсли; 
	
	Для Каждого ИзданиеПлатформы Из мИзданияПлатформы Цикл
		Для Каждого ТипКласса Из ТипыComКлассов Цикл
			Если Истина
				И ЗаполнятьТолькоВнешниеСоединения 
				И ТипКласса.Имя <> "ComConnector"
			Тогда
				Продолжить;
			КонецЕсли; 
			Для Каждого x64 Из МассивРазрядностей Цикл
				Если Не ТипКласса.Внутрипроцессный И x64 И ИзданиеПлатформы.Значение < "83" Тогда
					Продолжить;
				КонецЕсли; 
				ИмяКласса = "V" + ИзданиеПлатформы.Значение + ТипКласса.ИмяКлассаПослеV8;
				СтрокаКласса = Классы.Добавить();
				СтрокаКласса.ИзданиеПлатформы = ИзданиеПлатформы.Представление;
				СтрокаКласса.ИмяКласса = ИмяКласса;
				ирОбщий.ОбновитьКопиюСвойстваВНижнемРегистреЛкс(СтрокаКласса, "ИмяКласса");
				СтрокаКласса.ВнутриПроцессный = ТипКласса.Внутрипроцессный;
				СтрокаКласса.ТипКласса = ТипКласса.Имя;
				СтрокаКласса.x64 = x64;
			КонецЦикла;
		КонецЦикла;
		Для Каждого x64 Из МассивРазрядностей Цикл
			СтрокаПриложения = Приложения.Добавить();
			СтрокаПриложения.ИзданиеПлатформы = ИзданиеПлатформы.Значение;
			СтрокаПриложения.ИмяКласса = "V" + ИзданиеПлатформы.Значение + ".ComConnector";
			ирОбщий.ОбновитьКопиюСвойстваВНижнемРегистреЛкс(СтрокаПриложения, "ИмяКласса");
			СтрокаПриложения.x64 = x64;
		КонецЦикла;
	КонецЦикла; 
	
	КаталогПриложений = Новый COMОбъект("COMAdmin.COMAdminCatalog");
	КаталогПриложений.Connect(ИмяКомпьютера());
	Если ирКэш.Это64битнаяОСЛкс() Тогда
		Компоненты = КаталогПриложений.GetCollection("InprocServers");
		ЗаполнитьКлассыИзКоллекции(Компоненты, Истина);
		Компоненты = КаталогПриложений.GetCollection("WOWLegacyServers");
		ЗаполнитьКлассыИзКоллекции(Компоненты, Ложь);
	КонецЕсли; 
	Компоненты = КаталогПриложений.GetCollection("LegacyServers");
	ЗаполнитьКлассыИзКоллекции(Компоненты, ирКэш.Это64битнаяОСЛкс());

	// COM+ Приложения
	ПриложенияСистемы = КаталогПриложений.GetCollection("Applications");
	ПриложенияСистемы.Populate();
	Для Каждого Приложение Из ПриложенияСистемы Цикл
		Если Ложь
			Или Приложение.Key = "{9EB3B62C-79A2-11D2-9891-00C04F79AF51}" 
			Или Приложение.Key = "{7B4E1F3C-A702-11D2-A336-00C04F7978E0}" 
			Или Приложение.Key = "{01885945-612C-4A53-A479-E97507453926}" 
			Или Приложение.Key = "{02D4B3F1-FD88-11D1-960D-00805FC79235}" 
		Тогда
			Продолжить;
		КонецЕсли; 
		СтрокаПриложения = Неопределено;
		Компоненты = ПриложенияСистемы.GetCollection("Components", Приложение.Key);
		Попытка
			Компоненты.Populate();
		Исключение
			Компоненты = Неопределено;
			ирОбщий.СообщитьЛкс("Ошибка получения компонент приложения """ + Приложение.Value("Name") + """: " + ОписаниеОшибки(), СтатусСообщения.Внимание);
			Продолжить;
		КонецПопытки; 
		Если Компоненты <> Неопределено Тогда
			Для Каждого Компонента Из Компоненты Цикл
				ИмяКласса = Компонента.Value("ProgID");
				Если Истина
					И ирОбщий.СтрНачинаетсяСЛкс(НРег(ИмяКласса), "v8")
					И Найти(НРег(ИмяКласса), ".comconnector") > 0
				Тогда
					ПолноеИмяФайла = Компонента.Value("DLL");
					Это64битнаяКомпонента = Найти(НРег(ПолноеИмяФайла), "(x86)") = 0 И ирКэш.Это64битнаяОСЛкс(); // Ненадежно
					СтрокаПриложения = ЗаполнитьКлассыПриложения(ИмяКласса, Компонента, ПолноеИмяФайла, Приложение, ПриложенияСистемы, Это64битнаяКомпонента);
				КонецЕсли; 
			КонецЦикла;
		КонецЕсли; 
		Если ирКэш.Это64битнаяОСЛкс() Тогда
			Компоненты = ПриложенияСистемы.GetCollection("LegacyComponents", Приложение.Key);
			Компоненты.Populate();
			Для Каждого Компонента Из Компоненты Цикл
				ИмяКласса = Компонента.Value("ProgID");
				Если Истина
					И ирОбщий.СтрНачинаетсяСЛкс(НРег(ИмяКласса), "v8")
					И Найти(НРег(ИмяКласса), ".comconnector") > 0
				Тогда
					ПолноеИмяФайла = Компонента.Value("InprocServer32");
					Это64битнаяКомпонента = Ложь;
					СтрокаПриложения = ЗаполнитьКлассыПриложения(ИмяКласса, Компонента, ПолноеИмяФайла, Приложение, ПриложенияСистемы, Это64битнаяКомпонента);
				КонецЕсли; 
			КонецЦикла;
		КонецЕсли; 
		//Прервать;
	КонецЦикла;
	Для Каждого СтрокаТаблицы Из Классы Цикл
		Если ЗначениеЗаполнено(СтрокаТаблицы.ИмяФайла) Тогда
			ФайлWMI = ирОбщий.ПолучитьФайлWMIЛкс(СтрокаТаблицы.ИмяФайла);
			Если ФайлWMI <> Неопределено Тогда
				СтрокаТаблицы.ФайлСуществует = Истина;
			КонецЕсли; 
			Фрагменты = ирОбщий.СтрРазделитьЛкс(СтрЗаменить(СтрокаТаблицы.ИмяФайла, "\\", "\"), "\");
			КаталогСборки = ирОбщий.СтрСоединитьЛкс(Фрагменты, "\", -2) + "\";
			СтрокаСборкиПлатформы = СборкиПлатформы.Найти(НРег(КаталогСборки), "НКаталог");
			Если ЗначениеЗаполнено(СтрокаСборкиПлатформы) Тогда
				СтрокаТаблицы.СборкаПлатформы = ПредставлениеСборкиПлатформы(СтрокаСборкиПлатформы, СтрокаТаблицы.Внутрипроцессный);
			Иначе
				Если ФайлWMI <> Неопределено Тогда
					СтрокаТаблицы.СборкаПлатформы = ФайлWMI.Version;
				КонецЕсли; 
			КонецЕсли;    
			Если Не ЗначениеЗаполнено(СтрокаТаблицы.ИзданиеПлатформы) Тогда
				СтрокаТаблицы.ИзданиеПлатформы = ирОбщий.СтрСоединитьЛкс(ирОбщий.СтрРазделитьЛкс(СтрокаТаблицы.СборкаПлатформы), ".", 2);
			КонецЕсли; 
		КонецЕсли; 
		Если ЗначениеЗаполнено(СтрокаТаблицы.ИмяФайлаПользователя) Тогда
			ФайлWMI = ирОбщий.ПолучитьФайлWMIЛкс(СтрокаТаблицы.ИмяФайлаПользователя);
			Если ФайлWMI <> Неопределено Тогда
				СтрокаТаблицы.ФайлСуществуетПользователь = Истина;
			КонецЕсли; 
			Фрагменты = ирОбщий.СтрРазделитьЛкс(СтрЗаменить(СтрокаТаблицы.ИмяФайлаПользователя, "\\", "\"), "\");
			КаталогСборки = ирОбщий.СтрСоединитьЛкс(Фрагменты, "\", -2) + "\";
			СтрокаСборкиПлатформы = СборкиПлатформы.Найти(НРег(КаталогСборки), "НКаталог");
			Если ЗначениеЗаполнено(СтрокаСборкиПлатформы) Тогда
				СтрокаТаблицы.СборкаПлатформыПользователь = ПредставлениеСборкиПлатформы(СтрокаСборкиПлатформы, СтрокаТаблицы.Внутрипроцессный);
			Иначе
				Если ФайлWMI <> Неопределено Тогда
					СтрокаТаблицы.СборкаПлатформыПользователь = ФайлWMI.Version;
				КонецЕсли; 
			КонецЕсли;
		КонецЕсли; 
	КонецЦикла;
	Классы.Сортировать("ИзданиеПлатформы Убыв, ТипКласса, x64, Добавленный, ИмяКласса");
	
	Для Каждого СтрокаПриложения Из Приложения Цикл
		ОтборКлассов = Новый Структура("ИмяКласса, x64", СтрокаПриложения.ИмяКласса, СтрокаПриложения.x64);
		СтрокаКласса = Классы.НайтиСтроки(ОтборКлассов)[0];
		#Если Сервер И Не Сервер Тогда
			СтрокаКласса = Классы.Добавить();
		#КонецЕсли
		СтрокаПриложения.СборкаПлатформы = СтрокаКласса.СборкаПлатформы;
		СтрокаПриложения.ИзданиеПлатформы = СтрокаКласса.ИзданиеПлатформы;
	КонецЦикла;
	Приложения.Сортировать("ИзданиеПлатформы Убыв, x64, Добавленный, ИмяКласса");
	
КонецПроцедуры

Функция ЗаполнитьКлассыПриложения(Знач ИмяКласса, Знач Компонента, Знач ПолноеИмяФайла, Знач Приложение, Знач ПриложенияСистемы, Знач Это64битнаяКомпонента)
	
	НомерИзданияПлатформы = Число(Сред(ИмяКласса, 3, 1));
	//ИмяКласса = "V8" + НомерИзданияПлатформы + ".ComConnector";
	Отбор = Новый Структура("НИмяКласса, x64, ТипКласса", НРег(ИмяКласса), Это64битнаяКомпонента, "ComConnector");
	СтрокиКлассов = Классы.НайтиСтроки(Отбор);
	Если Истина
		И СтрокиКлассов.Количество() = 0 
		И ирОбщий.СтрКончаетсяНаЛкс(ИмяКласса, ".1") 
	Тогда
		ИмяКласса = ирОбщий.СтрокаБезКонцаЛкс(ИмяКласса, СтрДлина(".1"));
		Отбор = Новый Структура("НИмяКласса, x64, ТипКласса", НРег(ИмяКласса), Это64битнаяКомпонента, "ComConnector");
		СтрокиКлассов = Классы.НайтиСтроки(Отбор);
	КонецЕсли; 
	Если СтрокиКлассов.Количество() = 0 Тогда
		СтрокаКласса = Классы.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаКласса, Отбор); 
		СтрокаКласса.ИмяКласса = ИмяКласса;
		СтрокаКласса.Добавленный = Истина;
	Иначе
		СтрокаКласса = СтрокиКлассов[0];
	КонецЕсли;
	СтрокаКласса.Идентификатор = Компонента.Key;
	СтрокаКласса.ИмяФайла = ПолноеИмяФайла;
	СтрокаКласса.Зарегистрирован = Истина;
	СтрокаПриложения = НайтиЗаполнитьСтрокуПриложения(ИмяКласса, Приложение, Это64битнаяКомпонента, ПриложенияСистемы);
	Возврат СтрокаПриложения;

КонецФункции

Функция НайтиЗаполнитьСтрокуПриложения(ИмяКласса, Приложение, x64, ПриложенияСистемы)
	
	Отбор = Новый Структура("НИмяКласса, x64, Идентификатор", НРег(ИмяКласса), x64, "");
	НайденныеСтроки = Приложения.НайтиСтроки(Отбор);
	Если НайденныеСтроки.Количество() = 0 Тогда
		СтрокаПриложения = Приложения.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаПриложения, Отбор); 
		СтрокаПриложения.ИмяКласса = ИмяКласса;
		СтрокаПриложения.Добавленный = Истина;
	Иначе
		СтрокаПриложения = НайденныеСтроки[0];
	КонецЕсли; 
	СтрокаПриложения.ИмяПриложения = Приложение.Name;
	СтрокаПриложения.Идентификатор = Приложение.Key;
	
	ДоступенПользователям = "";
	Роли = ПриложенияСистемы.GetCollection("Roles", Приложение.Key);
	Роли.Populate();
	Для Каждого Роль Из Роли Цикл
		ПользователиКомпоненты = Роли.GetCollection("UsersInRole", Роль.Key);
		ПользователиКомпоненты.Populate();
		Для Каждого Пользователь Из ПользователиКомпоненты Цикл
			Если ДоступенПользователям <> "" Тогда
				ДоступенПользователям = ДоступенПользователям + ",";
			КонецЕсли; 
			ДоступенПользователям = ДоступенПользователям + Пользователь.Value("User");
		КонецЦикла;
	КонецЦикла;
	СтрокаПриложения.ДоступенПользователям = ДоступенПользователям;
	
	Если Приложение.Value("Activation") > 0 Тогда
		СтрокаПриложения.ОтдельнаяАктивация = Истина;
	КонецЕсли;
	СтрокаПриложения.Создать = Истина;
	СтрокаПриложения.ВремяОжидания = Приложение.Value("RecycleExpirationTimeout");
	СтрокаПриложения.ИмяПользователя = Приложение.Value("Identity");
	СтрокаПриложения.ПредельноеЧислоАктиваций = Приложение.Value("RecycleActivationLimit");
	СтрокаПриложения.РазмерГруппы = Приложение.Value("ConcurrentApps");
	СтрокаПриложения.Включено = Приложение.Value("IsEnabled");
	НомерИзданияПлатформы = Прав(Приложение.Name, 1);
	//Роли = ПриложенияСистемы.GetCollection("Roles", Приложение.Key);
	//Роли.Populate();
	//Для Каждого Роль Из Роли Цикл
	//	 Прервать;
	//КонецЦикла;
	//ПользователиКомпоненты = Роли.GetCollection("UsersInRole", Роль.Key);
	//ПользователиКомпоненты.Populate();
	//Для Каждого Пользователь Из ПользователиКомпоненты Цикл
	//	 Прервать;
	//КонецЦикла;
	Возврат СтрокаПриложения;

КонецФункции

Функция ПредставлениеСборкиПлатформы(Знач СтрокаСборки, Знач Внутрипроцессный = Ложь) Экспорт 
	
	ПредставлениеСборки = СтрокаСборки.СборкаПлатформы;
	Возврат ПредставлениеСборки;

КонецФункции

Функция ЗаполнитьТипыCOMКлассов() Экспорт 
	
	ТабличныйДокумент = ПолучитьМакет("ТипыCOMКлассов");
	Результат = ирОбщий.ТаблицаЗначенийИзТабличногоДокументаЛкс(ТабличныйДокумент);
	ТипыComКлассов.Загрузить(Результат);
	СистемнаяИнформация = Новый СистемнаяИнформация;
	ЭтотОбъект.ТекущаяСборкаПлатформы = СистемнаяИнформация.ВерсияПриложения;
	ЭтотОбъект.ТекущийПользовательОС = ирКэш.ТекущийПользовательОСЛкс();
	ЭтотОбъект.x64Текущая = ирКэш.Это64битныйПроцессЛкс();
	Возврат Результат;
	
КонецФункции

//ирПортативный лФайл = Новый Файл(ИспользуемоеИмяФайла);
//ирПортативный ПолноеИмяФайлаБазовогоМодуля = Лев(лФайл.Путь, СтрДлина(лФайл.Путь) - СтрДлина("Модули\")) + "ирПортативный.epf";
//ирПортативный #Если Клиент Тогда
//ирПортативный 	Контейнер = Новый Структура();
//ирПортативный 	Оповестить("ирПолучитьБазовуюФорму", Контейнер);
//ирПортативный 	Если Не Контейнер.Свойство("ирПортативный", ирПортативный) Тогда
//ирПортативный 		ирПортативный = ВнешниеОбработки.ПолучитьФорму(ПолноеИмяФайлаБазовогоМодуля);
//ирПортативный 		ирПортативный.Открыть();
//ирПортативный 	КонецЕсли; 
//ирПортативный #Иначе
//ирПортативный 	ирПортативный = ВнешниеОбработки.Создать(ПолноеИмяФайлаБазовогоМодуля, Ложь); // Это будет второй экземпляр объекта
//ирПортативный #КонецЕсли
//ирПортативный ирОбщий = ирПортативный.ОбщийМодульЛкс("ирОбщий");
//ирПортативный ирКэш = ирПортативный.ОбщийМодульЛкс("ирКэш");
//ирПортативный ирСервер = ирПортативный.ОбщийМодульЛкс("ирСервер");
//ирПортативный ирКлиент = ирПортативный.ОбщийМодульЛкс("ирКлиент");

мПлатформа = ирКэш.Получить();
мИзданияПлатформы = Новый СписокЗначений;
Для Счетчик = 1 По 3 Цикл
	Представление = "8." + Счетчик;
	мИзданияПлатформы.Добавить("8" + Счетчик, Представление);
КонецЦикла;
