﻿
Процедура КнопкаВыполнитьНажатие(Элемент)
	
	ВладелецФормы.ФиксированныйМакет = Новый ТабличныйДокумент;
	ВладелецФормы.ФиксированныйМакет.ВставитьОбласть(
		ЭлементыФормы.Макет.Область(), 
		ВладелецФормы.ФиксированныйМакет.Область(), , Ложь);
	ВладелецФормы.ИспользоватьМакет	= Истина;
	ВладелецФормы.Модифицированность = Истина;
	ВладелецФормы.ФиксированныйЗаголовок = ФиксированныйЗаголовок;
	ВладелецФормы.МакетСОформлением = МакетСОформлением;
	ВладелецФормы.ОбновитьСтраницы();
	Закрыть();
	
КонецПроцедуры

Процедура КоманднаяПанель1МакетПоУмолчанию(Кнопка)
	СтарыйМакетОформления = ПостроительОтчетов.МакетОформления;
	
	ПостроительОтчетов.МакетОформления = Неопределено;
	ПостроительОтчетов.Макет = Неопределено;
	
	НовыйМакет = ПостроительОтчетов.Макет;
	ВладелецФормы.ПрименитьФорматыДляИмен(НовыйМакет);
	ЭлементыФормы.Макет.Очистить();
	ЭлементыФормы.Макет.ВставитьОбласть(НовыйМакет.Область(), ЭлементыФормы.Макет.Область(), , Ложь);
	
	ПостроительОтчетов.МакетОформления = СтарыйМакетОформления;
	
	МакетСОформлением = Ложь;
КонецПроцедуры

Процедура КоманднаяПанель1МакетСОформлением(Кнопка)
	
	МакетОформления = ВладелецФормы.ЭлементыФормы.ВариантОформления.СписокВыбора.ВыбратьЭлемент("Выберите макет оформления");
	
	Если МакетОформления <> Неопределено Тогда
		ПостроительОтчетов.МакетОформления = ПолучитьМакетОформления(МакетОформления.Значение);
		ПостроительОтчетов.Макет = Неопределено;
		
		НовыйМакет = ПостроительОтчетов.Макет;
		ВладелецФормы.ПрименитьФорматыДляИмен(НовыйМакет);
		ЭлементыФормы.Макет.Очистить();
		ЭлементыФормы.Макет.ВставитьОбласть(НовыйМакет.Область(), ЭлементыФормы.Макет.Область(), , Ложь);
		
		МакетСОформлением = Истина;
	КонецЕсли;
КонецПроцедуры

Процедура ПриЗакрытии()
	
	Если ВладелецФормы <> Неопределено Тогда
		ВладелецФормы.Панель.Доступность = Истина;
	КонецЕсли; 
	
КонецПроцедуры

Процедура КоманднаяПанель1ТабличныйДокумент(Кнопка)

	лМакет = Новый ТабличныйДокумент;
	лМакет.ВставитьОбласть(ЭлементыФормы.Макет.Область(), лМакет, , Ложь);
	лМакет.ОтображатьЗаголовки = Истина;
	лМакет.ОтображатьСетку = Истина;
	лМакет.Показать();
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ЭлементыФормы.КоманднаяПанель1.Кнопки.ТабличныйДокумент.Доступность = НЕ ЭлементыФормы.Макет.Защита;
	
КонецПроцедуры

