﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//Если Не ирКэш.ЛиЭтоРасширениеКонфигурацииЛкс() Тогда
	//	Сообщить("Операция доступна только в варианте Расширение");
	//	Отказ = Истина;
	//	Возврат;
	//КонецЕсли;
	Элементы.ФормаВыполнить.Доступность = ирКэш.ЛиЭтоРасширениеКонфигурацииЛкс();
	ПометкиКоманд = ХранилищеОбщихНастроек.Загрузить(, "ирАдаптацияРасширения.ПометкиКоманд",, ирКэш.ИмяПродукта());
	Если ПометкиКоманд = Неопределено Тогда
		СохранитьНастройкиАдаптации(Истина);
	КонецЕсли;
	СписокСочетанийКлавиш = Новый Массив;
	СписокСочетанийКлавиш.Добавить(Метаданные.ОбщиеКоманды.ирОбработатьОбъектыИзАктивнойФормы.Имя);
	СписокСочетанийКлавиш.Добавить(Метаданные.ОбщиеКоманды.ирРедактироватьОбъектИзАктивнойФормы.Имя);
	Для Каждого МетаКоманда Из Метаданные.ОбщиеКоманды Цикл
		Если Истина
			И Метаданные.Подсистемы.ИнструментыРазработчикаTormozit.Состав.Содержит(МетаКоманда)
			И МетаКоманда.Группа.Получить() = Метаданные.ГруппыКоманд.ирКоманднаяПанельФормы
		Тогда 
			Если СписокСочетанийКлавиш.Найти(МетаКоманда.Имя) <> Неопределено Тогда
				СтрокаГорячейКлавиши = ГлобальныеСочетанияКлавиш.Добавить();
				СтрокаГорячейКлавиши.ИмяКоманды = МетаКоманда.Имя;
				СтрокаГорячейКлавиши.СинонимКоманды = МетаКоманда.Представление();
				СтрокаГорячейКлавиши.Подсказка = МетаКоманда.Подсказка;
				СтрокаГорячейКлавиши.СочетаниеКлавиш = ирОбщий.ПреставлениеСочетанияКлавишЛкс(МетаКоманда.СочетаниеКлавиш);
			Иначе
				СтрокаКоманды = СписокКоманд.Добавить();
				СтрокаКоманды.ИмяКоманды = МетаКоманда.Имя;
				СтрокаКоманды.СинонимКоманды = МетаКоманда.Представление();
				СтрокаКоманды.Подсказка = МетаКоманда.Подсказка;
				Если Истина
					И ПометкиКоманд <> Неопределено 
					И ПометкиКоманд.Свойство(СтрокаКоманды.ИмяКоманды)
				Тогда
					СтрокаКоманды.Подключить = ПометкиКоманд[СтрокаКоманды.ИмяКоманды];
				Иначе
					СтрокаКоманды.Подключить = Ложь
						Или СтрокаКоманды.ИмяКоманды = Метаданные.ОбщиеКоманды.ирРедактироватьОбъект.Имя
						Или СтрокаКоманды.ИмяКоманды = Метаданные.ОбщиеКоманды.ирОбработатьОбъекты.Имя
						Или СтрокаКоманды.ИмяКоманды = Метаданные.ОбщиеКоманды.ирРедактироватьИзмененияНаУзле.Имя;
				КонецЕсли; 
			КонецЕсли; 
		КонецЕсли; 
	КонецЦикла;
	СписокКоманд.Сортировать("СинонимКоманды");
	Если Параметры.Автооткрытие Тогда
		Сообщить("Открыть это окно можно в разделе ""Инструменты разработчика""/""Сервис""");
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОперацию(Команда)
	
	СохранитьНастройкиАдаптации();
	Если ирОбщий.АдаптироватьРасширениеЛкс() Тогда 
		ЗавершитьРаботуСистемы(, Истина);
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиАдаптации(ПустуюСтруктуру = Ложь)
	
	ПометкиКоманд = Новый Структура;
	Если Не ПустуюСтруктуру Тогда
		Для Каждого СтрокаКоманды Из СписокКоманд Цикл
			ПометкиКоманд.Вставить(СтрокаКоманды.ИмяКоманды, СтрокаКоманды.Подключить);
		КонецЦикла;
	КонецЕсли; 
	ХранилищеОбщихНастроек.Сохранить(, "ирАдаптацияРасширения.ПометкиКоманд", ПометкиКоманд,, ирКэш.ИмяПродукта());

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	#Если ТонкийКлиент Или ВебКлиент Тогда
		Отказ = Истина;
		ОткрытьФорму("Обработка.ирПортативный.Форма.ФормаУправляемая");
	#КонецЕсли 
	
КонецПроцедуры


