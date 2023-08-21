﻿Перем ПолеТела Экспорт;

// @@@.КЛАСС.ПолеТекстаПрограммы
Функция КлсПолеТекстаПрограммыОбновитьКонтекст(Знач Компонента = Неопределено, Знач Кнопка = Неопределено) Экспорт 
КонецФункции

// @@@.КЛАСС.ПолеТекстаПрограммы
// Транслятор обработки событий нажатия на кнопки командной панели в компоненту.
// Является обязательным.
//
// Параметры:
//  Кнопка       - КнопкаКоманднойПанели.
//
Процедура КлсПолеТекстаПрограммыНажатие(Кнопка)
	
	#Если Сервер И Не Сервер Тогда
	    ПолеТела = Обработки.ирКлсПолеТекстаПрограммы.Создать();
	#КонецЕсли
	РезультатНажатия = ПолеТела.Нажатие(Кнопка);
	
КонецПроцедуры

Функция СохраняемаяНастройкаФормы(выхНаименование, выхИменаСвойств) Экспорт 
	выхИменаСвойств = "Форма.ШиринаГенерируемогоТекста";
	Возврат Неопределено;
КонецФункции

Процедура ТаблицаПараметровПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ОформлениеСтроки.Ячейки.ЭтоРезультат.ТолькоПросмотр = ТипыВнешнихПереходов.Количество() > 0;
	ОформлениеСтроки.Ячейки.Выход.ТолькоПросмотр = Не ДанныеСтроки.Вход И ДанныеСтроки.ВыходОбязательно;
	Если ОформлениеСтроки.Ячейки.Выход.ТолькоПросмотр Тогда
		ирОбщий.ПрисвоитьЕслиНеРавноЛкс(ДанныеСтроки.Выход, Истина); // Возводится внутренний флаг измененности данных таблицы и затем снова вызывается перерисовка
	КонецЕсли;
	ОформлениеСтроки.Ячейки.Вход.ТолькоПросмотр = Ложь
		Или ДанныеСтроки.ВходОбязательно // Нужно для А=А+1;
		Или ДанныеСтроки.ВыходОбязательно
		Или ЧистыйКонтекст И ДанныеСтроки.СвойствоМодуля;
	//Если ОформлениеСтроки.Ячейки.Вход.ТолькоПросмотр Тогда
	//	ирОбщий.ПрисвоитьЕслиНеРавноЛкс(ДанныеСтроки.Вход, Истина); // Возводится внутренний флаг измененности данных таблицы и затем снова вызывается перерисовка
	//КонецЕсли;
	ОформлениеСтроки.Ячейки.Обязательный.ТолькоПросмотр = Не ДанныеСтроки.Вход И Не ДанныеСтроки.ВыходОбязательно;
	ирКлиент.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки,, "Значение");
	
КонецПроцедуры

Процедура ТаблицаПараметровПриАктивизацииСтроки(Элемент)
	
	ирКлиент.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ирКлиент.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ирКлиент.СоздатьМенеджерСохраненияНастроекФормыЛкс(ЭтаФорма);
	ПолеТела = ирОбщий.СоздатьОбъектПоИмениМетаданныхЛкс("Обработка.ирКлсПолеТекстаПрограммы");
	#Если Сервер И Не Сервер Тогда
	    ПолеТела = Обработки.ирКлсПолеТекстаПрограммы.Создать();
	#КонецЕсли
	ПолеТела.Инициализировать(, ЭтаФорма, ЭлементыФормы.ПолеТела,, Ложь, "ВыполнитьЛокально");
	ПолеТела.УдалитьЛевыеТабуляции(СтрЧислоВхождений(ТекстСмещения, Символы.Таб) - 1);
	Если ТипыВнешнихПереходов.Количество() = 0 Тогда
		ТаблицаПараметров.ЗагрузитьКолонку(ТаблицаПараметров.ВыгрузитьКолонку("Выход"), "ВыходОбязательно");
		ТаблицаПараметров.ЗагрузитьКолонку(ТаблицаПараметров.ВыгрузитьКолонку("Вход"), "ВходОбязательно");
		СтрокиРезультата = ТаблицаПараметров.НайтиСтроки(Новый Структура("Вход, Выход", Ложь, Истина));
		Если СтрокиРезультата.Количество() > 0 Тогда
			СтрокиРезультата[0].ЭтоРезультат = Истина;
		КонецЕсли; 
	КонецЕсли; 
	ТаблицаПараметров.Сортировать("Позиция, Вход Убыв, НИмя"); 
	СписокВыбора = ЭлементыФормы.ДирективаКомлиляции.СписокВыбора;
	СписокВыбора.Добавить("НаКлиенте");
	СписокВыбора.Добавить("НаСервере");
	СписокВыбора.Добавить("НаСервереБезКонтекста");
	СписокВыбора.Добавить("НаКлиентеНаСервереБезКонтекста"); 
	СписокВыбора = ЭлементыФормы.ТаблицаПараметров.Колонки.ТипЗначения.ЭлементУправления.СписокВыбора;
	СписокВыбора.Добавить("Число");
	СписокВыбора.Добавить("Строка");
	СписокВыбора.Добавить("Булево");
	Найденный = ирОбщий.ОтобратьКоллекциюЛкс(СписокВыбора, "НРег(Э.Значение)=П1", "Значение", НРег(ДирективаКомлиляции));
	Если Найденный.Количество() > 0 Тогда
		ЭтаФорма.ДирективаКомлиляции = Найденный[0];
	КонецЕсли; 
	ЭлементыФормы.ТаблицаПараметров.Колонки.ЭтоРезультат.ТолькоПросмотр = ЭтоВыражение;
	
