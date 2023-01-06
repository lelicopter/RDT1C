﻿Перем ОсновнойЭУ;
Перем мПлатформа;

Функция СохраняемаяНастройкаФормы(выхНаименование, выхИменаСвойств) Экспорт 
	выхИменаСвойств = "";
	выхИменаСвойств = выхИменаСвойств + ",ПодсветкаСтрок";
КонецФункции

Процедура ЗагрузитьНастройкуВФорме(НастройкаФормы, ДопПараметры) Экспорт 
	
	ирОбщий.ЗагрузитьНастройкуФормыЛкс(ЭтаФорма, НастройкаФормы); 
	НастроитьЭлементыФормы();
	
КонецПроцедуры

Процедура КоманднаяПанельСпискаПользователейЖурналРегистрации(Кнопка)
	
	ТекущаяСтрока = ОсновнойЭУ.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	АнализЖурналаРегистрации = ирОбщий.СоздатьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирАнализЖурналаРегистрации");
	#Если Сервер И Не Сервер Тогда
		АнализЖурналаРегистрации = Обработки.ирАнализЖурналаРегистрации.Создать();
	#КонецЕсли
	АнализЖурналаРегистрации.ОткрытьСПараметром("Пользователь", Новый УникальныйИдентификатор(ТекущаяСтрока.УникальныйИдентификатор), ТекущаяСтрока.Имя);

КонецПроцедуры

Процедура ПриОткрытии()
	
	ирОбщий.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ирОбщий.СоздатьМенеджерСохраненияНастроекФормыЛкс(ЭтаФорма);
	мПлатформа = ирКэш.Получить();
	ОбновитьДоступныеРоли();
	Если РазделениеДанных.Количество() = 0 Тогда
		Для Каждого ОбщийРеквизит Из Метаданные.ОбщиеРеквизиты Цикл
			Если ОбщийРеквизит.РазделениеДанных = Метаданные.СвойстваОбъектов.РазделениеДанныхОбщегоРеквизита.Разделять Тогда
				СтрокаРазделителя = РазделениеДанных.Добавить();
				СтрокаРазделителя.Разделитель = ОбщийРеквизит.Имя;
				СтрокаРазделителя.Представление = ОбщийРеквизит.Представление();
			КонецЕсли; 
		КонецЦикла;
	КонецЕсли; 
	НастройкаОтбораСтрок = ОсновнойЭУ.НастройкаОтбораСтрок;
	Для каждого НастройкаОтбораСтроки Из НастройкаОтбораСтрок Цикл
		НастройкаОтбораСтроки.Доступность = Истина;
	КонецЦикла; 
	ИсторияОтборов = Новый Массив;
	Если ирКэш.НомерВерсииПлатформыЛкс() < 803016 Тогда
		ЭлементыФормы.Пользователи.Колонки.ДатаБлокировки.Видимость = Ложь;
		ЭлементыФормы.Пользователи.Колонки.ДатаБлокировки.ИзменятьВидимость = Ложь;
		ЭлементыФормы.КоманднаяПанельСпискаПользователей.Кнопки.Разблокировать.Доступность = Не ирКэш.ЛиПортативныйРежимЛкс(); // Антибаг платформы 8.3.22 https://www.hostedredmine.com/issues/948691
	КонецЕсли;
	УправлениеСпискомПользователей_ОбновитьСписокПользователей();
	ОбработатьПараметрИмяПользователя();
	ОсновнойЭУ.Значение.Сортировать("Имя");
	Если ЗначениеЗаполнено(НачальноеЗначениеВыбора) Тогда
		СтрокаПользователя = Пользователи.Найти(НачальноеЗначениеВыбора, "Имя");
		Если СтрокаПользователя <> Неопределено Тогда
			ЭлементыФормы.Пользователи.ТекущаяСтрока = СтрокаПользователя;
		КонецЕсли; 
	КонецЕсли;
	ирОбщий.ДописатьРежимВыбораВЗаголовокФормыЛкс(ЭтаФорма);
	Если Метаданные.Справочники.Найти("Пользователи") = Неопределено Тогда
		ЭлементыФормы.Пользователи.Колонки.Ссылка.Видимость = Ложь;
	КонецЕсли;
	ОбновитьПодменюПоследниеВыбранные();
	Если Пользователи.Количество() < 10 Тогда
		ЭтаФорма.ТекущийЭлемент = ЭлементыФормы.Пользователи;
	КонецЕсли; 

