﻿Перем ЛиНазад;
Перем ЛиОбработкаСобытия;
Перем Запрос;
Перем СтруктураКлюча;
Перем ПодходящиеСлова;
Перем РазмерГруппы;
Перем СтрокаСловаРезультата Экспорт;
Перем СтруктураТипаКонтекста Экспорт;
Перем ВКОбщая;

Процедура ОбновлениеОтображения()
	
	Если ВКОбщая <> Неопределено Тогда
		ЭтаФорма.Активизировать();
		Если ВводДоступен() Тогда
			Если ВКОбщая <> "" Тогда
				РазрешитьВыходЗаГраницыЭкрана = Не МодальныйРежим;
				ВКОбщая.ПереместитьОкноВПозициюКаретки(РазрешитьВыходЗаГраницыЭкрана);
			КонецЕсли;
			ВКОбщая = Неопределено;  
			Если ВладелецФормы <> Неопределено Тогда
				ВладелецФормы.Активизировать();
			КонецЕсли;
			УстановитьГраницыВыделенияФильтра();
		КонецЕсли;
	КонецЕсли; 

КонецПроцедуры

Процедура ПодходящиеСловаВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ЭтаФорма.СтрокаСловаРезультата = ВыбраннаяСтрока;
	ЗакрытьИВставитьСлово();
	
КонецПроцедуры

Процедура ЗакрытьИВставитьСлово(ПараметрЗакрытия = Истина) Экспорт 
	
	Если МодальныйРежим Тогда
		Если Не Открыта() Тогда
			ОповеститьОВыборе(Истина); // Аналог Закрыть(), но Закрыть() нельзя здесь вызывать
		Иначе
			Закрыть(ПараметрЗакрытия);
		КонецЕсли;
	Иначе
		Если Открыта() Тогда
			Закрыть();
		КонецЕсли;
		ВставитьВыбранноеСловоАвтодополнения(СтрокаСловаРезультата,, ПараметрЗакрытия);
	КонецЕсли;

КонецПроцедуры

Процедура НайтиПодходящиеСлова(ТекущееСлово, ЛиНашли, ПерваяПодходящаяСтрока)

	#Если Сервер И Не Сервер Тогда
		ПодходящиеСлова = ТаблицаСлов;
	#КонецЕсли
	ЛиНашли = Ложь;
	ДлинаТекущегоСлова = СтрДлина(ТекущееСлово);
	СтрокаМаксимальногоРейтинга = Неопределено;
	// Здесь в таблицу ПодходящиеСлова можно добавить колонку ИндексСлово = Лев(НСлово, 3) для ускорения поиска
	Если ирКэш.РежимОтладкиЛкс() Тогда 
		// Пассивный оригинал расположенного ниже однострочного кода. Выполняйте изменения синхронно в обоих вариантах.
		Для Каждого СтрокаСлова Из ПодходящиеСлова Цикл
			НСлово = СтрокаСлова.НСлово;
			Если СтрДлина(НСлово) < ДлинаТекущегоСлова Тогда 
				Продолжить;
			КонецЕсли;
			Если Лев(СтрокаСлова.НСлово, ДлинаТекущегоСлова) = Нрег(ТекущееСлово) Тогда
				ЛиНашли = Истина;
				Если СтрокаМаксимальногоРейтинга = Неопределено Тогда
					СтрокаМаксимальногоРейтинга = СтрокаСлова;
					ПерваяПодходящаяСтрока = СтрокаСлова;
					Если Ложь
						Или ДлинаТекущегоСлова = 0
						Или ДлинаТекущегоСлова = СтрДлина(СтрокаСлова.Слово) 
					Тогда
						Прервать;
					КонецЕсли;
					ДлинаСловРейтинга = СтрДлина(СтрокаСлова.Слово);
				Иначе
					Если СтрДлина(СтрокаСлова.Слово) <= ДлинаСловРейтинга Тогда
						Если СтрокаМаксимальногоРейтинга.Рейтинг < СтрокаСлова.Рейтинг Тогда
							СтрокаМаксимальногоРейтинга = СтрокаСлова;
						КонецЕсли;
					КонецЕсли; 
				КонецЕсли;
			ИначеЕсли ЛиНашли Тогда 
				Прервать; 
			ИначеЕсли СтрокаСлова.НСлово > ТекущееСлово Тогда 
				ПерваяПодходящаяСтрока = СтрокаСлова;
				Прервать; 
			КонецЕсли;
		КонецЦикла;
	Иначе
		// Однострочный код использован для ускорения. Выше расположен оригинал. Выполняйте изменения синхронно в обоих вариантах. Преобразовано консолью кода из подсистемы "Инструменты разработчика" (http://devtool1c.ucoz.ru)
		Для Каждого СтрокаСлова Из ПодходящиеСлова Цикл  		НСлово = СтрокаСлова.НСлово;  		Если СтрДлина(НСлово) < ДлинаТекущегоСлова Тогда  			Продолжить;  		КонецЕсли;  		Если Лев(СтрокаСлова.НСлово, ДлинаТекущегоСлова) = Нрег(ТекущееСлово) Тогда  			ЛиНашли = Истина;  			Если СтрокаМаксимальногоРейтинга = Неопределено Тогда  				СтрокаМаксимальногоРейтинга = СтрокаСлова;  				ПерваяПодходящаяСтрока = СтрокаСлова;  				Если Ложь  					Или ДлинаТекущегоСлова = 0  					Или ДлинаТекущегоСлова = СтрДлина(СтрокаСлова.Слово)  				Тогда  					Прервать;  				КонецЕсли;  				ДлинаСловРейтинга = СтрДлина(СтрокаСлова.Слово);  			Иначе  				Если СтрДлина(СтрокаСлова.Слово) <= ДлинаСловРейтинга Тогда  					Если СтрокаМаксимальногоРейтинга.Рейтинг < СтрокаСлова.Рейтинг Тогда  						СтрокаМаксимальногоРейтинга = СтрокаСлова;  					КонецЕсли;  				КонецЕсли;  			КонецЕсли;  		ИначеЕсли ЛиНашли Тогда  			Прервать;  		ИначеЕсли СтрокаСлова.НСлово > ТекущееСлово Тогда  			ПерваяПодходящаяСтрока = СтрокаСлова;  			Прервать;  		КонецЕсли;  	КонецЦикла;  
	КонецЕсли; 
	Если СтрокаМаксимальногоРейтинга = Неопределено Тогда
		СтрокаМаксимальногоРейтинга = ПерваяПодходящаяСтрока;
	КонецЕсли; 
	Если СтрокаМаксимальногоРейтинга <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(СтруктураКлюча, СтрокаМаксимальногоРейтинга);
		НайденныеСтроки = ТаблицаСлов.НайтиСтроки(СтруктураКлюча);
		Если НайденныеСтроки.Количество() > 0 Тогда
			ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока = НайденныеСтроки[0];
		КонецЕсли; 
	КонецЕсли;

