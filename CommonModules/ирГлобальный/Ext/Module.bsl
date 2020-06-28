﻿#Если Не ТонкийКлиент И Не ВебКлиент И Не МобильныйКлиент Тогда

// Обертка. Добавляет глобальные переменные и методы в контекст поля текстового документа с контекстной подсказкой.
//
// Параметры
//  ПолеТекстовогоДокументаСКонтекстнойПодсказкой - ОбработкаОбъект.ПолеТекстовогоДокументаСКонтекстнойПодсказкой.
//
Процедура ИнициализироватьГлобальныйКонтекстПодсказки(ПолеТекстовогоДокументаСКонтекстнойПодсказкой) Экспорт

	ирОбщий.ИнициализироватьГлобальныйКонтекстПодсказкиЛкс(ПолеТекстовогоДокументаСКонтекстнойПодсказкой);
	
КонецПроцедуры // ИнициализироватьГлобальныйКонтекстПодсказки()

Функция ПолучитьЗначениеПеременнойИзТаблицыЛокальногоКонтекстаЛкс(ИмяПеременной, ТаблицаЛокальногоКонтекста) Экспорт

	СтруктураКлюча = Новый Структура("нСлово, ТипСлова", НРег(ИмяПеременной), "Свойство");
	НайденныеСтроки = ТаблицаЛокальногоКонтекста.НайтиСтроки(СтруктураКлюча);
	Если НайденныеСтроки.Количество() > 0 Тогда
		Возврат НайденныеСтроки[0].Значение;
	Иначе
		Возврат Неопределено;
	КонецЕсли;

КонецФункции // ПолучитьЗначениеПеременнойИзТаблицыЛокальногоКонтекста()

// Вычисляет тип значения функции УК по внутренним параметрам и аргументам.
// Предназначена для вызвова из ирКлсПолеТекстовогоДокументаСКонтекстнойПодсказкой.
//
// Параметры:
//  ТаблицаЛокальногоКонтекста – ТаблицаЗначений – (см. ирКлсПолеТекстовогоДокументаСКонтекстнойПодсказкой);
//  МассивПараметров - Массив - выражений параметров.
//
// Возвращаемое значение:
//  ТаблицаЗначений - ТаблицаСтруктурТипов (см. ирКлсПолеТекстовогоДокументаСКонтекстнойПодсказкой).
//
Функция ПравилоВычисленияТипаЗначенияКПА(ТаблицаЛокальногоКонтекста, МассивПараметров) Экспорт

	лПлатформа = ирКэш.Получить(); 
	ТаблицаСтруктурТипов = лПлатформа.ПолучитьНовуюТаблицуСтруктурТипа();
	Алгоритм = ПолучитьЗначениеПеременнойИзТаблицыЛокальногоКонтекстаЛкс(МассивПараметров[0], ТаблицаЛокальногоКонтекста);
	Если Алгоритм <> Неопределено Тогда
		Структура = ирКПА(Алгоритм);
		СтруктураТипа = лПлатформа.ПолучитьСтруктуруТипаИзЗначения(Структура);
		ЗаполнитьЗначенияСвойств(ТаблицаСтруктурТипов.Добавить(), СтруктураТипа);
	КонецЕсли; 
	Возврат ТаблицаСтруктурТипов;

КонецФункции // ПравилоВычисленияТипаЗначенияУК()

// Конструктор Параметров Алгоритма.
//
// Параметры:
//  Алгоритм     – СправочникСсылка.ирАлгоритмы.
//
// Возвращаемое значение:
//  Структура - ключ - имя, значение - значение.
//
Функция ирКПА(Знач Алгоритм) Экспорт

	#Если Сервер И Не Сервер Тогда
	    Алгоритм = Справочники.ирАлгоритмы.ПустаяСсылка();
	#КонецЕсли
	СтруктураПараметров = Новый Структура;
	Для Каждого СтрокаПараметра Из Алгоритм.Параметры Цикл
		СтруктураПараметров.Вставить(СтрокаПараметра.Имя, СтрокаПараметра.Значение);
	КонецЦикла; 
	Возврат СтруктураПараметров;

