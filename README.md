# MurrellGroupRegistry

This is a Julia package registry for MurrellGroup, enabling easier version management and instant registration of packages. This is particularly useful for packages that are in development or not quite deserving of registration in the [General](https://github.com/JuliaRegistries/General) registry.

## Installation

Julia stores registries in `~/.julia/registries`, meaning installation is needed only once per user on a given machine:

```julia
using Pkg
pkg"registry add https://github.com/MurrellGroup/MurrellGroupRegistry"
```

Once installed, using packages in this registry is as simple as using any other.

## Registering a package

A package can be registered in MurrellGroupRegistry using [LocalRegistry.jl](https://github.com/GunnarFarneback/LocalRegistry.jl), which may be added to your global environment:

```julia
using Pkg
pkg"activate"
pkg"add LocalRegistry"
```

### With write access

With the package that you want to register being in your working directory, run:

```julia
using Pkg, LocalRegistry
pkg"activate ."
register(registry="MurrellGroupRegistry")
```

### Through pull request

1. Fork the registry or something.
2. Checkout new branch.
3. As above, but call `register(registry="path/to/.julia/registries/MurrellGroupRegistry", push=false)`.
4. Create a pull request.
5. ???

## See also

- [HolyLabRegistry](https://github.com/HolyLab/HolyLabRegistry) (somewhat dated, but README goes into more depth)
