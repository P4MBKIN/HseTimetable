# HseTimetable

<div>
 <img src="https://raw.githubusercontent.com/P4MBKIN/HseTimetable/master/Screenshots/photo/photo_auth_1.jpg" height="400" alt=""  /> 
 <img src="https://raw.githubusercontent.com/P4MBKIN/HseTimetable/master/Screenshots/photo/photo_lessons.jpg" height="400" alt=""  />
</div>

<br></br>

Данное приложение является планировщиком учебных занятий для учащихся и преподавателей университета "Высшая школа экономики".
- Приложение позволяет получать актуальную информацию о предстоящих занятиях для студентов и преподавателей НИУ ВШЭ. Для выполнения поставленной задачи приложение отправляет запросы на сервер РУЗ, с указанием конкретного пользователя (после прохождения авторизации), чтобы получить только необходимую информацию.
- Приложение позволяет добавлять события о занятиях в календарь мобильного устройства и настраивать их: установливать время начала и завершения занятия, а также добавлять напоминания за определенное время до события.
- Приложение позволяет добавлять события о занятиях в напоминания мобильного устройства и настроивать их: устанавливать приоритет задачи, добавлять заметки и устанавливать напоминание на определенное время.
- Приложение позволяет использовать голосовые команды, установленные пользователем, для демонстрации актуального расписания на экране мобильного устройства

<br></br>

| sync with server 	| add event to calendar 	| add event to reminder 	| voice commands 	|
|:----------------:	|:---------------------:	|:---------------------:	|:--------------:	|
|     &#10003;     	|        &#10003;       	|        &#10003;       	|    &#10003;    	|

<br></br>

# Usage

Чтобы использовать основные функции приложения вы должны пройти авторизацию на стартовом экране.
Для этого Вам потребуется ввести название своей университетской почты НИУ ВШЭ
!Если Вы не являетесь учащимся или сотрудником данного ВУЗ'а Вы можете использовать название моей почты (poantonov@edu.hse.ru) (данная почта является корректной на 21.05.2020)

<br></br>

<img src="https://raw.githubusercontent.com/P4MBKIN/HseTimetable/master/Screenshots/gif/gif_auth.gif" height="403" alt=""  />

<br></br>

После чего Вы получите возможность обновить данные о расписании на ближайщие дни (если данные после обновления отсутствуют, значит на текущий период у выбранного пользователя нет занятий в ближайщее время)
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

- Architecture - VIPER+Rx (была выбрана именно связка VIPER с Rx потому что это уменьшает связность компонент в модуле и делает более удобным взаимодействие с сетью и с внутренней БД, нежели чем в обычном VIPER)
<br></br>
<div>
 <img src="https://raw.githubusercontent.com/P4MBKIN/HseTimetable/master/Screenshots/materials/viper_rx.jpg" width="500" alt=""  /> 
 <img src="https://raw.githubusercontent.com/P4MBKIN/HseTimetable/master/Screenshots/materials/viper.jpg" width="500" alt=""  />
</div>

# Requirements

- iOS 12

# Credits

- [Realm][] for caching data

[Realm]:https://realm.io
