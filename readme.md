# DTN Emulator

## How to clone

This repo has git submodules dependencies, so in order to properly work, you need to clone it by doing:

```
git clone --recurse-submodules -j8 git@github.com:octaviotastico/dtn-emulator.git
```

If you already cloned the repo without using the recurse submodules flag, or you have an older version of Git, you can use:

```
git submodule update --init --recursive
```
