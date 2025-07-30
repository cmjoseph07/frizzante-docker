# Frizzante-Docker

## 🐙 Getting Started

> [!NOTE]  
> Frizzante Docker is A Docker-based installer and runtime for Frizzante.

1. If not already done, [install Docker Compose](https://docs.docker.com/compose/install/) (v2.10+) and clone this project.
2. Run `docker compose build --pull --no-cache` to build fresh images.
3. Run `docker compose up` to set up and start a fresh Frizzante project, subsequent runs of this command will simply start the frizzante container.\
   This way you can connect to the container with your IDE and start developing, alternatively ...
4. ... you can also run `DEV=1 docker compose up`, which will start the development server inline.
5. Run `docker compose down --remove-orphans` to stop the Docker containers.

## ⚡️ Features

* Prod, Dev, and CI ready
* Single service, can do everything through [Docker](https://www.docker.com).
* Blazing-fast performance thanks to [Go](https://go.dev) + [Svelte](https://svelte.dev)
* Super-readable configuration with comments for easy editing

## 📚 Docs

> [!NOTE]  
> Coming soon with additional guides and extra services.

## 🤝 Credits

- Created by [Chris Joseph](https://github.com/cmjoseph07) with help from [razshare](https://github.com/razshare) the developer of Frizzante.
- [Symfony-Docker](https://github.com/dunglas/symfony-docker) -- provided initial idea and structure.

## License

Frizzante Docker is available under the MIT License.