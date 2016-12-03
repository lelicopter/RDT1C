﻿Процедура ПриОткрытии()
	
	ЭлементыФормы.ПанельРазделаНастроек.Страницы.ХранилищеВариантовОтчетов.Доступность = ТипЗнч(ХранилищеВариантовОтчетов) = Тип("СтандартноеХранилищеНастроекМенеджер");
	ЗаполнитьСписокПользователей();
	ОбновитьДеревоПользователей();
	ТекущийПользователь = ИмяПользователя();
	Если ЗначениеЗаполнено(ТекущийПользователь) Тогда
		СтрокаДерева = ДеревоПользователей.Строки.Найти(ТекущийПользователь, "ИмяПользователя", Истина);
		Если СтрокаДерева <> Неопределено Тогда 
			ЭлементыФормы.ДеревоПользователей.ТекущаяСтрока = СтрокаДерева;
		КонецЕсли;
	КонецЕсли;
	//ПолучитьСписокФорм();
	//ОбновитьДеревоФорм();
	ОбновитьСписокОписанийНастроек();
	
КонецПроцедуры

Процедура ОбновитьНажатие(Элемент)
	
	ОбновитьСписокОписанийНастроек();
	
КонецПроцедуры

Процедура ОбновитьСписокОписанийНастроек()

	ПользователиНазначения = Новый Массив;
	Если Не ЭлементыФормы.ДеревоПользователей.ВыделенныеСтроки.Содержит(ДеревоПользователей.Строки[0]) Тогда
		ПолучитьВыделеныхПользователей(ПользователиНазначения, ЭлементыФормы.ДеревоПользователей.ВыделенныеСтроки);
	КонецЕсли; 
	Если ПользователиНазначения.Количество() > 0 Тогда
		ЭтаФорма.ОтборЗагрузкиПользователи = ирОбщий.ПолучитьРасширенноеПредставлениеЗначенияЛкс(ПользователиНазначения,, Ложь);
	Иначе
		ЭтаФорма.ОтборЗагрузкиПользователи = "Все";
	КонецЕсли; 
	ФормыНазначения = Новый Массив;
	Если Истина
		И ДеревоФорм.Строки.Количество() > 0
		И Не ЭлементыФормы.ДеревоФорм.ВыделенныеСтроки.Содержит(ДеревоФорм.Строки[0]) 
	Тогда
		ПолучитьВыделеныеФормы(ФормыНазначения, ЭлементыФормы.ДеревоФорм.ВыделенныеСтроки);
	КонецЕсли; 
	Если ФормыНазначения.Количество() > 0 Тогда
		ЭтаФорма.ОтборЗагрузкиМетаданные = ирОбщий.ПолучитьРасширенноеПредставлениеЗначенияЛкс(ФормыНазначения,, Ложь);
	Иначе
		ЭтаФорма.ОтборЗагрузкиМетаданные = "Все";
	КонецЕсли; 
	ПолучитьОписаниеНастроек(ПользователиНазначения, ФормыНазначения, ЭлементыФормы.ПанельРазделаНастроек.ТекущаяСтраница.Имя);
	ЭтаФорма.Количество = ОписаниеНастроек.Количество();

КонецПроцедуры

Процедура ПолучитьВыделеныхПользователей(ПользователиНазначения, СтрокиДерева)

	Для каждого Строка Из СтрокиДерева Цикл
		Если Строка.ЭтоПользователь = Истина Тогда
			ПользователиНазначения.Добавить(Строка.ИмяПользователя);
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры // ПолучитьВыделеныхПользователей()

Процедура ПолучитьВыделеныеФормы(ФормыНазначения, СтрокиДерева)

	Для каждого Строка Из СтрокиДерева Цикл
		Если Строка.ЭтоОбъект = Истина Тогда
			ФормыНазначения.Добавить(Строка.ПолноеИмяОбъекта);
		КонецЕсли;
		ПолучитьВыделеныеФормы(ФормыНазначения, Строка.Строки);
	КонецЦикла;

КонецПроцедуры //

