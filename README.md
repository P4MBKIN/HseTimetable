# HseTimetable

<div>
 <img src="https://raw.githubusercontent.com/P4MBKIN/HseTimetable/master/Screenshots/photo/photo_auth_1.jpg" height="400" alt=""  /> 
 <img src="https://raw.githubusercontent.com/P4MBKIN/HseTimetable/master/Screenshots/photo/photo_lessons.jpg" height="400" alt=""  />
</div>
<br></br>
Данное приложение является планировщиком учебных занятий для учащихся и преподавателей университета "Высшая школа экономики".
<br></br>

- Приложение позволяет получать актуальную информацию о предстоящих занятиях для студентов и преподавателей НИУ ВШЭ. Для выполнения поставленной задачи приложение отправляет запросы на сервер РУЗ с указанием конкретного пользователя (после прохождения авторизации), чтобы получить только необходимую информацию

- Приложение позволяет добавлять события о занятиях в календарь мобильного устройства и настраивать их: установливать время начала и завершения занятия, а также добавлять напоминания за определенное время до события

- Приложение позволяет добавлять события о занятиях в напоминания мобильного устройства и настроивать их: устанавливать приоритет задачи, добавлять заметки и устанавливать напоминание на определенное время

- Приложение позволяет использовать голосовые команды, установленные пользователем, для демонстрации актуального расписания на экране мобильного устройства
<br></br>

| sync with server 	| add event to calendar 	| add event to reminder 	| voice commands 	|
|:----------------:	|:---------------------:	|:---------------------:	|:--------------:	|
|     &#10003;     	|        &#10003;       	|        &#10003;       	|    &#10003;    	|

# Usage

Чтобы использовать основные функции приложения вы должны пройти авторизацию на стартовом экране.
Для этого Вам потребуется ввести название своей университетской почты НИУ ВШЭ
<br></br>
!Если Вы не являетесь учащимся или сотрудником данного ВУЗ'а Вы можете использовать название моей почты (poantonov@edu.hse.ru) (данная почта является корректной на 21.05.2020)
<br></br>
<img src="https://raw.githubusercontent.com/P4MBKIN/HseTimetable/master/Screenshots/gif/gif_auth.gif" height="403" alt=""  />
<br></br>
После чего Вы получите возможность обновить данные о расписании на ближайщие дни (если данные после обновления отсутствуют, значит на текущий период у выбранного пользователя нет занятий в ближайщее время)
<br></br>
Для тестирования Вы можете раскомментировать следующий код, чтобы получить расписание актуальное для моего пользователя на 14.12.2019:
```
params["student"] = "165773"
params["start"] = "2019-12-14"
```
<br></br>
<div>
 <img src="https://raw.githubusercontent.com/P4MBKIN/HseTimetable/master/Screenshots/photo/photo_lessons_empty.jpg" height="400" alt=""  /> 
 <img src="https://raw.githubusercontent.com/P4MBKIN/HseTimetable/master/Screenshots/photo/photo_lessons.jpg" height="400" alt=""  />
 <img src="https://raw.githubusercontent.com/P4MBKIN/HseTimetable/master/Screenshots/photo/photo_lessons_open_1.jpg" height="400" alt=""  />
 <img src="https://raw.githubusercontent.com/P4MBKIN/HseTimetable/master/Screenshots/gif/gif_touches.gif" height="403" alt=""  />
</div>

# Technologies

- Architecture - VIPER+Rx+SOA (была выбрана именно связка VIPER с Rx, потому что это уменьшает связность компонент в модуле и делает более удобным взаимодействие с сетью и с внутренней БД, нежели чем в обычном VIPER)
<br></br>
<div>
 <img src="https://raw.githubusercontent.com/P4MBKIN/HseTimetable/master/Screenshots/materials/viper_rx.jpg" width="600" alt=""  /> 
 <img src="https://raw.githubusercontent.com/P4MBKIN/HseTimetable/master/Screenshots/materials/viper.jpg" width="600" alt=""  />
</div>

<br></br>
- [Realm][] используется для кэширования данный о расписании (чтобы приложение могло работать offline)
<br></br>
<img src="https://raw.githubusercontent.com/P4MBKIN/HseTimetable/master/Screenshots/gif/gif_caching.gif" height="403" alt=""  />

<br></br>
- [EventKit][] используется для добавления записей в календарь (с возможностью установки времени начала и завершения занятия, а также добавления напоминания за определенное время до занятия) и напоминания устройства (с возможностью установки приоритета задачи, добавления заметок и настройки уведомления за определенное время до события)
<br></br>
<div>
 <img src="https://raw.githubusercontent.com/P4MBKIN/HseTimetable/master/Screenshots/photo/photo_calendar.jpg" height="400" alt=""  />
 <img src="https://raw.githubusercontent.com/P4MBKIN/HseTimetable/master/Screenshots/gif/gif_calendar.gif" height="403" alt=""  />
 <img src="https://raw.githubusercontent.com/P4MBKIN/HseTimetable/master/Screenshots/photo/photo_reminder.jpg" height="400" alt=""  />
 <img src="https://raw.githubusercontent.com/P4MBKIN/HseTimetable/master/Screenshots/gif/gif_reminder.gif" height="403" alt=""  />
</div>

<br></br>
- [SiriKit][] используется для добавление голосовых команд в приложение (открытие приложения и актуализирование информации о предстоящих занятиях)
<br></br>
<div>
 <img src="https://raw.githubusercontent.com/P4MBKIN/HseTimetable/master/Screenshots/photo/photo_add_siri.jpg" height="400" alt=""  />
 <img src="https://raw.githubusercontent.com/P4MBKIN/HseTimetable/master/Screenshots/gif/gif_siri.gif" height="403" alt=""  />
</div>

<br></br>
- [SnapKit][] используется верстки UI-элементов в коде (ячейки таблицы расписания, пустой экран занятий, уведомления об отсутствии сети, уведомление о выходе из аккаунта и уведомления о том, что событие в календаре/напоминаниях уже существует)
<br></br>
<div>
 <img src="https://raw.githubusercontent.com/P4MBKIN/HseTimetable/master/Screenshots/photo/photo_lessons_open_1.jpg" height="400" alt=""  />
 <img src="https://raw.githubusercontent.com/P4MBKIN/HseTimetable/master/Screenshots/photo/photo_lessons_empty.jpg" height="400" alt=""  />
 <img src="https://raw.githubusercontent.com/P4MBKIN/HseTimetable/master/Screenshots/photo/photo_alert_net.jpg" height="400" alt=""  />
 <img src="https://raw.githubusercontent.com/P4MBKIN/HseTimetable/master/Screenshots/photo/photo_alert_logout.jpg" height="400" alt=""  />
 <img src="https://raw.githubusercontent.com/P4MBKIN/HseTimetable/master/Screenshots/gif/gif_alert_calendar.gif" height="403" alt=""  />
 <img src="https://raw.githubusercontent.com/P4MBKIN/HseTimetable/master/Screenshots/gif/gif_alert_reminder.gif" height="403" alt=""  />
 <img src="https://raw.githubusercontent.com/P4MBKIN/HseTimetable/master/Screenshots/gif/gif_alert_net.gif" height="403" alt=""  />
 <img src="https://raw.githubusercontent.com/P4MBKIN/HseTimetable/master/Screenshots/gif/gif_logout.gif" height="403" alt=""  />
</div>

# Requirements

- iOS 12

[Realm]:https://realm.io
[EventKit]:https://developer.apple.com/documentation/eventkit
[SiriKit]:https://developer.apple.com/documentation/sirikit
[SnapKit]:https://snapkit.io
