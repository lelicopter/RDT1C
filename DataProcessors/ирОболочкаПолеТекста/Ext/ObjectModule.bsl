﻿//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирПривилегированный Экспорт;

Перем РедакторHTML; // Кэш
Перем НачальнаяСтрока, НачальнаяКолонка, КонечнаяСтрока, КонечнаяКолонка; // Временные переменные для всех методов
Перем ВременноеПолеВвода;
Перем ЛиВнутриУстановкиТекста;

Функция РедакторHTML() Экспорт
	Если Истина
		И РедакторHTML = Неопределено 
		И ТипЗнч(ЭлементФормы) = Тип("ПолеHTMLДокумента")
	Тогда
		РедакторHTML = ЭлементФормы.Документ.defaultView;
		Если РедакторHTML <> Неопределено И Не ЗначениеЗаполнено(РедакторHTML.version1C) Тогда 
			РедакторHTML = Неопределено;
		КонецЕсли; 
	КонецЕсли;
	Возврат РедакторHTML;
КонецФункции

Процедура УстановитьГраницыВыделения(НачальнаяСтрокаИлиПозиция, НачальнаяКолонкаИлиКонечнаяПозиция, КонечнаяСтрока = Неопределено, КонечнаяКолонка = Неопределено, Активировать = Ложь,
	ЭтаФорма = Неопределено) Экспорт 

	Если ТипЗнч(ЭлементФормы) = Тип("ПолеHTMLДокумента") Тогда
		РедакторHTML = РедакторHTML();
		Если РедакторHTML = Неопределено Тогда
			Возврат;
		КонецЕсли; 
		Если КонечнаяСтрока = Неопределено Тогда
			РедакторHTML.setSelectionByLength(НачальнаяСтрокаИлиПозиция, НачальнаяКолонкаИлиКонечнаяПозиция);
		Иначе
			РедакторHTML.setSelection(НачальнаяСтрокаИлиПозиция, НачальнаяКолонкаИлиКонечнаяПозиция, КонечнаяСтрока, КонечнаяКолонка);
		КонецЕсли; 
		Если Активировать Тогда
			РедакторHTML.editor.focus();
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
		Тогда 
			// https://www.hostedredmine.com/issues/929519 
			ВосстановитьФокусВвода();
		КонецЕсли; 
	КонецЕсли; 

КонецПроцедуры

Процедура ПолучитьГраницыВыделения(НачальнаяСтрока, НачальнаяКолонка, КонечнаяСтрока, КонечнаяКолонка) Экспорт 

	Если ТипЗнч(ЭлементФормы) = Тип("ПолеHTMLДокумента") Тогда
		РедакторHTML = РедакторHTML();
		Если РедакторHTML = Неопределено Тогда
			Возврат;
		КонецЕсли; 
		ВыделениеТекста = РедакторHTML.getSelection();
		НачальнаяСтрока = ВыделениеТекста.startLineNumber;
		НачальнаяКолонка = ВыделениеТекста.startColumn;
		КонечнаяСтрока = ВыделениеТекста.endLineNumber;
		КонечнаяКолонка = ВыделениеТекста.endColumn;
	Иначе
		ЭлементФормы.ПолучитьГраницыВыделения(НачальнаяСтрока, НачальнаяКолонка, КонечнаяСтрока, КонечнаяКолонка);
	КонецЕсли; 

КонецПроцедуры

Функция ПолучитьТекст() Экспорт

	Если ТипЗнч(ЭлементФормы) = Тип("ПолеHTMLДокумента") Тогда
		РедакторHTML = РедакторHTML();
		Если РедакторHTML = Неопределено Тогда
			Возврат Неопределено;
		КонецЕсли; 
		Текст = РедакторHTML.getText();
	ИначеЕсли ТипЗнч(ЭлементФормы) = Тип("ПолеВвода") Тогда
		Текст = ЭлементФормы.Значение;
	Иначе
		Текст = ЭлементФормы.ПолучитьТекст();
	КонецЕсли; 
	Возврат Текст;

КонецФункции

Функция УстановитьТекст(Текст, Активировать = Ложь, ИсходныйТекст = Неопределено) Экспорт 

	Если ТипЗнч(ЭлементФормы) = Тип("ПолеHTMLДокумента") Тогда
		РедакторHTML = РедакторHTML();
		Если РедакторHTML = Неопределено Тогда
			Возврат Ложь;
		КонецЕсли; 
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
	ИначеЕсли ТипЗнч(ЭлементФормы) = Тип("ПолеВвода") Тогда
		ЭлементФормы.Значение = Текст;
	Иначе
		ЭлементФормы.УстановитьТекст(Текст);
	КонецЕсли; 
	Возврат Истина;