КонецФункции // УК()

// Именованный Вызов Алгоритма. Передача параметров выполняется по имени. 
//
// Параметры:
//  Алгоритм     – СправочникСсылка.ирАлгоритмы, Строка - ссылка или GUID или имя сервиса;
//  *СтруктураПараметров – Структура, *Неопределено - ключи - имена параметров, значения - значения параметров;
//  *пНастройкаАлгоритма - СправочникСсылка.НаборыЗначенийПараметров2iS, *Неопределено - набор значений параметров,
//                 имеющий приоритет ниже, чем СтруктураПараметров;
//  *ПреобразоватьРезультатВСтрокуВнутр - Булево, *Ложь - преобразовать результат в строку внутреннюю (сериализовать)
//
// Возвращаемое значение:
//  Произвольный.
//
Функция ирИВА(Знач Алгоритм, Знач СтруктураПараметров = Неопределено) Экспорт

	Если СтруктураПараметров = Неопределено Тогда
		СтруктураПараметров = Новый Структура;
	КонецЕсли;
	АлгоритмОбъект = ирОбщий.ПолучитьАлгоритмОбъектПоИдентификаторуЛкс(Алгоритм);
	Результат = ирКэш.Получить().ВыполнитьМетодАлгоритма(АлгоритмОбъект, 1, СтруктураПараметров);
	Возврат Результат;

КонецФункции // ирИВА()

// Позиционный Вызов Алгоритма. Передача параметров выполняется по позиции. 
//
// Параметры
//  Алгоритм     – СправочникСсылка.Сервисы2iS, Строка - ссылки или имя сервиса;
//  *П...        – Произвольный, *Null – параметры сервиса.
//
// Возвращаемое значение:
//   Произвольное.
//
Функция ирПВА(Знач Алгоритм, П0=Null, П1=Null, П2=Null, П3=Null,
	П4=Null, П5=Null, П6=Null, П7=Null, П8=Null, П9=Null) Экспорт
	
	АлгоритмОбъект = ирОбщий.ПолучитьАлгоритмОбъектПоИдентификаторуЛкс(Алгоритм);
	мПлатформа = ирКэш.Получить();
	#Если Сервер И Не Сервер Тогда
	    мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	Результат = мПлатформа.ВыполнитьМетодАлгоритма(АлгоритмОбъект, 0, П0, П1, П2, П3, П4, П5, П6, П7, П8, П9);
	Возврат Результат;
	
КонецФункции // УФ()

#Если Клиент Тогда

// Вынесено сюда, чтобы у всех пользователей не компилировался тяжелый общий модуль ирОбщий в варианте Расширение
Процедура ОткрытьОднократноАдаптациюРасширенияЛкс() Экспорт 
	
	Если Не РольДоступна("ирРазработчик") Тогда
		Возврат;
	КонецЕсли;
	ИмяПродуктаЛкс = "ИнструментыРазработчикаTormozit";
	//ПометкиКоманд = ХранилищеОбщихНастроек.Загрузить(, "ирАдаптацияРасширения.ПометкиКоманд",, ирОбщий.ИмяПродуктаЛкс()); // Так при начале каждого сеанса толстого клиента будет комплироваться ирОбщий
	ПометкиКоманд = ХранилищеОбщихНастроек.Загрузить(, "ирАдаптацияРасширения.ПометкиКоманд",, ИмяПродуктаЛкс);
	Если ПометкиКоманд = Неопределено Тогда
		ПометкиКоманд = Новый Структура;
		//ХранилищеОбщихНастроек.Сохранить(, "ирАдаптацияРасширения.ПометкиКоманд", ПометкиКоманд,, ирОбщий.ИмяПродуктаЛкс());
		ХранилищеОбщихНастроек.Сохранить(, "ирАдаптацияРасширения.ПометкиКоманд", ПометкиКоманд,, ИмяПродуктаЛкс);
		Если ХранилищеОбщихНастроек.Загрузить(, "ирАдаптацияРасширения.ПометкиКоманд",, ИмяПродуктаЛкс) = Неопределено Тогда
			Возврат;
		КонецЕсли; 
		ОткрытьФормуМодально("ОбщаяФорма.ирАдаптацияРасширения", Новый Структура("Автооткрытие", Истина));
	КонецЕсли; 
	
