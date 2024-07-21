﻿Перем мОболочкаРедактора;

Процедура ПриОткрытии()
	
	Если КлючУникальности = "Автотест" Тогда
		Возврат;
	КонецЕсли;
	ирКлиент.Форма_ПриОткрытииЛкс(ЭтаФорма);
	Если РедакторHTML() = Неопределено Тогда
		ЭлементыФормы.РедакторHTML.Документ.ЭтоРедактор = Истина;
		ЭлементыФормы.РедакторHTML.Перейти(мПлатформа.БазовыйФайлРедактораКода());
		мОболочкаРедактора = ирКлиент.ОболочкаПоляТекстаЛкс(ЭлементыФормы.РедакторHTML);
	КонецЕсли; 
	Если ЗначениеЗаполнено(ВариантСинтаксиса) Тогда
		КнопкаВариантаСинтаксиса = ЭлементыФормы.ДействияФормы.Кнопки.Синтаксис.Кнопки[ВариантСинтаксиса];
	КонецЕсли; 
	Если ЗначениеЗаполнено(ОбщееНазвание) Тогда
		ирОбщий.ОбновитьТекстПослеМаркераЛкс(ЭтаФорма.Заголовок,, ОбщееНазвание, ": ");
	КонецЕсли; 
	ПодменюЯзыкаНажатие(КнопкаВариантаСинтаксиса);
	
КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирКлиент.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирКлиент.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирКлиент.Форма_ПриЗакрытииЛкс(ЭтаФорма);
	// Освобождаем память для случая, когда форма в кэше
	Текст1 = ""; 
	Текст2 = ""; 

КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	Если Не ирКэш.ДоступенРедакторМонакоЛкс() Тогда 
		ирОбщий.СообщитьЛкс("В вашей конфигурации инструмент ""Сравнение текстов"" недоступен");
		Отказ = Истина;
	КонецЕсли; 
КонецПроцедуры

Функция РедакторHTML()
	Если мОболочкаРедактора = Неопределено Тогда 
		Возврат Неопределено;
	КонецЕсли; 
	Возврат мОболочкаРедактора.РедакторHTML();
КонецФункции

Процедура РедакторHTMLДокументСформирован(Элемент)
	
	Инфо = Новый СистемнаяИнформация();
	РедакторHTML = ЭлементыФормы.РедакторHTML.Документ.defaultView;
	РедакторHTML.init(Инфо.ВерсияПриложения);
	РедакторHTML.minimap(Ложь);
	РедакторHTML.setOption("disableNativeHovers", Истина); // События не перестают вызываться  // Пока не работает https://github.com/salexdv/bsl_console/issues/193
	РедакторHTML.showStatusBar(Ложь);
	РедакторHTML.updateText(Текст1);
	ЭтаФорма.ТекущийЭлемент = ЭлементыФормы.РедакторHTML;
	//РедакторHTML.editor.focus(); // Если раскоментировать, то сочетания клавиш перестают срабатывать https://github.com/salexdv/bsl_console/issues/165#issuecomment-852768520
	ОбновитьСравнение();
	
КонецПроцедуры

Процедура ОбновитьСравнение()
	
	РедакторHTML = РедакторHTML();
	Если РедакторHTML = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ПодменюСинтаксис = ЭлементыФормы.ДействияФормы.Кнопки.Синтаксис.Кнопки;
	ПодсветкаСинтаксиса = ВариантСинтаксиса <> "Нет";
	Если ВариантСинтаксиса = ПодменюСинтаксис.ВстроенныйЯзык.Имя Тогда
		РедакторHTML.setLanguageMode("bsl");
	ИначеЕсли ВариантСинтаксиса = ПодменюСинтаксис.ЯзыкЗапросов.Имя Тогда
		РедакторHTML.setLanguageMode("bsl_query");
	ИначеЕсли ВариантСинтаксиса = ПодменюСинтаксис.ЯзыкКомпоновки.Имя Тогда
		РедакторHTML.setLanguageMode("dcs_query");
	ИначеЕсли ВариантСинтаксиса = ПодменюСинтаксис.XML.Имя Тогда
		РедакторHTML.setLanguageMode("xml");
	КонецЕсли; 
	РедакторHTML.compare(Текст2, Истина, ПодсветкаСинтаксиса, Истина, УчитыватьКрайнююПустоту); // https://github.com/salexdv/bsl_console/blob/develop/docs/compare.md
	ПолеТекстаHTML = ирКлиент.ОболочкаПоляТекстаЛкс(ЭлементыФормы.РедакторHTML);
	#Если Сервер И Не Сервер Тогда
		ПолеТекстаHTML = Обработки.ирОболочкаПолеТекста.Создать();
	#КонецЕсли
	ПолеТекстаHTML.Инициировать(ЭтаФорма);

КонецПроцедуры

Процедура ДействияФормыСледующий(Кнопка = Неопределено)
	
	РедакторHTML().nextDiff();
	
КонецПроцедуры

Процедура ДействияФормыПредыдущий(Кнопка = Неопределено)
	
	РедакторHTML().previousDiff();

КонецПроцедуры

Процедура ПодменюЯзыкаНажатие(Кнопка = Неопределено)
	
	ирКлиент.ПодменюПереключателяНажатиеЛкс(ЭлементыФормы.ДействияФормы.Кнопки.Синтаксис, Кнопка);
	ЭтаФорма.ВариантСинтаксиса = Кнопка.Имя;
	ОбновитьСравнение();
	
КонецПроцедуры

Процедура ДействияФормыСравнитьВстроеннымСредством(Кнопка)
	
	ирКлиент.СравнитьЗначенияВФормеЧерезXMLЛкс(Текст1, Текст2,, Заголовок1, Заголовок2,,, ОбщееНазвание, Ложь);
	
КонецПроцедуры

Процедура КПРедакторHTMLНайтиСледующееHTML(Кнопка)
	
	РедакторHTML().nextMatch();
	
КонецПроцедуры

Процедура КПРедакторHTMLНайтиПредыдущееHTML(Кнопка)
	
	РедакторHTML().previousMatch();

КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	ирКлиент.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 
	
КонецПроцедуры

Процедура УчитыватьКрайнююПустотуПриИзменении(Элемент)
	ОбновитьСравнение();
КонецПроцедуры

ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.СравнениеТекстов");
#Если Сервер И Не Сервер Тогда
	мОболочкаРедактора = Обработки.ирОболочкаПолеТекста.Создать();
#КонецЕсли