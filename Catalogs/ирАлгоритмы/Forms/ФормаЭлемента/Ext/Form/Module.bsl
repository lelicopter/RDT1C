﻿Перем ПолеТекстовогоДокументаСКонтекстнойПодсказкой;
Перем мЗначенияПараметров;

Процедура ПередЗаписью(Отказ)
	
	Если Не ПроверитьДанные() Тогда 
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	СинтаксическийКонтрольПередЗаписью = ирКэш.Получить().СинтаксическийКонтрольПередЗаписью;
	Если СинтаксическийКонтрольПередЗаписью = Истина Тогда
		ОбновитьКонтекстПодсказкиИПолучитьСтруктуруПараметров();
		Если Не ПолеТекстовогоДокументаСКонтекстнойПодсказкой.ПроверитьПрограммныйКод() Тогда 
			Ответ = Вопрос("При проверке текста алгоритма обнаружены ошибки. Продолжить?", РежимДиалогаВопрос.ОКОтмена);
			Если Ответ = КодВозвратаДиалога.Отмена Тогда
				Отказ = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	Если Не Отказ Тогда
		ТекстАлгоритма = ПолеТекстовогоДокументаСКонтекстнойПодсказкой.ПолеТекстовогоДокумента.ПолучитьТекст();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриИзмененииДанных()
	
	ПолеТекстовогоДокументаСКонтекстнойПодсказкой.ПолеТекстовогоДокумента.УстановитьТекст(ТекстАлгоритма);
	
КонецПроцедуры

Функция ОбновитьКонтекстПодсказкиИПолучитьСтруктуруПараметров()

	ирОбщий.ИнициализироватьГлобальныйКонтекстПодсказкиЛкс(ПолеТекстовогоДокументаСКонтекстнойПодсказкой);
	
	// Локальный контекст
	СтруктураПараметров = Новый Структура;
	Для Каждого СтрокаПараметра Из Параметры Цикл
		СтруктураПараметров.Вставить(СтрокаПараметра.Имя, СтрокаПараметра.Значение);
		Если СтрокаПараметра.Значение <> Неопределено Тогда
			МассивТипов = Новый Массив;
			МассивТипов.Добавить(ТипЗнч(СтрокаПараметра.Значение));
			ПолеТекстовогоДокументаСКонтекстнойПодсказкой.ДобавитьСловоЛокальногоКонтекста(
				СтрокаПараметра.Имя, "Свойство", Новый ОписаниеТипов(МассивТипов), , , СтрокаПараметра.Значение);
		КонецЕсли;
		//Если Не ПустаяСтрока(СтрокаПараметра.ДопустимыеТипы) Тогда 
			ПолеТекстовогоДокументаСКонтекстнойПодсказкой.ДобавитьПеременнуюЛокальногоКонтекста(
				СтрокаПараметра.Имя, СтрокаПараметра.ДопустимыеТипы);
		//КонецЕсли;
	КонецЦикла;
		
	// Результат
	ПолеТекстовогоДокументаСКонтекстнойПодсказкой.ДобавитьСловоЛокальногоКонтекста(
		"Результат", "Свойство", Новый ОписаниеТипов(Новый Массив));
		
	Возврат СтруктураПараметров;

КонецФункции // ОбновитьКонтекстПодсказкиИПолучитьСтруктуруПараметров()

// @@@.КЛАСС.ПолеТекстовогоДокументаСКонтекстнойПодсказкой
Процедура КлсПолеТекстовогоДокументаСКонтекстнойПодсказкойНажатие(Кнопка)
	
	СтруктураПараметров = ОбновитьКонтекстПодсказкиИПолучитьСтруктуруПараметров();
	// Специальная обработка команд компоненты ДО
	КомпонентаТекстаАлгоритма = ПолеТекстовогоДокументаСКонтекстнойПодсказкой;
	Если Ложь
		Или Кнопка = ирОбщий.ПолучитьКнопкуКоманднойПанелиЭкземпляраКомпонентыЛкс(ПолеТекстовогоДокументаСКонтекстнойПодсказкой, "Выполнить") 
		Или Кнопка = ирОбщий.ПолучитьКнопкуКоманднойПанелиЭкземпляраКомпонентыЛкс(ПолеТекстовогоДокументаСКонтекстнойПодсказкой, "Проверить") 
	Тогда
		Если Не ПроверитьДанные() Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли; 
	Если Кнопка = ирОбщий.ПолучитьКнопкуКоманднойПанелиЭкземпляраКомпонентыЛкс(ПолеТекстовогоДокументаСКонтекстнойПодсказкой, "Выполнить") Тогда
		Если ПолеТекстовогоДокументаСКонтекстнойПодсказкой.ПроверитьПрограммныйКод() Тогда 
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
		ПолеТекстовогоДокументаСКонтекстнойПодсказкой.Нажатие(Кнопка);
	КонецЕсли;
	
КонецПроцедуры

