# Hello World

[https://github.com/Kerwood/hello-world](https://github.com/Kerwood/hello-world)

### Files
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

#### Build the container
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