КонецПроцедуры

Процедура ПодобратьСтроку(ЛиПередОткрытием = Ложь, НачальнаяСтрока = Неопределено)
	
	Если ЛиОбработкаСобытия Тогда
		Возврат;
	КонецЕсли; 
	ЛиОбработкаСобытия = Истина;
	Если ЛиНазад Тогда
		Если НачальнаяСтрока = Неопределено Тогда
			НачальнаяСтрока = ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока;
		КонецЕсли; 
		// Найдем предыдущую максимальную общую часть подходящих слов
		Если НачальнаяСтрока <> Неопределено Тогда
			ЗаполнитьЗначенияСвойств(СтруктураКлюча, НачальнаяСтрока);
		Иначе
			СтруктураКлюча.Слово = ТекущееСлово;
			СтруктураКлюча.НСлово = НРег(ТекущееСлово);
			СтруктураКлюча.Рейтинг = -1;
		КонецЕсли; 
		НайденныеСтроки = ПодходящиеСлова.НайтиСтроки(СтруктураКлюча);
		Если НайденныеСтроки.Количество() > 0 Тогда
			СтрокаСлова = НайденныеСтроки[0];
			ДлинаОбщейЧасти = СтрДлина(ТекущееСлово) + 1;
			СимволОдинаковый = Истина;
			СледующееНСлово = "";
			Если ПодходящиеСлова.Индекс(СтрокаСлова) < ПодходящиеСлова.Количество() - 1 Тогда
				Для Индекс = ПодходящиеСлова.Индекс(СтрокаСлова) + 1 По ПодходящиеСлова.Количество() - 1 Цикл
					СледующееНСлово = ПодходящиеСлова[Индекс].НСлово;
					Если Лев(ПодходящиеСлова[Индекс].НСлово, ДлинаОбщейЧасти) <> Лев(СтрокаСлова.НСлово, ДлинаОбщейЧасти) Тогда 
						СимволОдинаковый = Ложь;
						Прервать;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
			Если СимволОдинаковый Тогда
				СледующееНСлово = "";
			КонецЕсли;
				
			СимволОдинаковый = Истина;
			ПредыдущееНСлово = "";
			Если ПодходящиеСлова.Индекс(СтрокаСлова) > 0 Тогда
				Для Индекс = 1 По ПодходящиеСлова.Индекс(СтрокаСлова)  Цикл
					ПредыдущееНСлово = ПодходящиеСлова[ПодходящиеСлова.Индекс(СтрокаСлова) - Индекс].НСлово;
					Если Лев(ПодходящиеСлова[ПодходящиеСлова.Индекс(СтрокаСлова) - Индекс].НСлово, ДлинаОбщейЧасти) <>
						Лев(СтрокаСлова.НСлово, ДлинаОбщейЧасти)
					Тогда 
						СимволОдинаковый = Ложь;
						Прервать;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
			Если СимволОдинаковый Тогда
				ПредыдущееНСлово = "";
			КонецЕсли;
			СимволОдинаковый = Ложь;
			Пока Истина Цикл
				Если ДлинаОбщейЧасти = 0 Тогда 
					СимволОдинаковый = Истина;
					Прервать;
				КонецЕсли;
				ДлинаОбщейЧасти = ДлинаОбщейЧасти - 1;
				ОчереднойСимвол = Сред(СтрокаСлова.НСлово, ДлинаОбщейЧасти, 1);
				Если Лев(СледующееНСлово, ДлинаОбщейЧасти) = Нрег(Лев(ТекущееСлово, ДлинаОбщейЧасти)) Тогда 
					СимволОдинаковый = Истина;
					Прервать;
				КонецЕсли;
				Если Лев(ПредыдущееНСлово, ДлинаОбщейЧасти) = Нрег(Лев(ТекущееСлово, ДлинаОбщейЧасти)) Тогда 
					СимволОдинаковый = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			УстановитьТекущееСлово(Лев(СтрокаСлова.Слово, ДлинаОбщейЧасти));
			ЛиНашли = Ложь;
			ПерваяПодходящаяСтрока = Неопределено;
			НайтиПодходящиеСлова(ТекущееСлово, ЛиНашли, ПерваяПодходящаяСтрока);
			СтрокаСлова = ПерваяПодходящаяСтрока;
			Если Не ЛиНашли Тогда
				ЭлементыФормы.ТаблицаСлов.ВыделенныеСтроки.Очистить();
			КонецЕсли;
		КонецЕсли; 
	Иначе
		ЛиНашли = Ложь;
		ПерваяПодходящаяСтрока = Неопределено;
		НайтиПодходящиеСлова(ТекущееСлово, ЛиНашли, ПерваяПодходящаяСтрока);
		СтрокаСлова = ПерваяПодходящаяСтрока;
		Если Не ЛиНашли Тогда
			ЛиОбработкаСобытия = Ложь;
			Если ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока = Неопределено Тогда 
				ЛиНазад = Истина;
				ВременнаяСтрока = ПодходящиеСлова.Добавить();
				ВременнаяСтрока.Слово = ТекущееСлово;
				ВременнаяСтрока.НСлово = НРег(ВременнаяСтрока.Слово);
				ВременнаяСтрока.Рейтинг = -1;
				ПодходящиеСлова.Сортировать("НСлово");
				ПодобратьСтроку(, ВременнаяСтрока);
				ПодходящиеСлова.Удалить(ВременнаяСтрока);
			Иначе
				УстановитьТекущееСлово(Лев(ТекущееСлово, СтрДлина(ТекущееСлово) - 1));
			КонецЕсли;
		Иначе
			// Найдем максимальную общую часть подходящих слов
			ДлинаОбщейЧасти = СтрДлина(ТекущееСлово);
			ДлинаТекущегоСлова = ДлинаОбщейЧасти;
			СимволОдинаковый = Истина;
			НСлово = "";
			Пока Истина Цикл
				Если ДлинаОбщейЧасти > СтрДлина(СтрокаСлова.НСлово) Тогда 
					СимволОдинаковый = Ложь;
				КонецЕсли;
				Если Не СимволОдинаковый Тогда
					Прервать;
				КонецЕсли;
				ДлинаОбщейЧасти = ДлинаОбщейЧасти + 1;
				ОчереднойСимвол = Сред(СтрокаСлова.НСлово, ДлинаОбщейЧасти, 1);
				РазмерГруппы = 1;
				Для Индекс = ПодходящиеСлова.Индекс(СтрокаСлова) + 1 По ПодходящиеСлова.Количество() - 1 Цикл
					НСлово = ПодходящиеСлова[Индекс].НСлово;
					Если Лев(НСлово, ДлинаТекущегоСлова) <> Нрег(ТекущееСлово) Тогда 
						Прервать;
					КонецЕсли;
					РазмерГруппы = РазмерГруппы + 1;
					Если Сред(НСлово, ДлинаОбщейЧасти, 1) <> ОчереднойСимвол Тогда 
						СимволОдинаковый = Ложь;
						Прервать;
					КонецЕсли;
				КонецЦикла;
				Если Не СимволОдинаковый Тогда
					Прервать;
				КонецЕсли;
			КонецЦикла;
			ДлинаОбщейЧастиГруппы = ДлинаОбщейЧасти - СтрДлина(ТекущееСлово) - 1;
			УстановитьТекущееСлово(Лев(СтрокаСлова.Слово, ДлинаОбщейЧасти - 1));
			Если Истина
				И ДлинаОбщейЧастиГруппы > 0
				И ЛиПередОткрытием
			Тогда
				Если РазмерГруппы = 1 Тогда 
					ЭтаФорма.СтрокаСловаРезультата = ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока;
				Иначе 
					ЭтаФорма.СтрокаСловаРезультата = Новый Структура("Слово, ТипСлова", ТекущееСлово);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	ЛиНазад = Ложь;
	ирКлиент.ПромежуточноеОбновлениеСтроковогоЗначенияПоляВводаЛкс(ЭтаФорма, ЭлементыФормы.ЭлементУправленияTextBox, ТекущееСлово, Истина);
	ЛиОбработкаСобытия = Ложь;

