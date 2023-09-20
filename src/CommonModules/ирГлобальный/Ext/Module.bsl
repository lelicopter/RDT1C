﻿#Если Клиент И Не ВебКлиент И Не МобильныйКлиент Тогда

// Вынесено сюда, чтобы у всех пользователей не компилировался тяжелый общий модуль ирОбщий в варианте Расширение
Процедура ОткрытьОднократноАдаптациюРасширенияЛкс(выхПерехватКлавиатуры = Неопределено) Экспорт 
	
	Если Ложь
		#Если ТонкийКлиент Тогда
			Или Не ирСервер.ЛиЕстьИнтерактивныйДоступКИнструментамЛкс() // 30мс
		#Иначе
			Или Не ПравоДоступа("Просмотр", Метаданные.Подсистемы.ИнструментыРазработчикаTormozit) 
		#КонецЕсли 
	Тогда
		Возврат;
	КонецЕсли;

	#Если Не ТолстыйКлиентОбычноеПриложение Тогда
	Если Найти(ПараметрЗапуска, "ОтключитьПерехватКлавиатурыИР") = 0 Тогда
		//ирОбщий.ПодключитьПерехватКлавиатурыЛкс(выхПерехватКлавиатуры); // Очень долго из-за инициализации всех модулей
		СисИнфо = Новый СистемнаяИнформация;
		Если СисИнфо.ТипПлатформы = ТипПлатформы.Windows_x86_64 Тогда 
			Разрядность = "64";
		Иначе
			Разрядность = "32";
		КонецЕсли; 
		Попытка
			//Успех = ПодключитьВнешнююКомпоненту("Обработка.ирПлатформа.Макет.KeyboardHookZip", "ПерехватКлавиатуры", ТипВнешнейКомпоненты.Native); // На 8.2 работать не будет
			Успех = ПодключитьВнешнююКомпоненту("Обработка.ирПлатформа.Макет.KeyboardHookWin" + Разрядность, "ПерехватКлавиатуры", ТипВнешнейКомпоненты.Native); // 0.03сек
		Исключение
			// В тонком клиенте: Использование синхронных методов на клиенте запрещено!
			ОписаниеОшибки = ОписаниеОшибки();
			Успех = Истина;
		КонецПопытки;
		Если Не Успех Тогда
			#Если ТонкийКлиент Тогда
				ирКлиент.ПослеУстановкиKeyboardHook();
			#КонецЕсли
		КонецЕсли; 
		Попытка
			выхПерехватКлавиатуры = Новый ("AddIn.ПерехватКлавиатуры.KeyboardHook");
		Исключение
		КонецПопытки;
		Если выхПерехватКлавиатуры <> Неопределено Тогда
			выхПерехватКлавиатуры.ЗахватПервым = Истина; // Используем не по назначению
			выхПерехватКлавиатуры.ЗахватРазрешен = Истина;
			выхПерехватКлавиатуры.СобытиеПриНажатии = Истина;
		КонецЕсли; 
	КонецЕсли; 
	#КонецЕсли
	
	#Если Не ТонкийКлиент И Не ВебКлиент И Не МобильныйКлиент Тогда
	Если Истина
		И ПравоДоступа("Администрирование", Метаданные)
		И Метаданные.Справочники.Найти("ирАлгоритмы") = Неопределено 
	Тогда
		// Это вариант поставки "Расширение"
		//ИмяПродуктаЛкс = ирОбщий.ИмяПродуктаЛкс(); // !!! Так при начале каждого сеанса толстого клиента будет компилироваться ирОбщий
		ИмяПродуктаЛкс = "ИнструментыРазработчикаTormozit";
		ОткрытьАдаптациюИР = Ложь;
		ПометкиКоманд = ХранилищеОбщихНастроек.Загрузить(, "ирАдаптацияРасширения.ПометкиКоманд",, ИмяПродуктаЛкс);
		Если ПометкиКоманд = Неопределено Тогда
			ПометкиКоманд = Новый Структура;
			ХранилищеОбщихНастроек.Сохранить(, "ирАдаптацияРасширения.ПометкиКоманд", ПометкиКоманд,, ИмяПродуктаЛкс);
			Если ХранилищеОбщихНастроек.Загрузить(, "ирАдаптацияРасширения.ПометкиКоманд",, ИмяПродуктаЛкс) = Неопределено Тогда
				Возврат;
			КонецЕсли; 
			ОткрытьАдаптациюИР = Истина;
		КонецЕсли; 
		Если Найти(НРег(ПараметрЗапуска), НРег("ОткрытьАдаптациюИР")) > 0 Тогда
			ОткрытьАдаптациюИР = Истина;
		КонецЕсли; 
		Если ОткрытьАдаптациюИР Тогда
			ОткрытьФорму("ОбщаяФорма.ирАдаптацияРасширения", Новый Структура("Автооткрытие", Истина));
		КонецЕсли; 
		// Пример пакетного запуска - /CАдаптироватьРасширениеИР;<ПарольПользователя>
		// http://devtool1c.ucoz.ru/forum/3-1695-1
		ИмяПараметра = "АдаптироватьРасширениеИР";
		Если Найти(НРег(ПараметрЗапуска), НРег(ИмяПараметра)) > 0 Тогда
			ПарольПользователя = ирОбщий.ТекстМеждуМаркерамиЛкс(ПараметрЗапуска, ИмяПараметра + ";", ";");
			РезультатАдаптации = ирОбщий.АдаптироватьРасширениеЛкс(ИмяПользователя(), ПарольПользователя);
			//Если РезультатАдаптации Тогда 
				ПрекратитьРаботуСистемы();
				Возврат;
			//КонецЕсли; 
		КонецЕсли; 
	КонецЕсли;
	#Если Сервер И Не Сервер Тогда
		ОбработатьПараметрЗапускаДляВсехРежимовЛкс();
	#КонецЕсли
	ПодключитьОбработчикОжидания("ОбработатьПараметрЗапускаДляВсехРежимовЛкс", 0.1, Истина); // Асинхронно, чтобы все сообщения отобразились https://www.hostedredmine.com/issues/953670
	#КонецЕсли
	
