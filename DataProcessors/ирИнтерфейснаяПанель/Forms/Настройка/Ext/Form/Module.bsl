﻿
Процедура КнопкаОКНажатие(Кнопка)
	ЗаполнитьЗначенияСвойств(стНастройки, ЭтотОбъект);
	ЗаполнитьДеревоВсехОбъектов();
	ВыполнитьФоновыйПоиск();
	Закрыть();
КонецПроцедуры

СписокВыбора = ЭлементыФормы.ПолнотекстовыйПоискРазмерПорции.СписокВыбора;
СписокВыбора.Добавить(5);
СписокВыбора.Добавить(10);
СписокВыбора.Добавить(20);

СписокВыбора = ЭлементыФормы.ПолнотекстовыйПоискПорогНечеткости.СписокВыбора;
СписокВыбора.Добавить(10);
СписокВыбора.Добавить(25);
СписокВыбора.Добавить(50);
