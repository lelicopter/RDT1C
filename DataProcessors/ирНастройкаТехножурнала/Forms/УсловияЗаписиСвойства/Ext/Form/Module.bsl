﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ, ВЫЗЫВАЕМЫЕ ИЗ ОБРАБОТЧИКОВ ЭЛЕМЕНТОВ ФОРМЫ

// Инициализация формы при октрытии
//
Процедура ПриОткрытии()
	
	Если Не ПустаяСтрока(ИмяСвойства) Тогда
		ЭлементыФормы.ВыборИмениСвойства.Значение = НРег(ЗаменитьСимвол(ИмяСвойства, ":", "_"));
	КонецЕсли;
	
	Если РедактированиеУсловийСвойства.Колонки.Найти("Значение") = Неопределено Тогда
		РедактированиеУсловийСвойства.Колонки.Добавить("Значение", Новый ОписаниеТипов("Строка"), "Значение"); 
	КонецЕсли;                        
	Если ЗначениеЗаполнено(ТекущееСвойство) Тогда
		ТабличноеПоле = ЭлементыФормы.РедактированиеУсловийСвойства;
		ТекущаяСтрока = ТабличноеПоле.Значение.Найти(ТекущееСвойство, "Свойство");
		Если ТекущаяСтрока <> Неопределено Тогда
			ТабличноеПоле.ТекущаяСтрока = ТекущаяСтрока;
			ТабличноеПоле.ТекущаяКолонка = ТабличноеПоле.Колонки.Значение;
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

// Закрыть форму с признаком "оотменить изменения"
//
Процедура КнопкаОКНажатие(Элемент)
	
	Если ВыборИмениСвойства = Неопределено Или СокрЛП(ВыборИмениСвойства) = "" Тогда
		Предупреждение("Имя свойства не выбрано!");
		Возврат;
	КонецЕсли;
	
	ЭтаФорма.Закрыть("ОК");
	
КонецПроцедуры

// Инициализация формы
//
Процедура КнопкаОтменаНажатие(Элемент)

	ЭтаФорма.Закрыть("Отмена");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ
 
// Процедура обработки события начала редактирования
//
Процедура РедактированиеУсловийСвойстваПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)

	ПриНачалеРедактирования(ЭлементыФормы.РедактированиеУсловийСвойства, Элемент, НоваяСтрока, Копирование);
	
КонецПроцедуры

// Процедура обработки события показа строки
//
Процедура РедактированиеУсловийСвойстваПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)

	ПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки);
	
КонецПроцедуры

// Процедура обработки события изменения данных
//
Процедура РедактированиеУсловийСвойстваСвойствоПриИзменении(Элемент)
	
	РедактированиеЗначения(ЭлементыФормы.РедактированиеУсловийСвойства, Элемент);
	
КонецПроцедуры

// Процедура обработки события выбора
//
Процедура РедактированиеУсловийСвойстваСвойствоОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СвойствоОбработкаВыбора(ЭлементыФормы.РедактированиеУсловийСвойства, Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

// Процедура обработки события НачалоВыбора
//
Процедура РедактированиеУсловийСвойстваЗначениеНачалоВыбора(Элемент, СтандартнаяОбработка)

	ЗначениеНачалоВыбора(ЭлементыФормы.РедактированиеУсловийСвойства, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

// Процедура обработки события окончания ввода данных
//
Процедура РедактированиеУсловийСвойстваЗначениеОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	Инд = РедактированиеУсловийСвойства.Индекс(ЭлементыФормы.РедактированиеУсловийСвойства.ТекущаяСтрока);
	Попытка
		РедактированиеУсловийСвойства.Получить(Инд).Значение = XMLСтрока(Число(Текст));
	Исключение
		РедактированиеУсловийСвойства.Получить(Инд).Значение = Текст;
	КонецПопытки;
	
КонецПроцедуры

ЭлементыФормы.РедактированиеУсловийСвойства.Колонки.Свойство.ЭлементУправления.СписокВыбора = ПолучитьСписокСвойствСобытий();
ЭлементыФормы.РедактированиеУсловийСвойства.Колонки.Сравнение.ЭлементУправления.СписокВыбора = ПолучитьСписокСравнения();
ЭлементыФормы.ВыборИмениСвойства.СписокВыбора = ПолучитьСписокИменСвойств();
	