КонецПроцедуры

#КонецЕсли 

//#Область ГлобальныеПортативныеМетоды

#Если Клиент Тогда

Процедура ВнешнееСобытиеЛкс(Источник, Событие, Данные) Экспорт
	
	#Если ТонкийКлиент Тогда
	Если Источник = "KeyboardHook" Тогда 
		//КодыКлавиш = ирКэш.КодыКлавишЛкс(); // В тонком недоступно
		КодыКлавиш = Новый Соответствие;
		КодыКлавиш["CTRL+~"] = "04288";
		Если Ложь
			Или Найти(Данные, КодыКлавиш["CTRL+~"]) = 1
		Тогда
			АктивноеОкно = АктивноеОкно();
			Если АктивноеОкно <> Неопределено Тогда
				НавигационнаяСсылка = АктивноеОкно.ПолучитьНавигационнуюСсылку();
			КонецЕсли; 
			ирОбщий.ПроверитьЧтоСеансТолстогоКлиентаЛкс(НавигационнаяСсылка);
		КонецЕсли;
	КонецЕсли; 
	#КонецЕсли 

	#Если Не ТонкийКлиент И Не ВебКлиент И Не МобильныйКлиент Тогда
	Попытка
		Если Истина
			И Источник = "KeyboardHook" 
			И (Ложь
				Или ирКэш.ЛиПортативныйРежимЛкс()
				Или ПравоДоступа("Просмотр", Метаданные.Подсистемы.ИнструментыРазработчикаTormozit))
		Тогда
			ПередатьОбработку = Ложь; // Максимально отсрачиваем компиляцию общего модуля ирОбщий
			ПерехватКлавиатуры = ирКэш.ПерехватКлавиатурыЛкс();
			КодыКлавиш = ирКэш.КодыКлавишЛкс();
			Если ПерехватКлавиатуры.ЗахватПервым = Истина Тогда // Используем не по назначению
				КлавишиТриггеры = Новый Массив;
				КлавишиТриггеры.Добавить("CTRL+~");
				КлавишиТриггеры.Добавить("CTRL+C");
				КлавишиТриггеры.Добавить("CTRL+V");
				КлавишиТриггеры.Добавить("CTRL+ALT+G");
				Для Каждого КлючКлавиши Из КлавишиТриггеры Цикл
					Если Найти(Данные, КодыКлавиш[КлючКлавиши]) = 1 Тогда 
						ПередатьОбработку = Истина;
						Прервать;
					КонецЕсли; 
				КонецЦикла;
			Иначе
				ПередатьОбработку = Истина;
			КонецЕсли; 
			Если ПередатьОбработку Тогда
				ПерехватКлавиатуры.ЗахватПервым = Ложь; // Используем не по назначению
				СобытиеОбработано = Ложь;
				АктивнаяУправляемаяФорма = ирКлиент.АктивнаяУправляемаяФормаЛкс();
				Если АктивнаяУправляемаяФорма = Неопределено Тогда
					ирКлиент.УдалитьСсылкиНаЗакрытыеФормыЛкс();
					Для Каждого ПроверятьПолеHTML Из ирОбщий.ЗначенияВМассивЛкс(Ложь, Истина) Цикл
						Для Каждого Форма Из ирКэш.ОткрытыеФормыПодсистемыЛкс() Цикл
							СлужебныеДанные = ирОбщий.СлужебныеДанныеФормыЛкс(Форма);
							Если ирКлиент.Форма_ВводДоступенЛкс(Форма, ПроверятьПолеHTML) Тогда 
								СобытиеОбработано = Истина;
								Если ирОбщий.ТекущееВремяВМиллисекундахЛкс() - СлужебныеДанные.ДатаОткрытия > 100 Тогда // https://www.hostedredmine.com/issues/892885
									Если ирОбщий.МетодРеализованЛкс(Форма, "ВнешнееСобытие") Тогда
										Форма.ВнешнееСобытие(Источник, Событие, Данные);
									Иначе
										ирОбщий.СообщитьЛкс(ирОбщий.СтрШаблонИменЛкс("У формы %1 отсутствует экспортный обработчик %2", 1, Форма.Заголовок, 2, "ВнешнееСобытие"));
									КонецЕсли; 
								КонецЕсли; 
								Прервать;
							КонецЕсли; 
						КонецЦикла;
						Если СобытиеОбработано Тогда
							Прервать;
						КонецЕсли; 
					КонецЦикла;
					#Если ТолстыйКлиентОбычноеПриложение Тогда
						Если Не СобытиеОбработано И Найти(Данные, КодыКлавиш["CTRL+~"]) = 1 Тогда
							КэшПоискаФорм = ирОбщий.ВосстановитьЗначениеЛкс("КэшПоискаФорм");
							Если КэшПоискаФорм = Неопределено Тогда
								КэшПоискаФорм = Новый СписокЗначений;
							КонецЕсли; 
							КэшПоискаФормИзменен = Ложь;
							ВводДоступен = Ложь;
							Для Каждого КлючИЗначение Из ирКэш.ОтслеживаемыеФормыЛкс() Цикл
								Форма = КлючИЗначение.Ключ;
								ВводДоступен = ирКлиент.Форма_ВводДоступенЛкс(Форма);
								Если ВводДоступен Тогда
									Прервать;
								КонецЕсли;
								КлючТекущейСтроки = Неопределено;
								ирКлиент.КлючиСтрокБДИзТаблицыФормыЛкс(Форма, КлючТекущейСтроки,,, Истина);
								Если КлючТекущейСтроки <> Неопределено И ирОбщий.ЛиСсылкаНаОбъектБДЛкс(КлючТекущейСтроки) Тогда
									Форма = КлючТекущейСтроки.ПолучитьФорму();
									Если Форма.Открыта() Тогда
										ирКлиент.НачатьОтслеживаниеФормыЛкс(Форма);
										ВводДоступен = ирКлиент.Форма_ВводДоступенЛкс(Форма);
										Если ВводДоступен Тогда
											Прервать;
										КонецЕсли;
									КонецЕсли;
								КонецЕсли; 
							КонецЦикла;
							Если Не ВводДоступен Тогда
								ПараметрыБыстрогоСозданияФормы = ирКлиент.ПараметрыБыстрогоСозданияФормыЛкс();
								Для Каждого ЭлементКэша Из КэшПоискаФорм Цикл
									ПолноеИмяФормы = ЭлементКэша.Значение;
									Попытка
										Форма = ирКлиент.ПолучитьФормуЛкс(ПолноеИмяФормы, ПараметрыБыстрогоСозданияФормы);
										ВводДоступен = Форма.ВводДоступен();
									Исключение
										Продолжить;
									КонецПопытки;
									Если ВводДоступен Тогда 
										Прервать;
									КонецЕсли;
								КонецЦикла;
							КонецЕсли;
							Если Не ВводДоступен Тогда 
								ТаблицаТиповМетаобъектов = ирКэш.ТипыМетаОбъектов(, Ложь, Ложь);
								ВыбранныеТипыМетаданных = Новый Массив;
								Для Каждого СтрокаТипаМетаОбъектов Из ТаблицаТиповМетаобъектов Цикл
									ЛиКорневойТипТаблицыБД = ирОбщий.ЛиКорневойТипТаблицыБДЛкс(СтрокаТипаМетаОбъектов.Единственное);
									Если Ложь
										Или СтрокаТипаМетаОбъектов.Единственное = "Перерасчет"
										Или СтрокаТипаМетаОбъектов.Единственное = "Последовательность"
										Или СтрокаТипаМетаОбъектов.Единственное = "ВнешнийИсточникДанных"
										Или (Истина
											И Не ЛиКорневойТипТаблицыБД
											И СтрокаТипаМетаОбъектов.Единственное <> "Отчет"
											И СтрокаТипаМетаОбъектов.Единственное <> "Обработка") 
										Или Метаданные[СтрокаТипаМетаОбъектов.Множественное].Количество() = 0
									Тогда
										Продолжить;
									КонецЕсли;
									ВыбранныеТипыМетаданных.Добавить(СтрокаТипаМетаОбъектов);
								КонецЦикла;
								ТаблицаТиповМетаобъектов = ТаблицаТиповМетаобъектов.Скопировать(ВыбранныеТипыМетаданных);
								ТаблицаТиповМетаобъектов.Сортировать("Категория");
								Если Метаданные.Справочники.Количество() > 200 Тогда
									СписокВыбораТипа = Новый СписокЗначений;
									СписокВыбораТипа.ЗагрузитьЗначения(ТаблицаТиповМетаобъектов.ВыгрузитьКолонку("Единственное"));
									Для Каждого ЭлементСписка Из СписокВыбораТипа Цикл
										ЭлементСписка.Картинка = ирКлиент.КартинкаКорневогоТипаМДЛкс(ЭлементСписка.Значение);
									КонецЦикла;
									СписокВыбораТипа.Вставить(0, "<Все>");
									ВыбранныйЭлемент = СписокВыбораТипа.ВыбратьЭлемент("Выберите тип формы для ускорения ее поиска");
									Если ВыбранныйЭлемент = Неопределено Тогда
										Возврат;
									КонецЕсли;
									СтрокаТипа = ТаблицаТиповМетаобъектов.Найти(ВыбранныйЭлемент.Значение, "Единственное");
									Если СтрокаТипа <> Неопределено Тогда
										ТаблицаТиповМетаобъектов = ирОбщий.ЗначенияВМассивЛкс(СтрокаТипа);
									КонецЕсли;
								КонецЕсли;
								РазрешитьПрерывание = Ложь; // Прерывания запрещает платформа в обработчике внешнего события. Поэтому не будем обманывать пользователя
								Для Каждого СтрокаТипаМетаОбъектов Из ТаблицаТиповМетаобъектов Цикл
									ИндикаторТипа = ирОбщий.ПолучитьИндикаторПроцессаЛкс(Метаданные[СтрокаТипаМетаОбъектов.Множественное].Количество(), "Поиск формы " + СтрокаТипаМетаОбъектов.Единственное,,, РазрешитьПрерывание);
									Для Каждого ОбъектМД Из Метаданные[СтрокаТипаМетаОбъектов.Множественное] Цикл
										#Если Сервер И Не Сервер Тогда
											ОбъектМД = Метаданные.Справочники.ирАлгоритмы;
										#КонецЕсли
										ирОбщий.ОбработатьИндикаторЛкс(ИндикаторТипа);
										Если ирОбщий.СтрНачинаетсяСЛкс(ОбъектМД.Имя, "ир", Истина) Тогда
											Продолжить;
										КонецЕсли;
										ПолноеИмяМД = ОбъектМД.ПолноеИмя();                    
										Если ЛиКорневойТипТаблицыБД Тогда
											ПолноеИмяФормы = ОбъектМД.ПолноеИмя() + ".ФормаСписка";
										Иначе
										    ПолноеИмяФормы = ОбъектМД.ПолноеИмя() + ".Форма";
										КонецЕсли;
										ЭлементКэша = КэшПоискаФорм.НайтиПоЗначению(ПолноеИмяФормы);
										Если ЭлементКэша <> Неопределено Тогда
											Продолжить;
										КонецЕсли;
										Попытка
											Форма = ирКлиент.ПолучитьФормуЛкс(ПолноеИмяФормы, ПараметрыБыстрогоСозданияФормы);
										Исключение
											Продолжить;
										КонецПопытки;
										Если Форма = Неопределено Тогда
											Продолжить;
										КонецЕсли;
										Если Форма.Открыта() Тогда
											ЭлементКэша = КэшПоискаФорм.Добавить(ПолноеИмяФормы);
											КэшПоискаФормИзменен = Истина;
											ВводДоступен = Форма.ВводДоступен(); 
										КонецЕсли;
										Если ВводДоступен Тогда
											Прервать;
										КонецЕсли;
									КонецЦикла;
									ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
									Если ВводДоступен Тогда
										Прервать;
									КонецЕсли; 
								КонецЦикла;
							КонецЕсли;
							Если ВводДоступен Тогда
								СобытиеОбработано = Истина;
								Если ЭлементКэша <> Неопределено Тогда
									ирОбщий.СостояниеЛкс();
									ИндексФормыВКэше = КэшПоискаФорм.Индекс(ЭлементКэша);
									Если ИндексФормыВКэше > 0 Тогда
										КэшПоискаФорм.Сдвинуть(ЭлементКэша, -ИндексФормыВКэше);
										КэшПоискаФормИзменен = Истина;
									КонецЕсли;
								КонецЕсли;
								ирКлиент.Форма_ВнешнееСобытиеЛкс(Форма, Источник, Событие, Данные, ВводДоступен);
							КонецЕсли;
							МаксЭлементовКэша = 1000;
							Пока КэшПоискаФорм.Количество() > МаксЭлементовКэша Цикл
								КэшПоискаФорм.Удалить(МаксЭлементовКэша);
							КонецЦикла;
							Если КэшПоискаФормИзменен Тогда
								ирОбщий.СохранитьЗначениеЛкс("КэшПоискаФорм", КэшПоискаФорм);
							КонецЕсли;
						КонецЕсли;
					#КонецЕсли
				КонецЕсли; 
				Если Не СобытиеОбработано Тогда
					ирКлиент.Форма_ВнешнееСобытиеЛкс(, Источник, Событие, Данные);
				КонецЕсли; 
			КонецЕсли; 
			//Сообщить(Данные); // Отладка
		КонецЕсли; 
	Исключение
		// Антибаг платформы https://www.hostedredmine.com/issues/890762
		Сообщить(ОписаниеОшибки(), СтатусСообщения.Внимание);
	КонецПопытки; 
	#КонецЕсли 
	
