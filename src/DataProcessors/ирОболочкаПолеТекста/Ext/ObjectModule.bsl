﻿//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирКлиент Экспорт;

#Если Клиент Тогда

Перем РедакторHTML; // Кэш
Перем НачальнаяСтрока, НачальнаяКолонка, КонечнаяСтрока, КонечнаяКолонка; // Временные переменные для всех методов
Перем ВременноеПолеВвода;
Перем ЛиВнутриУстановкиТекста;
Перем мПлатформа;

// Получает интерфейс редактора MonacoBSL
Функция РедакторHTML() Экспорт
	Если Истина
		И РедакторHTML = Неопределено 
		И ЛиПолеHTMLДокумента()
	Тогда
		РедакторHTML = ЭлементФормы.Документ.defaultView;
		Попытка
			Если Не ЗначениеЗаполнено(РедакторHTML.version1C) Тогда 
				// WebKit
				РедакторHTML = Неопределено;
			КонецЕсли; 
		Исключение
			// IE
			РедакторHTML = Неопределено;
		КонецПопытки;
	КонецЕсли;
	Возврат РедакторHTML;
КонецФункции

Функция ЛиПолеHTMLДокумента()
	
	Результат = Ложь
		Или ТипЗнч(ЭлементФормы) = Тип("ПолеHTMLДокумента")
		Или (Истина
			И ТипЗнч(ЭлементФормы) = Тип("ПолеФормы") 
			И (Ложь
				Или ЭлементФормы.Вид = ВидПоляФормы.ПолеHTMLДокумента));
	Возврат Результат;

КонецФункции

// Процедура - Установить границы выделения
//
// Параметры:
//  НачальнаяСтрокаИлиПозиция			 - 	 - 
//  НачальнаяКолонкаИлиКонечнаяПозиция	 - 	 - 
//  КонечнаяСтрока						 - 	 - 
//  КонечнаяКолонка						 - 			 - 
//  Активировать						 - 			 - 
//  ЭтаФорма							 - Форма - нужно передавать для формы и поля и исправления ошибки платформы 8.3.22 с прокруткой
//
Процедура УстановитьГраницыВыделения(Знач НачальнаяСтрокаИлиПозиция, Знач НачальнаяКолонкаИлиКонечнаяПозиция, Знач КонечнаяСтрока = Неопределено, Знач КонечнаяКолонка = Неопределено,
	Знач Активировать = Ложь, Знач ЭтаФорма = Неопределено) Экспорт 

	Если ЛиПолеHTMLДокумента() Тогда
		РедакторHTML = РедакторHTML();
		Если РедакторHTML = Неопределено Тогда
			Выделение = Новый Структура; 
			Если КонечнаяСтрока = Неопределено Тогда
				Выделение.Вставить("Начало", НачальнаяСтрокаИлиПозиция);
				Выделение.Вставить("Конец", НачальнаяКолонкаИлиКонечнаяПозиция);
			Иначе
				Выделение.Вставить("Начало", ОдномернаяПозицияИзДвумерной(НачальнаяСтрокаИлиПозиция, НачальнаяКолонкаИлиКонечнаяПозиция));
				Выделение.Вставить("Конец", ОдномернаяПозицияИзДвумерной(КонечнаяСтрока, КонечнаяКолонка));
			КонецЕсли;
			УстановитьВыделениеВДокументеHTML(Выделение);
		Иначе
			Если КонечнаяСтрока = Неопределено Тогда
				РедакторHTML.setSelectionByLength(НачальнаяСтрокаИлиПозиция, НачальнаяКолонкаИлиКонечнаяПозиция);
			Иначе
				РедакторHTML.setSelection(НачальнаяСтрокаИлиПозиция, НачальнаяКолонкаИлиКонечнаяПозиция, КонечнаяСтрока, КонечнаяКолонка);
			КонецЕсли; 
			Если Активировать Тогда
				РедакторHTML.editor.focus();
			КонецЕсли;
		КонецЕсли; 
	Иначе
		Если КонечнаяСтрока = Неопределено Тогда
			ЭлементФормы.УстановитьГраницыВыделения(НачальнаяСтрокаИлиПозиция, НачальнаяКолонкаИлиКонечнаяПозиция);
		Иначе
			ЭлементФормы.УстановитьГраницыВыделения(НачальнаяСтрокаИлиПозиция, НачальнаяКолонкаИлиКонечнаяПозиция, КонечнаяСтрока, КонечнаяКолонка);
		КонецЕсли; 
		Если Истина
			// Похоже эта проверка не улучшает логику работы, а только лишь немного ускоряет
			И ЭтаФорма <> Неопределено
			И ЭтаФорма.ТекущийЭлемент = ЭлементФормы
			И ирКэш.НомерИзданияПлатформыЛкс() >= "83" // https://www.hostedredmine.com/issues/934802
		Тогда 
			// Антибаг платформы https://www.hostedredmine.com/issues/929519 
			ирКлиент.УстановитьФокусВводаФормеЛкс();
			#Если Сервер И Не Сервер Тогда
				мПлатформа = Обработки.ирПлатформа.Создать()
			#КонецЕсли
			Если Истина
				И мПлатформа.ИспользоватьЭмуляциюНажатияКлавиш() 
				И ирКэш.НомерВерсииПлатформыЛкс() = 803022 
			Тогда
				// Антибаг платформы 8.3.22 https://www.hostedredmine.com/issues/958530
				ирКлиент.ОтправитьНажатияКлавишЛкс("+{right}");
				ирКлиент.ОтправитьНажатияКлавишЛкс("+{left}");
			КонецЕсли;
		КонецЕсли; 
	КонецЕсли; 

КонецПроцедуры

Функция ДвухмернаяПозицияИзОдномерной(Позиция)
	
	Результат = Новый Структура("НомерСтроки, НомерКолонки");
	// TODO
	//УстановитьГраницыВыделения(1, Позиция);
	//Текст = ВыделенныйТекст();
	//Результат.НомерСтроки = СтрЧислоВхождений(Текст, Символы.ПС);
	//Результат.НомерКолонки = СтрДлина(СтрПолучитьСтроку(Текст, Результат.НомерСтроки));
	Возврат Результат;
	
