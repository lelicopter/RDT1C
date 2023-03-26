﻿Перем мИмяОткрытогоФайла;
Перем мРасширениеФайла;
Перем мСтароеИмяПараметра;
Перем мОписаниеРасширенияФайла;
Перем мПлатформа;
Перем шИмя;
Перем мСтарыйПроверочныйТекст;
Перем мСтруктураВосстановления;
Перем мРежимРедактора Экспорт;
Перем мИсторияФайлов; 
Перем мПолеТекстаПоиска;
Перем мДокументDOM;
Перем мПоследняяПозицияПодсказки;

Функция СохраняемаяНастройкаФормы(выхНаименование, выхИменаСвойств) Экспорт 
	выхИменаСвойств = "Форма.АвтообновлениеРезультата, Форма.ПереносСлов";
	Возврат Неопределено;
КонецФункции

Процедура ОсновныеДействияФормыСохранитьНастройки(Кнопка)
	
	ирКлиент.ВыбратьИСохранитьНастройкуФормыЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ОсновныеДействияФормыЗагрузитьНастройки(Кнопка)
	
	ирКлиент.ВыбратьИЗагрузитьНастройкуФормыЛкс(ЭтаФорма);

КонецПроцедуры

Процедура ПриОткрытии()
	
	ирКлиент.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ирКлиент.СоздатьМенеджерСохраненияНастроекФормыЛкс(ЭтаФорма);
	КлсКомандаНажатие(ЭлементыФормы.КП_Вхождения.Кнопки.Идентификаторы);
	КлсКомандаНажатие(ЭлементыФормы.КП_Вхождения.Кнопки.Идентификаторы);
	мПолеТекстаПоиска = ирКлиент.ОболочкаПоляТекстаЛкс(ЭлементыФормы.ПроверочныйТекст);
	ТаблицаИзМакета = ирОбщий.ТаблицаЗначенийИзТабличногоДокументаЛкс(ПолучитьМакет("ДоступныеЭлементы"));
	ДоступныеЭлементы.Загрузить(ТаблицаИзМакета);
	Если ТипЗнч(ВладелецФормы) = Тип("Форма") Тогда
		ВладелецФормы.Панель.Доступность = Ложь;
	КонецЕсли;
	ЭлементыФормы.ТипРезультата.СписокВыбора = мПлатформа.ДоступныеЗначенияТипа(Тип("ТипРезультатаDOMXPath"));
	Если Ложь
		Или мРежимРедактора 
		Или ЗначениеЗаполнено(ПараметрВыражение) 
		Или ЗначениеЗаполнено(ПараметрПроверочныйТекст) 
	Тогда
		Если мРежимРедактора Тогда
			ЭтаФорма.РежимВыбора = Истина;
		КонецЕсли;
		СоздатьФайл();
		ЭтаФорма.Выражение = ПараметрВыражение;
		Если ПараметрПроверочныйТекст <> Неопределено Тогда
			#Если Сервер И Не Сервер Тогда
				УстановитьПроверочныйТекстОтложенно();
			#КонецЕсли
			ПодключитьОбработчикОжидания("УстановитьПроверочныйТекстОтложенно", 0.1, Истина);
		КонецЕсли; 
	Иначе
		ОписаниеФайлаВосстановления = Новый Структура;
		ИмяФайлаВосстановления = ирКлиент.ПроверитьВыбратьФайлВосстановленияКонсолиЛкс(мСтруктураВосстановления, ОписаниеФайлаВосстановления);
		Если ИмяФайлаВосстановления <> "" Тогда
			мИмяОткрытогоФайла = ИмяФайлаВосстановления;
			АвтообновлениеПроверочногоТекста = Ложь;
		Иначе
			// Попытаемся загрузить последний открывавшийся файл
			мИмяОткрытогоФайла = ирОбщий.ВосстановитьЗначениеЛкс(Метаданные().Имя + "_ИмяФайла");
			Если мИмяОткрытогоФайла = НеОпределено Тогда
				мИмяОткрытогоФайла = "";
			КонецЕсли;
		КонецЕсли;
		Если ПустаяСтрока(мИмяОткрытогоФайла) Тогда
			СоздатьФайл();
		Иначе
			ЗагрузитьИзФайла();
		КонецЕсли;
		Если ИмяФайлаВосстановления <> "" Тогда
			ЭтаФорма.Модифицированность = Истина;
			мИмяОткрытогоФайла = ирКлиент.ПослеВосстановленияФайлаКонсолиЛкс(ОписаниеФайлаВосстановления);
		КонецЕсли; 
		Кнопки = ЭлементыФормы.ДействияФормы.Кнопки;
		Кнопки.Удалить(Кнопки.Применить);
	КонецЕсли; 
	мИсторияФайлов = ирОбщий.ВосстановитьЗначениеЛкс(Метаданные().Имя + "_ИсторияФайлов");
	Если мИсторияФайлов = Неопределено Тогда
		мИсторияФайлов = Новый СписокЗначений;
	КонецЕсли;
	ОбновитьПодменюИсторииФайлов();
	ОбновитьПодсказкуДоступногоЭлемента();
	
	// Для теста
	//ирОбщий.СообщитьЛкс(1,, Истина);
	//_список = Новый СписокЗначений;
	//_список.Добавить(1);
	//_список.ВыбратьЭлемент();

КонецПроцедуры

Процедура УстановитьПроверочныйТекстОтложенно()
	
	УстановитьПроверочныйТекст(ПараметрПроверочныйТекст);
	ОбновитьВыражениеПараметра();
	ЭтаФорма.Модифицированность = Ложь;

КонецПроцедуры

Функция СоздатьФайл()
	
	мИмяОткрытогоФайла = "";
	ЭлементыФормы.ПроверочныйТекст.УстановитьТекст("");
	мСтарыйПроверочныйТекст = "";
	ЭтаФорма.Выражение = "/";
	ЭтаФорма.НачальныйПуть = "";
	ЭтаФорма.Модифицированность = Ложь; 
	СоответствияПространствИмен.Очистить();