КонецПроцедуры

Процедура ОбработатьПараметрИмяПользователя()
	
	Если ЗначениеЗаполнено(ЭтаФорма.ПараметрИмяПользователя) Тогда
		СтрокаПользователя = ОсновнойЭУ.Значение.Найти(ЭтаФорма.ПараметрИмяПользователя, "Имя");
		Если СтрокаПользователя <> Неопределено Тогда
			ОсновнойЭУ.ТекущаяСтрока = СтрокаПользователя;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Функция УправлениеСпискомПользователей_ОбновитьСписокПользователей(Знач УникальныйИдентификатор = "") Экспорт
	
	СостояниеСтрокТаблицы = ирОбщий.ТабличноеПолеСостояниеСтрокЛкс(ОсновнойЭУ, "УникальныйИдентификатор");
	ПользователиИнфобазы = ПользователиИнформационнойБазы.ПолучитьПользователей();
	//ПользователиИнфобазы.Добавить(ПользователиИнформационнойБазы.НайтиПоИмени("")); // Смыла в этом нет
	Разница = ПользователиИнфобазы.Количество() - ОсновнойЭУ.Значение.Количество();
	Если Разница > 0  Тогда
		Для Счетчик = 1 По Разница Цикл
			ОсновнойЭУ.Значение.Добавить();
		КонецЦикла; 
	ИначеЕсли Разница < 0 Тогда
		Для Счетчик = 1 По -Разница Цикл
			ОсновнойЭУ.Значение.Удалить(ОсновнойЭУ.Значение.Количество()-1);
		КонецЦикла; 
	КонецЕсли; 
	Счетчик = 0;
	СсылкиПользователей = СсылкиПользователей();
	Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(Пользователи.Количество(), "Чтение");
	Для каждого Пользователь Из ПользователиИнфобазы Цикл
		ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
		ТекущиеДанные = ОсновнойЭУ.Значение[Счетчик];
		УправлениеСпискомПользователей_ОбновитьСтрокуПользователя(Пользователь, ТекущиеДанные, СсылкиПользователей);
		Счетчик = Счетчик + 1;
	КонецЦикла;
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	ОсновнойЭУ.Значение.Сортировать("Имя");
	ирОбщий.ТабличноеПолеВосстановитьСостояниеСтрокЛкс(ОсновнойЭУ, СостояниеСтрокТаблицы);
	ЭтаФорма.Обновить();
	
КонецФункции

