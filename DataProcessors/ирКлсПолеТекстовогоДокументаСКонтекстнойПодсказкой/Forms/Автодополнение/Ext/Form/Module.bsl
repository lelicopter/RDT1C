﻿Перем ЛиНазад;
Перем ЛиОбработкаСобытия;
Перем Запрос;
Перем СтруктураКлюча;
Перем ПодходящиеСлова;
Перем РазмерГруппы;
Перем СтрокаСловаРезультата Экспорт;
Перем СтруктураТипаКонтекста Экспорт;
Перем ВКОбщая;

Процедура ПодходящиеСловаВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	СтрокаСловаРезультата = ВыбраннаяСтрока;
	Закрыть(Истина);
	
КонецПроцедуры

Процедура НайтиПодходящиеСлова(ТекущееСлово, ЛиНашли, ПерваяПодходящаяСтрока)

	#Если Сервер И Не Сервер Тогда
		ПодходящиеСлова = ТаблицаСлов;
	#КонецЕсли
	ЛиНашли = Ложь;
	ДлинаТекущегоСлова = СтрДлина(ТекущееСлово);
	СтрокаМаксимальногоРейтинга = Неопределено;
	// Здесь в таблицу ПодходящиеСлова можно добавить колонку ИндексСлово = Лев(НСлово, 3) для ускорения поиска
	Для Каждого СтрокаСлова Из ПодходящиеСлова Цикл
		НСлово = СтрокаСлова.НСлово;
		Если СтрДлина(НСлово) < ДлинаТекущегоСлова Тогда 
			Продолжить;
		КонецЕсли;
		Если Лев(СтрокаСлова.НСлово, ДлинаТекущегоСлова) = Нрег(ТекущееСлово) Тогда
			ЛиНашли = Истина;
			СтрокаМаксимальногоРейтинга = СтрокаСлова;
			ПерваяПодходящаяСтрока = СтрокаСлова;
			Прервать;
		ИначеЕсли ЛиНашли Тогда 
			Прервать; 
		ИначеЕсли СтрокаСлова.НСлово > ТекущееСлово Тогда 
			ПерваяПодходящаяСтрока = СтрокаСлова;
			Прервать; 
		КонецЕсли;
	КонецЦикла;
	Если СтрокаМаксимальногоРейтинга <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(СтруктураКлюча, ПерваяПодходящаяСтрока);
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
			ТекущееСлово = Лев(СтрокаСлова.Слово, ДлинаОбщейЧасти);
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
				ТекущееСлово = Лев(ТекущееСлово, СтрДлина(ТекущееСлово) - 1);
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
			ТекущееСлово = Лев(СтрокаСлова.Слово, ДлинаОбщейЧасти - 1);
			//Если ДлинаОбщейЧасти <> ДлинаТекущегоСлова И СтрокаЛучшегоСлова <> Неопределено Тогда
			//	ЗаполнитьЗначенияСвойств(СтруктураКлюча, СтрокаЛучшегоСлова);
			//	НайденныеСтроки = ТаблицаСлов.НайтиСтроки(СтруктураКлюча);
			//	Если НайденныеСтроки.Количество() > 0 Тогда
			//		ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока = НайденныеСтроки[0];
			//	КонецЕсли; 
			//КонецЕсли;
			Если Истина
				И ДлинаОбщейЧастиГруппы > 0
				И ЛиПередОткрытием
			Тогда
				Если РазмерГруппы = 1 Тогда 
					СтрокаСловаРезультата = ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока;
				Иначе 
					СтрокаСловаРезультата = Новый Структура("Слово, ТипСлова", ТекущееСлово);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	ЛиОбработкаСобытия = Ложь;
	ЛиНазад = Ложь;
	ирОбщий.ПромежуточноеОбновлениеСтроковогоЗначенияПоляВводаЛкс(ЭлементыФормы.ЭлементУправленияTextBox, ТекущееСлово, Истина);

КонецПроцедуры

Процедура ЭлементУправленияTextBoxChange(Элемент)
	
	ПриИзмененииОтбора();
	
КонецПроцедуры

