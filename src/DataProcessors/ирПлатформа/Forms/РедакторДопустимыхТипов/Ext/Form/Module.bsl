﻿Перем мСоответствиеСтруктурТипа;

Функция ПолучитьОтобранныеСтрокиТаблицы() Экспорт

	ВременныйПостроительЗапроса = Новый ПостроительЗапроса;
	ВременныйПостроительЗапроса.ИсточникДанных = Новый ОписаниеИсточникаДанных(ТаблицаТипов);
	ирОбщий.СкопироватьОтборПостроителяЛкс(ВременныйПостроительЗапроса.Отбор, ЭлементыФормы.ТаблицаТипов.ОтборСтрок);
	ВременныйПостроительЗапроса.ВыбранныеПоля.Добавить("Имя");
	ВременныйПостроительЗапроса.Выполнить();
	Результат = ВременныйПостроительЗапроса.Результат.Выгрузить();
	Возврат Результат;

КонецФункции // ПолучитьОтобранныеСтрокиТаблицы()

Функция ПолучитьПомеченныеСтрокиТаблицы() Экспорт

	ВременныйПостроительЗапроса = Новый ПостроительЗапроса;
	ВременныйПостроительЗапроса.ИсточникДанных = Новый ОписаниеИсточникаДанных(ТаблицаТипов);
	ВременныйПостроительЗапроса.Отбор.Добавить("Пометка").Установить(Истина);
	ВременныйПостроительЗапроса.ВыбранныеПоля.Добавить("Имя");
	ВременныйПостроительЗапроса.Выполнить();
	Результат = ВременныйПостроительЗапроса.Результат.Выгрузить();
	Возврат Результат;

КонецФункции

Процедура УстановитьСнятьПометка(Признак, ИзменятьМодифицированность = Истина)
	
	Если ИзменятьМодифицированность Тогда 
		Модифицированность = Истина;
	КонецЕсли;
	ВременнаяТаблица = ПолучитьОтобранныеСтрокиТаблицы();
	Для каждого ВременнаяСтрока Из ВременнаяТаблица Цикл
		СтрокаТипа = ТаблицаТипов.Найти(ВременнаяСтрока.Имя);
		ирОбщий.ПрисвоитьЕслиНеРавноЛкс(СтрокаТипа.Пометка, Признак);
		СтрокаДереваТипов = ДеревоТипов.Строки.Найти(СтрокаТипа.Имя, "Имя", Истина);
		ирОбщий.ПрисвоитьЕслиНеРавноЛкс(СтрокаДереваТипов.Пометка, Признак);
	КонецЦикла;
	ЭлементыФормы.ТаблицаТипов.ОбновитьСтроки();
	
КонецПроцедуры

Процедура УстановитьПометкуДерева(СтрокиДереваТипов, Признак)

	Для каждого СтрокаДереваТипа Из СтрокиДереваТипов Цикл
		ирОбщий.ПрисвоитьЕслиНеРавноЛкс(СтрокаДереваТипа.Пометка, Признак);
		УстановитьПометкуДерева(СтрокаДереваТипа.Строки, Признак);
	КонецЦикла;

КонецПроцедуры // УстановитьСПометкуДерева()