Функция УправлениеСпискомПользователей_ОбновитьСтрокуПользователя(Знач Пользователь = Неопределено, Знач ТекущиеДанные, Знач СсылкиПользователей = Неопределено)
	
	#Если Сервер И Не Сервер Тогда
		ТекущиеДанные = Пользователи.Добавить();
	#КонецЕсли
	Если Пользователь = Неопределено Тогда
		Пользователь = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(Новый УникальныйИдентификатор(ТекущиеДанные.УникальныйИдентификатор));
	Иначе
		ТекущиеДанные.Имя = Пользователь.Имя;
	КонецЕсли; 
	ТекущиеДанные.ПолноеИмя = Пользователь.ПолноеИмя;
	ТекущиеДанные.ПарольУстановлен = Пользователь.ПарольУстановлен;
	ТекущиеДанные.ПоказыватьВСпискеВыбора = Пользователь.ПоказыватьВСпискеВыбора;
	ТекущиеДанные.АутентификацияСтандартная = Пользователь.АутентификацияСтандартная;
	ТекущиеДанные.АутентификацияОС = Пользователь.АутентификацияОС;
	ТекущиеДанные.АутентификацияOpenID = Пользователь.АутентификацияOpenID;
	Попытка
		ТекущиеДанные.ПользовательОС = Пользователь.ПользовательОС;
	Исключение
		ТекущиеДанные.ПользовательОС = "<Неверные данные>";
	КонецПопытки; 
	Если Пользователь.Язык = Неопределено Тогда
		ТекущиеДанные.Язык = "";
		ТекущиеДанные.ЯзыкПредставление = "";
	Иначе
		ТекущиеДанные.Язык = Пользователь.Язык.Имя;
		ТекущиеДанные.ЯзыкПредставление = Пользователь.Язык;
	КонецЕсли; 
	Если Пользователь.ОсновнойИнтерфейс = Неопределено Тогда
		ТекущиеДанные.ОсновнойИнтерфейс = "";
		ТекущиеДанные.ОсновнойИнтерфейсПредставление = "";
	Иначе
		ТекущиеДанные.ОсновнойИнтерфейс = Пользователь.ОсновнойИнтерфейс.Имя;
		ТекущиеДанные.ОсновнойИнтерфейсПредставление = Пользователь.ОсновнойИнтерфейс;
	КонецЕсли; 
	РезультатРоли = Новый СписокЗначений;
	Для каждого Роль Из Пользователь.Роли Цикл
		РезультатРоли.Добавить(Роль.Имя,Роль);
	КонецЦикла; 
	РезультатРоли.СортироватьПоЗначению();
	РезультатИмена         = "";
	РезультатПредставление = "";
	Для каждого Роль Из РезультатРоли Цикл
		РезультатИмена         = РезультатИмена+Роль.Значение+", ";
		РезультатПредставление = РезультатПредставление+Роль.Представление+", ";
	КонецЦикла; 
	ТекущиеДанные.РолиИмена = Сред(РезультатИмена,1,СтрДлина(РезультатИмена)-2);
	ТекущиеДанные.РолиПредставление = Сред(РезультатПредставление,1,СтрДлина(РезультатПредставление)-2);
	ТекущиеДанные.УникальныйИдентификатор = Пользователь.УникальныйИдентификатор;
	ТекущиеДанные.СохраняемоеЗначениеПароля = Пользователь.СохраняемоеЗначениеПароля;
	ТекущиеДанные.РежимЗапуска = Пользователь.РежимЗапуска;
	Если ирКэш.ДоступнаЗащитаОтОпасныхДействийЛкс() Тогда
		ТекущиеДанные.ЗащитаОтОпасныхДействий = Пользователь.ЗащитаОтОпасныхДействий.ПредупреждатьОбОпасныхДействиях;
	КонецЕсли;
	Если ирКэш.ДоступноВосстановлениеПароляПользователямЛкс() Тогда
		ТекущиеДанные.АдресЭлектроннойПочты = Пользователь.АдресЭлектроннойПочты;
		ТекущиеДанные.ЗапрещеноВосстанавливатьПароль = Пользователь.ЗапрещеноВосстанавливатьПароль;
	КонецЕсли; 
	Если РазделениеДанных.Количество() > 0 Тогда
		ТекущиеДанные.РазделениеДанныхПредставление = ирОбщий.РасширенноеПредставлениеЗначенияЛкс(Пользователь.РазделениеДанных);
	КонецЕсли;  
	ТекущиеДанные.Ссылка = Неопределено;
	Если СсылкиПользователей <> Неопределено Тогда
		СтрокаСсылки = СсылкиПользователей.Найти(Пользователь.УникальныйИдентификатор, "ИдентификаторПользователяИБ");
		Если СтрокаСсылки <> Неопределено Тогда
			ТекущиеДанные.Ссылка = СтрокаСсылки.Ссылка;
		КонецЕсли; 
	КонецЕсли;
	НастройкиКлиентскогоПриложения = ХранилищеСистемныхНастроек.Загрузить("Общее/НастройкиКлиентскогоПриложения",,, Пользователь.Имя);
	Если НастройкиКлиентскогоПриложения = Неопределено Тогда
		НастройкиКлиентскогоПриложения = Новый НастройкиКлиентскогоПриложения;
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, НастройкиКлиентскогоПриложения); 
	Если ЭлементыФормы.Пользователи.Колонки.ДатаБлокировки.Видимость Тогда
		МоментНачала = ирОбщий.ТекущееВремяВМиллисекундахЛкс();
		БлокировкаПользователя = БлокировкаПользователя(Пользователь.Имя);
		ДлительностьМС = ирОбщий.ТекущееВремяВМиллисекундахЛкс() - МоментНачала;
		Если ДлительностьМС * Пользователи.Количество() > 5000 Тогда
			// https://www.hostedredmine.com/issues/951192
			ЭлементыФормы.Пользователи.Колонки.ДатаБлокировки.Видимость = Ложь;
			ирОбщий.СообщитьЛкс(ирОбщий.СтрШаблонЛкс("Колонка ""%1"" не будет заполнена и скрыта, т.е. ее заполнение происходит очень долго", ЭлементыФормы.Пользователи.Колонки.ДатаБлокировки.ТекстШапки));
		КонецЕсли;
		Если БлокировкаПользователя = Неопределено Тогда
			ТекущиеДанные.ДатаБлокировки = Неопределено;
		Иначе
			ТекущиеДанные.ДатаБлокировки = БлокировкаПользователя.ВремяНачалаБлокировки;
		КонецЕсли;
	КонецЕсли;
	УправлениеСпискомПользователей_УстановитьОтборПоРолям(ТекущиеДанные);
	