КонецПроцедуры

#КонецЕсли 

#Если Клиент И Не ТонкийКлиент И Не ВебКлиент И Не МобильныйКлиент Тогда

Процедура ОбработатьПараметрЗапускаДляВсехРежимовЛкс() Экспорт 
	
	МаркерОткрытьФорму = "ОткрытьФормуИР.";
	Если Найти(ПараметрЗапуска, МаркерОткрытьФорму) > 0 Тогда
		ИмяФормы = ирОбщий.ТекстМеждуМаркерамиЛкс(ПараметрЗапуска, МаркерОткрытьФорму, ";");
		Форма = ирКлиент.ПолучитьФормуЛкс(ИмяФормы);
		Если Форма <> Неопределено Тогда
			Форма.Открыть();
		КонецЕсли; 
	КонецЕсли;
	Если ирОбщий.СтрНачинаетсяСЛкс(ПараметрЗапуска, "ТестироватьМетаданныеИР") Тогда
		Фрагменты = ирОбщий.СтрРазделитьЛкс(ПараметрЗапуска, ";");
		Если Фрагменты.Количество() < 3 Тогда
			ВызватьИсключение ирКлиент.ОписаниеПараметраЗапускаТестированияМетаданныхЛкс();
		КонецЕсли;
		ФайлНастроек = Фрагменты[1];
		ФайлРезультата = Фрагменты[2];
		Объект = ирОбщий.СоздатьОбъектПоИмениМетаданныхЛкс("Обработка.ирТестированиеМетаданных");
		#Если Сервер И Не Сервер Тогда
			Объект = Обработки.ирТестированиеМетаданных.Создать();
		#КонецЕсли
		Форма = Объект.ПолучитьФорму();
		НастройкаФормы = ирОбщий.ЗагрузитьЗначениеИзФайлаЛкс(ФайлНастроек);
		Если НастройкаФормы = Неопределено Тогда
			ВызватьИсключение "Некорректный файл настройки формы";
		КонецЕсли;
		ирКлиент.ЗагрузитьНастройкуФормыЛкс(Форма, НастройкаФормы);
		Форма.ПроверятьФормы = Ложь;
		Форма.КнопкаВыполнитьНажатие();
		Результат = Форма.Ошибки.Скопировать(, "Метаданные, Операция, Контекст, Момент, ОписаниеОшибки, ПодробноеОписаниеОшибки");
		Текст = ирОбщий.ТаблицаЗначенийВJSONЛкс(Результат);
		ТекстДокумент = Новый ТекстовыйДокумент;
		ТекстДокумент.УстановитьТекст(Текст);
		ТекстДокумент.Записать(ФайлРезультата);
		ЗавершитьРаботуСистемы(Ложь);
		Возврат;
	КонецЕсли;

КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ ОЖИДАНИЯ

Процедура ПроверитьФормыСсылокОтложенноЛкс() Экспорт 
	ирКлиент.ПроверитьФормыСсылокЛкс();
КонецПроцедуры

Процедура ОсвободитьВсеИндикаторыПроцессовОтложенноЛкс() Экспорт
	
	ирОбщий.ОсвободитьВсеИндикаторыПроцессовЛкс();
	
КонецПроцедуры

Процедура СохранитьНастройкиПользователяОтложенноЛкс() Экспорт
	
	СохранитьНастройкиПользователя();
	
КонецПроцедуры

Процедура ВыполнитьПроверкуСовместимостиКонфигурацииЛкс() Экспорт 
	
	//мПлатформа = ирКэш.Получить();
	//#Если Сервер И Не Сервер Тогда
	//    мПлатформа = Обработки.ирПлатформа.Создать();
	//#КонецЕсли
	#Если ТолстыйКлиентОбычноеПриложение ИЛИ ТолстыйКлиентУправляемоеПриложение Тогда
		Если ирОбщий.КлючБазыВСпискеПользователяЛкс() = Неопределено Тогда 
			ирОбщий.СообщитьЛкс("База не найдена в списке баз пользователя ОС. Поэтому она НЕ использует постоянный кэш метаданных, что сильно увеличивает время запуска.", СтатусСообщения.Важное,, Истина);
		КонецЕсли;
		Если ирОбщий.ВосстановитьЗначениеЛкс("ПроверятьПодпискиКонфигурации", Истина) <> Ложь Тогда 
			ирКлиент.ПроверитьПодпискиЛкс();
		КонецЕсли; 
		#Если ТолстыйКлиентОбычноеПриложение Тогда
			Если Истина
				И Метаданные.ОсновнойРежимЗапуска = РежимЗапускаКлиентскогоПриложения.УправляемоеПриложение
				И Не Метаданные.ИспользоватьУправляемыеФормыВОбычномПриложении 
			Тогда
				Сообщить("Рекомендуется включить в свойствах конфигурации флажок ""Использовать управляемые формы в обычном приложении""");
			КонецЕсли; 
		#КонецЕсли 
	#КонецЕсли
	//#Если ТолстыйКлиентУправляемоеПриложение Тогда
	//	ирОбщий.ПроверитьФлажокИспользоватьОбычныеФормыВУправляемомПриложенииЛкс();
	//#КонецЕсли
	//Если Метаданные.ВариантВстроенногоЯзыка = Метаданные.СвойстваОбъектов.ВариантВстроенногоЯзыка.Английский Тогда
	//	Сообщить("Подсистема не полностью поддерживает вариант встроенного языка Английский.", СтатусСообщения.Внимание);
	//КонецЕсли;

