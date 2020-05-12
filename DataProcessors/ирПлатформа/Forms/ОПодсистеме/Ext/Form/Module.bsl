﻿Перем ЭтотРасширение;

Процедура ПриОткрытии()
	
	ЭтаФорма.Автор = "Старых Сергей Александрович (Tormozit, tormozit@mail.ru)";
	Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
		ЭтаФорма.НазваниеВарианта = "Портативные";
		ЭтаФорма.ИспользуемаяВерсия = НазваниеВарианта + " " + ирПортативный.мВерсия;
	ИначеЕсли ирКэш.ЛиЭтоРасширениеКонфигурацииЛкс() Тогда 
		ЭтотРасширение = ирКэш.ЭтотРасширениеКонфигурацииЛкс();
		ЭтаФорма.НазваниеВарианта = "Расширение";
		Если Прав(Метаданные.Подсистемы.ИнструментыРазработчикаTormozit.Комментарий, 1) = "a" Тогда 
			ЭтаФорма.НазваниеВарианта = ЭтаФорма.НазваниеВарианта + " зависимое";
		КонецЕсли; 
		ЭтаФорма.ИспользуемаяВерсия = НазваниеВарианта + " " + Метаданные.Подсистемы.ИнструментыРазработчикаTormozit.Комментарий;
	Иначе
		ЭтаФорма.НазваниеВарианта = "Подсистема";
		ЭтаФорма.ИспользуемаяВерсия = НазваниеВарианта + " " + Метаданные.Подсистемы.ИнструментыРазработчикаTormozit.Комментарий;
	КонецЕсли; 
	ИмяСервера = ирОбщий.АдресОсновногоСайтаЛкс();
	ЭлементыФормы.НадписьОсновнойСайт.Заголовок = ЭлементыФормы.НадписьОсновнойСайт.Заголовок + " " + ИмяСервера;
	ЭлементыФормы.ОписаниеВарианта.Видимость = НазваниеВарианта <> "Подсистема";
	ПодключитьОбработчикОжидания("ПолучитьАктуальнуюВерсиюОтложенно", 0.1, Истина);
	Если ЗначениеЗаполнено(КлючУникальности) Тогда
		СтрокаОписания = ПолучитьСтрокуОписанияИнструмента();
		Если СтрокаОписания = Неопределено Тогда
			Сообщить("Описание инструмента " + КлючУникальности + " не найдено");
			НазваниеИнструмента = КлючУникальности;
		Иначе
			НазваниеИнструмента = СтрокаОписания.Синоним;
			ЭлементыФормы.ОписаниеНаСайте.Доступность = Истина;
			ЭлементыФормы.ИсторияИзмененийИнструмента.Доступность = Истина;
		КонецЕсли; 
		ирОбщий.ОбновитьТекстПослеМаркераВСтрокеЛкс(ЭтаФорма.Заголовок,, НазваниеИнструмента, ". ");
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПолучитьАктуальнуюВерсиюОтложенно()
	
	Если ирКэш.НомерВерсииПлатформыЛкс() < 802018 Тогда
		// объект HTTPЗапрос недоступен
		Возврат;
	КонецЕсли; 
	НазваниеНаСайте = "Инструменты разработчика " + НазваниеВарианта + " 1С 8";
	ИмяСервера = ирОбщий.АдресОсновногоСайтаЛкс();
	Соединение = ирОбщий.HTTPСоединение(ИмяСервера, 5);
		#Если Сервер И Не Сервер Тогда
		    Соединение = Новый HTTPСоединение;
		#КонецЕсли
	Запрос = Новый ("HTTPЗапрос");
	Запрос.АдресРесурса = "load/osnovnye/1";
	Попытка
		ОтветHttp = Соединение.Получить(Запрос);
	Исключение
		ОтветHttp = Неопределено;
	КонецПопытки; 
	Если ОтветHttp <> Неопределено Тогда
		ЧтениеHtml = Новый ЧтениеHTML;
		ЧтениеHtml.УстановитьСтроку(ОтветHttp.ПолучитьТелоКакСтроку());
		ПостроительDOM = Новый ПостроительDOM;
		ДокументHTML = ПостроительDOM.Прочитать(ЧтениеHTML);
		УзлыВерсий = ДокументHTML.ПолучитьЭлементыПоИмени("a");
		Для Каждого УзелВерсии Из УзлыВерсий Цикл
			ТекстовоеСодержимое = НРег(УзелВерсии.ТекстовоеСодержимое);
			Если Найти(ТекстовоеСодержимое, НРег(НазваниеНаСайте)) > 0 Тогда
				ЭтаФорма.АктуальнаяВерсия = НазваниеВарианта + " " + Сред(ТекстовоеСодержимое, Найти(ТекстовоеСодержимое, "v") + 1);
				ЭтаФорма.СсылкаНаСтраницуСкачивания = УзелВерсии.Гиперссылка;
				Прервать;
			КонецЕсли; 
		КонецЦикла;
	КонецЕсли;
	Если Истина
		И ЗначениеЗаполнено(АктуальнаяВерсия) 
		И Не ирОбщий.СтрокиРавныЛкс(ЭтаФорма.АктуальнаяВерсия, ИспользуемаяВерсия)
	Тогда
		ЭлементыФормы.КнопкаОбновить.ЦветТекстаКнопки = Новый Цвет(0, 0, 255);
		ЭлементыФормы.КнопкаОбновить.Доступность = Истина;
	КонецЕсли;
	
	АдресСпискаВерсий = ирОбщий.АдресСайтаЗадачЛкс() + "/versions.xml";
	СтруктураАдреса = ирОбщий.СтруктураURIЛкс(АдресСпискаВерсий);
	Соединение = ирОбщий.HTTPСоединение(СтруктураАдреса.ИмяСервера, 5);
		#Если Сервер И Не Сервер Тогда
		    Соединение = Новый HTTPСоединение;
		#КонецЕсли
	Запрос = Новый ("HTTPЗапрос");
	Запрос.АдресРесурса = СтруктураАдреса.ПутьНаСервере;
	Попытка
		ОтветHttp = Соединение.Получить(Запрос);
	Исключение
		ОтветHttp = Неопределено;
	КонецПопытки; 
	ЭтаФорма.ИспользуемаяВерсияДатаВыпуска = Дата(2000, 1, 1);
	Если ОтветHttp <> Неопределено Тогда
		ЧтениеXML = Новый ЧтениеXML;
		ЧтениеXML.УстановитьСтроку(ОтветHttp.ПолучитьТелоКакСтроку());
		ДокументHTML = ПостроительDOM.Прочитать(ЧтениеXML);
		УзлыВерсий = ДокументHTML.ПолучитьЭлементыПоИмени("version");
		Для Каждого УзелВерсии Из УзлыВерсий Цикл
			#Если Сервер И Не Сервер Тогда
				УзелВерсии = ДокументHTML.СоздатьЭлемент();
			#КонецЕсли
			ВерсияИзУзла = УзелВерсии.ПолучитьЭлементыПоИмени("Name")[0].ТекстовоеСодержимое;
			СтрокаДаты = УзелВерсии.ПолучитьЭлементыПоИмени("due_date")[0].ТекстовоеСодержимое;
			Если ЗначениеЗаполнено(СтрокаДаты) Тогда
				ДатаВыпуска = Дата(СтрЗаменить(СтрокаДаты, "-", ""));
			Иначе
				ДатаВыпуска = Неопределено;
			КонецЕсли; 
			Если Истина
				И ЗначениеЗаполнено(ДатаВыпуска)
				И ВерсияИзУзла = ЧистыйНомерВерсии(ирОбщий.ПолучитьПоследнийФрагментЛкс(ИспользуемаяВерсия, " "))
			Тогда 
				ЭтаФорма.ИспользуемаяВерсияДатаВыпуска = ДатаВыпуска;
			КонецЕсли; 
			Если ВерсияИзУзла = ЧистыйНомерВерсии(ирОбщий.ПолучитьПоследнийФрагментЛкс(АктуальнаяВерсия, " ")) Тогда 
				ЭтаФорма.АктуальнаяВерсияДатаВыпуска = ДатаВыпуска;
			КонецЕсли; 
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