КонецПроцедуры

Процедура УстановитьТекущееСлово(Знач НовоеТекущееСлово)
	
	Если НовоеТекущееСлово <> ТекущееСлово Тогда
		ТекущееСлово = НовоеТекущееСлово;
		ЭлементУправленияTextBoxChange();
	КонецЕсли;

КонецПроцедуры

Процедура ЭлементУправленияTextBoxChange(Элемент = Неопределено)
	
	ПриИзмененииОтбора();
	
КонецПроцедуры

Функция ОбработкаОбщихКлавиш(ПолеВвода, КодСочетанияКлавиш)

	СочетаниеОбработано = Ложь;
	Если ТекущийЭлемент <> ЭлементыФормы.ТаблицаСлов Тогда
		Если Найти(КодСочетанияКлавиш, "00296") = 1 Тогда // {DOWN}
			СочетаниеОбработано = Истина;
			Если ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока <> Неопределено Тогда
				Смещение = + 1;
				ЗаполнитьЗначенияСвойств(СтруктураКлюча, ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока);
				ИндексТекущейСтроки = ПодходящиеСлова.Индекс(ПодходящиеСлова.НайтиСтроки(СтруктураКлюча)[0]);
				НовыйИндекс = Мин(ИндексТекущейСтроки + Смещение, ПодходящиеСлова.Количество() - 1);
				ЗаполнитьЗначенияСвойств(СтруктураКлюча, ПодходящиеСлова[НовыйИндекс]);
				ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока = ТаблицаСлов.НайтиСтроки(СтруктураКлюча)[0];
			КонецЕсли;
		ИначеЕсли Найти(КодСочетанияКлавиш, "00294") = 1 Тогда // {UP} 
			УстановитьГраницыВыделенияФильтра(); // https://www.hostedredmine.com/issues/929384
			СочетаниеОбработано = Истина;
			Если ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока <> Неопределено Тогда
				Смещение = - 1;
				ЗаполнитьЗначенияСвойств(СтруктураКлюча, ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока);
				ИндексТекущейСтроки = ПодходящиеСлова.Индекс(ПодходящиеСлова.НайтиСтроки(СтруктураКлюча)[0]);
				НовыйИндекс = Макс(ИндексТекущейСтроки + Смещение, 0);
				ЗаполнитьЗначенияСвойств(СтруктураКлюча, ПодходящиеСлова[НовыйИндекс]);
				ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока = ТаблицаСлов.НайтиСтроки(СтруктураКлюча)[0];
			КонецЕсли;
		ИначеЕсли Найти(КодСочетанияКлавиш, "00290") = 1 Тогда // {PGDW} 
			СочетаниеОбработано = Истина;
			Если ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока <> Неопределено Тогда
				Смещение = + 20;
				ЗаполнитьЗначенияСвойств(СтруктураКлюча, ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока);
				ИндексТекущейСтроки = ПодходящиеСлова.Индекс(ПодходящиеСлова.НайтиСтроки(СтруктураКлюча)[0]);
				НовыйИндекс = Мин(ИндексТекущейСтроки + Смещение, ПодходящиеСлова.Количество() - 1);
				ЗаполнитьЗначенияСвойств(СтруктураКлюча, ПодходящиеСлова[НовыйИндекс]);
				ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока = ТаблицаСлов.НайтиСтроки(СтруктураКлюча)[0];
			КонецЕсли;
		ИначеЕсли Найти(КодСочетанияКлавиш, "00289") = 1 Тогда // {PGUP} 
			СочетаниеОбработано = Истина;
			Если ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока <> Неопределено Тогда
				Смещение = - 20;
				ЗаполнитьЗначенияСвойств(СтруктураКлюча, ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока);
				ИндексТекущейСтроки = ПодходящиеСлова.Индекс(ПодходящиеСлова.НайтиСтроки(СтруктураКлюча)[0]);
				НовыйИндекс = Макс(ИндексТекущейСтроки + Смещение, 0);
				ЗаполнитьЗначенияСвойств(СтруктураКлюча, ПодходящиеСлова[НовыйИндекс]);
				ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока = ТаблицаСлов.НайтиСтроки(СтруктураКлюча)[0];
			КонецЕсли;
		КонецЕсли; 
	КонецЕсли; 
	Если Ложь
		Или Найти(КодСочетанияКлавиш, "00013") = 1 // {ENTER}
		Или Найти(КодСочетанияКлавиш, "00187") = 1 // "=" 
	Тогда  
		СочетаниеОбработано = Истина;
		Если Истина
			И ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока <> Неопределено
			И ЭлементыФормы.ТаблицаСлов.ВыделенныеСтроки.Содержит(ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока)
		Тогда 
			ЭтаФорма.СтрокаСловаРезультата = ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока;
		Иначе
			ЭтаФорма.СтрокаСловаРезультата = Новый Структура("Слово, ТипСлова, Определение", ТекущееСлово);
			Если Не ЗначениеЗаполнено(ТекущееСлово) Тогда
				Закрыть();
				Возврат Истина;
			КонецЕсли;
		КонецЕсли;
		Если Найти(КодСочетанияКлавиш, "00013") = 1 Тогда // {ENTER}
			ЗакрытьИВставитьСлово();
		Иначе
			ЗакрытьИВставитьСлово(" = ");
		КонецЕсли; 
	ИначеЕсли Найти(КодСочетанияКлавиш, "00191") = 1 Тогда // "."
		СочетаниеОбработано = Истина;
		ОткрытьДочерние();
	КонецЕсли;
	Если ЭтаФорма.Открыта() Тогда
		ЭтаФорма.ТекущийЭлемент = ПолеВвода;
	КонецЕсли;
	Возврат СочетаниеОбработано;

