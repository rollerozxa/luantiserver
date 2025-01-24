# Luanti headless server builds for Linux (`luantiserver`)
[Luanti forum topic](https://forum.luanti.org/viewtopic.php?t=31081)

The headless server binary is a special build of the engine with less dependencies that is useful for running a Luanti server on headless Linux systems such as VPSes. For server owners it may be complicated to obtain an up to date server binary as most distros you would run on a server such as Debian offer way too old versions of the server in the package repositories. The solution is of course to build from source, but can be a daunting task to someone who just wants to be able to download a server binary and get it running. These builds are for you.

The builds are not built with any additional database backends other than SQLite, but the dependencies they have are few and should only depend on evergreen libraries that will almost certainly exist on your server. They are currently built on Debian 11 Bullseye and should also work on any newer glibc-based distribution.

The latest version of LuaJIT that exists at the time is built with the server, and the interactive ncurses terminal is enabled. The builds also patch `core.get_player_information` to provide version information about clients, which is normally only available in debug builds in upstream, but other than that they are verbatim built from the corresponding Luanti version.

Debug symbols are also provided as a separate download with each build, with which you can use to make segfault stacktraces more human readable for assisting with debugging when reporting engine crashes to the core developers.

I dogfood these builds for running my own [Voxelmanip Classic](https://classic.voxelmanip.se) server, so I hope they should also work for whatever server you may want to run.

The builds should work on distributions that are equivalent to Debian 11 Bullseye and newer. The only dependencies it requires on the system are evergreen libraries (libcurl, ncurses, sqlite, zstd, zlib) that should already be on the server.

### [Releases](https://github.com/rollerozxa/luantiserver/releases)

## Configuration
The builds are made using some scripts in Github Actions. If you want to make your own custom server builds with other build options then feel free to fork.

- Built on Debian 11 Bullseye
- The latest version of LuaJIT at the time of the build is used and is statically linked with the executable
- RUN_IN_PLACE is 1
- cURL is enabled
- The interactive ncurses terminal is enabled
- The bundled libgmp and libjsoncpp are used to reduce amount of runtime dependencies - jsoncpp breaks its ABI many times!
- A patch is applied to reveal more player version information in `core.get_player_information` for release builds

## Debug symbols
A separate file containing debug symbols are generated for each server build. These can be used to help troubleshooting segfaults when a segfault occurs and you want to create a helpful backtrace for troubleshooting. If you put the debug symbol file next to the executable it will show the debug symbols automatically if the server is run with a debugger.
