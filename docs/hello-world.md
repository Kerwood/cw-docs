# Hello World

[https://github.com/Kerwood/hello-world](https://github.com/Kerwood/hello-world)

## Files
#### index.html
```
<!doctype html>
<html lang="en">

<head>
  <meta charset="utf-8">
  <title>Hello World</title>
</head>

<body>
  <pre>Hello world!</pre>
</body>
</html>
```


#### Dockerfile
```
FROM nginx

COPY index.html /usr/share/nginx/html/index.html

CMD ["nginx", "-g", "daemon off;"]
```

## Build and run
Clone the repository and enter the directory.
```
git clone https://github.com/Kerwood/hello-world.git
cd hello-world
```

Build the container.
```
docker build -t hello-world .
```

Run the image.
```
docker run --name hello-world -p 9001:80 -d hello-world
```

## Docker Compose

### File
#### docker-compose.yml
```
version: '3'

services:
  hello-world:
    image: kerwood/hello-world
    container_name: hello-world
    ports:
      - 9001:80
```

Start the service with docker compose.
```
$ docker-compose up -d
Creating network "hello-world_default" with the default driver
Creating hello-world ... done
```

List the services
```
$ docker-compose ps
   Name             Command          State          Ports        
-----------------------------------------------------------------
hello-world   nginx -g daemon off;   Up      0.0.0.0:9001->80/tcp
```

Remove all services
```
$ docker-compose down
Stopping hello-world ... done
Removing hello-world ... done
Removing network hello-world_default
```