КонецПроцедуры

Процедура ГлобальныйОбработчикОжиданияСПараметрамиЛкс() Экспорт 
	
	ирКлиент.ОбработчикОжиданияСПараметрамиЛкс();
	
КонецПроцедуры

Процедура ПроверитьОтмененныеФоновыеЗаданияОтложенноЛкс() Экспорт 
	
	мПлатформа = ирКэш.Получить();
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	Для Каждого Идентификатор Из мПлатформа.ОтмененныеФоновыеЗадания Цикл
		ФоновоеЗадание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(Идентификатор);
		Если ФоновоеЗадание <> Неопределено И ФоновоеЗадание.Состояние = СостояниеФоновогоЗадания.Активно Тогда
			ирОбщий.СообщитьЛкс(ирОбщий.СтрШаблонИменЛкс("Фоновое задание %1, которому была отправлена команда отмены, продолжает выполняться",, ФоновоеЗадание.Наименование + ". " + ФоновоеЗадание.Ключ),
				СтатусСообщения.Внимание); 
		КонецЕсли;
	КонецЦикла; 
	мПлатформа.ОтмененныеФоновыеЗадания.Очистить();
	
КонецПроцедуры

Процедура АктивироватьМодальныеГруппыЛкс() Экспорт 

	мПлатформа = ирКэш.Получить();
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	Для Каждого ЭлементСписка Из мПлатформа.МодальныеГруппы Цикл
		ЭлементСписка.Пометка = Истина;
	КонецЦикла;

КонецПроцедуры

Процедура ОткрытьСтруктуруАктивнойФормыЛкс(Параметры) Экспорт 
	
	ТекущаяФорма = Параметры.Форма;
	Если Параметры.Свойство("КоманднаяПанель") Тогда
		КоманднаяПанель = Параметры.КоманднаяПанель;
	КонецЕсли;
	//ТекущаяФорма = ирКлиент.АктивнаяУправляемаяФормаЛкс();
	Если ТекущаяФорма <> Неопределено Тогда   
		Если КоманднаяПанель = Неопределено Тогда
			ирКлиент.ОткрытьСтруктуруФормыЛкс(ТекущаяФорма);
		Иначе
			ирКлиент.ОткрытьСтруктуруКоманднойПанелиЛкс(ТекущаяФорма, КоманднаяПанель);
		КонецЕсли;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ИсследоватьТекущийЭлементАктивнойФормыЛкс(Параметры) Экспорт 
	
	ТекущаяФорма = Параметры.Форма;
	ТекущийЭлемент = ирКлиент.ТекущийЭлементАктивнойФормыЛкс(ТекущаяФорма);
	Если ТипЗнч(ТекущийЭлемент) = Тип("ТаблицаФормы") Тогда
		ТекущаяКолонка = ТекущийЭлемент.ТекущийЭлемент;
	ИначеЕсли ТипЗнч(ТекущийЭлемент) = Тип("ТабличноеПоле") Тогда
		ТекущаяКолонка = ТекущийЭлемент.ТекущаяКолонка;
		ИмяТекущегоСвойства = "ЭлементУправления";
	ИначеЕсли ТипЗнч(ТекущийЭлемент) = Тип("ПолеТабличногоДокумента") Тогда
		ИмяТекущегоСвойства = "ТекущаяОбласть";
	КонецЕсли; 
	Если ТекущаяКолонка <> Неопределено Тогда
		ТекущийЭлемент = ТекущаяКолонка;
	КонецЕсли;
	ирОбщий.ИсследоватьЛкс(ТекущийЭлемент,,,, ТекущийЭлемент.Имя, ИмяТекущегоСвойства, Истина);
	