Процедура ЗакрытьССохранением()

	ВыбранныеСтроки = ДеревоТипов.Строки.НайтиСтроки(Новый Структура("Пометка", Истина), Истина);
	СтрокаСериализованныхТипов = "";
	ТаблицаСтруктурТипов = НоваяТаблицаСтруктурТипа();
	Для Каждого ВыбраннаяСтрока Из ВыбранныеСтроки Цикл
		СтруктураТипа = ТаблицаСтруктурТипов.Добавить();
		Если ВыбраннаяСтрока.СтруктураТипа <> Неопределено Тогда
			ЗаполнитьЗначенияСвойств(СтруктураТипа, ВыбраннаяСтрока.СтруктураТипа);
		Иначе
			СтруктураТипа.ИмяОбщегоТипа = ВыбраннаяСтрока.Имя;
		КонецЕсли; 
	КонецЦикла;
	СтруктураТипаСтроки = ТаблицаСтруктурТипов.Найти("Строка", "ИмяОбщегоТипа");
	Если СтруктураТипаСтроки <> Неопределено Тогда
		СтруктураТипаСтроки.Метаданные = Новый КвалификаторыСтроки(ДлинаСтроки, 
			?(Фиксированная, ДопустимаяДлина.Фиксированная, ДопустимаяДлина.Переменная));
	КонецЕсли; 
	СтруктураТипаЧисла = ТаблицаСтруктурТипов.Найти("Число", "ИмяОбщегоТипа");
	Если СтруктураТипаЧисла <> Неопределено Тогда
		СтруктураТипаЧисла.Метаданные = Новый КвалификаторыЧисла(Разрядность, РазрядностьДробнойЧасти, 
			?(Неотрицательное, ДопустимыйЗнак.Неотрицательный, ДопустимыйЗнак.Любой));
	КонецЕсли; 
	СтруктураТипаДаты = ТаблицаСтруктурТипов.Найти("Дата", "ИмяОбщегоТипа");
	Если СтруктураТипаДаты <> Неопределено Тогда
		СтруктураТипаДаты.Метаданные = Новый КвалификаторыДаты(СоставДаты);
	КонецЕсли; 
	ДопустимыеТипы = ДопустимыеТипыИзТаблицыСтруктурТипа(ТаблицаСтруктурТипов);
	Модифицированность = Ложь;
	Закрыть(Истина);

КонецПроцедуры // ЗакрытьССохранением()

Процедура КнопкаОКНажатие(Кнопка)
	
	ЗакрытьССохранением();

КонецПроцедуры

Процедура КоманднаяПанельФормаУстановитьФлажки(Кнопка)
	
	УстановитьСнятьПометка(Истина);

КонецПроцедуры

Процедура КоманднаяПанельФормаСнятьФлажки(Кнопка)
	
	УстановитьСнятьПометка(Ложь);
	
КонецПроцедуры

