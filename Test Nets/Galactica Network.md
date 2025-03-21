# Установка ноды Galactica Network
### Убедитесь, что ваш сервер правильно подготовлен: [Инструкция и скрипт проверки](https://github.com/ptzruslan/tools/tree/main/validator/tech02)
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

#### Сохранение и применение изменений
1. Сохраните файл и выйдите из редактора:
   - **CTRL+S** (сохранение)
   - **CTRL+X** (выход)
2. Примените изменения:
```bash
source ~/.profile
```

## 3. Устанавливаем Cosmosvisor ( Если он у вас ещё не установлен )

```bash
go install github.com/cosmos/cosmos-sdk/cosmovisor/cmd/cosmovisor@v1.0.0
```
## 4. Устанавливаем Galactica

Выполните команды:
```bash
git clone https://github.com/Galactica-corp/galactica.git
cd galactica
BINDIR=$HOME/go/bin make install
```

### Проверка установки
После завершения установки убедитесь, что Galactica установлен корректно, выполнив команду:
```bash
galacticad version --long
```
**Если команда выводит корректную версию Galactica, установка прошла успешно!*

## 4. Инициализация ноды

Выполните следующую команду, заменив `YOUR_MONIKER` на имя вашей ноды:
*Нельзя использовать пробел!

```bash
galacticad init "YOUR_MONIKER" --chain-id galactica_9302-1
```

### Создаём кошелёк:
Выполните следующую команду, заменив 'YOUR_WALLET_NAME' на желаемое имя вашего кошелька (например, galwallet)

```bash
galacticad keys add YOUR_WALLET_NAME --algo eth_secp256k1 --home $HOME/.galactica --keyring
-backend file --keyring-dir $HOME/.galactica
```
Придумайте и введите пароль, для хранителя ключей, повторите ввод пароля

!!! Обязательно сохраните сид фразу !!!

## 5. Выполним настройки ноды

1. Тонкие настройки работы ноды:

config.toml
```bash
sed -i.backup 's?laddr = "tcp://127.0.0.1:26657"?laddr = "tcp://0.0.0.0:26657"?g' $HOME/.galactica/config/config.toml
sed -i 's?proxy_app = "tcp://127.0.0.1:26658"?proxy_app = "tcp://0.0.0.0:26658"?g' $HOME/.galactica/config/config.toml
sed -i 's?cors_allowed_origins = \[\]?cors_allowed_origins = \["*"\]?g' $HOME/.galactica/config/config.toml
```
app.toml

```bash
sed -i.backup '/\[api\]/,+3 s?enable = false?enable = true?' $HOME/.galactica/config/app.toml
sed -i 's?address = "tcp://localhost:1317"?address = "tcp://0.0.0.0:1317"?' $HOME/.galactica/config/app.toml
sed -i 's?enabled-unsafe-cors = false?enabled-unsafe-cors = true?' $HOME/.galactica/config/app.toml
sed -i 's?address = "localhost:9090"?address = "0.0.0.0:9090"?' $HOME/.galactica/config/app.toml
sed -i '/\[grpc-web\]/,+7 s?address = "localhost:9091"?address = "0.0.0.0:9091"?' $HOME/.galactica/config/app.toml
sed -i 's?pruning = "default"?pruning = "nothing"?g' $HOME/.galactica/config/app.toml
sed -i 's?minimum-gas-prices = ".*"?minimum-gas-prices = "10ugnet"?g' $HOME/.galactica/config/app.toml
```

#4. Настройка `minimum gas price` и отключение `indexer`

```bash
#sed -i 's|minimum-gas-prices =.*|minimum-gas-prices = "0.000000001ulava"|g' $HOME/.lava/config/app.toml
#sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.lava/config/config.toml
#sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.lava/config/config.toml
```

## 6. Скачаем genesis.json и addrbook.json
Выполните следующие команды:

```bash
wget -O $HOME/.galactica/config/genesis.json https://raw.githubusercontent.com/Galactica-corp/networks/main/galactica_9302-1/genesis.json
wget -O $HOME/.galactica/config/addrbook.json  https://server-2.itrocket.net/mainnet/lava/addrbook.json
```

## Сиды и пиры