КонецФункции

Процедура ОткрытьДочерние()

	Если Истина
		И ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока <> Неопределено
		И ЭлементыФормы.ТаблицаСлов.ВыделенныеСтроки.Содержит(ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока)
	Тогда 
		ЭтаФорма.СтрокаСловаРезультата = ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока;
		Закрыть(".");
	КонецЕсли;

КонецПроцедуры

Функция ЭлементУправленияTextBoxKeyDown(Элемент, КодСочетанияКлавиш)
	
	Если Найти(КодСочетанияКлавиш, "00008") = 1 Тогда // {BACKSPACE} 
		ЛиНазад = Истина;
	КонецЕсли;
	Результат = ОбработкаОбщихКлавиш(Элемент, КодСочетанияКлавиш);
	Возврат Результат;
	
КонецФункции

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	ЛиНазад = Ложь;
	ЛиОбработкаСобытия = Истина;
	ОтборПоСлову = ЭлементыФормы.ТаблицаСлов.ОтборСтрок.Слово;
	ОтборПоСлову.ВидСравнения = ВидСравнения.Содержит;
	ОтборПоСлову.Использование = Истина;
	ЛиОбработкаСобытия = Ложь;
	СтрокаСловаРезультата = Неопределено;

	//НачальногоСловаНетВТаблице = ТаблицаСлов.Найти(НРег(ТекущееСлово), "НСлово") = Неопределено;
	//Если НачальногоСловаНетВТаблице Тогда
	//	// Если слово не равно ни одному из слов списка, то фильтр включаем
	//	ЭлементыФормы.ТаблицаСлов.ОтборСтрок.Слово.Значение = ТекущееСлово;
	//	НачальноеСлово = ТекущееСлово;
	//КонецЕсли; 
	Если МодальныйРежим Тогда
		ПриИзмененииОтбора();
	КонецЕсли;
	ПодключитьОбработчикИзмененияДанных("ЭлементыФормы.ТаблицаСлов.Отбор", "ПриИзмененииОтбора", Истина);
	//ПодключитьОбработчикИзмененияДанных("ТекущееСлово", "ЭлементУправленияTextBoxChange"); // Так будет глючить из-за частой промежуточной переустановки значения
	Если Истина
		И СтрокаСловаРезультата <> Неопределено
		И СтрокаСловаРезультата = ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока 
		И ирОбщий.СтрНачинаетсяСЛкс(СтрокаСловаРезультата.Слово, мКонтекст)
	Тогда
		//Если НачальногоСловаНетВТаблице Тогда 
		//            ЭлементыФормы.ТаблицаСлов.ОтборСтрок.Слово.Значение = "";
		//            ТекущееСлово = НачальноеСлово;
		//            Если СтрокаСловаРезультата = ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока Тогда
		//                           Отказ = Истина;
		//            КонецЕсли; 
		//Иначе
		Отказ = Истина;
		//КонецЕсли;
	КонецЕсли;
	Если Отказ Тогда
		ЗакрытьИВставитьСлово();
	КонецЕсли; 

