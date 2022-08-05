==Example of how to build a container for use on CANFAR.net==

The canfar.net science portal allows users to build docker containers
to be launched on that platform.  Building containers can be a little
tricky.  There are various documentation pages but this is more of a
cookbook with an example.

=== Step 1 - Build a Dockerfile ===

Here you will build a Dockerfile that is used by the `docker build` command to build an container.

==== What's a Dockerfile? ====

There are many web pages that explain how to build things with `docker`.  In this cookbook I include a `Dockerfile` that build an `IRAF` deployment.  Have a look at that to see what CANFAR specific things are needed for a container to work on canfar.net

Read the Dockerfile to get a hang of how to build CANFAR Dockerfiles.

==== Why is there a Makefile ====

Remembering the syntax for the `docker` commands is more than I need so I construct a `Makefile` to do those commnds.  The included `Makefile` is run as:

`make dev`

or

`make deploy`

=== Step 2 - Testing the container ===

The `dev` version builds a container and keeps that local.  You can then launch that container and use it locally or just use it for some testing.  To launch the container that is built by the incuded `Dockerfile` and `Makefile` do:

`docker run --user jkavelaars  --interactive --tty --ip 0.0.0.0 --rm --env DISPLAY=host.docker.internal:0 images.canfar.net/uvickbos/iraf:0.1  xterm  -fg white -bg black -title iraf`

- `run` --> run the container
- `--user jkavelaars` --> set the user in the container
- `--interactive` --> set this as an interactive container
- `--tty` --> create a terminal connection
- `--ip 0.0.0.0` --> connect this to the local IP interface (needed for X11 forwarding)
- `--rm` --> remove the running container when we exit the command shell.
- `env DISPLAY=host.docker.internal:0` --> Set the X11 display to the internal 0.0.0.0 address which is forward to the local IP.
- `images.canfar.net/uvickbos/iraf:0.1` --> This is the container we built with the `make dev` command
- `xterm` --> Let's star an xterm as the basic execution step.

- the rest are options passed to `xterm`

Run the container and check that IRAF is working.

=== Step 3 - Push the image ===

`make deploy` will run the `docker` command needed to push the image
to canfar.net.  To push images you must have `developer` permsion on
`images.canfar.net` (ask support@canfar.net to hook you up). And you
need to have a token transfered to a local docker cache, see
instrutions here:
<https://github.com/opencadc/science-platform/tree/master/containers#publishing>

=== Step 4 - Tag the new container ===

Each container on images.canfar.net needs to be TAG as either (or
both) and `notebook` or `desktop-app` container (DO NOT LABEL AS
`desktop` container, that wont help you).  This allows the Skaha
system to discover your container and offer to launch it.  Checkout
<https://github.com/opencadc/science-platform/tree/master/containers>
for some details on how to do that.

=== Step 5 - Luanch you container via canfar.net site ===