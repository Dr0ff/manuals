# Установка ноды Lava Network | Спасибо ITROCKET

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

## 3. Устанавливаем Cosmosvisor

```bash
go install github.com/cosmos/cosmos-sdk/cosmovisor/cmd/cosmovisor@v1.0.0
```
## 4. Устанавливаем Lava

Выполните команды:
```bash
git clone https://github.com/lavanet/lava
cd lava/
git checkout v5.2.0
make install-all
```

### Проверка установки
После завершения установки убедитесь, что Lava установлен корректно, выполнив команду:
```bash
lavad version
```
**Если команда выводит корректную версию Lava, установка прошла успешно!*

## 5. Инициализация ноды

Выполните следующую команду, заменив `YOUR_MONIKER` на имя вашей ноды:

```bash
lavad init "YOUR_MONIKER" --chain-id lava-mainnet-1
```

## 6. Выполним настройки ноды

1. Тонкие настройки работы ноды:

```bash
sed -i \
-e 's/timeout_propose = .*/timeout_propose = "1s"/' \
-e 's/timeout_propose_delta = .*/timeout_propose_delta = "500ms"/' \
-e 's/timeout_prevote = .*/timeout_prevote = "1s"/' \
-e 's/timeout_prevote_delta = .*/timeout_prevote_delta = "500ms"/' \
-e 's/timeout_precommit = .*/timeout_precommit = "500ms"/' \
-e 's/timeout_precommit_delta = .*/timeout_precommit_delta = "1s"/' \
-e 's/timeout_commit = .*/timeout_commit = "15s"/' \
-e 's/^create_empty_blocks = .*/create_empty_blocks = true/' \
-e 's/^create_empty_blocks_interval = .*/create_empty_blocks_interval = "15s"/' \
-e 's/^timeout_broadcast_tx_commit = .*/timeout_broadcast_tx_commit = "151s"/' \
-e 's/skip_timeout_commit = .*/skip_timeout_commit = false/' \
  $HOME/.lava/config/config.toml
```

2. Добавим seed и peer:

```bash
SEEDS="19822a55dcd3b5a4e8a4d4911d0b78e001b93cf7@lava-mainnet-seed.itrocket.net:28656"
PEERS="0d67bedc7f929200d52c8724dfc50f848661f9ba@lava-mainnet-peer.itrocket.net:28656,8d28c38d956384510558664f5897a383b7529699@136.243.95.31:29156"
sed -i -e "/^\[p2p\]/,/^\[/{s/^[[:space:]]*seeds *=.*/seeds = \"$SEEDS\"/}" \
       -e "/^\[p2p\]/,/^\[/{s/^[[:space:]]*persistent_peers *=.*/persistent_peers = \"$PEERS\"/}" $HOME/.lava/config/config.toml
```

3. Настройка Pruning:

```bash
sed -i -e "s/^pruning *=.*/pruning = \"custom\"/" $HOME/.lava/config/app.toml 
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" $HOME/.lava/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"19\"/" $HOME/.lava/config/app.toml
```

4. Настройка `minimum gas price` и отключение `indexer`

```bash
sed -i 's|minimum-gas-prices =.*|minimum-gas-prices = "0.000000001ulava"|g' $HOME/.lava/config/app.toml
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.lava/config/config.toml
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.lava/config/config.toml
```

## 7. Скачаем genesis.json и addrbook.json
Выполните следующие команды:

```bash
wget -O $HOME/.lava/config/genesis.json https://server-2.itrocket.net/mainnet/lava/genesis.json
wget -O $HOME/.lava/config/addrbook.json  https://server-2.itrocket.net/mainnet/lava/addrbook.json
```

## 8. Настройка Сервиса

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

## 9. Настройка Cosmovisor
  1. Создаём директории:
```bash
mkdir -p ~/.lava/cosmovisor/genesis/bin
mkdir -p ~/.lava/cosmovisor/upgrades
```

  2. Копируем бинарник ноды в Cosmovisor
```bash
cp go/bin/lavad .lava/cosmovisor/genesis/bin/
```

## 10. Скачиваем и распаковываем Snapshot/StateSync

<details>
  <summary>Использовать StateSync. Быстро, легко. Нажмите, чтобы показать</summary>
  Выполните команду:

  `curl https://raw.githubusercontent.com/Dr0ff/Useful-scripts/refs/heads/main/lava_st_sync.sh | bash`
 
 </details>
 <details>
     <summary>Использовать Snapshot. Сложнее. Нажмите, чтобы показать</summary>
  1. Останавливаем ноду и сохраняем файл ноды

```bash
sudo systemctl stop lavad
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
 
## 11. Запуск и проверка ноды

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

## Huge Thanks to ITROCKET for amazing tool and contributions!
Check it out: [https://itrocket.net/](https://itrocket.net/)