КонецПроцедуры

Процедура ПриОткрытии()
	
	Если КлючУникальности = "Автотест" Тогда
		Возврат;
	КонецЕсли;
	ирКлиент.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ЭлементыФормы.ТаблицаСлов.ОтборСтрок.Слово.Значение = "";
	Если Ложь
		Или ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока = Неопределено 
		Или Лев(ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока.НСлово, СтрДлина(ТекущееСлово)) <> НРег(ТекущееСлово)
	Тогда 
		ЭлементыФормы.ТаблицаСлов.ВыделенныеСтроки.Очистить();
	КонецЕсли;
	ЭтаФорма.ТипКонтекста = ирКэш.Получить().ИмяТипаИзСтруктурыТипа(СтруктураТипаКонтекста);
	ЭтаФорма.ТекущийЭлемент = ЭлементыФормы.ЭлементУправленияTextBox;
	ЭлементыФормы.КоманднаяПанельФормы.Кнопки.ПерейтиКОпределению.Доступность = Истина
		И ЯзыкПрограммы = 1
		И Найти(ТипКонтекста, ".") > 0;
	//ЭтаФорма.Заголовок = "Контекст: " + Контекст;
	ЭтаФорма.Заголовок = "Тип: " + ТипКонтекста;

КонецПроцедуры