КонецФункции

Функция БлокировкаПользователя(Знач ИмяПользователя)
	
	БлокировкаАутентификацииМой = Вычислить("БлокировкаАутентификации");
	#Если Сервер И Не Сервер Тогда
		БлокировкаАутентификацииМой = БлокировкаАутентификации;
	#КонецЕсли
	БлокировкаПользователя = БлокировкаАутентификацииМой.ПолучитьБлокировки(Новый Структура("ИмяПользователя", ИмяПользователя));
	Если БлокировкаПользователя.Количество() > 0 Тогда
		БлокировкаПользователя = БлокировкаПользователя[0];
	Иначе
		БлокировкаПользователя = Неопределено;
	КонецЕсли;
	Возврат БлокировкаПользователя;

КонецФункции

Функция УправлениеСпискомПользователей_УстановитьОтборПоРолям(Знач ТекущиеДанные) Экспорт
	
	ОтборСтрок = ОсновнойЭУ.ОтборСтрок;
	Если ОтборСтрок.ОтборПоРолям.Использование = ложь Тогда
		Возврат Неопределено;
	КонецЕсли; 
	ВходитВОтборПоРолям = Ложь;
	Попытка
		СтруктураОтбораРолей = Новый Структура(ОтборСтрок.Роли.Значение);
		СтруктураРолей = Новый Структура(ТекущиеДанные.Роли);
		Для каждого КлючИЗначение Из СтруктураОтбораРолей Цикл
			Если СтруктураРолей.Свойство(КлючИЗначение.Ключ) Тогда
				ВходитВОтборПоРолям = Истина;
				Прервать;
			КонецЕсли; 
		КонецЦикла; 
	Исключение
	КонецПопытки; 
	ТекущиеДанные.ОтборПоРолям = ВходитВОтборПоРолям;
	
КонецФункции

Процедура ПользователиПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	РедактироватьПользователя(Элемент);
	
КонецПроцедуры

Процедура КоманднаяПанельСпискаПользователейОбновить(Кнопка)
	
	УправлениеСпискомПользователей_ОбновитьСписокПользователей();
	
КонецПроцедуры

Процедура ПользователиПриПолученииДанных(Элемент, ОформленияСтрок)
	
	Если ПодсветкаСтрок <> Ложь Тогда
		Сеансы = ПолучитьСеансыИнформационнойБазы(); // Иногда выполняется долго
	КонецЕсли;
	// Оптимизировать
	Для Каждого ОформлениеСтроки Из ОформленияСтрок Цикл
		ДанныеСтроки = ОформлениеСтроки.ДанныеСтроки;
		Если Сеансы <> Неопределено Тогда
			Для Каждого Сеанс Из Сеансы Цикл
				Если Сеанс.Пользователь = Неопределено Тогда
					Продолжить;
				КонецЕсли; 
				Если ирОбщий.СтрокиРавныЛкс(Сеанс.Пользователь.УникальныйИдентификатор, ДанныеСтроки.УникальныйИдентификатор) Тогда
					ОформлениеСтроки.ЦветФона = Новый Цвет(235, 255, 255);
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли; 
		Если ирОбщий.СтрокиРавныЛкс(ИмяПользователя(), ДанныеСтроки.Имя) Тогда
			ОформлениеСтроки.ЦветТекста = ирОбщий.ЦветТекстаТекущегоЭлементаЛкс();
		КонецЕсли; 
		ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
		ОформлениеСтроки.Ячейки.НастройкиУправляемогоПриложения.Видимость = Ложь;
	КонецЦикла; 
	
