﻿
Процедура ПолеHTMLДокументаonclick(Элемент, pEvtObj)
	
	Если ирОбщий.ОткрытьГиперссылкуИзПоляHTMLЛкс(pEvtObj.srcElement, pEvtObj.ctrlKey) Тогда 
		pEvtObj.returnValue = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ПриОткрытии()
	ирОбщий.Форма_ПриОткрытииЛкс(ЭтаФорма);
КонецПроцедуры

Процедура ПриЗакрытии()
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);
КонецПроцедуры

ирОбщий.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.HTML");