Функция ОбработкаОбщихКлавиш(ПолеВвода, КодСочетанияКлавиш)

	СочетаниеОбработано = Ложь;
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
	ИначеЕсли Найти(КодСочетанияКлавиш, "00013") = 1 Тогда // {ENTER} 
		СочетаниеОбработано = Истина;
		Если Истина
			И ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока <> Неопределено
			И ЭлементыФормы.ТаблицаСлов.ВыделенныеСтроки.Содержит(ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока)
		Тогда 
			СтрокаСловаРезультата = ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока;
		Иначе
			СтрокаСловаРезультата = Новый Структура("Слово, ТипСлова, Определение", ТекущееСлово);
		КонецЕсли;
		Закрыть(Истина);
	ИначеЕсли Найти(КодСочетанияКлавиш, "00187") = 1 Тогда // "=" 
		СочетаниеОбработано = Истина;
		Если Истина
			И ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока <> Неопределено
			И ЭлементыФормы.ТаблицаСлов.ВыделенныеСтроки.Содержит(ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока)
		Тогда 
			СтрокаСловаРезультата = ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока;
		Иначе
			СтрокаСловаРезультата = Новый Структура("Слово, ТипСлова, Определение", ТекущееСлово);
		КонецЕсли;
		Закрыть(" = ");
	ИначеЕсли Найти(КодСочетанияКлавиш, "00191") = 1 Тогда // "."
		СочетаниеОбработано = Истина;
		ОткрытьДочерние();
	КонецЕсли;
	ЭтаФорма.ТекущийЭлемент = ПолеВвода;
	Возврат СочетаниеОбработано;

КонецФункции

Процедура ОткрытьДочерние()

	Если Истина
		И ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока <> Неопределено
		И ЭлементыФормы.ТаблицаСлов.ВыделенныеСтроки.Содержит(ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока)
	Тогда 
		СтрокаСловаРезультата = ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока;
		Закрыть(".");
	КонецЕсли;

КонецПроцедуры // ОткрытьДочерние()

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

	//НачальногоСловаНетВТаблице = ТаблицаСлов.Найти(НРег(ТекущееСлово), "НСлово") = Неопределено;
	//Если НачальногоСловаНетВТаблице Тогда
	//	// Если слово не равно ни одному из слов списка, то фильтр включаем
	//	ЭлементыФормы.ТаблицаСлов.ОтборСтрок.Слово.Значение = ТекущееСлово;
	//	НачальноеСлово = ТекущееСлово;
	//КонецЕсли; 
	ПодключитьОбработчикИзмененияДанных("ЭлементыФормы.ТаблицаСлов.Отбор", "ПриИзмененииОтбора", Истина);
		
	ПриИзмененииОтбора();
	Если Истина
		И СтрокаСловаРезультата <> Неопределено
		И СтрокаСловаРезультата = ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока 
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
		ОповеститьОВыборе(Истина); // Аналог Закрыть(), но Закрыть() нельзя здесь вызывать
	КонецЕсли; 

КонецПроцедуры

Процедура ПриОткрытии()
	
	Если КлючУникальности = "Автотест" Тогда
		Возврат;
	КонецЕсли;
	ирОбщий.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ЭлементыФормы.ТаблицаСлов.ОтборСтрок.Слово.Значение = "";
	Заголовок = "Контекст: " + Контекст;
	Если Ложь
		Или ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока = Неопределено 
		Или Лев(ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока.НСлово, СтрДлина(ТекущееСлово)) <> НРег(ТекущееСлово)
	Тогда 
		ЭлементыФормы.ТаблицаСлов.ВыделенныеСтроки.Очистить();
	КонецЕсли;
	ТипКонтекста = ирКэш.Получить().ПолучитьСтрокуКонкретногоТипа(СтруктураТипаКонтекста);
	ЭтаФорма.ТекущийЭлемент = ЭлементыФормы.ЭлементУправленияTextBox;
	//Если ирОбщий.ВосстановитьЗначениеЛкс(ИмяКласса + ".ВычислятьТипыВСписке") <> Истина И ЯзыкПрограммы = 0 Тогда
	//	ЭлементыФормы.ТаблицаСлов.Колонки.ТипЗначения.Видимость = Ложь;
	//КонецЕсли;

КонецПроцедуры

