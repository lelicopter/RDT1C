﻿// В этом модуле нельзя обращаться к подсистеме, т.к. это внешняя обработка

#Если Не ВебКлиент Тогда

Функция АдресСайтаЛкс() Экспорт 
	Возврат "devtool1c.ucoz.ru";
КонецФункции

Функция ИмяПродуктаЛкс() Экспорт 
	
	Возврат "ИнструментыРазработчикаTormozit";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция HTTPСоединение(ИмяСервера, Таймаут = 0, ИспользоватьЗащищенноеСоединение = Истина) Экспорт 
	
	ПортВременный = ?(ИспользоватьЗащищенноеСоединение, 443, 80);
	ЗащищенноеСоединение = ?(ИспользоватьЗащищенноеСоединение, Новый ЗащищенноеСоединениеOpenSSL(), Неопределено);
	Попытка
		Результат = Новый HTTPСоединение(ИмяСервера, ПортВременный,,,, Таймаут, ЗащищенноеСоединение);
	Исключение
		// Антибаг платформы https://bugboard.v8.1c.ru/error/000013833.html
		Результат = Новый HTTPСоединение(ИмяСервера, ПортВременный,,, Новый ИнтернетПрокси(Ложь), Таймаут, ЗащищенноеСоединение);
	КонецПопытки;
	Возврат Результат;
	
КонецФункции

// Разделяет URL по составным частям: протокол, сервер, путь к ресурсу.
//
// Параметры:
//  URL - Строка - ссылка на ресурс в сети Интернет
//
// Возвращаемое значение:
//  Структура:
//             Протокол            - Строка - протокол доступа к ресурсу
//             ИмяСервера          - Строка - сервер, на котором располагается ресурс
//             ПутьКФайлуНаСервере - Строка - путь к ресурсу на сервере
//
Функция РазделитьURLЛкс(Знач URL) Экспорт
	
	СтруктураURL = СтруктураURIЛкс(URL);
	
	Результат = Новый Структура;
	Результат.Вставить("Протокол", ?(ПустаяСтрока(СтруктураURL.Схема), "http", СтруктураURL.Схема));
	Результат.Вставить("ИмяСервера", СтруктураURL.ИмяСервера);
	Результат.Вставить("ПутьКФайлуНаСервере", СтруктураURL.ПутьНаСервере);
	
	Возврат Результат;
	
КонецФункции

// Разбирает строку URI на составные части и возвращает в виде структуры.
// На основе RFC 3986.
//
// Параметры:
//     СтрокаURI - Строка - ссылка на ресурс в формате: <схема>://<логин>:<пароль>@<хост>:<порт>/<путь>?<параметры>#<якорь>
//
// Возвращаемое значение:
//     Структура - составные части URI согласно формату:
//         * Схема         - Строка
//         * Логин         - Строка
//         * Пароль        - Строка
//         * ИмяСервера    - Строка - часть <хост>:<порт> входного параметра
//         * Хост          - Строка
//         * Порт          - Строка
//         * ПутьНаСервере - Строка - часть <путь>?<параметры>#<якорь> входного параметра
//
Функция СтруктураURIЛкс(Знач СтрокаURI) Экспорт
	
	СтрокаURI = СокрЛП(СтрокаURI);
	
	// схема
	Схема = "";
	Позиция = Найти(СтрокаURI, "://");
	Если Позиция > 0 Тогда
		Схема = НРег(Лев(СтрокаURI, Позиция - 1));
		СтрокаURI = Сред(СтрокаURI, Позиция + 3);
	КонецЕсли;

	// строка соединения и путь на сервере
	СтрокаСоединения = СтрокаURI;
	ПутьНаСервере = "";
	Позиция = Найти(СтрокаСоединения, "/");
	Если Позиция > 0 Тогда
		ПутьНаСервере = Сред(СтрокаСоединения, Позиция + 1);
		СтрокаСоединения = Лев(СтрокаСоединения, Позиция - 1);
	КонецЕсли;
		
	// информация пользователя и имя сервера
	СтрокаАвторизации = "";
	ИмяСервера = СтрокаСоединения;
	Позиция = Найти(СтрокаСоединения, "@");
	Если Позиция > 0 Тогда
		СтрокаАвторизации = Лев(СтрокаСоединения, Позиция - 1);
		ИмяСервера = Сред(СтрокаСоединения, Позиция + 1);
	КонецЕсли;
	
	// логин и пароль
	Логин = СтрокаАвторизации;
	Пароль = "";
	Позиция = Найти(СтрокаАвторизации, ":");
	Если Позиция > 0 Тогда
		Логин = Лев(СтрокаАвторизации, Позиция - 1);
		Пароль = Сред(СтрокаАвторизации, Позиция + 1);
	КонецЕсли;
	
	// хост и порт
	Хост = ИмяСервера;
	Порт = "";
	Позиция = Найти(ИмяСервера, ":");
	Если Позиция > 0 Тогда
		Хост = Лев(ИмяСервера, Позиция - 1);
		Порт = Сред(ИмяСервера, Позиция + 1);
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("Схема", Схема);
	Результат.Вставить("Логин", Логин);
	Результат.Вставить("Пароль", Пароль);
	Результат.Вставить("ИмяСервера", ИмяСервера);
	Результат.Вставить("Хост", Хост);
	Результат.Вставить("Порт", ?(ПустаяСтрока(Порт), Неопределено, Число(Порт)));
	Результат.Вставить("ПутьНаСервере", ПутьНаСервере);
	
	Возврат Результат;
	
