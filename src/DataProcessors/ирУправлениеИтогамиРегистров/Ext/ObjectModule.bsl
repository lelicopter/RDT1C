﻿//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирКлиент Экспорт;

Процедура ВыполнитьКомандуПользователя(ВыделенныеСтроки, Команда, ПериодИтогов = Неопределено) Экспорт 
	
	Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(ВыделенныеСтроки.Количество(), Команда);
	Для каждого СтрокаТаблицы Из ВыделенныеСтроки Цикл
		ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
		Если СтрокаТаблицы.ТипРегистра = "РегистрНакопления" Тогда
			РегистрМенеджер = РегистрыНакопления[СтрокаТаблицы.ИмяРегистра];
		ИначеЕсли СтрокаТаблицы.ТипРегистра = "РегистрБухгалтерии" Тогда
			РегистрМенеджер = РегистрыБухгалтерии[СтрокаТаблицы.ИмяРегистра];
		ИначеЕсли СтрокаТаблицы.ТипРегистра = "РегистрСведений" Тогда
			РегистрМенеджер = РегистрыСведений[СтрокаТаблицы.ИмяРегистра];
		КонецЕсли;
		Попытка 
			Если Команда = "ВключитьИспользованиеИтогов" Тогда
				РегистрМенеджер.УстановитьИспользованиеИтогов(Истина);
				СтрокаТаблицы.ИспользованиеИтогов = Истина;
			ИначеЕсли Команда = "ВыключитьИспользованиеИтогов" Тогда
				РегистрМенеджер.УстановитьИспользованиеИтогов(Ложь);
				СтрокаТаблицы.ИспользованиеИтогов = Ложь; 
			ИначеЕсли Команда = "ПересчитатьИтоги" Тогда
				РегистрМенеджер.ПересчитатьИтоги();
			Иначе
				Если СтрокаТаблицы.ТипРегистра <> "РегистрСведений" Тогда
					Если Команда = "ВключитьТекущиеИтоги" Тогда
						Если Истина
							И СтрокаТаблицы.ТипРегистра = "РегистрНакопления" 
							И СтрокаТаблицы.ВидРегистра = "Обороты" 
							Тогда
							Продолжить;
						КонецЕсли;
						РегистрМенеджер.УстановитьИспользованиеТекущихИтогов(Истина);
						СтрокаТаблицы.ИспользованиеТекущихИтогов = Истина;
					ИначеЕсли Команда = "ВыключитьТекущиеИтоги" Тогда
						Если Истина
							И СтрокаТаблицы.ТипРегистра = "РегистрНакопления" 
							И СтрокаТаблицы.ВидРегистра = "Обороты" 
							Тогда
							Продолжить;
						КонецЕсли;
						РегистрМенеджер.УстановитьИспользованиеТекущихИтогов(Ложь);
						СтрокаТаблицы.ИспользованиеТекущихИтогов = Ложь;   			
					ИначеЕсли Команда = "ВключитьРазделениеИтогов" Тогда
						РегистрМенеджер.УстановитьРежимРазделенияИтогов(Истина);
						СтрокаТаблицы.РазделениеИтогов = Истина;
					ИначеЕсли Команда = "ВыключитьРазделениеИтогов" Тогда
						РегистрМенеджер.УстановитьРежимРазделенияИтогов(Ложь);
						СтрокаТаблицы.РазделениеИтогов = Ложь;
					ИначеЕсли Команда = "УстановитьГраницыИтогов" Тогда
						Если Ложь
							Или (Истина
							И СтрокаТаблицы.ТипРегистра = "РегистрНакопления" 
							И СтрокаТаблицы.ВидРегистра = "Остатки")
							Или СтрокаТаблицы.ТипРегистра = "РегистрБухгалтерии"
							Тогда
							РегистрМенеджер.УстановитьПериодРассчитанныхИтогов(ПериодИтогов.МаксимальнаяДата);
							СтрокаТаблицы.ПериодИтогов = ПериодИтогов.МаксимальнаяДата;
							Если Не ирОбщий.РежимСовместимостиМеньше8_3_4Лкс() Тогда
								РегистрМенеджер.УстановитьМинимальныйПериодРассчитанныхИтогов(ПериодИтогов.МинимальнаяДата);
								СтрокаТаблицы.ПериодНачалаИтогов = ПериодИтогов.МинимальнаяДата;
							КонецЕсли; 
						КонецЕсли;
					ИначеЕсли Команда = "ПересчитатьТекущиеИтоги" Тогда
						Если Истина
							И СтрокаТаблицы.ТипРегистра = "РегистрНакопления" 
							И СтрокаТаблицы.ВидРегистра = "Обороты" 
							Тогда
							Продолжить;
						КонецЕсли;
						РегистрМенеджер.ПересчитатьТекущиеИтоги();
					ИначеЕсли Команда = "ПересчитатьИтогиЗаПериод" Тогда
						РегистрМенеджер.ПересчитатьИтогиЗаПериод(ПериодИтогов.НачалоПериода, ПериодИтогов.КонецПериода);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		Исключение
			Если ПрерыватьПриОшибке Тогда
				ВызватьИсключение;
			КонецЕсли; 
			ирОбщий.СообщитьЛкс("Ошибка обработки регистра """ + СтрокаТаблицы.ПолноеИмя + """: " + ОписаниеОшибки());
		КонецПопытки;
	КонецЦикла;
	Если ВыделенныеСтроки.Количество() > 0 Тогда
		ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	КонецЕсли; 
	
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
//ирПортативный ирКлиент = ирПортативный.ПолучитьОбщийМодульЛкс("ирКлиент");