Процедура КоманднаяПанельТиповДерево(Кнопка)

	Кнопка.Пометка = Не Кнопка.Пометка;
	Если Кнопка.Пометка Тогда 
		КнопкаТолькоВыбранные = ЭлементыФормы.КоманднаяПанельТипов.Кнопки.ТолькоВыбранные;
		Если КнопкаТолькоВыбранные.Пометка Тогда
			КоманднаяПанельТиповТолькоВыбранные(КнопкаТолькоВыбранные);
		КонецЕсли;
		Если ЭлементыФормы.ТаблицаТипов.ТекущаяСтрока <> Неопределено Тогда
			ТекущееИмя = ЭлементыФормы.ТаблицаТипов.ТекущаяСтрока.Имя;
			ЭлементыФормы.ДеревоТипов.ТекущаяСтрока = ДеревоТипов.Строки.Найти(ТекущееИмя, "Имя", Истина);
		КонецЕсли;
		ЭлементыФормы.ОсновнаяПанель.ТекущаяСтраница = ЭлементыФормы.ОсновнаяПанель.Страницы.Дерево;
	Иначе
		Если ЭлементыФормы.ДеревоТипов.ТекущаяСтрока <> Неопределено Тогда
			ТекущееИмя = ЭлементыФормы.ДеревоТипов.ТекущаяСтрока.Имя;
			ЭлементыФормы.ТаблицаТипов.ТекущаяСтрока = ТаблицаТипов.Найти(ТекущееИмя, "Имя");
		КонецЕсли;
		ЭлементыФормы.ОсновнаяПанель.ТекущаяСтраница = ЭлементыФормы.ОсновнаяПанель.Страницы.Таблица;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ирКлиент.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ЭтаФорма.ЭлементыФормы.КоманднаяПанельТипов.Кнопки.Открыть.Доступность = ирКэш.Получить().Это2iS;

	ИнициализироватьДеревоТипов();
	фДеревоТипов = ДеревоТипов;
	СброситьПометкиУПомеченных();
	ТаблицаСтруктурТипов = ПолучитьТаблицуСтруктурТиповИзДопустимыхТипов(ДопустимыеТипы);
	ИзмененСоставСтрок = Ложь;
	Для Каждого СтруктураТипа Из ТаблицаСтруктурТипов Цикл
		КонкретныйТип = ИмяТипаИзСтруктурыТипа(СтруктураТипа);
		СтрокаДереваТипов = ДеревоТипов.Строки.Найти(КонкретныйТип, "Имя", Истина);
		Если СтрокаДереваТипов = Неопределено Тогда
			МассивФрагментов = ирОбщий.СтрРазделитьЛкс(КонкретныйТип);
			ТекущееИмя = "";
			СтрокаДереваТипов = ДеревоТипов;
			ТекущаяСтруктураТипа = НоваяСтруктураТипа();
			Для Каждого Фрагмент Из МассивФрагментов Цикл
				Если ТекущееИмя <> "" Тогда
					ТекущееИмя = ТекущееИмя + ".";
				КонецЕсли; 
				ТекущееИмя = ТекущееИмя + Фрагмент;
				лСтрокаДерева = СтрокаДереваТипов.Строки.Найти(ТекущееИмя, "Имя");
				Если лСтрокаДерева = Неопределено Тогда
					лСтрокаДерева = СтрокаДереваТипов.Строки.Добавить();
					лСтрокаДерева.Имя = ТекущееИмя;
					Если СтрокаДереваТипов.Родитель <> Неопределено Тогда
						ОбработатьСтрокиДереваТипов(СтрокаДереваТипов.Строки, ТекущаяСтруктураТипа);
					КонецЕсли; 
					ИзмененСоставСтрок = Истина;
				КонецЕсли; 
				СтрокаДереваТипов = лСтрокаДерева;
				ТекущаяСтруктураТипа = лСтрокаДерева.СтруктураТипа;
			КонецЦикла;
			Если СтрокаДереваТипов = Неопределено Тогда
				Продолжить;
			КонецЕсли; 
		КонецЕсли;
		СтрокаДереваТипов.Пометка = Истина;
		СтрокаТаблицыТипов = ТаблицаТипов.Найти(КонкретныйТип, "Имя");
		Если СтрокаТаблицыТипов <> Неопределено Тогда
			СтрокаТаблицыТипов.Пометка = Истина;
		КонецЕсли;
	КонецЦикла;
	Если ИзмененСоставСтрок Тогда 
		ДеревоТипов.Строки.Сортировать("Имя", Истина);
		ТаблицаТипов.Сортировать("Имя"); // Нужно в случае добавления неизвестных типов 
	КонецЕсли; 
	СтруктураТипаСтроки = ТаблицаСтруктурТипов.Найти("Строка", "ИмяОбщегоТипа");
	Если СтруктураТипаСтроки <> Неопределено Тогда
		Если ТипЗнч(СтруктураТипаСтроки.Метаданные) = Тип("КвалификаторыСтроки") Тогда
			Квалификаторы = СтруктураТипаСтроки.Метаданные;
			ДлинаСтроки = Квалификаторы.Длина;
			Фиксированная = Квалификаторы.ДопустимаяДлина = ДопустимаяДлина.Фиксированная;
		КонецЕсли; 
	КонецЕсли; 
	СтруктураТипаЧисла = ТаблицаСтруктурТипов.Найти("Число", "ИмяОбщегоТипа");
	Если СтруктураТипаЧисла <> Неопределено Тогда
		Если ТипЗнч(СтруктураТипаЧисла.Метаданные) = Тип("КвалификаторыЧисла") Тогда
			Квалификаторы = СтруктураТипаЧисла.Метаданные;
			Разрядность = Квалификаторы.Разрядность;
			РазрядностьДробнойЧасти = Квалификаторы.РазрядностьДробнойЧасти;
			Неотрицательное = Квалификаторы.ДопустимыйЗнак = ДопустимыйЗнак.Неотрицательный;
		КонецЕсли; 
	КонецЕсли; 
	СтруктураТипаДаты = ТаблицаСтруктурТипов.Найти("Дата", "ИмяОбщегоТипа");
	Если СтруктураТипаДаты <> Неопределено Тогда
		Если ТипЗнч(СтруктураТипаДаты.Метаданные) = Тип("КвалификаторыДаты") Тогда
			Квалификаторы = СтруктураТипаДаты.Метаданные;
			СоставДаты = Квалификаторы.ЧастиДаты;
		КонецЕсли; 
	КонецЕсли; 
	
	ЭлементыФормы.ТаблицаТипов.ОтборСтрок.Пометка.Значение = Истина;
	РазрешитьСоставнойТип = Истина;
	Если ТаблицаСтруктурТипов.Количество() > 0 Тогда
		КоманднаяПанельТиповТолькоВыбранные(ЭлементыФормы.КоманднаяПанельТипов.Кнопки.ТолькоВыбранные);
		Если ТаблицаСтруктурТипов.Количество() = 1 Тогда
			РазрешитьСоставнойТип = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	ЭлементОтбораИмя = ЭлементыФормы.ТаблицаТипов.ОтборСтрок.Имя;
	ЭлементОтбораИмя.ВидСравнения = ВидСравнения.Содержит;
	ЭлементОтбораИмя.Использование = Истина; 