КонецФункции

// Обновляет в строковом свойстве объекта часть, которая следует за маркером.
// Если маркер не находится, то он добавляется.
//
// Параметры:
//  пОбъект      - Объект, Строка - объект, строковое свойство которого будем обновлять, или само свойство по ссылке;
//  *пИмяСвойства - Строка, *"" - имя строкового Свойства объекта, указывается в случае, если свойство не передается по ссылке;
//  пНовыйТекст  - Строка - новая часть, которая следует за разделителем;
//  *пМаркер     - Строка, *"," - маркер.
//
Процедура ОбновитьТекстПослеМаркераЛкс(пОбъектИлиСвойство, пИмяСвойства = "", пНовыйТекст, пМаркер = ", ") Экспорт
	
	Если пИмяСвойства <> "" Тогда
		СтараяСтрока = пОбъектИлиСвойство[пИмяСвойства];
	Иначе
		СтараяСтрока = пОбъектИлиСвойство;
	КонецЕсли;
	ПозицияРазделителя = Найти(СтараяСтрока, пМаркер);
	Если ПозицияРазделителя = 0 Тогда 
		ПозицияРазделителя = СтрДлина(СтараяСтрока) + 1;
	КонецЕсли;
	НоваяСтрока = Лев(СтараяСтрока, ПозицияРазделителя - 1) + пМаркер + пНовыйТекст;
	Если пИмяСвойства <> "" Тогда
		пОбъектИлиСвойство[пИмяСвойства] = НоваяСтрока;
	Иначе
		пОбъектИлиСвойство               = НоваяСтрока;
	КонецЕсли;

КонецПроцедуры // ОбновитьТекстПослеМаркераЛкс()

// Функция разбивает строку разделителем.
// 
// Параметры:
//  пСтрока      - Строка - которую разбиваем;
//  *пРазделитель - Строка, "." - символ-разделитель;
//  *ОбрезатьНепечатныеСимволы - Булево, *Ложь - делать СокрЛП.
//  *ОставлятьПустуюСтроку - Булево, *Истина - если передана пустая строка, то добавлять ее в массив.
//
// Возвращаемое значение:
//  Массив - фрагментов.
//
Функция ПолучитьМассивИзСтрокиСРазделителемЛкс(Знач Стр, Знач Разделитель = ".", Знач ОбрезатьНепечатныеСимволы = Ложь, Знач ОставлятьПустуюСтроку = Истина) Экспорт
	
	МассивСтрок = Новый Массив;
	Если Истина
		И Не ОставлятьПустуюСтроку 
		И ПустаяСтрока(Стр)
	Тогда
		Возврат МассивСтрок;
	КонецЕсли; 
	Если Разделитель = " " Тогда
		Стр = СокрЛП(Стр);
		Пока 1=1 Цикл
			Поз = Найти(Стр, Разделитель);
			Если Поз=0 Тогда
				МассивСтрок.Добавить(Стр);
				Возврат МассивСтрок;
			КонецЕсли;
			МассивСтрок.Добавить(Лев(Стр, Поз-1));
			Стр = СокрЛ(Сред(Стр, Поз));
		КонецЦикла;
	Иначе
		ДлинаРазделителя = СтрДлина(Разделитель);
		Пока 1=1 Цикл
			Поз = Найти(Стр, Разделитель);
			Если Поз=0 Тогда
				Фрагмент = Стр;
				Если ОбрезатьНепечатныеСимволы Тогда
					Фрагмент = СокрЛП(Фрагмент);
				КонецЕсли;
				МассивСтрок.Добавить(Фрагмент);
				Возврат МассивСтрок;
			КонецЕсли;
			Фрагмент = Лев(Стр, Поз-1);
			Если ОбрезатьНепечатныеСимволы Тогда
				Фрагмент = СокрЛП(Фрагмент);
			КонецЕсли;
			МассивСтрок.Добавить(Фрагмент);
			Стр = Сред(Стр, Поз+ДлинаРазделителя);
		КонецЦикла;
	КонецЕсли;
	Возврат МассивСтрок;
		
