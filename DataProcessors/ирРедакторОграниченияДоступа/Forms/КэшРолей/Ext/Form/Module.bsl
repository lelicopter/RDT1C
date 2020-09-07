﻿
Процедура КоманднаяПанель1ОбновитьКэш(Кнопка)
	Ответ = Вопрос("Обновление кэша ролей использует конфигуратор текущей базы и может занять до нескольких минут. Продолжить?", РежимДиалогаВопрос.ОКОтмена);
	Если Ответ = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	УдалитьФайлы(КаталогКэша, "*");
	ТекстЛога = "";
	Успех = ирОбщий.ВыполнитьКомандуКонфигуратораЛкс("/DumpConfigFiles """ + КаталогКэша + """ -Right", СтрокаСоединенияИнформационнойБазы(), ТекстЛога, Ложь, "Выгрузка ролей конфигурации");
	Если Не Успех Тогда 
		Сообщить(ТекстЛога);
		Возврат;
	КонецЕсли;
	ОбновитьИнфоПапкиКэшаRLS();
КонецПроцедуры

Процедура ПриОткрытии()
	
	ОбновитьИнфоПапкиКэшаRLS();
	
КонецПроцедуры

Процедура ОбновитьИнфоПапкиКэшаRLS()
	
	ирПлатформа = ирКэш.Получить();
	#Если Сервер И Не Сервер Тогда
		ирПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	ПапкаКэшаПрав = ирПлатформа.СтруктураПодкаталоговФайловогоКэша.КэшРолей;
	#Если Сервер И Не Сервер Тогда
		ПапкаКэшаПрав = Новый Файл;
	#КонецЕсли
	ЭтаФорма.КаталогКэша = ПапкаКэшаПрав.ПолноеИмя;
	Если ПапкаКэшаПрав.Существует() Тогда
		ФайлыКэша = НайтиФайлы(ПапкаКэшаПрав.ПолноеИмя, "*");
		Если ФайлыКэша.Количество() > 0 Тогда
			ЭтаФорма.ДатаОбновленияКэша = ФайлыКэша[0].ПолучитьВремяИзменения();
		КонецЕсли; 
		ЭтаФорма.РазмерКэша = ирОбщий.ВычислитьРазмерКаталогаЛкс(ПапкаКэшаПрав.ПолноеИмя) /1000/1000;
	КонецЕсли;

КонецПроцедуры

Процедура КаталогКэшаОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗапуститьПриложение(КаталогКэша);
	
КонецПроцедуры

Процедура ДействияФормыОчиститьКэш(Кнопка)
	
	Ответ = Вопрос("Кэш ролей будет очищен. Продолжить?", РежимДиалогаВопрос.ОКОтмена);
	Если Ответ = КодВозвратаДиалога.ОК Тогда
		УдалитьФайлы(КаталогКэша);
	КонецЕсли;
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирРедакторОграниченияДоступа.Форма.КэшРолей");
