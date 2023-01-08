﻿Перем МассивУровнейЖурнала;
Перем СтруктураКолонокБезОтбора;
Перем СтарыйОтбор;

Функция СохраняемаяНастройкаФормы(выхНаименование, выхИменаСвойств) Экспорт 
	НастройкаФормы = ирОбщий.КопияОбъектаЛкс(ОписаниеВариантаОтбора());
	выхНаименование = ПредставлениеВариантаОтбора(НастройкаФормы);
	Возврат НастройкаФормы;
КонецФункции

Процедура ЗагрузитьНастройкуВФорме(НастройкаФормы, ДопПараметры) Экспорт 
	
	Если НастройкаФормы.Свойство("НачалоПериода") Тогда
		ЭтотОбъект.НачалоПериода = НастройкаФормы.НачалоПериода;
		ЭтотОбъект.КонецПериода = НастройкаФормы.КонецПериода;
	КонецЕсли; 
	ЭтотОбъект.МаксимальныйРазмерВыгрузки = НастройкаФормы.МаксимальныйРазмерВыгрузки;
	Если НастройкаФормы.Свойство("АлгоритмПередВыгрузкой") Тогда
		ЭтотОбъект.АлгоритмПередВыгрузкой = НастройкаФормы.АлгоритмПередВыгрузкой;
	КонецЕсли; 
	Отбор.Очистить();
	ирОбщий.ЗагрузитьВТаблицуЗначенийЛкс(НастройкаФормы.Отбор, Отбор);
	НастроитьЭлементыФормы();
	
КонецПроцедуры

Процедура КнопкаВыбораПериодаНажатие(Элемент)
	
	НастройкаПериода = Новый НастройкаПериода;
	НастройкаПериода.УстановитьПериод(НачалоПериода, ?(КонецПериода='0001-01-01', КонецПериода, КонецДня(КонецПериода)));
	НастройкаПериода.РедактироватьКакИнтервал = Истина;
	НастройкаПериода.РедактироватьКакПериод = Истина;
	НастройкаПериода.ВариантНастройки = ВариантНастройкиПериода.Период;
	Если НастройкаПериода.Редактировать() Тогда
		НачалоПериода = НастройкаПериода.ПолучитьДатуНачала();
		КонецПериода = НастройкаПериода.ПолучитьДатуОкончания();
	КонецЕсли;

КонецПроцедуры

Процедура ТаблицаВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	СтрокаТаблицыЗначений = ТаблицаЗначенийЖурнала.Найти(ВыбраннаяСтрока.ПорядокСтроки, "ПорядокСтроки");
	//ирКлиент.ЯчейкаТабличногоПоляРасширенногоЗначения_ВыборЛкс(ЭтаФорма, Элемент, СтандартнаяОбработка, СтрокаТаблицыЗначений[Колонка.Данные]);
	ФормаСобытия = ПолучитьФорму("ФормаСобытия",, ВыбраннаяСтрока.ПорядокСтроки);
	ФормаСобытия.НачальноеЗначениеВыбора = ВыбраннаяСтрока;
	ФормаСобытия.СтрокаТаблицыЗначений = СтрокаТаблицыЗначений;
	ФормаСобытия.Открыть();

КонецПроцедуры

Процедура ОбновитьТаблицуЖурнала() Экспорт
	
	#Если Сервер И Не Сервер Тогда
		ЗагрузитьДанныеЖурналаЗавершить();
	#КонецЕсли
	ЗагрузитьДанныеЖурнала(ЭтаФорма, ЭлементыФормы.ДействияФормы.Кнопки.Обновить, "ЗагрузитьДанныеЖурналаЗавершить");
	
КонецПроцедуры

