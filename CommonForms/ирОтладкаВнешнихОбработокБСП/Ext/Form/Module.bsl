﻿
&НаКлиенте
Процедура КаталогФайловогоКэшаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ВыборФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ВыборФайла.Каталог = КаталогФайловогоКэша;
	Если Не ВыборФайла.Выбрать() Тогда
		Возврат;
	КонецЕсли;
	ЭтаФорма.КаталогФайловогоКэша = ВыборФайла.Каталог;
	КаталогФайловогоКэшаПриИзменении();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Метаданные.Справочники.Найти("ДополнительныеОтчетыИОбработки") = Неопределено Тогда
		Сообщить("Справочник внешних обработок БСП не обнаружен");
		Отказ = Истина;
		Возврат;
	КонецЕсли; 
	ВерсияПлатформы = ирКэш.Получить().ВерсияПлатформы;
	Элементы.НадписьНеРаботаютТочкиОстанова.Видимость = ВерсияПлатформы = 803006;
	ПрочитатьНастройкиНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьНастройкиНаСервере()
	
	Обработчик = ирСервер.НайтиПерехватВнешнихОбработокБСПЛкс();
	ЭтаФорма.ПерехватВнешнихОбработок = Обработчик <> Неопределено;
	Если ПерехватВнешнихОбработок Тогда
		ЭтаФорма.КаталогФайловогоКэша = Обработчик.КаталогФайловогоКэша;
		ЭтаФорма.СозданиеВнешнихОбработокЧерезФайл = ХранилищеСистемныхНастроек.Загрузить("ирОтладкаВнешнихОбработок", "СозданиеВнешнихОбработокЧерезФайл");
		ОбновитьСписокНаСервере();
	Иначе
		ЭтаФорма.СозданиеВнешнихОбработокЧерезФайл = Ложь;
		СохранитьНастройкиПользователяНаСервере();
	КонецЕсли; 
	ОбновитьДоступность();

КонецПроцедуры

&НаКлиенте
Процедура ОтладкаДляТекущегоПользователяПриИзменении(Элемент)
	
	Если СозданиеВнешнихОбработокЧерезФайл Тогда
		Если ЭтаФорма.ПерехватВнешнихОбработок <> Истина Тогда 
			ЭтаФорма.ПерехватВнешнихОбработок = Истина;
			Если Не СохранитьНастройкиНаСервере() Тогда 
				Возврат;
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли;
	СохранитьНастройкиПользователяНаСервере();

КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиПользователяНаСервере()
	
	ХранилищеСистемныхНастроек.Сохранить("ирОтладкаВнешнихОбработок", "СозданиеВнешнихОбработокЧерезФайл", СозданиеВнешнихОбработокЧерезФайл);

КонецПроцедуры

&НаКлиенте
Процедура КаталогФайловогоКэшаПриИзменении(Элемент = Неопределено)
	
	СохранитьНастройкиНаСервере();
	ОбновитьСписокНаСервере();
	
КонецПроцедуры

&НаСервере
Функция СохранитьНастройкиНаСервере()
	
	Если ПерехватВнешнихОбработок Тогда
		ФайлКаталога = Новый Файл(КаталогФайловогоКэша);
		Если Не ФайлКаталога.Существует() Тогда
			Сообщить("Выбранный каталог недоступен серверу. Выберите другой каталог");
			ПрочитатьНастройкиНаСервере();
			ЭтаФорма.СозданиеВнешнихОбработокЧерезФайл = Ложь;
			СохранитьНастройкиПользователяНаСервере();
			Возврат Ложь;
		КонецЕсли; 
		ирСервер.ВключитьПерехватВнешнихОбработокБСПЛкс(КаталогФайловогоКэша);
	Иначе
		ирСервер.НайтиПерехватВнешнихОбработокБСПЛкс(Истина);
	КонецЕсли; 
	//ПрочитатьНастройкиНаСервере();
	Возврат Истина;
	
КонецФункции

