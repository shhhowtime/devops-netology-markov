### Задание 1: Запуск пода из образа в деплойменте

Скриншот запуска deployment:
![Задание 1](https://github.com/shhhowtime/devops-netology-markov/blob/main/12-kubernetes-02-commands/1.png)
Ссылка на конфиг [deployment](https://github.com/shhhowtime/devops-netology-markov/blob/main/12-kubernetes-02-commands/deployment.yaml "deployment.yaml").

### Задание 2. Просмотр логов для разработки

Скриншот добавления ноды к кластеру:
![Задание 2](https://github.com/shhhowtime/devops-netology-markov/blob/main/12-kubernetes-02-commands/2.png)

Скриншот просмтора логов с ноды test2:
![Тоже задание 2](https://github.com/shhhowtime/devops-netology-markov/blob/main/12-kubernetes-02-commands/2.1.png)

Ссылки на конфиг [role](https://github.com/shhhowtime/devops-netology-markov/blob/main/12-kubernetes-02-commands/role.yaml "role.yaml") и конфиг [role binding](https://github.com/shhhowtime/devops-netology-markov/blob/main/12-kubernetes-02-commands/rolebinding.yaml "rolebinding.yaml").

### Задание 3. Изменение числа реплик.

Для изменения числа реплик в deployment соответствующий пункт был изменён с 2 на 5. Скриншот с результатом выполнения:
![Задание 3](https://github.com/shhhowtime/devops-netology-markov/blob/main/12-kubernetes-02-commands/3.png)

### Обновление для преподавателя.

Пункты 1 и 2. Создание пользователя. Для создания использовались следующие команды:

`kubectl create sa log-reader`

`kubectl config set-credentials log-reader-user --token="токен пользователя из команды kubectl describe secrets"`

`kubectl config set-context log-reader-context --cluster=kubernetes --user=log-reader`

В качестве дополнительного пользователя буду использовать учётную запись в ОС, под которой идёт работа. В результате получаем в файле .kube/config дополнительного пользователя:
![Дополнение 1](https://github.com/shhhowtime/devops-netology-markov/blob/main/12-kubernetes-02-commands/add1.png)

Пункты 3, 4, 5 и 6. Немного исправил конфиг [role](https://github.com/shhhowtime/devops-netology-markov/blob/main/12-kubernetes-02-commands/role_new.yaml "role.yaml") и [role binding](https://github.com/shhhowtime/devops-netology-markov/blob/main/12-kubernetes-02-commands/rolebinding_new.yaml "rolebinding.yaml"), чтобы они работали на юзера, а не на ноду. Применение конфигов с помощью `kubectl apply -f "config.yaml"`. Скриншот ниже. Также на скриншоте демонтрация попытки изменения количества подов от имени пользователя и их фактическое изменение от администратора.
![Дополнение 2](https://github.com/shhhowtime/devops-netology-markov/blob/main/12-kubernetes-02-commands/add2.png)