// Предопределеный метод
Процедура ПроверкаЗавершенияФоновыхЗаданий() Экспорт 
	
	ирКлиент.ПроверитьЗавершениеФоновыхЗаданийФормыЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ЗагрузитьДанныеЖурналаЗавершить(СостояниеЗадания = Неопределено, РезультатЗадания = Неопределено) Экспорт 
	
	Если Ложь
		Или СостояниеЗадания = Неопределено
		Или СостояниеЗадания = СостояниеФоновогоЗадания.Завершено 
	Тогда
		ирОбщий.СостояниеЛкс("Загрузка выгрузки журнала регистрации");
		Если ЭлементыФормы.ТаблицаЖурнала.ТекущаяСтрока <> Неопределено Тогда
			КлючТекущейСтроки = Новый Структура();
			Для Каждого Колонка Из Метаданные().ТабличныеЧасти.ТаблицаЖурнала.Реквизиты Цикл
				Если Колонка.Имя = "ПорядокСтроки" Тогда
					Продолжить;
				КонецЕсли; 
				КлючТекущейСтроки.Вставить(Колонка.Имя, ЭлементыФормы.ТаблицаЖурнала.ТекущаяСтрока[Колонка.Имя]);
			КонецЦикла;
		КонецЕсли;
		Если ЗначениеЗаполнено(СостояниеЗадания) Тогда
			ЭтотОбъект.ТаблицаЗначенийЖурнала = РезультатЗадания.ТаблицаЗначенийЖурнала;
		КонецЕсли;
		ТаблицаЖурнала.Загрузить(ТаблицаЗначенийЖурнала);
		ЭлементыФормы.ТаблицаЖурнала.Колонки.РазделениеДанныхСеанса.Видимость = ТаблицаЗначенийЖурнала.Колонки.Найти("РазделениеДанныхСеанса") <> Неопределено;
		ТекущаяСтрокаУстановлена = Ложь;
		Если КлючТекущейСтроки <> Неопределено Тогда
			НайденныеСтроки = ТаблицаЖурнала.НайтиСтроки(КлючТекущейСтроки);
			Если НайденныеСтроки.Количество() > 0 Тогда
				ЭлементыФормы.ТаблицаЖурнала.ТекущаяСтрока = НайденныеСтроки[0];
				ТекущаяСтрокаУстановлена = Истина;
			КонецЕсли; 
		КонецЕсли; 
		Если Не ТекущаяСтрокаУстановлена Тогда
			Если ТаблицаЖурнала.Количество() > 0 Тогда
				ЭлементыФормы.ТаблицаЖурнала.ТекущаяСтрока = ТаблицаЖурнала[ТаблицаЖурнала.Количество() - 1];
			КонецЕсли; 
		КонецЕсли; 
		ЭлементыФормы.ТаблицаЖурнала.Колонки.ДлительностьТранзакции.Видимость = РезультатЗадания.АнализироватьТранзакцииСУчастиемОбъекта;
		ЭтотОбъект.КоличествоСтрокЖурнала = ТаблицаЖурнала.Количество();
		Если МаксимальныйРазмерВыгрузки > 0 И МаксимальныйРазмерВыгрузки = ТаблицаЖурнала.Количество() Тогда
			ирОбщий.СообщитьЛкс("Выгрузка прервана по максимально допустимому количеству сообщений");
		КонецЕсли;
		ДлительностьСекунд = ТекущаяДата() - РезультатЗадания.НачалоЗадания;
		ДлительностьСтрока = ирОбщий.ПредставлениеДлительностиЛкс(ДлительностьСекунд);
		Если ВыводитьДлительностьВыгрузки Или ДлительностьСекунд > 5 Тогда
			ирОбщий.СообщитьЛкс("Выгрузка данных журнала завершена через " + ДлительностьСтрока + ". Отбор - " + РезультатЗадания.ПредставлениеОтбора);
		КонецЕсли;
		ирОбщий.СостояниеЛкс("");
	КонецЕсли; 

КонецПроцедуры

Процедура КоманднаяПанельЖурналРегистрацииОбновить(Кнопка)
	
	ОбновитьТаблицуЖурнала();
	
КонецПроцедуры

Процедура ОтборПередНачаломДобавления(Элемент, Отказ, Копирование)
	
	Отказ = Истина;
	Если Копирование Тогда
		Возврат;
	КонецЕсли; 
	СписокВыбора = Новый СписокЗначений;
	Для Каждого Колонка Из Метаданные().ТабличныеЧасти.ТаблицаЖурнала.Реквизиты Цикл
		Если Ложь
			Или Отбор.Найти(Колонка.Имя, "Поле") <> Неопределено 
			Или СтруктураКолонокБезОтбора.Свойство(Колонка.Имя)
		Тогда
			Продолжить;
		КонецЕсли; 
		СписокВыбора.Добавить(Колонка.Имя, Колонка.Представление());
	КонецЦикла;
	СписокВыбора.СортироватьПоЗначению();
	РезультатВыбора = СписокВыбора.ВыбратьЭлемент();
	Если РезультатВыбора <> Неопределено Тогда
		ПолеОтбора = РезультатВыбора.Значение;
		ТекущаяСтрока = ДобавитьЭлементОтбора(Отбор, ПолеОтбора);
		Элемент.ТекущаяСтрока = ТекущаяСтрока;
		//Элемент.ИзменитьСтроку();
		//ОтборЗначениеНачалоВыбора();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ирКлиент.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ирКлиент.СоздатьМенеджерСохраненияНастроекФормыЛкс(ЭтаФорма);
	мАлгоритмПередВыгрузкойПараметры = ирОбщий.ТаблицаЗначенийИзТабличногоДокументаЛкс(ПолучитьМакет("АлгоритмПередВыгрузкой"),,,, Истина);
	Если НЕ ЗначениеЗаполнено(НачалоПериода) Тогда
		НачалоПериода = НачалоДня(ТекущаяДата());
	КонецЕсли;
	ДействияФормыОткрытьФайлЖурнала();
	ОбновитьПодменюПоследнихОтборов();
	ДопСвойства = ирКлиент.ДопСвойстваЭлементаФормыЛкс(ЭтаФорма, ЭлементыФормы.ТаблицаЖурнала);
	ДопСвойства.ЗапретПодвала = Истина;

КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирКлиент.Форма_ПриЗакрытииЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ОтборЗначениеПриИзменении(Элемент)
	
	ТекущаяСтрока = ЭлементыФормы.Отбор.ТекущаяСтрока;
	ПолеОтбора = ТекущаяСтрока.Поле;
	БазовоеОписаниеТипов = Метаданные().ТабличныеЧасти.ТаблицаЖурнала.Реквизиты[ПолеОтбора].Тип;
	ТекущаяСтрока.Использование = Истина;
	Если ТипЗнч(ТекущаяСтрока.Значение) = Тип("СписокЗначений") Тогда
		Если ПолеОтбора = "Сеанс" Тогда 
			ТекущаяСтрока.Значение.ТипЗначения = БазовоеОписаниеТипов;
		КонецЕсли;
	КонецЕсли;
	Если ТекущаяСтрока.Поле = "Комментарий" Тогда
		ирКлиент.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, КомментарийКлючХраненияПоследнихЗначений());
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыбратьДатуИзСписка(Элемент, СтандартнаяОбработка, Знач ПарнаяДата, Знак)
	
	СимволЗнака = ?(Знак = 1, "+", "-");
	ИмяПарнойДаты = ?(Знак = 1, "Начало", "Конец");
	СписокВыбора = Новый СписокЗначений;
	СписокВыбора.Добавить(1*60,          ИмяПарнойДаты + " " + СимволЗнака + " 1 минута");
	СписокВыбора.Добавить(10*60,       ИмяПарнойДаты + " " + СимволЗнака + " 10 минут");
	СписокВыбора.Добавить(2*60*60,       ИмяПарнойДаты + " " + СимволЗнака + " 2 часа");
	СписокВыбора.Добавить(1*24*60*60,    ИмяПарнойДаты + " " + СимволЗнака + " 1 день");
	СписокВыбора.Добавить(7*24*60*60,    ИмяПарнойДаты + " " + СимволЗнака + " 7 дней");
	СписокВыбора.Добавить(30*24*60*60,   ИмяПарнойДаты + " " + СимволЗнака + " 30 дней");
	РезультатВыбора = ЭтаФорма.ВыбратьИзСписка(СписокВыбора, Элемент);
	Если РезультатВыбора <> Неопределено Тогда
		Если Знак = -1 Тогда
			Если Не ЗначениеЗаполнено(ПарнаяДата) Тогда
				ПарнаяДата = ТекущаяДата();
			КонецЕсли; 
		КонецЕсли; 
		Элемент.Значение = ПарнаяДата + Знак * РезультатВыбора.Значение;
	КонецЕсли;
	СтандартнаяОбработка = Ложь;

КонецПроцедуры

Процедура КонецПериодаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ВыбратьДатуИзСписка(Элемент, СтандартнаяОбработка, НачалоПериода, 1);
	
КонецПроцедуры

Процедура НачалоПериодаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ВыбратьДатуИзСписка(Элемент, СтандартнаяОбработка, КонецПериода, -1);

КонецПроцедуры

Процедура КоманднаяПанельЖурналРегистрацииНастроитьРегистрациюСобытия(Кнопка)
	
	Форма = ирКлиент.ПолучитьФормуЛкс("Обработка.ирНастройкаЖурналаРегистрации.Форма");
	Форма.Открыть();
	ТекущаяСтрока = ЭлементыФормы.ТаблицаЖурнала.ТекущаяСтрока;
	Если ТекущаяСтрока <> Неопределено Тогда
		СтрокаТаблицыЗначений = ТаблицаЗначенийЖурнала.Найти(ТекущаяСтрока.ПорядокСтроки, "ПорядокСтроки");
		лМетаданные = Неопределено;
		Если СтрокаТаблицыЗначений <> Неопределено Тогда
			лМетаданные = СтрокаТаблицыЗначений.Метаданные;
		КонецЕсли; 
		Форма.АктивизироватьСтрокуСобытия(ТекущаяСтрока.Событие, лМетаданные);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ФиксированныйСписокПриИзмененииФлажка(Элемент)
	
	ЭлементыФормы.Отбор.ОбновитьСтроки();
	ЭлементыФормы.Отбор.ТекущиеДанные.Использование = Истина;
	
КонецПроцедуры

