# Luanti headless server builds for Linux (`luantiserver`)
[Luanti forum topic](https://forum.luanti.org/viewtopic.php?t=31081)

The headless server binary is a special build of the engine with less dependencies that is useful for running a Luanti server on headless Linux systems such as VPSes. For server owners it may be complicated to obtain an up to date server binary as most distros you would run on a server such as Debian offer way too old versions of the server in the package repositories. The solution is of course to build from source, but can be a daunting task to someone who just wants to be able to download a server binary and get it running. These builds are for you.

The builds are compiled as RUN_IN_PLACE=1, meaning that server files will be stored self-contained within the same folder you have extracted the tarball to. [See the Luanti docs](https://docs.luanti.org/for-server-hosts/setup/linux/#running-the-server) for more information on how to set up and run the server.

The builds are not built with any additional database backends other than SQLite, but the dependencies they have are few and should only depend on evergreen libraries (libcurl, ncurses, sqlite, zstd, zlib) that will almost certainly exist on your server. The latest version of LuaJIT at the time is built and included in the binary, and the interactive ncurses terminal is enabled. The server binary is currently built in Debian 11 Bullseye and should also work on any newer glibc-based distribution.

To clarify: *The builds work on anything equivalent to Debian 11 **and newer***. If a distribution has a glibc that is newer than the version 2.31 that Debian 11 uses (which is 5 years old at this point), then it will work. Glibc versions are backwards compatible, but not forwards compatible, so building on an older distribution is standard practice for Linux binary distribution and improves the range of compatibility.

Debug symbols are also provided as a separate download with each build, with which you can use to make segfault stacktraces more human readable for assisting with debugging when reporting engine crashes to the core developers.

I dogfood these builds for running my own [Voxelmanip Classic](https://classic.voxelmanip.se) server, so I hope they should also work for whatever server you may want to run.

### [Releases](https://github.com/rollerozxa/luantiserver/releases)

## Configuration
The builds are made using some scripts in Github Actions. If you want to make your own custom server builds with other build options then feel free to fork.

- Built on Debian 11 Bullseye
- The latest version of LuaJIT at the time of the build is used and is statically linked with the executable
- RUN_IN_PLACE is 1
- cURL is enabled
- The interactive ncurses terminal is enabled
- The bundled libgmp and libjsoncpp are used to reduce amount of runtime dependencies - jsoncpp breaks its ABI many times!

## Debug symbols
A separate file containing debug symbols are generated for each server build. These can be used to help troubleshooting segfaults when a segfault occurs and you want to create a helpful backtrace for troubleshooting. If you put the debug symbol file next to the executable it will show the debug symbols automatically if the server is run with a debugger.