КонецПроцедуры

#КонецЕсли 

//#Область ГлобальныеПортативныеМетоды

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ ОЖИДАНИЯ

#Если Клиент Тогда
		
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
		Если ирОбщий.ВосстановитьЗначениеЛкс("ПроверятьПодпискиКонфигурации", Истина) <> Ложь Тогда 
			ирОбщий.ПроверитьПодпискиЛкс();
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
	#Если ТолстыйКлиентУправляемоеПриложение Тогда
		ирОбщий.ПроверитьФлажокИспользоватьОбычныеФормыВУправляемомПриложенииЛкс();
	#КонецЕсли
	//Если Метаданные.ВариантВстроенногоЯзыка = Метаданные.СвойстваОбъектов.ВариантВстроенногоЯзыка.Английский Тогда
	//	Сообщить("Подсистема не полностью поддерживает вариант встроенного языка Английский.", СтатусСообщения.Внимание);
	//КонецЕсли;

КонецПроцедуры

Процедура ОткрытьСтруктуруАктивнойФормыЛкс() Экспорт 
	
	ТекущееОкно = АктивноеОкно();
	Если ТипЗнч(ТекущееОкно) = Тип("ОкноКлиентскогоПриложения") Тогда
		ТекущаяФорма = ТекущееОкно.ПолучитьСодержимое();
		Если ТекущаяФорма <> Неопределено Тогда
			ирОбщий.ОткрытьСтруктуруФормыЛкс(ТекущаяФорма);
		КонецЕсли; 
	КонецЕсли;
	
КонецПроцедуры

Процедура РедактироватьОбъектАктивнойФормыЛкс() Экспорт 

	ИмяПоляФормы = "";
	ИмяТаблицыФормы = "";
	Ссылка = ирОбщий.КлючОсновногоОбъектаУправляемойФормыЛкс(, ИмяТаблицыФормы, ИмяПоляФормы);
	Если Ссылка <> Неопределено Тогда
		ПоляТаблицы = ирОбщий.ПоляТаблицыБДЛкс(Ссылка.Метаданные().ПолноеИмя());
		ИмяПоляТаблицыБД = "";
		Для Каждого ПолеТаблицы Из ПоляТаблицы Цикл
			Если Найти(ИмяПоляФормы, ПолеТаблицы.Имя) > 0 Тогда
				ИмяПоляТаблицыБД = ПолеТаблицы.Имя;
				Прервать;
			КонецЕсли; 
		КонецЦикла;
		ирОбщий.ОткрытьСсылкуВРедактореОбъектаБДЛкс(Ссылка,,, ИмяПоляТаблицыБД);
	КонецЕсли; 

КонецПроцедуры

Процедура РедактироватьОбъектТекущегоПоляАктивнойФормыЛкс() Экспорт 
	
	Ссылки = ирОбщий.СсылкиИлиКлючиЗаписейИзТекущегоПоляАктивнойУправляемойФормыЛкс();
	Если Ссылки.Количество() > 0 Тогда
		ирОбщий.ОткрытьСсылкуВРедактореОбъектаБДЛкс(Ссылки[0]);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОткрытьОбъектТекущегоПоляАктивнойФормыЛкс() Экспорт 
	
	Ссылки = ирОбщий.СсылкиИлиКлючиЗаписейИзТекущегоПоляАктивнойУправляемойФормыЛкс();
	Если Ссылки.Количество() > 0 Тогда
		ирОбщий.ОткрытьЗначениеЛкс(Ссылки[0]);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбработатьОбъектыАктивнойФормыЛкс() Экспорт 

	Ссылки = ирОбщий.СсылкиИлиКлючиЗаписейИзАктивнойУправляемойФормыЛкс();
	Если Ссылки.Количество() > 0 Тогда
		ирОбщий.ОткрытьМассивОбъектовВПодбореИОбработкеОбъектовЛкс(Ссылки);
	КонецЕсли; 