КонецФункции // ПолучитьМассивИзСтрокиСРазделителемЛкс()

Функция СтрокиРавныЛкс(Знач Строка1, Знач Строка2, СУчетомРегистра = Ложь, БезПравыхНепечатныхСимволов = Ложь) Экспорт
	
	Если Не СУчетомРегистра Тогда
		Строка1 = НРег(Строка1);
		Строка2 = НРег(Строка2);
	КонецЕсли; 
	Если БезПравыхНепечатныхСимволов Тогда
		Строка1 = СокрП(Строка1);
		Строка2 = СокрП(Строка2);
	КонецЕсли; 
	Результат = Строка1 = Строка2;
	Возврат Результат;
	
КонецФункции

Функция НомерВерсииПлатформыЛкс(ВключаяНомерСборки = Ложь) Экспорт 
	
	СисИнфо = Новый СистемнаяИнформация;
	Фрагменты = ПолучитьМассивИзСтрокиСРазделителемЛкс(СисИнфо.ВерсияПриложения);
	Результат = Число(Фрагменты[0]) * 100 * 1000 + Число(Фрагменты[1]) * 1000 + Число(Фрагменты[2]);
	Если ВключаяНомерСборки Тогда
		Результат = Результат * 10000 + Число(Фрагменты[3]);
	КонецЕсли; 
	Возврат Результат;
	
КонецФункции

Функция НомерРежимаСовместимостиЛкс() Экспорт 
	
	ТекущийРежимСовместимости = Метаданные.РежимСовместимости;
	Если ТекущийРежимСовместимости = Метаданные.СвойстваОбъектов.РежимСовместимости.НеИспользовать Тогда
		СисИнфо = Новый СистемнаяИнформация;
		Фрагменты = ПолучитьМассивИзСтрокиСРазделителемЛкс(СисИнфо.ВерсияПриложения);
	Иначе
		// Пример значения СтрокаВерсии = Версия8_3_1
		ТекущийРежимСовместимости = СтрЗаменить(ТекущийРежимСовместимости, "Версия", "");
		ТекущийРежимСовместимости = СтрЗаменить(ТекущийРежимСовместимости, "Version", ""); // Вариант встроенного языка Английский
		Фрагменты = ПолучитьМассивИзСтрокиСРазделителемЛкс(ТекущийРежимСовместимости, "_");
	КонецЕсли; 
	Результат = Число(Фрагменты[0]) * 100 * 1000 + Число(Фрагменты[1]) * 1000;
	Если Фрагменты.Количество() > 2 Тогда
		Результат = Результат + Число(Фрагменты[2]);
	КонецЕсли;
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция ВыбратьФайлЛкс(РежимОткрытия = Истина, Расширение = "", ОписаниеФормата = "", Знач ПолноеИмяФайла = "", Знач Каталог = "", Знач КраткоеИмя = "") Экспорт
	
	ВыборФайла = ДиалогВыбораФайлаЛкс(РежимОткрытия, Расширение, ОписаниеФормата, ПолноеИмяФайла, Каталог, КраткоеИмя);
	Если Не ВыборФайла.Выбрать() Тогда
		Возврат Неопределено;
	КонецЕсли;
	Возврат ВыборФайла.ПолноеИмяФайла;
	
КонецФункции

&НаКлиенте
Функция ФильтрДляВыбораФайлаЛкс(СтрокаРасширений, ОписаниеФормата = "", РазрешитьВсеФайлы = Истина) Экспорт
	
	Расширения = ПолучитьМассивИзСтрокиСРазделителемЛкс(СтрокаРасширений, ",", Истина);
	Результат = "";
	Для Каждого Расширение Из Расширения Цикл
		Если Результат <> "" Тогда
			Результат = Результат + "|";
		КонецЕсли;
		ОписаниеРасширения = "(*." + Расширение + ")|*." + Расширение;
		Если ЗначениеЗаполнено(ОписаниеФормата) Тогда
			ОписаниеРасширения = ОписаниеФормата + " " + ОписаниеРасширения;
		КонецЕсли;
		Результат = Результат + ОписаниеРасширения;
	КонецЦикла;
	Если РазрешитьВсеФайлы Тогда
		Результат = Результат + "|Все файлы (*.*)|*.*";
	КонецЕсли; 
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция ДиалогВыбораФайлаЛкс(РежимОткрытия = Истина, Знач Расширение = "", ОписаниеФормата = "", Знач ПолноеИмяФайла = "", Знач Каталог = "", Знач КраткоеИмя = "") Экспорт 
	
	Если РежимОткрытия = Истина Тогда
		РежимДиалога = РежимДиалогаВыбораФайла.Открытие;
	Иначе
		РежимДиалога = РежимДиалогаВыбораФайла.Сохранение;
	КонецЕсли; 
	ВыборФайла = Новый ДиалогВыбораФайла(РежимДиалога);
	Если ЗначениеЗаполнено(ПолноеИмяФайла) Тогда
		Файл = Новый Файл(ПолноеИмяФайла);
		ВыборФайла.Каталог = Файл.Путь;
		ВыборФайла.ПолноеИмяФайла = Файл.Имя;
	Иначе
		ВыборФайла.Каталог = Каталог;
		ВыборФайла.ПолноеИмяФайла = КраткоеИмя;
	КонецЕсли; 
	ВыборФайла.Расширение = Расширение;
	Если Не ЗначениеЗаполнено(Расширение) Тогда
		Расширение = "*";
	КонецЕсли; 
	ВыборФайла.Фильтр = ФильтрДляВыбораФайлаЛкс(Расширение, ОписаниеФормата);
	Возврат ВыборФайла;

