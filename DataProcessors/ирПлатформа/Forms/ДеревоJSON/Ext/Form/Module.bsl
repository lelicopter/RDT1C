﻿
Процедура ПриОткрытии()
	
	ОбъектJSON = ирОбщий.ВосстановитьОбъектИзСтрокиJsonЛкс(ПараметрJSON);
	ЭтаФорма.Дерево = ирОбщий.ДеревоЗначенийИзМассиваСтруктурЛкс(ОбъектJSON);
	
КонецПроцедуры

