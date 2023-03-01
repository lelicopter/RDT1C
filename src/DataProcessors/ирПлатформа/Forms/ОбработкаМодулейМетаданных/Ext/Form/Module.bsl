﻿Функция СохраняемаяНастройкаФормы(выхНаименование, выхИменаСвойств) Экспорт 
	выхИменаСвойств = "Форма.Папка, Форма.ТипЗамены, Форма.Маска, Форма.УчитыватьОтступ";
	Результат = Новый Структура;
	Результат.Вставить("ЧтоЗаменять", ЭлементыФормы.ПолеЧтоЗаменять.ПолучитьТекст());
	Результат.Вставить("ЧтоЗаменятьКонец", ЭлементыФормы.ПолеЧтоЗаменятьКонец.ПолучитьТекст());
	Результат.Вставить("НаЧтоЗаменять", ЭлементыФормы.ПолеНаЧтоЗаменять.ПолучитьТекст());
	Возврат Результат;
КонецФункции

Процедура ЗагрузитьНастройкуВФорме(НастройкаФормы, ДопПараметры) Экспорт 
	
	ирКлиент.ЗагрузитьНастройкуФормыЛкс(ЭтаФорма, НастройкаФормы); 
	НовыйЧтоЗаменять = "";
	НовыйНаЧтоЗаменять = "";
	Если НастройкаФормы <> Неопределено Тогда
		НовыйЧтоЗаменять = НастройкаФормы.ЧтоЗаменять;
		Если НастройкаФормы.Свойство("ЧтоЗаменятьКонец") Тогда
			НовыйЧтоЗаменятьКонец = НастройкаФормы.ЧтоЗаменятьКонец;
		КонецЕсли;
		НовыйНаЧтоЗаменять = НастройкаФормы.НаЧтоЗаменять;
	КонецЕсли; 
	ЭлементыФормы.ПолеЧтоЗаменять.УстановитьТекст(НовыйЧтоЗаменять);
	ЭлементыФормы.ПолеЧтоЗаменятьКонец.УстановитьТекст(НовыйЧтоЗаменятьКонец);
	ЭлементыФормы.ПолеНаЧтоЗаменять.УстановитьТекст(НовыйНаЧтоЗаменять);
	НастроитьЭлементыФормы();
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ирКлиент.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ирКлиент.СоздатьМенеджерСохраненияНастроекФормыЛкс(ЭтаФорма);

КонецПроцедуры

Процедура ОбновитьИнфоПапки()
	
	КонтрольныйФайл = КонтрольныйФайл();
	#Если Сервер И Не Сервер Тогда
		КонтрольныйФайл = Новый файл;
	#КонецЕсли
	Если КонтрольныйФайл.Существует() Тогда
		ЭтаФорма.ДатаОбновленияФайлов = КонтрольныйФайл.ПолучитьВремяИзменения();
	Иначе
		ЭтаФорма.ДатаОбновленияФайлов = Неопределено;
	КонецЕсли; 

КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт 
	
	ирКлиент.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ДействияФормыВыгрузить(Кнопка)
	
	Если Не ЗначениеЗаполнено(Папка) Тогда
		ЭтаФорма.ТекущийЭлемент = ЭлементыФормы.Папка;
		ирОбщий.СообщитьЛкс("Не указан каталог выгрузки", СтатусСообщения.Внимание);
		Возврат;
	КонецЕсли;
	УдалитьФайлы(Папка, "*");
	ТекстЛога = "";
	Успех = ирОбщий.ВыполнитьКомандуКонфигуратораЛкс("/DumpConfigFiles """ + Папка + """ -Module", СтрокаСоединенияИнформационнойБазы(), ТекстЛога, Истина, "Выгрузка модулей конфигурации");
	Если Не Успех Тогда 
		Сообщить(ТекстЛога);
		Возврат;
	КонецЕсли;
	КонтрольныйФайл = КонтрольныйФайл();
	#Если Сервер И Не Сервер Тогда
		КонтрольныйФайл = Новый Файл;
	#КонецЕсли
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.Записать(КонтрольныйФайл.ПолноеИмя);
	ОбновитьИнфоПапки();
	
КонецПроцедуры

Функция КонтрольныйФайл()
	
	Возврат Новый Файл(Папка + "base.cnt");

КонецФункции

Процедура ДействияФормыЗагрузить(Кнопка)
	
	Ответ = Вопрос("После загрузки обязательно сделайте сравнение/объединение с конфигурацией БД, чтобы убедиться, что изменения корректны. Продолжить?", РежимДиалогаВопрос.ОКОтмена);
	Если Ответ = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	КонтрольныйФайл = КонтрольныйФайл();
	#Если Сервер И Не Сервер Тогда
		КонтрольныйФайл = Новый Файл;
	#КонецЕсли
	Если Не КонтрольныйФайл.Существует() Тогда
		ирОбщий.СообщитьЛкс("Контрольный файл """ + КонтрольныйФайл.ПолноеИмя + """ не найден в папке");
		Возврат;
	КонецЕсли; 
	ДатаКонтрольная = КонтрольныйФайл.ПолучитьВремяИзменения();
	ФайлыПапки = НайтиФайлы(Папка, "*Модул*");
	КраткоеИмяПапкиНеизменных = "Unchanged";
	ПолноеИмяПапкиНеизменных = Папка + КраткоеИмяПапкиНеизменных + "\";
	СоздатьКаталог(ПолноеИмяПапкиНеизменных);
	СчетчикНеизменных = 0;
	Для Каждого ФайлМодуля Из ФайлыПапки Цикл
		#Если Сервер И Не Сервер Тогда
			ФайлМодуля = Новый Файл;
		#КонецЕсли
		Если ДатаКонтрольная >= ФайлМодуля.ПолучитьВремяИзменения() Тогда
			ПереместитьФайл(ФайлМодуля.ПолноеИмя, ПолноеИмяПапкиНеизменных + ФайлМодуля.Имя);
			СчетчикНеизменных = СчетчикНеизменных + 1;
		КонецЕсли; 
	КонецЦикла; 
	ирОбщий.СообщитьЛкс("" + СчетчикНеизменных + " неизменных файлов спрятаны в папку .\" + КраткоеИмяПапкиНеизменных);
	ТекстЛога = "";
	Успех = ирОбщий.ВыполнитьКомандуКонфигуратораЛкс("/LoadConfigFiles """ + Папка + """ -Module", СтрокаСоединенияИнформационнойБазы(), ТекстЛога, Истина, "Загрузка модулей конфигурации");
	ФайлыПапки = НайтиФайлы(ПолноеИмяПапкиНеизменных, "*Модул*");
	Для Каждого ФайлМодуля Из ФайлыПапки Цикл
		#Если Сервер И Не Сервер Тогда
			ФайлМодуля = Новый Файл;
		#КонецЕсли
		ПереместитьФайл(ФайлМодуля.ПолноеИмя, Папка + ФайлМодуля.Имя);
	КонецЦикла; 
	ирОбщий.СообщитьЛкс("" + СчетчикНеизменных + " неизменных файлов возвращены в папку модулей");
	УдалитьФайлы(ПолноеИмяПапкиНеизменных);
	Если Не Успех Тогда 
		Сообщить(ТекстЛога);
		Возврат;
	КонецЕсли;
	ЗапуститьСистему("CONFIG");
	
КонецПроцедуры

Процедура ПапкаОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗапуститьПриложение(Элемент.Значение);

КонецПроцедуры

Процедура ПапкаНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	НоваяПапка = ирКлиент.ВыбратьКаталогВФормеЛкс(Элемент.Значение,, "Выберите папку хранения модулей");
	Если НоваяПапка <> Неопределено Тогда
		Элемент.Значение = НоваяПапка;
	КонецЕсли;
	НастроитьЭлементыФормы();

КонецПроцедуры

Процедура НастроитьЭлементыФормы()
	ОбновитьИнфоПапки();
	ЛиЗаменаБлока = ЛиЗаменаБлока();
	ЭлементыФормы.ПолеЧтоЗаменятьКонец.Доступность = ЛиЗаменаБлока;
	ЭлементыФормы.НадписьНачалоБлока.Видимость = ЛиЗаменаБлока;
	ЭлементыФормы.НадписьКонецБлока.Видимость = ЛиЗаменаБлока;
	ЭлементыФормы.ПолеЧтоЗаменятьКонец.Видимость = ЛиЗаменаБлока;
	ЭлементыФормы.УчитыватьОтступ.Видимость = ЛиЗаменаБлока;
КонецПроцедуры

Функция ЛиЗаменаБлока()
	
	РежимЗаменыБлока = ТипЗамены = "МестоВместоБлок";
	Возврат РежимЗаменыБлока;

КонецФункции

Процедура КлсКомандаНажатие(Кнопка)
	ирКлиент.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирКлиент.Форма_ПриЗакрытииЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ДействияФормыЗаменить(Кнопка)
	
	ВыполнитьЗамену(Ложь);
	
КонецПроцедуры

Процедура ВыполнитьЗамену(Знач РежимТеста)
	
	Если Не РежимТеста И ТекущаяДата() - ДатаОбновленияФайлов > 600 Тогда
		Ответ = Вопрос("Файлы были выгружены более 10 минут назад. Уверены что хотите продолжить?", РежимДиалогаВопрос.ОКОтмена);
		Если Ответ <> КодВозвратаДиалога.ОК Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли; 
	ЧтоЗаменять = ЭлементыФормы.ПолеЧтоЗаменять.ПолучитьТекст();
	ЧтоЗаменятьКонец = ЭлементыФормы.ПолеЧтоЗаменятьКонец.ПолучитьТекст();
	ЛиЗаменаБлока = ЛиЗаменаБлока();
	Если ЛиЗаменаБлока Тогда
		Если Ложь
			Или СтрЧислоСтрок(ЧтоЗаменять) > 1 
			Или СтрЧислоСтрок(ЧтоЗаменятьКонец) > 1
		Тогда
			ирОбщий.СообщитьЛкс("В режиме ""Замена блока"" границы блока должны содержать по одной строке");
			Возврат;
		КонецЕсли;
		РегВычислитель = ирОбщий.НовыйВычислительРегВыражений();
		#Если Сервер И Не Сервер Тогда
			РегВычислитель = Обработки.ирОболочкаРегВыражение.Создать();
		#КонецЕсли
		РегВычислитель.Global = Истина;
		ГраницаСтроки = "(?:^|$|\n\r?)";
		Если УчитыватьОтступ Тогда
			ШаблонОтступа = "";
		Иначе
			ЧтоЗаменять = СокрЛП(ЧтоЗаменять);
			ЧтоЗаменятьКонец = СокрЛП(ЧтоЗаменятьКонец);
			ШаблонОтступа = "\s*";
		КонецЕсли;
		РегВычислитель.Pattern = "(" + ГраницаСтроки + ШаблонОтступа + ирОбщий.ПреобразоватьТекстДляРегулярныхВыраженийЛкс(ЧтоЗаменять) + "\s*" + ГраницаСтроки + ")"
			+ "[\S\s]+?" + "(" + ГраницаСтроки + ШаблонОтступа + ирОбщий.ПреобразоватьТекстДляРегулярныхВыраженийЛкс(ЧтоЗаменятьКонец) + "\s*" + ГраницаСтроки + ")";
	КонецЕсли;
	ФайлыПапки = НайтиФайлы(Папка, Маска);
	СчетчикИзменных = 0;
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(ФайлыПапки.Количество(), "Замена в файлах");
	Для Каждого ФайлМодуля Из ФайлыПапки Цикл
		#Если Сервер И Не Сервер Тогда
			ФайлМодуля = Новый Файл;
		#КонецЕсли
		ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
		ТекстМодуля = ирОбщий.ПрочитатьТекстИзФайлаЛкс(ФайлМодуля.ПолноеИмя);
		ЧислоВхождений = СтрЧислоВхождений(ТекстМодуля, СокрЛП(ЧтоЗаменять));
		Если ЧислоВхождений = 0 Тогда
			Продолжить;
		КонецЕсли; 
		НаЧтоЗаменять = ЭлементыФормы.ПолеНаЧтоЗаменять.ПолучитьТекст();
		Если ТипЗамены = "МестоПеред" Тогда
			НаЧтоЗаменять = НаЧтоЗаменять + ЧтоЗаменять;
		ИначеЕсли ТипЗамены = "МестоПосле" Тогда
			НаЧтоЗаменять = ЧтоЗаменять + НаЧтоЗаменять;
		ИначеЕсли ТипЗамены = "МестоВместо" Тогда
			//
		ИначеЕсли ТипЗамены = "МестоВместоБлок" Тогда
			ЧислоВхождений = Мин(ЧислоВхождений, СтрЧислоВхождений(ТекстМодуля, СокрЛП(ЧтоЗаменятьКонец)));
			Если ЧислоВхождений = 0 Тогда
				Продолжить;
			КонецЕсли;
		Иначе
			ВызватьИсключение "Некорректный тип замены - " + ТипЗамены;
		КонецЕсли;
		Если ЛиЗаменаБлока Тогда
			НовыйТекстМодуля = РегВычислитель.Заменить(ТекстМодуля, "$1" + НаЧтоЗаменять + "$2");
		Иначе
			НовыйТекстМодуля = СтрЗаменить(ТекстМодуля, ЧтоЗаменять, НаЧтоЗаменять);
		КонецЕсли;
		Если РежимТеста И НовыйТекстМодуля <> ТекстМодуля Тогда
			ирОбщий.СообщитьЛкс("Показан тест замены в файле """ + ФайлМодуля.Имя + """");
			ирКлиент.Сравнить2ЗначенияВФормеЛкс(ТекстМодуля, НовыйТекстМодуля,, "Оригинал", "Замена");
			Возврат;
		КонецЕсли; 
		ТекстовыйДокумент.УстановитьТекст(НовыйТекстМодуля);
		ТекстовыйДокумент.Записать(ФайлМодуля.ПолноеИмя);
		ирОбщий.СообщитьЛкс(Формат(ЧислоВхождений, "ЧЦ=4; ЧДЦ=0; ЧВН=; ЧГ=") + " вхождений - " + ФайлМодуля.ИмяБезРасширения);
		СчетчикИзменных = СчетчикИзменных + 1;
	КонецЦикла;
	Если РежимТеста Тогда
		ирОбщий.СообщитьЛкс("Подходящих файлов для замены не найдено");
		Возврат;
	КонецЕсли; 
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс(, Истина);
	ирОбщий.СообщитьЛкс("Изменено " + СчетчикИзменных + " файлов");

КонецПроцедуры

Процедура ДействияФормыТестЗамены(Кнопка)
	
	ВыполнитьЗамену(Истина);
	
КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирКлиент.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура МаскаОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ЭтаФорма.Маска = "*";
КонецПроцедуры

Процедура МаскаПриИзменении(Элемент)
	
	ирКлиент.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);

КонецПроцедуры

Процедура МаскаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_ОбновитьСписокЛкс(Элемент, ЭтаФорма);

КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	ирКлиент.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура МестоПриИзменении(Элемент)
	НастроитьЭлементыФормы();
КонецПроцедуры

Процедура ПапкаПриИзменении(Элемент)
	ирКлиент.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
КонецПроцедуры

Процедура ПапкаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	ирОбщий.ПолеВводаСИсториейВыбора_ОбновитьСписокЛкс(Элемент, ЭтаФорма);
КонецПроцедуры

ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.ОбработкаМодулейМетаданных");
Маска = "*"; 
УчитыватьОтступ = Истина;