КонецПроцедуры

Процедура КоманднаяПанельТиповТолькоВыбранные(Кнопка)
	
	Кнопка.Пометка = Не Кнопка.Пометка;
	ЭлементыФормы.ТаблицаТипов.ОтборСтрок.Пометка.Использование = Кнопка.Пометка;
	Если Кнопка.Пометка Тогда
		КнопкаДерево = ЭлементыФормы.КоманднаяПанельТипов.Кнопки.Дерево;
		Если КнопкаДерево.Пометка Тогда
			КоманднаяПанельТиповДерево(КнопкаДерево);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ТаблицаТиповПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	//Попытка
	//	// В некоторых случаях долго выполняется. Поддержка системы 2iS
	//	ОформлениеСтроки.Ячейки.Имя.УстановитьКартинку(Вычислить("ПолучитьНастройкуКартинки(глПолучитьПиктограммуСсылочногоОбъекта(ПолучитьСсылкуТипа(ДанныеСтроки)))"));
	//Исключение
		ОформлениеСтроки.Ячейки.Имя.ОтображатьКартинку = Истина;
		ОформлениеСтроки.Ячейки.Имя.ИндексКартинки = ДанныеСтроки.ИндексКартинки;
	//КонецПопытки;
	
	//Если Найти(ДанныеСтроки.Имя, "<Имя табличной части>") > 0 Тогда
	//	ОформлениеСтроки.Ячейки.Имя.ОтображатьФлажок = Ложь;
	//КонецЕсли;
	
КонецПроцедуры

