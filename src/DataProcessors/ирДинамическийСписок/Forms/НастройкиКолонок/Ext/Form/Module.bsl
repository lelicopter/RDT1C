﻿Перем мПлатформа;
Перем СтароеКонтекстноеМеню;
Перем СтароеАвтоконтекстноеМеню;
Перем ВременноеКонтекстноеМеню;

Процедура ОсновныеДействияФормыПробовать(Кнопка = Неопределено)

	Если Не ПрименятьСразу И Кнопка = Неопределено Тогда
		Возврат;
	КонецЕсли;    
	ЭтаФорма.Модифицированность = Истина;
	ПодключитьОбработчикОжидания("ПрименитьНастройки", 0.1, Истина);
	
КонецПроцедуры

Процедура ПрименитьНастройки()
	ОбновитьСвязанноеТабличноеПоле();
КонецПроцедуры

Процедура ОбновитьСвязанноеТабличноеПоле(Восстановить = Ложь)
	
	Если Восстановить Тогда
		ЭтаФорма.Результат = Новый Структура;
		Результат.Вставить("ПрименятьПорядок", ПрименятьПорядок);
		Результат.Вставить("Сохранить", Ложь);
		Результат.Вставить("НастройкиКолонок", НастройкиКолонок.Выгрузить());
	Иначе
		ПолучитьРезультат(Ложь); 
	КонецЕсли;
	Если СвязанноеТабличноеПоле <> Неопределено Тогда
		СтарыеНастройки = НастройкиКолонок.Выгрузить();
		ПрименитьНастройкиКолонокКТабличномуПолю(СвязанноеТабличноеПоле, Результат);
		Если Не Результат.Сохранить Тогда
			НастройкиКолонок.Загрузить(СтарыеНастройки);
		КонецЕсли; 
	Иначе
		Если Не Результат.Сохранить Тогда
			ОповеститьСвязаннуюТаблицуФормы(Результат); 
		КонецЕсли;
	КонецЕсли;
	ДействияФормыАктивизироватьКолонку();

КонецПроцедуры

Процедура ОсновныеДействияФормыПрименитьИЗакрыть(Кнопка = Неопределено)
	
	Если Модифицированность И Не ПрименятьСразу Тогда
		ОбновитьСвязанноеТабличноеПоле();
	КонецЕсли;
	ЭтаФорма.Модифицированность = Ложь; 
	Закрыть(ПолучитьРезультат(Истина));
	
	//Если ПараметрРучноеСохранение Тогда 
	//	ОбщийТипИсточника = ирОбщий.ОбщийТипДанныхТабличногоПоляЛкс(СвязанноеТабличноеПоле);
	//	КнопкаЭталон = ирКэш.ФормаОбщихКомандЛкс().ЭлементыФормы.Команды.Кнопки.Найти("НастройкаСписка" + ОбщийТипИсточника); // НастройкаСпискаСписок
	//	Если КнопкаЭталон <> Неопределено Тогда
	//		СтароеКонтекстноеМеню = СвязанноеТабличноеПоле.КонтекстноеМеню;
	//		СтароеАвтоконтекстноеМеню = СвязанноеТабличноеПоле.АвтоконтекстноеМеню;
	//		ВременноеКонтекстноеМеню = ВладелецФормы.ЭлементыФормы.Добавить(Тип("КоманднаяПанель"), "ВременноеКонтекстноеМеню" + ирОбщий.СуффиксСлужебногоСвойстваЛкс(), Ложь);
	//		ВременноеКонтекстноеМеню.ИсточникДействий = СвязанноеТабличноеПоле;
	//		СвязанноеТабличноеПоле.КонтекстноеМеню = ВременноеКонтекстноеМеню;
	//		СвязанноеТабличноеПоле.АвтоконтекстноеМеню = Ложь;
	//		ВременноеКонтекстноеМеню.Кнопки.Добавить(, ТипКнопкиКоманднойПанели.Действие,, КнопкаЭталон.Действие); 
	//		ВладелецФормы.Активизировать();
	//		ирКлиент.ОтправитьНажатияКлавишЛкс("+{F10}", Истина);
	//		#Если Сервер И Не Сервер Тогда
	//			ЭмулироватьОткрытиеНастройкиСписка();
	//			ирКлиент.ВыполнитьМетодОбъектаЛкс();
	//		#КонецЕсли
	//		ПараметрыОбработчика = Новый Структура;
	//		ПараметрыОбработчика.Вставить("Объект", ЭтаФорма);
	//		ПараметрыОбработчика.Вставить("МетодОбъекта", "ЭмулироватьОткрытиеНастройкиСписка");
	//		ирКлиент.ПодключитьОбработчикОжиданияСПараметрамиЛкс("ирКлиент.ВыполнитьМетодОбъектаЛкс", ПараметрыОбработчика, 0.2, Истина);
	//	КонецЕсли;
	//КонецЕсли;
	
