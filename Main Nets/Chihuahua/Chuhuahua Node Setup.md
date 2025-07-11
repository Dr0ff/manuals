# Установка ноды Chihuahua
### Убедитесь, что ваш сервер правильно подготовлен: [Инструкция и скрипт проверки](https://github.com/ptzruslan/tools)
  ## 1. Устанавливаем Go v1.23.4

**Если Go ещё не установлен, выполните команды по установке и настройке GO:*

```bash
sudo rm -rvf /usr/local/go/
wget https://golang.org/dl/go1.23.4.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.23.4.linux-amd64.tar.gz
rm go1.23.4.linux-amd64.tar.gz
```

## 2. Настраиваем Go

Откройте файл командой:
```bash
nano ~/.profile
```

И вставьте в него следующий текст:

```bash
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export GO111MODULE=on
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
```

## 3. Устанавливаем Cosmosvisor

```bash
go install github.com/cosmos/cosmos-sdk/cosmovisor/cmd/cosmovisor@v1.0.0
```
## 4. Устанавливаем Chihuahua

```
git clone https://github.com/ChihuahuaChain/chihuahua chihuahua
cd chihuahua
git checkout v9.0.5
make install
```

### Проверка установки
После завершения установки убедитесь, что Lava установлен корректно, выполнив команду:
```bash
chihuahuad version
```
**Если команда выводит корректную версию, установка прошла успешно!*

## 4. Инициализация ноды

Выполните следующую команду, заменив `YOUR_MONIKER` на имя вашей ноды:

```bash
chihuahuad init "YOUR MONIKER" --chain-id chihuahua-1
```

## 5. Выполним настройки ноды

3. Настройка Pruning и соединения:

```bash
sed -i -e "s/^pruning *=.*/pruning = \"custom\"/" $HOME/.chihuahuad/config/app.toml 
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" $HOME/.chihuahuad/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"19\"/" $HOME/.chihuahuad/config/app.toml
```

4. Отключение `indexer`

```bash
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.chihuahuad/config/config.toml
sed -i -e 's/^max_num_outbound_peers *=.*/max_num_outbound_peers = 40/' $HOME/.chihuahuad/config/config.toml
```

## 6. Скачаем genesis.json и addrbook.json
Выполните следующие команды:

```bash
wget -O $HOME/.chihuahuad/config/genesis.json https://snapshots.polkachu.com/genesis/chihuahua/genesis.json --inet4-only
wget -O $HOME/.chihuahuad/config/addrbook.json https://snapshots.polkachu.com/addrbook/chihuahua/addrbook.json --inet4-only
```

## 7. Настройка Сервиса

### Автозагрузка и работа ноды как сервис

  1. Создайте файл следующей командой:
```bash
sudo nano /etc/systemd/system/chihuahuad.service
```
  2. Вставьте в него содержимое приведённое ниже:</br>
  *Замените USER на имя своего пользователя!

```bash
[Unit]
Description="chihuahua node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=infinity
LimitNPROC=infinity
Environment="DAEMON_NAME=chihuahuad"
Environment="DAEMON_HOME=/home/USER/.chihuahuad"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_LOG_BUFFER_SIZE=512"
Environment="UNSAFE_SKIP_BACKUP=true"

#MemoryAccounting=true
#MemoryMax=5G
#MemoryHigh=800M
#MemorySwapMax=0

[Install]
WantedBy=multi-user.target
```
  3. Выполните команду активации автозапуска:

```bash
sudo systemctl enable chihuahuad.service
```

## 8. Настройка Cosmovisor
  1. Создаём директории:
```bash
mkdir -p ~/.chihuahuad/cosmovisor/genesis/bin
mkdir -p ~/.chihuahuad/cosmovisor/upgrades
```

  2. Копируем бинарник ноды в Cosmovisor
```bash
cp go/bin/chihuahuad .chihuahuad/cosmovisor/genesis/bin/
```

## 9. Синхронизируем ноду при помощи StateSync!
</br>
    
<details>
  <summary>Использовать StateSync. Быстро, легко! Нажмите, чтобы показать</summary>
  Выполните команду, после её выполнения, вы получите полностью работающую ноду! Только дайте ей время синхронизироваться.

  ```
  curl https://raw.githubusercontent.com/Dr0ff/manuals/refs/heads/main/Main%20Nets/Chihuahua/chihuahua_state_sync.sh | bash
```
 
 </details>


## Дополнительно! Если не делали предыдущий шаг!
 <details>
     <summary>Использовать Snapshot. Сложнее. Нажмите, чтобы показать</summary>
  1. Останавливаем ноду и сохраняем файл ноды

```bash
sudo systemctl stop chihuahuad.service
cp $HOME/.chihuahuad/data/priv_validator_state.json $HOME/.chihuahuad/priv_validator_state.json.backup
```

  2. Выполняем команду очистки и сброса ноды

```bash
chihuahuad tendermint unsafe-reset-all --home $HOME/.chihuahuad --keep-addr-book
```

  3. Переходим по ссылке:</br>
  !!! КОПИРУЕМ И ВЫПОЛНЯЕМ ТОЛЬКО команду которая начинается с `curl https://....` !!!

```bash
https://itrocket.net/services/mainnet/chihuahuad/#snap
```
  
  3. Возвращаем сохранённый файл на место:
```bash
mv $HOME/.chihuahuad/priv_validator_state.json.backup $HOME/.chihuahuad/data/priv_validator_state.json
```
 
## Запуск и проверка ноды

  1. Делаем пробный запуск ноды:
```bash
chihuahuad start
```
  ***Дождитесь пока начнётся синхронизация или даже пока нода полностью не синхронизируется!*

  2. Запустите ноду и просмотр логов:
```bash
sudo systemctl start chihuahuad.service
sudo journalctl -u chihuahuad -f --output cat
```
</details>
</br>
<details>
<summary>Сиды и Пиры! Эту секцию можно смело пропустить! Если есть Addrbook, они не нужны</summary>

## Запуск Валидатора:
Создаём файл, `nano validator.json` вставляем содержимое:

```
{
	"pubkey": {"@type":"/cosmos.crypto.ed25519.PubKey","key":"oWg2LF405Jcm2vXV+2v4fnjodh6aafuIdeoW+rUw="},
	"amount": "1000000unolus",
	"moniker": "myvalidator",
	"identity": "(ex. UPort or Keybase)",
	"website": "validator's (optional) website",
	"security": "validator's (optional) security contact email",
	"details": "validator's (optional) details",
	"commission-rate": "0.1",
	"commission-max-rate": "0.2",
	"commission-max-change-rate": "0.01",
	"min-self-delegation": "1"
}
```
Редактируем параметры как вам необходимо.

Ваш "pubkey" можно взять выполнив команду: `nolusd tendermint show-validator`

Далее можно отправлять транзакцию на создание валидатора:
```
chihuahuad tx staking create-validator validator.json --from wallet --chain-id pirin-1 --gas=auto --fees 700unls --gas-adjustment="1.5
```