КонецПроцедуры

Процедура КоманднаяПанельСпискаПользователейЗапуститьПодПользователем(Кнопка)
	
	Если ОсновнойЭУ.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	УникальныйИдентификатор = Новый УникальныйИдентификатор(ОсновнойЭУ.ТекущаяСтрока.УникальныйИдентификатор);
	ФормаЗапуска = ЭтотОбъект.ПолучитьФорму("ЗапускПодПользователем",, УникальныйИдентификатор);
	ФормаЗапуска.ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(УникальныйИдентификатор);
	Если ФормаЗапуска.ПользовательИБ = Неопределено Тогда
		УправлениеСпискомПользователей_ОбновитьСписокПользователей();
		Возврат;
	КонецЕсли;
	ирОбщий.ОткрытьФормуВМинимальномРазмереЛкс(ФормаЗапуска);
	
КонецПроцедуры

Процедура КоманднаяПанельСпискаПользователейТехноЖурнал(Кнопка)
	
	ТекущаяСтрока = ОсновнойЭУ.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ирОбщий.ПолучитьФормуЛкс("Обработка.ирАнализТехножурнала.Форма").ОткрытьСОтбором(, , Новый Структура("Пользователь", ТекущаяСтрока.Имя));
	
КонецПроцедуры

Процедура ПользователиПередНачаломДобавления(Элемент, Отказ, Копирование)
	
	Отказ = Истина;
	ФормаРедактированияПользователя = ПолучитьФорму("ПользовательИнфобазы");
	Если Копирование Тогда
		ФормаРедактированияПользователя.ПользовательДляКопированияНастроек = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(Новый УникальныйИдентификатор(Элемент.ТекущаяСтрока.УникальныйИдентификатор));
	КонецЕсли; 
	ФормаРедактированияПользователя.Открыть();

КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ПользователиПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	ВыделенныеСтроки = ЭлементыФормы.Пользователи.ВыделенныеСтроки;
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли; 
	Ответ = Вопрос("Вы действительно хотите удалить выделенных (" + ВыделенныеСтроки.Количество() + ") пользователей?", РежимДиалогаВопрос.ОКОтмена);
	Если Ответ = КодВозвратаДиалога.ОК Тогда
		Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
			ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(Новый УникальныйИдентификатор(ВыделеннаяСтрока.УникальныйИдентификатор)).Удалить();
		КонецЦикла;
		УправлениеСпискомПользователей_ОбновитьСписокПользователей();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	КоличествоПользователей = ОсновнойЭУ.Значение.Количество();

КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	Если ТипЗнч(Параметр) = Тип("ПользовательИнформационнойБазы") Тогда
		Если ИмяСобытия = "ЗаписанОбъект" Тогда
			УправлениеСпискомПользователей_ОбновитьСписокПользователей(); 
		КонецЕсли;
		ПоследниеВыбранныеДобавить(Параметр.УникальныйИдентификатор);
	КонецЕсли;
	ирОбщий.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура КоманднаяПанельСпискаПользователейИзменениеВыбранных(Кнопка = Неопределено)
	
	ФормаУстановкиНастроек = ПолучитьФорму("ИзменениеВыбранныхПользователей");
	Если ЭлементыФормы.Пользователи.ТекущаяСтрока <> Неопределено Тогда
		ФормаУстановкиНастроек.ПараметрИмяПользователя = ЭлементыФормы.Пользователи.ТекущаяСтрока.Имя;
	КонецЕсли;
	ПараметрИменаПользователей = Новый Массив;
	Для Каждого ВыделеннаяСтрока Из ЭлементыФормы.Пользователи.ВыделенныеСтроки Цикл
		ПараметрИменаПользователей.Добавить(ВыделеннаяСтрока.Имя);
	КонецЦикла;
	ФормаУстановкиНастроек.ПараметрИменаПользователей = ПараметрИменаПользователей;
	РезультатФормы = ФормаУстановкиНастроек.ОткрытьМодально();
	Если РезультатФормы = Истина Тогда 
		УправлениеСпискомПользователей_ОбновитьСписокПользователей();
	КонецЕсли;
	
КонецПроцедуры