Функция ЧистыйНомерВерсии(ГрязныйНомерВерсии)
	Если Прав(ГрязныйНомерВерсии, 1) = "p" Или Прав(ГрязныйНомерВерсии, 1) = "e" Тогда
		Результат = Лев(ГрязныйНомерВерсии, СтрДлина(ГрязныйНомерВерсии) - 1);
	Иначе
		Результат = ГрязныйНомерВерсии;
	КонецЕсли; 
	Возврат Результат;
КонецФункции

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ирОбщий.ФормаОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура ОписаниеНаСайтеНажатие(Элемент)
	
	СтрокаОписания = ПолучитьСтрокуОписанияИнструмента();
	ЗапуститьПриложение("http://" + ирОбщий.АдресОсновногоСайтаЛкс() + "/" + СтрокаОписания.Описание);
	
КонецПроцедуры

Функция ПолучитьСтрокуОписанияИнструмента()
	
	СтрокаОписания = ПолучитьСписокИнструментов().Найти(КлючУникальности, "ПолноеИмя");
	Если СтрокаОписания = Неопределено И СтрЧислоВхождений(КлючУникальности, ".") > 1 Тогда
		ОбъектМД = Метаданные.НайтиПоПолномуИмени(КлючУникальности);
		ПолноеИмяМД = ОбъектМД.Родитель().ПолноеИмя();
		СтрокаОписания = ПолучитьСписокИнструментов().Найти(ПолноеИмяМД, "ПолноеИмя");
	КонецЕсли; 
	Возврат СтрокаОписания;