КонецФункции

Процедура ПриЗакрытии()
	
	ирКлиент.Форма_ПриЗакрытииЛкс(ЭтаФорма);
	ирКлиент.УдалитьФайлВосстановленияКонсолиСБлокировкойЛкс(мСтруктураВосстановления);
	СохранитьИмяФайла();
	Если ТипЗнч(ВладелецФормы) = Тип("Форма") Тогда
		ВладелецФормы.Панель.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

Функция СохранитьВФайл(ЗапрашиватьСохранение = Ложь, ЗапрашиватьИмяФайла = Ложь, Знач ИмяФайла = Неопределено, СброситьМодифицированность = Истина)

	Если ИмяФайла = Неопределено Тогда
		ИмяФайла = мИмяОткрытогоФайла;
	КонецЕсли; 
	Если СброситьМодифицированность Тогда
		ОбновитьВыражениеПараметра();
	КонецЕсли; 
	Если Не ЗапрашиватьИмяФайла Тогда
		Если ЗапрашиватьСохранение Тогда
			Если Не Модифицированность Тогда
				Возврат Истина;
			Иначе
				Ответ = Вопрос("Сохранить текущий файл?", РежимДиалогаВопрос.ДаНетОтмена);
				Если Ответ = КодВозвратаДиалога.Отмена Тогда
					Возврат Ложь;
				ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
					Возврат Истина;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли; 
	КонецЕсли;
	СохраняемыеДанные = Новый Структура;
	СохраняемыеДанные.Вставить("НачальныйПуть", НачальныйПуть);
	СохраняемыеДанные.Вставить("Выражение", Выражение);
	СохраняемыеДанные.Вставить("ТипРезультата", ТипРезультата);
	СохраняемыеДанные.Вставить("ПроверочныйТекст", ЭлементыФормы.ПроверочныйТекст.ПолучитьТекст());
	СохраняемыеДанные.Вставить("СоответствияПространствИмен", СоответствияПространствИмен.Скопировать());
	//ирОбщий.СохранитьЗначениеВФайлЛкс(СохраняемыеДанные, ИмяСохраняемогоФайла);
	ДиалогВыбораФайла = ирКлиент.ДиалогВыбораФайлаЛкс(Ложь, мРасширениеФайла, мОписаниеРасширенияФайла);
	ФайлВыбран = ирКлиент.СохранитьФайлВКонсолиСВосстановлениемЛкс(ДиалогВыбораФайла, ИмяФайла, мИмяОткрытогоФайла, СохраняемыеДанные, мСтруктураВосстановления, ЗапрашиватьИмяФайла);
	Если ФайлВыбран Тогда
		СохранитьИмяФайла();
	Иначе
		Возврат Ложь;
	КонецЕсли;
	Если СброситьМодифицированность Тогда
		ЭтаФорма.Модифицированность = Ложь;
	КонецЕсли; 
	Обновить();
	Возврат Истина;

КонецФункции

Процедура ОсновныеДействияФормыОК(Кнопка)
	
	//СохранитьИзменения();
	
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если Не ПроверитьСохранитьПолноеВыражение() Тогда 
		Отказ = Истина;
	КонецЕсли; 
	
КонецПроцедуры

Функция ПроверитьСохранитьПолноеВыражение()
	
	Отказ = Ложь;
	Если Модифицированность Тогда
		ирКлиент.ПередОтображениемДиалогаПередЗакрытиемФормыЛкс(ЭтаФорма);
		Ответ = Вопрос("Выражение было изменено. Сохранить изменения?", РежимДиалогаВопрос.ДаНетОтмена);
		Если Ответ = КодВозвратаДиалога.Да Тогда
			Отказ = Не СохранитьВФайл();
		ИначеЕсли Ответ = КодВозвратаДиалога.Отмена Тогда
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	Возврат Не Отказ;

КонецФункции

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирКлиент.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОсновныеДействияФормыСтруктураФормы(Кнопка)
	
	ирКлиент.ОткрытьСтруктуруФормыЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ПанельДоступныеЭлементыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	ЭлементОтбора = ЭлементыФормы.ДоступныеЭлементы.ОтборСтрок.Категория;
	ЭлементОтбора.Установить(ЭлементыФормы.ПанельДоступныеЭлементы.ТекущаяСтраница.Имя);
	ЭлементОтбора.Использование = ЭлементыФормы.ПанельДоступныеЭлементы.ТекущаяСтраница <> ЭлементыФормы.ПанельДоступныеЭлементы.Страницы.Все;
	
КонецПроцедуры