Процедура ОтборПриАктивизацииСтроки(Элемент = Неопределено)

	Если Элемент = Неопределено Тогда
		Элемент = ЭлементыФормы.Отбор;
	КонецЕсли; 
	ирКлиент.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	ТекущиеДанные = ЭлементыФормы.Отбор.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		ЗначениеОтбора = Неопределено;
	Иначе
		ЗначениеОтбора = ТекущиеДанные.Значение;
	КонецЕсли; 
	ЭтоСписокЗначений = ТипЗнч(ЗначениеОтбора) = Тип("СписокЗначений");
	Элемент.Колонки.Значение.ТолькоПросмотр = ЭтоСписокЗначений;
	ЭлементыФормы.ФиксированныйСписок.Видимость = ЭтоСписокЗначений;
	ЭлементыФормы.КоманднаяПанельСписка.Видимость = ЭтоСписокЗначений;
	ЭлементыФормы.КоличествоЭлементовСписка.Видимость = ЭтоСписокЗначений;
	Если ЭтоСписокЗначений Тогда
		ЭтаФорма.КоличествоЭлементовСписка = ЗначениеОтбора.Количество();
	Иначе
		ЭтаФорма.КоличествоЭлементовСписка = 0;
	КонецЕсли; 
	
КонецПроцедуры

Процедура КоманднаяПанельСпискаСнятьФлажки(Кнопка)
	
	ЭлементыФормы.ФиксированныйСписок.Значение.ЗаполнитьПометки(Ложь);
	ЭлементыФормы.Отбор.ОбновитьСтроки();
	
КонецПроцедуры

Процедура КоманднаяПанельСпискаУстановитьФлажки(Кнопка)
	
	ЭлементыФормы.ФиксированныйСписок.Значение.ЗаполнитьПометки(Истина);
	ЭлементыФормы.Отбор.ОбновитьСтроки();

КонецПроцедуры

Процедура ДействияФормыАнализТехножурнала(Кнопка)
	
	АнализТехножурнала = ирОбщий.СоздатьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирАнализТехножурнала");
	#Если Сервер И Не Сервер Тогда
		АнализТехножурнала = Обработки.ирАнализТехножурнала.Создать();
	#КонецЕсли
	АнализТехножурнала.ОткрытьСОтбором(НачалоПериода, КонецПериода);
	
КонецПроцедуры

Процедура ОтборПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Элемент.ТекущиеДанные.Значение = Элемент.ТекущиеДанные.ОписаниеТипов.ПривестиЗначение(Элемент.ТекущиеДанные.Значение);
	ЭлементыФормы.Отбор.Колонки.Значение.ЭлементУправления.КнопкаСпискаВыбора = Элемент.ТекущиеДанные.Поле = "Комментарий";
	
КонецПроцедуры

Процедура КоманднаяПанельЖурналРегистрацииНайтиВОтбореВыгрузки(Кнопка)
	
	ПолеОтбора = ЭлементыФормы.ТаблицаЖурнала.ТекущаяКолонка.Данные;
	Если СтруктураКолонокБезОтбора.Свойство(ПолеОтбора) Тогда
		Если ЗначениеЗаполнено(СтруктураКолонокБезОтбора[ПолеОтбора]) Тогда
			ПолеОтбора = СтруктураКолонокБезОтбора[ПолеОтбора];
		КонецЕсли; 
	КонецЕсли; 
	ЗначениеОтбора = Неопределено;
	Если ЭлементыФормы.ТаблицаЖурнала.ТекущаяСтрока <> Неопределено Тогда
		ЗначениеОтбора = ЭлементыФормы.ТаблицаЖурнала.ТекущиеДанные[ПолеОтбора];
	КонецЕсли; 
	СтрокаОтбора = ДобавитьЭлементОтбора(Отбор, ПолеОтбора, ЗначениеОтбора);
	ЭлементыФормы.Отбор.ТекущаяСтрока = СтрокаОтбора;
	ТекущаяСтрокаСписка = ЭлементыФормы.ФиксированныйСписок.Значение.НайтиПоЗначению(ЗначениеОтбора);
	Если ТекущаяСтрокаСписка <> Неопределено Тогда
		ЭлементыФормы.ФиксированныйСписок.ТекущаяСтрока = ТекущаяСтрокаСписка;
	КонецЕсли; 
	ЭлементыФормы.Отбор.ОбновитьСтроки();
	
КонецПроцедуры

Процедура КоманднаяПанельОтборТекущийСеанс(Кнопка)
	
	ДобавитьЭлементОтбора(Отбор, "Сеанс", НомерСеансаИнформационнойБазы(),, Истина, Ложь);
	
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирКлиент.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	ирКлиент.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура ОтборЗначениеОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	//ирКлиент.ПолеВвода_ОкончаниеВводаТекстаЛкс(Элемент, Текст, Значение, СтандартнаяОбработка, , Истина);
	ирКлиент.ПолеВвода_ОкончаниеВводаТекстаЛкс(Элемент, Текст, Значение, СтандартнаяОбработка);

КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирКлиент.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработчикОжиданияСПараметрамиЛкс() Экспорт 
	
	ирКлиент.ОбработчикОжиданияСПараметрамиЛкс();

КонецПроцедуры

Процедура ОтборЗначениеНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ирКлиент.ПолеВводаКолонкиРасширенногоЗначения_НачалоВыбораЛкс(ЭтаФорма, ЭлементыФормы.Отбор, СтандартнаяОбработка, , Истина);
	
КонецПроцедуры

Процедура КоманднаяПанельСпискаСортироватьПоВозрастанию(Кнопка)
	
	ЭлементыФормы.Отбор.ТекущиеДанные.Значение.СортироватьПоЗначению();
	
КонецПроцедуры

Процедура КоманднаяПанельСпискаСортироватьПоУбыванию(Кнопка)
	
	ЭлементыФормы.Отбор.ТекущиеДанные.Значение.СортироватьПоЗначению(НаправлениеСортировки.Убыв);

КонецПроцедуры

Процедура ДействияФормыОткрытьФайлЖурнала(Кнопка = Неопределено)
	
	Если Кнопка <> Неопределено Тогда
		Если ЗначениеЗаполнено(ИмяФайла) Тогда
			Ответ = Вопрос("Хотите открыть текущий журнал регистрации?", РежимДиалогаВопрос.ДаНет);
		Иначе
			Ответ = КодВозвратаДиалога.Нет;
		КонецЕсли; 
		Если Ответ = КодВозвратаДиалога.Да Тогда
			ИмяФайла = "";
		Иначе
			//НовоеИмяФайла = ирКлиент.ВыбратьФайлЛкс(, "lgf,lgd", "Журнал регистрации 1С", ИмяФайла); // lgd выдает ошибку https://www.hostedredmine.com/issues/929797
			НовоеИмяФайла = ирКлиент.ВыбратьФайлЛкс(, "lgf", "Журнал регистрации 1С", ИмяФайла);
			Если НовоеИмяФайла <> Неопределено Тогда
				ИмяФайла = НовоеИмяФайла;
			Иначе
				Возврат;
			КонецЕсли; 
		КонецЕсли;
	КонецЕсли; 
	ирОбщий.ОбновитьТекстПослеМаркераВСтрокеЛкс(ЭтаФорма.Заголовок,, ИмяФайла, ": ");
	ЗаполнитьОтборВыгрузки();
	ТаблицаЖурнала.Очистить();
	ОтборПриАктивизацииСтроки();
	
КонецПроцедуры

Процедура КоманднаяПанельФормыОткрытьИТС(Кнопка)
	
	ирКлиент.ОткрытьСсылкуИТСЛкс("https://its.1c.ru/db/v?doc#bookmark:dev:TI000000823");
	
КонецПроцедуры

Процедура КоманднаяПанельСпискаРедактироватьЭлементОтбора(Кнопка = Неопределено)
	
	ФормаРедактора = ПолучитьФорму("РедакторСписка");
	ФормаРедактора.ПараметрСписок = ЭлементыФормы.Отбор.ТекущиеДанные.Значение;
	ФормаРедактора.ПараметрТекущаяСтрока = ЭлементыФормы.ФиксированныйСписок.ТекущаяСтрока;
	РезультатФормы = ФормаРедактора.ОткрытьМодально();
	Если РезультатФормы <> Неопределено Тогда
		ЭлементыФормы.Отбор.ТекущиеДанные.Использование = Истина;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОтборВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если КоличествоЭлементовСписка > 0 И ЭлементыФормы.Отбор.Колонки.Значение = Колонка Тогда
		СтандартнаяОбработка = Ложь;
		КоманднаяПанельСпискаРедактироватьЭлементОтбора();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ФиксированныйСписокВыбор(Элемент, ЭлементСписка)
	
	КоманднаяПанельСпискаРедактироватьЭлементОтбора();
	
КонецПроцедуры

Процедура ОтборПриИзмененииФлажка(Элемент, Колонка)
	
	ирКлиент.ТабличноеПолеПриИзмененииФлажкаЛкс(ЭтаФорма, Элемент, Колонка);

КонецПроцедуры

Процедура ТаблицаЖурналаПриАктивизацииСтроки(Элемент)
	
	ирКлиент.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);

КонецПроцедуры

Процедура КоманднаяПанельФормыОтображатьОтбор(Кнопка)
	
	ПоказатьСвернутьОтбор(Не ЭлементыФормы.ДействияФормы.Кнопки.ОтображатьОтбор.Пометка);
	
КонецПроцедуры

