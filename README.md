[![Docker Build Status](https://img.shields.io/docker/build/tassoevan/alpine-chrome.svg)](https://hub.docker.com/r/tassoevan/alpine-chrome/) [![Docker Pulls](https://img.shields.io/docker/pulls/tassoevan/alpine-chrome.svg)](https://hub.docker.com/r/tassoevan/alpine-chrome/)

# Supported tags and respective `Dockerfile` links

- `latest`, `93` [(Dockerfile)](https://github.com/sampaiodiego/alpine-chrome/blob/master/Dockerfile)
- `with-node` [(Dockerfile)](https://github.com/sampaiodiego/alpine-chrome/blob/master/with-node/Dockerfile)
- `with-puppeteer` [(Dockerfile)](https://github.com/sampaiodiego/alpine-chrome/blob/master/with-puppeteer/Dockerfile)
- `80`
- `73`

# alpine-chrome

Chrome running in headless mode in a tiny Alpine image

# Why this image

We often need a headless chrome.
We created this image to get a fully headless chrome image.
Be careful to the "--no-sandbox" flag from Chrome

# Build instructions

Single platform:
```
docker build -t tassoevan/alpine-chrome .
```

Multi platform:
```
docker buildx build --platform=linux/amd64,linux/arm64/v8 -t tassoevan/alpine-chrome --push .
```

# 3 ways to use Chrome Headless with this image

## Not secured

Launch the container using:

`docker run -it --rm tassoevan/alpine-chrome` and use the `--no-sandbox` flag for all your commands.

Be careful to know the website you're calling.

Explanation for the `no-sandbox` flag in a [quick introduction here](https://www.google.com/googlebooks/chrome/med_26.html) and for [More in depth design document here](https://chromium.googlesource.com/chromium/src/+/master/docs/design/sandbox.md)

## With SYS_ADMIN capability

Launch the container using:
`docker run -it --rm --cap-add=SYS_ADMIN tassoevan/alpine-chrome`

This allows to run Chrome with sandboxing but needs unnecessary privileges from a Docker point of view.

## The best: With seccomp

Thanks to ever-awesome Jessie Frazelle seccomp profile for Chrome.

[chrome.json](https://github.com/sampaiodiego/alpine-chrome/blob/master/chrome.json)

Also available here `wget https://raw.githubusercontent.com/jfrazelle/dotfiles/master/etc/docker/seccomp/chrome.json`

Launch the container using:
`docker run -it --rm --security-opt seccomp=$(pwd)/chrome.json tassoevan/alpine-chrome`

# How to use in command line

## Default entrypoint

The default entrypoint does the following command: `chromium-browser --headless --disable-gpu`

You can get full control by overriding the entrypoint using: `docker run -it --rm --entrypoint ""tassoevan/alpine-chrome chromium-browser ...`

## Use the devtools

Command (with no-sandbox): `docker run -d -p 9222:9222 tassoevan/alpine-chrome --no-sandbox --remote-debugging-address=0.0.0.0 --remote-debugging-port=9222 https://www.chromestatus.com/`

Open your browser to: `http://localhost:9222` and then click on the tab you want to inspect. Replace the beginning
`https://chrome-devtools-frontend.appspot.com/serve_file/@.../inspector.html?ws=localhost:9222/[END]`
by
`chrome-devtools://devtools/bundled/inspector.html?ws=localhost:9222/[END]`

## Print the DOM

Command (with no-sandbox): `docker run -it --rm tassoevan/alpine-chrome --no-sandbox --dump-dom https://www.chromestatus.com/`

## Print a PDF

Command (with no-sandbox): `docker run -it --rm -v $(pwd):/usr/src/app tassoevan/alpine-chrome --no-sandbox --print-to-pdf --hide-scrollbars https://www.chromestatus.com/`

## Take a screenshot

Command (with no-sandbox): `docker run -it --rm -v $(pwd):/usr/src/app tassoevan/alpine-chrome --no-sandbox --screenshot --hide-scrollbars https://www.chromestatus.com/`

### Size of a standard letterhead.

Command (with no-sandbox): `docker run -it --rm -v $(pwd):/usr/src/app tassoevan/alpine-chrome --no-sandbox --screenshot --hide-scrollbars --window-size=1280,1696 https://www.chromestatus.com/`

### Nexus 5x

Command (with no-sandbox): `docker run -it --rm -v $(pwd):/usr/src/app tassoevan/alpine-chrome --no-sandbox --screenshot --hide-scrollbars --window-size=412,732 https://www.chromestatus.com/`

### Screenshot owned by current user (by default the file is owned by the container user)

Command (with no-sandbox): `` docker run -u `id -u $USER` -it --rm -v $(pwd):/usr/src/apptassoevan/alpine-chrome --no-sandbox --screenshot --hide-scrollbars --window-size=412,732 https://www.chromestatus.com/ ``

# How to use with Puppeteer

With tool like ["Puppeteer"](https://pptr.dev/#?product=Puppeteer&version=v1.15.0&show=api-class-browser), we can add a lot things with our Chrome Headless.

With some code in NodeJS, we can improve and make some tests.

See the ["with-puppeteer"](https://github.com/sampaiodiego/alpine-chrome/blob/master/with-puppeteer) folder for more details.

If you have a NodeJS/Puppeteer script in your `src` folder named `pdf.js`, you can launch it using the following command:

```
docker run -it --rm -v $(pwd)/src:/usr/src/app/src --cap-add=SYS_ADMINtassoevan/alpine-chrome:with-puppeteer node src/pdf.js
```

With the ["wqy-zenhei"](https://pkgs.alpinelinux.org/package/edge/testing/x86/wqy-zenhei) library, you could also manipulate asian pages like in ["screenshot-asia.js"](https://github.com/sampaiodiego/alpine-chrome/blob/master/with-puppeteer/src/screenshot-asia.js)

```
docker run -it --rm -v $(pwd)/src:/usr/src/app/src --cap-add=SYS_ADMINtassoevan/alpine-chrome:with-puppeteer node src/screenshot-asia.js
```

These websites are tested with the following supported languages:

- Chinese (with `https://m.baidu.com`)
- Japanese (with `https://www.yahoo.co.jp/`)
- Korean (with `https://www.naver.com/`)

# References

- Headless Chrome website: https://developers.google.com/web/updates/2017/04/headless-chrome

- List of all options of the "Chromium" command line: https://peter.sh/experiments/chromium-command-line-switches/

- Where to file issues: https://github.com/sampaiodiego/alpine-chrome/issues

# Versions (in latest)

## Alpine version

```
docker run -it --rm --entrypoint "" tassoevan/alpine-chrome cat /etc/alpine-release
3.15.0
```

## Chrome version

```
docker run -it --rm --entrypoint "" tassoevan/alpine-chrome chromium-browser --version
Chromium 93.0.4577.82
```
