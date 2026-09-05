# ctan-mirror-docker

Docker (Compose) setup for mirroring CTAN (Comprehensive TeX Archive Network).

## Requirements

- Docker & Docker Compose
- Traefik (for reverse proxy and SSL termination)

## Usage

1. Clone this repository.
2. Move `docker-compose.example.yml` to `docker-compose.yml`.
3. Edit the `environment` section in `docker-compose.yml` to set `HOST` and a unique `CTAN_SYNC_CRON` schedule. Set the same hostname in the Traefik routing label.
4. Run `docker-compose up -d` to start the mirror. The first run will take a while, as it will download the entire CTAN archive. Subsequent runs will only download updates.
5. Access your mirror at `https://mirror.example.com` (or your configured domain).

> [!IMPORTANT]
> Please carefully read the guide on hosting a CTAN mirror at [CTAN's official guide](https://ctan.org/mirrors/register/).
> Especially, make sure to set `CTAN_SYNC_CRON` to a **custom** time. You can generate a random minute using the following command on Linux:
>
> ```bash
> shuf -i 0-59 -n 1
> ```

## Configuration

The image can be configured using environment variables.

| Variable         | Image default | Description                                            |
| ---------------- | ------------- | ------------------------------------------------------ |
| `CTAN_SYNC_CRON` | `21 * * * *`  | Cron schedule used for CTAN syncs.                     |
| `HOST`           | `localhost`   | Apache server hostname, optionally followed by a port. |

Configure these values in `docker-compose.yml`:

```yaml
environment:
    CTAN_SYNC_CRON: '37 * * * *'
    HOST: mirror.example.com
```

## Contributing

Contributions are welcome! Please fork this repository and submit pull requests for any improvements or bug fixes.

## License

This project is licensed under the GNU General Public License v3.0. See the [LICENSE](LICENSE) file for details.