КонецПроцедуры

Процедура РедактироватьОбъектАктивнойФормыЛкс(Параметры) Экспорт 

	Форма = Параметры.Форма;
	Ссылка = ирОбщий.КлючОсновногоОбъектаФормыЛкс(Форма);
	Если Ссылка <> Неопределено Тогда
		КлючСтроки = Неопределено;
		ИмяПоляБД = ирОбщий.НайтиПутьКДаннымПоляТаблицыФормыЛкс(Ссылка, Форма.ТекущийЭлемент.Имя);
		Если ТипЗнч(Форма.ТекущийЭлемент) = Тип("ТаблицаФормы") Тогда
			ИмяТЧБД = ИмяПоляБД;
			ИмяПоляБД = "";
			Если Форма.ТекущийЭлемент.ТекущийЭлемент <> Неопределено Тогда
				ИмяПоляБД = ирОбщий.ПутьКДаннымКолонкиТабличногоПоляЛкс(Форма.ТекущийЭлемент);
			КонецЕсли; 
			ДанныеТаблицыФормы = ирОбщий.ДанныеЭлементаФормыЛкс(Форма.ТекущийЭлемент);
			Если Форма.ТекущийЭлемент.ТекущаяСтрока <> Неопределено И ирОбщий.ЛиДанныеФормыСВозможностьюПоискаЛкс(ДанныеТаблицыФормы) Тогда
				КлючСтроки = Новый Структура("НомерСтроки", ДанныеТаблицыФормы.Индекс(ДанныеТаблицыФормы.НайтиПоИдентификатору(Форма.ТекущийЭлемент.ТекущаяСтрока)) + 1);
			КонецЕсли; 
		КонецЕсли; 
		//Если ПоляТаблицы.Найти(ИмяТЧБД, "Имя") = Неопределено Тогда 
		//	ИмяТЧБД = "";
		//КонецЕсли; 
		//ИмяДочернейТаблицыБД = Ссылка.Метаданные().ПолноеИмя();
		//Если ЗначениеЗаполнено(ИмяТЧБД) Тогда
		//	ИмяДочернейТаблицыБД = ИмяДочернейТаблицыБД + "." + ИмяТЧБД;
		//КонецЕсли; 
		//ПоляТаблицы = ирОбщий.ПоляТаблицыБДЛкс(ИмяДочернейТаблицыБД);
		//Если ПоляТаблицы.Найти(ИмяПоляБД, "Имя") = Неопределено Тогда 
		//	ИмяПоляБД = "";
		//КонецЕсли; 
		ирКлиент.ОткрытьСсылкуВРедактореОбъектаБДЛкс(Ссылка,, ИмяТЧБД, ИмяПоляБД, КлючСтроки);
	КонецЕсли; 

КонецПроцедуры

Процедура КопироватьСсылкуАктивнойФормыЛкс(Параметры) Экспорт 

	Форма = Неопределено;
	Ссылка = ирОбщий.КлючОсновногоОбъектаФормыЛкс(Форма);
	Если Ссылка <> Неопределено Тогда
		ирКлиент.БуферОбменаПриложения_УстановитьЗначениеЛкс(Ссылка,, ирОбщий.ВнешняяНавигационнаяСсылкаЛкс(Ссылка));
	КонецЕсли; 

КонецПроцедуры

Процедура РедактироватьОбъектСтрокиАктивнойФормыЛкс(Параметры) Экспорт 

	КлючТекущейСтроки = Неопределено;
	Форма = Параметры.Форма;
	ирКлиент.КлючиСтрокБДИзТаблицыФормыЛкс(Форма, КлючТекущейСтроки);
	Если КлючТекущейСтроки <> Неопределено Тогда
		ДанныеКолонки = ирОбщий.ПутьКДаннымКолонкиТабличногоПоляЛкс(Форма.ТекущийЭлемент);
		ирКлиент.ОткрытьСсылкуВРедактореОбъектаБДЛкс(КлючТекущейСтроки,,, ДанныеКолонки);
	КонецЕсли; 

КонецПроцедуры

