﻿Перем мРегламентноеЗадание Экспорт;

Процедура OK(Кнопка)
	
	Если Не ЗначениеЗаполнено(Наименование) Тогда
		Наименование = "Ручной запуск пользователем """ + ИмяПользователя() + """";
	КонецЕсли; 
	Попытка
	    ФоновоеЗадание = ФоновыеЗадания.Выполнить(ИмяМетода, ?(мРегламентноеЗадание = Неопределено, Новый Массив, мРегламентноеЗадание.Параметры), Ключ, Наименование);
		Закрыть(Истина);
	Исключение
		ПоказатьИнформациюОбОшибке(ИнформацияОбОшибке());
	КонецПопытки;
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	Если ЗначениеЗаполнено(Идентификатор) Тогда
		ЭлементыФормы.ИмяМетода.ТолькоПросмотр = Истина;
		ЭлементыФормы.Наименование.ТолькоПросмотр = Истина;
		ЭлементыФормы.Ключ.ТолькоПросмотр = Истина;
		ЭлементыФормы.ОсновныеДействияФормы.Кнопки.ОсновныеДействияФормыВыполнить.Доступность = Ложь;
		ЗаголовокЗадания = Наименование;
		Если Не ЗначениеЗаполнено(ЗаголовокЗадания) Тогда
			ЗаголовокЗадания = Регламентное;
		КонецЕсли; 
		ирОбщий.ОбновитьТекстПослеМаркераВСтрокеЛкс(ЭтаФорма.Заголовок,, ЗаголовокЗадания, ": ");
		ОбновитьДанные();
	Иначе
		ЭлементыФормы.ОсновныеДействияФормы.Кнопки.Обновить.Доступность = Ложь;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОсновныеДействияФормыОбновить(Кнопка = Неопределено)
	
	ОбновитьДанные();
	
КонецПроцедуры

Процедура ОбновитьДанные()
	
	ФоновоеЗадание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(Новый УникальныйИдентификатор(Идентификатор)); // Надо получать каждый раз, чтобы считывание из БД выполнялось
	ОбновитьСтрокуФоновогоЗадания(ЭтаФорма, ФоновоеЗадание);
	СообщенияПользователюЛ = ирОбщий.СообщенияПользователюОтФоновогоЗаданияЛкс(ФоновоеЗадание);
	ЭтаФорма.СообщенияПользователю = ирОбщий.СоединитьСообщенияПользователюЛкс(СообщенияПользователюЛ);
	Если ФоновоеЗадание.Состояние <> СостояниеФоновогоЗадания.Активно Тогда
		ОтключитьОбработчикОжидания("ОбновитьДанные");
	Иначе
		ПодключитьОбработчикОжидания("ОбновитьДанные", 5, Истина);
	КонецЕсли; 

КонецПроцедуры

Процедура РазделениеДанныхПредставлениеОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ирОбщий.ОткрытьЗначениеЛкс(РазделениеДанных, Ложь);
	
КонецПроцедуры

Процедура ОшибкиЖРОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьОшибкиЖРПоЗаданию(ЭтаФорма);
	
КонецПроцедуры

Процедура ОшибкаОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если СтрДлина(Элемент.Значение) > 0 Тогда
		ирОбщий.ОткрытьТекстЛкс(Элемент.Значение);
	КонецЕсли; 
	
КонецПроцедуры

Процедура СообщенияПользователюОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если СтрДлина(Элемент.Значение) > 0 Тогда
		ирОбщий.ОткрытьТекстЛкс(Элемент.Значение);
	КонецЕсли; 

КонецПроцедуры

Процедура ИмяМетодаОткрытие(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПерейтиКОпределениюМетодаВКонфигуратореЛкс(ИмяМетода);
	СтандартнаяОбработка = Ложь;

КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирКонсольЗаданий.Форма.ДиалогФоновогоЗадания");
мРегламентноеЗадание = Неопределено;

