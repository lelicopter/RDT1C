﻿
Процедура КнопкаОКНажатие(Кнопка = Неопределено)

	ОповеститьОВыборе(Текст);
	
КонецПроцедуры

Процедура НадписьКакСохранитьНажатие(Элемент)
	
	Форма = ирОбщий.ОткрытьФормуЛкс("Обработка.ирПортативный.Форма.ФормаНастроек");
	Форма.ЭлементыФормы.Панель.ТекущаяСтраница = Форма.ЭлементыФормы.Панель.Страницы.Настройки;
	
КонецПроцедуры

Процедура НадписьФункцииДляОтладкиНажатие(Элемент)
	
	мПлатформа.ПолучитьФорму("ФункцииРежимаОтладки").Открыть();
	
КонецПроцедуры

Процедура ОсновныеДействияФормыПоследнийСохраненный(Кнопка)
	
	ЭтаФорма.Текст = ирОбщий.РезультатСохраненияОбъектаОтложеннойОтладкиВНастройкуЛкс();
	КнопкаОКНажатие();
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ДоступенСписокХранения = Метаданные.Справочники.Найти("ирОбъектыДляОтладки") <> Неопределено Или ЗначениеЗаполнено(ирОбщий.ПолучитьКаталогОбъектовДляОтладкиЛкс(Истина));
	Если ДоступенСписокХранения Тогда
		ЭлементыФормы.ОсновныеДействияФормы.Кнопки.Удалить(ЭлементыФормы.ОсновныеДействияФормы.Кнопки.ПоследнийСохраненный);
	КонецЕсли; 
	ЭлементыФормы.НадписьПриЗакрытии.Видимость = ДоступенСписокХранения;
	ЭлементыФормы.НадписьНастройкиСохранения.Видимость = Не ирКэш.ЛиПортативныйРежимЛкс();
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирОбщий.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура ОсновныеДействияФормыОбучающееВидео(Кнопка)
	
	ЗапуститьПриложение("https://youtu.be/-NJJP79TccI");
	
КонецПроцедуры

ирОбщий.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.ОткрытьОбъектДляОтладки");