Процедура ДеревоТиповПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт

	//Попытка
	//	// В некоторых случаях долго выполняется. Поддержка системы 2iS
	//	ОформлениеСтроки.Ячейки.Имя.УстановитьКартинку(Вычислить("ПолучитьНастройкуКартинки(глПолучитьПиктограммуСсылочногоОбъекта(глКэш.СсылкиОбъектовСистемыПоОбщемуТипу[ДанныеСтроки.Имя]))"));
	//Исключение
		ОформлениеСтроки.Ячейки.Имя.ОтображатьКартинку = Истина;
		ОформлениеСтроки.Ячейки.Имя.ИндексКартинки = ДанныеСтроки.ИндексКартинки;
	//КонецПопытки;
	
	Если Найти(ДанныеСтроки.Имя, "<Имя табличной части>") > 0 Тогда
		ОформлениеСтроки.Ячейки.Имя.ОтображатьФлажок = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ДеревоТиповПриИзмененииФлажка(Элемент, Колонка)

	НоваяПометка = Элемент.ТекущаяСтрока.Пометка;
	Если Не РазрешитьСоставнойТип Тогда
		СброситьПометкиУПомеченных();
	КонецЕсли;
	Элемент.ТекущаяСтрока.Пометка = НоваяПометка;
	Элемент.ТекущаяСтрока.Пометка = НоваяПометка;
	СтрокаТаблицыТипов = ТаблицаТипов.Найти(Элемент.ТекущаяСтрока.Имя, "Имя");
	СтрокаТаблицыТипов.Пометка = НоваяПометка;
	
КонецПроцедуры

Процедура ТаблицаТиповПриИзмененииФлажка(Элемент, Колонка)

	ТекущаяСтрока = Элемент.ТекущаяСтрока;
	НоваяПометка = ТекущаяСтрока.Пометка;
	Если Не РазрешитьСоставнойТип Тогда
		СброситьПометкиУПомеченных();
	КонецЕсли;
	ТекущаяСтрока.Пометка = НоваяПометка;
	Элемент.ТекущаяСтрока = ТекущаяСтрока;
	СтрокаДереваТипов = ДеревоТипов.Строки.Найти(Элемент.ТекущаяСтрока.Имя, "Имя", Истина);
	СтрокаДереваТипов.Пометка = НоваяПометка;
	
КонецПроцедуры

// <Описание функции>
//
// Параметры:
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>;
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>.
//
// Возвращаемое значение:
//               - <Тип.Вид> - <описание значения>
//                 <продолжение описания значения>;
//  <Значение2>  - <Тип.Вид> - <описание значения>
//                 <продолжение описания значения>.
//
Функция ОпределитьТекущуюСтроку()


	
КонецФункции // ОпределитьТекущуюСтроку()

Процедура КоманднаяПанельДереваСправка(Кнопка)
	
	Если ЭлементыФормы.ОсновнаяПанель.ТекущаяСтраница = ЭлементыФормы.ОсновнаяПанель.Страницы.Дерево Тогда
		ТекущаяСтрока = ЭлементыФормы.ДеревоТипов.ТекущаяСтрока;
	Иначе//Если ЭлементыФормы.ОсновнаяПанель.ТекущаяСтраница = ЭлементыФормы.ОсновнаяПанель.Страницы.Таблица Тогда
		ТекущаяСтрока = ЭлементыФормы.ТаблицаТипов.ТекущаяСтрока;
	КонецЕсли;
	
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	СтрокаОбщегоТипа = ТаблицаОбщихТипов.Найти(ТекущаяСтрока.Имя);
	Если СтрокаОбщегоТипа = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ирКлиент.ОткрытьСтраницуСинтаксПомощникаЛкс(СтрокаОбщегоТипа.ПутьКОписанию, , ЭтаФорма);

КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Ответ = ирКлиент.ЗапроситьСохранениеДанныхФормыЛкс(ЭтаФорма, Отказ);
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Закрыть(Ложь);
	ИначеЕсли Ответ = КодВозвратаДиалога.Да Тогда
		ЗакрытьССохранением();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОчиститьФильтрНажатие(Элемент)
	
	ЭлементыФормы.ТаблицаТипов.ОтборСтрок.Имя.Значение = "";
	
КонецПроцедуры

