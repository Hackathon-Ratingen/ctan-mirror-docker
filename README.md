# ctan-mirror-docker

Docker (Compose) setup for mirroring CTAN (Comprehensive TeX Archive Network).

## Requirements

- Docker & Docker Compose
- Traefik (for reverse proxy and SSL termination)

## Usage

1. Clone this repository.
2. Move `docker-compose.example.yml` to `docker-compose.yml`.
3. Edit `ctan-site.conf` and `docker-compose.yml` to set your domain name (replace `mirror.example.com`).
4. Run `docker-compose up -d` to start the mirror. The first run will take a while, as it will download the entire CTAN archive. Subsequent runs will only download updates.
5. Access your mirror at `https://mirror.example.com` (or your configured domain).

> [!IMPORTANT]
> Please carefully read the guide on hosting a CTAN mirror at [CTAN's official guide](https://ctan.org/mirrors/register/)
> Especiall, make sure to change the cronjob in `Dockerfile` to run at a custom time. You can generate a random time using the following command on linux:
>
> ```bash
> shuf -i 0-59 -n 1
> ```

## Contributing

Contributions are welcome! Please fork this repository and submit pull requests for any improvements or bug fixes.

## License

This project is licensed under the GNU General Public License v3.0. See the [LICENSE](LICENSE) file for details.