Процедура ОбновитьДеревоПользователей()

	ДеревоПользователей.Строки.Очистить();
	ВсеПользователи = ДеревоПользователей.Строки.Добавить();
	ВсеПользователи.ИмяПользователя = "Все";
	Для каждого Строка Из ПользователиИБ Цикл
		ВеткаГруппы = ВсеПользователи;
		СтрокаПользователя = ВеткаГруппы.Строки.Добавить();
		СтрокаПользователя.ИмяПользователя = СокрЛП(Строка.ИмяПользователя);
		СтрокаПользователя.ЭтоПользователь = Истина;
	КонецЦикла; 
	ЭлементыФормы.ДеревоПользователей.Развернуть(ВсеПользователи, Истина);
	
КонецПроцедуры

Процедура ОбновитьДеревоФорм()

	ДеревоФорм.Строки.Очистить();
	СтрокаВсе = ДеревоФорм.Строки.Добавить();
	СтрокаВсе.ИмяОбъекта = "Все";
	СтрокаВсе.ПолноеИмяОбъекта = "Все";
	СтрокаВсе.ПредставлениеОбъекта = "Все";
	Для каждого Строка Из ФормыИБ Цикл
		ВеткаТипа = СтрокаВсе.Строки.Найти(Строка.ТипОбъекта, "ИмяОбъекта", Ложь);
		Если ВеткаТипа = Неопределено Тогда
			ВеткаТипа = СтрокаВсе.Строки.Добавить();
			ВеткаТипа.ИмяОбъекта = Строка.ТипОбъекта;
			ВеткаТипа.ПредставлениеОбъекта = Строка.ТипОбъекта;
			ВеткаТипа.ТипОбъекта = Строка.ТипОбъекта;
		КонецЕсли;
		ВеткаВида = ВеткаТипа.Строки.Найти(Строка.ВидОбъекта, "ИмяОбъекта", Ложь);
		Если ВеткаВида = Неопределено Тогда
			ВеткаВида = ВеткаТипа.Строки.Добавить();
			ВеткаВида.ИмяОбъекта = Строка.ВидОбъекта;
			ВеткаВида.ПолноеИмяОбъекта = Строка.ВидОбъекта;
			ВеткаВида.ПредставлениеОбъекта = Строка.ВидОбъекта;
			ВеткаВида.ТипОбъекта = Строка.ТипОбъекта;
			ВеткаВида.ЭтоОбъект = Истина;
		КонецЕсли;
		СтрокаФормы = ВеткаВида.Строки.Добавить();
		СтрокаФормы.ИмяОбъекта = Строка.ИмяОбъекта;
		СтрокаФормы.ПолноеИмяОбъекта = Строка.ПолноеИмяОбъекта;
		СтрокаФормы.ПредставлениеОбъекта = Строка.ПредставлениеОбъекта;
		СтрокаФормы.ТипОбъекта = Строка.ТипОбъекта;
		СтрокаФормы.ЭтоОбъект = Истина;
	КонецЦикла; 
	СтрокаПрочие = СтрокаВсе.Строки.Добавить();
	СтрокаПрочие.ИмяОбъекта = "Прочие";
	СтрокаПрочие.ПолноеИмяОбъекта = "Прочие";
	СтрокаПрочие.ПредставлениеОбъекта = "Прочие";
	СтрокаПрочие.ЭтоОбъект = Истина;
	ЭлементыФормы.ДеревоФорм.Развернуть(СтрокаВсе, Ложь);
	
КонецПроцедуры

Процедура ДеревоФормПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ОформлениеСтроки.Ячейки.ИмяОбъекта.ОтображатьКартинку = ЗначениеЗаполнено(ДанныеСтроки.ТипОбъекта);
	Если ДанныеСтроки.Строки.Количество() = 0 Тогда
		ОформлениеСтроки.Ячейки.ИмяОбъекта.Картинка = БиблиотекаКартинок.Форма;
	Иначе
		ОформлениеСтроки.Ячейки.ИмяОбъекта.Картинка = КартинкаПоТипуОбъекта(ДанныеСтроки.ТипОбъекта);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДеревоПользователейПриАктивизацииСтроки(Элемент)
	
	ОбновитьСписокОписанийНастроек();
	
