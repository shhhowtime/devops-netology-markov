## Основная часть
1. Файл инвентаря изменён и находится в репозитории.
2. Файл модифицированного playbook в репозитории. Изменения в playbook незначительны, так как установка kibana мало чем отличается от elasticsearch. Переменная elastic_home была перемещена в group_vars/all, так как она используется и для установки такой же версии kibana.
3. Модули были использованы.
4. Tasks выполняют данные функции.
5. После выполнения ansible-lint ошибок нет, только 7 предупреждений по поводу неопределённых прав
6. Выполнение playbook с ключом --check падает, так как директория в предыдущей таске по факту не создаётся
7. Добавить скриншот результата
8. Добавить скриншот результата
9. README по Playbook начинается далее.

### Плейбук site.yml

Данный плейбук:

- Устанавливает java версии `8u281` (определяется в `group_vars/all/vars.yml`) на все хосты по пути `/opt/jdk/(версия java)/bin/java` (определяется в плейбуке, строка 8) и экспортирует переменные окружения для корректной работы с Java
- Устанавливает Elasticsearch версии `7.10.1` (определяется в `group_vars/all/vars.yml`) на хосты в группе `el`. Загружает Elasticsearch конкретной версии, распаковывает по пути `/opt/elastic/(версия elasticsearch)/bin/elasticsearch` (определяется в файле `group_vars/el/vars.yml`) и экспортирует переменные окружения для корректной работы с Elasticsearch
- Устанавливает Kibana версии `7.10.1` (определяется в `group_vars/all/vars.yml`) на хосты в группе `deb`. Загружает Kibana конкретной версии, распаковывает по пути `/opt/kibana/(версия elasticsearch)/bin/kibana` (определяется в файле `group_vars/deb/vars.yml`) и экспортирует переменные окружения для корректной работы с Kibana

Теги, присутствующие в данном плейбуке:

- `java`, используется для тасок, выполняющихся для установки java
- `elastic`, используется для тасок, выполняющихся для установки elasticsearch
- `kibana`, используется для тасок, выполняющихся для установки kibana
- `skip_ansible_lint`, используется для игнорирования блока при выполнении ansible-lint