КонецФункции

Функция ОдномернаяПозицияИзДвумерной(НомерСтроки, НомерКолонки)
	
	// TODO Сделать через рег. выражение подсчетом номер вхождения любого разделителя строк
	Возврат 1;
	
КонецФункции

Процедура ПолучитьГраницыВыделения(НачальнаяСтрока, НачальнаяКолонка, КонечнаяСтрока, КонечнаяКолонка) Экспорт 

	Если ЛиПолеHTMLДокумента() Тогда
		РедакторHTML = РедакторHTML();
		Если РедакторHTML = Неопределено Тогда
			// TODO отличить монако и обычный редакторы
			//ВыделениеТекста = ПолучитьВыделениеВДокументеHTML();
			//КоординатыПозиции = ДвухмернаяПозицияИзОдномерной(ВыделениеТекста.Начало);
			//НачальнаяСтрока = КоординатыПозиции.НомерСтроки;
			//НачальнаяКолонка = КоординатыПозиции.НомерКолонки;
			//КоординатыПозиции = ДвухмернаяПозицияИзОдномерной(ВыделениеТекста.Начало);
			//КонечнаяСтрока = КоординатыПозиции.НомерСтроки;
			//КонечнаяКолонка = КоординатыПозиции.НомерКолонки;
		Иначе
			ВыделениеТекста = РедакторHTML.getSelection();
			НачальнаяСтрока = ВыделениеТекста.startLineNumber;
			НачальнаяКолонка = ВыделениеТекста.startColumn;
			КонечнаяСтрока = ВыделениеТекста.endLineNumber;
			КонечнаяКолонка = ВыделениеТекста.endColumn;
		КонецЕсли; 
	Иначе
		ЭлементФормы.ПолучитьГраницыВыделения(НачальнаяСтрока, НачальнаяКолонка, КонечнаяСтрока, КонечнаяКолонка);
	КонецЕсли; 

КонецПроцедуры

Функция ПолучитьТекст() Экспорт

	Если ЛиПолеHTMLДокумента() Тогда
		РедакторHTML = РедакторHTML();
		Если РедакторHTML = Неопределено Тогда
			// TODO отличить монако и обычный редакторы
			Если ирКэш.ДоступенБраузерWebKitЛкс() Тогда
				ДокументHtml = ЭлементФормы.Документ;
				//Текст = ДокументHtml.body.textContent;
				Текст = ДокументHtml.body.innerText;
			Иначе
				Текст = ЭлементФормы.ПолучитьТекст();
				ДокументHtml = ирОбщий.ПолучитьHtmlFileИзТекстаHtmlЛкс(Текст); // Тут переносы строк другое количество символов дают. Скорее всего из-за Символы.ВК
				Текст = ДокументHtml.body.innerText;
			КонецЕсли;
		Иначе
			Текст = РедакторHTML.getText();
		КонецЕсли; 
	ИначеЕсли ТипЗнч(ЭлементФормы) = Тип("ПолеВвода") Тогда
		Текст = ЭлементФормы.Значение;
	ИначеЕсли ТипЗнч(ЭлементФормы) = Тип("ПолеФормы") Тогда
		Текст = ирОбщий.ДанныеЭлементаФормыЛкс(ЭлементФормы);
	Иначе
		Текст = ЭлементФормы.ПолучитьТекст();
	КонецЕсли; 
	Возврат Текст;

КонецФункции

Функция УстановитьТекст(Знач Текст, Активировать = Ложь, ИсходныйТекст = Неопределено, СохранитьГраницыВыделения = Ложь) Экспорт 

	Если СохранитьГраницыВыделения Тогда
		СтруктураВыделения = ВыделениеДвумерное();
	КонецЕсли; 
	Если ЛиПолеHTMLДокумента() Тогда
		РедакторHTML = РедакторHTML();
		Если РедакторHTML = Неопределено Тогда
			Возврат Ложь;
			// TODO отличить монако и обычный редакторы
			//УстановитьТелоHTML(ирОбщий.КодироватьТекстВXMLЛкс(Текст));
		Иначе
			Если СтрЧислоСтрок(Текст) <> СтрЧислоСтрок(ПолучитьТекст()) Тогда
				РедакторHTML.removeAllBookmarks();
			КонецЕсли; 
			Если Активировать Тогда
				РедакторHTML.editor.focus();
			КонецЕсли;
			// https://github.com/salexdv/bsl_console/issues/141#issuecomment-852355305
			РедакторHTML.updateText(Текст);
			//РедакторHTML.editor.setValue(Текст); // Так история редактирования сбрасывается и устанавливается модифицированность
			Если ИсходныйТекст <> Неопределено Тогда
				РедакторHTML.setOriginalText(ИсходныйТекст);
			КонецЕсли;
			УстановитьДекорации();
		КонецЕсли; 
	ИначеЕсли ТипЗнч(ЭлементФормы) = Тип("ПолеВвода") Тогда
		ЭлементФормы.Значение = Текст;
	ИначеЕсли ТипЗнч(ЭлементФормы) = Тип("ПолеФормы") Тогда
		ЭтаФорма = Неопределено;
		ПутьКДанным = "";
		ирОбщий.ДанныеЭлементаФормыЛкс(ЭлементФормы, ПутьКДанным, ЭтаФорма);
		Если ЗначениеЗаполнено(ПутьКДанным) Тогда
			Выполнить("ЭтаФорма." + ПутьКДанным + " = Текст");
		КонецЕсли; 
	Иначе
		ЭлементФормы.УстановитьТекст(Текст);
	КонецЕсли; 
	Если СохранитьГраницыВыделения Тогда
		УстановитьВыделениеДвумерное(СтруктураВыделения);
	КонецЕсли; 
	Возврат Истина;