КонецПроцедуры

//Процедура ЭмулироватьОткрытиеНастройкиСписка() Экспорт 
//	ирКлиент.ОтправитьНажатияКлавишЛкс("{ENTER}", Истина);
//	#Если Сервер И Не Сервер Тогда
//		ЭмулироватьПрименениеНастройкиСписка();
//	#КонецЕсли
//	ПараметрыОбработчика = Новый Структура;
//	ПараметрыОбработчика.Вставить("Объект", ЭтаФорма);
//	ПараметрыОбработчика.Вставить("МетодОбъекта", "ЭмулироватьПрименениеНастройкиСписка");
//	ирКлиент.ПодключитьОбработчикОжиданияСПараметрамиЛкс("ирКлиент.ВыполнитьМетодОбъектаЛкс", ПараметрыОбработчика, 0.1, Истина);
//КонецПроцедуры

//Процедура ЭмулироватьПрименениеНастройкиСписка() Экспорт 
//	ирКлиент.ОтправитьНажатияКлавишЛкс("^{ENTER}", Истина);
//	ВладелецФормы.ЭлементыФормы.Удалить(ВременноеКонтекстноеМеню);
//	СвязанноеТабличноеПоле.КонтекстноеМеню = СтароеКонтекстноеМеню;
//	СвязанноеТабличноеПоле.АвтоконтекстноеМеню = СтароеАвтоконтекстноеМеню;
//КонецПроцедуры

Функция ПолучитьРезультат(Сохранить)
	
	ЭтаФорма.Результат = Новый Структура;
	Результат.Вставить("ПрименятьПорядок", ПрименятьПорядок);
	Результат.Вставить("Сохранить", Сохранить);
	Если Не Сохранить И ПрименятьСразу Тогда
		Результат.Вставить("НастройкиКолонок", ОбработкаОбъектСлужебная.НастройкиКолонок.Выгрузить());
	КонецЕсли;
	Возврат Результат;

КонецФункции

