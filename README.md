# Frizzante-Docker

## 🐙 Getting Started

> [!NOTE]  
> Frizzante Docker is A Docker-based installer and runtime for Frizzante.

1. If not already done, [install Docker Compose](https://docs.docker.com/compose/install/) (v2.10+).
1. Clone this project.
   ```sh
   git clone git@github.com:cmjoseph07/frizzante-docker.git && cd frizzante-docker
   ```
1. Build fresh images.
   ```sh
   docker compose build --pull --no-cache
   ```
1. Create a fresh Frizzante project and start the container.
   ```sh
   docker compose up
   ```
   Subsequent runs of this command will simply start the container.
1. Attach to the container with your IDE or with your shell.
   ```sh
   docker exec -it frizzante-start sh
   ```
1. You can stop the container with
   ```sh
   docker compose down --remove-orphans
   ```

> [!TIP]
> As an alternative, instead of starting the container in background and attaching to it,
> you can directly start the development server inline.
> ```sh
> DEV=1 docker compose up
> ```
> However, this docker project doesn't integrate with [Go Delve](https://github.com/go-delve/delve) for various reasons, 
> hence you won't be able to debug your application out of the box if you choose to develop this way.

## 🚀 Production with Docker

**Option 1: Build and run production binary inside container**
```sh
# Inside the container
frizzante --build
./.gen/bin/app
```

**Option 2: Build production Docker image**
```sh
docker build --target frizzante_prod -t my-app:prod .
docker run -p 8080:8080 my-app:prod
```

**Option 3: Use Docker Compose for production**
```sh
docker compose -f compose.yaml -f compose.prod.yaml up -d --build
```

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