КонецФункции

Процедура Надпись5Нажатие(Элемент)
	
	Предупреждение("Пожайлуйста сообщайте о проблеме по почте только если у вас проблемы с доступом на форум продукта");
	ЗапуститьПриложение("mailto:tormozit@mail.ru?subject=Инструменты разработчика " + ИспользуемаяВерсия);
	
КонецПроцедуры

Процедура ПорядокОписанияПроблемНажатие(Элемент)
	
	ЗапуститьПриложение("http://devtool1c.ucoz.ru/forum/2-2-1");
	
КонецПроцедуры

Процедура ОбновитьНажатие(Элемент)
	
	ИмяСервера = ирОбщий.АдресОсновногоСайтаЛкс();
	Соединение = ирОбщий.HTTPСоединение(ИмяСервера);
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
			Если Найти(ТекстовоеСодержимое, НРег("Скачать с сервера")) > 0 Тогда
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
	Запрос = Новый ("HTTPЗапрос");
	Запрос.АдресРесурса = ирОбщий.РазделитьURLЛкс(СсылкаНаСкачивание).ПутьКФайлуНаСервере;
	ПараметрыПодключенияКТекущемуОтладчику = ирОбщий.ПараметрыЗапускаСеансаДляПодключенияКТекущемуОтладчикуЛкс();
	Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
		БазоваяФорма = ирПортативный.ПолучитьФорму();
		БазоваяФорма.Закрыть();
		Если БазоваяФорма.Открыта() Тогда 
			Возврат;
		КонецЕсли; 
		Ответ = Вопрос("При завершении обновления будет необходимо выполнить перезапуск клиентского приложения. Продолжить?", РежимДиалогаВопрос.ОКОтмена);
		Если Ответ <> КодВозвратаДиалога.ОК Тогда
			Возврат;
		КонецЕсли;
		ИмяАрхиваСтаройВерсии = ирПортативный.мКаталогОбработки + "ИР_" + ИспользуемаяВерсия + ".zip";
		ИмяАрхиваНовойВерсии = ирПортативный.мКаталогОбработки + "ИР_" + АктуальнаяВерсия + ".zip";
		СоздатьКаталог(ирПортативный.мКаталогОбработки + "temp");
		СоздатьКаталог(ирПортативный.мКаталогОбработки + "temp\Модули");
		ирОбщий.СкопироватьФайлыЛкс(ирПортативный.мКаталогОбработки + "Модули", ирПортативный.мКаталогОбработки + "temp\Модули");
		КопироватьФайл(ирПортативный.мКаталогОбработки + "ирПортативный.epf", ирПортативный.мКаталогОбработки + "temp\ирПортативный.epf");
		АрхивированиеУспешно = Истина;
		Попытка
			ЗаписьZip = Новый ЗаписьZipФайла(ИмяАрхиваСтаройВерсии);
			ЗаписьZip.Добавить(ирПортативный.мКаталогОбработки + "temp\*", РежимСохраненияПутейZIP.СохранятьОтносительныеПути, РежимОбработкиПодкаталоговZIP.ОбрабатыватьРекурсивно);
			ЗаписьZip.Записать();
		Исключение
			Сообщить(ОписаниеОшибки());
			АрхивированиеУспешно = Ложь;
		КонецПопытки;
		УдалитьФайлы(ирПортативный.мКаталогОбработки + "temp");
		Если АрхивированиеУспешно Тогда
			Предупреждение("Архивы старой и новой версии сохранены в каталоге """ + ирПортативный.мКаталогОбработки + """", 10);
		Иначе
			Ответ = Вопрос("При архивировании используемой версии возникла ошибка. Продолжить обновление?", РежимДиалогаВопрос.ОКОтмена);
			Если Ответ <> КодВозвратаДиалога.ОК Тогда
				Возврат;
			КонецЕсли;
		КонецЕсли; 
		СтрокаОтвета = Соединение.Получить(Запрос);
		ДвоичныеДанные = СтрокаОтвета.ПолучитьТелоКакДвоичныеДанные();
		ДвоичныеДанные.Записать(ИмяАрхиваНовойВерсии);
		ЧтениеZip = Новый ЧтениеZipФайла(ИмяАрхиваНовойВерсии);
		ЧтениеZip.ИзвлечьВсе(ирПортативный.мКаталогОбработки, РежимВосстановленияПутейФайловZIP.Восстанавливать);
		ЗавершитьРаботуСистемы(, Истина, ПараметрыПодключенияКТекущемуОтладчику + " /Execute""" + ирПортативный.ИспользуемоеИмяФайла + """");
	ИначеЕсли ЭтотРасширение <> Неопределено Тогда 
		Ответ = Вопрос("При завершении обновления будет необходимо выполнить перезапуск клиентского приложения. Продолжить?", РежимДиалогаВопрос.ОКОтмена);
		Если Ответ <> КодВозвратаДиалога.ОК Тогда
			Возврат;
		КонецЕсли;
		Каталог = ирОбщий.ВыбратьКаталогВФормеЛкс(,, "Выберите каталог для сохранения старой и новой версий расширения");
		Если ЗначениеЗаполнено(Каталог) Тогда
			ИмяФайлаСтаройВерсии = Каталог + "\ИР_" + ИспользуемаяВерсия + ".cfe";
			ЭтотРасширение.ПолучитьДанные().Записать(ИмяФайлаСтаройВерсии);
			ИмяАрхиваНовойВерсии = Каталог + "\ИР_" + АктуальнаяВерсия + ".cfe";
		Иначе
			ИмяАрхиваНовойВерсии = ПолучитьИмяВременногоФайла("cfe");
		КонецЕсли; 
		СтрокаОтвета = Соединение.Получить(Запрос);
		ДвоичныеДанные = СтрокаОтвета.ПолучитьТелоКакДвоичныеДанные();
		ДвоичныеДанные.Записать(ИмяАрхиваНовойВерсии);
		#Если Сервер И Не Сервер Тогда
		    ЭтотРасширение = РасширенияКонфигурации.Создать();
		#КонецЕсли
		ЭтотРасширение.Записать(ДвоичныеДанные);
		//ЭтотРасширение.ПолучитьДанные().Записать(ИмяАрхиваНовойВерсии);
		ОткрыватьАдаптациюПриОбновлении = ХранилищеОбщихНастроек.Загрузить(, "ирАдаптацияРасширения.ОткрыватьАдаптациюПриОбновлении",, ирКэш.ИмяПродукта());
		Если ОткрыватьАдаптациюПриОбновлении = Истина Тогда
			ОткрытьФормуМодально("ОбщаяФорма.ирАдаптацияРасширения");
		КонецЕсли; 
		ЗавершитьРаботуСистемы(, Истина, ПараметрыПодключенияКТекущемуОтладчику);
	Иначе
		Каталог = ирОбщий.ВыбратьКаталогВФормеЛкс(,, "Выберите каталог для сохранения файла новой подсистемы");
		Если Не ЗначениеЗаполнено(Каталог) Тогда
			Возврат;
		КонецЕсли; 
		СтрокаОтвета = Соединение.Получить(Запрос);
		ДвоичныеДанные = СтрокаОтвета.ПолучитьТелоКакДвоичныеДанные();
		ИмяФайла = Каталог + "\Инструменты разработчика " + АктуальнаяВерсия + ".cf";
		ДвоичныеДанные.Записать(ИмяФайла);
		Сообщить("Теперь выполните объединение конфигурации базы с """ + ИмяФайла + """");
	КонецЕсли; 
	
КонецПроцедуры

Процедура ИнформацияДляТехническойПоддержкиНажатие(Элемент)
	
	Текст = ИнформацияДляТехническойПоддержки();
	ТекущийЯзыкСистемы = ирОбщий.ПолучитьПервыйФрагментЛкс(ТекущийЯзыкСистемы(), "_");
	Если Истина
		И Не ирОбщий.СтрокиРавныЛкс(ТекущийЯзыкСистемы, "ru") 
		И Не ирОбщий.СтрокиРавныЛкс(ТекущийЯзыкСистемы, "en")
	Тогда
		Ответ = Вопрос("Разработчик инструментов понимает только русский и английский языки. Запустить сеанс на русском языке?", РежимДиалогаВопрос.ДаНет);
		Если Ответ = КодВозвратаДиалога.Да Тогда
			ПараметрыЗапуска = ирОбщий.ПараметрыЗапускаПриложения1СЛкс(,,,,,,,,,,,,,, "ru");
			ЗапуститьСистему(ПараметрыЗапуска);
			Возврат;
		КонецЕсли;
	КонецЕсли; 
	ирОбщий.ОткрытьТекстЛкс(Текст, "Информация для технической поддержки");
	
КонецПроцедуры

Функция ИнформацияДляТехническойПоддержки()
	
	НомерВерсииБСП = ирОбщий.НомерВерсииБСПЛкс();
	
	// Системный вариант
	//Платформа: 1С:Предприятие 8.3 (8.3.9.2033)
	//Конфигурация: Комплексная автоматизация, редакция 1.1 (1.1.20.1) (http://v8.1c.ru/ka/)
	//Copyright (С) ООО "1C", 2010-2012. Все права защищены
	//(http://www.1c.ru/)
	//Режим: Файловый (без сжатия)
	//Приложение: Тонкий клиент
	//Локализация: Информационная база: русский (Россия), Сеанс: русский (Россия)
	//Вариант интерфейса: Такси
	
	ВК = ирКэш.ВКОбщая();
	#Если Сервер И Не Сервер Тогда
		ирПортативный = Обработки.ирПортативный.Создать();
	#КонецЕсли
	СистемнаяИнформация = Новый СистемнаяИнформация;
	Текст = 
	"Платформа: " + СистемнаяИнформация.ВерсияПриложения + "
	|Режим БД: " + ?(ирКэш.ЭтоФайловаяБазаЛкс(), "файловый", "клиент-серверный") + "
	|Конфигурация. Название: " + Метаданные.Синоним + " (" + Метаданные.Версия + ")
	|Конфигурация. Основной режим запуска: " + Метаданные.ОсновнойРежимЗапуска + "
	|Конфигурация. Вариант встроенного языка: " + Метаданные.ВариантВстроенногоЯзыка + "
	|Конфигурация. Режим совместимости: " + Метаданные.РежимСовместимости;
	Если ЗначениеЗаполнено(НомерВерсииБСП) Тогда
		Текст = Текст + "
		|Конфигурация. Версия БСП: " + НомерВерсииБСП;
	КонецЕсли; 
	Текст = Текст + "
	|Инструменты разработчика. Версия: " + ИспользуемаяВерсия + "
	|Инструменты разработчика. Объекты на сервере: " + ирКэш.ПараметрыЗаписиОбъектовЛкс().ОбъектыНаСервере;
	Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
		Текст = Текст + "
		|Инструменты разработчика. Серверный модуль: " + ирПортативный.ЛиСерверныйМодульДоступенЛкс();
	КонецЕсли; 
	Если ирКэш.НомерРежимаСовместимостиЛкс() >= 803006 И ПравоДоступа("АдминистрированиеРасширенийКонфигурации", Метаданные) Тогда
		РасширенияКонфигурацииЛ = Вычислить("РасширенияКонфигурации");
		#Если Сервер И Не Сервер Тогда
			РасширенияКонфигурацииЛ = РасширенияКонфигурации;
		#КонецЕсли
		Для Каждого РасширениеКонфигурации Из РасширенияКонфигурацииЛ.Получить() Цикл
			#Если Сервер И Не Сервер Тогда
				РасширениеКонфигурации = РасширенияКонфигурации.Создать();
			#КонецЕсли
			Если ирКэш.НомерВерсииПлатформыЛкс() >= 803012 И Не РасширениеКонфигурации.Активно Тогда
				Продолжить;
			КонецЕсли; 
			Текст = Текст + "
			|Расширения. " + РасширениеКонфигурации.Имя + " (" + РасширениеКонфигурации.Версия + ")";
		КонецЦикла;
	КонецЕсли; 
	Если ирКэш.НомерВерсииПлатформыЛкс() >= 803009 Тогда
		Если ПравоДоступа("Администрирование", Метаданные) И ПользователиИнформационнойБазы.ПолучитьПользователей().Количество() > 0 Тогда
			ТекущийПользовательБазы = ПользователиИнформационнойБазы.ТекущийПользователь();
			Попытка
				ЗащитаОтОпасныхДействий = ТекущийПользовательБазы.ЗащитаОтОпасныхДействий.ПредупреждатьОбОпасныхДействиях;
			Исключение
				ЗащитаОтОпасныхДействий = "Недоступно";
			КонецПопытки; 
		Иначе
			ЗащитаОтОпасныхДействий = "Неизвестно";
		КонецЕсли; 
		Если ЗащитаОтОпасныхДействий = Истина Тогда
			Текст = Текст + "
			|Пользователь. Защита от опасных действий: " + ЗащитаОтОпасныхДействий;
		КонецЕсли; 
	КонецЕсли; 
	Текст = Текст + "
	|Клиент. ОС: " + СистемнаяИнформация.ТипПлатформы + " " + СистемнаяИнформация.ВерсияОС + "
	|Клиент. Приложение: " + ТекущийРежимЗапуска() + " " + ?(ирКэш.Это64битныйПроцессЛкс(), "64б", "32б") + "
	|Клиент. От имени администратора Windows: " + ВК.IsAdmin() + "
	//|Клиент. Текущий язык: " + ТекущийЯзыкСистемы() + "
	|Клиент. Текущий язык системы: " + ТекущийЯзыкСистемы() + "
	|";
	Если Не ирКэш.ЭтоФайловаяБазаЛкс() Тогда
		Текст = Текст + ирСервер.ИнфоСервераПриложений();
	КонецЕсли; 
	Возврат Текст;

КонецФункции

Процедура НадписьОсновнойСайтНажатие(Элемент)
	
	ЗапуститьПриложение("http://" + ирОбщий.АдресОсновногоСайтаЛкс());
	
КонецПроцедуры

Процедура ОписаниеПодсистемыНажатие(Элемент)
	
	ЗапуститьПриложение("http://" + ирОбщий.АдресОсновногоСайтаЛкс() + "/index/opisanie_podsistemy/0-4");
	
КонецПроцедуры

Процедура ОписаниеВариантаНажатие(Элемент)
	
	Если НазваниеВарианта = "Портативный" Тогда
		ОтносительныйАдрес = "/index/portativniy_variant/0-39";
	ИначеЕсли НазваниеВарианта = "Расширение" Тогда
		ОтносительныйАдрес = "/index/rasshirenie_variant/0-52";
	Иначе
		Возврат;
	КонецЕсли; 
	ЗапуститьПриложение("http://" + ирОбщий.АдресОсновногоСайтаЛкс() + ОтносительныйАдрес);
	
КонецПроцедуры

Процедура ИсторияИзмененийИнструментаНажатие(Элемент)
	
	СтрокаОписания = ПолучитьСтрокуОписанияИнструмента();
	СтрокаЗапуска = "http://www.hostedredmine.com/projects/devtool1c/issues?utf8=%E2%9C%93&set_filter=1&sort=fixed_version%3Adesc%2Ccategory%2Csubject&f%5B%5D=status_id&op%5Bstatus_id%5D=%3D&v%5Bstatus_id%5D%5B%5D=5&f%5B%5D=category_id&op%5Bcategory_id%5D=%3D&v%5Bcategory_id%5D%5B%5D="
		+ СтрокаОписания.Код + "&f%5B%5D=fixed_version.due_date&op%5Bfixed_version.due_date%5D=%3E%3D&v%5Bfixed_version.due_date%5D%5B%5D="
		+ Формат(ИспользуемаяВерсияДатаВыпуска + 24*60*60, "ДФ=yyyy-ММ-dd") + "&f%5B%5D=&c%5B%5D=tracker&c%5B%5D=subject&c%5B%5D=fixed_version&group_by=tracker&t%5B%5D="
		+ "&f%5B%5D=subject&op%5Bsubject%5D=%2A" // Отбор по темам
		;
	ЗапуститьПриложение(СтрокаЗапуска);
	
КонецПроцедуры

Процедура ИсторияИзмененийПодсистемыНажатие(Элемент)
	
	//СтрокаЗапуска = "http://www.hostedredmine.com/projects/devtool1c/issues?query_id=9313";
	СтрокаЗапуска = "http://www.hostedredmine.com/projects/devtool1c/issues?utf8=%E2%9C%93&set_filter=1&sort=fixed_version%3Adesc%2Ccategory%2Csubject&f%5B%5D=fixed_version.status&op%5Bfixed_version.status%5D=%3D&v%5Bfixed_version.status%5D%5B%5D=closed&f%5B%5D=fixed_version.due_date&op%5Bfixed_version.due_date%5D=%3E%3D&v%5Bfixed_version.due_date%5D%5B%5D="
		+ Формат(ИспользуемаяВерсияДатаВыпуска + 24*60*60, "ДФ=yyyy-ММ-dd") + "&f%5B%5D=&c%5B%5D=category&c%5B%5D=tracker&c%5B%5D=subject&group_by=fixed_version&t%5B%5D=" 
		+ "&f%5B%5D=subject&op%5Bsubject%5D=%2A" // Отбор по темам
		;
	ЗапуститьПриложение(СтрокаЗапуска);
	
КонецПроцедуры

Процедура ИзвестныеПроблемыПодсистемыНажатие(Элемент)
	
	ЗапуститьПриложение("http://www.hostedredmine.com/projects/devtool1c/issues?query_id=9080");
	
КонецПроцедуры

Процедура ИзвестныеПроблемыИнструментаНажатие(Элемент)
	
	СтрокаОписания = ПолучитьСтрокуОписанияИнструмента();
	СтрокаЗапуска = "http://www.hostedredmine.com/projects/devtool1c/issues?utf8=%E2%9C%93&set_filter=1&sort=updated_on%3Adesc&f%5B%5D=fixed_version.status&op%5Bfixed_version.status%5D=%21&v%5Bfixed_version.status%5D%5B%5D=closed&f%5B%5D=status_id&op%5Bstatus_id%5D=%21&v%5Bstatus_id%5D%5B%5D=6&f%5B%5D=tracker_id&op%5Btracker_id%5D=%3D&v%5Btracker_id%5D%5B%5D=1&f%5B%5D=category_id&op%5Bcategory_id%5D=%3D&v%5Bcategory_id%5D%5B%5D=" 
		+ СтрокаОписания.Код + "&f%5B%5D=&c%5B%5D=tracker&c%5B%5D=subject&c%5B%5D=status&c%5B%5D=updated_on&group_by=category&t%5B%5D=;";
	ЗапуститьПриложение(СтрокаЗапуска);
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.ОПодсистеме");