Процедура РедактироватьОбъектТекущегоПоляАктивнойФормыЛкс(Параметры) Экспорт 
	
	КлючТекущейСтроки = Неопределено;
	ирКлиент.ЗначенияВыделенныхЯчеекТаблицыЛкс(Параметры.Форма, КлючТекущейСтроки);
	Если КлючТекущейСтроки <> Неопределено Тогда
		ирКлиент.ОткрытьСсылкуВРедактореОбъектаБДЛкс(КлючТекущейСтроки);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОткрытьОбъектТекущегоПоляАктивнойФормыЛкс(Параметры) Экспорт 
	
	КлючТекущейСтроки = Неопределено;
	ирКлиент.ЗначенияВыделенныхЯчеекТаблицыЛкс(Параметры.Форма, КлючТекущейСтроки,, Ложь);
	Если КлючТекущейСтроки <> Неопределено Тогда
		ирКлиент.ОткрытьЗначениеЛкс(КлючТекущейСтроки,,,, Ложь);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбработатьОбъектыАктивнойФормыЛкс(Параметры) Экспорт 

	КлючТекущейСтроки = Неопределено;
	ТаблицаФормыДинамическогоСписка = Неопределено;
	Ссылки = ирКлиент.КлючиСтрокБДИзТаблицыФормыЛкс(Параметры.Форма, КлючТекущейСтроки, ТаблицаФормыДинамическогоСписка);
	Если Ссылки.Количество() > 0 Тогда
		Если ТаблицаФормыДинамическогоСписка <> Неопределено Тогда
			ирКлиент.ОткрытьПодборИОбработкуОбъектовИзДинамическогоСпискаЛкс(ТаблицаФормыДинамическогоСписка,, Ссылки);
		Иначе
			ирКлиент.ОткрытьМассивОбъектовВПодбореИОбработкеОбъектовЛкс(Ссылки,,,, КлючТекущейСтроки);
		КонецЕсли; 
	КонецЕсли; 

КонецПроцедуры

Процедура ОбработатьОбъектыТекущегоПоляАктивнойФормыЛкс(Параметры) Экспорт 

	КлючТекущейСтроки = Неопределено;
	Ссылки = ирКлиент.ЗначенияВыделенныхЯчеекТаблицыЛкс(Параметры.Форма, КлючТекущейСтроки);
	Если Ссылки.Количество() > 0 Тогда
		ирКлиент.ОткрытьМассивОбъектовВПодбореИОбработкеОбъектовЛкс(Ссылки,,,, КлючТекущейСтроки);
	КонецЕсли; 

КонецПроцедуры

Процедура ОткрытьТаблицуАктивнойФормыЛкс(Параметры) Экспорт 

	ирКлиент.ОткрытьТаблицуЗначенийИзАктивнойУправляемойФормыЛкс(Параметры.Форма);

КонецПроцедуры

Процедура НастроитьКолонкиТаблицыАктивнойФормыЛкс(Параметры) Экспорт 
	
	Форма = Параметры.Форма;
	ТекущийЭлемент = ирКлиент.ТекущийЭлементАктивнойФормыЛкс(Форма);
	Если Истина
		И ТипЗнч(ТекущийЭлемент) <> Тип("ТаблицаФормы") 
		И ТипЗнч(ТекущийЭлемент) <> Тип("ТабличноеПоле")
	Тогда
		Возврат;
	КонецЕсли; 
	ирКлиент.ОткрытьНастройкуКолонокТабличногоПоляЛкс(Форма, ТекущийЭлемент);

КонецПроцедуры

Процедура ОткрытьТабличныйДокументАктивнойФормыЛкс(Параметры) Экспорт 

	ирКлиент.ОткрытьТабличныйДокументИзАктивнойФормыЛкс(Параметры.Форма);

КонецПроцедуры

Процедура СравнитьТаблицуАктивнойФормыЛкс(Параметры) Экспорт 

	ирКлиент.ЗапомнитьСодержимоеЭлементаАктивнойФормыДляСравненияЛкс(Параметры.Форма);

КонецПроцедуры

Процедура ОткрытьРазличныеЗначенияКолонкиАктивнойФормыЛкс(Параметры) Экспорт 

	ирКлиент.ОткрытьРазличныеЗначенияКолонкиАктивнойУправляемойФормыЛкс(Параметры.Форма);

КонецПроцедуры

Процедура УстановитьЗначениеВКолонкеАктивнойФормыЛкс(Параметры) Экспорт 

	Форма = Параметры.Форма;
	ТекущийЭлемент = ирКлиент.ТекущийЭлементАктивнойФормыЛкс(Форма);
	Если Истина
		И ТипЗнч(ТекущийЭлемент) <> Тип("ТаблицаФормы") 
		И ТипЗнч(ТекущийЭлемент) <> Тип("ТабличноеПоле")
	Тогда
		Возврат;
	КонецЕсли; 
	ирКлиент.ОткрытьМенеджерТабличногоПоляЛкс(ТекущийЭлемент, Форма, "Обработка");

КонецПроцедуры

Процедура ЗагрузитьДанныеВТабличноеПолеАктивнойФормыЛкс(Параметры) Экспорт 

	Форма = Параметры.Форма;
	ТабличноеПоле = ирКлиент.ТекущийЭлементАктивнойФормыЛкс(Форма);
	ирКлиент.ЗагрузитьСтрокиВТабличноеПолеЛкс(Форма, ТабличноеПоле,,,, Форма);

КонецПроцедуры

Процедура ОтладитьКомпоновкуДанныхАктивнойФормыЛкс(Параметры) Экспорт 

	ирКлиент.ОтладитьКомпоновкуДанныхАктивнойУправляемойФормыЛкс(Параметры.Форма);

КонецПроцедуры 

Процедура ОтладитьПостроительОтчетаАктивнойФормыЛкс(Параметры) Экспорт 

	ирОбщий.ОтладитьЛкс(Параметры.Форма.ПостроительОтчета);

КонецПроцедуры

Процедура РедактироватьАктивныйСписокЗначенийЛкс(Параметры) Экспорт 

	ирКлиент.РедактироватьАктивныйСписокЗначенийУправляемыйЛкс(Параметры.Форма);

КонецПроцедуры

Процедура НастроитьДинамическийСписокАктивнойФормыЛкс(Параметры) Экспорт 

	ирКлиент.НастроитьДинамическийСписокАктивнойУправляемойФормыЛкс(Параметры.Форма);