Процедура СброситьПометкиУПомеченных(ВременнаяТаблица = Неопределено)

	Если ВременнаяТаблица = Неопределено Тогда
		ВременнаяТаблица = ПолучитьПомеченныеСтрокиТаблицы();
	КонецЕсли;
	Признак = Ложь;
	Для каждого ВременнаяСтрока Из ВременнаяТаблица Цикл
		СтрокаТипа = ТаблицаТипов.Найти(ВременнаяСтрока.Имя);
		СтрокаТипа.Пометка = Признак;
		СтрокаДереваТипов = ДеревоТипов.Строки.Найти(СтрокаТипа.Имя, "Имя", Истина);
		СтрокаДереваТипов.Пометка = Признак;
	КонецЦикла;
	// Антибаг платформы 8.2.15. Непомеченные строки лишались текста в колонке "Представление" при выводе строки
	// http://partners.v8.1c.ru/forum/thread.jsp?id=1016721#1016721
	ЭлементыФормы.ТаблицаТипов.ОбновитьСтроки();

КонецПроцедуры // СброситьПометкиУПомеченных()


Процедура РазрешитьСоставнойТипПриИзменении(Элемент)
	
	Если Не РазрешитьСоставнойТип Тогда
		ВременнаяТаблица = ПолучитьПомеченныеСтрокиТаблицы();
		Если ВременнаяТаблица.Количество() > 1 Тогда
			ВременнаяТаблица.Удалить(0);
			СброситьПометкиУПомеченных(ВременнаяТаблица);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПолеОтбораПоПодстрокеKeyDown(Элемент, KeyCode, Shift)
	
	Если Shift Тогда 
		Если KeyCode.Value = 16 Тогда // F4
			ЭлементыФормы.ТаблицаТипов.ОтборСтрок.Имя.Значение = "";
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Процедура ТаблицаТиповВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ВыбраннаяСтрока.Пометка = Истина;
	ТаблицаТиповПриИзмененииФлажка(Элемент, Колонка);
	ЗакрытьССохранением();
	
КонецПроцедуры

Процедура ДеревоТиповВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)

	ВыбраннаяСтрока.Пометка = Истина;
	ДеревоТиповПриИзмененииФлажка(Элемент, Колонка);
	ЗакрытьССохранением();
	
КонецПроцедуры

Процедура ПолеВвода1ПриИзменении(Элемент)
	
	ирКлиент.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
	
	КнопкаФильтра = ЭтаФорма.ЭлементыФормы.КоманднаяПанельТипов.Кнопки.ТолькоВыбранные;
	Если КнопкаФильтра.Пометка Тогда
		КоманднаяПанельТиповТолькоВыбранные(ЭтаФорма.ЭлементыФормы.КоманднаяПанельТипов.Кнопки.ТолькоВыбранные);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПолеВвода1НачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_ОбновитьСписокЛкс(Элемент, ЭтаФорма);
	
КонецПроцедуры

Процедура ТаблицаТиповПриАктивизацииСтроки(Элемент)
	
	Если Истина
		И Элемент.ТекущиеДанные <> Неопределено
		И (Ложь
			Или Элемент.ТекущиеДанные.Имя = "Строка"
			Или Элемент.ТекущиеДанные.Имя = "Дата"
			Или Элемент.ТекущиеДанные.Имя = "Число")
	Тогда
		ИмяСтраницы = Элемент.ТекущиеДанные.Имя;
		ЭлементыФормы.ПанельКвалификаторов.ТекущаяСтраница = ЭлементыФормы.ПанельКвалификаторов.Страницы[ИмяСтраницы];
		ЭлементыФормы.ПанельКвалификаторов.Видимость = Истина;
	Иначе
		ЭлементыФормы.ПанельКвалификаторов.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура НеограниченнаяПриИзменении(Элемент)
	
	Если Элемент.Значение Тогда
		ДлинаСтроки = 0;
	КонецЕсли; 
	ЭлементыФормы.ДлинаСтроки.Доступность = Не Элемент.Значение;
	УстановитьПометкуВТекущейСтроке();
	