Процедура ПоказатьСвернутьОтбор(Видимость = Истина)
	
	ЭлементыФормы.ДействияФормы.Кнопки.ОтображатьОтбор.Пометка = Видимость;
	ирКлиент.ИзменитьСвернутостьЛкс(ЭтаФорма, Видимость, ЭлементыФормы.ПанельОтбор, ЭлементыФормы.РазделительГоризонтальныйПодОтбором, ЭтаФорма.Панель, "верх");
	
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если Не Отказ Тогда
		ПоказатьСвернутьОтбор();
	КонецЕсли; 

КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	ирКлиент.Форма_ОбновлениеОтображенияЛкс(ЭтаФорма);

КонецПроцедуры

Процедура ПроверитьИзменениеОтбораТабличногоПоляДляИстории(ПутьКДанным)
	
	ПодключитьОбработчикИзмененияДанных("ЭлементыФормы.ТаблицаЖурнала.Отбор", "ПроверитьИзменениеОтбораТабличногоПоляДляИстории", Истина);
	ПодключитьОбработчикОжидания("ПроверитьИзменениеОтбораТабличногоПоляДляИсторииОтложенно", 0.1, Истина);

КонецПроцедуры

Процедура ОбновитьПодменюПоследнихОтборов()
	
	ирКлиент.ОбновитьПодменюПоследнихОтборовЛкс(ЭтаФорма, ЭлементыФормы.КоманднаяПанельЖурнала, ЭлементыФормы.ТаблицаЖурнала);

КонецПроцедуры

Процедура ПроверитьИзменениеОтбораДляИсторииОтложенно()
	
	ТабличноеПоле = ЭлементыФормы.ТаблицаЖурнала;
	ДобавленВСписок = ирКлиент.ДобавитьОтборВИсториюТабличногоПоляЛкс(ЭтаФорма, ТабличноеПоле, ТабличноеПоле.ОтборСтрок, СтарыйОтбор);
	Если ДобавленВСписок Тогда
		ОбновитьПодменюПоследнихОтборов();
	КонецЕсли;

КонецПроцедуры

Процедура ОбработчикИзмененияДанных(ПутьКДанным) Экспорт 
	
	ПутьКДаннымОтбораНайденных = "ЭлементыФормы." + ЭлементыФормы.ТаблицаЖурнала.Имя + ".Отбор";
	Если ирОбщий.СтрНачинаетсяСЛкс(ПутьКДанным, ПутьКДаннымОтбораНайденных) Тогда
		#Если Сервер И Не Сервер Тогда
			ПроверитьИзменениеОтбораДляИсторииОтложенно();
		#КонецЕсли
		ПодключитьОбработчикОжидания("ПроверитьИзменениеОтбораДляИсторииОтложенно", 0.1, Истина);
		ПодключитьОбработчикИзмененияДанных(ПутьКДаннымОтбораНайденных, "ОбработчикИзмененияДанных", Истина);
	КонецЕсли; 

КонецПроцедуры

Процедура КоманднаяПанельЖурналРегистрацииАнализПравДоступа(Кнопка)
	
	ВыбраннаяСтрока = ЭлементыФормы.ТаблицаЖурнала.ТекущаяСтрока;
	Если ВыбраннаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	СтрокаТаблицыЗначений = ТаблицаЗначенийЖурнала.Найти(ВыбраннаяСтрока.ПорядокСтроки, "ПорядокСтроки");
	ПолноеИмяМД = ВыбратьОбъектМетаданных(СтрокаТаблицыЗначений);
	Если ПолноеИмяМД = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ФормаОтчета = ирКлиент.ПолучитьФормуЛкс("Отчет.ирАнализПравДоступа.Форма",,, ПолноеИмяМД);
	ФормаОтчета.Пользователь = СтрокаТаблицыЗначений.ИмяПользователя;
	ФормаОтчета.ОбъектМетаданных = ПолноеИмяМД;
	ФормаОтчета.ПараметрКлючВарианта = "ПоПользователям";
	ФормаОтчета.Открыть();
	
КонецПроцедуры

