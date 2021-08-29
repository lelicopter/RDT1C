﻿Перем ПолеТекстаПрограммы;
Перем мЗначенияПараметров;

Процедура ПередЗаписью(Отказ)
	
	Если Не ПроверитьДанные() Тогда 
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	СинтаксическийКонтрольПередЗаписью = ирКэш.Получить().СинтаксическийКонтрольПередЗаписью;
	Если СинтаксическийКонтрольПередЗаписью = Истина Тогда
		ОбновитьКонтекстПодсказкиИПолучитьСтруктуруПараметров();
		Если Не ПолеТекстаПрограммы.ПроверитьПрограммныйКод() Тогда 
			Ответ = Вопрос("При проверке текста алгоритма обнаружены ошибки. Продолжить?", РежимДиалогаВопрос.ОКОтмена);
			Если Ответ = КодВозвратаДиалога.Отмена Тогда
				Отказ = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	Если Не Отказ Тогда
		ТекстАлгоритма = ПолеТекстаПрограммы.ПолеТекста.ПолучитьТекст();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриИзмененииДанных()
	
	ПолеТекстаПрограммы.ПолеТекста.УстановитьТекст(ТекстАлгоритма);
	
КонецПроцедуры

Функция ОбновитьКонтекстПодсказкиИПолучитьСтруктуруПараметров()

	ирОбщий.ИнициироватьГлобальныйКонтекстПодсказкиЛкс(ПолеТекстаПрограммы);
	
	// Локальный
	СтруктураПараметров = Новый Структура;
	Для Каждого СтрокаПараметра Из Параметры Цикл
		СтруктураПараметров.Вставить(СтрокаПараметра.Имя, СтрокаПараметра.Значение);
		Если СтрокаПараметра.Значение <> Неопределено Тогда
			МассивТипов = Новый Массив;
			МассивТипов.Добавить(ТипЗнч(СтрокаПараметра.Значение));
			ПолеТекстаПрограммы.ДобавитьСловоЛокальногоКонтекста(
				СтрокаПараметра.Имя, "Свойство", Новый ОписаниеТипов(МассивТипов), , , СтрокаПараметра.Значение);
		КонецЕсли;
		//Если Не ПустаяСтрока(СтрокаПараметра.ДопустимыеТипы) Тогда 
			ПолеТекстаПрограммы.ДобавитьПеременнуюЛокальногоКонтекста(
				СтрокаПараметра.Имя, СтрокаПараметра.ДопустимыеТипы);
		//КонецЕсли;
	КонецЦикла;
		
	// Результат
	ПолеТекстаПрограммы.ДобавитьСловоЛокальногоКонтекста(
		"Результат", "Свойство", Новый ОписаниеТипов(Новый Массив));
		
	Возврат СтруктураПараметров;

КонецФункции // ОбновитьКонтекстПодсказкиИПолучитьСтруктуруПараметров()

// @@@.КЛАСС.ПолеТекстаПрограммы
Процедура КлсПолеТекстаПрограммыНажатие(Кнопка)
	
	СтруктураПараметров = ОбновитьКонтекстПодсказкиИПолучитьСтруктуруПараметров();
	// Специальная обработка команд компоненты ДО
	КомпонентаТекстаАлгоритма = ПолеТекстаПрограммы;
	Если Ложь
		Или Кнопка = ирОбщий.КнопкаКоманднойПанелиЭкземпляраКомпонентыЛкс(ПолеТекстаПрограммы, "Выполнить") 
		Или Кнопка = ирОбщий.КнопкаКоманднойПанелиЭкземпляраКомпонентыЛкс(ПолеТекстаПрограммы, "Проверить") 
	Тогда
		Если Не ПроверитьДанные() Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли; 
	Если Кнопка = ирОбщий.КнопкаКоманднойПанелиЭкземпляраКомпонентыЛкс(ПолеТекстаПрограммы, "Выполнить") Тогда
		Если ПолеТекстаПрограммы.ПроверитьПрограммныйКод() Тогда 
			Если Модифицированность Тогда
				Ответ = Вопрос("Перед выполнением алгоритм необходимо сохранить. Выполнить сохранение?", РежимДиалогаВопрос.ОКОтмена);
				Если Ответ = КодВозвратаДиалога.Отмена Тогда
					Возврат;
				КонецЕсли;
				Если Не ЗаписатьВФорме() Тогда 
					Возврат;
				КонецЕсли;
			КонецЕсли;
			ирКэш.Получить().ВыполнитьМетодАлгоритма(ЭтотОбъект, 1, СтруктураПараметров);
		КонецЕсли;
	Иначе
		ПолеТекстаПрограммы.Нажатие(Кнопка);
	КонецЕсли;
	