КонецПроцедуры

Процедура ОбработатьОбъектыТекущегоПоляАктивнойФормыЛкс() Экспорт 

	Ссылки = ирОбщий.СсылкиИлиКлючиЗаписейИзТекущегоПоляАктивнойУправляемойФормыЛкс();
	Если Ссылки.Количество() > 0 Тогда
		ирОбщий.ОткрытьМассивОбъектовВПодбореИОбработкеОбъектовЛкс(Ссылки);
	КонецЕсли; 

КонецПроцедуры

Процедура ОткрытьТаблицуАктивнойФормыЛкс() Экспорт 

	ирОбщий.ОткрытьТаблицуЗначенийИзАктивнойУправляемойФормыЛкс();

КонецПроцедуры

Процедура СравнитьТаблицуАктивнойФормыЛкс() Экспорт 

	ирОбщий.СравнитьТаблицуИзАктивнойУправляемойФормыЛкс();

КонецПроцедуры

Процедура ОткрытьРазличныеЗначенияКолонкиАктивнойФормыЛкс() Экспорт 

	ирОбщий.ОткрытьРазличныеЗначенияКолонкиАктивнойУправляемойФормыЛкс();

КонецПроцедуры

Процедура ОтладитьКомпоновкуДанныхАктивнойФормыЛкс() Экспорт 

	ирОбщий.ОтладитьКомпоновкуДанныхАктивнойУправляемойФормыЛкс();

КонецПроцедуры

Процедура НастроитьДинамическийСписокАктивнойФормыЛкс() Экспорт 

	ирОбщий.НастроитьДинамическийСписокАктивнойУправляемойФормыЛкс();

КонецПроцедуры

Процедура НайтиВыбратьСсылкуВДинамическомСпискеАктивнойФормыЛкс() Экспорт 

	ирОбщий.НайтиВыбратьСсылкуВДинамическомСпискеАктивнойУправляемойФормыЛкс();

КонецПроцедуры

Процедура ОткрытьВыборГлобальнойКомандыЛкс() Экспорт 
	
	мПлатформа = ирКэш.Получить();
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	Форма = мПлатформа.ПолучитьФорму("ВыборГлобальнойКоманды");
	Форма.ТекущийЭлементАктивнойФормы = ирОбщий.ТекущийЭлементАктивнойУправляемойФормыЛкс();
	Форма.ОткрытьМодально();
	
КонецПроцедуры

#КонецЕсли 

////////////////////////////////////////////////////////////////////////////////
// ОТЛАДКА

// Обертка ирОбщий.ПрЛкс(). Присваивает первому параметру второй.
// Удобно вызывать из отладчика через диалог "Вычислить выражение". 
//
// Параметры:
//  П1           – Произвольный – параметр1;
//  П2           – Произвольный – параметр2;
//
// Возвращаемое значение:
//  П2 – Не используется.
//
Функция Пр(п1, п2 = Неопределено) Экспорт
	
	Результат = ирОбщий.ПрЛкс(п1, п2);
	Возврат Результат;
	
КонецФункции // Присвоить()

// Обертка ирОбщий.ДуЛкс(). Выполняет программный код, переданный как параметр.
// Остальные Параметры могут участвовать в теле этого кода.
// Удобно использовать в отладчике.
//
// Параметры:
//  П1           – Произвольный – параметр1;
//  П2           – Произвольный – параметр2;
//  П3           – Произвольный – параметр3;
//  П4           – Произвольный – параметр4;
//
// Возвращаемое значение:
//  Неопределено – Не используется.
//
Функция Ду(Знач ТекстПрограммы, п1 = 0, п2 = 0, п3 = 0, п4 = 0)  Экспорт
	
	Результат = ирОбщий.ДуЛкс(ТекстПрограммы, п1, п2, п3, п4);
	Возврат Результат;
	
КонецФункции // Ду()

// Обертка ирОбщий.ОперироватьЛкс(). На клиенте открывает консоль кода с передачей туда всех своих параметров. На сервере сразу выполняет код.
// Изменения параметров возвращаются в вызывающий контекст в модальном режиме.
//
// Параметры:
//  ТекстПрограммы    - Строка - программный код для передачи в консоль кода или выполнения;
//  РежимОперации     – Число - 0 - немодально, 1 - модально, 2 - неинтерактивно (на сервере всегда);
//  СтрокаИменПараметров – Строка - имена параметров для консоли кода через запятую, если не указаны, то будут оригинальные П*;
//  П*             – Произвольный - параметры для использования при выполнении программного кода;
//
// Возвращаемое значение:
//  Строка - описание ошибок.
//
Функция Оперировать(Знач ТекстПрограммы = "", Знач РежимОперации = 0, СтрокаИменПараметров= "",
	П1 = Null, П2 = Null, П3 = Null, П4 = Null, П5 = Null, П6 = Null, П7 = Null, П8 = Null, П9 = Null) Экспорт

	Результат = ирОбщий.ОперироватьЛкс(ТекстПрограммы, РежимОперации, СтрокаИменПараметров, П1, П2, П3, П4, П5, П6, П7, П8, П9);
	Возврат Результат;

КонецФункции // РП()

// Обертка ирОбщий.ПерЛкс(). Подготавливает строку для помещения всех переменных в структуру с целью ее дальнейшего вычисления в отладчике "Вычислить(Пер())".
// Изменения параметров возвращаются в вызывающий контекст.
//
// Параметры:
//  ТекстПрограммы    - Строка, *"" - программный код для анализа, берется из буфера обмена если пустой.
//
// Возвращаемое значение:
//  Строка для вычисления в отладчике.
//
Функция Пер(Знач ТекстПрограммы =  "") Экспорт
	
	Результат = ирОбщий.ПерЛкс(ТекстПрограммы);
	Возврат Результат;
	
КонецФункции

// Обертка ирОбщий.ПолВТЛкс(). Функция получает структуру (Имя временной таблицы; Таблица значений) из указанного запроса или менеджера временных таблиц.
// Полезна для просмотра временных таблиц из менеджера временных таблиц серверного контекста в отладчике.
// Параметры:
//   ЗапросИлиМенеджерВременныхТаблиц - Запрос, МенеджерВременныхТаблиц
//   ИменаВременныхТаблиц - Строка, *"" - имена существующих, но возможно не используемых в тексте запроса временных таблиц через запятую
//   ДопустимоеЧислоСтрок - Число, *500000 - выбирать из временной таблицы не более этого числа строк
//
// Результат - ТаблицаЗначений, Структура
//
Функция ПолВТ(ЗапросИлиМенеджерВременныхТаблиц, ИменаВременныхТаблиц = "", ДопустимоеЧислоСтрок = 500000) Экспорт
	
	Результат = ирОбщий.ПолВТЛкс(ЗапросИлиМенеджерВременныхТаблиц, ИменаВременныхТаблиц, ДопустимоеЧислоСтрок);
	Возврат Результат;
	
КонецФункции // ПолВТ()

// Обертка ирОбщий.ТехНЛкс(). Начать трассу в технологическом журнале. Сам технологический журнал надо заранее включить.
Функция ТехН() Экспорт
	
	Результат = ирОбщий.ТехНЛкс();
	Возврат Результат;
	
КонецФункции

// Обертка ирОбщий.ТехКЛкс(). Кончить трассу в технологическом журнале и показать ее анализ
Функция ТехК() Экспорт
	
	Результат = ирОбщий.ТехКЛкс();
	Возврат Результат;
	