КонецФункции

Функция ПолучитьСтроку(НомерСтроки) Экспорт 

	Если ТипЗнч(ЭлементФормы) = Тип("ПолеHTMLДокумента") Тогда
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

	Если ТипЗнч(ЭлементФормы) = Тип("ПолеHTMLДокумента") Тогда
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

	Если ТипЗнч(ЭлементФормы) = Тип("ПолеHTMLДокумента") Тогда
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

Процедура ВосстановитьФокусВвода() Экспорт 
	
	// Так отображается индикатор изменения NumLock
	//ирОбщий.ОтправитьНажатияКлавишЛкс("%");
	//ирОбщий.ОтправитьНажатияКлавишЛкс("%");
	
	#Если Сервер И Не Сервер Тогда
		ВосстановитьФокусВводаЛкс();
	#КонецЕсли
	ирОбщий.ПодключитьГлобальныйОбработчикОжиданияЛкс("ВосстановитьФокусВводаЛкс", 0.1, Истина);

КонецПроцедуры

Функция ТолькоПросмотр(НовыйРежим = Неопределено) Экспорт 

	Если ТипЗнч(ЭлементФормы) = Тип("ПолеHTMLДокумента") Тогда
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

	Если ТипЗнч(ЭлементФормы) = Тип("ПолеHTMLДокумента") Тогда
		РедакторHTML = РедакторHTML();
		Если РедакторHTML = Неопределено Тогда
			Возврат;
		КонецЕсли; 
		РедакторHTML.setLineContent(НомерСтроки, Текст);  // https://github.com/salexdv/bsl_console/issues/90
		//УстановитьГраницыВыделения(НомерСтроки, 1 , НомерСтроки, СтрДлина(ПолучитьСтроку(НомерСтроки)) + 1);
		//ВыделенныйТекст(Текст);
	Иначе
		ЭлементФормы.ЗаменитьСтроку(НомерСтроки, Текст);
	КонецЕсли; 

КонецПроцедуры

Процедура ВставитьСтроку(НомерСтроки, Текст) Экспорт 

	Если ТипЗнч(ЭлементФормы) = Тип("ПолеHTMLДокумента") Тогда
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

	Если ТипЗнч(ЭлементФормы) = Тип("ПолеHTMLДокумента") Тогда
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

Процедура Очистить() Экспорт 

	Если ТипЗнч(ЭлементФормы) = Тип("ПолеHTMLДокумента") Тогда
		РедакторHTML = РедакторHTML();
		Если РедакторHTML = Неопределено Тогда
			Возврат;
		КонецЕсли; 
		РедакторHTML.eraseText();
	Иначе
		ЭлементФормы.Очистить();
	КонецЕсли; 

КонецПроцедуры

Процедура ПоказатьОшибку(НомерСтроки, НомерКолонки = 1) Экспорт 
	Если ТипЗнч(ЭлементФормы) = Тип("ПолеHTMLДокумента") Тогда
		РедакторHTML = РедакторHTML();
		Если РедакторHTML = Неопределено Тогда
			Возврат;
		КонецЕсли; 
		РедакторHTML.markError(НомерСтроки, НомерКолонки);
	Иначе
		ЭлементФормы.УстановитьГраницыВыделения(НомерСтроки, 1, НомерСтроки, 150);
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

		// Стало необходимо в 8.3.19, иначе фокус не переходил в это поле сразу и координаты каретки получились пустые
		//Форма.Обновить(); 
		Форма.Открыть(); 
		
		ВКОбщая.ПолучитьПозициюКаретки(Координаты.left, Координаты.top + 8);
		Форма.ТекущийЭлемент = ЭлементФормы;
		Форма.ЭлементыФормы.Удалить(ВременноеПолеВвода);
	Иначе
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
	РедакторHTML.showStatusBar(Ложь);
	РедакторHTML.renderWhitespace(Истина);
	РедакторHTML.setFontSize(13);
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

Процедура ПоказатьПоследнююСтроку() Экспорт 
	НомерСтроки = Макс(1, КоличествоСтрок()); // https://www.hostedredmine.com/issues/891268
	Если НомерСтроки > 1 Тогда
		УстановитьГраницыВыделения(НомерСтроки, 1, НомерСтроки, 1);
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
//ирПортативный ирОбщий = ирПортативный.ПолучитьОбщийМодульЛкс("ирОбщий");
//ирПортативный ирКэш = ирПортативный.ПолучитьОбщийМодульЛкс("ирКэш");
//ирПортативный ирСервер = ирПортативный.ПолучитьОбщийМодульЛкс("ирСервер");
//ирПортативный ирПривилегированный = ирПортативный.ПолучитьОбщийМодульЛкс("ирПривилегированный");