Процедура УстановитьГраницыВыделенияФильтра()
	
	ирКлиент.ПромежуточноеОбновлениеСтроковогоЗначенияПоляВводаЛкс(ЭтаФорма, ЭлементыФормы.ЭлементУправленияTextBox,, Истина);

КонецПроцедуры

Процедура ПодходящиеСловаПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ирКлиент.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
	Если Лев(ДанныеСтроки.НСлово, СтрДлина(ТекущееСлово)) <> НРег(ТекущееСлово) Тогда 
		ОформлениеСтроки.ЦветТекста = WebЦвета.Коричневый;
	Иначе
		ОформлениеСтроки.Ячейки.КлючеваяБуква.УстановитьТекст(ВРег(Сред(ДанныеСтроки.НСлово, СтрДлина(ТекущееСлово) + 1, 1)));
	КонецЕсли;
	ЯчейкаКартинки = ОформлениеСтроки.Ячейки.Картинка;
	ЯчейкаКартинки.ОтображатьКартинку = Истина;
	ИндексКартинки = ирКлиент.ИндексКартинкиСловаПодсказкиЛкс(ДанныеСтроки);
	Если ИндексКартинки >= 0 Тогда
		ЯчейкаКартинки.ИндексКартинки = ИндексКартинки;
	КонецЕсли; 
	ОформитьЯчейкуТипаЗначения(ОформлениеСтроки, ДанныеСтроки);
	
КонецПроцедуры

Процедура ПриИзмененииОтбора(ИмяДанных = "") Экспорт 

	Если ЛиОбработкаСобытия Тогда
		Возврат;
	КонецЕсли;
	ЛиОбработкаСобытия = Истина;
	СписокФильтраПоТипуСлова = Новый СписокЗначений;
	Если ЭлементыФормы.ДействияФормы.Кнопки.НеМетоды.Пометка Тогда
		СписокФильтраПоТипуСлова.Добавить("Метод");
	КонецЕсли;
	Если ЭлементыФормы.ДействияФормы.Кнопки.НеСвойства.Пометка Тогда
		СписокФильтраПоТипуСлова.Добавить("Свойство");
	КонецЕсли;
	Если ЭлементыФормы.ДействияФормы.Кнопки.НеКлючевыеСлова.Пометка Тогда
		СписокФильтраПоТипуСлова.Добавить("Конструкция");
	КонецЕсли;
	ОтборПоТипуСлова = ЭлементыФормы.ТаблицаСлов.ОтборСтрок.ТипСлова;
	Если СписокФильтраПоТипуСлова.Количество() > 0 Тогда
		ОтборПоТипуСлова.ВидСравнения = ВидСравнения.НеВСписке;
		ОтборПоТипуСлова.Значение = СписокФильтраПоТипуСлова;
		ОтборПоТипуСлова.Использование = Истина;
	ИначеЕсли ОтборПоТипуСлова.ВидСравнения = ВидСравнения.НеВСписке Тогда 
		ОтборПоТипуСлова.Использование = Ложь;
	КонецЕсли;
	ВременныйПостроительЗапроса = ирКлиент.ПостроительТабличногоПоляСОтборомКлиентаЛкс(ЭлементыФормы.ТаблицаСлов);
	//ВременныйПостроительЗапроса.Выполнить();
	ПодходящиеСлова = ВременныйПостроительЗапроса.Результат.Выгрузить();
	ЛиОбработкаСобытия = Ложь;
	Если ПодходящиеСлова.Количество() = 0 Тогда 
		// Иначе будет рекурсивно столько вызывов, сколько символов в текущем слове
		Возврат;
	КонецЕсли;
	ПодобратьСтроку(Не Открыта());