КонецФункции

Функция ЭтотРасширениеКонфигурацииЛкс() Экспорт
	
	Результат = Неопределено;
	Попытка
		ЭтиРасширения = Вычислить("РасширенияКонфигурации").Получить(); // Антибаг платформы https://partners.v8.1c.ru/forum/t/1607016/m/1607016
	Исключение
		ВызватьИсключение "Ошибка получения списка расширений конфигурации: " + КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки; 
	ОтборРасширений = Новый Структура("Имя", ИмяПродуктаЛкс());
	ЭтиРасширения = Вычислить("РасширенияКонфигурации").Получить(ОтборРасширений);
	Если ЭтиРасширения.Количество() > 0 Тогда 
		Результат = ЭтиРасширения[0];
	КонецЕсли; 
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ПриОткрытии()
	
	НастроитьЭлементыФормы(ЭтаФорма);
	ПодключитьОбработчикОжидания("ПолучитьАктуальнуюВерсиюОтложенно", 0.1, Истина);

КонецПроцедуры

&НаКлиенте
Процедура ПолучитьАктуальнуюВерсиюОтложенно()
	
	Если НомерВерсииПлатформыЛкс() < 802018 Тогда
		// объект HTTPЗапрос недоступен
		Возврат;
	КонецЕсли; 
	НазваниеНаСайте = "Инструменты разработчика " + НазваниеВарианта + " 1С 8";
	ИмяСервера = АдресСайтаЛкс();
	Соединение = HTTPСоединение(ИмяСервера, 5);
	#Если Сервер И Не Сервер Тогда
	    Соединение = Новый HTTPСоединение;
	#КонецЕсли
	Запрос = Новый ("HTTPЗапрос");
	Запрос.АдресРесурса = "load/osnovnye/1";
	Попытка
		СтрокаОтвета = Соединение.Получить(Запрос);
	Исключение
		СтрокаОтвета = Неопределено;
	КонецПопытки; 
	Если СтрокаОтвета <> Неопределено Тогда
		ЧтениеHtml = Новый ЧтениеHTML;
		ЧтениеHtml.УстановитьСтроку(СтрокаОтвета.ПолучитьТелоКакСтроку());
		ПостроительDOM = Новый ПостроительDOM;
		ДокументHTML = ПостроительDOM.Прочитать(ЧтениеHTML);
		УзлыФайлов = ДокументHTML.ПолучитьЭлементыПоИмени("a");
		Для Каждого УзелФайла Из УзлыФайлов Цикл
			ТекстовоеСодержимое = НРег(УзелФайла.ТекстовоеСодержимое);
			Если Найти(ТекстовоеСодержимое, НРег(НазваниеНаСайте)) > 0 Тогда
				ЭтаФорма.АктуальнаяВерсия = Сред(ТекстовоеСодержимое, Найти(ТекстовоеСодержимое, "v") + 1);
				ЭтаФорма.СсылкаНаСтраницуСкачивания = УзелФайла.Гиперссылка;
				Прервать;
			КонецЕсли; 
		КонецЦикла;
		НастроитьЭлементыФормы(ЭтаФорма);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура УстановитьНаКлиенте()
	
	Если ЗначениеЗаполнено(ФайлРасширения) Тогда
		ДвоичныеДанные = Новый ДвоичныеДанные(ФайлРасширения);
	Иначе
		ИмяСервера = АдресСайтаЛкс();
		Соединение = HTTPСоединение(ИмяСервера);
		#Если Сервер И Не Сервер Тогда
		    Соединение = Новый HTTPСоединение;
		#КонецЕсли
		Запрос = Новый ("HTTPЗапрос");
		Запрос.АдресРесурса = СсылкаНаСтраницуСкачивания;
		СтрокаОтвета = Соединение.Получить(Запрос);
		СсылкаНаСкачивание = Неопределено;
		Если СтрокаОтвета <> Неопределено Тогда
			ЧтениеHtml = Новый ЧтениеHTML;
			ЧтениеHtml.УстановитьСтроку(СтрокаОтвета.ПолучитьТелоКакСтроку());
			ПостроительDOM = Новый ПостроительDOM;
			ДокументHTML = ПостроительDOM.Прочитать(ЧтениеHTML);
			УзлыФайлов = ДокументHTML.ПолучитьЭлементыПоИмени("a");
			Для Каждого УзелФайла Из УзлыФайлов Цикл
				ТекстовоеСодержимое = НРег(УзелФайла.ТекстовоеСодержимое);
				Если Ложь
					Или Найти(ТекстовоеСодержимое, НРег("Скачать с сервера")) > 0 
					Или Найти(ТекстовоеСодержимое, НРег("Скачать удаленно")) > 0
				Тогда
					СсылкаНаСкачивание = УзелФайла.Гиперссылка;
					Прервать;
				КонецЕсли; 
			КонецЦикла;
		КонецЕсли;
		Если СсылкаНаСкачивание = Неопределено Тогда
			ВызватьИсключение "Ссылка на скачивание не найдена"; 
		КонецЕсли; 
		Запрос = Новый ("HTTPЗапрос");
		Запрос.АдресРесурса = СсылкаНаСкачивание;
		СтрокаОтвета = Соединение.Получить(Запрос);
		СсылкаНаСкачивание = СтрокаОтвета.Заголовки.Получить("Location");
		СтруктураАдреса = РазделитьURLЛкс(СсылкаНаСкачивание);          
		Соединение = HTTPСоединение(СтруктураАдреса.ИмяСервера);
		Запрос = Новый ("HTTPЗапрос");
		Запрос.АдресРесурса = СтруктураАдреса.ПутьКФайлуНаСервере;
		ИмяАрхиваНовойВерсии = ПолучитьИмяВременногоФайла("cfe");
		СтрокаОтвета = Соединение.Получить(Запрос);
		ДвоичныеДанные = СтрокаОтвета.ПолучитьТелоКакДвоичныеДанные();
		ДвоичныеДанные.Записать(ИмяАрхиваНовойВерсии);
	КонецЕсли; 
	УстановитьНаСервере(ДвоичныеДанные);
	
КонецПроцедуры

Процедура УстановитьНаСервере(Знач ДвоичныеДанные)
	
	ЭтотРасширение = ЭтотРасширениеКонфигурацииЛкс();
	Если ЭтотРасширение = Неопределено Тогда
		ЭтотРасширение = РасширенияКонфигурации.Создать();
	КонецЕсли; 
	УстановитьСвойстваРасширения(ЭтотРасширение);
	ЭтотРасширение.Записать(ДвоичныеДанные);
	
	// Антибаг режима совместимости 8.3.10. В нем флаг ПредупреждатьОбОпасныхДействиях с первого раза не устанавливается https://www.hostedredmine.com/issues/925886
	ЭтотРасширение = ЭтотРасширениеКонфигурацииЛкс();
	Если ЭтотРасширение.ЗащитаОтОпасныхДействий.ПредупреждатьОбОпасныхДействиях Тогда
		ЭтотРасширение.ЗащитаОтОпасныхДействий.ПредупреждатьОбОпасныхДействиях = Ложь;
		ЭтотРасширение.Записать();
	КонецЕсли; 
	
	//ЭтотРасширение.ПолучитьДанные().Записать(ИмяАрхиваНовойВерсии);
	ОбновитьРасширениеУстановлено();
	СделатьВидимымНаСервере(Ложь);

КонецПроцедуры

Процедура УстановитьСвойстваРасширения(Знач ЭтотРасширение)
	
	#Если Сервер И Не Сервер Тогда
		ЭтотРасширение = РасширенияКонфигурации.Создать();
	#КонецЕсли
	Попытка
		ЭтотРасширение.Активно = Истина; // Свойство появилось в 8.3.12
		ЭтотРасширение.ИспользоватьОсновныеРолиДляВсехПользователей = Ложь; // Свойство появилось в 8.3.15
	Исключение
	КонецПопытки; 
	ЭтотРасширение.БезопасныйРежим = Ложь;
	ЭтотРасширение.ЗащитаОтОпасныхДействий.ПредупреждатьОбОпасныхДействиях = Ложь;
	//ЭтотРасширение.Назначение = Метаданные.СвойстваОбъектов.НазначениеРасширенияКонфигурации.Дополнение;

КонецПроцедуры

&НаКлиенте
Процедура Установить(Команда)
	УстановитьНаКлиенте();
	НастроитьЭлементыФормы(ЭтаФорма);
	Если Не Элементы.ДекорацияНужноДобавитьПользователя.Видимость Тогда
		ЗапуститьСеанс();
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Функция ЭтоУчебнаяПлатформа() Экспорт 

	ВременныйФайл = ПолучитьИмяВременногоФайла("mxl");
	ТабДок = Новый ТабличныйДокумент;
	Попытка
		ТабДок.Записать(ВременныйФайл, ТипФайлаТабличногоДокумента.MXL7); // В учебной версии платформы это запрещено https://www.hostedredmine.com/issues/923942
	Исключение
		ОписаниеОшибки = ОписаниеОшибки(); 
		Если Найти(ОписаниеОшибки, "синхронных") > 0 Тогда
			// Использование синхронных методов на клиенте запрещено!
			Возврат Ложь;
		КонецЕсли;
		Возврат Истина;
	КонецПопытки; 
	УдалитьФайлы(ВременныйФайл);
	Возврат Ложь;

КонецФункции

&НаКлиенте
Функция ЛиПлатформаWindows() Экспорт
	
	СисИнфо = Новый СистемнаяИнформация;
	Результат = Ложь
		Или СисИнфо.ТипПлатформы = ТипПлатформы.Windows_x86
		Или СисИнфо.ТипПлатформы = ТипПлатформы.Windows_x86_64;
	Возврат Результат;

КонецФункции

&НаКлиенте
// Добавляет если нужно расширение ".exe"
Функция ИмяИсполняемогоФайла(Знач ИмяБезРасширения)
	Результат = ИмяБезРасширения;
	Если ЛиПлатформаWindows() Тогда
		Результат = Результат + ".exe";
	КонецЕсли;
	Возврат Результат;
КонецФункции

&НаКлиенте
Функция ИмяИсполняемогоФайлаПлатформы(Полное = Истина, Тонкий = Ложь) Экспорт 
	Результат = "1cv8";
	Если Тонкий Тогда
		Результат = Результат + "c";
	КонецЕсли; 
	Если ЭтоУчебнаяПлатформа() Тогда
		Результат = Результат + "t";
	КонецЕсли; 
	Результат = ИмяИсполняемогоФайла(Результат);
	Если Полное Тогда
		Результат = КаталогПрограммы() + Результат;
	КонецЕсли; 
	Возврат Результат;
КонецФункции