КонецПроцедуры

Процедура СоставДатыПриИзменении(Элемент)
	
	УстановитьПометкуВТекущейСтроке();

КонецПроцедуры

// <Описание процедуры>
//
// Параметры:
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>;
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>.
//
Процедура УстановитьПометкуВТекущейСтроке()

	Если ЭлементыФормы.ОсновнаяПанель.ТекущаяСтраница = ЭлементыФормы.ОсновнаяПанель.Страницы.Дерево Тогда
		Если ЭлементыФормы.ДеревоТипов.ТекущаяСтрока <> Неопределено Тогда
			ЭлементыФормы.ДеревоТипов.ТекущаяСтрока.Пометка = Истина;
			ДеревоТиповПриИзмененииФлажка(ЭлементыФормы.ДеревоТипов,);
		КонецЕсли; 
	Иначе
		Если ЭлементыФормы.ТаблицаТипов.ТекущаяСтрока <> Неопределено Тогда
			ЭлементыФормы.ТаблицаТипов.ТекущаяСтрока.Пометка = Истина;
			ТаблицаТиповПриИзмененииФлажка(ЭлементыФормы.ТаблицаТипов,);
		КонецЕсли; 
	КонецЕсли;

КонецПроцедуры // УстановитьПометкуВТекущейСтроке()

Процедура РазрядностьПриИзменении(Элемент)
	
	УстановитьПометкуВТекущейСтроке();
	
КонецПроцедуры

Процедура РазрядностьДробнойЧастиПриИзменении(Элемент)
	
	УстановитьПометкуВТекущейСтроке();

КонецПроцедуры

Процедура НеотрицательноеПриИзменении(Элемент)
	
	УстановитьПометкуВТекущейСтроке();
	
КонецПроцедуры

Процедура ДлинаСтрокиПриИзменении(Элемент)
	
	УстановитьПометкуВТекущейСтроке();
	
КонецПроцедуры

Процедура ФиксированнаяПриИзменении(Элемент)
	
	УстановитьПометкуВТекущейСтроке();
	
КонецПроцедуры