КонецФункции

Процедура УстановитьДекорации(Знач МассивСтрок = Неопределено) Экспорт 
	
	Если МассивСтрок = Неопределено Тогда
		МассивСтрок = Новый Массив;
	КонецЕсли;
	РедакторHTML.setLineNumbersDecorations(ирОбщий.ОбъектВСтрокуJSONЛкс(МассивСтрок));

КонецПроцедуры

Функция ПолучитьСтроку(НомерСтроки) Экспорт 

	Если ТипЗнч(ЭлементФормы) = Тип("ПолеВвода") Тогда
		ТекстовыйДокумент =  Новый ТекстовыйДокумент;
		ТекстовыйДокумент.УстановитьТекст(ЭлементФормы.Значение);
		Текст = ТекстовыйДокумент.ПолучитьСтроку(НомерСтроки);
	ИначеЕсли ЛиПолеHTMLДокумента() Тогда
		РедакторHTML = РедакторHTML();
		Если РедакторHTML = Неопределено Тогда
			Возврат Неопределено;
		КонецЕсли; 
		Текст = РедакторHTML.getLineContent(НомерСтроки);
	Иначе
		Текст = ЭлементФормы.ПолучитьСтроку(НомерСтроки);
	КонецЕсли; 
	Возврат Текст;

КонецФункции

Функция КоличествоСтрок() Экспорт 

	Если ЛиПолеHTMLДокумента() Тогда
		РедакторHTML = РедакторHTML();
		Если РедакторHTML = Неопределено Тогда
			Возврат Неопределено;
		КонецЕсли; 
		Текст = РедакторHTML.getLineCount();
	Иначе
		Текст = ЭлементФормы.КоличествоСтрок();
	КонецЕсли; 
	Возврат Текст;

КонецФункции

Функция ВыделенныйТекст(НовыйТекст = Неопределено) Экспорт 

	Если ЛиПолеHTMLДокумента() Тогда
		РедакторHTML = РедакторHTML();
		Если РедакторHTML = Неопределено Тогда
			Возврат Неопределено;
		КонецЕсли; 
		Если НовыйТекст = Неопределено Тогда
			Результат = РедакторHTML.selectedText();
		Иначе
			РедакторHTML.selectedText(НовыйТекст);
			//// https://github.com/salexdv/bsl_console/issues/64#issue-873784658
			//ПолучитьГраницыВыделения(НачальнаяСтрока, НачальнаяКолонка, КонечнаяСтрока, КонечнаяКолонка);
			//УстановитьГраницыВыделения(КонечнаяСтрока, КонечнаяКолонка, КонечнаяСтрока, КонечнаяКолонка);
		КонецЕсли;
	Иначе
		Если НовыйТекст = Неопределено Тогда
			Результат = ЭлементФормы.ВыделенныйТекст;
		Иначе
			ЭлементФормы.ВыделенныйТекст = НовыйТекст;
		КонецЕсли; 
	КонецЕсли; 
	Возврат Результат;

КонецФункции

Функция ТолькоПросмотр(НовыйРежим = Неопределено) Экспорт 

	Если ЛиПолеHTMLДокумента() Тогда
		РедакторHTML = РедакторHTML();
		Если РедакторHTML = Неопределено Тогда
			Возврат Неопределено;
		КонецЕсли; 
		Если НовыйРежим = Неопределено Тогда
			Результат = РедакторHTML.getReadOnly();
		Иначе
			РедакторHTML.setReadOnly(НовыйРежим);
		КонецЕсли;
	Иначе
		Если НовыйРежим = Неопределено Тогда
			Результат = ЭлементФормы.ТолькоПросмотр;
		Иначе
			ЭлементФормы.ТолькоПросмотр = НовыйРежим;
		КонецЕсли; 
	КонецЕсли; 
	Возврат Результат;

КонецФункции

Процедура ЗаменитьСтроку(НомерСтроки, Текст) Экспорт 

	Если ЛиПолеHTMLДокумента() Тогда
		РедакторHTML = РедакторHTML();
		Если РедакторHTML = Неопределено Тогда
			Возврат;
		КонецЕсли; 
		РедакторHTML.setLineContent(НомерСтроки, Текст);  // https://github.com/salexdv/bsl_console/issues/90
		//УстановитьГраницыВыделения(НомерСтроки, 1 , НомерСтроки, СтрДлина(ПолучитьСтроку(НомерСтроки)) + 1);
		//ВыделенныйТекст(Текст);
	Иначе
		ЭлементФормы.ЗаменитьСтроку(НомерСтроки, Текст); // Баг платформы. Вызывает выделение всего предшествующего текста на 8.3.18
	КонецЕсли; 

КонецПроцедуры

Процедура ВставитьСтроку(НомерСтроки, Текст) Экспорт 

	Если ЛиПолеHTMLДокумента() Тогда
		РедакторHTML = РедакторHTML();
		Если РедакторHTML = Неопределено Тогда
			Возврат;
		КонецЕсли; 
		РедакторHTML.insertLine(НомерСтроки, Текст);
	Иначе
		ЭлементФормы.ВставитьСтроку(НомерСтроки, Текст);
	КонецЕсли; 

КонецПроцедуры

Процедура ДобавитьСтроку(Текст) Экспорт 

	Если ЛиПолеHTMLДокумента() Тогда
		РедакторHTML = РедакторHTML();
		Если РедакторHTML = Неопределено Тогда
			Возврат;
		КонецЕсли; 
		//ДлинаТекста = СтрДлина(ПолучитьТекст());
		//РедакторHTML.setText(Символы.ПС + Текст, ДлинаТекста);
		РедакторHTML.AddLine(Текст);
	Иначе
		ЭлементФормы.ДобавитьСтроку(Текст);
	КонецЕсли; 

КонецПроцедуры

