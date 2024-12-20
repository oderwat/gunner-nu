# Gunner

Gunner is a simple Gleam language code runner that allows users to execute Gleam code snippets easily and efficiently.

You need nushell to use it! You activate it using `source gunner.nu`

## Quickstart

```
git clone https://github.com/hara/gunner.git
source ./gunner/gunner.nu
gunner init
gunner run examples/hello.gleam
gunner add gleam_erlang
gunner run examples/erlang-only.gleam
```

## Here are some of its key functionalities:

* running Gleam code snippets `gunner <gleam_file>` without creating a gleam project
* adding packages to the runner `gunner add <package>` (can also add multiple packages at once)
* running with Erlang or JS targets (in the "sandbox") `gunner <gleam_file> --js`
* formatting Gleam code `gunner format <gleam_file>`
* builds the sandbox "runner" using docker `gunner init` optional: `gunner init <package1> <package2> ...` (e.g. `gunner init gleam_erlang gleam_otp`)
* allows running `gleam` directly inside the sandbox `gunner gleam deps list` (this can result in unexpected behavior)
* it uses a volume to cache the dependencies and parts of the build

## Commands

### gunner init

```
Initialize the gleam runner image (needs docker)

Usage:
  > gunner init ...(package) 

Flags:
  -h, --help: Display the help message for this command

Parameters:
  ...package <any>: the packages to add
```

### gunner

```
Run a gleam code file

Usage:
  > gunner {flags} <gleam_file> 

Subcommands:
  gunner add (custom) - Add a package to the runner
  gunner format (custom) - Format a gleam code file
  gunner gleam (custom) - Runs any command in the runner (with gleam)
  gunner init (custom) - Initialize the gleam runner image (needs docker)

Flags:
  --js: using javastript target
  -f, --format: format the code before running
  -v, --verbose: output compililation information
  -h, --help: Display the help message for this command

Parameters:
  gleam_file <any>: the gleam code file to run
```

### gunner add

```
Add a package to the runner

Usage:
  > gunner add ...(package) 

Flags:
  -h, --help: Display the help message for this command

Parameters:
  ...package <any>: the packages to add
```

### gunner format

```
Format a gleam code file

Usage:
  > gunner format <gleam_file> 

Flags:
  -h, --help: Display the help message for this command

Parameters:
  gleam_file <any>: the gleam code file to format
```

### gunner gleam

```
Runs any command in the runner (with gleam)

Usage:
  > gunner gleam ...(args) 

Flags:
  -h, --help: Display the help message for this command

Parameters:
  ...args <any>: the packages to add
```