Процедура ДобавитьCOMБиблиотекуНажатие(Элемент)
	
	ИмяБиблиотеки = "";
	Если Не ВвестиСтроку(ИмяБиблиотеки, "Введите имя библиотеки") Тогда
		Возврат;
	КонецЕсли;
	СтрокаCOMОбъекта = ДеревоТипов.Строки.Найти("COMОбъект", "Имя");
	ПрефиксИмени = "COMОбъект.{" + ИмяБиблиотеки + "}";
	СтрокаБиблиотеки = СтрокаCOMОбъекта.Строки.Найти(ПрефиксИмени, "Имя");
	Если СтрокаБиблиотеки = Неопределено Тогда
		СтрокаБиблиотеки = СтрокаCOMОбъекта.Строки.Добавить();
		СтрокаБиблиотеки.Имя = ПрефиксИмени;
		ОбработатьСтрокиДереваТипов(СтрокаCOMОбъекта.Строки, СтрокаCOMОбъекта.СтруктураТипа);
	Иначе
		//СтрокаБиблиотеки.Строки.Очистить();
		// Еще нужно удалять строки из таблицы
		Возврат;
	КонецЕсли; 
	ПолучитьCOMНавигатор();
	Если COMНавигатор = "Отказ" Тогда
		Возврат;
	КонецЕсли;
	Попытка
		COMОбъект = Новый COMОбъект(ИмяБиблиотеки);
	Исключение
		Сообщить("Библиотека не найдена", СтатусСообщения.Внимание);
		Возврат;
	КонецПопытки;
	ТипыБиблиотеки = COMНавигатор.InterfaceInfoFromObject(COMОбъект).Parent.Interfaces;
	Для Каждого ТипБиблиотеки Из ТипыБиблиотеки Цикл
		СтрокаТипаБиблиотеки = СтрокаБиблиотеки.Строки.Добавить();
		СтрокаТипаБиблиотеки.Имя = СтрокаБиблиотеки.Имя + "." + ТипБиблиотеки.Name;
	КонецЦикла;
	ОбработатьСтрокиДереваТипов(СтрокаБиблиотеки.Строки, СтрокаCOMОбъекта.СтруктураТипа);
	СтрокаБиблиотеки.Строки.Сортировать("Имя", Истина);
	//ТаблицаТипов.Сортировать("Имя"); // Если включать, то надо еще и сдвиг важных типов наверх доделать
	Если ЭлементыФормы.ОсновнаяПанель.ТекущаяСтраница = ЭлементыФормы.ОсновнаяПанель.Страницы.Таблица Тогда 
		ЭлементыФормы.ДеревоТипов.ТекущаяСтрока = СтрокаБиблиотеки;
	Иначе
		СтрокаТаблицы = ТаблицаТипов.Найти(СтрокаБиблиотеки.Имя, "Имя");
		Попытка
			ЭлементыФормы.ТаблицаТипов.ТекущаяСтрока = СтрокаТаблицы;
		Исключение
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьСсылкуТипа(ДанныеСтроки = Неопределено)

	Если ДанныеСтроки = Неопределено Тогда
		Если ЭлементыФормы.ОсновнаяПанель.ТекущаяСтраница = ЭлементыФормы.ОсновнаяПанель.Страницы.Дерево Тогда
			ТабличноеПоле = ЭлементыФормы.ДеревоТипов;
		Иначе
			ТабличноеПоле = ЭлементыФормы.ТаблицаТипов;
		КонецЕсли;
		ДанныеСтроки = ТабличноеПоле.ТекущаяСтрока;
	КонецЕсли; 
	Если ДанныеСтроки = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	ИмяТипа = ДанныеСтроки.Имя;
	
	ОбъектСистемы = Вычислить("глКэш.СсылкиОбъектовСистемыПоОбщемуТипу[ИмяТипа]");
	Если ЗначениеЗаполнено(ОбъектСистемы) Тогда
		Возврат ОбъектСистемы;
	КонецЕсли; 
	Попытка
		Тип = Тип(ИмяТипа);
	Исключение
		Возврат Неопределено;
	КонецПопытки; 
	ДопМетаданные = Вычислить("глПолучитьМетаданныеТипа(Тип)");
	Если Истина
		И ДопМетаданные <> Неопределено
		И ЗначениеЗаполнено(ДопМетаданные.СсылкаОбъектаМД) 
	Тогда
		Возврат ДопМетаданные.СсылкаОбъектаМД;
	КонецЕсли; 
	Возврат Неопределено;

КонецФункции // ПолучитьСсылкуТипа()

Процедура КоманднаяПанельТиповОткрыть(Кнопка)
	
	СсылкаТипа = ПолучитьСсылкуТипа();
	Если ЗначениеЗаполнено(СсылкаТипа) Тогда
		ОткрытьЗначение(СсылкаТипа);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	ирКлиент.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура ОсновныеДействияФормыСтруктураФормы(Кнопка)
	
	ирКлиент.ОткрытьСтруктуруФормыЛкс(ЭтаФорма);

КонецПроцедуры

Процедура ПриЗакрытии()
	ирКлиент.Форма_ПриЗакрытииЛкс(ЭтаФорма);
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирКлиент.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирКлиент.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.РедакторДопустимыхТипов");

СписокВыбора = ЭлементыФормы.СоставДаты.СписокВыбора;
СписокВыбора.Добавить(ЧастиДаты.Время);
СписокВыбора.Добавить(ЧастиДаты.Дата);
СписокВыбора.Добавить(ЧастиДаты.ДатаВремя);
СоставДаты = ЧастиДаты.ДатаВремя;