КонецПроцедуры

Процедура ДействияФормыНеМетоды(Кнопка)
	
	Кнопка.Пометка = Не Кнопка.Пометка;
	ПриИзмененииОтбора();
	
КонецПроцедуры
 
Процедура ДействияФормыНеСвойства(Кнопка)
	
	Кнопка.Пометка = Не Кнопка.Пометка;
	ПриИзмененииОтбора();
	
КонецПроцедуры

Процедура ДействияФормыНеКлючевыеСлова(Кнопка)
	
	Кнопка.Пометка = Не Кнопка.Пометка;
	ПриИзмененииОтбора();
	
КонецПроцедуры

Процедура КоманднаяПанельФормыКонтекстнаяСправка(Кнопка = Неопределено)
	
	Если ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ПутьКСлову = ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока.Слово;
	Если ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока.ТипСлова = "Метод" Тогда
		ПутьКСлову = ПутьКСлову + "(";
	КонецЕсли;
	ФормаФокуса = ?(ЭтаФорма.ВводДоступен(), ЭтаФорма, ФормаВладелец);
	ФормаВызовМетода = ФормаВызовМетода();
	ФормаВызовМетода.ЗапомнитьПозициюКаретки(Ширина + 4);
	ОткрытьКонтекстнуюСправку(ПутьКСлову, ФормаФокуса);
	Если ирКэш.ЛиСеансТолстогоКлиентаУПЛкс() Тогда 
		// Нельзя сразу активировать обратно эту форму, т.к. тогда платформа открытую форму сразу скроет и пользователь может не понять, что та форма открыта в отдельном окне
	Иначе
		ирКлиент.Форма_АктивироватьОткрытьЛкс(ФормаФокуса);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПолеОтбораПоПодстрокеKeyDown(Элемент, КодСочетанияКлавиш)

	ОбработкаОбщихКлавиш(Элемент, КодСочетанияКлавиш);
	
КонецПроцедуры

Процедура КоманднаяПанельФормыВнутрь(Кнопка)
	
	ОткрытьДочерние();
	
КонецПроцедуры

Процедура КнопкаОчисткиФильтраНажатие(Элемент = Неопределено)
	
	ЭлементыФормы.ПолеОтбораПоПодстроке.Значение = "";
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирКлиент.Форма_ПриЗакрытииЛкс(ЭтаФорма);
	ЛиНазад = Ложь;
	ЛиОбработкаСобытия = Истина;
	ТекущееСлово = "";
	КнопкаОчисткиФильтраНажатие();
	
КонецПроцедуры

// Надо вызывать до начала открытия (до ПередОткрытием), иначе недоступность формы-владельца будет сброшена
Процедура ЗапомнитьПозициюКаретки() Экспорт 
	
	Если Не ирКэш.ЛиПлатформаWindowsЛкс() Тогда
		ВКОбщая = "";
		Возврат;
	КонецЕсли; 
	ВКОбщая = ирОбщий.НоваяВКОбщаяЛкс();
	ОбработкаПрерыванияПользователя();
	Если ВКОбщая <> Неопределено Тогда
		#Если Сервер И Не Сервер Тогда
			ПолеТекста = Обработки.ирОболочкаПолеТекста.Создать();
		#КонецЕсли
		ПолеТекста.ПолучитьПозициюКаретки(ВКОбщая, ФормаВладелец);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	ЭтаФорма.ТекущийЭлемент = ЭлементыФормы.ТаблицаСлов; // Антибаг флатформы 8.3.12 чтобы каретка в поле текстового документа родительской формы не исчезала

КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	ирКлиент.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

// Для нее еще нужна ОбработчикОжиданияСПараметрамиЛкс()
Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирКлиент.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ТаблицаСловПриАктивизацииСтроки(Элемент)
	
	ирКлиент.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	ТекущаяСтрока = ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ВернутьСтруктуруТипа = ТекущаяСтрока.Определение <> "Статистический";
	ТаблицаСтруктурТипов = УточнитьТипЗначенияВСтрокеТаблицыСлов(СтруктураТипаКонтекста, ТекущаяСтрока, ВернутьСтруктуруТипа, Ложь);
	Если ТаблицаСтруктурТипов <> Неопределено Тогда
		СтруктураТипа = ТаблицаСтруктурТипов[0];
		Если СтруктураТипа.СтрокаОписания <> Неопределено Тогда
			ирКлиент.ОповеститьФормыПодсистемыЛкс("ПоказатьОписаниеСлова", СтруктураТипа, ЭтаФорма);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура КоманднаяПанельФормыПереброситьВведеннуюСтроку(Кнопка)
	
	#Если Сервер И Не Сервер Тогда
		ПереброситьВведеннуюСтроку();
	#КонецЕсли
	// Без задержки к сожалению не переключается фокус между полями ввода
	ПодключитьОбработчикОжидания("ПереброситьВведеннуюСтроку", 0.1, Истина);
	