КонецПроцедуры

Процедура ТаблицаПараметровПриИзмененииФлажка(Элемент, Колонка)
	
	ирКлиент.ТабличноеПолеПриИзмененииФлажкаЛкс(ЭтаФорма, Элемент, Колонка);
	
КонецПроцедуры

Процедура ДействияФормыПрименить(Кнопка)
	
	Если Не ЗначениеЗаполнено(Имя) Тогда
		Предупреждение("Укажите имя метода");
		ЭтаФорма.ТекущийЭлемент = ЭлементыФормы.Имя;
		Возврат;
	КонецЕсли;
	ОбновлениеОтображения(); // Иначе может не обновиться, если после редактирования поля ввода нажали CTRL+ENTER
	ЭтаФорма.ПолноеОпределение = НачалоОпределения + "	" + СокрЛП(ЭлементыФормы.ПолеТела.ПолучитьТекст()) + Символы.ПС + КонецОпределения;
	Закрыть(Истина);
	
КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	ТекстВозвратаРезультата = "";
	ТекстВставки = "";
	СтрокаПараметровВызова = "";
	СтрокаПараметровОпределения = "";
	Разделитель = ", ";
	#Если Сервер И Не Сервер Тогда
	    ПолеТела = Обработки.ирКлсПолеТекстаПрограммы.Создать();
	#КонецЕсли
	ПолеТела.Параметры.Очистить();
	Для Каждого СтрокаПараметра Из ТаблицаПараметров Цикл
		ПодачаНаВход = Ложь
			Или ЧистыйКонтекст И СтрокаПараметра.СвойствоМодуля И СтрокаПараметра.Обязательный
			Или СтрокаПараметра.Вход 
			Или СтрокаПараметра.Выход И Не СтрокаПараметра.ЭтоРезультат; 
		Если Ложь
			Или Не ПодачаНаВход
			//Или (Истина
			//	И СтрокаПараметра.ЭтоРезультат 
			//	И Не ПодачаНаВход)
		Тогда
			Продолжить;
		КонецЕсли; 
		ПараметрМетода = ПолеТела.Параметры.Добавить();
		ЗаполнитьЗначенияСвойств(ПараметрМетода, СтрокаПараметра);
		Если СтрДлина(СтрПолучитьСтроку(СтрокаПараметровВызова, СтрЧислоСтрок(СтрокаПараметровВызова))) > ШиринаГенерируемогоТекста Тогда
			СтрокаПараметровВызова = СтрокаПараметровВызова + Символы.ПС;
		КонецЕсли; 
		СтрокаПараметровВызова = СтрокаПараметровВызова + Разделитель;
		Если ПодачаНаВход Тогда
			СтрокаПараметровВызова = СтрокаПараметровВызова + СтрокаПараметра.Имя;
		КонецЕсли; 
		Если СтрДлина(СтрПолучитьСтроку(СтрокаПараметровОпределения, СтрЧислоСтрок(СтрокаПараметровОпределения))) > ШиринаГенерируемогоТекста Тогда
			СтрокаПараметровОпределения = СтрокаПараметровОпределения + Символы.ПС;
		КонецЕсли; 
		СтрокаПараметровОпределения = СтрокаПараметровОпределения + Разделитель;
		Если Не СтрокаПараметра.Выход Тогда
			СтрокаПараметровОпределения = СтрокаПараметровОпределения + "Знач ";
		КонецЕсли; 
		СтрокаПараметровОпределения = СтрокаПараметровОпределения + СтрокаПараметра.Имя;
		Если Не СтрокаПараметра.Обязательный Тогда
			СтрокаПараметровОпределения = СтрокаПараметровОпределения + " = " + ирОбщий.ПредставлениеЗначенияВоВстроенномЯзыкеЛкс(СтрокаПараметра.Значение);
		КонецЕсли; 
	КонецЦикла;
	СтрокаПараметровВызова = Сред(СтрокаПараметровВызова, СтрДлина(Разделитель) + 1);
	СтрокаПараметровОпределения = Сред(СтрокаПараметровОпределения, СтрДлина(Разделитель) + 1);
	СтрокаРезультата = ТаблицаПараметров.Найти(Истина, "ЭтоРезультат");
	Если ТипыВнешнихПереходов.Количество() > 0 Тогда
		КомментарийМетода = ПолеТела.СобратьКомментарийМетода(Описание);
	Иначе
		КомментарийМетода = ПолеТела.СобратьКомментарийМетода(Описание, СтрокаРезультата);
	КонецЕсли;
	ИмяПараметраВозврата = "ПараметрВозврата";
	Если ТипыВнешнихПереходов.Количество() > 0 Или СтрокаРезультата <> Неопределено Тогда
		НачалоОпределения = "Функция";
		КонецОпределения = "";
		ТекстВозвратаРезультата = "";
		Если ТипыВнешнихПереходов.Количество() > 0 Тогда
			Если ТипыВнешнихПереходов.Свойство("Возврат") Тогда
				ТекстВозвратаРезультата = ИмяПараметраВозврата + " = ";
			КонецЕсли; 
			КонецОпределения = Символы.Таб + "Возврат Неопределено;";
		Иначе
			Если Не ЭтоВыражение Тогда
				ТекстВозвратаРезультата = СтрокаРезультата.Имя + " = ";
			КонецЕсли; 
			КонецОпределения = Символы.Таб + "Возврат " + СтрокаРезультата.Имя + ";";
		КонецЕсли; 
		КонецОпределения = КонецОпределения + Символы.ПС + "КонецФункции";
	Иначе
		НачалоОпределения = "Процедура";
		КонецОпределения = "КонецПроцедуры";
	КонецЕсли;
	ТекстЭкспорт = "";
	Если ЛиЭкспорт Тогда
		ТекстЭкспорт = " Экспорт";
	КонецЕсли;
	ТекстАсинх = "";
	Если ЛиАсинх Тогда
		ТекстАсинх = "Асинх ";
	КонецЕсли; 
	ТекстДиректива = "";
	Если ЗначениеЗаполнено(ДирективаКомлиляции) Тогда
		ТекстДиректива = "&" + ДирективаКомлиляции + Символы.ПС;
	КонецЕсли;
	НачалоОпределения = ТекстДиректива + ТекстАсинх + НачалоОпределения + " " + Имя + "(" + СтрокаПараметровОпределения + ")" + ТекстЭкспорт + Символы.ПС;
	НачалоОпределения = КомментарийМетода + НачалоОпределения;
	ЭлементыФормы.ПолеНачала.УстановитьТекст(НачалоОпределения);
	КоличествоСтрок = ЭлементыФормы.ПолеНачала.КоличествоСтрок();
	ЭлементыФормы.ПолеНачала.УстановитьГраницыВыделения(КоличествоСтрок, 1, КоличествоСтрок, 1);
	ЭлементыФормы.ПолеКонца.УстановитьТекст(КонецОпределения);
	Для Каждого СтрокаПараметраВыхода Из ТаблицаПараметров.НайтиСтроки(Новый Структура("Вход, Выход, ЭтоРезультат", Ложь, Истина, Ложь)) Цикл
		ТекстВставки = ТекстВставки + ТекстСмещения + СтрокаПараметраВыхода.Имя + " = Неопределено;" + Символы.ПС;
	КонецЦикла;
	ТекстВставки = ТекстВставки + ТекстСмещения + ТекстВозвратаРезультата + Имя + "(" + СтрокаПараметровВызова + ")";
	Если Не ЭтоВыражение Тогда
		ТекстВставки = ТекстВставки + ";" + Символы.ПС;
	КонецЕсли;;
	ТекстУсловияПерехода = "";
	Для Каждого КлючИЗначение Из ТипыВнешнихПереходов Цикл
		ТекстУсловияПерехода = ТекстУсловияПерехода + ТекстСмещения;
		Если ЗначениеЗаполнено(ТекстУсловияПерехода) Тогда
			ТекстУсловияПерехода = ТекстУсловияПерехода + "Иначе";
		КонецЕсли; 
		ТекстУсловияПерехода = ТекстУсловияПерехода + "Если " + ИмяПараметраТипаВыхода + " = """ + КлючИЗначение.Ключ + """ Тогда" + Символы.ПС;
		ТекстУсловияПерехода = ТекстУсловияПерехода + ТекстСмещения + Символы.Таб + КлючИЗначение.Ключ;
		Если КлючИЗначение.Ключ = "Возврат" Тогда
			ТекстУсловияПерехода = ТекстУсловияПерехода + " " + ИмяПараметраВозврата;
		КонецЕсли; 
		ТекстУсловияПерехода = ТекстУсловияПерехода + ";" + Символы.ПС;
	КонецЦикла;
	Если ТекстУсловияПерехода <> "" Тогда
		ТекстУсловияПерехода = ТекстУсловияПерехода + ТекстСмещения + "КонецЕсли;" + Символы.ПС;
	КонецЕсли; 
	ТекстВставки = ТекстВставки + ТекстУсловияПерехода;
	ЭлементыФормы.ПолеВызова.УстановитьТекст(ТекстВставки);

КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка)
	
	ирКлиент.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);

КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирКлиент.Форма_ПриЗакрытииЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ТаблицаПараметровОписаниеНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ирКлиент.ПолеВводаРасширенногоЗначения_НачалоВыбораЛкс(Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирКлиент.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТаблицаПараметровЭтоРезультатПриИзменении(Элемент)
	
	Если Элемент.Значение Тогда
		ТаблицаПараметров.ЗаполнитьЗначения(Ложь, "ЭтоРезультат");
		ЭлементыФормы.ТаблицаПараметров.ТекущаяСтрока.ЭтоРезультат = Истина;
	КонецЕсли; 

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирКлиент.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	ирКлиент.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 
	
КонецПроцедуры

Процедура ТаблицаПараметровТипЗначенияНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	мПлатформа = ирКэш.Получить();
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	НеопознанныеТипы = Неопределено;
    ОписаниеТипов = ирОбщий.ОписаниеТиповИзТекстаЛкс(Элемент.Значение, НеопознанныеТипы);
	ДопустимыеТипы = мПлатформа.ДопустимыеТипыИзОписанияТипов(ОписаниеТипов);
	РезультатФормы = мПлатформа.РедактироватьДопустимыеТипы(ДопустимыеТипы);
	Если РезультатФормы <> Неопределено Тогда
		#Если Сервер И Не Сервер Тогда
			РезультатФормы = Новый ОписаниеТипов;
		#КонецЕсли
		Для Каждого Тип Из мПлатформа.ОписаниеТиповИзДопустимыхТипов(РезультатФормы).Типы() Цикл
			НеопознанныеТипы.Добавить(мПлатформа.ИмяТипаИзСтруктурыТипа(мПлатформа.СтруктураТипаИзКонкретногоТипа(Тип)));
		КонецЦикла;
		СтрокаТипов = ирОбщий.СтрСоединитьЛкс(НеопознанныеТипы, ", ");
		ирКлиент.ИнтерактивноЗаписатьВКолонкуТабличногоПоляЛкс(ЭлементыФормы.ТаблицаПараметров, ЭлементыФормы.ТаблицаПараметров.Колонки.ТипЗначения, СтрокаТипов);
	КонецЕсли; 

КонецПроцедуры

Процедура ТаблицаПараметровЗначениеПриИзменении(Элемент)
	
	ЭлементыФормы.ТаблицаПараметров.ТекущаяСтрока.Обязательный = Ложь;
	
КонецПроцедуры

Процедура ТаблицаПараметровПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

Процедура ТаблицаПараметровПередНачаломДобавления(Элемент, Отказ, Копирование)
	
	Отказ = Истина;
	
КонецПроцедуры

Процедура ТаблицаПараметровПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Колонка)
	
	ПараметрыПеретаскивания.ДопустимыеДействия = ДопустимыеДействияПеретаскивания.Перемещение;
	Если ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Копирование Тогда
		ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Перемещение;
	КонецЕсли; 
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

Процедура ТаблицаПараметровПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Колонка)
	
	Если ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Копирование Тогда
		ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Перемещение;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ТаблицаПараметровВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если Колонка = ЭлементыФормы.ТаблицаПараметров.Колонки.Имя Тогда
		#Если Сервер И Не Сервер Тогда
			ПолеТела = Обработки.ирКлсПолеТекстаПрограммы.Создать();
		#КонецЕсли
		ПолеТела.НайтиПоказатьСловоВТексте(ВыбраннаяСтрока.Имя,,,,,, Истина);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ШиринаГенерируемогоТекстаПриИзменении(Элемент)
	ирКлиент.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма, 5);
КонецПроцедуры

Процедура ШиринаГенерируемогоТекстаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	ирОбщий.ПолеВводаСИсториейВыбора_ОбновитьСписокЛкс(Элемент, ЭтаФорма);
КонецПроцедуры

ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирКлсПолеТекстаПрограммы.Форма.ВыделениеМетода");
ЭтаФорма.ШиринаГенерируемогоТекста = 180;
ЭтаФорма.ТипыВнешнихПереходов = Новый Структура;
ЭтаФорма.ЛиЭкспорт = Истина;