// Заменяет выделенный текст новым
Процедура ВставитьТекст(Знач НовыйТекст, Знач ДобавитьНовуюСтрокуПосле = Истина) Экспорт 
	
	НачальнаяПозиция = 0;
	КонечнаяПозиция = 0;
	ПолучитьГраницыВыделения(НачальнаяПозиция, КонечнаяПозиция, НачальнаяПозиция, КонечнаяПозиция);
	ВыделенныйТекст(НовыйТекст);
	Если ДобавитьНовуюСтрокуПосле Тогда
		// Антибаг 8.3.12 https://partners.v8.1c.ru/forum/t/1719342/m/1719342, http://www.hostedredmine.com/issues/882423
		ВыделенныйТекст(Символы.ПС);
	КонецЕсли;
	УстановитьГраницыВыделения(НачальнаяПозиция, КонечнаяПозиция, НачальнаяПозиция, КонечнаяПозиция);

КонецПроцедуры

Процедура Очистить() Экспорт 

	Если ЛиПолеHTMLДокумента() Тогда
		РедакторHTML = РедакторHTML();
		Если РедакторHTML = Неопределено Тогда
			Возврат;
		КонецЕсли; 
		РедакторHTML.eraseText();
	Иначе
		ЭлементФормы.Очистить();
	КонецЕсли; 

КонецПроцедуры

Процедура ПоказатьОшибку(НомерСтроки, НомерКолонки = 1, ЭтаФорма = Неопределено) Экспорт 
	Если ЛиПолеHTMLДокумента() Тогда
		РедакторHTML = РедакторHTML();
		Если РедакторHTML = Неопределено Тогда
			Возврат;
		КонецЕсли; 
		УстановитьГраницыВыделения(НомерСтроки, 1, НомерСтроки, 1,, ЭтаФорма);
		РедакторHTML.markError(НомерСтроки, НомерКолонки);
	Иначе
		УстановитьГраницыВыделения(НомерСтроки, 1, НомерСтроки, 150,, ЭтаФорма);
	КонецЕсли; 
КонецПроцедуры

Процедура ПолучитьПозициюКаретки(ВКОбщая, Форма, Панель) Экспорт 
	
	РедакторHTML = РедакторHTML();
	Если РедакторHTML <> Неопределено Тогда
		Координаты = РедакторHTML.getPositionOffset();
		ВременноеПолеВвода = Форма.ЭлементыФормы.Добавить(Тип("ПолеВвода"), "ПолеВвода" + ирОбщий.СуффиксСлужебногоСвойстваЛкс(), Истина, Панель);
		ВременноеПолеВвода.Лево = 0;
		ВременноеПолеВвода.Верх = 0;
		ВременноеПолеВвода.Высота = 20;
		ВременноеПолеВвода.Ширина = 1;
		Форма.ТекущийЭлемент = ВременноеПолеВвода;

		// Стало необходимо в 8.3.19, иначе фокус не переходил в это поле сразу и координаты каретки получались пустые
		//Форма.Обновить(); 
		Форма.Открыть(); 
		
		ВКОбщая.ПолучитьПозициюКаретки(Координаты.left, Координаты.top + 8);
		Форма.ТекущийЭлемент = ЭлементФормы;
		Форма.ЭлементыФормы.Удалить(ВременноеПолеВвода);
	Иначе
		Форма.Активизировать();
		ВКОбщая.ПолучитьПозициюКаретки(0, 0);
	КонецЕсли; 
	
КонецПроцедуры

Функция КоординатыКурсора() Экспорт 
	ПолучитьГраницыВыделения(НачальнаяСтрока, НачальнаяКолонка, КонечнаяСтрока, КонечнаяКолонка);
	Результат = Новый Структура("НомерСтроки, НомерКолонки", КонечнаяСтрока, КонечнаяКолонка);
	Возврат Результат;
КонецФункции

Процедура Инициировать() Экспорт 
	// Настройки шрифта и окна автодополнения тут
	#Если Сервер И Не Сервер Тогда
		Обработки.ирПлатформа.Создать().БазовыйФайлРедактораКода();
	#КонецЕсли
	
	РедакторHTML = ЭлементФормы.Документ.defaultView;
	ЭлементСтиля = РедакторHTML.document.createElement("style");
	ЭлементСтиля.setAttribute("type", "text/css");
	ЭлементСтиля.innerHTML = "
	// Убираем полосы прокрутки 1С
	|body {
	|	overflow: hidden;
	|}
	// Цвета статусной строки
	|.statusbar-widget {
	|	background: #c2dfef;
	|	color: #000;
	|}
	// Окно подсказки по вызову метода
	|.editor-widget.parameter-hints-widget .code {
	|	font-size: 13px !important;
	|	line-height: 15px;
	|}
	|.editor-widget.parameter-hints-widget .docs {
	|	font-size: 13px !important;
	|	line-height: 15px;
	|}
	|.editor-widget.parameter-hints-widget.visible {
	|  max-width: 600px;
	|}
	|.monaco-editor .parameter-hints-widget > .wrapper {
	|  max-width: 600px;
	|}
	|.monaco-editor-hover .monaco-editor-hover-content {
  	|	max-width: 600px;
	|}
	// Подсказка удержания
	|.monaco-editor-hover .hover-row {
	|	font-size: 13px !important;
	|	line-height: 15px;
	|}
	// Подсказка автодополнения
	|.monaco-editor .suggest-widget {
	|	width: 500px;
	|}
	// Подсказка автодополнения вместе с окном детальной инфы
	|.monaco-editor .suggest-widget.docs-side {
	|	width: 1000px;
	|}
	|.monaco-editor .suggest-widget.docs-side > .details {
	|	width: 60%;
	|	max-height: 800px !important;
	|}
	|.monaco-editor .suggest-widget.docs-side > .tree {
	|	width: 40%;
	|	float: left;
	|}";
	РедакторHTML.document.head.appendChild(ЭлементСтиля);
	РедакторHTML.showStatusBar(Ложь); // параметр Ложь - отображаем снизу справа
	РедакторHTML.renderWhitespace(Истина);
	РедакторHTML.setFontSize(13);
	РедакторHTML.setLineHeight(15);
	РедакторHTML.disableContextMenu();
	РедакторHTML.setOption("autoResizeEditorLayout", Истина); // https://github.com/salexdv/bsl_console/issues/185
	//РедакторHTML.setOption("lineHeight", 15);  // Высота строки редактора https://github.com/salexdv/bsl_console/issues/195
	//РедакторHTML.setOption("suggestFontSize", 13); // шрифт окна автодополнения https://github.com/salexdv/bsl_console/issues/194
	//РедакторHTML.setOption("suggestLineHeight", 15); // шрифт окна автодополнения https://github.com/salexdv/bsl_console/issues/194
	//ИмяШрифта = ирКэш.ИмяШрифтаРедактораМодуляКонфигуратораЛкс();
	//Если ЗначениеЗаполнено(ИмяШрифта) Тогда
	//	РедакторHTML.setFontFamily(ИмяШрифта);
	//Иначе
		РедакторHTML.setFontFamily("Lucida Console");
	//КонецЕсли; 