Процедура ПриОткрытии()
	
	ирКлиент.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ЭтаФорма.ЗакрыватьПриВыборе = Ложь;
	ЭлементыФормы.НадписьСохранениеНастроек.Видимость = ПараметрРучноеСохранение;
	Если СвязанноеТабличноеПоле = Неопределено Тогда
		ЭлементыФормы.НастройкиКолонок.Колонки.Ширина.ПодсказкаВШапке = 
			"Если ширина колонок в связанной таблице формы не меняется, выполни команду ""Установить стандартные настройки"" в окне ""Настроить форму"" чтобы удалить пользовательскую ширину.";
	КонецЕсли;
	ЭлементыФормы.ДействияФормы.Кнопки.ЗагрузитьПорядокИзОсновнойФормы.Доступность = ЗначениеЗаполнено(ПолноеИмяТаблицы);
	ОбработкаОбъектСлужебная.НастройкиКолонок.Загрузить(НастройкиКолонок.Выгрузить());
	
	ПоляТаблицы = Неопределено;
	Если ЗначениеЗаполнено(ПолноеИмяТаблицы) Тогда
		ПоляТаблицы = ирКэш.ПоляТаблицыБДЛкс(ПолноеИмяТаблицы);
		#Если Сервер И Не Сервер Тогда
			ПоляТаблицы = Новый ТаблицаЗначений;
		#КонецЕсли
	ИначеЕсли СвязанноеТабличноеПоле <> Неопределено Тогда 
		ТаблицаЗначений = ирКлиент.ТаблицаИлиДеревоЗначенийИзТаблицыФормыСКоллекциейЛкс(СвязанноеТабличноеПоле, Новый Массив,,,,, ВладелецФормы);
		Если ТаблицаЗначений <> Неопределено Тогда
			ПоляТаблицы = ТаблицаЗначений.Колонки;
		КонецЕсли;
	КонецЕсли;
	Если ПоляТаблицы <> Неопределено Тогда 
		Для Каждого СтрокаНастройкиКолонки Из ОбработкаОбъектСлужебная.НастройкиКолонок Цикл
			ИмяПоляТаблицы = СтрокаНастройкиКолонки.Имя;
			Если СвязанноеТабличноеПоле <> Неопределено Тогда
				ИмяПоляТаблицы = СвязанноеТабличноеПоле.Колонки[ИмяПоляТаблицы].Данные;
			КонецЕсли;
			ДоступноеПоле = ПоляТаблицы.Найти(ИмяПоляТаблицы);
			#Если Сервер И Не Сервер Тогда
				ДоступноеПоле = Обработки.ирТипПолеБД.Создать();
			#КонецЕсли
			Если ДоступноеПоле = Неопределено Тогда
				Продолжить;
			КонецЕсли; 
			СтрокаНастройкиКолонки.ТипЗначения = ирОбщий.РасширенноеПредставлениеЗначенияЛкс(ДоступноеПоле.ТипЗначения);
		КонецЦикла;
	КонецЕсли;
	
	Если СвязанноеТабличноеПоле <> Неопределено Тогда
		ТекущаяКолонка = ирКлиент.ТабличноеПолеТекущаяКолонкаЛкс(СвязанноеТабличноеПоле);
		Если Не ЗначениеЗаполнено(ПараметрИмяТекущейКолонки) И ТекущаяКолонка <> Неопределено Тогда
			ПараметрИмяТекущейКолонки = ТекущаяКолонка.Имя;
		КонецЕсли; 
	КонецЕсли;
	СтрокаТекущейКолонки = ОбработкаОбъектСлужебная.НастройкиКолонок.Найти(ПараметрИмяТекущейКолонки, "Имя");
	Если СтрокаТекущейКолонки <> Неопределено Тогда
		ЭлементыФормы.НастройкиКолонок.ТекущаяСтрока = СтрокаТекущейКолонки;
	КонецЕсли;
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	ЭлементыФормы.НастройкиКолонок.Колонки.Положение.ЭлементУправления.СписокВыбора = мПлатформа.ДоступныеЗначенияТипа("ПоложениеКолонки");
	ЭлементыФормы.НастройкиКолонок.Колонки.Положение.Видимость = ТипЗнч(ВладелецФормы) <> Тип("УправляемаяФорма");
	КлсКомандаНажатие(ЭлементыФормы.ДействияФормы.Кнопки.ПоказыватьИтоги);
	НастроитьЭлементыФормы();
	
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирКлиент.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ДействияФормыАктивизироватьКолонку(Кнопка = Неопределено)
	
	ПодключитьОбработчикОжидания("АктивизироватьКолонку", 0.1, Истина);
	
КонецПроцедуры