Процедура КоманднаяПанельЖурналРегистрацииОткрытьОбъектМетаданных(Кнопка)
	
	ВыбраннаяСтрока = ЭлементыФормы.ТаблицаЖурнала.ТекущаяСтрока;
	Если ВыбраннаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	СтрокаТаблицыЗначений = ТаблицаЗначенийЖурнала.Найти(ВыбраннаяСтрока.ПорядокСтроки, "ПорядокСтроки");
	ПолноеИмяМД = ВыбратьОбъектМетаданных(СтрокаТаблицыЗначений);
	Если ПолноеИмяМД = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ирКлиент.ОткрытьОбъектМетаданныхЛкс(ПолноеИмяМД);
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирКлиент.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТаблицаЖурналаПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт 
	
	ОформлениеСтроки.Ячейки.Уровень.ОтображатьКартинку = Истина;
	ИндексКартинки = -1;
	//Если ДанныеСтроки.СтатусТранзакции = "" + СтатусТранзакцииЗаписиЖурналаРегистрации.Отменена тогда
	//	ИндексКартинки = 0;
	//Иначе
		ИндексКартинки = МассивУровнейЖурнала.Найти("" + ДанныеСтроки.Уровень);
		ИндексКартинки = ?(ИндексКартинки <> Неопределено, ИндексКартинки, -1);
	//КонецЕсли;
	Если ИндексКартинки >= 0 тогда
		ОформлениеСтроки.Ячейки.Уровень.ИндексКартинки = ИндексКартинки;
	КонецЕсли;
	Если ДанныеСтроки.Сеанс = НомерСеансаИнформационнойБазы() Тогда
		ОформлениеСтроки.ЦветФона = Новый Цвет(250, 250, 255);
	КонецЕсли; 
	//Если ДанныеСтроки.Данные = ВыбОбъект Тогда
	//	ОформлениеСтроки.ЦветФона = Новый Цвет(255, 250, 250);
	//КонецЕсли;
	СтрокаТаблицыЗначений = ТаблицаЗначенийЖурнала.Найти(ДанныеСтроки.ПорядокСтроки, "ПорядокСтроки");
	Если СтрокаТаблицыЗначений <> Неопределено Тогда
		Если ТаблицаЗначенийЖурнала.Колонки.Найти("РазделениеДанныхСеанса") <> Неопределено Тогда
			ирКлиент.ОформитьЯчейкуСРасширеннымЗначениемЛкс(ОформлениеСтроки.Ячейки.РазделениеДанныхСеанса, СтрокаТаблицыЗначений.РазделениеДанныхСеанса, Элемент.Колонки.РазделениеДанныхСеанса);
		КонецЕсли; 
		Если ТипЗнч(СтрокаТаблицыЗначений.Метаданные) = Тип("Строка") Тогда
			КартинкаКорневогоТипа = ирКлиент.КартинкаКорневогоТипаМДЛкс(ирОбщий.ПервыйФрагментЛкс(СтрокаТаблицыЗначений.Метаданные));
			Если КартинкаКорневогоТипа.Вид <> ВидКартинки.Пустая Тогда
				ОформлениеСтроки.Ячейки.Метаданные.УстановитьКартинку(КартинкаКорневогоТипа);
			КонецЕсли; 
		Иначе
			ирКлиент.ОформитьЯчейкуСРасширеннымЗначениемЛкс(ОформлениеСтроки.Ячейки.Метаданные, СтрокаТаблицыЗначений.Метаданные, Элемент.Колонки.Метаданные);
		КонецЕсли; 
		ирКлиент.ОформитьЯчейкуСРасширеннымЗначениемЛкс(ОформлениеСтроки.Ячейки.Данные, СтрокаТаблицыЗначений.Данные, Элемент.Колонки.Данные);
		ирКлиент.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки,,,,, СтрокаТаблицыЗначений);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОтборПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт 
	
	ирКлиент.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
	СтрокаОтбора = ДанныеСтроки;
	ИспользованиеСтрокиОтбора = ИспользованиеСтрокиОтбора(СтрокаОтбора);
	Если ТипЗнч(ДанныеСтроки.Значение) = Тип("СписокЗначений") Тогда
		Если ДанныеСтроки.Значение.ТипЗначения.Типы().Количество() = 0 Тогда
			КоличествоПомеченных = Неопределено;
			ПредставлениеСтрокиОтбора = ПредставлениеСтрокиОтбора(ДанныеСтроки, КоличествоПомеченных);
			ИспользованиеСтрокиОтбора = ИспользованиеСтрокиОтбора И ЗначениеЗаполнено(ПредставлениеСтрокиОтбора);
			ОформлениеСтроки.Ячейки.Значение.УстановитьТекст("(" + КоличествоПомеченных + " из " + ДанныеСтроки.Значение.Количество() + ") " + ПредставлениеСтрокиОтбора);
		КонецЕсли;
	КонецЕсли; 
	Если ДанныеСтроки.Поле = "Данные" Тогда
		ирКлиент.ОформитьЯчейкуСРасширеннымЗначениемЛкс(ОформлениеСтроки.Ячейки.Значение,,, Истина);
	КонецЕсли; 
	Если Не ИспользованиеСтрокиОтбора Тогда
		ОформлениеСтроки.ЦветТекста = ирОбщий.ЦветТекстаНеактивностиЛкс();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирКлиент.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура КоманднаяПанельЖурналРегистрацииРедакторОбъектаБД(Кнопка)
	
	ТекущаяСтрока = ЭлементыФормы.ТаблицаЖурнала.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	СтрокаТаблицыЗначений = ТаблицаЗначенийЖурнала.Найти(ТекущаяСтрока.ПорядокСтроки, "ПорядокСтроки");
	Если Не ирОбщий.ЛиСсылкаНаОбъектБДЛкс(СтрокаТаблицыЗначений.Данные) Тогда
		Возврат
	КонецЕсли; 
	ирКлиент.ОткрытьСсылкуВРедактореОбъектаБДЛкс(СтрокаТаблицыЗначений.Данные);
	