Процедура КПВыражениеСгенерироватьПрограммныйКод(Кнопка)
	
	ПрограммныйКод = Новый Массив;
	Для Каждого СтрокаПИ Из СоответствияПространствИмен Цикл
		ПрограммныйКод.Добавить("	СоответствиеПИ.Вставить(""" + СтрокаПИ.Префикс + """, """ + СтрокаПИ.ПространствоИмен + """);");
	КонецЦикла;
	ПрограммныйКод = ирОбщий.СтрСоединитьЛкс(ПрограммныйКод, Символы.ПС);
	ПрограммныйКод = 
	"	НачальныйПуть = """ + НачальныйПуть + """;
	|	Выражение = """ + РазвернутоеВыражение() + """;
	|	СоответствиеПИ = Новый Соответствие;
	|" + ПрограммныйКод + "
	|	ЧтениеXML = Новый ЧтениеXML();
	|	ЧтениеXML.УстановитьСтроку(ТекстХМЛ);
	|	ПостроительDOM = Новый ПостроительDOM();
	|	ДокументDOM = ПостроительDOM.Прочитать(ЧтениеXML);
	|	Разыменователь = Новый РазыменовательПространствИменDOM(СоответствиеПИ); 
	|	Если ЗначениеЗаполнено(НачальныйПуть) Тогда
	|		БазовыйУзел = ДокументDOM.ВычислитьВыражениеXPath(НачальныйПуть, ДокументDOM, Разыменователь, ТипРезультатаDOMXPath.ПервыйУпорядоченныйУзел);
	|		БазовыйУзел = БазовыйУзел.ОдиночныйУзелЗначение;
	|		Если БазовыйУзел = Неопределено Тогда
	|			ВызватьИсключение ""Не найден начальный узел"";
	|		КонецЕсли;
	|	Иначе
	|		БазовыйУзел = ДокументDOM;
	|	КонецЕсли;
	|	НаборУзлов = ДокументDOM.ВычислитьВыражениеXPath(Выражение, БазовыйУзел, Разыменователь, ТипРезультатаDOMXPath." + ТипРезультата + ");
	|	УзелDOM = НаборУзлов.ПолучитьСледующий();
	|	Пока УзелDOM <> Неопределено Цикл
	|		Сообщить(УзелDOM.ТекстовоеСодержимое);
	|		УзелDOM = НаборУзлов.ПолучитьСледующий();
	|	КонецЦикла;";
	ирОбщий.ОперироватьСтруктуройЛкс(ПрограммныйКод,, Новый Структура("ТекстХМЛ", ПроверочныйТекст()));
	
КонецПроцедуры

Процедура КПВыражениеВставитьВыражение1С(Кнопка)
	
	Текст = ирКлиент.ТекстИзБуфераОбменаОСЛкс();
	Если Не ЗначениеЗаполнено(Текст) Тогда
		Возврат;
	КонецЕсли; 
	Текст = ирОбщий.ТекстИзВыраженияВстроенногоЯзыкаЛкс(Текст);
	ЗаменитьИВыделитьВыделенныйТекстВыражения(Текст);
	
КонецПроцедуры

Процедура ЗаменитьИВыделитьВыделенныйТекстВыражения(Знач Текст)
	
	ирКлиент.ЗаменитьИВыделитьВыделенныйТекстПоляЛкс(ЭтаФорма, ЭлементыФормы.ПолеТекстаВыражения, Текст);
	ОбновитьВыражениеПараметра();

КонецПроцедуры

Процедура ПанельВыражениеПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	ОбновитьВыражениеПараметра();
	
КонецПроцедуры

Процедура ОбновитьВыражениеПараметра()
	
	ПроверитьСинтаксис(Ложь);
	Если АвтообновлениеРезультата Тогда
		ОбновитьПроверочныйТекст();
	КонецЕсли; 

КонецПроцедуры

Функция ОбновитьПроверочныйТекст(РазрешитьАвтовыделение = Истина, ЭтоАвтообновлениеРезультата = Ложь)
	
	#Если Сервер И Не Сервер Тогда
		мПолеТекстаПоиска = Обработки.ирОболочкаПолеТекста.Создать();
	#КонецЕсли
	СохранитьФайлДляВосстановления();
	ДеревоРезультата.Строки.Очистить();
	ЭтаФорма.ПутьТекущиегоУзла = "";
	ТекстХМЛ = ПроверочныйТекст();
	Если Не ЗначениеЗаполнено(ТекстХМЛ) Тогда
		ЭтаФорма.ТекущийЭлемент = ЭлементыФормы.ПроверочныйТекст;
		Предупреждение("Необходимо указать проверочный XML текст");
		Возврат Истина;
	КонецЕсли;
	Успех = Истина;
	Попытка
		НаборУзлов = ВычислитьНаборУзлов(Ложь);
	Исключение 
		ОписаниеОшибки = ОписаниеОшибки();
		Если Не ЭтоАвтообновлениеРезультата Тогда
			ирОбщий.СообщитьЛкс(ОписаниеОшибки);
		КонецЕсли;
		Успех = Ложь;
	КонецПопытки;
	ОформитьПолеВыражения(ЭлементыФормы.ПолеТекстаВыражения, Успех);            
	Если Не Успех Тогда
		Возврат Ложь;
	КонецЕсли;
	УзелDOM = НаборУзлов.ПолучитьСледующий();
	Пока УзелDOM <> Неопределено Цикл
		ЗаполнитьСтрокиДерева(УзелDOM, ДеревоРезультата);
		УзелDOM = НаборУзлов.ПолучитьСледующий();
	КонецЦикла;
	Возврат Истина;

КонецФункции

Функция ВычислитьНаборУзлов(ЭтоПроверка)
	
	Если ЭтоПроверка Тогда
		ТекстХМЛ = "<r/>";
	Иначе
		ТекстХМЛ = ПроверочныйТекст();
	КонецЕсли;
	ЧтениеXML = Новый ЧтениеXML();
	ЧтениеXML.УстановитьСтроку(ТекстХМЛ);
	ПостроительDOM = Новый ПостроительDOM();
	ДокументDOM = ПостроительDOM.Прочитать(ЧтениеXML);
	СоответствиеПИ = Новый Соответствие;
	Если Не ЭтоПроверка Тогда
		ЗаполнитьСоответствияПространствИмен(ДокументDOM, ДокументDOM.ЭлементДокумента.Атрибуты);
		Для Каждого СтрокаПИ Из СоответствияПространствИмен Цикл
			СоответствиеПИ.Вставить(СтрокаПИ.Префикс, СтрокаПИ.ПространствоИмен);
		КонецЦикла;
	КонецЕсли;
	Разыменователь = Новый РазыменовательПространствИменDOM(СоответствиеПИ); 
	БазовоеВыраженияКорректно = Истина;
	Если Не ЭтоПроверка И ЗначениеЗаполнено(НачальныйПуть) Тогда
		Попытка
			БазовыйУзел = ДокументDOM.ВычислитьВыражениеXPath(НачальныйПуть, ДокументDOM, Разыменователь, ТипРезультатаDOMXPath.ПервыйУпорядоченныйУзел);
			БазовыйУзел = БазовыйУзел.ОдиночныйУзелЗначение;
			БазовоеВыраженияКорректно = БазовыйУзел <> Неопределено;
		Исключение
			ОформитьПолеВыражения(ЭлементыФормы.НачальныйПуть, Ложь);            
			ВызватьИсключение;
		КонецПопытки;
		ОформитьПолеВыражения(ЭлементыФормы.НачальныйПуть, БазовыйУзел <> Неопределено);            
		Если БазовыйУзел = Неопределено Тогда
			ВызватьИсключение "Не найден начальный узел";
		КонецЕсли;
	Иначе
		БазовыйУзел = ДокументDOM;
	КонецЕсли;
	НаборУзлов = ДокументDOM.ВычислитьВыражениеXPath(РазвернутоеВыражение(), БазовыйУзел, Разыменователь, ТипРезультатаDOMXPath[ТипРезультата]);
	Если Не ЭтоПроверка Тогда
		мДокументDOM = ДокументDOM;
	КонецЕсли;
	Возврат НаборУзлов;

КонецФункции    

Процедура ЗаполнитьСоответствияПространствИмен(УзелDOM, Атрибуты)
	
	СчетчикTNS = 0;
	ПрефиксTNS = "t";
	Если Атрибуты <> Неопределено Тогда
		Для Каждого Атрибут Из Атрибуты Цикл
			Если Атрибут.Префикс = "xmlns" Тогда
				мСтроки = СоответствияПространствИмен.НайтиСтроки(Новый Структура("Префикс", Атрибут.ЛокальноеИмя));
				Если мСтроки.Количество() = 0 Тогда
					СтрокаПИ = СоответствияПространствИмен.Добавить();
					СтрокаПИ.Префикс = Атрибут.ЛокальноеИмя;
					СтрокаПИ.ПространствоИмен = Атрибут.Значение;
					Если Атрибут.ЛокальноеИмя = ПрефиксTNS Тогда
						СчетчикTNS = СчетчикTNS + 1;
						СтрокаПИ.Префикс = ПрефиксTNS + СчетчикTNS;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			Если УзелDOM.ПространствоИменПоУмолчанию(Атрибут.Значение) Тогда
				мСтроки = СоответствияПространствИмен.НайтиСтроки(Новый Структура("Префикс", ПрефиксTNS));
				Если мСтроки.Количество() = 0 Тогда
					СтрокаПИ = СоответствияПространствИмен.Добавить();
					СтрокаПИ.Префикс = ПрефиксTNS;
					СтрокаПИ.ПространствоИмен = Атрибут.Значение;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	Если УзелDOM.ЕстьДочерниеУзлы() Тогда
		Для каждого ДочернийУзел из УзелDOM.ДочерниеУзлы Цикл
			ЗаполнитьСоответствияПространствИмен(ДочернийУзел, ДочернийУзел.Атрибуты);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьСтрокиДерева(УзелDOM, СтрокаДерева)
	
	НоваяСтрока = СтрокаДерева.Строки.Добавить();
	НоваяСтрока.ИмяЭлемента = Строка(УзелDOM.ИмяУзла);
	НоваяСтрока.ТипУзла = Строка(УзелDOM.ТипУзла);
	НоваяСтрока.Значение = Строка(УзелDOM.ЗначениеУзла);
	НоваяСтрока.УзелДокумента = УзелDOM;
	Если УзелDOM.ТипУзла = ТипУзлаDOM.Атрибут Тогда
		НоваяСтрока.ИндексКартинки = 0;
	ИначеЕсли УзелDOM.ТипУзла = ТипУзлаDOM.Элемент Тогда
		НоваяСтрока.ИндексКартинки = 1;
	ИначеЕсли УзелDOM.ТипУзла = ТипУзлаDOM.Документ Тогда
		НоваяСтрока.ИндексКартинки = 2;
	ИначеЕсли УзелDOM.ТипУзла = ТипУзлаDOM.Комментарий Тогда
		НоваяСтрока.ИндексКартинки = 3;
	ИначеЕсли УзелDOM.ТипУзла = ТипУзлаDOM.Текст Тогда
		НоваяСтрока.ИндексКартинки = 4;
	Иначе
		НоваяСтрока.ИндексКартинки = 9;
	КонецЕсли;
	Если УзелDOM.ЕстьАтрибуты() Тогда
		Для каждого Атрибут из УзелDOM.Атрибуты Цикл
			Если Атрибут.ЛокальноеИмя <> "xmlns" И Атрибут.Префикс <> "xmlns" Тогда
				ЗаполнитьСтрокиДерева(Атрибут, НоваяСтрока);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	Если УзелDOM.ЕстьДочерниеУзлы() Тогда
		Для каждого ДочернийУзел из УзелDOM.ДочерниеУзлы Цикл
			ЗаполнитьСтрокиДерева(ДочернийУзел, НоваяСтрока);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Функция ПроверочныйТекст()
	
	#Если Сервер И Не Сервер Тогда
		мПолеТекстаПоиска = Обработки.ирОболочкаПолеТекста.Создать();
	#КонецЕсли
	Текст = мПолеТекстаПоиска.ПолучитьТекст();
	Возврат Текст;

КонецФункции

Функция УстановитьПроверочныйТекст(Текст)
	
	ПолеТекста = ирКлиент.ОболочкаПоляТекстаЛкс(ЭлементыФормы.ПроверочныйТекст);
	#Если Сервер И Не Сервер Тогда
		 ПолеТекста = Обработки.ирОболочкаПолеТекста.Создать();
	 #КонецЕсли
	ПолеТекста.УстановитьОтображаемыйТекст(Текст, ПереносСлов);
	Возврат Текст;

КонецФункции

Функция РазвернутоеВыражение()
	
	Возврат Выражение;
	
КонецФункции

Процедура ПолеТекстаВыраженияАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	
	ирКлиент.ПромежуточноеОбновлениеСтроковогоЗначенияПоляВводаЛкс(ЭтаФорма, Элемент, Текст);
	ОбновитьВыражениеПараметра();

КонецПроцедуры 

Процедура ОбновитьПодсказкуДоступногоЭлемента()
	
	//ПолеТекста = ирКлиент.ОболочкаПоляТекстаЛкс(ЭлементыФормы.ПолеТекстаВыражения);
	//#Если Сервер И Не Сервер Тогда
	//	ПолеТекста = Обработки.ирОболочкаПолеТекста.Создать();
	//#КонецЕсли
	//КонечнаяПозиция = Неопределено;
	//ПолеТекста.ВыделениеОдномерное(, КонечнаяПозиция);
	//Если мПоследняяПозицияПодсказки <> КонечнаяПозиция Тогда
	//	мПоследняяПозицияПодсказки = КонечнаяПозиция;
	//	КонечнаяПозиция = КонечнаяПозиция - 1;
	//	Текст = ПолеТекста.ПолучитьТекст();
	//	Фрагмент = Лев(Текст, КонечнаяПозиция);
	//	Фрагмент = ирОбщий.ПоследнийФрагментЛкс(Фрагмент, "/");
	//	Фрагмент = ирОбщий.ПервыйФрагментЛкс(Фрагмент, "(", Ложь);
	//	Если ЗначениеЗаполнено(Фрагмент) Тогда
	//		Фрагмент = Фрагмент + "(";
	//	КонецЕсли;
	//	ДоступныйЭлемент = ДоступныеЭлементы.Найти(Фрагмент, "Индекс");
	//	Если Истина
	//		И ДоступныйЭлемент <> Неопределено 
	//		И ЭлементыФормы.ДоступныеЭлементы.ТекущаяСтрока <> ДоступныйЭлемент
	//	Тогда
	//		ЭлементыФормы.ПанельДоступныеЭлементы.ТекущаяСтраница = ЭлементыФормы.ПанельДоступныеЭлементы.Страницы.Все;
	//		ЭлементыФормы.ДоступныеЭлементы.ТекущаяСтрока = ДоступныйЭлемент;
	//	КонецЕсли;
	//КонецЕсли;
	//ПодключитьОбработчикОжидания("ОбновитьПодсказкуДоступногоЭлемента", 1, Истина);

КонецПроцедуры

Процедура ПолеТекстаВыраженияПриИзменении(Элемент)
	
	ирКлиент.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма, 40);
	ОбновитьВыражениеПараметра();

КонецПроцедуры

Процедура КПВыражениеСправкаПоСинтаксису(Кнопка)
	
	ЗапуститьПриложение("https://infostart.ru/1c/articles/415439/");
	ЗапуститьПриложение("https://infostart.ru/public/280340/");

КонецПроцедуры

Процедура ДействияФормыНовоеОкно(Кнопка)
	
	ирКлиент.ОткрытьНовоеОкноФормыЛкс(ЭтотОбъект);
	
КонецПроцедуры

Процедура ДействияФормыНовыйФайл(Кнопка)
	
	Если ПроверитьСохранитьПолноеВыражение() Тогда
		СоздатьФайл();
	КонецЕсли;

КонецПроцедуры

Процедура ДействияФормыСохранитьФайл(Кнопка)
	
	СохранитьВФайл();
	
КонецПроцедуры

Процедура ДействияФормыСохранитьКак(Кнопка)
	
	СохранитьВФайл(, Истина);
	
КонецПроцедуры

Процедура ДействияФормыОткрытьФайл(Кнопка)
	
	Если Не ПроверитьСохранитьПолноеВыражение() Тогда
		Возврат;
	КонецЕсли; 
	ОткрытьФайл();
	
КонецПроцедуры

Процедура ОткрытьФайл()
	
	ИмяФайла = ирКлиент.ВыбратьФайлЛкс(, мРасширениеФайла, мОписаниеРасширенияФайла);
	Если ИмяФайла = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ОткрытьФайлПоПолномуИмени(ИмяФайла);

КонецПроцедуры

Процедура ЗагрузитьИзФайлаОтложенно()
	ЗагрузитьИзФайла();
КонецПроцедуры

Процедура ЗагрузитьИзФайла(ИмяФайла = "")
	
	Если Не ЗначениеЗаполнено(ИмяФайла) Тогда
		ИмяФайла = мИмяОткрытогоФайла;
	КонецЕсли; 
	//ЗагружаемыеДанные = ирОбщий.ЗагрузитьЗначениеИзФайлаЛкс(ИмяВыбранногоФайла);
	ЗагружаемыеДанные = ирКлиент.ПрочитатьЗначениеИзФайлаСКонтролемПотерьЛкс(ИмяФайла);
	Если ЗагружаемыеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	#Если Сервер И Не Сервер Тогда
		ЗагружаемыеДанные = Новый Структура;
	#КонецЕсли
	ЭтаФорма.Модифицированность = Ложь;  
	СоответствияПространствИмен.Очистить();
	//УстановитьЗаголовокФормы();
	ЭтаФорма.НачальныйПуть = ЗагружаемыеДанные.НачальныйПуть;
	ЭтаФорма.Выражение = ЗагружаемыеДанные.Выражение;
	ЭтаФорма.ТипРезультата = ЗагружаемыеДанные.ТипРезультата;
	ЭтаФорма.ПроверочныйТекстНовый = ЗагружаемыеДанные.ПроверочныйТекст;
	ирОбщий.ЗагрузитьВТаблицуЗначенийЛкс(ЗагружаемыеДанные.СоответствияПространствИмен, СоответствияПространствИмен);
	ПроверочныйТекстДокументСформирован();
	УстановитьПроверочныйТекст("");

КонецПроцедуры

Процедура СохранитьФайлДляВосстановления()
	
	//ОбновитьВыражениеПараметра(); // Рекурсия
	СохранитьВФайл(,, мСтруктураВосстановления.ФайлВосстановления.ПолноеИмя, Ложь);
	
КонецПроцедуры 

Процедура ОбновлениеОтображения()
	
	ирОбщий.ОбновитьЗаголовокФормыСОткрытымФайломЛкс(ЭтаФорма, мИмяОткрытогоФайла);
	ирКлиент.Форма_ОбновлениеОтображенияЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ДоступныеЭлементыНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	ТекстВставки = ТекстВставкиДоступногоЭлемента();
	//ТекстВставки = СтрЗаменить(ТекстВставки, "шаблон", "");
	ПараметрыПеретаскивания.Значение = ТекстВставки;
	
КонецПроцедуры

Функция ТекстВставкиДоступногоЭлемента()
	
	ТекстВставки = ЭлементыФормы.ДоступныеЭлементы.ТекущаяСтрока.ТекстВставки;
	Если Не ЗначениеЗаполнено(ТекстВставки) Тогда
		ТекстВставки = ЭлементыФормы.ДоступныеЭлементы.ТекущаяСтрока.Текст;
	КонецЕсли;
	Возврат ТекстВставки;

КонецФункции

Процедура ДоступныеЭлементыВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ВыделенныйТекст = ЭлементыФормы.ПолеТекстаВыражения.ВыделенныйТекст;
	ТекстВставки = ТекстВставкиДоступногоЭлемента();
	ТекстВставки = СтрЗаменить(ТекстВставки, "шаблон", ВыделенныйТекст);
	ЗаменитьИВыделитьВыделенныйТекстВыражения(ТекстВставки);
	
КонецПроцедуры

Процедура КПВыражениеУстановитьФокус(Кнопка)
	
	ЭтаФорма.ТекущийЭлемент = ЭлементыФормы.ПолеТекстаВыражения;
	
КонецПроцедуры

Процедура КПВыражение1ПроверитьСинтаксис(Кнопка)
	
	ПроверитьСинтаксис(Истина, Истина);
	
КонецПроцедуры

Функция ПроверитьСинтаксис(СообщатьОшибку = Ложь, СообщатьУспех = Ложь)
	
	Успех = Истина;
	ОписаниеОшибки = "";
	Попытка
		ВычислитьНаборУзлов(Истина);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		Если ИнформацияОбОшибке.Причина <> Неопределено Тогда
			ИнформацияОбОшибке = ИнформацияОбОшибке.Причина;
		КонецЕсли; 
		ОписаниеОшибки = ИнформацияОбОшибке.Описание;
		Успех = Ложь;
	КонецПопытки;
	ОформитьПолеВыражения(ЭлементыФормы.ПолеТекстаВыражения, Успех);
	Если Не Успех Тогда
		Если СообщатьОшибку Тогда
			Сообщить(ОписаниеОшибки, СтатусСообщения.Внимание);
		КонецЕсли;
	Иначе
		Если СообщатьУспех Тогда 
			Сообщить("Выражение корректно");
		КонецЕсли; 
	КонецЕсли; 
	Возврат Успех;

КонецФункции

Процедура ОформитьПолеВыражения(Знач ПолеВвода, Знач Успех)
	
	Если Успех Тогда
		НовыйЦвет = Новый Цвет;
	Иначе
		НовыйЦвет = WebЦвета.Красный;
	КонецЕсли;
	ПолеВвода.ЦветТекстаПоля = НовыйЦвет;

КонецПроцедуры 

Процедура ВычислитьНажатие(Элемент)
	
	Если Не ОбновитьПроверочныйТекст() Тогда 
		ПроверитьСинтаксис(Истина);
	КонецЕсли;
	
КонецПроцедуры

Процедура АвтообновлениеРезультатаПриИзменении(Элемент)
	
	АвтообновлениеПроверочногоТекста();
	
КонецПроцедуры

Процедура АвтообновлениеПроверочногоТекста()
	
	Если АвтообновлениеРезультата Тогда
		ОбновитьПроверочныйТекст();
	КонецЕсли;

КонецПроцедуры

Функция ПолучитьВыделениеВПроверочномТексте()
	
	#Если Сервер И Не Сервер Тогда
		мПолеТекстаПоиска = Обработки.ирОболочкаПолеТекста.Создать();
	#КонецЕсли
	ВыделениеВТексте = мПолеТекстаПоиска.ПолучитьВыделениеВДокументеHTML();
	Возврат ВыделениеВТексте;

КонецФункции

Процедура УстановитьВыделениеВПроверочномТексте(Знач ВыделениеВТексте, Знач РодительскийУзел = Неопределено)
	
	#Если Сервер И Не Сервер Тогда
		мПолеТекстаПоиска = Обработки.ирОболочкаПолеТекста.Создать();
	#КонецЕсли
	мПолеТекстаПоиска.УстановитьВыделениеВДокументеHTML(ВыделениеВТексте, РодительскийУзел);
	
КонецПроцедуры

Процедура ВыделитьГруппуВПроверочномТексте(Знач ВыбраннаяГруппа)
	
	#Если Сервер И Не Сервер Тогда
		мПолеТекстаПоиска = Обработки.ирОболочкаПолеТекста.Создать();
	#КонецЕсли
	ИндексПодгруппы = ЭлементыФормы.Подгруппы.ТекущаяСтрока.Индекс;
	мПолеТекстаПоиска.ВыделитьРезультатПоиска(ВыбраннаяГруппа, ИндексПодгруппы);

КонецПроцедуры

Процедура КПВыражениеЭкранироватьТекст(Кнопка)
	
	ВыделенныйТекст = ЭлементыФормы.ПолеТекстаВыражения.ВыделенныйТекст;
	Если Не ЗначениеЗаполнено(ВыделенныйТекст) Тогда
		ВыделенныйТекст = ЭлементыФормы.ПолеТекстаВыражения.Значение;
		Если Не ЗначениеЗаполнено(ВыделенныйТекст) Тогда
			Возврат;
		КонецЕсли; 
		ЭлементыФормы.ПолеТекстаВыражения.УстановитьГраницыВыделения(1, СтрДлина(ВыделенныйТекст) + 1);
	КонецЕсли; 
	ТекстВставки = ирОбщий.ПреобразоватьТекстДляРегулярныхВыраженийЛкс(ВыделенныйТекст);
	ЗаменитьИВыделитьВыделенныйТекстВыражения(ТекстВставки);
	
КонецПроцедуры

Процедура ПереносСловПриИзменении(Элемент)
	
	УстановитьПроверочныйТекст(ПроверочныйТекст());
	
КонецПроцедуры

Процедура ОбновитьПроверочныйТекстОтложенно()
	
	ОбновитьПроверочныйТекст(Ложь);
	
КонецПроцедуры

Процедура ПроверочныйТекстonkeypress(Элемент, pEvtObj)
	
	Если АвтообновлениеРезультата Тогда
		ПодключитьОбработчикОжидания("ОбновитьПроверочныйТекстОтложенно", 1, Истина);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДействияФормыПрименить(Кнопка)
	
	ирКлиент.ПрименитьИзмененияИЗакрытьФормуЛкс(ЭтаФорма, Выражение);
	
КонецПроцедуры

Процедура КПВыражениеРазэкранироватьТекст(Кнопка)
	// Вставить содержимое обработчика.
КонецПроцедуры

Процедура КПВыражениеОткрытьВыражениеНаСайтеRegex101(Кнопка)
	
	Если ирКэш.НомерВерсииПлатформыЛкс() < 803001 Тогда
		ирОбщий.СообщитьЛкс("Для функции требуется платформа 8.3 и выше");
		Возврат;
	КонецЕсли; 
	//РазвернутоеВыражение = ПолеТекстаВыражения;
	//КодированнаяСтрока = Вычислить("КодироватьСтроку(РазвернутоеВыражение, СпособКодированияСтроки.КодировкаURL)");
	СтрокаURL = "https://codebeautify.org/Xpath-Tester";
	ЗапуститьПриложение(СтрокаURL);
	
КонецПроцедуры

Процедура ВхожденияПодгруппыВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если Ложь
		//Или Колонка = ЭлементыФормы.ВхожденияПодгруппы.Колонки.ЗначениеПодгруппы 
		//Или Колонка = ЭлементыФормы.ВхожденияПодгруппы.Колонки.ПозицияПодгруппы
		//Или Колонка = ЭлементыФормы.ВхожденияПодгруппы.Колонки.ДлинаПодгруппы
	Тогда
		ВыделитьГруппуВПроверочномТексте(ВыбраннаяСтрока);
	Иначе
		ирКлиент.ЯчейкаТабличногоПоляРасширенногоЗначения_ВыборЛкс(ЭтаФорма, Элемент, СтандартнаяОбработка);
	КонецЕсли; 
	
КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирКлиент.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирКлиент.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирКлиент.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	ирКлиент.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура КПВыражениеСравнить(Кнопка)
	
	ирКлиент.ЗапомнитьСодержимоеЭлементаФормыДляСравненияЛкс(ЭтаФорма, ЭлементыФормы.ПолеТекстаВыражения);
	
КонецПроцедуры

Процедура ПроверочныйТекстДокументСформирован(Элемент = Неопределено)
	
	Если ЗначениеЗаполнено(ПроверочныйТекстНовый) Тогда
		ЭлементыФормы.ПроверочныйТекст.УстановитьТекст(ПроверочныйТекстНовый);
		Если Элемент <> Неопределено Тогда
			ЭтаФорма.ПроверочныйТекстНовый = "";
		КонецЕсли; 
	КонецЕсли; 

КонецПроцедуры

// Сохраняет имя файла и путь к нему для использования в последующих сеансах работы
//
// Параметры:
//  Нет.
//
Процедура СохранитьИмяФайла()
	
	ирОбщий.СохранитьЗначениеЛкс(Метаданные().Имя + "_ИмяФайла", мИмяОткрытогоФайла);
	Если ЗначениеЗаполнено(мИмяОткрытогоФайла) Тогда
		ирКлиент.ДобавитьФайлВИсториюФормыЛкс(мИсторияФайлов, мИмяОткрытогоФайла);
		ирОбщий.СохранитьЗначениеЛкс(Метаданные().Имя + "_ИсторияФайлов", мИсторияФайлов);
		ОбновитьПодменюИсторииФайлов();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбновитьПодменюИсторииФайлов()
	
	//Если Не мРежимРедактора Тогда
		Кнопки = ЭлементыФормы.ДействияФормы.Кнопки.ОткрытьПоследние.Кнопки;
		ирКлиент.ОбновитьПодменюИсторииФайловЛкс(мИсторияФайлов, Кнопки);
	//КонецЕсли; 
	
КонецПроцедуры

Процедура ОткрытьФайлИзИстории(Кнопка) 
	
	Если СохранитьВФайл(Истина) Тогда
		СтрокаИстории = мИсторияФайлов[Число(Сред(Кнопка.Имя, 2))];
		ОткрытьФайлПоПолномуИмени(СтрокаИстории.Значение);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОткрытьФайлПоПолномуИмени(ПолноеИмяФайла)
	
	мИмяОткрытогоФайла = ПолноеИмяФайла;
	ЗагрузитьИзФайла();
	СохранитьИмяФайла();
	
КонецПроцедуры

Процедура ПолеТекстаВыраженияНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	ирОбщий.ПолеВводаСИсториейВыбора_ОбновитьСписокЛкс(Элемент, ЭтаФорма);
КонецПроцедуры

Процедура ДеревоРезультатаПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ирКлиент.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
	ОформлениеСтроки.Ячейки.ИмяЭлемента.ОтображатьКартинку = Истина;
	ОформлениеСтроки.Ячейки.ИмяЭлемента.ИндексКартинки = ДанныеСтроки.ИндексКартинки;
	
КонецПроцедуры

Процедура ДеревоРезультатаПриАктивизацииСтроки(Элемент)
	ирКлиент.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	Если Элемент.ТекущаяСтрока <> Неопределено Тогда
		ЭтаФорма.ПутьТекущиегоУзла = ПутьКУзлу(Элемент.ТекущаяСтрока.УзелДокумента);
	КонецЕсли;
КонецПроцедуры

Процедура ДоступныеЭлементыПриАктивизацииСтроки(Элемент)
	ирКлиент.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
КонецПроцедуры

Процедура ДоступныеЭлементыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	ирКлиент.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
КонецПроцедуры

Процедура ТипРезультатаПриИзменении(Элемент)
	ОбновитьВыражениеПараметра();
КонецПроцедуры

Процедура КП_ПроверочныйТекстФорматироватьXML(Кнопка)

	УстановитьПроверочныйТекст(ирОбщий.ФорматироватьТекстXMLЛкс(ПроверочныйТекст()));

КонецПроцедуры

Процедура КП_ПроверочныйТекстОткрытьВРедакторе(Кнопка)
	Текст = ПроверочныйТекст();
	Если ирКлиент.ОткрытьЗначениеЛкс(Текст) Тогда 
		УстановитьПроверочныйТекст(Текст);
	КонецЕсли;
КонецПроцедуры

Функция ПутьКУзлу(Знач ТекущийУзел)
	
	Если ТекущийУзел.РодительскийУзел <> Неопределено Тогда
		Если ТекущийУзел.ТипУзла = ТипУзлаDOM.Элемент Тогда
			Если ТекущийУзел = мДокументDOM.ЭлементДокумента Тогда
				ИмяУзла = ТекущийУзел.ИмяУзла;
			Иначе
				СчетчикСоседей = 0;
				СоседнийУзел = ТекущийУзел.ПредыдущийСоседний;
				Пока СоседнийУзел <> Неопределено Цикл
					СчетчикСоседей = СчетчикСоседей + 1;
					СоседнийУзел = СоседнийУзел.ПредыдущийСоседний;
				КонецЦикла;
				ИмяУзла = ТекущийУзел.ИмяУзла + "[" + (СчетчикСоседей+1) + "]";
			КонецЕсли;
		ИначеЕсли ТекущийУзел.ТипУзла = ТипУзлаDOM.Текст Тогда
			ИмяУзла = "text()";
		Иначе
			ИмяУзла = ТекущийУзел.ИмяУзла;
		КонецЕсли;
		Если ПустаяСтрока(ТекущийУзел.Префикс) Тогда
			ЗаписьСоответствияПространствИмен = СоответствияПространствИмен.Найти(ТекущийУзел.URIПространстваИмен, "ПространствоИмен");
			Если Истина
				И ЗаписьСоответствияПространствИмен <> Неопределено
				И Не ПустаяСтрока(ЗаписьСоответствияПространствИмен.Префикс) 
			Тогда
				ИмяУзла = ЗаписьСоответствияПространствИмен.Префикс + ":" + ИмяУзла;
			КонецЕсли;
		КонецЕсли;
		Возврат ПутьКУзлу(ТекущийУзел.РодительскийУзел) + "/" + ИмяУзла;
	Иначе
		Если ТекущийУзел.ТипУзла = ТипУзлаDOM.Документ Тогда
			Возврат "";
		ИначеЕсли ТекущийУзел.ТипУзла = ТипУзлаDOM.Атрибут Тогда
			Возврат ПутьКУзлу(ТекущийУзел.ЭлементВладелец) + "/@" + ТекущийУзел.ИмяУзла;
		Иначе
			Возврат ТекущийУзел.ИмяУзла;
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

Процедура КП_ВхожденияУстановитьБазовым(Кнопка)
	
	ТекущаяСтрока = ЭлементыФормы.ДеревоРезультата.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ПутьКУзлу = ПутьКУзлу(ТекущаяСтрока.УзелДокумента);
	ирКлиент.ИнтерактивноЗаписатьВПолеВводаЛкс(ЭлементыФормы.НачальныйПуть, ПутьКУзлу);
	ирКлиент.ИнтерактивноЗаписатьВПолеВводаЛкс(ЭлементыФормы.ПолеТекстаВыражения, "node()");
	
КонецПроцедуры

Процедура БазовыйУзелПриИзменении(Элемент)
	ирКлиент.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма, 40);
	ОбновитьВыражениеПараметра();
КонецПроцедуры

Процедура БазовыйУзелНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	ирОбщий.ПолеВводаСИсториейВыбора_ОбновитьСписокЛкс(Элемент, ЭтаФорма);
КонецПроцедуры

Процедура ПолеТекстаВыраженияОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Если Не ЗначениеЗаполнено(НачальныйПуть) Тогда
		ЭтаФорма.Выражение = "/";
	Иначе
		ЭтаФорма.Выражение = "node()";
	КонецЕсли;
	ОбновитьВыражениеПараметра();
КонецПроцедуры

Процедура КП_ВхожденияУстановитьВВыражение(Кнопка)
	ТекущаяСтрока = ЭлементыФормы.ДеревоРезультата.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ПутьКУзлу = ПутьКУзлу(ТекущаяСтрока.УзелДокумента);
	ирКлиент.ИнтерактивноЗаписатьВПолеВводаЛкс(ЭлементыФормы.НачальныйПуть, "");
	ирКлиент.ИнтерактивноЗаписатьВПолеВводаЛкс(ЭлементыФормы.ПолеТекстаВыражения, ПутьКУзлу);
КонецПроцедуры

ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирКонструкторВыраженияXPath.Форма.Форма");
мПлатформа = ирКэш.Получить();
шИмя = мПлатформа.шИмя;
мРежимРедактора = Ложь;
мРасширениеФайла = "rxp";
ТипРезультата = "Любой";
ДеревоРезультата.Колонки.Добавить("ИндексКартинки");   
ДеревоРезультата.Колонки.Добавить("УзелДокумента");

мОписаниеРасширенияФайла = "Выражение XPath";
АвтообновлениеПроверочногоТекста = Истина;
Автовыделение = Истина;
ПереносСлов = Истина;
мСтруктураВосстановления = ирКлиент.ПолучитьСтруктуруВосстановленияКонсолиЛкс("irXPathConstructor");
ЭтаФорма.ПроверочныйТекстНовый = "не загружен";