КонецПроцедуры

Процедура Перерисовать() Экспорт 
	РедакторHTML = РедакторHTML();
	РедакторHTML.editor.layout();
КонецПроцедуры

Процедура ЗагрузитьСостояниеИзПоляТекстаЛкс(Знач ПолеИсточник, Знач ИсходныйТекст) Экспорт 
	#Если Сервер И Не Сервер Тогда
		ПолеИсточник = ЭтотОбъект;
	#КонецЕсли
	ПолеИсточник.ПолучитьГраницыВыделения(НачальнаяСтрока, НачальнаяКолонка, КонечнаяСтрока, КонечнаяКолонка);
	УстановитьТекст(ПолеИсточник.ПолучитьТекст(), Истина, ИсходныйТекст);
	УстановитьГраницыВыделения(НачальнаяСтрока, НачальнаяКолонка, КонечнаяСтрока, КонечнаяКолонка);
	ТолькоПросмотр(ПолеИсточник.ТолькоПросмотр());
КонецПроцедуры

Функция СостояниеИсторииИзменения() Экспорт 
	РедакторHTML = РедакторHTML();
	Результат = РедакторHTML.editor.saveViewState();
	Возврат Результат;
КонецФункции

Процедура ВосстановитьСостояниеИсторииИзменения(Состояние) Экспорт 
	РедакторHTML = РедакторHTML();
	РедакторHTML.editor.restoreViewState(Состояние);
КонецПроцедуры

// Процедура - Показать последнюю строку
//
// Параметры:
//  ЭтаФорма	- Форма - нужно передавать для активации поля и для исправления ошибки платформы 8.3.22 с прокруткой
//
Процедура ПоказатьПоследнююСтроку(ЭтаФорма = Неопределено) Экспорт 
	НомерСтроки = Макс(1, КоличествоСтрок()); // https://www.hostedredmine.com/issues/891268
	Если НомерСтроки > 1 Тогда
		УстановитьГраницыВыделения(НомерСтроки, 1, НомерСтроки, 1,, ЭтаФорма);
	КонецЕсли; 
КонецПроцедуры

Функция ОбработатьКликНаГиперссылке(Событие) Экспорт 
	СобытиеОбработано = Ложь;
	ЗаголовокГиперссылки = Событие.params.label;
	ЗначениеГиперссылки = Событие.params.href;
	Если Ложь
		Или ЗаголовокГиперссылки = "перейти по ссылке" 
		Или ирОбщий.СтрНачинаетсяСЛкс(ЗначениеГиперссылки, "http")
	Тогда
		ЗапуститьПриложение(ЗначениеГиперссылки);
		СобытиеОбработано = Истина;
	КонецЕсли;
	Возврат СобытиеОбработано;
КонецФункции

Функция НоваяСтруктураДвумерногоВыделения() Экспорт 
	
	Структура = Новый Структура();
	Структура.Вставить("НачальнаяСтрока", 1);
	Структура.Вставить("НачальнаяКолонка", 1);
	Структура.Вставить("КонечнаяСтрока", 1);
	Структура.Вставить("КонечнаяКолонка", 1);
	Возврат Структура;
		
КонецФункции

Функция ВыделениеДвумерное() Экспорт
	
	Структура = НоваяСтруктураДвумерногоВыделения();
	ПолучитьГраницыВыделения(Структура.НачальнаяСтрока, Структура.НачальнаяКолонка, Структура.КонечнаяСтрока, Структура.КонечнаяКолонка);
	Возврат Структура;
	
КонецФункции

Функция УстановитьВыделениеДвумерное(Знач Структура) Экспорт
	
	Если Структура.НачальнаяКолонка <= 0 Тогда
		Структура.НачальнаяКолонка = 1;
	КонецЕсли; 
	Если Структура.НачальнаяСтрока <= 0 Тогда
		Структура.НачальнаяСтрока = 1;
	КонецЕсли; 
	Если Структура.НачальнаяКолонка > Структура.КонечнаяКолонка Тогда
		Структура.КонечнаяКолонка = Структура.НачальнаяКолонка;
	КонецЕсли; 
	Если Структура.НачальнаяСтрока > Структура.КонечнаяСтрока Тогда
		Структура.КонечнаяСтрока = Структура.НачальнаяСтрока;
	КонецЕсли; 
	УстановитьГраницыВыделения(Структура.НачальнаяСтрока, Структура.НачальнаяКолонка, Структура.КонечнаяСтрока, Структура.КонечнаяКолонка);
	Возврат Неопределено;
	
КонецФункции

