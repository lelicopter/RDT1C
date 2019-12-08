﻿
&Вместо("ПодключитьВнешнююОбработку")
Функция ирПодключитьВнешнююОбработку(Ссылка)
	
	// ИР. Начало оригинального кода
	
	СтандартнаяОбработка = Истина;
	Результат = Неопределено;
	Если Метаданные.ОбщиеМодули.Найти("ИнтеграцияСТехнологиейСервиса") <> Неопределено Тогда
		МодульИнтеграцияПодсистемБСП = ОбщегоНазначения.ОбщийМодуль("ИнтеграцияСТехнологиейСервиса"); // БСП 2.4
	ИначеЕсли Метаданные.ОбщиеМодули.Найти("ИнтеграцияПодсистемБСП") <> Неопределено Тогда
		МодульИнтеграцияПодсистемБСП = ОбщегоНазначения.ОбщийМодуль("ИнтеграцияПодсистемБСП"); // БСП 3.1
	Иначе
		МодульИнтеграцияПодсистемБСП = Неопределено;
	КонецЕсли; 
	Если МодульИнтеграцияПодсистемБСП <> Неопределено Тогда
		МодульИнтеграцияПодсистемБСП.ПриПодключенииВнешнейОбработки(Ссылка, СтандартнаяОбработка, Результат);
	КонецЕсли; 
	Если Не СтандартнаяОбработка Тогда
		Возврат Результат;
	КонецЕсли;
	// Проверка корректности переданных параметров.
	Если ТипЗнч(Ссылка) <> Тип("СправочникСсылка.ДополнительныеОтчетыИОбработки") 
		Или Ссылка = Справочники.ДополнительныеОтчетыИОбработки.ПустаяСсылка() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	// ИР. Перенесено ниже
	//// Подключение
	//#Если ТолстыйКлиентОбычноеПриложение Тогда
	//	ИмяОбработки = ПолучитьИмяВременногоФайла();
	//	ХранилищеОбработки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ХранилищеОбработки");
	//	ДвоичныеДанные = ХранилищеОбработки.Получить();
	//	ДвоичныеДанные.Записать(ИмяОбработки);
	//	Возврат ИмяОбработки;
	//#КонецЕсли
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПрофилиБезопасности") Тогда
		МодульРаботаВБезопасномРежиме = ОбщегоНазначения.ОбщийМодуль("РаботаВБезопасномРежиме");
		ИспользуютсяПрофилиБезопасности = МодульРаботаВБезопасномРежиме.ИспользуютсяПрофилиБезопасности();
	Иначе
		ИспользуютсяПрофилиБезопасности = Ложь;
	КонецЕсли;
	Вид = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Вид");
	Если Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок.Отчет
		Или Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительныйОтчет Тогда
		Менеджер = ВнешниеОтчеты;
	Иначе
		Менеджер = ВнешниеОбработки;
	КонецЕсли;
	ПараметрыЗапуска = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "БезопасныйРежим, ХранилищеОбработки");
	
	// ИР. Перенесено ниже
	//АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(ПараметрыЗапуска.ХранилищеОбработки.Получить());
	
	Если ИспользуютсяПрофилиБезопасности Тогда
		МодульРаботаВБезопасномРежимеСлужебный = ОбщегоНазначения.ОбщийМодуль("РаботаВБезопасномРежимеСлужебный");
		БезопасныйРежим = МодульРаботаВБезопасномРежимеСлужебный.РежимПодключенияВнешнегоМодуля(Ссылка);
		Если БезопасныйРежим = Неопределено Тогда
			БезопасныйРежим = Истина;
		КонецЕсли;
	Иначе
		БезопасныйРежим = ПолучитьФункциональнуюОпцию("СтандартныеПодсистемыВМоделиСервиса") Или ПараметрыЗапуска.БезопасныйРежим;
		Если БезопасныйРежим Тогда
			ЗапросРазрешений = Новый Запрос(
				"ВЫБРАТЬ ПЕРВЫЕ 1
				|	ДополнительныеОтчетыИОбработкиРазрешения.НомерСтроки,
				|	ДополнительныеОтчетыИОбработкиРазрешения.ВидРазрешения
				|ИЗ
				|	Справочник.ДополнительныеОтчетыИОбработки.Разрешения КАК ДополнительныеОтчетыИОбработкиРазрешения
				|ГДЕ
				|	ДополнительныеОтчетыИОбработкиРазрешения.Ссылка = &Ссылка");
			ЗапросРазрешений.УстановитьПараметр("Ссылка", Ссылка);
			ЕстьРазрешений = Не ЗапросРазрешений.Выполнить().Пустой();
			РежимСовместимости = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "РежимСовместимостиРазрешений");
			Если РежимСовместимости = Перечисления.РежимыСовместимостиРазрешенийДополнительныхОтчетовИОбработок.Версия_2_2_2
				И ЕстьРазрешений Тогда
				БезопасныйРежим = Ложь;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	ЗаписатьПримечание(Ссылка, НСтр("ru = 'Подключение, БезопасныйРежим = """ + БезопасныйРежим + """.'"));
	
	// ИР.Конец оригинального кода
	
	ИмяОбработки = "";
	ирСервер.ПриПодключенииВнешнейОбработки(Ссылка, Истина, ИмяОбработки);
	Если ЗначениеЗаполнено(ИмяОбработки) Тогда
		Возврат ИмяОбработки;
	КонецЕсли; 
	
	// ИР. Перенесенный оригинальный код
	#Если ТолстыйКлиентОбычноеПриложение Тогда
		ИмяОбработки = ПолучитьИмяВременногоФайла();
		ХранилищеОбработки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ХранилищеОбработки");
		ДвоичныеДанные = ХранилищеОбработки.Получить();
		ДвоичныеДанные.Записать(ИмяОбработки);
		Возврат ИмяОбработки;
	#КонецЕсли
	
	// ИР. Перенесенный оригинальный код
	АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(ПараметрыЗапуска.ХранилищеОбработки.Получить());
	
	// ИР. Начало оригинального кода
	Если ОбщегоНазначения.ЕстьЗащитаОтОпасныхДействий() Тогда
		ИмяОбработки = Менеджер.Подключить(АдресВоВременномХранилище, , БезопасныйРежим,
			ОбщегоНазначения.ОписаниеЗащитыБезПредупреждений());
	Иначе
		ИмяОбработки = Менеджер.Подключить(АдресВоВременномХранилище, , БезопасныйРежим);
	КонецЕсли;
	Возврат ИмяОбработки;
	// ИР.Конец оригинального кода

КонецФункции

Функция ирПроверкаПодключенияРасширенияМодуля() Экспорт 
КонецФункции