КонецФункции

#Если Клиент Тогда

// Обертка ирОбщий.ПопЛкс(). Подготавливает строку для вызова Оперировать() в отладчике. Вызвается путем вычисления "Вычислить(Поп())".
// Изменения параметров возвращаются в вызывающий контекст.
//
// Параметры:
//  ТекстПрограммы    - Строка, *"" - программный код для передачи в консоль кода или выполнения, берется из буфера обмена если пустой;
//  РежимОперации     – Число - 0 - немодально, 1 - модально, 2 - неинтерактивно (на сервере всегда);
//
// Возвращаемое значение:
//  Строка для вычисления в отладчике.
//
Функция Поп(Знач ТекстПрограммы =  "", РежимОперации = 1) Экспорт
	
	Результат = ирОбщий.ПопЛкс(ТекстПрограммы, РежимОперации);
	Возврат Результат;
	
КонецФункции

// Обертка ирОбщий.ОпЛкс(). Модально открывает консоль кода с передачей туда всех своих параметров.
// Удобно вызывать из отладчика через диалог "Вычислить выражение". 
// Изменения параметров возвращаются в вызывающий контекст.
//
// Параметры:
//  П*  – Произвольный;
//
// Возвращаемое значение:
//  Неопределено.
//
Функция Оп(П1 = Null, П2 = Null, П3 = Null, П4 = Null, П5 = Null) Экспорт

	Результат = ирОбщий.ОпЛкс(П1, П2, П3, П4, П5);
	Возврат Результат;

КонецФункции // Оп()

// Обертка ирОбщий.ОперироватьСтруктуройЛкс(). Открывает консоль кода с передачей туда структуры параметров.
// Изменения параметров возвращаются в структуру, но не в вызывающий контекст.
//
// Параметры:
//  ТекстПрограммы - Строка;
//  Модально     – Булево - открывать окно модально;
//  СтруктураПараметров – Структура - ключи соответсвуют именам параметов, а значения их значениям.
//
// Возвращаемое значение:
//  Неопределено.
//
Функция ОперироватьСтруктурой(Знач ТекстПрограммы = "", Модально = Ложь, СтруктураПараметров) Экспорт

	Результат = ирОбщий.ОперироватьСтруктуройЛкс(ТекстПрограммы, Модально, СтруктураПараметров);
	Возврат Результат;

КонецФункции // РП()

// Обертка ирОбщий.ОпсЛкс(). Обертка ОперироватьСтруктурой. Модально открывает консоль кода с передачей туда всех своих параметров.
// Удобно вызывать из отладчика через диалог "Вычислить выражение". 
// Изменения параметров возвращаются в структуру, но не в вызывающий контекст.
//
// Параметры:
//  СтруктураПараметров – Структура - ключи соответсвуют именам параметов, а значения их значениям.
//
// Возвращаемое значение:
//  Неопределено.
//
Функция Опс(Знач СтруктураПараметров) Экспорт

	Результат = ирОбщий.ОпсЛкс(СтруктураПараметров);
	Возврат Результат;

КонецФункции // Опс()

// Обертка ирОбщий.НаблюдатьЛкс(). Выводит в окно сообщений переданное значение вместе с типом и заданным представлением.
//
// Параметры:
//  Значение     - Произвольный;
//  *Представление – Строка, *"" - представление наблюдаемого значения.
//
Процедура Наблюдать(Знач Значение, Представление = "") Экспорт

	ирОбщий.НаблюдатьЛкс(Значение, Представление);

КонецПроцедуры // Наблюдать()

#КонецЕсли 