// Функция - Позиция в поле текста по номеру строки и колонки. Портит текущее незаконченное выделение мышкой!
//
// Параметры:
//  КонечнаяСтрока	 - 	 - 
//  КонечнаяКолонка	 - 	 - 
// 
// Возвращаемое значение:
//  - Число - начиная с 1
//
Функция ПозицияВПолеТекстаПоНомеруСтрокиИКолонки(Знач КонечнаяСтрока, Знач КонечнаяКолонка, Знач СлужебноеПолеТекста = Неопределено) Экспорт 
	
	Если СлужебноеПолеТекста = Неопределено Тогда
		СлужебноеПолеТекста = СлужебноеПолеТекста();
	КонецЕсли;
	СлужебноеПолеТекста.УстановитьГраницыВыделения(1, 1, КонечнаяСтрока, КонечнаяКолонка);
	Результат = СтрДлина(СлужебноеПолеТекста.ВыделенныйТекст) + 1;
	Возврат Результат;

КонецФункции

Функция СлужебноеПолеТекста()
	
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать()
	#КонецЕсли
	СлужебноеПолеТекста = мПлатформа.СлужебноеПолеТекста;
	СлужебноеПолеТекста.УстановитьТекст(ПолучитьТекст());
	Возврат СлужебноеПолеТекста;

КонецФункции

// Процедура - Выделение одномерное
//
// Параметры:
//  выхНачальнаяПозиция	 - Число - начиная с 1
//  выхКонечнаяПозиция	 - Число - начиная с 1
//
Процедура ВыделениеОдномерное(выхНачальнаяПозиция, выхКонечнаяПозиция = Неопределено) Экспорт 
	
	ПолучитьГраницыВыделения(НачальнаяСтрока, НачальнаяКолонка, КонечнаяСтрока, КонечнаяКолонка);
	СлужебноеПолеТекста = СлужебноеПолеТекста();
	выхНачальнаяПозиция = ПозицияВПолеТекстаПоНомеруСтрокиИКолонки(НачальнаяСтрока, НачальнаяКолонка, СлужебноеПолеТекста);
	выхКонечнаяПозиция = ПозицияВПолеТекстаПоНомеруСтрокиИКолонки(КонечнаяСтрока, КонечнаяКолонка, СлужебноеПолеТекста);

КонецПроцедуры

Функция РазметитьТекстРезультатамиПоиска(Знач Текст = "", Знач РезультатыПоиска, Знач ИндексПодгруппы = -1, Знач ПереносСлов = Истина) Экспорт 
	
	Если Не ЛиПолеHTMLДокумента() Тогда
		ВызватьИсключение "Доступно только в поле HTML";
	КонецЕсли;  
	Если Не ЗначениеЗаполнено(Текст) Тогда
		Текст = ПолучитьТекст();
	КонецЕсли;
	ЭтотОбъект.РезультатыПоиска = РезультатыПоиска;
	#Если Сервер И Не Сервер Тогда
		РезультатыПоиска = Новый ТаблицаЗначений;
	#КонецЕсли
	МаркерКонецПодгруппы = "</SPAN>";
	Результат = Новый ЗаписьXML;
	Результат.УстановитьСтроку("");
	Старт = Истина;
	Финиш = 0;
	ЗначениеЧередования = Ложь;
	МаксРаскашиваемыхВхождений = 1000;
	//МассивЦветов = Новый Массив;
	//МассивЦветов.Добавить("yellow");
	//МассивЦветов.Добавить("cyan");
	//МассивЦветов.Добавить("#CCFF66"); // светло-зеленый
	//МассивЦветов.Добавить("orange");
	РаскрашеноВхождений = 0; 
	ЕстьКолонкаГиперссылки = РезультатыПоиска.Колонки.Найти("ЛиГиперссылка") <> Неопределено;
	Для каждого Группа Из РезультатыПоиска Цикл
		Если Группа.ПозицияПодгруппы = Неопределено Или РаскрашеноВхождений > МаксРаскашиваемыхВхождений Тогда
			Продолжить;
		КонецЕсли; 
		Если ИндексПодгруппы = -1 Тогда
			ТекстПодгруппы = Группа.Значение;
		Иначе
			ТекстПодгруппы = Группа.Подгруппы[ИндексПодгруппы].Значение;
		КонецЕсли;
		Если ТекстПодгруппы = Неопределено Тогда
			Продолжить;
		КонецЕсли; 
		ПозицияПодгруппы = Группа.ПозицияПодгруппы;
		ДлинаПодгруппы = Группа.ДлинаПодгруппы;
		Если Старт Тогда
			Если Группа.ПозицияПодгруппы <> 0 Тогда
				Результат.ЗаписатьБезОбработки(ирОбщий.КодироватьТекстВXMLЛкс(Сред(Текст, 1, ПозицияПодгруппы)));
			КонецЕсли;
			Старт = Ложь;
		ИначеЕсли Финиш <> 0 Тогда
			Результат.ЗаписатьБезОбработки(ирОбщий.КодироватьТекстВXMLЛкс(Сред(Текст, Финиш, ПозицияПодгруппы - Финиш + 1)));
		КонецЕсли;
		ЗначениеПодгруппы = ирОбщий.КодироватьТекстВXMLЛкс(ТекстПодгруппы);
		Если ЗначениеЧередования Тогда
			ИмяЦвета = "cyan";
		Иначе
			ИмяЦвета = "yellow";
		КонецЕсли;      
		Если ЕстьКолонкаГиперссылки И Группа.ЛиГиперссылка Тогда
			// https://stackoverflow.com/questions/42692953/make-hyperlinks-selectable
			ТегВхождения = "<A data-href=""" + "" + """ style=""text-decoration: underline"">" + ЗначениеПодгруппы + "</A>";
		Иначе
			ТегВхождения = "<SPAN id=""" + ИдентификаторПодгруппыВРазмеченномТексте(Группа.Номер, ИндексПодгруппы) + """ style=""background-color: " + ИмяЦвета + """>" + ЗначениеПодгруппы + "</SPAN>";
		КонецЕсли;
		Результат.ЗаписатьБезОбработки(ТегВхождения);
		РаскрашеноВхождений = РаскрашеноВхождений + 1;
		Финиш = ПозицияПодгруппы + ДлинаПодгруппы + 1;
		ЗначениеЧередования = Не ЗначениеЧередования;
	КонецЦикла;
	Результат.ЗаписатьБезОбработки(ирОбщий.КодироватьТекстВXMLЛкс(Сред(Текст, Финиш)));
	Результат = Результат.Закрыть();
	УстановитьТелоHTML(Результат, ПереносСлов);
	