КонецПроцедуры

// @@@.КЛАСС.ПолеТекстаПрограммы
Процедура КлсПолеТекстаПрограммыАвтоОбновитьСправку()
	
	#Если Сервер И Не Сервер Тогда
	    ПолеТекстаПрограммы = Обработки.ирКлсПолеТекстаПрограммы.Создать();
	#КонецЕсли
	ПолеТекстаПрограммы.АвтоОбновитьСправку();
	
КонецПроцедуры

// @@@.КЛАСС.ПолеТекстаПрограммы
Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	Если ПолеТекстаПрограммы = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	#Если Сервер И Не Сервер Тогда
	    ПолеТекстаПрограммы = Обработки.ирКлсПолеТекстаПрограммы.Создать();
	#КонецЕсли
	ПолеТекстаПрограммы.ВнешнееСобытиеОбъекта(Источник, Событие, Данные);
	
КонецПроцедуры

Функция ПоказатьОшибкуВыполнения(ИнформацияОбОшибке, Знач ТекстСообщения = "", РежимВыполненияАлгоритма = 0, СтартоваяСтрока = 0) Экспорт

	Если Не Открыта() Тогда
		Открыть();
	КонецЕсли;
	Если Не ВводДоступен() Тогда
		ирОбщий.Форма_АктивироватьОткрытьЛкс(ЭтаФорма);
	КонецЕсли;
	ВыполнятьАлгоритмыЧерезВнешниеОбработки = ирКэш.Получить().ВыполнятьАлгоритмыЧерезВнешниеОбработки;
	Если ВыполнятьАлгоритмыЧерезВнешниеОбработки Тогда 
		ОбновитьСвязи();
	КонецЕсли;
	ТекущийЭлемент = ПолеТекстаПрограммы.ПолеТекста;
	Если Ложь
		Или РежимВыполненияАлгоритма = 0
		Или РежимВыполненияАлгоритма = 1
	Тогда 
		ИмяМодуля = "ВнешняяОбработка." + Наименование;
		Если ирКэш.НомерИзданияПлатформыЛкс() = "82" Тогда
			ИмяМодуля = ИмяМодуля + ".МодульОбъекта";
		КонецЕсли;
	Иначе
		ИмяМодуля = "";
	КонецЕсли;
	Если ТекстСообщения = "" Тогда
		ТекстСообщения = "Ошибка при выполнении алгоритма """ + Наименование + """ в режиме " + РежимВыполненияАлгоритма;
	КонецЕсли;
	Сообщить(ТекстСообщения, СтатусСообщения.Важное);
	ТекстИстиннойОшибки = ирОбщий.ПоказатьОшибкуВТекстеПрограммыЛкс(ПолеТекстаПрограммы.ПолеТекста,
		СтартоваяСтрока, , , МодальныйРежим, ИнформацияОбОшибке, ИмяМодуля);
	Возврат ТекстИстиннойОшибки;

КонецФункции // ПоказатьОшибкуВыполнения()

Процедура ОбновитьСвязи()

	ФайлНовее = Ложь;
	ДобавокЗаголовка = "";
	ФайлВнешнейОбработки = ирКэш.Получить().ПолучитьФайлВнешнейОбработкиАлгоритма(ЭтотОбъект);
	Если ФайлВнешнейОбработки.Существует() Тогда
		Если ФайлВнешнейОбработки.ПолучитьВремяИзменения() + ирКэш.ПолучитьСмещениеВремениЛкс() > ДатаИзменения Тогда
			ДобавокЗаголовка = " [файл новее!]";
			ФайлНовее = Истина;
		КонецЕсли;
	КонецЕсли; 
	Если ФайлНовее Тогда
		НовыйЦветРамки = WebЦвета.Красный;
	Иначе
		НовыйЦветРамки = WebЦвета.Зеленый;
	КонецЕсли;
	ПолеТекстаПрограммы.ПолеТекста.ЦветРамки = НовыйЦветРамки;
	ЭлементыФормы.Наименование.ТолькоПросмотр = ФайлНовее;
	Заголовок = Метаданные().Представление() + ДобавокЗаголовка;

КонецПроцедуры // ОбновитьСвязи()

Процедура ПриОткрытии()
	
	ЭтаФорма.ЗакрыватьПриВыборе = Ложь;
	ВыполнятьАлгоритмыЧерезВнешниеОбработки = ирКэш.Получить().ВыполнятьАлгоритмыЧерезВнешниеОбработки;
	Если ВыполнятьАлгоритмыЧерезВнешниеОбработки Тогда 
		ПодключитьОбработчикОжидания("ОбновитьСвязи", 5);
		ОбновитьСвязи();
	КонецЕсли;
	КнопкиПанели = ЭлементыФормы.КоманднаяПанельТекстАлгоритма.Кнопки;
	КнопкиПанели.ОбновитьИзФайла.Доступность = ВыполнятьАлгоритмыЧерезВнешниеОбработки;
	КнопкиПанели.ОткрытьВОтладчике.Доступность = ВыполнятьАлгоритмыЧерезВнешниеОбработки;
	
КонецПроцедуры

Процедура КоманднаяПанельТекстАлгоритмаОбновитьИзФайла(Кнопка)
	
	ФайлВнешнейОбработки = ирКэш.Получить().ПолучитьФайлВнешнейОбработкиАлгоритма(ЭтотОбъект);
	ТекстАлгоритмаИзФайла = ирКэш.Получить().ПолучитьТекстМодуляВнешнейОбработкиАлгоритма(ФайлВнешнейОбработки);
	Если ТекстАлгоритмаИзФайла <> Неопределено Тогда
		// %%%%% Здесь можно сделать еще и сравнение текстов
		ПолеТекстаПрограммы.ПолеТекста.УстановитьТекст(ТекстАлгоритмаИзФайла);
		Сообщить("Обновление из файла прошло успешно");
		ДатаИзменения = ФайлВнешнейОбработки.ПолучитьВремяИзменения() + ирКэш.ПолучитьСмещениеВремениЛкс();
		Модифицированность = Истина;
		ОбновитьСвязи();
	Иначе
		Сообщить("Обновить из файла не удалось");
	КонецЕсли;
	
КонецПроцедуры

Процедура ПараметрыДопустимыеТипыНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Результат = ирКэш.Получить().РедактироватьДопустимыеТипы(Элемент.Значение);
	Если Результат <> Неопределено Тогда 
		Элемент.Значение = Результат;
		ОбновитьОграничениеТипаЗначения();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПараметрыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ОформлениеСтроки.Ячейки.ДопустимыеТипы.УстановитьТекст(ирКэш.Получить().ПредставлениеДопустимыхТипов(ДанныеСтроки.ДопустимыеТипы));
	ирОбщий.ТабличноеПолеОтобразитьПиктограммыТиповЛкс(ОформлениеСтроки, "Значение");
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	ПолеТекстаПрограммы.Уничтожить();
	
КонецПроцедуры

Процедура КоманднаяПанельТекстАлгоритмаОткрытьВОтладчике(Кнопка)
	
	ОбновитьКонтекстПодсказкиИПолучитьСтруктуруПараметров();
	Если ПолеТекстаПрограммы.ПроверитьПрограммныйКод() Тогда 
		Если Модифицированность Тогда
			Ответ = Вопрос("Перед открытием в отладчике алгоритм необходимо сохранить. Выполнить сохранение?", РежимДиалогаВопрос.ОКОтмена);
			Если Ответ = КодВозвратаДиалога.Отмена Тогда
				Возврат;
			КонецЕсли;
			Если Не ЗаписатьВФорме() Тогда 
				Возврат;
			КонецЕсли;
		КонецЕсли;
		НомерСтрокиВАлгоритме = ПолеТекстаПрограммы.ПолучитьНомерТекущейСтроки();
		НомерСтрокиВМодуле = НомерСтрокиВАлгоритме + ПолучитьСтартовуюСтрокуМетодаВМодуле();
		ИдентификаторОтладчика = ирОбщий.ПроверитьЗапуститьОтладчик();
		ирКэш.Получить().ОткрытьАлгоритмВОтладчике(ЭтотОбъект, НомерСтрокиВМодуле, ИдентификаторОтладчика);
	КонецЕсли;
	
КонецПроцедуры

Процедура НаименованиеПриИзменении(Элемент)
	
	Если Не ирОбщий.ЛиИмяПеременнойЛкс(Элемент.Значение) Тогда
		Элемент.Значение = ирОбщий.ИдентификаторИзПредставленияЛкс(Элемент.Значение);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаВыбора(РезультатВыбора, Источник)
	
	Если ТипЗнч(РезультатВыбора) = Тип("Структура") Тогда
		Если РезультатВыбора.Свойство("ИнформацияОбОшибке") Тогда
			ПоказатьОшибкуВыполнения(РезультатВыбора.ИнформацияОбОшибке, , РезультатВыбора.РежимВыполненияАлгоритма, РезультатВыбора.СтартоваяСтрока);
		КонецЕсли; 
	КонецЕсли;
	
КонецПроцедуры

Процедура ДействияФормыОПодсистеме(Кнопка)
	
	ирОбщий.ОткрытьСправкуПоПодсистемеЛкс(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПараметрыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если Не ЗначениеЗаполнено(Элемент.ТекущиеДанные.Имя) Тогда
		Элемент.ТекущиеДанные.Имя = "П" + (Элемент.Значение.Индекс(Элемент.ТекущиеДанные) + 1);
	КонецЕсли; 
	Если НоваяСтрока И Не Копирование Тогда
		Элемент.ТекущиеДанные.Вход = Истина;
	КонецЕсли; 
	ОбновитьОграничениеТипаЗначения();

КонецПроцедуры

Процедура ОбновитьОграничениеТипаЗначения()
	
	Если ЗначениеЗаполнено(ЭлементыФормы.Параметры.ТекущиеДанные.ДопустимыеТипы) Тогда
		ОграничениеТипа = ирКэш.Получить().ПолучитьОписаниеТиповИзДопустимыхТипов(ЭлементыФормы.Параметры.ТекущиеДанные.ДопустимыеТипы);
		ЭлементыФормы.Параметры.Колонки.Значение.ЭлементУправления.ОграничениеТипа = ОграничениеТипа;
		ЭлементыФормы.Параметры.ТекущиеДанные.Значение = ОграничениеТипа.ПривестиЗначение(ЭлементыФормы.Параметры.ТекущиеДанные.Значение);
	КонецЕсли;

КонецПроцедуры

Процедура ПараметрыНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	Если ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Перемещение Тогда
		ПараметрыПеретаскивания.Значение = Элемент.ТекущаяСтрока.Имя;
	КонецЕсли; 

КонецПроцедуры

Процедура КоманднаяПанельТекстАлгоритмаСсылкаНаОбъектБД(Кнопка)
	
	ПолеТекстаПрограммы.ВставитьСсылкуНаОбъектБД(ЭлементыФормы.Параметры);
	
КонецПроцедуры

Процедура КоманднаяПанельПараметрыЗаполнить(Кнопка)
	
	Пока Истина Цикл
		ОбновитьКонтекстПодсказкиИПолучитьСтруктуруПараметров();
		ИнформацияОбОшибке = ПолеТекстаПрограммы.ПолучитьИнформациюОбОшибке();
		НеопределеннаяПеременная = ирКэш.Получить().ИмяНеопределеннойПеременнойИзИнформацииОбОшибке(ИнформацияОбОшибке);
		Если Не ЗначениеЗаполнено(НеопределеннаяПеременная) Тогда
			ПолеТекстаПрограммы.ПроверитьПрограммныйКод(Ложь);
			Прервать;
		КонецЕсли;
		СтрокаПараметра = Параметры.Найти(НеопределеннаяПеременная);
		Если СтрокаПараметра = Неопределено Тогда
			СтрокаПараметра = Параметры.Добавить();
			СтрокаПараметра.Имя = НеопределеннаяПеременная;
			//СтрокаПараметра.НИмя = НРег(СтрокаПараметра.Имя);
		КонецЕсли; 
		//СтрокаПараметра.Вход = Истина;
		ЭтаФорма.Модифицированность = Истина;
	КонецЦикла;
	
КонецПроцедуры

Процедура КоманднаяПанельТекстАлгоритмаКонсольКода(Кнопка)
	
	СтруктураПараметров = Новый Структура;
	Для Каждого СтрокаПараметра Из Параметры Цикл
		СтруктураПараметров.Вставить(СтрокаПараметра.Имя, СтрокаПараметра.Значение);
	КонецЦикла;
	ФормаКонсолиКода = ирОбщий.ОперироватьСтруктуройЛкс(ТекстАлгоритма, , СтруктураПараметров);
	ФормаКонсолиКода.ТекущийАлгоритм = Ссылка;
	
КонецПроцедуры

Процедура КоманднаяПанельТекстАлгоритмаСгенерироватьМетод(Кнопка)
	
	ТекстАлгоритма = ПолеТекстаПрограммы.ПолеТекста.ПолучитьТекст();
	Объект = ЭтотОбъект;
	//Объект.СобратьКонтекст(); // Можно делать и снаружи, но здесь для надежности.
	
	Результат = "Функция " + Объект.Наименование + "(";
	СтрокаПараметров = "";
	ПодсказкаПараметров = "";
	СмещениеИндекса = 0;
	Для Индекс = 0 ПО Объект.Параметры.Количество() - 1 Цикл
		ВнешнийПараметр = Объект.Параметры[Индекс];
		ИмяПараметра = ВнешнийПараметр.Имя;
		Если СтрокаПараметров <> "" Тогда
			СтрокаПараметров = СтрокаПараметров + ", ";
		КонецЕсли;
		//Если ВнешнийПараметр.Невозвращаемый Тогда
			СтрокаПараметров = СтрокаПараметров + "Знач ";
		//КонецЕсли;
		СтрокаПараметров = СтрокаПараметров + ИмяПараметра;
		ЗначениеПараметра = ВнешнийПараметр.Значение;
		Если Типзнч(ЗначениеПараметра) = Тип("Строка") Тогда
			СтрокаПараметров = СтрокаПараметров + " = """ + ЗначениеПараметра + """";
		ИначеЕсли Типзнч(ЗначениеПараметра) = Тип("Булево") Тогда
			СтрокаПараметров = СтрокаПараметров + " = " + ?(ЗначениеПараметра, "Истина", "Ложь");
		ИначеЕсли Типзнч(ЗначениеПараметра) = Тип("Число") Тогда
			СтрокаПараметров = СтрокаПараметров + " = " + Формат(ЗначениеПараметра, "ЧН=; ЧГ=");
		КонецЕсли;
		ТипХмл = XMLТипЗнч(ЗначениеПараметра);
		Если Истина
			И ТипХмл <> Неопределено 
			И Найти(ТипХмл.ИмяТипа, "Ref.") > 0
		Тогда
			ОбъектМД = ЗначениеПараметра.Метаданные();
			СтрокаКлассаМД = ирКэш.Получить().ОписаниеТипаМетаОбъектов(ирОбщий.ПервыйФрагментЛкс(ОбъектМД.ПолноеИмя()));
			ПодсказкаПараметров = ПодсказкаПараметров + Символы.ПС + Символы.Таб + ИмяПараметра + " = " + СтрокаКлассаМД.Множественное 
				+ "." + ОбъектМД.Имя + ".ПустаяСсылка();";
		КонецЕсли;
	КонецЦикла;
	Результат = Результат + СтрокаПараметров + ") Экспорт" + Символы.ПС;
	Если ПодсказкаПараметров <> "" Тогда
		ПодсказкаПараметров = "
		|	#Если Сервер И Не Сервер Тогда" + ПодсказкаПараметров + "
		|	#КонецЕсли";
	КонецЕсли;
	Результат = Результат + Символы.Таб ;
	
	//МассивСлужебныхПеременных = мВнешниеПараметры.Выгрузить("Наименование"); // Так не будет работать при использовании Выполнить (без функции)
	МассивСлужебныхПеременных = Новый Массив;
	Если МассивСлужебныхПеременных.Найти("ЭтотОбъект") = Неопределено Тогда
		МассивСлужебныхПеременных.Добавить("ЭтотОбъект");
	КонецЕсли; 
	Если МассивСлужебныхПеременных.Найти("Результат") = Неопределено Тогда
		МассивСлужебныхПеременных.Добавить("Результат");
	КонецЕсли; 
	Разделитель = ", ";
	СтрокаСлужебных = "";
	Для Каждого СлужебнаяПеременная Из МассивСлужебныхПеременных Цикл
		СтрокаСлужебных = СтрокаСлужебных + Разделитель + СлужебнаяПеременная;
	КонецЦикла;
	СтрокаСлужебных = Сред(СтрокаСлужебных, СтрДлина(Разделитель) + 1);
	Результат = Результат + "Перем " + СтрокаСлужебных + ";";
	Результат = Результат + ПодсказкаПараметров;
	
	мПлатформа = ирКэш.Получить();
	ТекстПолученияКэшей = "";
	Результат = Результат + Символы.ПС + мПлатформа.МаркерНачалаАлгоритма;
	ТекстАлгоритмаТД = Новый ТекстовыйДокумент;
	ТекстАлгоритмаТД.УстановитьТекст(Объект.ТекстАлгоритма);
	Для Сч1 = 1 По ТекстАлгоритмаТД.КоличествоСтрок() Цикл
		Результат = Результат + Символы.Таб + ТекстАлгоритмаТД.ПолучитьСтроку(Сч1) + Символы.ПС;
	КонецЦикла;
	//#Если Клиент Или ВнешнееСоединение Тогда
	//мПлатформа = ирКэш.Получить();
	//#КонецЕсли
	Результат = Результат + мПлатформа.МаркерКонцаАлгоритма;
	Если Найти(НРег(Объект.ТекстАлгоритма), НРег("~Конец")) > 0 Тогда
		Результат = Результат + Символы.Таб + "; ~Конец:" + Символы.ПС;
	КонецЕсли; 
	Результат = Результат + Символы.Таб + "Возврат Результат;" + Символы.ПС;
	Результат = Результат + "КонецФункции" + Символы.ПС;
	
	ирОбщий.ОткрытьТекстЛкс(Результат, , "ВстроенныйЯзык", Истина);

КонецПроцедуры

Процедура ПараметрыЗначениеНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаКолонкиРасширенногоЗначения_НачалоВыбораЛкс(ЭтаФорма, ЭлементыФормы.Параметры, СтандартнаяОбработка, , Истина);
	
КонецПроцедуры

Процедура ПараметрыПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Колонка)
	
	Если ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Массив") Тогда
		СтандартнаяОбработка = Ложь;
		ПараметрыПеретаскивания.ДопустимыеДействия = ДопустимыеДействияПеретаскивания.КопированиеИПеремещение;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПараметрыПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Колонка)
	
	Если ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Массив") Тогда
		ЭлементыФормы.Параметры.ВыделенныеСтроки.Очистить();
		Для Каждого ЭлементМассива Из ПараметрыПеретаскивания.Значение Цикл
			Если Метаданные.НайтиПоТипу(ТипЗнч(ЭлементМассива)) = Метаданные.НайтиПоТипу(ТипЗнч(Параметры)) Тогда 
				НоваяСтрока = Параметры.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, ЭлементМассива); 
				ЭлементыФормы.Параметры.ВыделенныеСтроки.Добавить(НоваяСтрока);
			КонецЕсли; 
		КонецЦикла;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДействияФормыОтображатьПараметры(Кнопка)
	
	ПоказатьСвернутьНастройки(Не ЭлементыФормы.ДействияФормы.Кнопки.ОтображатьПараметры.Пометка);
	
КонецПроцедуры

Процедура ПоказатьСвернутьНастройки(Видимость = Истина)
	
	ЭлементыФормы.ДействияФормы.Кнопки.ОтображатьПараметры.Пометка = Видимость;
	ирОбщий.ИзменитьСвернутостьЛкс(ЭтаФорма, Видимость, ЭлементыФормы.Панель1, ЭлементыФормы.Разделитель1, ЭтаФорма.Панель, "верх");
	
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	ПоказатьСвернутьНастройки();
	
КонецПроцедуры

Процедура ПослеЗаписи()
	
	ОповеститьОВыборе(Ссылка);
	
КонецПроцедуры

// +++.КЛАСС.ПолеТекстаПрограммы
ПолеТекстаПрограммы = ирОбщий.СоздатьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирКлсПолеТекстаПрограммы");
#Если Сервер И Не Сервер Тогда
	ПолеТекстаПрограммы = Обработки.ирКлсПолеТекстаПрограммы.Создать();
#КонецЕсли
ПолеТекстаПрограммы.Инициализировать(, ЭтаФорма, ЭлементыФормы.ТекстАлгоритма,
	ЭлементыФормы.КоманднаяПанельТекстАлгоритма, , "ВыполнитьЛокально", ЭтотОбъект);
// ---.КЛАСС.ПолеТекстаПрограммы