Процедура АктивизироватьКолонку()
	
	Если ЭлементыФормы.НастройкиКолонок.ТекущаяСтрока = Неопределено Или Не ЭлементыФормы.НастройкиКолонок.ТекущаяСтрока.Видимость Тогда
		Возврат;
	КонецЕсли;   
	Если СвязанноеТабличноеПоле <> Неопределено Тогда
		ИмяКолонки = ЭлементыФормы.НастройкиКолонок.ТекущаяСтрока.Имя;
		КолонкаТП = СвязанноеТабличноеПоле.Колонки.Найти(ИмяКолонки);
		Если КолонкаТП.Видимость Тогда
			ирКлиент.ТабличноеПолеУстановитьТекущуюКолонкуЛкс(СвязанноеТабличноеПоле, КолонкаТП);
		КонецЕсли;
	Иначе
		ОповеститьСвязаннуюТаблицуФормы();
	КонецЕсли;
	
КонецПроцедуры


Процедура ОповеститьСвязаннуюТаблицуФормы(Знач Оповещение = Неопределено)
	
	Если Оповещение = Неопределено Тогда
		Оповещение = Новый Структура;
	КонецЕсли;
	Оповещение.Вставить("ТекущаяКолонка", ЭлементыФормы.НастройкиКолонок.ТекущаяСтрока.Имя);
	ОповеститьОВыборе(Оповещение);

КонецПроцедуры

Процедура НастройкиКолонокВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если Ложь
		Или Колонка = ЭлементыФормы.НастройкиКолонок.Колонки.Имя 
		Или Колонка = ЭлементыФормы.НастройкиКолонок.Колонки.Заголовок
	Тогда
		СтандартнаяОбработка = Ложь;
		ДействияФормыАктивизироватьКолонку();
	КонецЕсли; 
	
КонецПроцедуры

Процедура НастройкиКолонокПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

Процедура НастройкиКолонокПередНачаломДобавления(Элемент, Отказ, Копирование)
	
	Отказ = Истина;
	
КонецПроцедуры

Процедура ДействияФормыПереместитьВверх(Кнопка)
	
	ПорядокИзменен = ирКлиент.ТабличноеПолеСдвинутьВыделенныеСтрокиЛкс(ЭлементыФормы.НастройкиКолонок, -1);
	Если ПорядокИзменен Тогда
		ЭтаФорма.ПрименятьПорядок = Истина;
		ОсновныеДействияФормыПробовать();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДействияФормыПереместитьВниз(Кнопка)
	
	ПорядокИзменен = ирКлиент.ТабличноеПолеСдвинутьВыделенныеСтрокиЛкс(ЭлементыФормы.НастройкиКолонок, +1);
	Если ПорядокИзменен Тогда
		ЭтаФорма.ПрименятьПорядок = Истина;
		ОсновныеДействияФормыПробовать();
	КонецЕсли; 

КонецПроцедуры

Процедура ДействияФормыВНачало(Кнопка)
	
	ПорядокИзменен = ирКлиент.ТабличноеПолеСдвинутьВыделенныеСтрокиЛкс(ЭлементыФормы.НастройкиКолонок, -100000);
	Если ПорядокИзменен Тогда
		ЭтаФорма.ПрименятьПорядок = Истина;
		ОсновныеДействияФормыПробовать();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДействияФормыВКонец(Кнопка)
	ПорядокИзменен = ирКлиент.ТабличноеПолеСдвинутьВыделенныеСтрокиЛкс(ЭлементыФормы.НастройкиКолонок, +100000);
	Если ПорядокИзменен Тогда
		ЭтаФорма.ПрименятьПорядок = Истина;
		ОсновныеДействияФормыПробовать();
	КонецЕсли; 
КонецПроцедуры

Процедура НастройкиКолонокПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Колонка)
	
	СтандартнаяОбработка = ПараметрыПеретаскивания.Действие <> ДействиеПеретаскивания.Копирование;
	ЭтаФорма.ПрименятьПорядок = Истина;
	ОсновныеДействияФормыПробовать();
	
КонецПроцедуры

Процедура НастройкиКолонокПриАктивизацииСтроки(Элемент)
	
	ирКлиент.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	ДействияФормыАктивизироватьКолонку();
	
КонецПроцедуры

