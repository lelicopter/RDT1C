﻿//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирПривилегированный Экспорт;

Перем мРежимОтладки Экспорт;
Перем мСоединениеHttp Экспорт;

Функция ОткрытьДляОтладки(Знач СоединениеHttp, Знач ЗапросHttp = Неопределено, Модально = Истина, ИмяЗапроса = "Запрос для отладки") Экспорт
	
	Перем ЗаголовкиЗапроса;
	Перем ЗаголовкиОтвета;
	#Если Сервер И Не Сервер Тогда
		СоединениеHttp = Новый HTTPСоединение;
		ЗапросHttp = Новый HTTPЗапрос;
	#КонецЕсли
	мСоединениеHttp = СоединениеHttp;

	СтруктураЗапроса = Новый Структура();
	СтруктураЗапроса.Вставить("МетодЗапроса", "GET");
	СтруктураЗапроса.Вставить("СерверЗапроса", СоединениеHttp.Сервер);
	СтруктураЗапроса.Вставить("ПортЗапроса", СоединениеHttp.Порт);
	СтруктураЗапроса.Вставить("ИспользоватьЗащищенноеСоединение", СоединениеHttp.Защищенное);
	СтруктураЗапроса.Вставить("ТелоСтрока", Неопределено);
	СтруктураЗапроса.Вставить("ТелоДвоичныеДанные", Неопределено);
	СтруктураЗапроса.Вставить("ТипАвторизации", "Basic");
	СтруктураЗапроса.Вставить("ТаймаутЗапроса", 10);
	СтруктураЗапроса.Вставить("ИспользоватьПрокси", Ложь);
	СтруктураЗапроса.Вставить("Автоперенаправление", Ложь);
	СтруктураЗапроса.Вставить("МаксимальныйРазмерОтвета", 1000);
	АдресРесурса = "";
	ТелоЗапросаСтрока = Неопределено;
	ТелоЗапросаДвоичныеДанные = Неопределено;
	ПараметрыЗапроса = Новый ТаблицаЗначений;
	ЗаголовкиЗапроса = Новый ТаблицаЗначений;
	ДанныеФормыЗапроса = Новый ТаблицаЗначений;
	Если ТипЗнч(ЗапросHttp) = Тип("HTTPЗапрос") Тогда 
		ТелоЗапросаСтрока = ЗапросHttp.ПолучитьТелоКакСтроку();
		ТелоЗапросаДвоичныеДанные = ЗапросHttp.ПолучитьТелоКакДвоичныеДанные();
		Если ТелоЗапросаДвоичныеДанные <> Неопределено Тогда
			СтруктураЗапроса.МетодЗапроса = "POST";
		КонецЕсли; 
		ПараметрыЗапроса = Новый ТаблицаЗначений;
		ПараметрыЗапроса.Колонки.Добавить("Имя");
		ПараметрыЗапроса.Колонки.Добавить("Значение");
		Фрагменты = ирОбщий.СтрРазделитьЛкс(ЗапросHttp.АдресРесурса, "?");
		Если Фрагменты.Количество() > 1 Тогда
			АдресРесурса = Фрагменты[0];
			Фрагменты = ирОбщий.СтрРазделитьЛкс(Фрагменты[1], "?");
			Для Каждого Фрагмент Из Фрагменты Цикл
				СтрокаПараметра = ПараметрыЗапроса.Добавить();
				СтрокаПараметра.Имя = ирОбщий.ПервыйФрагментЛкс(Фрагмент, "=");
				СтрокаПараметра.Значение = ирОбщий.ПоследнийФрагментЛкс(Фрагмент, "=");
			КонецЦикла;
		Иначе
			АдресРесурса = ЗапросHttp.АдресРесурса;
		КонецЕсли; 
		ЗаголовкиЗапроса = Новый ТаблицаЗначений;
		ЗаголовкиЗапроса.Колонки.Добавить("Имя");
		ЗаголовкиЗапроса.Колонки.Добавить("Значение");
		Для Каждого КлючИЗначение Из ЗапросHttp.Заголовки Цикл
			СтрокаЗаголовка = ЗаголовкиЗапроса.Добавить();
			СтрокаЗаголовка.Имя = КлючИЗначение.Ключ;
			СтрокаЗаголовка.Значение = КлючИЗначение.Значение;
		КонецЦикла;
	КонецЕсли; 
	СтруктураЗапроса.Вставить("АдресРесурса", АдресРесурса);
	СтруктураЗапроса.Вставить("ТелоЗапросаСтрока", ТелоЗапросаСтрока);
	СтруктураЗапроса.Вставить("ТелоЗапросаДвоичныеДанные", ТелоЗапросаДвоичныеДанные);
	СтруктураЗапроса.Вставить("ТелоОтветаСтрока", Неопределено);
	СтруктураЗапроса.Вставить("ТелоОтветаДвоичныеДанные", Неопределено);
	СтруктураЗапроса.Вставить("ПараметрыЗапроса", ПараметрыЗапроса);
	СтруктураЗапроса.Вставить("ЗаголовкиЗапроса", ЗаголовкиЗапроса);
	СтруктураЗапроса.Вставить("ДанныеФормыЗапроса", ДанныеФормыЗапроса);
	мСтрокаЗапроса = ДеревоЗапросов.Строки.Добавить();
	мСтрокаЗапроса.Наименование = ИмяЗапроса;
	мСтрокаЗапроса.Запрос = СтруктураЗапроса;
	мРежимОтладки = Истина;
	Форма = ЭтотОбъект.ПолучитьФорму();
	Если Модально Тогда
		Возврат Форма.ОткрытьМодально();
	Иначе
		Форма.Открыть();
	КонецЕсли;
	
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
//ирПортативный ирОбщий = ирПортативный.ПолучитьОбщийМодульЛкс("ирОбщий");
//ирПортативный ирКэш = ирПортативный.ПолучитьОбщийМодульЛкс("ирКэш");
//ирПортативный ирСервер = ирПортативный.ПолучитьОбщийМодульЛкс("ирСервер");
//ирПортативный ирПривилегированный = ирПортативный.ПолучитьОбщийМодульЛкс("ирПривилегированный");

мРежимОтладки = Ложь;
ДеревоЗапросов.Колонки.Добавить("ИД");
ДеревоЗапросов.Колонки.Добавить("Наименование", Новый ОписаниеТипов("Строка"));
ДеревоЗапросов.Колонки.Добавить("Длительность", Новый ОписаниеТипов("Число, Строка"));
ДеревоЗапросов.Колонки.Добавить("КонтекстВыполнения");
ДеревоЗапросов.Колонки.Добавить("ЭтоГруппа", Новый ОписаниеТипов("Булево"));
ДеревоЗапросов.Колонки.Добавить("Запрос");
ДеревоЗапросов.Колонки.Добавить("Комментарий");

