﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	#Если ТонкийКлиент Или ВебКлиент Тогда
		Сообщить("В текущем режиме запуска команда не поддерживается");
	#Иначе
		ОперироватьСтруктурой(, , Новый Структура("Источник", ПараметрыВыполненияКоманды.Источник));
	#КонецЕсли 
	
КонецПроцедуры
