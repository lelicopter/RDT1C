﻿
Процедура Панель1ПриСменеСтраницы(Элемент = Неопределено, ТекущаяСтраница = Неопределено)
	
	Если ЭлементыФормы.ПанельОсновная.ТекущаяСтраница = ЭлементыФормы.ПанельОсновная.Страницы.Выгрузка Тогда
		ЭлементыФормы.ДействияФормы.Кнопки.Выполнить.Текст = "Выгрузить данные";
	Иначе
		ЭлементыФормы.ДействияФормы.Кнопки.Выполнить.Текст = "Загрузить данные";
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДействияФормыВыполнить(Кнопка)
	
	Если ЭлементыФормы.ПанельОсновная.ТекущаяСтраница = ЭлементыФормы.ПанельОсновная.Страницы.Выгрузка Тогда
		Результат = ВыполнитьВыгрузку();
	Иначе
		ПодключитьОбработчикОжидания("ДобавитьВРезультатыПоследнийПрочитанныйОбъект", 0.1, Истина);
		Результат = ВыполнитьЗагрузку();
		Если Результат <> Истина Тогда
			Предупреждение(Результат, 10);
		КонецЕсли; 
	КонецЕсли; 

КонецПроцедуры

Процедура ДобавитьВРезультатыПоследнийПрочитанныйОбъект()

	Если ЭтотОбъект.мПоследнийПрочитанныйОбъект <> Неопределено Тогда 
		Если Ложь
			Или РезультатОбработки.Количество() = 0
			Или РезультатОбработки[РезультатОбработки.Количество() - 1].КлючОбъекта <> ирОбщий.ПолучитьXMLКлючОбъектаБДЛкс(мПоследнийПрочитанныйОбъект)
		Тогда
			ОбработатьИсключениеПоОбъекту(мПоследнийПрочитанныйОбъект, "Последний считанный из файла объект", Ложь);
		КонецЕсли; 
	КонецЕсли; 

КонецПроцедуры // ДобавитьВРезультатыПоследнийЗагруженныйОбъект()


Процедура КоманднаяПанельРезультатЗагрузкиОткрытьМенеджерТабличногоПоля(Кнопка)
	
	ирОбщий.ПолучитьФормуЛкс("Обработка.ирМенеджерТабличногоПоля.Форма",, ЭтаФорма, ).УстановитьСвязь(ЭлементыФормы.РезультатЗагрузки);
	
КонецПроцедуры

Процедура КоманднаяПанельРезультатЗагрузкиРедакторОбъектаБД(Кнопка)
	
	ТекущаяСтрока = ЭлементыФормы.РезультатЗагрузки.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ОбъектБД = ирОбщий.ВосстановитьОбъектИзСтрокиXMLЛкс(ТекущаяСтрока.XML,, Ложь);
	ирОбщий.ИсследоватьЛкс(ОбъектБД);

КонецПроцедуры

Процедура ИмяФайлаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, Метаданные().Имя);

КонецПроцедуры

Процедура ИмяФайлаПриИзменении(Элемент)
	
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, Метаданные().Имя);
	
КонецПроцедуры

Процедура ИмяФайлаНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	лПолноеИмяФайла = ирОбщий.ВыбратьФайлЛкс(, "zip",, Элемент.Значение);
	Если лПолноеИмяФайла <> Неопределено Тогда
		ирОбщий.ИнтерактивноЗаписатьВЭлементУправленияЛкс(Элемент, лПолноеИмяФайла);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДействияФормыОПодсистеме(Кнопка)
	
	ирОбщий.ОткрытьСправкуПоПодсистемеЛкс(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ЭлементыФормы.ЗаписьНаСервере.Доступность = Не ирКэш.ЛиПортативныйРежимЛкс() Или ирПортативный.ЛиСерверныйМодульДоступенЛкс();
	Панель1ПриСменеСтраницы();
	
КонецПроцедуры

Процедура ДействияФормыНовоеОкно(Кнопка)
	
	ирОбщий.ОткрытьНовоеОкноОбработкиЛкс(ЭтотОбъект);

КонецПроцедуры

Процедура ИмяФайлаОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗапуститьПриложение(Элемент.Значение);
	
КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	ЭтаФорма.КоличествоОшибок = РезультатОбработки.Количество();
	
КонецПроцедуры

Процедура УзелОтправительНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, Метаданные().Имя);
	
КонецПроцедуры

Процедура УзелОтправительПриИзменении(Элемент)
	
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, Метаданные().Имя);

КонецПроцедуры

Процедура УзелОтбораОбъектовПриИзменении(Элемент)
	
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, Метаданные().Имя);
	
КонецПроцедуры

Процедура УзелОтбораОбъектовНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, Метаданные().Имя);
	
КонецПроцедуры

Процедура ДействияФормыРедакторИзмененийНаУзле(Кнопка)
	
	Если ЗначениеЗаполнено(УзелВыборкиДанных) Тогда
		Форма = ирОбщий.ПолучитьФормуЛкс("Обработка.ирРедакторИзмененийПоПлануОбмена.Форма");
		Форма.ПараметрУзелОбмена = УзелВыборкиДанных;
		Форма.Открыть();
	КонецЕсли; 
	
КонецПроцедуры

Процедура КоманднаяПанельРезультатЗагрузкиОтборБезЗначенияВТекущейКолонке(Кнопка)
	
	ирОбщий.ТабличноеПоле_ОтборБезЗначенияВТекущейКолонке_КнопкаЛкс(ЭлементыФормы.ТаблицаЖурнала);
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ирОбщий.ФормаОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура КлсУниверсальнаяКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработчикОжиданияСПараметрамиЛкс() Экспорт 
	
	ирОбщий.ОбработчикОжиданияСПараметрамиЛкс();

КонецПроцедуры

Процедура КоманднаяПанельРезультатЗагрузкиРазличныеЗначенияКолонки(Кнопка)
	
	ирОбщий.ОткрытьРазличныеЗначенияКолонкиЛкс(ЭлементыФормы.РезультатЗагрузки);
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирВыгрузкаЗагрузкаДанныхЧерезФайл.Форма.Форма");

ЭтотОбъект.ЗаписьНаСервере = ирОбщий.ПолучитьРежимЗаписиНаСервереПоУмолчаниюЛкс();

