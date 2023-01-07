﻿
Процедура КнопкаВыполнитьНажатие(Кнопка)
	
	Ответ = Вопрос("Вы уверены в том, что хотите изменить номера сообщений на узле?", РежимДиалогаВопрос.ДаНет);
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	 
	Если УзелОбмена.НомерОтправленного = НомерОтправленного
		И УзелОбмена.НомерПринятого = НомерПринятого Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ОбъектУзла = УзелОбмена.ПолучитьОбъект();
	
	Попытка
	
		ОбъектУзла.НомерОтправленного = НомерОтправленного;
		ОбъектУзла.НомерПринятого = НомерПринятого;
		
		ОбъектУзла.Записать();
		
	Исключение
		
		Сообщить("Возникла ошибка при изменении номеров сообщений обмена: " + ОписаниеОшибки());
		
	Конецпопытки;
	
КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	Если УзелОбмена <> Неопределено Тогда
		НомерОтправленного = УзелОбмена.НомерОтправленного;
		НомерПринятого = УзелОбмена.НомерПринятого;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирКлиент.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирКлиент.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирРедакторИзмененийНаУзлах.Форма.ИзменениеНомеровСообщений");
