﻿Процедура ОсновныеДействияФормыОК(Кнопка)
	
	Закрыть(Истина);
	
КонецПроцедуры

Процедура ОсновныеДействияФормыОтмена(Кнопка)
	
	Закрыть();
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирОбщий.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирРедакторИзмененийНаУзлах.Форма.ФормаВыбораОбновленияРегистрации");
ОбновлятьТолькоДляЭлементовСАвтоРегистрацией = Истина;