Процедура КоманднаяПанельСпискаПользователейОбработатьВКонсолиКода(Кнопка)
	
	ВыделенныеПользователи = Новый Массив;
	Для Каждого ВыделеннаяСтрока Из ЭлементыФормы.Пользователи.ВыделенныеСтроки Цикл
		ВыделенныеПользователи.Добавить(ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(Новый УникальныйИдентификатор(ВыделеннаяСтрока.УникальныйИдентификатор)));
	КонецЦикла;
	СтруктураПараметров = Новый Структура("ВыделенныеПользователи", ВыделенныеПользователи);
	ТекстАлгоритма = "Для Каждого Пользователь Из ВыделенныеПользователи Цикл
	|	//: Пользователь = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору();
	|
	|КонецЦикла;";
	ирОбщий.ОперироватьСтруктуройЛкс(ТекстАлгоритма, , СтруктураПараметров);
	
КонецПроцедуры

Процедура ПользователиВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если РежимВыбора Тогда
		Закрыть(ВыбраннаяСтрока.Имя);
	Иначе
		Если Колонка = ЭлементыФормы.Пользователи.Колонки.Ссылка Тогда
			ОткрытьЗначение(ВыбраннаяСтрока[Колонка.Данные]);
		ИначеЕсли Ложь
			Или Колонка = ЭлементыФормы.Пользователи.Колонки.ВариантМасштабаФормКлиентскогоПриложения 
			Или Колонка = ЭлементыФормы.Пользователи.Колонки.ВариантИнтерфейсаКлиентскогоПриложения
			Или Колонка = ЭлементыФормы.Пользователи.Колонки.ОтображатьПанелиНавигацииИДействий
			Или Колонка = ЭлементыФормы.Пользователи.Колонки.ОтображатьПанельРазделов
			Или Колонка = ЭлементыФормы.Пользователи.Колонки.СкоростьКлиентскогоСоединения
			Или Колонка = ЭлементыФормы.Пользователи.Колонки.РежимОткрытияФормПриложения
		Тогда
			КоманднаяПанельСпискаПользователейИзменениеВыбранных();
		Иначе
			РедактироватьПользователя(Элемент);
		КонецЕсли; 
	КонецЕсли; 

КонецПроцедуры

Процедура РедактироватьПользователя(Знач Элемент)
	
	ФормаРедактированияПользователя = ПолучитьФорму("ПользовательИнфобазы",, Элемент.ТекущаяСтрока.УникальныйИдентификатор);
	ФормаРедактированияПользователя.ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(Новый УникальныйИдентификатор(Элемент.ТекущаяСтрока.УникальныйИдентификатор));
	ФормаРедактированияПользователя.Открыть();

КонецПроцедуры

Процедура КоманднаяПанельСпискаПользователейПодсветитьАктивныеСеансы(Кнопка = Неопределено)
	ЭтаФорма.ПодсветкаСтрок = НЕ ПодсветкаСтрок;
	НастроитьЭлементыФормы();
КонецПроцедуры

Процедура НастроитьЭлементыФормы()
	
	ЭлементыФормы.КоманднаяПанельСпискаПользователей.Кнопки.ПодсветитьАктивныеСеансы.Пометка = ПодсветкаСтрок;

КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);

КонецПроцедуры

Процедура КоманднаяПанельСпискаПользователейАнализПравДоступа(Кнопка)
	
	Если ЭлементыФормы.Пользователи.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ФормаОтчета = ирОбщий.ПолучитьФормуЛкс("Отчет.ирАнализПравДоступа.Форма",,, ЭлементыФормы.Пользователи.ТекущаяСтрока.Имя);
	ФормаОтчета.Пользователь = ЭлементыФормы.Пользователи.ТекущаяСтрока.Имя;
	ФормаОтчета.ПараметрКлючВарианта = "ПоМетаданным";
	ФормаОтчета.Открыть();
	
КонецПроцедуры

Процедура ПриПовторномОткрытии(СтандартнаяОбработка)
	
	ОбработатьПараметрИмяПользователя();
	
КонецПроцедуры

Процедура ПользователиПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);

КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирОбщий.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура КоманднаяПанельСпискаПользователейРедакторХранилищНастроек(Кнопка)
	
	Если ЭлементыФормы.Пользователи.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ФормаОтчета = ирОбщий.ПолучитьФормуЛкс("Обработка.ирРедакторХранилищНастроек.Форма",,, ЭлементыФормы.Пользователи.ТекущаяСтрока.Имя);
	ФормаОтчета.Пользователь = ЭлементыФормы.Пользователи.ТекущаяСтрока.Имя;
	ФормаОтчета.Открыть();
	
КонецПроцедуры

Процедура ПользователиПриАктивизацииКолонки(Элемент)
	ирОбщий.ТабличноеПолеПриАктивацииКолонкиЛкс(ЭтаФорма, Элемент);
КонецПроцедуры

Функция ПоследниеВыбранныеНажатие(Кнопка) Экспорт
	
	ирОбщий.ПоследниеВыбранныеНажатиеЛкс(ЭтаФорма, ЭлементыФормы.Пользователи, Метаданные().ТабличныеЧасти.Пользователи.Реквизиты.УникальныйИдентификатор.Имя, Кнопка);
	
КонецФункции

Процедура ПоследниеВыбранныеДобавить(Знач УникальныйИдентификатор) Экспорт 
	УникальныйИдентификатор = "" + УникальныйИдентификатор;
	СтрокаПользователя = Пользователи.Найти(УникальныйИдентификатор, "УникальныйИдентификатор");
	ирОбщий.ПоследниеВыбранныеДобавитьЛкс(ЭтаФорма, СтрокаПользователя.УникальныйИдентификатор, СтрокаПользователя.Имя, ЭлементыФормы.Пользователи);
	ОбновитьПодменюПоследниеВыбранные();
КонецПроцедуры   

Процедура ОбновитьПодменюПоследниеВыбранные()
	ирОбщий.ПоследниеВыбранныеЗаполнитьПодменюЛкс(ЭтаФорма, ЭлементыФормы.КоманднаяПанельСпискаПользователей.Кнопки.ПоследниеВыбранные, ЭлементыФормы.Пользователи);
КонецПроцедуры

Процедура КоманднаяПанельСпискаПользователейРазблокировать(Кнопка)

	Для Каждого ВыделеннаяСтрока Из ЭлементыФормы.Пользователи.ВыделенныеСтроки Цикл
		Если ЗначениеЗаполнено(ВыделеннаяСтрока.ДатаБлокировки) Тогда
			// Антибаг платформы 8.3.22 https://www.hostedredmine.com/issues/948691
			//БлокировкаПользователя = БлокировкаПользователя(ВыделеннаяСтрока.Имя);
			//Если БлокировкаПользователя <> Неопределено Тогда
			//	БлокировкаПользователя.Разблокировать();
			//КонецЕсли;
			ирСервер.РазблокироватьАутентифкациюЛкс(ВыделеннаяСтрока.Имя);

			УправлениеСпискомПользователей_ОбновитьСтрокуПользователя(, ВыделеннаяСтрока);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбновитьОтбор()
	
	Реквизиты = Метаданные().ТабличныеЧасти.Пользователи.Реквизиты;
	КолонкиПоиска = Новый Структура;
	КолонкиПоиска.Вставить(Реквизиты.Имя.Имя);
	КолонкиПоиска.Вставить(Реквизиты.ПолноеИмя.Имя);
	КолонкиПоиска.Вставить(Реквизиты.АдресЭлектроннойПочты.Имя);
	ирОбщий.ТабличноеПолеСДаннымиПоискаУстановитьОтборПоПодстрокеЛкс(ЭтаФорма, ЭлементыФормы.Пользователи, ПодстрокаПоиска, КолонкиПоиска);

КонецПроцедуры

Процедура ПодстрокаПоискаПриИзменении(Элемент)
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
	ОбновитьОтбор();
КонецПроцедуры

Процедура ПодстрокаПоискаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, ЭтаФорма);
КонецПроцедуры

Процедура ПодстрокаПоискаАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	Если ирОбщий.ПромежуточноеОбновлениеСтроковогоЗначенияПоляВводаЛкс(ЭтаФорма, Элемент, Текст) Тогда 
		ОбновитьОтбор();
	КонецЕсли;
КонецПроцедуры

ирОбщий.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирРедакторПользователей.Форма.Форма");
ОсновнойЭУ = ЭлементыФормы.Пользователи;