Процедура НастройкиКолонокПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ОформлениеСтроки.Ячейки.Видимость.ТолькоПросмотр = Не ДанныеСтроки.ВидимостьРазрешено;
	ирКлиент.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки,,, Новый Структура("ТипЗначения"));

КонецПроцедуры

Процедура ДействияФормыЗагрузитьПорядокИзОсновнойФормы(Кнопка)
	
	Если ЗначениеЗаполнено(СсылкаОбъекта) Тогда
		Форма = СсылкаОбъекта.ПолучитьФорму();
	ИначеЕсли ЗначениеЗаполнено(ПолноеИмяТаблицы) Тогда 
		Форма = ирКлиент.ПолучитьФормуСпискаЛкс(ПолноеИмяТаблицы,, Ложь, ВладелецФормы, РежимВыбора);
	КонецЕсли; 
	Если Форма = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если ТипЗнч(Форма) = Тип("Форма") Тогда
		ТабличноеПоле = Неопределено;
		Для Каждого ЭлементФормы Из Форма.ЭлементыФормы Цикл
			Если Истина
				И  ТипЗнч(ЭлементФормы) = Тип("ТабличноеПоле")
				И (Ложь
					Или Не ЗначениеЗаполнено(СсылкаОбъекта)
					Или Найти(НРег(ЭлементФормы.Имя), НРег(ирОбщий.ПоследнийФрагментЛкс(ПолноеИмяТаблицы))) > 0)
			Тогда
				ТабличноеПоле = ЭлементФормы;
				Прервать;
			КонецЕсли; 
		КонецЦикла;
	Иначе
		ТабличноеПоле = Неопределено;
		Для Каждого ЭлементФормы Из Форма.Элементы Цикл
			Если Истина
				И  ТипЗнч(ЭлементФормы) = Тип("ТаблицаФормы")
				И (Ложь
					Или Не ЗначениеЗаполнено(СсылкаОбъекта)
					Или Найти(НРег(ЭлементФормы.Имя), НРег(ирОбщий.ПоследнийФрагментЛкс(ПолноеИмяТаблицы))) > 0)
			Тогда
				ТабличноеПоле = ЭлементФормы;
				Прервать;
			КонецЕсли; 
		КонецЦикла;
	КонецЕсли; 
	Если ТабличноеПоле <> Неопределено Тогда
		СтрокаКолонкиКартинка = ЭлементыФормы.НастройкиКолонок.Значение.Найти("Картинка", "Имя");
		Если СтрокаКолонкиКартинка <> Неопределено Тогда
			ЭлементыФормы.НастройкиКолонок.Значение.Сдвинуть(СтрокаКолонкиКартинка, -ЭлементыФормы.НастройкиКолонок.Значение.Индекс(СтрокаКолонкиКартинка));
		КонецЕсли; 
		Счетчик = 0;
		Для Каждого КолонкаТП Из ирКлиент.КолонкиТаблицыФормыИлиТабличногоПоляЛкс(ТабличноеПоле) Цикл
			ДанныеКолонки = ирОбщий.ПутьКДаннымКолонкиТабличногоПоляЛкс(ТабличноеПоле, КолонкаТП);
			Если ЗначениеЗаполнено(ДанныеКолонки) Тогда
				СтрокаКолонки = ЭлементыФормы.НастройкиКолонок.Значение.Найти(ДанныеКолонки, "Имя");
			ИначеЕсли КолонкаТП.Имя = "Картинка" Тогда
				СтрокаКолонки = ЭлементыФормы.НастройкиКолонок.Значение.Найти(КолонкаТП.Имя, "Имя");
			КонецЕсли;
			Если СтрокаКолонки <> Неопределено Тогда
				ЭлементыФормы.НастройкиКолонок.Значение.Сдвинуть(СтрокаКолонки, -ЭлементыФормы.НастройкиКолонок.Значение.Индекс(СтрокаКолонки)+Счетчик);
				Счетчик = Счетчик + 1;
			КонецЕсли; 
		КонецЦикла;
		ЭтаФорма.ПрименятьПорядок = Истина;
		ОсновныеДействияФормыПробовать();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирКлиент.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирКлиент.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирКлиент.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура НастройкиКолонокПриИзмененииФлажка(Элемент, Колонка)
	
	ирКлиент.ТабличноеПолеПриИзмененииФлажкаЛкс(ЭтаФорма, Элемент, Колонка);
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	Если Истина
		И ЭтаФорма.Модифицированность
		//И (Ложь
		//	Или Результат = Неопределено 
		//	Или Не Результат.Сохранить)
	Тогда
		ОбновитьСвязанноеТабличноеПоле(Истина);
	КонецЕсли;
	ирКлиент.Форма_ПриЗакрытииЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура НастройкиКолонокВидимостьПриИзменении(Элемент)
	ОсновныеДействияФормыПробовать();