КонецПроцедуры

Процедура ОткрытьДинамическийСписокАктивнойФормыЛкс(Параметры) Экспорт 

	ирКлиент.ОткрытьДинамическийСписокАктивнойУправляемойФормыЛкс(Параметры.Форма);

КонецПроцедуры

Процедура НайтиВыбратьСсылкуВДинамическомСпискеАктивнойФормыЛкс(Параметры) Экспорт 

	ирКлиент.НайтиВыбратьСсылкуВДинамическомСпискеЛкс(Параметры.Форма);

КонецПроцедуры

Процедура ОткрытьМенеджерТабличногоПоляАктивнойФормыЛкс(Параметры) Экспорт 

	ирКлиент.ОткрытьМенеджерТабличногоПоляЛкс(, Параметры.Форма);

КонецПроцедуры

Процедура СообщитьКоличествоСтрокАктивнойТаблицыЛкс(Параметры) Экспорт 

	ирКлиент.ТабличноеПолеИлиТаблицаФормы_СколькоСтрокЛкс(Параметры.Форма.ТекущийЭлемент);

КонецПроцедуры

Процедура СравнитьСтрокиАктивнойФормыЛкс(Параметры) Экспорт 

	ирКлиент.ТабличноеПолеИлиТаблицаФормы_СравнитьСтрокиЛкс(Параметры.Форма, Параметры.Форма.ТекущийЭлемент);

КонецПроцедуры

Процедура ВставитьСкопированнуюСсылкуАктивнойФормыЛкс(Параметры) Экспорт 

	ирКлиент.БуферОбмена_ВставитьЛкс(Параметры.Форма);

КонецПроцедуры

Процедура НайтиСкопированнуюСсылкуВТаблицеАктивнойФормыЛкс(Параметры) Экспорт 

	ирКлиент.НайтиСсылкуИзБуфераВТаблицеФормыЛкс(Параметры.Форма);

КонецПроцедуры

Процедура КопироватьСсылкуАктивнойСтрокиАктивнойФормыЛкс(Параметры) Экспорт 

	ирКлиент.КопироватьСсылкуАктивнойСтрокиФормыЛкс(Параметры.Форма);

КонецПроцедуры

Процедура КопироватьСсылкиЯчеекАктивнойФормыЛкс(Параметры) Экспорт 

	ирКлиент.КопироватьСсылкиЯчеекФормыЛкс(Параметры.Форма);

КонецПроцедуры

Процедура СравнитьСкопированнуюСсылкуСЯчейкойАктивнойФормыЛкс(Параметры) Экспорт 

	Ссылки = ирКлиент.ЗначенияВыделенныхЯчеекТаблицыЛкс(Параметры.Форма);
	Если Ссылки <> Неопределено Тогда
		Значение = ирКлиент.ЗначениеИзБуфераОбменаЛкс();
		ирКлиент.Сравнить2ЗначенияВФормеЛкс(Значение, Ссылки[0]);
	КонецЕсли;

КонецПроцедуры  

Процедура СравнитьСкопированнуюСсылкуСКлючомСтрокиАктивнойФормыЛкс(Параметры) Экспорт 

	КлючТекущейСтроки = Неопределено;
	ирКлиент.КлючиСтрокБДИзТаблицыФормыЛкс(Параметры.Форма, КлючТекущейСтроки);
	Если КлючТекущейСтроки <> Неопределено Тогда
		Значение = ирКлиент.ЗначениеИзБуфераОбменаЛкс();
		ирКлиент.Сравнить2ЗначенияВФормеЛкс(Значение, КлючТекущейСтроки);
	КонецЕсли;

КонецПроцедуры

Процедура СравнитьСкопированнуюСсылкуСАктивнойФормойЛкс(Параметры) Экспорт 

	КлючОсновногоОбъекта = ирОбщий.КлючОсновногоОбъектаФормыЛкс(Параметры.Форма);
	Если КлючОсновногоОбъекта <> Неопределено Тогда
		Значение = ирКлиент.ЗначениеИзБуфераОбменаЛкс();
		ирКлиент.Сравнить2ЗначенияВФормеЛкс(Значение, КлючОсновногоОбъекта);
	КонецЕсли;

КонецПроцедуры

Процедура ОткрытьТекстАктивнойФормыЛкс(Параметры) Экспорт 

	АктивнаяФорма = Параметры.Форма;
	Текст = ирКлиент.Форма_ЗначениеТекущегоПоляЛкс(АктивнаяФорма);
	ирКлиент.ОткрытьТекстЛкс(Текст,, "",,, АктивнаяФорма.ТекущийЭлемент);

КонецПроцедуры

// Антибаг платформы https://www.hostedredmine.com/issues/929519
// В некоторых случаях не помогает. При проблемах заменить на УстановитьФокусВводаФормеЛкс()
// 8мс
Процедура ВосстановитьФокусВводаГлЛкс() Экспорт 
	
	ирКлиент.ОткрытьИЗакрытьПустуюФормуЛкс(); 
	
КонецПроцедуры

// Антибаг платформы https://www.hostedredmine.com/issues/926161
Процедура АктивироватьАктивнуюФормуЛкс() Экспорт 
	
	АктивнаяФорма = ирКлиент.АктивнаяФормаЛкс();
	Если АктивнаяФорма = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ирКлиент.ОткрытьИЗакрытьПустуюФормуЛкс(); 
	ирКлиент.Форма_АктивироватьОткрытьЛкс(АктивнаяФорма);

КонецПроцедуры

#КонецЕсли     

//#КонецОбласти