// Обертка ирОбщий.ОтладитьЛкс(). Открывает нужную консоль для редактирования сложного объекта. 
// Варианты использования в зависимости от типа параметра Объект:
//   Запрос, COMОбъект - открывает Запрос или ADODB.Command или ADODB.Connection в консоли запросов
//   ПостроительЗапроса - открывает результирующий запрос построителя запросов в консоли запросов
//   ПостроительОтчета - открывает построитель отчета в консоли построителей отчетов, откуда можно открыть результирующий запрос построителя отчета в консоли запросов
//   СхемаКомпоновки - открывает схему компоновки в консоли компоновки данных, откуда можно открыть результирующие (из макета компоновки) запросы в консоли запросов
//
// Параметры:
//  Объект       – Запрос, ПостроительЗапроса, ПостроительОтчета, СхемаКомпоновкиДанных, COMОбъект.ADODB.Command - исследуемый объект;
//  Модально     – Булево - открывать окно модально, должно быть Истина для использования функции в отладчике;
//  НастройкаКомпоновкиИлиТекстЗапроса - НастройкиКомпоновкиДанных, Строка, *Неопределено - настройки для схемы компоновки, текст запроса для WMI или ADODB.Connection;
//  ВнешниеНаборыДанных - Структура, *Неопределено - внешние наборы данных для схемы компоновки;
//  ОтложеннаяОтладка - Булево - на сервере игнорируется (равно Истина), вместо открытия инструмента отладки сразу выполняется помещение
//                      объектов отладки во временное хранилище;
//  ДопустимоеЧислоСтрокВоВременнойТаблицеОтложеннойОтладки - Число, *500000 - допустимое количество строк во всех временных таблицах запроса
//                      для отложенной отладки, больше этого количества строки не сохраняются, о чем сообщается в результате;
//  Наименование - Строка - наименование сохраняемого объекта отложенной отладки;
//
// Возвращаемое значение:
//  Неопределено.
//
Функция Отладить(Знач Объект, Модально = Ложь, Знач НастройкаКомпоновкиИлиТекстЗапроса = Неопределено, Знач ВнешниеНаборыДанных = Неопределено,
	ОтложенноеВыполнение = Ложь, ДопустимоеЧислоСтрокВоВременнойТаблицеОтложеннойОтладки = 500000, Наименование = "") Экспорт 
	
	Результат = ирОбщий.ОтладитьЛкс(Объект, Модально, НастройкаКомпоновкиИлиТекстЗапроса, ВнешниеНаборыДанных, ОтложенноеВыполнение, ДопустимоеЧислоСтрокВоВременнойТаблицеОтложеннойОтладки,, Наименование);
	Возврат Результат;
	
КонецФункции 

// Обертка ирОбщий.ОтЛкс(). Модально (на клиенте) или отложенно (на сервере) открывает нужную консоль для редактирования/отладки объекта.
// Удобно вызывать из отладчика через диалог "Вычислить выражение". 
// Варианты использования в зависимости от типа параметра Объект:
//   Запрос, COMОбъект, HttpСоединение - открывает Запрос или ADODB.Command или ADODB.Connection в консоли запросов
//   ПостроительЗапроса - открывает результирующий запрос построителя запросов в консоли запросов
//   ПостроительОтчета - открывает построитель отчета в консоли построителей отчетов, откуда можно открыть результирующий запрос построителя отчета в консоли запросов
//   СхемаКомпоновки - открывает схему компоновки в консоли компоновки данных, откуда можно открыть результирующие (из макета компоновки) запросы в консоли запросов
//   МакетКомпоновкиДанных - открытвает запросы макета компоновки в консоли запросов
//   ОтчетОбъект - открывает схему и настройки компоновки отчета в консоли компоновки данных, откуда можно открыть результирующие (из макета компоновки) запросы в консоли запросов
//
// Параметры:
//  Объект       – Запрос, ПостроительЗапроса, ПостроительОтчета, СхемаКомпоновкиДанных, МакетКомпоновкиДанных, ОтчетОбъект, ADODB.Command, ADODB.Connection, HttpСоединение - исследуемый объект;
//  НастройкаКомпоновкиИлиТекстЗапросаИлиИменаВременныхТаблиц - НастройкиКомпоновкиДанных, Строка, *Неопределено - 
//                      если первый параметр СхемаКомпоновкиДанных, то настройки компоновки,
//                      если первый параметр WMI или ADODB.Connection, то текст запроса,
//                      если первый параметр HttpСоединение, то HttpЗапрос,
//                      если первый параметр Запрос, имена временных таблиц разделенных запятыми;
//  ВнешниеНаборыДанных - Структура, *Неопределено - внешние наборы данных для схемы компоновки;
//  ОтложеннаяОтладка - Булево - на сервере игнорируется (равно Истина), вместо открытия инструмента отладки сразу выполняется помещение
//                      объектов отладки во временное хранилище;
//  Наименование - Строка - наименование сохраняемого объекта отложенной отладки;
//
// Возвращаемое значение:
//  Неопределено.
//
Функция От(Знач Объект, Знач НастройкаКомпоновкиИлиТекстЗапросаИлиИменаВременныхТаблиц = Неопределено, Знач ВнешниеНаборыДанных = Неопределено, ОтложеннаяОтладка = Ложь, Наименование = "") Экспорт 

	#Если ТолстыйКлиентОбычноеПриложение Тогда
		Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
			Пустышка = ПолучитьФорму(Неопределено); // Чтобы использовалась форма именно этого объекта
		КонецЕсли; 
	#КонецЕсли 
	Результат = ирОбщий.ОтЛкс(Объект, НастройкаКомпоновкиИлиТекстЗапросаИлиИменаВременныхТаблиц, ВнешниеНаборыДанных, ОтложеннаяОтладка, Наименование);
	Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
		ирПортативный.УсловныйДеструктор();
	КонецЕсли; 
	Возврат Результат;