КонецПроцедуры

Процедура КоманднаяПанельОтборАлгоритм(Кнопка)
	
	СтандартнаяОбработка = Ложь;
	СтруктураАлгоритма = ирОбщий.ОбъектИзСтрокиXMLЛкс(АлгоритмПередВыгрузкой);
	Результат = ирКлиент.РедактироватьАлгоритмЧерезСтруктуруЛкс(СтруктураАлгоритма, мАлгоритмПередВыгрузкойПараметры,,, "Алгоритм перед выгрузкой");
	Если Результат Тогда
		Если Не ЗначениеЗаполнено(СтруктураАлгоритма.ТекстАлгоритма) Тогда
			ЭтотОбъект.АлгоритмПередВыгрузкой = "";
		Иначе
			ЭтотОбъект.АлгоритмПередВыгрузкой = ирОбщий.ОбъектВСтрокуXMLЛкс(СтруктураАлгоритма);
		КонецЕсли; 
	КонецЕсли;
	НастроитьЭлементыФормы();
	
КонецПроцедуры

Процедура НастроитьЭлементыФормы()
	
	ЭлементыФормы.КоманднаяПанельОтбор.Кнопки.Алгоритм.Пометка = ЗначениеЗаполнено(АлгоритмПередВыгрузкой);

КонецПроцедуры

Процедура ОбновитьОтборПросмотра()
	
	ирОбщий.УстановитьОтборПоПодстрокеЛкс(ЭлементыФормы.ТаблицаЖурнала.ОтборСтрок.Комментарий, ФильтрКомментарий);

КонецПроцедуры

Процедура ФильтрКомментарийПриИзменении(Элемент)
	
	ирКлиент.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, КомментарийКлючХраненияПоследнихЗначений());
	ОбновитьОтборПросмотра();
	
КонецПроцедуры

Процедура ФильтрКомментарийНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_ОбновитьСписокЛкс(Элемент, КомментарийКлючХраненияПоследнихЗначений());
	
КонецПроцедуры

Процедура ФильтрКомментарийАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	
	ирКлиент.ПромежуточноеОбновлениеСтроковогоЗначенияПоляВводаЛкс(ЭтаФорма, Элемент, Текст);
	ОбновитьОтборПросмотра();
	
КонецПроцедуры

Процедура ОтборЗначениеНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_ОбновитьСписокЛкс(Элемент, КомментарийКлючХраненияПоследнихЗначений());
	
КонецПроцедуры

Функция КомментарийКлючХраненияПоследнихЗначений()
	
	КлючИстории = ирОбщий.КлючХраненияНастроекФормыЛкс(ЭтаФорма) + "." + ЭлементыФормы.ФильтрКомментарий.Имя;
	Возврат КлючИстории;

КонецФункции

ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирАнализЖурналаРегистрации.Форма.Форма");
СписокВыбора = ЭлементыФормы.МаксимальныйРазмерВыгрузки.СписокВыбора;
СписокВыбора.Добавить(100);
СписокВыбора.Добавить(1000);
СписокВыбора.Добавить(10000);
СписокВыбора.Добавить(100000);
СписокВыбора.Добавить(500000);
РазделительДлительности = "-";

СтруктураКолонокБезОтбора = Новый Структура();
СтруктураКолонокБезОтбора.Вставить("ПредставлениеПриложения", "ИмяПриложения");
СтруктураКолонокБезОтбора.Вставить("ПредставлениеСобытия", "Событие");
СтруктураКолонокБезОтбора.Вставить("ИмяПользователя", "Пользователь");
СтруктураКолонокБезОтбора.Вставить("Дата");
СтруктураКолонокБезОтбора.Вставить("Соединение");
СтруктураКолонокБезОтбора.Вставить("ПредставлениеМетаданных", "Метаданные");

МассивУровнейЖурнала = Новый Массив();
МассивУровнейЖурнала.Добавить("" + УровеньЖурналаРегистрации.Примечание);
МассивУровнейЖурнала.Добавить("" + УровеньЖурналаРегистрации.Информация);
МассивУровнейЖурнала.Добавить("" + УровеньЖурналаРегистрации.Предупреждение);
МассивУровнейЖурнала.Добавить("" + УровеньЖурналаРегистрации.Ошибка);