```bash
SEEDS="c722e6dc5f762b0ef19be7f8cc8fd67cdf988946@seed01-reticulum.galactica.com:26656,8949fb771f2859248bf8b315b6f2934107f1cf5a@seed02-reticulum.galactica.com:26656,3afb7974589e431293a370d10f4dcdb73fa96e9b@seed03-reticulum.galactica.com:26656"
PEERS=""
sed -i -e "/^\[p2p\]/,/^\[/{s/^[[:space:]]*seeds *=.*/seeds = \"$SEEDS\"/}" \
       -e "/^\[p2p\]/,/^\[/{s/^[[:space:]]*persistent_peers *=.*/persistent_peers = \"$PEERS\"/}" $HOME/.galactica/config/config.toml
```

## 7. Настройка Сервиса

### Автозагрузка и работа ноды как сервис

  1. Создайте файл следующей командой:
```bash
sudo nano /etc/systemd/system/lava.service
```
  2. Вставьте в него содержимое приведённое ниже:</br>
  *Замените USER на имя своего пользователя!

```bash
[Unit]
Description="lava node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=infinity
LimitNPROC=infinity
Environment="DAEMON_NAME=lavad"
Environment="DAEMON_HOME=/home/USER/.lava"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=true"
Environment="DAEMON_LOG_BUFFER_SIZE=512"
Environment="UNSAFE_SKIP_BACKUP=true"
[Install]
WantedBy=multi-user.target
```
  3. Выполните команду активации автозапуска:

```bash
sudo systemctl enable lava.service
```

## 8. Настройка Cosmovisor
  1. Создаём директории:
```bash
mkdir -p ~/.lava/cosmovisor/genesis/bin
mkdir -p ~/.lava/cosmovisor/upgrades
```

  2. Копируем бинарник ноды в Cosmovisor
```bash
cp go/bin/lavad .lava/cosmovisor/genesis/bin/
```

## 9. Синхронизируем ноду при помощи StateSync!
</br>
    
<details>
  <summary>Использовать StateSync. Быстро, легко! Нажмите, чтобы показать</summary>
  Выполните команду, после её выполнения, вы получите полностью работающую ноду! Только дайте ей время синхронизироваться.

  ```
  curl https://raw.githubusercontent.com/Dr0ff/Useful-scripts/refs/heads/main/lava_st_sync.sh | bash
```
 
 </details>


## Дополнительно! Если не делали предыдущий шаг!
 <details>
     <summary>Использовать Snapshot. Сложнее. Нажмите, чтобы показать</summary>
  1. Останавливаем ноду и сохраняем файл ноды

```bash
sudo systemctl stop lava.service
cp $HOME/.lava/data/priv_validator_state.json $HOME/.lava/priv_validator_state.json.backup
```

  2. Выполняем команду очистки и сброса ноды

```bash
lavad tendermint unsafe-reset-all --home $HOME/.lava --keep-addr-book
```

  3. Переходим по ссылке:</br>
  !!! КОПИРУЕМ И ВЫПОЛНЯЕМ ТОЛЬКО команду которая начинается с `curl https://....` !!!

```bash
https://itrocket.net/services/mainnet/lava/#snap
```
  
  3. Возвращаем сохранённый файл на место:
```bash
mv $HOME/.lava/priv_validator_state.json.backup $HOME/.lava/data/priv_validator_state.json
```
 
## Запуск и проверка ноды

  1. Делаем пробный запуск ноды:
```bash
lavad start
```
  ***Дождитесь пока начнётся синхронизация или даже пока нода полностью не синхронизируется!*

  2. Запустите ноду и просмотр логов:
```bash
sudo systemctl start lava.service
sudo journalctl -u lava -f --output cat
```
</details>
</br>
<details>
<summary>Сиды и Пиры! Эту секцию можно смело пропустить! Если есть Addrbook, они не нужны</summary>

```bash
SEEDS="c722e6dc5f762b0ef19be7f8cc8fd67cdf988946@seed01-reticulum.galactica.com:26656,8949fb771f2859248bf8b315b6f2934107f1cf5a@seed02-reticulum.galactica.com:26656,3afb7974589e431293a370d10f4dcdb73fa96e9b@seed03-reticulum.galactica.com:26656"
PEERS=""
sed -i -e "/^\[p2p\]/,/^\[/{s/^[[:space:]]*seeds *=.*/seeds = \"$SEEDS\"/}" \
       -e "/^\[p2p\]/,/^\[/{s/^[[:space:]]*persistent_peers *=.*/persistent_peers = \"$PEERS\"/}" $HOME/.galactica/config/config.toml
```
</details>


## Huge Thanks to ITROCKET for amazing tool and contributions!
Check it out: [https://itrocket.net/](https://itrocket.net/)