КонецФункции

// Обертка ирОбщий.ИсследоватьЛкс(). Открывает исследователь объектов.
//
// Параметры:
//  Объект       – Произвольный, *Неопределено - объект, который будет исследован;
//  Модально     – Булево - открывать окно модально;
//  КакКоллекцию – Булево, *Ложь - исследовать как коллекцию вместо объекта.
//
// Возвращаемое значение:
//  Сам объект.
//
Функция Исследовать(Знач Объект = Неопределено, Модально = Ложь, КакКоллекцию = Ложь, ОтложенноеВыполнение = Ложь) Экспорт

	Результат = ирОбщий.ИсследоватьЛкс(Объект, Модально, КакКоллекцию, ОтложенноеВыполнение);
	Возврат Результат;
	
КонецФункции // Исследовать()

// Обертка ирОбщий.ИсЛкс(). Модально открывает объект в исследователе объектов
// Удобно вызывать из отладчика через диалог "Вычислить выражение". 
Функция Ис(Знач Объект = Неопределено, КакКоллекцию = Ложь, ОтложенноеВыполнение = Ложь) Экспорт
	
	#Если ТолстыйКлиентОбычноеПриложение Тогда
		Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
			Пустышка = ПолучитьФорму(Неопределено); // Чтобы использовалась форма именно этого объекта
		КонецЕсли; 
	#КонецЕсли 
	Результат = ирОбщий.ИсЛкс(Объект, КакКоллекцию, ОтложенноеВыполнение);
	Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
		ирПортативный.УсловныйДеструктор();
	КонецЕсли; 
	Возврат Результат;

КонецФункции // Ис()

// Обертка ирОбщий.ФайлЛкс() Возвращает текст из файла
Функция Файл(Знач ИмяФайла, Знач Кодировка = "") Экспорт 
	
	Результат = ирОбщий.ФайлЛкс(ИмяФайла, Кодировка);
	Возврат Результат;
	
КонецФункции

// обертка ирОбщий.СкорКолЛкс() Удаляет все элементы коллекции кроме заданного или первого.
Функция СокрКол(Коллекция, ОставитьЭлементИлиКлюч = Неопределено) Экспорт 
	
	ирОбщий.СокрКолЛкс(Коллекция, ОставитьЭлементИлиКлюч);
	
КонецФункции

//#КонецОбласти

#КонецЕсли

