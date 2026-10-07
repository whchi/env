# infra

本機開發用的基礎服務與 Docker 相關檔案。

## 結構

```
infra/
├── docker-compose.yaml   # 入口,include 下列所有 compose,project name: dev-infra
├── network.yaml          # 共用網路 dev-infra-network
├── db/postgres.yaml
├── redis/sentinel.yaml   # 1 master + 2 replica + 3 sentinel
├── smtp/mailpit.yaml
├── storage/minio.yaml
├── docker/               # Dockerfile(solc / sshd / systemd / web / php-fpm)
```

## 啟動

```sh
cd infra
export VM_IP=<host 可被 client 連到的 IP>   # redis sentinel 需要
docker compose up -d                         # 全部
docker compose up -d postgres mailpit        # 只啟動部分
```

只能從 `infra/` 目錄用 `docker-compose.yaml` 啟動。直接 `-f db/postgres.yaml` 會被當成獨立 project,不會加入 `dev-infra-network`。

## 服務與 port

| 服務 | Host port | 帳密 |
|---|---|---|
| postgres 17 | 5432 | postgres / postgres(db: postgres) |
| redis-master / replica-1 / replica-2 | 6379 / 6380 / 6381 | - |
| redis-sentinel-1 / 2 / 3 | 26379 / 26380 / 26381(master name: `mymaster`) | - |
| mailpit | SMTP 1025、Web UI 8025 | 任意帳密皆接受 |
| minio | API 9000、Console 9001 | minioadmin / minioadmin |

## 讓 app 連到 infra

同一個 `dev-infra-network` 內可用 service 名稱連線(`postgres`、`redis-master`、`mailpit`、`minio`)。app 的 compose 加上:

```yaml
networks:
  default:
    external: true
    name: dev-infra-network
```

需先啟動 infra,網路才會存在。也可以直接用 host port 連 `host.docker.internal`。

## 注意

- 資料目錄在各 compose 旁的 `data/`(`db/data`、`storage/data`、`redis/data`),已由 `infra/.gitignore` 排除。
- `golang/`、`laravel/`、`nodejs/`、`python/fastapi/` 的 compose 也會綁 5432、6379、3306 等 port,與 infra 同時啟動會衝突。
