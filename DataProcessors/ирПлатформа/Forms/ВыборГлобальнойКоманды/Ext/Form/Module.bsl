﻿Процедура ПриОткрытии()
	
	ОбновитьДоступныеКоманды();
	ВыбраннаяГлобальнаяКоманда = ирОбщий.ВосстановитьЗначениеЛкс("ВыбраннаяГлобальнаяКоманда");
	Если ВыбраннаяГлобальнаяКоманда <> Неопределено Тогда
		НовыйТекущийЭлемент = Команды.Найти(ВыбраннаяГлобальнаяКоманда, "Имя");
		Если НовыйТекущийЭлемент <> Неопределено Тогда
			ЭлементыФормы.Команды.ТекущаяСтрока = НовыйТекущийЭлемент;
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбновитьДоступныеКоманды()
	
	Если ЭлементыФормы.Команды.ТекущаяСтрока <> Неопределено Тогда
		СтараяТекущаяКоманда = ЭлементыФормы.Команды.ТекущаяСтрока.Имя;
	КонецЕсли; 
	Команды.Очистить();
	ОтложенноеВыполнение = Ложь;
	АктивнаяФорма = ирОбщий.РодительЭлементаУправляемойФормыЛкс(ТекущийЭлементАктивнойФормы);
	ДанныеТекущегоЭлемента = ирОбщий.ДанныеЭлементаФормыЛкс(ТекущийЭлементАктивнойФормы);
	Если Ложь
		Или ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ТаблицаФормы") 
		Или (Истина
			И ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ПолеФормы") 
			И (Ложь
				Или ТекущийЭлементАктивнойФормы.Вид = ВидПоляФормы.ПолеВвода
				Или ТекущийЭлементАктивнойФормы.Вид = ВидПоляФормы.ПолеТабличногоДокумента))
	Тогда
		Если Истина
			И ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ПолеФормы") 
			И ТекущийЭлементАктивнойФормы.Вид = ВидПоляФормы.ПолеТабличногоДокумента
		Тогда
			Параметр = "ячейка";
		Иначе
			Параметр = "поле";
		КонецЕсли; 
		#Если Сервер И Не Сервер Тогда
			РедактироватьОбъектТекущегоПоляАктивнойФормыЛкс();
		#КонецЕсли
		НоваяКоманда = Команды.Добавить();
		НоваяКоманда.Имя = "РедактироватьОбъектТекущегоПоляАктивнойФормыЛкс";
		НоваяКоманда.Представление = "Редактировать объект";
		НоваяКоманда.Пояснение = "Открыть объект по ссылке в редакторе объекта БД (ИР)";
		НоваяКоманда.Картинка = ирКэш.КартинкаИнструментаЛкс("Обработка.ирРедакторОбъектаБД");
		НоваяКоманда.Параметр = Параметр;
		
		#Если Сервер И Не Сервер Тогда
			ОткрытьОбъектТекущегоПоляАктивнойФормыЛкс();
		#КонецЕсли
		НоваяКоманда = Команды.Добавить();
		НоваяКоманда.Имя = "ОткрытьОбъектТекущегоПоляАктивнойФормыЛкс";
		НоваяКоманда.Представление = "Открыть объект";
		НоваяКоманда.Пояснение = "Открыть объект по ссылке в основной форме";
		НоваяКоманда.Картинка = ирКэш.КартинкаПоИмениЛкс("Лупа");
		НоваяКоманда.Параметр = Параметр;
	КонецЕсли; 
	Если Ложь
		Или ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ТаблицаФормы") 
		Или (Истина
			И ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ПолеФормы") 
			И (Ложь
				//Или ТекущийЭлементАктивнойФормы.Вид = ВидПоляФормы.ПолеВвода
				Или ТекущийЭлементАктивнойФормы.Вид = ВидПоляФормы.ПолеТабличногоДокумента))
	Тогда
		Если Истина
			И ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ПолеФормы") 
			И ТекущийЭлементАктивнойФормы.Вид = ВидПоляФормы.ПолеТабличногоДокумента
		Тогда
			Параметр = "ячейка";
		Иначе
			Параметр = "поле";
		КонецЕсли; 
		#Если Сервер И Не Сервер Тогда
			ОбработатьОбъектыТекущегоПоляАктивнойФормыЛкс();
		#КонецЕсли
		НоваяКоманда = Команды.Добавить();
		НоваяКоманда.Имя = "ОбработатьОбъектыТекущегоПоляАктивнойФормыЛкс";
		НоваяКоманда.Представление = "Обработать выделенные объекты";
		НоваяКоманда.Пояснение = "Обработать выделенные объекты в подборе и обработке объектов БД (ИР)";
		НоваяКоманда.Картинка = ирКэш.КартинкаИнструментаЛкс("Обработка.ирПодборИОбработкаОбъектов");
		НоваяКоманда.Параметр = Параметр;
	КонецЕсли; 
	Если Ложь
		Или ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ТаблицаФормы")
		Или ирОбщий.КлючОсновногоОбъектаУправляемойФормыЛкс(АктивнаяФорма) <> Неопределено
	Тогда
		Если ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ТаблицаФормы") Тогда
			Параметр = "строка";
		Иначе
			Параметр = "форма";
		КонецЕсли; 
		#Если Сервер И Не Сервер Тогда
			РедактироватьОбъектАктивнойФормыЛкс();
		#КонецЕсли
		НоваяКоманда = Команды.Добавить();
		НоваяКоманда.Имя = "РедактироватьОбъектАктивнойФормыЛкс";
		НоваяКоманда.Представление = "Редактировать объект";
		НоваяКоманда.Пояснение = "Открыть объект по ссылке в редакторе объекта БД (ИР)";
		НоваяКоманда.Картинка = ирКэш.КартинкаИнструментаЛкс("Обработка.ирРедакторОбъектаБД");
		НоваяКоманда.Параметр = Параметр;
	КонецЕсли; 
	Если ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ТаблицаФормы") Тогда 
		#Если Сервер И Не Сервер Тогда
			ОбработатьОбъектыАктивнойФормыЛкс();
		#КонецЕсли
		НоваяКоманда = Команды.Добавить();
		НоваяКоманда.Имя = "ОбработатьОбъектыАктивнойФормыЛкс";
		НоваяКоманда.Представление = "Обработать выделенные объекты";
		НоваяКоманда.Пояснение = "Обработать выделенные объекты в подборе и обработке объектов БД (ИР)";
		НоваяКоманда.Картинка = ирКэш.КартинкаИнструментаЛкс("Обработка.ирПодборИОбработкаОбъектов");
		НоваяКоманда.Параметр = "строка";
	КонецЕсли; 
	Если Ложь
		Или ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ТаблицаФормы") 
		Или (Истина
			И ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ПолеФормы") 
			И ТекущийЭлементАктивнойФормы.Вид = ВидПоляФормы.ПолеТабличногоДокумента)
	Тогда
		Если ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ТаблицаФормы") Тогда
			НаименованиеКоманды = "Открыть различные значения колонки";
			Если ДанныеТекущегоЭлемента = Неопределено Тогда
				НаименованиеКоманды = НаименованиеКоманды + " выделенных строк";
			КонецЕсли; 
			#Если Сервер И Не Сервер Тогда
				ОткрытьРазличныеЗначенияКолонкиАктивнойФормыЛкс();
			#КонецЕсли
			НоваяКоманда = Команды.Добавить();
			НоваяКоманда.Имя = "ОткрытьРазличныеЗначенияКолонкиАктивнойФормыЛкс";
			НоваяКоманда.Представление = НаименованиеКоманды;
			НоваяКоманда.Пояснение = "Открыть список различных значений колонки";
			НоваяКоманда.Картинка = ирКэш.КартинкаИнструментаЛкс("Обработка.ирРазличныеЗначенияКолонки");
			НоваяКоманда.Параметр = "таблица";
		КонецЕсли; 
		
		НаименованиеКоманды = "Сравнить данные";
		Если ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ТаблицаФормы") Тогда
			Если ДанныеТекущегоЭлемента = Неопределено Тогда
				НаименованиеКоманды = НаименованиеКоманды + " выделенных строк";
			КонецЕсли; 
			Параметр = "таблица";
		Иначе
			Параметр = "табличный документ";
		КонецЕсли; 
		#Если Сервер И Не Сервер Тогда
			СравнитьТаблицуАктивнойФормыЛкс();
		#КонецЕсли
		НоваяКоманда = Команды.Добавить();
		НоваяКоманда.Имя = "СравнитьТаблицуАктивнойФормыЛкс";
		НоваяКоманда.Представление = НаименованиеКоманды;
		НоваяКоманда.Пояснение = "Передать данные в одну сторону сравнения. Если вторая сторона заполнена, то будет выполнено сравнение.";
		НоваяКоманда.Картинка = ирКэш.КартинкаПоИмениЛкс("ирСравнить");
		НоваяКоманда.Параметр = Параметр;
		
		НаименованиеКоманды = "Открыть таблицу";
		Параметр = "таблица";
		Если ДанныеТекущегоЭлемента = Неопределено Тогда
			НаименованиеКоманды = НаименованиеКоманды + " выделенных строк";
		ИначеЕсли ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ПолеФормы") Тогда
			НаименованиеКоманды = НаименованиеКоманды + " выделенных ячеек";
			Параметр = "табличный документ";
		КонецЕсли; 
		#Если Сервер И Не Сервер Тогда
			ОткрытьТаблицуАктивнойФормыЛкс();
		#КонецЕсли
		НоваяКоманда = Команды.Добавить();
		НоваяКоманда.Имя = "ОткрытьТаблицуАктивнойФормыЛкс";
		НоваяКоманда.Представление = НаименованиеКоманды;
		НоваяКоманда.Пояснение = "Открыть таблицу в редакторе таблицы значений (ИР)";
		НоваяКоманда.Параметр = Параметр;
		НоваяКоманда.Картинка = ирКэш.КартинкаПоИмениЛкс("ирТаблицаЗначений");
		
		Если ТипЗнч(ДанныеТекущегоЭлемента) = Тип("ДинамическийСписок") Тогда
			#Если Сервер И Не Сервер Тогда
				НастроитьДинамическийСписокАктивнойФормыЛкс();
			#КонецЕсли
			НоваяКоманда = Команды.Добавить();
			НоваяКоманда.Имя = "НастроитьДинамическийСписокАктивнойФормыЛкс";
			НоваяКоманда.Представление = "Настроить список";
			НоваяКоманда.Пояснение = "";
			НоваяКоманда.Картинка = ирКэш.КартинкаПоИмениЛкс("НастроитьСписок");
			НоваяКоманда.Параметр = "динамический список";
			Если ирОбщий.ЛиКорневойТипСсылочногоОбъектаБДЛкс(ирОбщий.ПервыйФрагментЛкс(ирОбщий.ИмяТаблицыБДДинамическогоСпискаЛкс(ТекущийЭлементАктивнойФормы))) Тогда
				#Если Сервер И Не Сервер Тогда
					НайтиВыбратьСсылкуВДинамическомСпискеАктивнойФормыЛкс();
				#КонецЕсли
				НоваяКоманда = Команды.Добавить();
				НоваяКоманда.Имя = "НайтиВыбратьСсылкуВДинамическомСпискеАктивнойФормыЛкс";
				НоваяКоманда.Представление = "Найти/Выбрать ссылку по ID";
				НоваяКоманда.Пояснение = "";
				НоваяКоманда.Картинка = ирКэш.КартинкаПоИмениЛкс("ирИдентификатор");
				НоваяКоманда.Параметр = "динамический список";
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 
	
	Если ирОбщий.ЭтоУправляемаяФормаОтчетаЛкс(АктивнаяФорма) Тогда
		#Если Сервер И Не Сервер Тогда
			ОтладитьКомпоновкуДанныхАктивнойФормыЛкс();
		#КонецЕсли
		НоваяКоманда = Команды.Добавить();
		НоваяКоманда.Имя = "ОтладитьКомпоновкуДанныхАктивнойФормыЛкс";
		НоваяКоманда.Представление = "Отладить компоновку данных";
		НоваяКоманда.Пояснение = "Отладить схему и настройки компоновки отчета в консоли компоновки данных (ИР)";
		НоваяКоманда.Картинка = ирКэш.КартинкаПоИмениЛкс("ирОтладка");
		НоваяКоманда.Параметр = "форма отчета";
	КонецЕсли; 
	#Если Сервер И Не Сервер Тогда
		ОткрытьСтруктуруАктивнойФормыЛкс();
	#КонецЕсли
	НоваяКоманда = Команды.Добавить();
	НоваяКоманда.Имя = "ОткрытьСтруктуруАктивнойФормыЛкс";
	НоваяКоманда.Представление = "Открыть структуру формы";
	НоваяКоманда.Пояснение = "";
	НоваяКоманда.Картинка = ирКэш.КартинкаИнструментаЛкс("Обработка.ирПлатформа.Форма.СтруктураФормы");
	НоваяКоманда.Параметр = "форма";
	
	Если СтараяТекущаяКоманда <> Неопределено Тогда
		НоваяТекущаяКоманда = Команды.Найти(СтараяТекущаяКоманда, "Имя");
	КонецЕсли; 
	Если НоваяТекущаяКоманда = Неопределено Тогда
		НоваяТекущаяКоманда = Команды[0];
	КонецЕсли; 
	ЭлементыФормы.Команды.ТекущаяСтрока = НоваяТекущаяКоманда;

