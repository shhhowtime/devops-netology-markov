### Задание 1. Подключение для тестового конфига общей папки.

Для задания использовался [следующий под](https://github.com/shhhowtime/devops-netology-markov/blob/main/13-kubernetes-config-02-mounts/21.yaml "21.yaml"). Результат на скриншоте:
![Задание 1](https://github.com/shhhowtime/devops-netology-markov/blob/main/13-kubernetes-config-02-mounts/1.png)

### Задание 2.

Модернизировал [конфиг прода](https://github.com/shhhowtime/devops-netology-markov/blob/main/13-kubernetes-config-02-mounts/prod.yaml "prod.yaml") из предыдущего задания с учётом использования NFS. Также потребовалось установить пакет nfs-common для ОС, так как по умолчанию и при установке helm данный пакет не был предоставлен. Скриншот выполнения команд ниже:
![Задание 2](https://github.com/shhhowtime/devops-netology-markov/blob/main/13-kubernetes-config-02-mounts/2.png)