Процедура ПодходящиеСловаПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
	Если Лев(ДанныеСтроки.НСлово, СтрДлина(ТекущееСлово)) <> НРег(ТекущееСлово) Тогда 
		ОформлениеСтроки.ЦветТекста = WebЦвета.Коричневый;
	Иначе
		ОформлениеСтроки.Ячейки.КлючеваяБуква.УстановитьТекст(ВРег(Сред(ДанныеСтроки.НСлово, СтрДлина(ТекущееСлово) + 1, 1)));
	КонецЕсли;
	ЯчейкаКартинки = ОформлениеСтроки.Ячейки.Картинка;
	ЯчейкаКартинки.ОтображатьКартинку = Истина;
	ИндексКартинки = ирОбщий.ПолучитьИндексКартинкиСловаПодсказкиЛкс(ДанныеСтроки);
	Если ИндексКартинки >= 0 Тогда
		ЯчейкаКартинки.ИндексКартинки = ИндексКартинки;
	КонецЕсли; 
	ОформитьЯчейкуТипаЗначения(ОформлениеСтроки, ДанныеСтроки);
	
КонецПроцедуры

Процедура ПриИзмененииОтбора(ИмяДанных = "")

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
		СписокФильтраПоТипуСлова.Добавить("Ключевое слово");
	КонецЕсли;
	ОтборПоТипуСлова = ЭлементыФормы.ТаблицаСлов.ОтборСтрок.ТипСлова;
	Если СписокФильтраПоТипуСлова.Количество() > 0 Тогда
		ОтборПоТипуСлова.ВидСравнения = ВидСравнения.НеВСписке;
		ОтборПоТипуСлова.Значение = СписокФильтраПоТипуСлова;
		ОтборПоТипуСлова.Использование = Истина;
	ИначеЕсли ОтборПоТипуСлова.ВидСравнения = ВидСравнения.НеВСписке Тогда 
		ОтборПоТипуСлова.Использование = Ложь;
	КонецЕсли;
	ВременныйПостроительЗапроса = ирОбщий.ПолучитьПостроительТабличногоПоляСОтборомКлиентаЛкс(ЭлементыФормы.ТаблицаСлов);
	//ВременныйПостроительЗапроса.Выполнить();
	ПодходящиеСлова = ВременныйПостроительЗапроса.Результат.Выгрузить();
	ЛиОбработкаСобытия = Ложь;
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

Процедура КоманднаяПанельФормыКонтекстнаяСправка(Кнопка)
	
	Если ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ПутьКСлову = ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока.Слово;
	Если ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока.ТипСлова = "Метод" Тогда
		ПутьКСлову = ПутьКСлову + "(";
	КонецЕсли;
	//ОткрытьПоискВСинтаксПомощнике(ПутьКСлову, ЭтаФорма);
	ОткрытьКонтекстнуюСправку(ПутьКСлову, ЭтаФорма);
	Активизировать();
	
КонецПроцедуры

Процедура ПолеОтбораПоПодстрокеKeyDown(Элемент, КодСочетанияКлавиш)

	ОбработкаОбщихКлавиш(Элемент, КодСочетанияКлавиш);
	
КонецПроцедуры

Процедура КоманднаяПанельФормыВнутрь(Кнопка)
	
	ОткрытьДочерние();
	
КонецПроцедуры

Процедура КнопкаОчисткиФильтраНажатие(Элемент)
	
	ЭлементыФормы.ПолеОтбораПоПодстроке.Значение = "";
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);
	ЛиНазад = Ложь;
	ЛиОбработкаСобытия = Истина;
	ТекущееСлово = "";
	
КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	Если ВКОбщая <> Неопределено Тогда
		Если МодальныйРежим Или ВводДоступен() Тогда
			ВКОбщая.ПереместитьОкноВПозициюКаретки();
			ВКОбщая = Неопределено;
			ВладелецФормы.Активизировать();
		КонецЕсли;
	КонецЕсли; 

КонецПроцедуры

// Надо вызывать до начала открытия (до ПередОткрытием), иначе недоступность формы-владельца будет сброшена
Процедура ЗапомнитьПозициюКаретки() Экспорт 
	
	ВКОбщая = ирОбщий.НоваяВКОбщаяЛкс();
	ОбработкаПрерыванияПользователя();
	Если ВКОбщая <> Неопределено Тогда
		ВКОбщая.ПолучитьПозициюКаретки();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	ЭтаФорма.ТекущийЭлемент = ЭлементыФормы.ТаблицаСлов; // Антибаг флатформы 8.3.12 чтобы каретка в поле текстового документа родительской формы не исчезала

КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	ирОбщий.ФормаОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

// Для нее еще нужна ОбработчикОжиданияСПараметрамиЛкс()
Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ТаблицаСловПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	Если ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ТекущаяСтрока = ЭлементыФормы.ТаблицаСлов.ТекущаяСтрока;
	Если Истина
		И Найти(ТекущаяСтрока.ТипЗначения, "??") = 1
		И ТекущаяСтрока.ТипСлова = "Метод"
	Тогда
		#Если Сервер И Не Сервер Тогда
			мПлатформа = Обработки.ирПлатформа.Создать();
		#КонецЕсли
		ТаблицаМетодов = мПлатформа.ДобавитьВТаблицуСловЭлементыМодуляМетаданных(СтруктураТипаКонтекста, ТекущаяСтрока.Слово, "Метод",, мМодульМетаданных);
		Если ТаблицаМетодов.Количество() > 0 Тогда
			ОбновитьТипЗначенияИзТаблицыСтруктурТипов(ТекущаяСтрока, ТаблицаМетодов[0].ТаблицаСтруктурТипов, Ложь);
		КонецЕсли; 
	КонецЕсли;
	
КонецПроцедуры

Процедура КоманднаяПанельФормыПереброситьВведеннуюСтроку(Кнопка)
	
	#Если Сервер И Не Сервер Тогда
		ПереброситьВведеннуюСтроку();
	#КонецЕсли
	// Без задержки к сожанию не переключается фокус между полями ввода
	ПодключитьОбработчикОжидания("ПереброситьВведеннуюСтроку", 0.1, Истина);
	
КонецПроцедуры

Процедура ПереброситьВведеннуюСтроку()
	
	Если ЗначениеЗаполнено(ЭлементыФормы.ПолеОтбораПоПодстроке.Значение) Тогда
		ЭтаФорма.ТекущийЭлемент = ЭлементыФормы.ЭлементУправленияTextBox;
		ЭлементыФормы.ЭлементУправленияTextBox.Значение = ЭлементыФормы.ПолеОтбораПоПодстроке.Значение;
		ЭлементыФормы.ПолеОтбораПоПодстроке.Значение = "";
	Иначе
		ЭтаФорма.ТекущийЭлемент = ЭлементыФормы.ПолеОтбораПоПодстроке;
		ЭлементыФормы.ПолеОтбораПоПодстроке.Значение = ЭлементыФормы.ЭлементУправленияTextBox.Значение;
		ЭлементыФормы.ЭлементУправленияTextBox.Значение = "";
	КонецЕсли;

КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);
	Если Источник = "KeyboardHook" Тогда
		Если Не ЭтаФорма.ВводДоступен() Тогда
			Возврат;
		КонецЕсли;
		//Сообщить(Данные); // Для отладки
		Если ТекущийЭлемент = ЭлементыФормы.ЭлементУправленияTextBox Тогда
			ирОбщий.ПромежуточноеОбновлениеСтроковогоЗначенияПоляВводаЛкс(ТекущийЭлемент, ТекущийЭлемент.Значение);
			Если Не ЭлементУправленияTextBoxKeyDown(ТекущийЭлемент, Данные) Тогда 
				ЭлементУправленияTextBoxChange(ТекущийЭлемент);
			КонецЕсли; 
		ИначеЕсли ТекущийЭлемент = ЭлементыФормы.ПолеОтбораПоПодстроке Тогда
			ирОбщий.ПромежуточноеОбновлениеСтроковогоЗначенияПоляВводаЛкс(ТекущийЭлемент, ТекущийЭлемент.Значение);
			ПолеОтбораПоПодстрокеKeyDown(ТекущийЭлемент, Данные);
		КонецЕсли; 
	КонецЕсли; 

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирОбщий.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирКлсПолеТекстовогоДокументаСКонтекстнойПодсказкой.Форма.Автодополнение");

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

// Антибаг платформы. Очищаются свойство данные, если оно указывает на отбор табличной части
ЭлементыФормы.ПолеОтбораПоПодстроке.Данные = "ЭлементыФормы.ТаблицаСлов.Отбор.Слово.Значение";
ЭлементыФормы.ПолеОтбораПоПодстроке.КнопкаВыбора = Ложь;