КонецПроцедуры

Процедура ОсновныеДействияФормыОК(Кнопка = Неопределено)
	
	ЗакрытьФорму();
	//Выполнить(ЭлементыФормы.Команды.ТекущаяСтрока.Значение + "()"); // Так окно откроется в режиме блокирования владельца
	ирОбщий.ПодключитьГлобальныйОбработчикОжиданияЛкс(ЭлементыФормы.Команды.ТекущаяСтрока.Имя,, Истина);
	
КонецПроцедуры

Процедура ЗакрытьФорму()
	ВыбраннаяГлобальнаяКоманда = ЭлементыФормы.Команды.ТекущаяСтрока.Имя;
	ирОбщий.СохранитьЗначениеЛкс("ВыбраннаяГлобальнаяКоманда", ВыбраннаяГлобальнаяКоманда);
	Закрыть(ВыбраннаяГлобальнаяКоманда);
КонецПроцедуры

Процедура КомандыВыбор(Элемент, ЭлементСписка)
	
	ОсновныеДействияФормыОК();
	
КонецПроцедуры

Процедура ОтложенноеВыполнениеПриИзменении(Элемент)
	
	ОбновитьДоступныеКоманды();
	
КонецПроцедуры

Процедура ОсновныеДействияФормыВыполнитьОтложенно(Кнопка)
	
	ЗакрытьФорму();
	ирОбщий.ПодключитьГлобальныйОбработчикОжиданияЛкс("ОткрытьВыборГлобальнойКомандыЛкс", 4, Истина);

КонецПроцедуры

Процедура КомандыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ОформлениеСтроки.Ячейки.Параметр.УстановитьКартинку(ДанныеСтроки.Картинка);
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.ВыборГлобальнойКоманды", Ложь);
Команды.Колонки.Добавить("Картинка");