// @@@.КЛАСС.ПолеТекстовогоДокументаСКонтекстнойПодсказкой
Процедура КлсПолеТекстовогоДокументаСКонтекстнойПодсказкойАвтоОбновитьСправку()
	
	ПолеТекстовогоДокументаСКонтекстнойПодсказкой.АвтоОбновитьСправку();
	
КонецПроцедуры

Функция ПоказатьОшибкуВыполнения(ИнформацияОбОшибке, Знач ТекстСообщения = "", РежимВыполненияАлгоритма = 0, СтартоваяСтрока = 0) Экспорт

	Если Не Открыта() Тогда
		Открыть();
	КонецЕсли;
	Если Не ВводДоступен() Тогда
		Активизировать();
	КонецЕсли;
	ВыполнятьАлгоритмыЧерезВнешниеОбработки = ирКэш.Получить().ВыполнятьАлгоритмыЧерезВнешниеОбработки;
	Если ВыполнятьАлгоритмыЧерезВнешниеОбработки Тогда 
		ОбновитьСвязи();
	КонецЕсли;
	ТекущийЭлемент = ПолеТекстовогоДокументаСКонтекстнойПодсказкой.ПолеТекстовогоДокумента;
	Если Ложь
		Или РежимВыполненияАлгоритма = 0
		Или РежимВыполненияАлгоритма = 1
	Тогда 
		ИмяМодуля = "ВнешняяОбработка." + Наименование;
		Если ирКэш.Получить().ИДВерсииПлатформы = "82" Тогда
			ИмяМодуля = ИмяМодуля + ".МодульОбъекта";
		КонецЕсли;
	Иначе
		ИмяМодуля = "";
	КонецЕсли;
	Если ТекстСообщения = "" Тогда
		ТекстСообщения = "Ошибка при выполнении алгоритма """ + Наименование + """ в режиме " + РежимВыполненияАлгоритма;
	КонецЕсли;
	Сообщить(ТекстСообщения, СтатусСообщения.Важное);
	ТекстИстиннойОшибки = ирОбщий.ПоказатьОшибкуВЗапросеИлиПрограммномКодеЛкс(ПолеТекстовогоДокументаСКонтекстнойПодсказкой.ПолеТекстовогоДокумента,
		СтартоваяСтрока, , , МодальныйРежим, ИнформацияОбОшибке, ИмяМодуля);
	Возврат ТекстИстиннойОшибки;

КонецФункции // ПоказатьОшибкуВыполнения()

Процедура ОбновитьСвязи()

	ФайлНовее = Ложь;
	ДобавокЗаголовка = "";
	ФайлВнешнейОбработки = ирКэш.Получить().ПолучитьФайлВнешнейОбработкиАлгоритма(ЭтотОбъект);
	Если ФайлВнешнейОбработки.Существует() Тогда
		Если ФайлВнешнейОбработки.ПолучитьВремяИзменения() > ДатаИзменения Тогда
			ДобавокЗаголовка = " [файл новее!]";
			ФайлНовее = Истина;
		КонецЕсли;
	КонецЕсли; 
	Если ФайлНовее Тогда
		НовыйЦветРамки = WebЦвета.Красный;
	Иначе
		НовыйЦветРамки = WebЦвета.Зеленый;
	КонецЕсли;
	ПолеТекстовогоДокументаСКонтекстнойПодсказкой.ПолеТекстовогоДокумента.ЦветРамки = НовыйЦветРамки;
	ЭлементыФормы.Наименование.ТолькоПросмотр = ФайлНовее;
	Заголовок = Метаданные().Представление() + ДобавокЗаголовка;

КонецПроцедуры // ОбновитьСвязи()

Процедура ПриОткрытии()
	
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
		ПолеТекстовогоДокументаСКонтекстнойПодсказкой.ПолеТекстовогоДокумента.УстановитьТекст(ТекстАлгоритмаИзФайла);
		Сообщить("Обновление из файла прошло успешно");
		ДатаИзменения = ФайлВнешнейОбработки.ПолучитьВремяИзменения();
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
	КонецЕсли;
	
КонецПроцедуры

Процедура ПараметрыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ОформлениеСтроки.Ячейки.ДопустимыеТипы.УстановитьТекст(ирКэш.Получить().ПолучитьПредставлениеДопустимыхТипов(ДанныеСтроки.ДопустимыеТипы));
	ирОбщий.ТабличноеПоле_ОтобразитьПиктограммыТиповЛкс(ОформлениеСтроки, "Значение");
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	ПолеТекстовогоДокументаСКонтекстнойПодсказкой.Уничтожить();
	
КонецПроцедуры

Процедура КоманднаяПанельТекстАлгоритмаОткрытьВОтладчике(Кнопка)
	
	ОбновитьКонтекстПодсказкиИПолучитьСтруктуруПараметров();
	Если ПолеТекстовогоДокументаСКонтекстнойПодсказкой.ПроверитьПрограммныйКод() Тогда 
		Если Модифицированность Тогда
			Ответ = Вопрос("Перед открытием в отладчике алгоритм необходимо сохранить. Выполнить сохранение?", РежимДиалогаВопрос.ОКОтмена);
			Если Ответ = КодВозвратаДиалога.Отмена Тогда
				Возврат;
			КонецЕсли;
			Если Не ЗаписатьВФорме() Тогда 
				Возврат;
			КонецЕсли;
		КонецЕсли;
		НомерСтрокиВАлгоритме = ПолеТекстовогоДокументаСКонтекстнойПодсказкой.ПолучитьНомерТекущейСтроки();
		НомерСтрокиВМодуле = НомерСтрокиВАлгоритме + ПолучитьСтартовуюСтрокуМетодаВМодуле();
		ИдентификаторПроцессаОтладчика = ирОбщий.ПроверитьЗапуститьОтладчик();
		ирКэш.Получить().ОткрытьАлгоритмВОтладчике(ЭтотОбъект, НомерСтрокиВМодуле, ИдентификаторПроцессаОтладчика);
	КонецЕсли;
	
КонецПроцедуры

Процедура НаименованиеПриИзменении(Элемент)
	
	Если Не ирОбщий.ЛиИмяПеременнойЛкс(Элемент.Значение) Тогда
		Элемент.Значение = ирКэш.Получить().ПолучитьИдентификаторИзПредставления(Элемент.Значение);
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

КонецПроцедуры

Процедура ПараметрыНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	ПараметрыПеретаскивания.Значение = Элемент.ТекущаяСтрока.Имя;

КонецПроцедуры

Процедура КоманднаяПанельТекстАлгоритмаСсылкаНаОбъектБД(Кнопка)
	
	ПолеТекстовогоДокументаСКонтекстнойПодсказкой.ВставитьСсылкуНаОбъектБД(ЭлементыФормы.Параметры);
	
КонецПроцедуры

Процедура КоманднаяПанельПараметрыЗаполнить(Кнопка)
	
	Пока Истина Цикл
		ОбновитьКонтекстПодсказкиИПолучитьСтруктуруПараметров();
		ИнформацияОбОшибке = ПолеТекстовогоДокументаСКонтекстнойПодсказкой.ПолучитьИнформациюОбОшибке();
		НеопределеннаяПеременная = ирКэш.Получить().ПолучитьИмяНеопределеннойПеременнойИзИнформацииОбОшибке(ИнформацияОбОшибке);
		Если Не ЗначениеЗаполнено(НеопределеннаяПеременная) Тогда
			ПолеТекстовогоДокументаСКонтекстнойПодсказкой.ПроверитьПрограммныйКод(Ложь);
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
	
	ТекстАлгоритма = ПолеТекстовогоДокументаСКонтекстнойПодсказкой.ПолеТекстовогоДокумента.ПолучитьТекст();
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
			СтрокаКлассаМД = ирКэш.Получить().ПолучитьСтрокуТипаМетаОбъектов(ирОбщий.ПолучитьПервыйФрагментЛкс(ОбъектМД.ПолноеИмя()));
			ПодсказкаПараметров = ПодсказкаПараметров + Символы.ПС + Символы.Таб + ИмяПараметра + " = " + СтрокаКлассаМД.Множественное 
				+ "." + ОбъектМД.Имя + ".ПустаяСсылка();";
		КонецЕсли;
	КонецЦикла;
	Результат = Результат + СтрокаПараметров + ") Экспорт" + Символы.ПС;
	Если ПодсказкаПараметров <> "" Тогда
		ПодсказкаПараметров = "
		|	#Если _ Тогда" + ПодсказкаПараметров + "
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
	Для Сч1 = 1 По СтрЧислоСтрок(Объект.ТекстАлгоритма) Цикл
		Результат = Результат + Символы.Таб + СтрПолучитьСтроку(Объект.ТекстАлгоритма, Сч1) + Символы.ПС;
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

// +++.КЛАСС.ПолеТекстовогоДокументаСКонтекстнойПодсказкой
ПолеТекстовогоДокументаСКонтекстнойПодсказкой = ирОбщий.ПолучитьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирКлсПолеТекстовогоДокументаСКонтекстнойПодсказкой");
#Если _ Тогда
	ПолеТекстовогоДокументаСКонтекстнойПодсказкой = Обработки.ирКлсПолеТекстовогоДокументаСКонтекстнойПодсказкой.Создать();
#КонецЕсли
ПолеТекстовогоДокументаСКонтекстнойПодсказкой.Инициализировать(, ЭтаФорма, ЭлементыФормы.ТекстАлгоритма,
	ЭлементыФормы.КоманднаяПанельТекстАлгоритма, , "ВыполнитьЛокально", ЭтотОбъект);
// ---.КЛАСС.ПолеТекстовогоДокументаСКонтекстнойПодсказкой