&НаСервере
Процедура ОбновитьСписокНаСервере()
	
	Список.Очистить();
	ОбновитьДоступность();
	Если Не ЗначениеЗаполнено(КаталогФайловогоКэша) Тогда
		Возврат;
	КонецЕсли; 
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ДополнительныеОтчетыИОбработки.Ссылка КАК Ссылка,
	               |	ДополнительныеОтчетыИОбработки.ИмяФайла
	               |ИЗ
	               |	Справочник.ДополнительныеОтчетыИОбработки КАК ДополнительныеОтчетыИОбработки
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Ссылка
	               |АВТОУПОРЯДОЧИВАНИЕ";
	Результат = Запрос.Выполнить().Выгрузить();
	СравнениеЗначений = Новый СравнениеЗначений;
	Для Каждого СтрокаРезультата Из Результат Цикл
		СтрокаТаблицы = Список.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы, СтрокаРезультата); 
		ПолноеИмяФайла = ирСервер.ПолноеИмяФайлаВнешнейОбработкиВФайловомКэшеЛкс(СтрокаТаблицы.Ссылка, КаталогФайловогоКэша);
		Файл = Новый Файл(ПолноеИмяФайла);
		СтрокаТаблицы.ИмяФайла = Файл.Имя;
		Если Файл.Существует() Тогда
			Попытка
				ДвоичныеДанныеФайла = Новый ДвоичныеДанные(ПолноеИмяФайла);
			Исключение
				Сообщить("Ошибка доступа к файлу """ + ПолноеИмяФайла + """: " + ОписаниеОшибки());
				Продолжить;
			КонецПопытки; 
			СтрокаТаблицы.ДатаИзмененияФайла = Файл.ПолучитьВремяИзменения() + ирКэш.ПолучитьСмещениеВремениЛкс();
			СтрокаТаблицы.ФайлОтличаетсяОтХранилища = СравнениеЗначений.Сравнить(ДвоичныеДанныеФайла, СтрокаТаблицы.Ссылка.ХранилищеОбработки.Получить()) <> 0;
		КонецЕсли; 
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДоступность()
	
	Элементы.ВнешниеОбработкиЗагрузитьИзФайла.Доступность = ЗначениеЗаполнено(КаталогФайловогоКэша);
	Элементы.ВнешниеОбработкиОткрытьВОтладчике.Доступность = ЗначениеЗаполнено(КаталогФайловогоКэша);

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписок(Команда = Неопределено)
	
	КлючСтроки = ирОбщий.ПолучитьКлючТекущейСтрокиЛкс(Элементы.Список);
	ОбновитьСписокНаСервере();
	ирОбщий.ВосстановитьТекущуюСтрокуТаблицыФормыЛкс(Элементы.Список, КлючСтроки, Список);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВОтладчике(Команда)
	
	#Если ТонкийКлиент Или ВебКлиент Тогда
		Сообщить("Функция доступна только в толстом клиенте");
		Возврат;
	#КонецЕсли 
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ПолноеИмяФайла = ирСервер.ПолноеИмяФайлаВнешнейОбработкиВФайловомКэшеЛкс(ТекущиеДанные.Ссылка, КаталогФайловогоКэша);
	Файл = Новый Файл(ПолноеИмяФайла);
	Если Не Файл.Существует() Тогда
		ТекущиеДанные.Ссылка.ХранилищеОбработки.Получить().Записать(ПолноеИмяФайла);
	КонецЕсли; 
	ирКэш.Получить().ОткрытьФайлВКонфигураторе(ПолноеИмяФайла, "Модуль");
	ОбновитьСписок();
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешниеОбработкиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОткрытьЗначение(Элемент.ТекущиеДанные.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерехватВнешнихОбработокПриИзменении(Элемент)
	
	Если Не ПерехватВнешнихОбработок Тогда
		ЭтаФорма.СозданиеВнешнихОбработокЧерезФайл = Ложь;
		СохранитьНастройкиПользователяНаСервере();
	КонецЕсли; 
	СохранитьНастройкиНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьАктуальныеНастройки(Команда)
	
	ПрочитатьНастройкиНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзФайла(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ЗагрузитьИзФайлаНаСервере(ТекущиеДанные.Ссылка, КаталогФайловогоКэша);
	ОбновитьСписок();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗагрузитьИзФайлаНаСервере(Ссылка, КаталогФайловогоКэша)
	
	#Если Сервер И Не Сервер Тогда
	    Ссылка = Справочники.ДополнительныеОтчетыИОбработки.ПустаяСсылка();
	#КонецЕсли
	ПолноеИмяФайла = ирСервер.ПолноеИмяФайлаВнешнейОбработкиВФайловомКэшеЛкс(Ссылка, КаталогФайловогоКэша);
	Файл = Новый Файл(ПолноеИмяФайла);
	Если Не Файл.Существует() Тогда
		Возврат;
	КонецЕсли; 
	ОбъектМодуля = ВнешниеОбработки.Создать(Файл.ПолноеИмя, Ложь);
	СведенияМодуля = ОбъектМодуля.СведенияОВнешнейОбработке();
	Объект = Ссылка.ПолучитьОбъект();
	Объект.Версия = СведенияМодуля.Версия;
	Объект.ХранилищеОбработки = Новый ХранилищеЗначения(Новый ДвоичныеДанные(Файл.ПолноеИмя));
	Объект.Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогФайловогоКэшаОткрытие(Элемент, СтандартнаяОбработка)
	
	ЗапуститьПриложение(КаталогФайловогоКэша);
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры


