﻿&НаКлиенте
Процедура ЗапуститьОбычноеПриложение(Команда)
	
	#Если ВебКлиент Тогда
		Сообщить("Команда недоступна в веб клиенте");
	#Иначе
		ПараметрыЗапуска = ирОбщий.ПолучитьПараметрыЗапускаПриложения1СТекущейБазыЛкс();
		ЗапуститьПриложение(КаталогПрограммы() + "1cv8.exe " + ПараметрыЗапуска);
	#КонецЕсли 
	
КонецПроцедуры

&НаКлиенте
Процедура Декорация1Нажатие(Элемент)
	
	ЗапуститьПриложение("http://devtool1c.ucoz.ru/index/opisanie_podsistemy/0-4");
	
КонецПроцедуры

