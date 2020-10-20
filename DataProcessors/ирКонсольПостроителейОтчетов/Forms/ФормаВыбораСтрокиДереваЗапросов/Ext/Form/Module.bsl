﻿
Процедура ДеревоЗапросовВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	РодительСтроки = ВыбраннаяСтрока;
	Пока РодительСтроки <> НеОпределено Цикл

		Если РодительСтроки = ТекущаяСтрокаВладельца Тогда
			Предупреждение("Нельзя выбирать в качестве копируемой строки саму строку
			               |или подчиненные ей строки. Выберите другую строку.");
			Возврат;
		КонецЕсли;

		РодительСтроки = РодительСтроки.Родитель;

	КонецЦикла;

	ОповеститьОВыборе(ЭлементыФормы.ДеревоЗапросов.ТекущаяСтрока);

КонецПроцедуры

Процедура КнопкаНаВерхнийУровеньНажатие(Элемент)

	ОповеститьОВыборе(ВладелецФормы.ДеревоЗапросов);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирОбщий.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирКонсольПостроителейОтчетов.Форма.ФормаВыбораСтрокиДереваЗапросов");




