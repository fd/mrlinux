# OrbStack

## Instructions

Download and [install](https://docs.orbstack.dev/quick-start).

```sh
# Or just run if you have homebrew installed
brew install orbstack
```

That's it. Now you can use `mrlinuxctl`.

## Changes made to the Host system

_None, unless you count OrbStack_

This OS will never change settings in your _host OS_. The 
`mrlinuxctl` tool is warpper around `orbctl` and is only there
to help setup the _guest OS_. When Orbstack supports custom 
OS images this can be changed.

## Changes made to OrbStack

_None_

This OS just includes the OrbStack provided configurations
and leaves those unchanged.

## Known issues

- Running a `x86_64` guest on a `aarch64` host seems to be broken. (See: https://github.com/orbstack/orbstack/issues/54)

## Notes

- OrbStack seems to run LXC containers as _machines_ in a VM
- These containers seem to run in _privileged_ mode to reduce friction with tools like docker and k8s.
- This is _fine_ as a dev env on the host has similar access.