КонецПроцедуры

Процедура ПереброситьВведеннуюСтроку() Экспорт 
	
	Если ЗначениеЗаполнено(ЭлементыФормы.ПолеОтбораПоПодстроке.Значение) Тогда
		ЭтаФорма.ТекущийЭлемент = ЭлементыФормы.ЭлементУправленияTextBox;
		ЭлементыФормы.ЭлементУправленияTextBox.Значение = ЭлементыФормы.ПолеОтбораПоПодстроке.Значение;
		ЭлементыФормы.ПолеОтбораПоПодстроке.Значение = "";
	Иначе
		ЭтаФорма.ТекущийЭлемент = ЭлементыФормы.ПолеОтбораПоПодстроке;
		ЭлементыФормы.ПолеОтбораПоПодстроке.Значение = ЭлементыФормы.ЭлементУправленияTextBox.Значение;
		//ирКлиент.ПромежуточноеОбновлениеСтроковогоЗначенияПоляВводаЛкс(ЭтаФорма, ЭлементыФормы.ПолеОтбораПоПодстроке, ЭлементыФормы.ЭлементУправленияTextBox.Значение); // Каретка все равно встает в левый край поля
		ЭлементыФормы.ЭлементУправленияTextBox.Значение = "";
	КонецЕсли;

КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирКлиент.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);
	Если Источник = "KeyboardHook" Тогда
		//Сообщить(Данные); // Для отладки
		КодыКлавиш = ирКэш.КодыКлавишЛкс();
		Если Найти(Данные, КодыКлавиш["CTRL+F1"]) = 1 Тогда 
			КоманднаяПанельФормыКонтекстнаяСправка();
		ИначеЕсли ТекущийЭлемент = ЭлементыФормы.ЭлементУправленияTextBox Тогда
			ЗначениеИзменилось = ТекущийЭлемент.Значение <> ТекущееСлово;
			Если ЗначениеИзменилось Тогда
				ирКлиент.ПромежуточноеОбновлениеСтроковогоЗначенияПоляВводаЛкс(ЭтаФорма, ТекущийЭлемент, ТекущийЭлемент.Значение);
			КонецЕсли; 
			Если Не ЭлементУправленияTextBoxKeyDown(ТекущийЭлемент, Данные) Тогда 
				Если ЗначениеИзменилось Тогда
					ЭлементУправленияTextBoxChange(ТекущийЭлемент);
				КонецЕсли; 
			КонецЕсли; 
		ИначеЕсли Ложь
			Или ТекущийЭлемент = ЭлементыФормы.ПолеОтбораПоПодстроке 
			//Или ТекущийЭлемент = ЭлементыФормы.ТипКонтекста // https://www.hostedredmine.com/issues/895503
		Тогда
			ирКлиент.ПромежуточноеОбновлениеСтроковогоЗначенияПоляВводаЛкс(ЭтаФорма, ТекущийЭлемент, ТекущийЭлемент.Значение);
			ПолеОтбораПоПодстрокеKeyDown(ТекущийЭлемент, Данные);
		КонецЕсли; 
	КонецЕсли; 

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирКлиент.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура КоманднаяПанельФормыПерейтиКОпределению(Кнопка)
	
	ТекущаяСтрока = ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ирКлиент.ОткрытьКолонкуБДЛкс(ТипКонтекста, ТекущаяСтрока.Слово);
	
КонецПроцедуры

ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирКлсПолеТекстаПрограммы.Форма.Автодополнение");

ЛиНазад = Ложь;
ЛиОбработкаСобытия = Истина;
СтруктураКлюча = Новый Структура;
Для Каждого КолонкаРезультата Из Метаданные().ТабличныеЧасти.ТаблицаСлов.Реквизиты Цикл
	Если КолонкаРезультата = Метаданные().ТабличныеЧасти.ТаблицаСлов.Реквизиты.ТипЗначения Тогда
		// Эта колонка может дозаполняться при активации строки
		Продолжить;
	КонецЕсли; 
	СтруктураКлюча.Вставить(КолонкаРезультата.Имя);
КонецЦикла;
ПодходящиеСлова = ТаблицаСлов.ВыгрузитьКолонки();

// Антибаг платформы. В портативном варианте очищается свойство "Данные", если оно указывает на отбор табличной части
ЭлементыФормы.ПолеОтбораПоПодстроке.Данные = "ЭлементыФормы.ТаблицаСлов.Отбор.Слово.Значение";
ЭлементыФормы.ПолеОтбораПоПодстроке.КнопкаВыбора = Ложь;