КонецПроцедуры

Процедура ДеревоФормПриАктивизацииСтроки(Элемент)
	
	ОбновитьСписокОписанийНастроек();
	
КонецПроцедуры

Процедура КоманднаяПанельНастроекУдалитьНастройки(Кнопка)

	УдалитьНастройкиВыделенныхСтрок(ЭлементыФормы.ОписаниеНастроек.ВыделенныеСтроки, Ложь);
	
КонецПроцедуры

Процедура КоманднаяПанельНастроекФормУдалитьНастройки(Кнопка)

	УдалитьНастройкиВыделенныхСтрок(ЭлементыФормы.ОписаниеНастроекФорм.ВыделенныеСтроки, Истина);
	
КонецПроцедуры

Процедура УдалитьНастройкиВыделенныхСтрок(ТекВыделенныеСтроки, ДопКлюч)

	ТабКУдалению = Новый ТаблицаЗначений;
	ТабКУдалению.Колонки.Добавить("КлючОбъекта");
	ТабКУдалению.Колонки.Добавить("КлючНастроек");
	ТабКУдалению.Колонки.Добавить("Пользователь");
	Для каждого Строка Из ТекВыделенныеСтроки Цикл
		СтрокаТаб = ТабКУдалению.Добавить();
		СтрокаТаб.КлючОбъекта = Строка.ИмяОбъекта + ?(ДопКлюч = Истина  И ЗначениеЗаполнено(Строка.Ключ), "/"+Строка.Ключ, "");
		СтрокаТаб.КлючНастроек = Строка.КлючНастроек;
		СтрокаТаб.Пользователь = Строка.ИмяПользователя;
	КонецЦикла; 
	Если ТабКУдалению.Количество() > 0 Тогда
		ТекстВопроса = НСтр("ru = 'После удаления настроек форма будет открываться с настройками по умолчанию. 
		|Вы действительно хотите удалить настройки?'");
		Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Да);
		Если Ответ = КодВозвратаДиалога.Нет Тогда
			Возврат;
		КонецЕсли;
		УдалитьНастройкиПользователей(ТабКУдалению, ЭлементыФормы.ПанельРазделаНастроек.ТекущаяСтраница.Имя);
		ПоказатьОповещениеПользователя(НСтр("ru = 'Настройки удалены'"));
		ОбновитьСписокОписанийНастроек();
	Иначе
		Сообщить("Не выбрано ни одной настройки.");
	КонецЕсли;

КонецПроцедуры

Процедура КоманднаяПанельНастроекСкопироватьНастройки(Кнопка)

	СкопироватьНастройкиВыделенныхСтрок(ЭлементыФормы.ОписаниеНастроек.ВыделенныеСтроки, Ложь);
	
КонецПроцедуры

Процедура КоманднаяПанельНастроекФормСкопироватьНастройки(Кнопка)

	СкопироватьНастройкиВыделенныхСтрок(ЭлементыФормы.ОписаниеНастроекФорм.ВыделенныеСтроки, Истина);	
	
КонецПроцедуры