КонецПроцедуры

Процедура НастройкиКолонокАвтовысотаПриИзменении(Элемент)
	ОсновныеДействияФормыПробовать();
КонецПроцедуры

Процедура НастройкиКолонокВысотаЯчейкиПриИзменении(Элемент)
	ОсновныеДействияФормыПробовать();
КонецПроцедуры

Процедура НастройкиКолонокШиринаПриИзменении(Элемент)
	ОсновныеДействияФормыПробовать();
КонецПроцедуры

Процедура НастройкиКолонокПоложениеПриИзменении(Элемент)
	ОсновныеДействияФормыПробовать();
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если Не ПрименятьСразу Тогда
		Ответ = ирКлиент.ЗапроситьСохранениеДанныхФормыЛкс(ЭтаФорма, Отказ);
		Если Ответ = КодВозвратаДиалога.Да Тогда
			ОсновныеДействияФормыПрименитьИЗакрыть();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПрименятьСразуПриИзменении(Элемент = Неопределено)
	
	Если Модифицированность И ПрименятьСразу Тогда
		ОбновитьСвязанноеТабличноеПоле();
	КонецЕсли;
	НастроитьЭлементыФормы();
	
КонецПроцедуры

Процедура НастроитьЭлементыФормы()
	
	ЭлементыФормы.ОсновныеДействияФормы.Кнопки.Пробовать.Доступность = Не ПрименятьСразу;

КонецПроцедуры

Процедура ПрименятьПорядокПриИзменении(Элемент)
	Если ПрименятьПорядок Тогда
		ОсновныеДействияФормыПробовать();
	КонецЕсли;
КонецПроцедуры

Процедура ОбновитьОтбор()
	
	Реквизиты = Метаданные().ТабличныеЧасти.НастройкиКолонок.Реквизиты;
	КолонкиПоиска = Новый Структура;
	КолонкиПоиска.Вставить(Реквизиты.Заголовок.Имя);
	ирКлиент.ТабличноеПолеСДаннымиПоискаУстановитьОтборПоПодстрокеЛкс(ЭтаФорма, ЭлементыФормы.НастройкиКолонок, ПодстрокаПоиска, КолонкиПоиска);

КонецПроцедуры

Процедура ПодстрокаПоискаПриИзменении(Элемент)
	ирКлиент.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
	ОбновитьОтбор();
КонецПроцедуры

Процедура ПодстрокаПоискаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	ирОбщий.ПолеВводаСИсториейВыбора_ОбновитьСписокЛкс(Элемент, ЭтаФорма);
КонецПроцедуры

Процедура ПодстрокаПоискаАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	Если ирКлиент.ПромежуточноеОбновлениеСтроковогоЗначенияПоляВводаЛкс(ЭтаФорма, Элемент, Текст) Тогда 
		ОбновитьОтбор();
	КонецЕсли;
КонецПроцедуры

ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирДинамическийСписок.Форма.НастройкиКолонок");

мПлатформа = ирКэш.Получить();
ПрименятьСразу = Истина;