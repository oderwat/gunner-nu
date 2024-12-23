#!/usr/bin/env nu

# Initialize the gleam gunner image (needs docker)
export def "gunner init" [
    ...package # the packages to add 
    ] {
    try { docker image rm -f gunner } catch {}
    try { docker volume rm -f gunner } catch {}
    docker image inspect gunner o> /dev/null e>| if $in =~ "No such image" {
        mkdir /tmp/gunner-build
        cd /tmp/gunner-build
        rm -f Dockerfile
        r#'
        FROM alpine
        RUN apk add --no-cache \
            ca-certificates \
            gleam \
            erlang \
            rebar3
        
        WORKDIR /
        RUN gleam new gunner
        WORKDIR /gunner
        CMD ["gleam","run","--no-print-progress"]
        '# | save Dockerfile
        #' fix that syntax highlighting
        docker pull alpine:latest
        docker build -t gunner:latest .
        ($package | each { docker run --rm --volume gunner:/gunner gunner gleam add $in }) | ignore
        docker run --rm --volume gunner:/gunner gunner gleam run
        docker run --rm --volume gunner:/gunner gunner rm -rf /gunner/build/dev/erlang/gunner
        cd -
        rm -rf /tmp/gunner-build
    }
}

# Run a gleam code file
export def "gunner" [
    gleam_file # the gleam code file to run
    --js # using javastript target
    --format (-f) # format the code before running
    --verbose (-v) # output compililation information
]: nothing -> nothing {
    let target = if $js { ["--target", "javascript"] } else { [] }
    let vflag = if $verbose { [] } else { "--no-print-progress" }
    print $gleam_file
    if ($gleam_file | path type) != "file" {
        print $"File not found: '($gleam_file)'"
        return
    }
    let path = ($"./($gleam_file):/gunner/src/gunner.gleam" | path expand)
    if $format {
        docker run -t --rm --volume gunner:/gunner --volume $path gunner gleam format
    }
    docker run --rm --volume gunner:/gunner gunner rm -rf /gunner/build/dev/erlang/gunner
    docker run -t --rm --volume gunner:/gunner --volume $path gunner gleam run ...$target $vflag
}

# Format a gleam code file
export def "gunner format" [
    gleam_file # the gleam code file to format
]: nothing -> nothing {
    if ($gleam_file | path type) != "file" {
        print $"File not found: '($gleam_file)'"
        return
    }
    let path = ($"./($gleam_file):/gunner/src/gunner.gleam" | path expand)
    docker run -t --rm --volume gunner:/gunner --volume $path gunner gleam format
}

# Add a package to the gunner
export def "gunner add" [
    ...package # the packages to add
]: nothing -> nothing {
    ($package | each { docker run --rm --volume gunner:/gunner gunner gleam add $in }) | ignore
}

# Runs any command in the gunner (with gleam)
export def "gunner gleam" [
    ...args # the packages to add
]: nothing -> nothing {
    docker run --rm --volume gunner:/gunner gunner gleam ...$args
}

# Remove the gunner docker image and volume
export def "gunner de-init" []: nothing -> nothing {
    docker image rm -f gunner
    docker volume rm -f gunner
}
