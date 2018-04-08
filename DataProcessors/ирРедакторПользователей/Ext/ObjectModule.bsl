﻿//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирПривилегированный Экспорт;

Процедура ЗаполнитьСписокВыбораРежимаЗапуска(Знач СписокВыбораРежимаЗапуска) Экспорт 
	
	СписокВыбораРежимаЗапуска.Добавить(РежимЗапускаКлиентскогоПриложения.Авто);
	СписокВыбораРежимаЗапуска.Добавить(РежимЗапускаКлиентскогоПриложения.ОбычноеПриложение);
	СписокВыбораРежимаЗапуска.Добавить(РежимЗапускаКлиентскогоПриложения.УправляемоеПриложение);

КонецПроцедуры

Процедура ЗаполнитьСписокВыбораИнтерфейса(Знач СписокВыбораИнтерфейса) Экспорт 
	
	#Если Сервер И Не Сервер Тогда
	    СписокВыбораИнтерфейса = Новый СписокЗначений;
	#КонецЕсли
	Для Каждого ИнтерфейсЛ Из Метаданные.Интерфейсы Цикл
		СписокВыбораИнтерфейса.Добавить(ИнтерфейсЛ, ИнтерфейсЛ.Имя);
	КонецЦикла;
	СписокВыбораИнтерфейса.СортироватьПоПредставлению();

КонецПроцедуры

Процедура ЗаполнитьСписокВыбораЯзыка(Знач СписокВыбораЯзыка) Экспорт
	
	#Если Сервер И Не Сервер Тогда
	    СписокВыбораЯзыка = Новый СписокЗначений;
	#КонецЕсли
	Для Каждого ЯзыкЛ Из Метаданные.Языки Цикл
		СписокВыбораЯзыка.Добавить(ЯзыкЛ, ЯзыкЛ.Имя);
	КонецЦикла;
	СписокВыбораЯзыка.СортироватьПоПредставлению();

КонецПроцедуры


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
//ирПортативный ирОбщий = ирПортативный.ПолучитьОбщийМодульЛкс("ирОбщий");
//ирПортативный ирКэш = ирПортативный.ПолучитьОбщийМодульЛкс("ирКэш");
//ирПортативный ирСервер = ирПортативный.ПолучитьОбщийМодульЛкс("ирСервер");
//ирПортативный ирПривилегированный = ирПортативный.ПолучитьОбщийМодульЛкс("ирПривилегированный");
