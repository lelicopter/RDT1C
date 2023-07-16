﻿//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирКлиент Экспорт;

Перем ФайлСтилейСинтаксПомощника Экспорт;
Перем ЗаменыВнешнихОбъектов;
Перем СоответствиеЗамены;
Перем типСтрока;
Перем СрабатываниеЗамен Экспорт;
Перем ВычислительРегВыражений;
Перем ВычислительРегВыражений2;
Перем СодержанияАрхивовСправки Экспорт;
Перем мПлатформа;
Перем шТег Экспорт;
Перем шТегНеКлюч Экспорт;
Перем шТегКлюч Экспорт;
Перем шКонецТегаКлюч Экспорт;
Перем шТегКлючСлабый Экспорт;
Перем шКонецТегаКлючСлабый Экспорт;
Перем шТип Экспорт;
Перем шТипСтрогий Экспорт;
Перем мКниги Экспорт;

Функция РаспаковатьФайлАрхиваСинтаксПомощника(Знач ПутьКЭлементу, ПрефиксСсылки = "") Экспорт

	ФайлАрхива = ПолучитьАрхивСинтаксПомощникаПоПутиКЭлементу(ПутьКЭлементу,, Истина);
	Если ФайлАрхива = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
		ФайлАрхива = Новый Файл;
	#КонецЕсли
	Если Лев(ПутьКЭлементу, 1) = "/" Тогда
		ПутьКЭлементу = Сред(ПутьКЭлементу, 2);
	КонецЕсли;
	МассивФрагментов = ирОбщий.СтрРазделитьЛкс(ПутьКЭлементу, "#");
	ПутьКЭлементу = МассивФрагментов[0];
	ФайлСтраницы = Новый Файл(ПутьКэшаСинтаксПомощника() + ПутьКЭлементу);
	Если Не ФайлСтраницы.Существует() Тогда
		ФайлРаспаковщикаZIP = мПлатформа.ПолучитьФайлРаспаковщикаZIP(Истина);
		#Если Сервер И Не Сервер Тогда
			ФайлРаспаковщикаZIP = Новый Файл;
		#КонецЕсли
		ПараметрыКоманды = " -o " + ФайлАрхива.Имя + " """ + ПутьКЭлементу + """";
		Если ирКэш.ЛиПлатформаWindowsЛкс() И ирКэш.ЛиДоступноВыполнениеКомандныхФайловЛкс() Тогда
			// Так быстрее - 150мс
			ПолноеИмяРаспаковщика = ФайлРаспаковщикаZIP.ПолноеИмя;
			ВК = ирОбщий.ВКОбщаяЛкс();
			ВК.Run(ПолноеИмяРаспаковщика, ПараметрыКоманды, ПутьКэшаСинтаксПомощника(), Истина, Ложь); // В 8.2 все параметры метода ВК зачем то должны быть доступны на запись https://www.hostedredmine.com/issues/931482
		Иначе
			// Так медленнее - 200мс
			ирОбщий.ЗапуститьСкрытоеПриложениеИДождатьсяЗавершенияЛкс("""" + ФайлРаспаковщикаZIP.ПолноеИмя + """" + ПараметрыКоманды, ПутьКэшаСинтаксПомощника());
		КонецЕсли;
		Если Не ФайлСтраницы.Существует() Тогда
			ирОбщий.СообщитьЛкс("Синтаксический элемент в текущей версии платформы не поддерживается", СтатусСообщения.Внимание);
			Возврат Неопределено;
		КонецЕсли;
		ТекстовыйДокумент = Новый ТекстовыйДокумент;
		ТекстовыйДокумент.Прочитать(ФайлСтраницы.ПолноеИмя);
		СодержаниеСтраницы = ТекстовыйДокумент.ПолучитьТекст();
		Если Найти(СодержаниеСтраницы, "<head>") > 0 Тогда
			Маркер = "<head>";
		ИначеЕсли Найти(СодержаниеСтраницы, "<HEAD>") > 0 Тогда
			Маркер = "<HEAD>";
		ИначеЕсли Найти(СодержаниеСтраницы, "<Head>") > 0 Тогда
			Маркер = "<Head>";
		КонецЕсли;
		Если Маркер <> Неопределено Тогда
			ТегБазы = "<base href=""" + ПрефиксСсылки + "/" + ПутьКЭлементу + """>";
			Если Найти(СодержаниеСтраницы, ТегБазы) = 0 Тогда
				СодержаниеСтраницы = СтрЗаменить(СодержаниеСтраницы, Маркер, Маркер + ТегБазы);
				ТекстовыйДокумент.УстановитьТекст(СодержаниеСтраницы);
				ТекстовыйДокумент.Вывод = ИспользованиеВывода.Разрешить;
				ТекстовыйДокумент.Записать(ФайлСтраницы.ПолноеИмя);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли; 
	ВременныйАдрес = ФайлСтраницы.ПолноеИмя;
	Если МассивФрагментов.Количество() > 1 Тогда
		ВременныйАдрес = ВременныйАдрес + "#" + МассивФрагментов[1];
	КонецЕсли; 
	Возврат ВременныйАдрес;

КонецФункции

Функция ФайлСтилейСинтаксПомощника() Экспорт 

	Если ФайлСтилейСинтаксПомощника = Неопределено Тогда 
		ФайлСтилейСинтаксПомощника = Новый Файл(ПолучитьИмяВременногоФайла("css"));
		ТекстовыйДокумент = ПолучитьМакет("СтилиСинтаксПомощника");
		ТекстовыйДокумент.Вывод = ИспользованиеВывода.Разрешить;
		ТекстовыйДокумент.Записать(ФайлСтилейСинтаксПомощника.ПолноеИмя);
	КонецЕсли;
	Возврат ФайлСтилейСинтаксПомощника;

КонецФункции

// Получает zip-архив синтакс-помощника из файла "shcntx_ru.hbk" в каталоге установки платформы.
//
// Параметры:
//  ЭлементСтруктуры - Число, *0 - 0 - архив страниц, 1 - содержание книги, 2 - индекс книги
//
Функция АрхивСинтаксПомощникаПоИмени(ЭлементСтруктуры = 0, ИмяАрхива = "shcntx_ru") Экспорт

	мПлатформа = ирКэш.Получить();
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	КлючСтруктуры = "_" + ИмяАрхива + ЭлементСтруктуры;
	ФайлАрхива = Новый Файл(ПутьКэшаСинтаксПомощника() + КлючСтруктуры + ".zip");
	Если Не ФайлАрхива.Существует() Тогда
		Если ЭлементСтруктуры = 0 Тогда
			ИмяБлока = "FileStorage.data";
		ИначеЕсли ЭлементСтруктуры = 1 Тогда
			ИмяБлока = "PackBlock.data";
		ИначеЕсли ЭлементСтруктуры = 2 Тогда
			ИмяБлока = "IndexPackBlock.data";
		КонецЕсли; 
		ИмяФайлаПлатформы = ИмяАрхива + ".hbk";
		ТекущийКаталог = КаталогВременныхФайлов();
		ФайлПлатформы = Новый Файл(КаталогПрограммы() + ИмяФайлаПлатформы);
		ФайлБлока = Новый Файл(ТекущийКаталог + ИмяБлока);
		#Если Клиент Тогда
		Состояние("Распаковка синтакс-помощника");
		#КонецЕсли 
		мПлатформа.РаспаковатьФайлВнешнейОбработки(ФайлПлатформы.ПолноеИмя, ТекущийКаталог);
		Если Не ФайлБлока.Существует() Тогда
			// Если файл залочен на чтение (открыт синтакс-помощник в конфигураторе)
			КопияФайлаПлатформы = Новый Файл(ПолучитьИмяВременногоФайла());
			КопироватьФайл(ФайлПлатформы.ПолноеИмя, КопияФайлаПлатформы.ПолноеИмя);
			//ФайлПлатформы = Новый Файл(мПлатформа.ПолучитьИмяФайлаВФорматеDOS(КопияФайлаПлатформы.ПолноеИмя)); не работае в 64б процессе
			ФайлПлатформы = КопияФайлаПлатформы;
			ФайлБлока = Новый Файл(ТекущийКаталог + ИмяБлока);
			мПлатформа.РаспаковатьФайлВнешнейОбработки(ФайлПлатформы.ПолноеИмя, ТекущийКаталог);
			Если Не ФайлБлока.Существует() Тогда
				ирОбщий.СообщитьЛкс("Ошибка выполнения приложения V8unpack");
				Возврат Неопределено;
			КонецЕсли;
		КонецЕсли;
		ПереместитьФайл(ФайлБлока.ПолноеИмя, ФайлАрхива.ПолноеИмя);
		УдалитьФайлы(ТекущийКаталог + Лев(ФайлПлатформы.ИмяБезРасширения, 8));
		#Если Клиент Тогда
		Состояние("");
		#КонецЕсли 
	КонецЕсли;
	Возврат ФайлАрхива;

КонецФункции

Функция ПутьКэшаСинтаксПомощника() Экспорт
	
	Результат = ирКэш.КаталогИзданияПлатформыВПрофилеЛкс() + ирОбщий.РазделительПутиКФайлуЛкс() + XMLСтрока(ирКэш.НомерВерсииПлатформыЛкс());
	СоздатьКаталог(Результат);
	Возврат Результат + ирОбщий.РазделительПутиКФайлуЛкс();

КонецФункции

Функция ПрочитатьИндексЯзыкаСинтаксПомощника(ЯзыкПрограммы) Экспорт 
	
	Результат = Неопределено;
	ФайлИндекса = Новый Файл(ПутьКэшаСинтаксПомощника() + "Язык" + ЯзыкПрограммы + ".idx");
	Если ФайлИндекса.Существует() Тогда
		Результат = ЗначениеИзФайла(ФайлИндекса.ПолноеИмя);
		Результат = Результат.Индекс;
	КонецЕсли;
	Возврат Результат;
	
КонецФункции

Процедура ЗаписатьИндексЯзыкаСинтаксПомощника(ЯзыкПрограммы, ТаблицаИндекса) Экспорт 
	
	ФайлИндекса = Новый Файл(ПутьКэшаСинтаксПомощника() + "Язык" + ЯзыкПрограммы + ".idx");
	Результат = Новый Структура;
	Результат.Вставить("Индекс", ТаблицаИндекса);
	ЗначениеВФайл(ФайлИндекса.ПолноеИмя, Результат);
	
КонецПроцедуры

// 
//
// Параметры:
//  ПутьКЭлементу  - Строка - модифицируется
//  ИмяАрхива    - Строка - входное значение игнорируется, на выход подается вычисленное имя файла архива;
//
// Возвращаемое значение:
//               - <Тип.Вид> - <описание значения>
//                 <продолжение описания значения>;
//  <Значение2>  - <Тип.Вид> - <описание значения>
//                 <продолжение описания значения>.
//
Функция ПолучитьАрхивСинтаксПомощникаПоПутиКЭлементу(ПутьКЭлементу, ЭлементСтруктуры = 0, ЛиОбрезатьПутьДоОтносительного = Ложь, ИмяАрхива = "") Экспорт

	МаркерДопАрхива = "//";
	Если Найти(ПутьКЭлементу, МаркерДопАрхива) = 1 Тогда
		ИмяАрхива = ирОбщий.ПервыйФрагментЛкс(Сред(ПутьКЭлементу, СтрДлина(МаркерДопАрхива) + 1), "/");
		Если ЛиОбрезатьПутьДоОтносительного Тогда
			ПутьКЭлементу = Сред(ПутьКЭлементу, СтрДлина(МаркерДопАрхива) + 1 + СтрДлина(ИмяАрхива) + 1);
		КонецЕсли;
		ФайлАрхива = АрхивСинтаксПомощникаПоИмени(ЭлементСтруктуры, ИмяАрхива);
	Иначе
		ФайлАрхива = АрхивСинтаксПомощникаПоИмени(ЭлементСтруктуры);
	КонецЕсли;
	Возврат ФайлАрхива;

КонецФункции

// Загрузить описание метода (все варианты)
//
// Параметры:
//  ТипКонтекста		 - 	 - 
//  ИмяМетода			 - 	 - 
//  ОписаниеHTML		 - 	 - 
//  ТипСлова			 - 	 - 
//  ЯзыкПрограммы		 - 	 - 
//  ТаблицаПараметров	 - 	 - 
//  РабочийКаталог		 - 	 - 
//  СтрокаОписания		 - 	 - 
// 
// Возвращаемое значение:
//   Число - количество параметров 
//
Функция ЗагрузитьОписаниеМетода(Знач ТипКонтекста, Знач ИмяМетода, Знач ОписаниеHTML, Знач ТипСлова = "Метод", Знач ЯзыкПрограммы = 0, Знач ТаблицаПараметров = Неопределено, Знач РабочийКаталог = "",
	Знач СтрокаОписанияМетода = Неопределено, ОписаниеМетода = "") Экспорт 
	
	мПлатформа = ирКэш.Получить();
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	Если ТаблицаПараметров = Неопределено Тогда
		ТаблицаПараметров = мПлатформа.ТаблицаПараметров;
	КонецЕсли;
	#Если Сервер И Не Сервер Тогда
		ТаблицаПараметров = Новый ТаблицаЗначений;
	#КонецЕсли
	Если ЯзыкПрограммы = 2 Тогда
		шКлюч = шТегКлюч;
		шКонецКлюча = шКонецТегаКлюч;
	Иначе
		шКлюч = шТегКлючСлабый;
		шКонецКлюча = шКонецТегаКлючСлабый;
	КонецЕсли;
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ВычислительРегВыражений.IgnoreCase = Истина;
	ВычислительРегВыражений.Global = Истина;
	ВычислительРегВыражений.Pattern = шКлюч + "Вариант синтаксиса:\s*([^<""]+)" + шКонецКлюча;
	ВхожденияВариантов = ВычислительРегВыражений.НайтиВхождения(ОписаниеHTML);
	ОписанияВариантов = Новый СписокЗначений;
	Если ВхожденияВариантов.Количество() = 0 Тогда
		ОписанияВариантов.Добавить(ОписаниеHTML);
	Иначе
		ТекущаяПозиция = 1;
		ТекущийВариант = "";
		Для Каждого Вхождение Из ВхожденияВариантов Цикл
			Если ТекущаяПозиция > 1 Тогда
				ОписанияВариантов.Добавить(Сред(ОписаниеHTML, ТекущаяПозиция, Вхождение.FirstIndex - ТекущаяПозиция), ТекущийВариант);
			КонецЕсли; 
			ТекущаяПозиция = Вхождение.FirstIndex;
			ТекущийВариант = Вхождение.SubMatches(0);
		КонецЦикла;
		ОписанияВариантов.Добавить(Сред(ОписаниеHTML, ТекущаяПозиция), Вхождение.SubMatches(0));
	КонецЕсли;
	МаксНомерПараметра = 0;
	Для Каждого ЭлементСписка Из ОписанияВариантов Цикл
		ОписаниеВарианта = ЭлементСписка.Значение;
		ВычислительРегВыражений.Pattern = "(?:Возвращаемое значение:.*?" + шКлюч + "+)?Описание(?: варианта метода)?:?" + шКонецКлюча + "+(?:.*?)(?:\s*</p>\s*)";
		РезультатМетод = ВычислительРегВыражений.НайтиВхождения(ОписаниеВарианта);
		Если РезультатМетод.Количество() = 0 Тогда
			ОписаниеМетода = "";
			Если ЯзыкПрограммы = 1 Тогда
				ОписаниеВарианта = ирОбщий.ТекстМеждуМаркерамиЛкс(ОписаниеВарианта, "</H1>", "</BODY>", Ложь);
				ОписаниеМетода = ОписаниеВарианта;
			ИначеЕсли ЯзыкПрограммы = 2 Тогда
				ВычислительРегВыражений.Pattern = "<H2[^>]*><A[^>]*>(?:</A>)?" + ИмяМетода + "[<\s\(].*?</H2>((?:.|\n|\r)*?)(?:<H2[^>]*>|$)";
				РезультатОписание = ВычислительРегВыражений.НайтиВхождения(ОписаниеВарианта);
				Если РезультатОписание.Количество() > 0 Тогда
					ОписаниеВарианта = РезультатОписание[0].SubMatches(0);
					ОписаниеМетода = ирОбщий.ПервыйФрагментЛкс(ОписаниеВарианта, "Синтаксис:");
				Иначе
					ОписаниеВарианта = "";
				КонецЕсли; 
			КонецЕсли; 
		Иначе
			ОписаниеМетода = РезультатМетод[0].Value;
		КонецЕсли; 
		Если ТаблицаПараметров = мПлатформа.ТаблицаПараметров Тогда
			СтрокаОписанияМетода.Описание = ИзвлечьИзФрагментаHTMLОбычныйТекст(ОписаниеМетода, Ложь);
		КонецЕсли; 
		ВычислительРегВыражений.Pattern = шКлюч + "+Параметры?(?: функции)?:?" + шКонецКлюча + "+((?:.|\n)*?)(?:" + шКлюч + "+Описание(?: варианта метода)?:?" + шКонецКлюча + "|$)";
		РезультатВарианты = ВычислительРегВыражений.НайтиВхождения(ОписаниеВарианта);
		Если РезультатВарианты.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли; 
		ОписаниеВариантаСПараметрами = РезультатВарианты[0].SubMatches(0);
		Если ТипСлова = "Таблица" Тогда
			ВычислительРегВыражений.Pattern = "(<a href=""v8help://SyntaxHelperContext(/[" + мПлатформа.шБукваЦифра + "/]+params/[" + мПлатформа.шБукваЦифра + "/]+.html)"">[" + мПлатформа.шБукваЦифра + "\-\s\(\)]+</a>)";
		Иначе
			ВычислительРегВыражений.Pattern = шКлюч + "(?:&lt;|<strong>)([^&<:]+)(?:&gt;|</strong>)" 
			+ "()?(?:\s*(?:\((необязательный|обязательный)?\)\s*)?" + шКонецКлюча + "+(?:Тип:" + шТегНеКлюч + "?((?:" + шТип + ")+)" + шТегНеКлюч + "?)?)?\.?(?:\s*-\s*)?((?:(?:Значение по умолчанию: " + шТег 
			+ "?([^<>]+)" + шТег + "?\.)|[^dlp](?=[^dlp]|$)|[^<][dlp]+|<li>(?!<strong>))*)";
		КонецЕсли;
		ВхожденияПараметра = ВычислительРегВыражений.НайтиВхождения(ОписаниеВариантаСПараметрами);
		
		КлючПоискаПараметра = Новый Структура("ТипКонтекста, ЯзыкПрограммы, Слово, Номер, ВариантСинтаксиса");
		Если ТипСлова = "Конструктор" Тогда
			КлючПоискаПараметра.Слово = "<Новый>";
			КлючПоискаПараметра.ВариантСинтаксиса = ИмяМетода;
		Иначе
			КлючПоискаПараметра.Слово = ИмяМетода;
			КлючПоискаПараметра.ВариантСинтаксиса = ЭлементСписка.Представление;
		КонецЕсли;
		КлючПоискаПараметра.ТипКонтекста = ТипКонтекста;
		КлючПоискаПараметра.ЯзыкПрограммы = ЯзыкПрограммы;
		ЧтениеХмлПараметра = Новый ЧтениеXML;
		НомерПараметра = 1;
		Для Каждого ВхождениеПараметра Из ВхожденияПараметра Цикл
			#Если Сервер И Не Сервер Тогда
				ВхождениеПараметра = Обработки.ирОболочкаРегВхождение.Создать();
			#КонецЕсли
			НоваяСтрокаПараметра = Неопределено;
			КлючПоискаПараметра.Номер = НомерПараметра; 
			Если ТаблицаПараметров = мПлатформа.ТаблицаПараметров Тогда
				НайденныеСтроки = ТаблицаПараметров.НайтиСтроки(КлючПоискаПараметра);
				Если НайденныеСтроки.Количество() > 0 Тогда
					НоваяСтрокаПараметра = НайденныеСтроки[0];
				КонецЕсли; 
			КонецЕсли; 
			Если НоваяСтрокаПараметра = Неопределено Тогда
				НоваяСтрокаПараметра = ТаблицаПараметров.Добавить();
			КонецЕсли;
			СтруктураСтроки = ирОбщий.СтруктураСвойствСтрокиТаблицыИлиДереваЛкс(НоваяСтрокаПараметра);
			ЗаполнитьЗначенияСвойств(СтруктураСтроки, КлючПоискаПараметра); 
			ТекстПараметра = ВхождениеПараметра.SubMatches(0);
			ТекстПоискаТипов = Неопределено;
			АдресСтраницыОписанияПараметра = "";
			
			// Для параметров виртуальных таблиц надо убрать оберку <A>...</A>. В ней находится ссылка на страницу описания параметра. Это примеяется пока только в описаниях виртуальных таблиц языка запросов.
			ЧтениеХмлПараметра.УстановитьСтроку(ТекстПараметра);
			Попытка
				ЧтениеХмлПараметра.Прочитать();
				ЧтениеХмлПараметра.Прочитать();
			Исключение
			КонецПопытки;
			Если ЧтениеХмлПараметра.ТипУзла = ТипУзлаXML.Текст Тогда
				ТекстПараметра = ЧтениеХмлПараметра.Значение;
			КонецЕсли;
			СтруктураСтроки.Параметр = ТекстПараметра;
			Если ТипСлова <> "Таблица" Тогда
				Если ВхождениеПараметра.SubMatches(2) = "необязательный" Тогда
					СтруктураСтроки.Необязательный = Истина;
				КонецЕсли;
				Если ТаблицаПараметров = мПлатформа.ТаблицаПараметров Тогда
					СтруктураСтроки.Описание = ИзвлечьИзФрагментаHTMLОбычныйТекст(ВхождениеПараметра.SubMatches(6), Ложь);
				КонецЕсли; 
				ЗначениеПоУмолчанию = ВхождениеПараметра.SubMatches(7);
				Если ирОбщий.СтрокиРавныЛкс(ЗначениеПоУмолчанию, "Пустая строка") Тогда
					ЗначениеПоУмолчанию = """""";
				КонецЕсли; 
				СтруктураСтроки.Значение = ЗначениеПоУмолчанию;
				ТекстПоискаТипов = ВхождениеПараметра.SubMatches(3);
			КонецЕсли;
			Если ВхождениеПараметра.SubMatches(1) <> "" Тогда
				СтруктураСтроки.ПутьКОписанию = ВхождениеПараметра.SubMatches(1);
				Если Не ЗначениеЗаполнено(РабочийКаталог) Тогда
					РаспаковатьФайлАрхиваСинтаксПомощника(СтруктураСтроки.ПутьКОписанию);
					ФайлОписанияПараметра = Новый Файл(ПутьКэшаСинтаксПомощника() + СтруктураСтроки.ПутьКОписанию);
				Иначе
					ФайлОписанияПараметра = Новый Файл(РабочийКаталог + СтруктураСтроки.ПутьКОписанию);
				КонецЕсли; 
				Если Истина
					И ФайлОписанияПараметра.Существует()
					И ФайлОписанияПараметра.ЭтоФайл()
				Тогда
					ТекстовыйДокумент.Прочитать(ФайлОписанияПараметра.ПолноеИмя);
					ВычислительРегВыражений2.Pattern = "Тип параметра:" + шТегНеКлюч + "?((?:" + шТип + ")+)";
					ОписаниеПараметра = ТекстовыйДокумент.ПолучитьТекст();
					Результат2 = ВычислительРегВыражений2.НайтиВхождения(ОписаниеПараметра);
					Если Результат2.Количество() > 0 Тогда
						ТекстПоискаТипов = Результат2[0].SubMatches(0);
						ОписаниеПараметра = Сред(ОписаниеПараметра, Результат2[0].FirstIndex + Результат2[0].Length + 1);
					КонецЕсли;
					Если ТаблицаПараметров = мПлатформа.ТаблицаПараметров Тогда
						Если Не ЗначениеЗаполнено(СтруктураСтроки.Описание) Тогда
							СтруктураСтроки.Описание = ИзвлечьИзФрагментаHTMLОбычныйТекст(ОписаниеПараметра, Ложь);
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			Если ТекстПоискаТипов <> Неопределено Тогда
				ВычислительРегВыражений2.Global = Истина;
				ВычислительРегВыражений2.Pattern = шТип;
				Результат2 = ВычислительРегВыражений2.НайтиВхождения(ТекстПоискаТипов);
				СтрокаТипаЗначения = "";
				Для Каждого Вхождение2 Из Результат2 Цикл
					СтрокаТипаЗначения = СтрокаТипаЗначения + ", " + СокрЛП(Вхождение2.SubMatches(0));
				КонецЦикла;
				СтруктураСтроки.ТипЗначения = ИзвлечьИзФрагментаHTMLОбычныйТекст(Сред(СтрокаТипаЗначения, 3));
			КонецЕсли;
			
			СкорректироватьЭлементыСтруктуры(СтруктураСтроки);
			ЗаполнитьЗначенияСвойств(НоваяСтрокаПараметра, СтруктураСтроки);
			НомерПараметра = НомерПараметра + 1;
		КонецЦикла;
		НомерПараметра = НомерПараметра - 1;
		Если НомерПараметра > МаксНомерПараметра Тогда
			МаксНомерПараметра = НомерПараметра;
		КонецЕсли;
	КонецЦикла;
	Если Истина
		И ТаблицаПараметров = мПлатформа.ТаблицаПараметров 
		И Не ЗначениеЗаполнено(СтрокаОписанияМетода.Описание) // Мультиметка443985642
	Тогда
		СтрокаОписанияМетода.Описание = "."; // Обязательно заполняем чтобы потом повторно не загружать
	КонецЕсли;
	Возврат МаксНомерПараметра;

КонецФункции

Функция ИзвлечьИзФрагментаHTMLОбычныйТекст(Знач Текст, Знач УдалитьКрайнююТочку = Истина) Экспорт 
	
	ВычислительРегВыражений.Pattern = "<br>";
	//Текст = ВычислительРегВыражений.Заменить(Текст, Символы.ПС); // менее эффективно используется место
	Текст = ВычислительРегВыражений.Заменить(Текст, " "); // более эффективно используется место
	ВычислительРегВыражений.Pattern = "<li>";
	Текст = ВычислительРегВыражений.Заменить(Текст, Символы.ПС + " - ");
	ВычислительРегВыражений.Pattern = "<p[^>]*>|</?ul>";
	Текст = ВычислительРегВыражений.Заменить(Текст, Символы.ПС);
	
	// Удаление всех оставшихся тегов
	ВычислительРегВыражений.Pattern = "<[^>]+>";
	Текст = ВычислительРегВыражений.Заменить(Текст, "");
	
	Текст = ирОбщий.ДекодироватьТекстИзXMLЛкс(Текст);
	// Нормализация пустых строк
	ВычислительРегВыражений.Pattern = "(?:\r?\n\s*){2,}";
	Текст = СокрЛП(ВычислительРегВыражений.Заменить(Текст, Символы.ПС));
	Если УдалитьКрайнююТочку И Прав(Текст, 1) = "." Тогда       
		// Например, Тип: Произвольный. 
		Текст = ирОбщий.СтрокаБезКонцаЛкс(Текст, 1);
	КонецЕсли;
	Возврат Текст;

КонецФункции

Процедура СкорректироватьЭлементыСтруктуры(Структура) Экспорт 
	
	Для Каждого ЭлементСтруктуры Из Структура Цикл
		Если ТипЗнч(ЭлементСтруктуры.Значение) <> типСтрока Тогда
			Продолжить;
		КонецЕсли; 
		Если Найти(ЭлементСтруктуры.Значение, "<Имя регистра>") > 0 Тогда
			Если Найти(ЭлементСтруктуры.Значение, "РегистрСведений") > 0 Тогда
				СтрокаЗаменыИмениРегистра = "<Имя регистра сведений>";
			ИначеЕсли Найти(ЭлементСтруктуры.Значение, "РегистрНакопления") > 0 Тогда
				СтрокаЗаменыИмениРегистра = "<Имя регистра накопления>";
			КонецЕсли;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого ЭлементСтруктуры Из Структура Цикл
		ЗначениеЭлемента = ЭлементСтруктуры.Значение;
		Если ТипЗнч(ЗначениеЭлемента) <> типСтрока Тогда
			Продолжить;
		КонецЕсли; 
		Если Истина
			И Структура.Свойство("ЯзыкПрограммы")
			И Структура.ЯзыкПрограммы = 1 
			И ЗначениеЭлемента <> "Ссылка"
		Тогда
			ЗначениеЭлемента = СтрЗаменить(ЗначениеЭлемента, "Ссылка", "");
		КонецЕсли;
		Если СтрокаЗаменыИмениРегистра <> Неопределено Тогда
			ЗначениеЭлемента = СтрЗаменить(ЗначениеЭлемента, "<Имя регистра>", СтрокаЗаменыИмениРегистра);
		КонецЕсли;
		
		Если ирКэш.РежимОтладкиЛкс() Тогда 
			// Пассивный оригинал расположенного ниже однострочного кода. Выполняйте изменения синхронно в обоих вариантах.
			// Выполняется много раз! Тяжелый цикл
			Для Каждого ЭлементЗамены Из СоответствиеЗамены Цикл
				//Если ВключитьАнализСрабатыванияЗамен Тогда
				//	Если СрабатываниеЗамен[ЭлементЗамены.Ключ] = 0 И Найти(ЗначениеЭлемента, ЭлементЗамены.Ключ) > 0 Тогда
				//		СрабатываниеЗамен[ЭлементЗамены.Ключ] = 1;
				//	КонецЕсли; 
				//КонецЕсли; 
				ЗначениеЭлемента = СтрЗаменить(ЗначениеЭлемента, ЭлементЗамены.Ключ, ЭлементЗамены.Значение);
			КонецЦикла;
			Если Найти(ЗначениеЭлемента, "<") = 0 Тогда
				СтароеЗначениеЭлемента = ЗначениеЭлемента;
				Для Каждого СтрокаЗамены Из ЗаменыВнешнихОбъектов Цикл
					ЗначениеЭлемента = СтрЗаменить(ЗначениеЭлемента, СтрокаЗамены.Образец, СтрокаЗамены.Замена);
					Если СтароеЗначениеЭлемента <> ЗначениеЭлемента Тогда
						Прервать;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли; 
		Иначе
			// Однострочный код использован для ускорения. Выше расположен оригинал. Выполняйте изменения синхронно в обоих вариантах. Преобразовано консолью кода из подсистемы "Инструменты разработчика" (http://devtool1c.ucoz.ru)
			Для Каждого ЭлементЗамены Из СоответствиеЗамены Цикл            			ЗначениеЭлемента = СтрЗаменить(ЗначениеЭлемента, ЭлементЗамены.Ключ, ЭлементЗамены.Значение);  		КонецЦикла;  		Если Найти(ЗначениеЭлемента, "<") = 0 Тогда  			СтароеЗначениеЭлемента = ЗначениеЭлемента;  			Для Каждого СтрокаЗамены Из ЗаменыВнешнихОбъектов Цикл  				ЗначениеЭлемента = СтрЗаменить(ЗначениеЭлемента, СтрокаЗамены.Образец, СтрокаЗамены.Замена);  				Если СтароеЗначениеЭлемента <> ЗначениеЭлемента Тогда  					Прервать;  				КонецЕсли;  			КонецЦикла;  		КонецЕсли;  
		КонецЕсли; 
		Структура[ЭлементСтруктуры.Ключ] = ЗначениеЭлемента;
	КонецЦикла;

КонецПроцедуры

Функция СтрокаДляПодсветкиПараметра(Знач ИмяПараметра, Знач ЯзыкПрограммы = 0) Экспорт 
	
	Если ЯзыкПрограммы = 2 Тогда
		СтрокаДляПодсветки = "<strong>" + ИмяПараметра + "</strong>";
	Иначе
		СтрокаДляПодсветки = "&lt;" + ИмяПараметра + "&gt;";
	КонецЕсли;
	Возврат СтрокаДляПодсветки;

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
#Если Сервер И Не Сервер Тогда
	мПлатформа = Обработки.ирПлатформа.Создать();
#КонецЕсли
шТег =           "(?:\s*<[^>]+>\s*)";
шТегНеКлюч =     "(?:\s*<[^>""]+>\s*)";
шТегКлюч =       "(?:\s*<(?:li|(?:div|p|b)(?:\s[^>]*)?)>\s*)";  // <li><strong> используется в описании функций языка выражений компоновки . <P>Параметры:</P> - встречается в описании функций языка выражений компоновки, например КлассификацияABC
шКонецТегаКлюч = "(?:\s*</(?:div|li|p|b)>\s*)";
шТегКлючСлабый = "(?:\s*<(?:li|(?:div|p|b|strong|u)(?:\s[^>]*)?)>\s*)"; // Добавлены <strong> и <u>. Много ложных срабатываний в описаниях языка выражений компоновки
шКонецТегаКлючСлабый = "(?:(?:<br>|\s)*</(?:div|li|p|b|strong|u)>(?:<br>|\s)*)";
//шТип = "\s*(?:<[^>""]+""(?:[^""]*)"">)?((?:[" + мПлатформа.шБукваЦифра + "\-\s\:\&\/]+))(?:(?:<[^>""]+>)?(,|;))?";
шТип =        "\s*(?:<[^>""]+""(?:[^""]*)"">)?((?:[" + мПлатформа.шБукваЦифра + "\-\s\:\&\/.;]+))(?:(?:<[^>""]+>)?(,|;))?"; // Добавлены символы "." и ";" Для разрабора типов параметра "Субконто" виртуальной таблицы ОстаткиИОбороты
шТипСтрогий = "\s*(?:<[^>""]+""(?:[^""]*)"">)((?:[" + мПлатформа.шБукваЦифра + "\-\s\:\&\/.;]+))(?:(?:<[^>""]+>)(,|;))?"; // Добавлены символы "." и ";" Для разрабора типов параметра "Субконто" виртуальной таблицы ОстаткиИОбороты
СоответствиеЗамены = Новый Соответствие;

// Баг платформы. Небрежность в файлах справки.
СоответствиеЗамены.Вставить("<Имя журнала>",      "<Имя журнала документов>");
СоответствиеЗамены.Вставить("<Имя критерия>", "<Имя критерия отбора>");
СоответствиеЗамены.Вставить("<Имя WS-ссылки>", "<Имя WS-Ссылки>");
СоответствиеЗамены.Вставить("<Имя значения>", "<Имя значения перечисления>");
СоответствиеЗамены.Вставить("<ИмяПеречисления>", "<Имя перечисления>");
СоответствиеЗамены.Вставить("<Имя внешнего источника данных>", "<Имя внешнего источника>");

ЗаменыВнешнихОбъектов = Новый ТаблицаЗначений;
ЗаменыВнешнихОбъектов.Колонки.Добавить("Образец");
ЗаменыВнешнихОбъектов.Колонки.Добавить("Замена");
СтрокаЗамены = ЗаменыВнешнихОбъектов.Добавить();
СтрокаЗамены.Образец = "ВнешнийОтчетТабличнаяЧасть";
СтрокаЗамены.Замена = "ВнешнийОтчетТабличнаяЧасть.<Имя внешнего отчета>.<Имя табличной части>";
СтрокаЗамены = ЗаменыВнешнихОбъектов.Добавить();
СтрокаЗамены.Образец = "ВнешняяОбработкаТабличнаяЧасть";
СтрокаЗамены.Замена = "ВнешняяОбработкаТабличнаяЧасть.<Имя внешней обработки>.<Имя табличной части>";
СтрокаЗамены = ЗаменыВнешнихОбъектов.Добавить();
СтрокаЗамены.Образец = "ВнешнийОтчет";
СтрокаЗамены.Замена = "ВнешнийОтчетОбъект.<Имя внешнего отчета>";
СтрокаЗамены = ЗаменыВнешнихОбъектов.Добавить();
СтрокаЗамены.Образец = "ВнешняяОбработка";
СтрокаЗамены.Замена = "ВнешняяОбработкаОбъект.<Имя внешней обработки>";
СтрокаЗамены = ЗаменыВнешнихОбъектов.Добавить();
СтрокаЗамены.Образец = "ТочкаМаршрутаБизнесПроцессаСсылка";
СтрокаЗамены.Замена = "ТочкаМаршрутаБизнесПроцессаСсылка.<Имя бизнес-процесса>";
типСтрока = Тип("Строка");
ВычислительРегВыражений = ирОбщий.НовыйВычислительРегВыражений();
ВычислительРегВыражений2 = ирОбщий.НовыйВычислительРегВыражений();
СодержанияАрхивовСправки = Новый Соответствие;
мКниги = ирОбщий.ТаблицаЗначенийИзТабличногоДокументаЛкс(ПолучитьМакет("Книги"),,,, Истина);