Процедура СкопироватьНастройкиВыделенныхСтрок(ТекВыделенныеСтроки, ДопКлюч)

	Если ТекВыделенныеСтроки.Количество() = 0 Тогда
		Предупреждение(НСтр("ru = 'Для копирования нужно выбрать настройки, которые требуется скопировать.'"));
		Возврат;
	КонецЕсли;
	
	СписокПользователей = Новый СписокЗначений;
	Для каждого СтрокаП Из ПользователиИБ Цикл
		СписокПользователей.Добавить(СтрокаП.ИмяПользователя, "" + СтрокаП.ИмяПользователя );
	КонецЦикла; 
	
	Если СписокПользователей.ОтметитьЭлементы(НСтр("ru = 'Отметьте пользователей, которым нужно скопировать настройки'")) Тогда
		ПользователиПриемник = Новый Массив;
		Для Каждого Элемент Из СписокПользователей Цикл
			Если Элемент.Пометка Тогда
				ПользователиПриемник.Добавить(Элемент.Значение);
			КонецЕсли;
		КонецЦикла;
		
		Если ПользователиПриемник.Количество() = 0 Тогда
			Предупреждение(НСтр("ru = 'Для копирования нужно отметить пользователей, которым требуется скопировать настройки.'"));
			Возврат;
		КонецЕсли;
		
		ТекстВопроса = НСтр("ru = 'После копирования настроек пользователю,
		|форма у пользователя будет открываться с настройками, которые ему скопируются. 
		|При этом его собственные настройки будут потеряны. 
		|Вы действительно хотите скопировать настройки выбранным пользователям?'");
		Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Да);
		Если Ответ = КодВозвратаДиалога.Нет Тогда
			Возврат;
		КонецЕсли;
		
		///
		ТабОписаний = Новый ТаблицаЗначений;
		ТабОписаний.Колонки.Добавить("КлючОбъекта");
		ТабОписаний.Колонки.Добавить("КлючНастроек");
		ТабОписаний.Колонки.Добавить("Пользователь");
		
		Для каждого Строка Из ТекВыделенныеСтроки Цикл
			СтрокаТаб = ТабОписаний.Добавить();
			СтрокаТаб.КлючОбъекта = Строка.ИмяОбъекта + ?(ДопКлюч = Истина  И ЗначениеЗаполнено(Строка.Ключ), "/"+Строка.Ключ, "");
			СтрокаТаб.КлючНастроек = Строка.КлючНастроек;
			СтрокаТаб.Пользователь = Строка.ИмяПользователя;
		КонецЦикла; 
		
		СкопироватьНастройкиПользователей(ТабОписаний, ПользователиПриемник, ЭлементыФормы.ПанельРазделаНастроек.ТекущаяСтраница.Имя);
		///
		
		ПоказатьОповещениеПользователя(НСтр("ru = 'Настройки скопированы'"));
		ОбновитьСписокОписанийНастроек();
		
	КонецЕсли;	

КонецПроцедуры

Процедура ПанельРазделаНастроекПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	ОбновитьСписокОписанийНастроек();
	
КонецПроцедуры

Процедура КоманднаяПанельНастроекОткрытьНастройку(Кнопка)
	
	ОткрытьТекНастройку(ЭлементыФормы.ОписаниеНастроек.ТекущиеДанные, Ложь);
	
КонецПроцедуры

Процедура ОткрытьТекНастройку(ТекДанные, ДопКлюч, Исследовать = Ложь)
	
	Если ТекДанные <> Неопределено Тогда
		
		ТабОписаний = Новый ТаблицаЗначений;
		ТабОписаний.Колонки.Добавить("КлючОбъекта");
		ТабОписаний.Колонки.Добавить("КлючНастроек");
		ТабОписаний.Колонки.Добавить("Пользователь");
		
		//Для каждого Строка Из ТекВыделенныеСтроки Цикл
			СтрокаТаб = ТабОписаний.Добавить();
			СтрокаТаб.КлючОбъекта = ТекДанные.ИмяОбъекта + ?(ДопКлюч = Истина И ЗначениеЗаполнено(ТекДанные.Ключ), "/" + ТекДанные.Ключ, "");
			СтрокаТаб.КлючНастроек = ТекДанные.КлючНастроек;
			СтрокаТаб.Пользователь = ТекДанные.ИмяПользователя;
		//КонецЦикла;
		
		ОткрытьЗначНастройки(ТабОписаний, ЭлементыФормы.ПанельРазделаНастроек.ТекущаяСтраница.Имя, Исследовать);
	КонецЕсли;

КонецПроцедуры

Процедура КоманднаяПанельНастроекФормОткрытьНастройкуФорм(Кнопка)
	
	ОткрытьТекНастройку(ЭлементыФормы.ОписаниеНастроекФорм.ТекущиеДанные, Истина);
	
КонецПроцедуры

Процедура ОписаниеНастроекФормВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ОткрытьТекНастройку(ЭлементыФормы.ОписаниеНастроекФорм.ТекущиеДанные, Истина);
	