КонецФункции

Процедура УстановитьТелоHTML(Знач ТекстHTML, Знач ПереносСлов = Истина)
	
	ОформлениеТекста = "<pre style=""FONT-SIZE: 10pt; FONT-FAMILY: Courier New; color: #000000; tab-size: 4;";
	Если ПереносСлов Тогда                              
		// https://developer.mozilla.org/ru/docs/Web/CSS/overflow-wrap
		// normal, keep-all и остальные вебкит не поддерживает, т.к. в нем используется режим совместимости IE7.0 https://forum.mista.ru/topic.php?id=884540
		ОформлениеТекста = ОформлениеТекста + " word-wrap: break-word; white-space: pre-wrap;"; 
	КонецЕсли; 
	ОформлениеТекста = ОформлениеТекста + """>";
	РаскрашенныйТекст = "<HTML lang=""ru-Ru""><HEAD><BODY>" + ОформлениеТекста + РаскрашенныйТекст + ТекстHTML + "</BODY></HEAD></HTML>";
	ДокументHtml = ЭлементФормы.Документ;
	//ДокументHtml.body.innerHTML = РаскрашенныйТекст;
	ДокументHtml.documentElement.innerHTML = РаскрашенныйТекст;

КонецПроцедуры

Процедура УстановитьОтображаемыйТекст(Знач Текст, Знач ПереносСлов = Истина) Экспорт 
	
	УстановитьТелоHTML(ирОбщий.КодироватьТекстВXMLЛкс(Текст), ПереносСлов);

КонецПроцедуры

Функция ИдентификаторПодгруппыВРазмеченномТексте(Знач НомерГруппы, Знач ИндексПодгруппы = Неопределено) Экспорт 
	
	Если ИндексПодгруппы < 0 Тогда
		ИндексПодгруппы = "";
	Иначе
		ИндексПодгруппы = XMLСтрока(ИндексПодгруппы);
	КонецЕсли;
	Возврат "Match" + НомерГруппы + "_SubMatch" + ИндексПодгруппы;

КонецФункции

Процедура ВыделитьРезультатПоиска(Знач РезультатПоиска, Знач ИндексПодгруппы = -1) Экспорт 
	
	#Если Сервер И Не Сервер Тогда
		РезультатПоиска = РезультатыПоиска.Добавить();
	#КонецЕсли
	ДокументHtml = ЭлементФормы.Документ;
	ИДНужныйУзел = ИдентификаторПодгруппыВРазмеченномТексте(РезультатПоиска.Номер, ИндексПодгруппы);
	ТегГруппы = Неопределено;
	//ТегГруппы = ДокументHtml.getElementByID(ИДНужныйУзел); // начиная с 8.3.14 так не работает
	ТегГруппы = ДокументHtml.querySelector("[id = " + ИДНужныйУзел + "]");
	ТелоДокумента = ДокументHtml.body;
	Если ТегГруппы <> Неопределено Тогда
		Если ирКэш.ДоступенБраузерWebKitЛкс() Тогда
			ВыделениеВТексте = Новый Структура;
			ВыделениеВТексте.Вставить("Начало", 0);
			ВыделениеВТексте.Вставить("НачалоБезПереносов", 0);
			ВыделениеВТексте.Вставить("Конец", РезультатПоиска.Длина);
			ВыделениеВТексте.Вставить("КонецБезПереносов", 0);
			УстановитьВыделениеВДокументеHTML(ВыделениеВТексте, ТегГруппы);
		Иначе
			Диапазон = ТелоДокумента.createTextRange();
			Диапазон.moveToElementText(ТегГруппы);
			Диапазон.scrollIntoView();
			Диапазон.Select();
		КонецЕсли; 
	КонецЕсли;

КонецПроцедуры

Функция ПолучитьВыделениеВДокументеHTML() Экспорт  
	
	ВыделениеВТексте = Новый Структура;
	ДокументHtml = ЭлементФормы.Документ;
	ТелоДокумента = ДокументHtml.body;
	Если ирКэш.ДоступенБраузерWebKitЛкс() Тогда
		ТекущееВыделение = ДокументHtml.getSelection();
		Диапазон = ДокументHtml.createRange();
		Диапазон.setStart(ДокументHtml.body, 0); // !!! Без этой строки начало диапазона может захватывать какой то мусор. Видимо ошибка платформы
		Диапазон.setEnd(ТекущееВыделение.anchorNode, ТекущееВыделение.anchorOffset);
		ТекстВыделения = Диапазон.toString();
		Начало = СтрДлина(ТекстВыделения);
		ТекстВыделения = СтрЗаменить(ТекстВыделения, Символы.ПС, "");
		НачалоБезПереносов = СтрДлина(ТекстВыделения);
		Диапазон = ДокументHtml.createRange();
		Диапазон.setStart(ТекущееВыделение.anchorNode, ТекущееВыделение.anchorOffset);
		Диапазон.setEnd(ТекущееВыделение.focusNode, ТекущееВыделение.focusOffset);
		ТекстВыделения = Диапазон.toString();
		Конец = Начало + СтрДлина(ТекстВыделения);
		ТекстВыделения = СтрЗаменить(ТекстВыделения, Символы.ПС, "");
		КонецБезПереносов = НачалоБезПереносов + СтрДлина(ТекстВыделения);
		ВыделениеВТексте.Вставить("Начало", Начало);
		ВыделениеВТексте.Вставить("НачалоБезПереносов", НачалоБезПереносов);
		ВыделениеВТексте.Вставить("Конец", Конец);
		ВыделениеВТексте.Вставить("КонецБезПереносов", КонецБезПереносов);
	Иначе
		ТекущееВыделение = ДокументHtml.Selection.createRange();
		Диапазон = ТелоДокумента.createTextRange();
		Диапазон.setEndPoint("EndToStart", ТекущееВыделение);
		ВыделениеВТексте.Вставить("Начало", СтрДлина(Диапазон.Text));
		ВыделениеВТексте.Вставить("НачалоБезПереносов", СтрДлина(СтрЗаменить(Диапазон.Text, Символы.ПС, "")));
		Диапазон.setEndPoint("EndToEnd", ТекущееВыделение);
		ВыделениеВТексте.Вставить("Конец", СтрДлина(Диапазон.Text));
		ВыделениеВТексте.Вставить("КонецБезПереносов", СтрДлина(СтрЗаменить(Диапазон.Text, Символы.ПС, "")));
	КонецЕсли;
	Возврат ВыделениеВТексте;

КонецФункции

Процедура УстановитьВыделениеВДокументеHTML(Знач ВыделениеВТексте, РодительскийУзел = Неопределено) Экспорт 
	
	ДокументHtml = ЭлементФормы.Документ;
	ТелоДокумента = ДокументHtml.body;
	Если РодительскийУзел = Неопределено Тогда
		РодительскийУзел = ТелоДокумента;
	КонецЕсли; 
	Если ирКэш.ДоступенБраузерWebKitЛкс() Тогда
		//ВыделенныйТекст = Диапазон.toString(); // Для отладки
		РодительскийУзел.scrollIntoViewIfNeeded();
		Диапазон = ДокументHtml.createRange();
		Диапазон.selectNodeContents(РодительскийУзел);
		ТекстовыеУзлы = ТекстовыеУзлыHTMLВнутри(РодительскийУзел);
		НачалоНайдено = Ложь;
		СчетчикСимволов = 0;
		СчетчикУзлов = 0;
		Для Каждого ТекстовыйУзел Из ТекстовыеУзлы Цикл 
			endCharCount = СчетчикСимволов + СтрДлина(ТекстовыйУзел.textContent);
			Если Истина
				И Не НачалоНайдено 
				И ВыделениеВТексте.Начало >= СчетчикСимволов
				И (Ложь
					Или ВыделениеВТексте.Начало < endCharCount 
					Или (ВыделениеВТексте.Начало = endCharCount И СчетчикУзлов <= ТекстовыеУзлы.Количество()))
			Тогда 
				Диапазон.setStart(ТекстовыйУзел, ВыделениеВТексте.Начало - СчетчикСимволов);
				НачалоНайдено = Истина;
			КонецЕсли; 
			Если НачалоНайдено И ВыделениеВТексте.Конец <= endCharCount Тогда 
				Диапазон.setEnd(ТекстовыйУзел, ВыделениеВТексте.Конец - СчетчикСимволов);
				Прервать;
			КонецЕсли; 
			СчетчикСимволов = endCharCount;
			СчетчикУзлов = СчетчикУзлов + 1;
		КонецЦикла; 
		ТекущееВыделение = ДокументHtml.getSelection();
		ТекущееВыделение.removeAllRanges();
		ТекущееВыделение.addRange(Диапазон);
	Иначе
		Диапазон = РодительскийУзел.createTextRange();
		Диапазон.Collapse();
		Диапазон.moveStart("character", ВыделениеВТексте.НачалоБезПереносов);
		Диапазон.moveEnd("character", ВыделениеВТексте.КонецБезПереносов - ВыделениеВТексте.НачалоБезПереносов);
		Диапазон.select();
	КонецЕсли;

КонецПроцедуры

Функция ТекстовыеУзлыHTMLВнутри(Узел, ТекстовыеУзлы = Неопределено)
	Если ТекстовыеУзлы = Неопределено Тогда
		ТекстовыеУзлы = Новый Массив;
	КонецЕсли; 
	Если Узел.nodeType = 3 Тогда 
		ТекстовыеУзлы.Добавить(Узел);
	Иначе
		Потомки = Узел.childNodes;
		Для Каждого Потомок Из Потомки Цикл
			ТекстовыеУзлыHTMLВнутри(Потомок, ТекстовыеУзлы);
		КонецЦикла;
	КонецЕсли; 
	Возврат ТекстовыеУзлы;
КонецФункции

#КонецЕсли

//ирПортативный лФайл = Новый Файл(ИспользуемоеИмяФайла);
//ирПортативный ПолноеИмяФайлаБазовогоМодуля = Лев(лФайл.Путь, СтрДлина(лФайл.Путь) - СтрДлина("Модули\")) + "ирПортативный.epf";
//ирПортативный #Если Клиент Тогда
//ирПортативный 	Контейнер = Новый Структура();
//ирПортативный 	Оповестить("ирПолучитьБазовуюФорму", Контейнер);
//ирПортативный 	Если Не Контейнер.Свойство("ирПортативный", ирПортативный) Тогда
//ирПортативный 		ирПортативный = ВнешниеОбработки.ПолучитьФорму(ПолноеИмяФайлаБазовогоМодуля);
//ирПортативный 		ирПортативный.Открыть();
//ирПортативный 	КонецЕсли; 
//ирПортативный #Иначе
//ирПортативный 	ирПортативный = ВнешниеОбработки.Создать(ПолноеИмяФайлаБазовогоМодуля, Ложь); // Это будет второй экземпляр объекта
//ирПортативный #КонецЕсли
//ирПортативный ирОбщий = ирПортативный.ОбщийМодульЛкс("ирОбщий");
//ирПортативный ирКэш = ирПортативный.ОбщийМодульЛкс("ирКэш");
//ирПортативный ирСервер = ирПортативный.ОбщийМодульЛкс("ирСервер");
//ирПортативный ирКлиент = ирПортативный.ОбщийМодульЛкс("ирКлиент");

мПлатформа = ирКэш.Получить();
