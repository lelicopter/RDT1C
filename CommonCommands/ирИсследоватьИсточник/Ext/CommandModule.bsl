﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	#Если ТонкийКлиент Или ВебКлиент Тогда
		Сообщить("Команда доступна только в толстом клиенте");
	#Иначе
		Исследовать(ПараметрыВыполненияКоманды.Источник);
	#КонецЕсли 
	
КонецПроцедуры