КонецПроцедуры

Процедура ОписаниеНастроекВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ОткрытьТекНастройку(ЭлементыФормы.ОписаниеНастроек.ТекущиеДанные, Истина);
	
КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	Если НЕ ПравоДоступа("Администрирование", Метаданные) Тогда
		Отказ = Истина;
		Сообщить("Недостаточно прав.");
	КонецЕсли;
	Если ТипЗнч(ХранилищеНастроекДанныхФорм) <> Тип("СтандартноеХранилищеНастроекМенеджер") Тогда
		Сообщить("Поддерживается работа только со стандартным хранилищем настроек форм");
		Отказ = Истина;
	КонецЕсли; 
	
КонецПроцедуры

Процедура КоманднаяПанельНастроекОтборБезЗначенияВТекущейКолонке(Кнопка)
	
	ирОбщий.ТабличноеПоле_ОтборБезЗначенияВТекущейКолонке_КнопкаЛкс(ЭлементыФормы.ОписаниеНастроек);

КонецПроцедуры

Процедура ОписаниеНастроекПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

Процедура ДействияФормыОПодсистеме(Кнопка)
	
	ирОбщий.ОткрытьСправкуПоПодсистемеЛкс(ЭтотОбъект);
	
КонецПроцедуры

Процедура КоманднаяПанельНастроекИсследовать(Кнопка)
	
	ОткрытьТекНастройку(ЭлементыФормы.ОписаниеНастроек.ТекущиеДанные, , Истина);
	
КонецПроцедуры

Процедура КоманднаяПанельНастроекКонсольКомпоновки(Кнопка)
	
	КонсольКомпоновокДанных = ирОбщий.ПолучитьОбъектПоПолномуИмениМетаданныхЛкс("Отчет.ирКонсольКомпоновокДанных");
	#Если _ Тогда
		КонсольКомпоновокДанных = Отчеты.ирКонсольКомпоновокДанных.Создать();
	#КонецЕсли
    КонсольКомпоновокДанных.ОткрытьПоТаблицеЗначений(ОписаниеНастроек.Выгрузить());
	
КонецПроцедуры

Процедура КоманднаяПанельНастроекМенеджерТабличногоПоля(Кнопка)
	
	 ирОбщий.ПолучитьФормуЛкс("Обработка.ирМенеджерТабличногоПоля.Форма",, ЭтаФорма, ).УстановитьСвязь(ЭлементыФормы.ОписаниеНастроек);

КонецПроцедуры

Процедура ФильтрИмяОбъектаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Элемент.Значение = "";
	ЭлементыФормы.ОписаниеНастроек.ОтборСтрок.ИмяОбъекта.Использование = Ложь; 
	
КонецПроцедуры

Процедура ФильтрИмяОбъектаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)

	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, Метаданные().Имя);
	
КонецПроцедуры

Процедура ФильтрИмяОбъектаПриИзменении(Элемент)
	
	ЭлементыФормы.ОписаниеНастроек.ОтборСтрок.ИмяОбъекта.Использование = Истина; 
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, Метаданные().Имя);
	
КонецПроцедуры

Процедура Панель1ПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	Если ЭлементыФормы.ПанельОтборЗагрузки.ТекущаяСтраница = ЭлементыФормы.ПанельОтборЗагрузки.Страницы.Метаданные Тогда
		Если ДеревоФорм.Строки.Количество() = 0 Тогда
			ПолучитьСписокФорм();
			ОбновитьДеревоФорм();
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ирОбщий.ФормаОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура КлсУниверсальнаяКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработчикОжиданияСПараметрамиЛкс() Экспорт 
	
	ирОбщий.ОбработчикОжиданияСПараметрамиЛкс();

КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирРедакторХранилищНастроек.Форма.Форма");
ЭлементыФормы.ОписаниеНастроек.ОтборСтрок.ИмяОбъекта.ВидСравнения = ВидСравнения.Содержит; 
ОтборЗагрузкиМетаданные = "Все";
ОтборЗагрузкиПользователи = "Все";