&НаКлиенте
Процедура ЗапуститьСеанс()
	
	#Если ТолстыйКлиентУправляемоеПриложение Тогда
		ЗапуститьСистему("/DEBUG");
		Возврат;
	#КонецЕсли
	#Если Не ВебКлиент Тогда
		ПараметрыЗапуска = " ENTERPRISE /IBConnectionString""" + СтрЗаменить(СтрокаСоединенияИнформационнойБазы(), """", """""") + """ /DEBUG /CВключитьИР";
		ЗапуститьПриложение("""" + ИмяИсполняемогоФайлаПлатформы() + """ " + ПараметрыЗапуска);
	#КонецЕсли 

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	#Если ВебКлиент Тогда
		Сообщить("ВебКлиент не поддерживается");
		Отказ = Истина;
	#КонецЕсли
	Если НомерВерсииПлатформыЛкс() < 803010 Тогда
		Сообщить("Необходима версия платформы 8.3.10 или выше");
		Отказ = Истина;
		Возврат;
	КонецЕсли; 
	Если НомерРежимаСовместимостиЛкс() < 803009 Тогда
		Сообщить("Необходим режим совместимости конфигурации 8.3.9 или выше");
		Отказ = Истина;
		Возврат;
	КонецЕсли; 
	ОбновитьРасширениеУстановлено();
	Если Не РасширениеУстановлено И Метаданные.Обработки.Найти("ирПлатформа") <> Неопределено Тогда
		Сообщить("В конфигурации встроена подсистема ""Инструменты разработчика"". Установка расширения невозможна.");
		Отказ = Истина;
		Возврат;
	КонецЕсли; 
	ОбъектМД = РеквизитФормыВЗначение("Объект").Метаданные();
	#Если Сервер И Не Сервер Тогда
		ОбъектМД = Обработки.ирПлатформа.Создать().Метаданные();
	#КонецЕсли
	ЭтаФорма.АвтоЗаголовок = Ложь;
	ЭтаФорма.Заголовок = ОбъектМД.Представление() + " " + ОбъектМД.Комментарий;
	ЭтаФорма.НазваниеВарианта = "Расширение";
	ЭтаФорма.ПараметрЗапуска = "ВключитьИР";
	// Если поднять режим совместимости расширения и конфигурации до 8.3.14 и указать основую роль ирРазработчик, то не будет этого ограничения
	Элементы.ДекорацияНужноДобавитьПользователя.Видимость = ПользователиИнформационнойБазы.ПолучитьПользователей().Количество() = 0;
	Элементы.ДекорацияНужноДобавитьПользователя1.Видимость = Истина
		И НомерРежимаСовместимостиЛкс() >= 803014
		И ПользователиИнформационнойБазы.ПолучитьПользователей().Количество() = 0;
	Элементы.ДекорацияЗапретСинхронныхВызовов.Видимость = Метаданные.РежимИспользованияСинхронныхВызововРасширенийПлатформыИВнешнихКомпонент = Метаданные.СвойстваОбъектов.РежимИспользованияСинхронныхВызововРасширенийПлатформыИВнешнихКомпонент.НеИспользовать;
	Элементы.ДекорацияЗапретРусскийЯзык.Видимость = Метаданные.Языки.Найти("Русский") = Неопределено;
	Элементы.ГруппаСпособыСделатьВидимыми.Доступность = Не Элементы.ДекорацияНужноДобавитьПользователя.Видимость;
	ОбновитьДоступностьКомандыСделатьВидимыми();

КонецПроцедуры

&НаСервере
Процедура ОбновитьДоступностьКомандыСделатьВидимыми()
	
	Элементы.СделатьВидимым.Доступность = Истина
	И РасширениеУстановлено 
	И (Ложь
		Или Метаданные.Обработки.Найти("ирПлатформа") = Неопределено
		Или Не ПравоДоступа("Просмотр", Метаданные.Обработки.ирПлатформа));

КонецПроцедуры

&НаСервере
Процедура ОбновитьРасширениеУстановлено()
	
	ЭтотРасширение = ЭтотРасширениеКонфигурацииЛкс();
	#Если Сервер И Не Сервер Тогда
		ЭтотРасширение = РасширенияКонфигурации.Создать();
	#КонецЕсли
	ЭтаФорма.РасширениеУстановлено = ЭтотРасширение <> Неопределено;
	Попытка
		ЭтаФорма.РасширениеАктивно = ЭтотРасширение <> Неопределено И ЭтотРасширение.Активно;
	Исключение
		ЭтаФорма.РасширениеАктивно = ЭтотРасширение <> Неопределено;
	КонецПопытки; 
	ОбновитьДоступностьКомандыСделатьВидимыми(); 
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	РезультатВыбора = ВыбратьФайлЛкс(, "cfe", "Расширение конфигурации 1С", ФайлРасширения);
	Если РезультатВыбора <> Неопределено Тогда
		ЭтаФорма.ФайлРасширения = РезультатВыбора;
		ФайлПриИзменении();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлПриИзменении(Элемент = Неопределено)
	
	НастроитьЭлементыФормы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьЭлементыФормы(ЭтаФорма)
	
	Если Не ЗначениеЗаполнено(АктуальнаяВерсия) Тогда
		Файл = Новый Файл(ФайлРасширения);
		Попытка
			ФайлСуществует = Файл.Существует();
		Исключение
			ПоказатьОповещениеПользователя("",, "В конфигурации установлен запрет использования синхронных методов в тонком клиенте. Поэтому запускаем толстый клиент");
			#Если Не ВебКлиент Тогда
				ПараметрыЗапуска = " ENTERPRISE /IBConnectionString""" + СтрЗаменить(СтрокаСоединенияИнформационнойБазы(), """", """""") + """ /RunModeManagedApplication /DEBUG /Execute""" + ПолучитьИспользуемоеИмяФайла() + """";
				НачатьЗапускПриложения(Новый ОписаниеОповещения, """" + ИмяИсполняемогоФайлаПлатформы() + """ " + ПараметрыЗапуска);
			#КонецЕсли 
			Закрыть();
			Возврат;
		КонецПопытки;
	КонецЕсли;
	Элементы.Установить.Доступность = ЗначениеЗаполнено(АктуальнаяВерсия) Или ФайлСуществует;
	Элементы.Запустить.Доступность = Элементы.Установить.Доступность И Не РасширениеУстановлено И Не Элементы.ДекорацияНужноДобавитьПользователя.Видимость;
	Элементы.Удалить.Доступность = РасширениеУстановлено;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьИспользуемоеИмяФайла()
    Возврат РеквизитФормыВЗначение("Объект").ИспользуемоеИмяФайла;
КонецФункции

&НаСервере
Процедура СделатьВидимымНаСервере(ПрописатьСвойстваРасширения = Истина)
	
	Если ПрописатьСвойстваРасширения Тогда
		ЭтотРасширение = ЭтотРасширениеКонфигурацииЛкс();
		#Если Сервер И Не Сервер Тогда
			ЭтотРасширение = РасширенияКонфигурации.Создать();
		#КонецЕсли
		УстановитьСвойстваРасширения(ЭтотРасширение);
		ЭтотРасширение.Записать();
		ОбновитьРасширениеУстановлено();
	КонецЕсли; 
	Если Метаданные.Роли.Найти("ирРазработчик") <> Неопределено Тогда
		Пользователь = ПользователиИнформационнойБазы.ТекущийПользователь();
		Пользователь.Роли.Добавить(Метаданные.Роли.ирРазработчик);
		Пользователь.Роли.Добавить(Метаданные.Роли.ирПользователь);
		Попытка
			Пользователь.Записать();
		Исключение
			Если ЗначениеЗаполнено(Пользователь.Имя) Тогда 
				ВызватьИсключение;
			Иначе
				// Попытка изменения информации о пользователе информационной базы по умолчанию.
			КонецЕсли;
		КонецПопытки;
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура СделатьВидимым(Команда)
	СделатьВидимымНаСервере();
	ЗапуститьСеанс();
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияСкачатьВручнуюНажатие(Элемент)
	
	ОтносительныйАдрес = "/index/rasshirenie_variant/0-52";
	ЗапуститьПриложение("http://" + АдресСайтаЛкс() + ОтносительныйАдрес);
	
КонецПроцедуры

&НаСервере
Процедура УдалитьНаСервере()
	
	Расширение = ЭтотРасширениеКонфигурацииЛкс();
	Если Расширение <> Неопределено Тогда
		Расширение.Удалить();
	КонецЕсли; 
	ОбновитьРасширениеУстановлено();
	
КонецПроцедуры

&НаКлиенте
Процедура Удалить(Команда)
	УдалитьНаСервере();
	НастроитьЭлементыФормы(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьОднократно(Команда)
	
	УстановитьНаКлиенте();
	НастроитьЭлементыФормы(ЭтаФорма);
	Попытка
		ТекущаяДата = ТекущаяДата();
		ЗапуститьСеанс();
		Состояние("Ожидание запуска сеанса...");
		Успех = Ложь;
		ДатаПоследнегоВопроса = ТекущаяДата();
		ИмяКомпьютера = ИмяКомпьютера();
		НомерПервогоСеанса = Неопределено;
		СчетчикСерииСеансов = 0;
		ПериодичностьВопроса = 10;
		Пока Не Успех Цикл
			ОбработкаПрерыванияПользователя();
			Если ТекущаяДата() - ДатаПоследнегоВопроса >= ПериодичностьВопроса Тогда
				Ответ = Вопрос("Продолжить ожидание сеанса (" + ПериодичностьВопроса + " сек)?", РежимДиалогаВопрос.ДаНет);
				Если Ответ = КодВозвратаДиалога.Нет Тогда
					Прервать;
				КонецЕсли;
				ДатаПоследнегоВопроса = ТекущаяДата();
			КонецЕсли; 
			Если СеансСоздан(ИмяКомпьютера, ТекущаяДата, НомерПервогоСеанса) Тогда 
				СчетчикСерииСеансов = СчетчикСерииСеансов + 1;
				Если СчетчикСерииСеансов = 2 Тогда
					Прервать;
				КонецЕсли; 
			КонецЕсли; 
		КонецЦикла; 
		Состояние("");
	Исключение
		УдалитьНаСервере();
		ВызватьИсключение;
	КонецПопытки;
	УдалитьНаСервере();
	НастроитьЭлементыФормы(ЭтаФорма);

КонецПроцедуры

&НаСервереБезКонтекста
Функция СеансСоздан(Знач ИмяКомпьютера, Знач ТекущаяДата, выхНомерПервогоСеанса = Неопределено)
	
	Сеансы = ПолучитьСеансыИнформационнойБазы(); // Иногда выполняется долго
	Успех = Ложь;
	Для Каждого Сеанс Из Сеансы Цикл
		Если Истина
			И ТекущаяДата() - Сеанс.НачалоСеанса > 1
			И Сеанс.НачалоСеанса >= ТекущаяДата 
			И НРег(Сеанс.ИмяКомпьютера) = НРег(ИмяКомпьютера)
			И Сеанс.Пользователь <> Неопределено
			И НРег(Сеанс.Пользователь.Имя) = НРег(ИмяПользователя())
			И (Ложь
				Или выхНомерПервогоСеанса = Неопределено
				Или выхНомерПервогоСеанса <> Сеанс.НомерСеанса)
		Тогда
			выхНомерПервогоСеанса = Сеанс.НомерСеанса;
			Успех = Истина;
			Прервать;
		КонецЕсли; 
	КонецЦикла;
	Возврат Успех
	
КонецФункции

#КонецЕсли
