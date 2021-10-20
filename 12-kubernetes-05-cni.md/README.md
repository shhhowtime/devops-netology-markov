### Задание 1. Установка в кластер CNI плагина Calico

В данном задании будет использоваться кластер, созданный в [предыдущем ДЗ](https://github.com/shhhowtime/devops-netology-markov/blob/main/12-kubernetes-04-install-part-2/README.md "Решение предыдущего ДЗ"). В результате выполнения предыдущего ДЗ был создан кластер с уже становленным плагином Calico.

Настройка политики доступа к hello world выполнялась по принципу "запретить доступ всем, кроме пода access в том же namespace". Скриншот с командами, выполненными для настройки данных ограничений:
![Задание 1](https://github.com/shhhowtime/devops-netology-markov/blob/main/12-kubernetes-05-cni/1.png)
Используемые файлы в данном задании:
- [deployment.yaml](https://github.com/shhhowtime/devops-netology-markov/blob/main/12-kubernetes-05-cni/deployment.yaml "deployment.yaml"). Деплоймент схож с предыдущими ДЗ, в него добавлен namespace и expose port.
- [deny-all-be-default-network-policy.yaml](https://github.com/shhhowtime/devops-netology-markov/blob/main/12-kubernetes-05-cni/deny-all-be-default-network-policy.yaml "deny-all-be-default-network-policy.yaml"). Политика запрета доступа к namespace даже внутри самого namespace. На скришноте имеет имя `network-policy.yaml`.
- [access-to-hello-node-network-policy.yaml](https://github.com/shhhowtime/devops-netology-markov/blob/main/12-kubernetes-05-cni/access-to-hello-node-network-policy.yaml "access-to-hello-node-network-policy.yaml"). Политика разрешения доступа из пода access к подам hello-node внутри самого namespace. На скришноте имеет имя `network-policy2.yaml`.

### Задание 2. Изучение того, что запущено по умолчанию.

Скриншот получения списка нод в Calico, его IP pool и список профилей:
![Задание 1](https://github.com/shhhowtime/devops-netology-markov/blob/main/12-kubernetes-05-cni/2.png)