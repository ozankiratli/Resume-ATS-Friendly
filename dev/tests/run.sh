#!/usr/bin/env bash
#
# The test suite: compile both example documents with each engine and report everything
# that went wrong, not only the first thing.
#
# Usage: dev/tests/run.sh [--out <dir>] [--keep]
#        dev/tests/run.sh --env <name>[,<name>...]|all [--out <dir>]
#        dev/tests/run.sh --clean
#        dev/tests/run.sh --list
#
#   no --env       Test this machine's TeX Live.
#   --env          Test in Docker, in the named environments (ENVIRONMENTS and
#                  environment() below) or in all of them. Each runs in a throwaway
#                  container: its base image is pulled, TeX Live is installed into the
#                  container the way that environment installs it, the suite runs, and
#                  the container is removed with everything installed in it. Nothing is
#                  reused, so every run installs TeX Live again, which takes a few
#                  minutes per environment. Base images are kept; when a pull brings a
#                  newer one, the copy it replaces is removed unless something else uses
#                  it. Ctrl-C removes the running container and stops the run.
#   --out <dir>    Keep the PDFs and logs there, one directory per engine. With --env,
#                  one directory per environment, each holding one per engine and the TeX
#                  Live installation's output in setup.log. What an earlier run left
#                  there is removed first.
#   --keep         Leave the scratch directory in place, to read a failure in. Only
#                  without --env; with --env, keep the output with --out.
#   --clean        Remove the environments' base images, which are all a run leaves
#                  behind, to free the space between testing sessions. The next --env
#                  run pulls them again. An image a container still uses is not removed.
#   --list         Print the environment names, one per line.
#   --install <m>  Internal: install TeX Live with install_texlive <m> before the suite.
#                  --env passes it to the containers it starts; anywhere else it is
#                  refused, because it runs a package manager as root.
#
# Docker runs through sudo, as `sudo docker`. sudo asks for your password at the start
# of an --env run, and again if a run outlasts its timeout. DOCKER sets a different
# command, e.g. DOCKER=docker for a user in the docker group. The program looked for is
# its first word that is neither sudo nor an option.
#
# Each document is compiled with every engine in ENGINES below, by latexmk with -f in
# nonstop mode, so an error does not end the compile: it goes on to the end, biber runs,
# and the log holds every error instead of the first one. TeX's log lines are not
# wrapped, so no message is split across lines. A document fails on:
#
#   - any error in the log
#   - latexmk not finishing cleanly
#   - no PDF, or an empty one
#   - an undefined reference or citation, which prints "??" in the PDF
#   - an error from biber
#   - a warning from our own classes, drevoresumecv or drevocover
#
# Errors are listed with the lines TeX printed under them, up to 60 lines per document;
# the whole log is kept with --out.
#
# Reported without failing, because they are worth knowing and not defects by
# themselves: warnings from other packages (a package that has been renamed or replaced
# shows up here first), overfull lines, the page count, and the versions of the packages
# most likely to change under this template.
#
# A check that could not run, because what it reads was never written or the compile
# stopped before the end, is a failure and not a pass.
#
# Compiles in a scratch directory, so nothing in the working tree is touched.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
DOCS=(Resume CoverLetter)

# The engines every document is compiled with. dev/release-notes-tail.md names them to
# users, so the two change together. LuaLaTeX is not supported: the classes select the
# T1 font encoding, for which there is no Source Sans under LuaLaTeX, so LaTeX sets the
# documents in its default serif font instead, and the semibold shape is missing even
# in LuaLaTeX's own encoding. Adding it back means fixing that in both classes first.
ENGINES="pdflatex"

# The environments, chosen by who uses them: the list here, and what each one is in
# environment(). A new environment needs both. When Ubuntu releases a new LTS, both
# Ubuntu entries move up one; a workaround for an old package version can go once the
# previous LTS no longer has that version. SETUP says how install_texlive() installs TeX
# Live there.
ENVIRONMENTS="ubuntu-24.04 ubuntu-26.04 arch latest-ctan"
environment() {
    case "$1" in
        ubuntu-24.04) IMAGE="ubuntu:24.04";           SETUP="apt";    TITLE="Ubuntu 24.04 (previous LTS)" ;;
        ubuntu-26.04) IMAGE="ubuntu:26.04";           SETUP="apt";    TITLE="Ubuntu 26.04 (current LTS)" ;;
        arch)         IMAGE="archlinux:latest";       SETUP="pacman"; TITLE="TeX Live as released (Arch)" ;;
        latest-ctan)  IMAGE="texlive/texlive:latest"; SETUP="ctan";   TITLE="Latest CTAN" ;;
        *) return 1 ;;
    esac
}

# How each environment installs TeX Live. --install runs this as root inside the
# environment's throwaway container, never on your machine. The package lists are TeX
# Live collections, under each distribution's name for them. They come from what a
# compile of both documents opens (latexmk's .fls), mapped to the packages that own
# those files. A new \RequirePackage in a class, or a new engine in ENGINES, can need a
# collection added here; the suite reports a missing file as missing from the
# installation, not as a defect in the template.
#
# Each step is chained with &&, because --install calls this inside an if, where set -e
# does not apply: without the chaining, a failed step would not stop the ones after it.
install_texlive() {
    case "$1" in
        apt)
            # Ubuntu's own packages, without the ones apt only recommends, which would add
            # dozens of unrelated fonts, except cm-super. texlive-fonts-extra recommends
            # it, so a default Ubuntu install has it. Without it, pdfTeX falls back to
            # bitmap fonts that text cannot be extracted from: the header's bullets
            # vanished from the PDF's text that way. Debian ships it outside the texlive-*
            # collections, so the .fls mapping does not find it.
            export DEBIAN_FRONTEND=noninteractive
            apt-get update && apt-get install -y --no-install-recommends \
                texlive-latex-base texlive-latex-recommended texlive-latex-extra \
                texlive-fonts-recommended texlive-fonts-extra cm-super \
                texlive-pictures texlive-plain-generic texlive-bibtex-extra \
                latexmk biber
            ;;
        pacman)
            # Arch's packages: the current TeX Live release, without the CTAN updates
            # since.
            pacman -Syu --noconfirm --needed \
                texlive-basic texlive-latex texlive-latexrecommended texlive-latexextra \
                texlive-fontsrecommended texlive-fontsextra \
                texlive-pictures texlive-plaingeneric texlive-bibtexextra \
                texlive-binextra biber
            ;;
        ctan)
            # The texlive/texlive image, rebuilt weekly. The update brings it to today's
            # packages, which is what a MiKTeX user, or a TeX Live user who runs tlmgr
            # update, has. Across a TeX Live year change tlmgr refuses to update the older
            # year, so this fails until the image moves to the new one.
            tlmgr option repository https://mirror.ctan.org/systems/texlive/tlnet \
                && tlmgr update --self --all
            ;;
        *)
            echo "no way to install TeX Live is called $1" >&2
            return 2
            ;;
    esac
}

# The exit status of a container run whose TeX Live installation failed, so it is not
# mistaken for a suite that ran and failed.
INSTALL_FAILED=90

# The files a run leaves in an output directory. Removed before a run writes there, so
# a file it did not write cannot pass for one it did.
clear_outputs() {
    local engine doc
    for engine in $ENGINES; do
        for doc in "${DOCS[@]}"; do
            rm -f -- "$1/$engine/$doc.pdf" "$1/$engine/$doc.log" \
                "$1/$engine/$doc.blg" "$1/$engine/$doc.latexmk.txt"
        done
    done
    rm -f -- "$1/summary.md" "$1/setup.log"
}

OUT=""
KEEP=0
ENVS=""
INSTALL=""
CLEAN=0
while [ $# -gt 0 ]; do
    case "$1" in
        --out)
            OUT="${2-}"
            [ -n "$OUT" ] || { echo "--out needs a directory" >&2; exit 2; }
            shift
            ;;
        --env)
            ENVS="${2-}"
            [ -n "$ENVS" ] || { echo "--env needs an environment name, or all" >&2; exit 2; }
            shift
            ;;
        --install)
            INSTALL="${2-}"
            [ -n "$INSTALL" ] || { echo "--install needs apt, pacman or ctan" >&2; exit 2; }
            shift
            ;;
        --keep) KEEP=1 ;;
        --clean) CLEAN=1 ;;
        --list)
            # Every name listed must be one environment() describes, or --env all would
            # stop on it.
            for name in $ENVIRONMENTS; do
                environment "$name" || {
                    echo "ENVIRONMENTS lists $name, which environment() does not describe" >&2; exit 1; }
            done
            printf '%s\n' $ENVIRONMENTS
            exit 0
            ;;
        *) echo "unknown argument: $1" >&2; exit 2 ;;
    esac
    shift
done
case "$OUT" in ""|/*) ;; *) OUT="$PWD/$OUT" ;; esac

# Docker, as DOCKER says or through sudo: found, authenticated and reachable, or the run
# stops here with the reason.
docker_setup() {
    local word
    read -r -a DOCKER_CMD <<< "${DOCKER:-sudo docker}"
    docker_bin=""
    for word in ${DOCKER_CMD[@]+"${DOCKER_CMD[@]}"}; do
        case "$word" in
            sudo|-*) ;;
            *) docker_bin="$word"; break ;;
        esac
    done
    [ -n "$docker_bin" ] || { echo "DOCKER names no program to run" >&2; exit 2; }
    command -v "$docker_bin" > /dev/null || { echo "$docker_bin not found" >&2; exit 2; }
    if [ "${DOCKER_CMD[0]}" = sudo ]; then
        # Asked here, once, rather than in the middle of the first environment's output,
        # and so a refused password is not reported as a Docker problem.
        sudo -v || {
            echo "sudo did not authenticate, and Docker runs through it (DOCKER=docker runs it without)" >&2
            exit 2
        }
    fi
    "${DOCKER_CMD[@]}" info > /dev/null 2>&1 || {
        echo "cannot reach the Docker daemon through '${DOCKER_CMD[*]}'. Is it running?" >&2; exit 2; }
}

# ---------------------------------------------------------------------------------------
# --clean: remove the base images between testing sessions. Never forced, so an image a
# container still uses is reported and kept.

if [ "$CLEAN" -eq 1 ]; then
    if [ -n "$ENVS$INSTALL$OUT" ] || [ "$KEEP" -eq 1 ]; then
        echo "--clean takes no other option" >&2
        exit 2
    fi
    docker_setup
    kept=0
    for name in $ENVIRONMENTS; do
        environment "$name"
        if ! "${DOCKER_CMD[@]}" image inspect "$IMAGE" > /dev/null 2>&1; then
            echo "  -      $IMAGE was not here"
        elif "${DOCKER_CMD[@]}" image rm "$IMAGE" > /dev/null; then
            echo "  gone   $IMAGE"
        else
            echo "  KEPT   $IMAGE: Docker would not remove it, see above"
            kept=1
        fi
    done
    exit "$kept"
fi

# ---------------------------------------------------------------------------------------
# --env: the same suite, in a throwaway container per environment.

if [ -n "$ENVS" ]; then
    if [ "$KEEP" -eq 1 ]; then
        echo "--keep is for a run on this machine; with --env, keep the output with --out" >&2
        exit 2
    fi
    if [ "$ENVS" = all ]; then ENVS="$ENVIRONMENTS"; else ENVS="${ENVS//,/ }"; fi
    [ -n "${ENVS// /}" ] || { echo "--env names no environment (known: $ENVIRONMENTS)" >&2; exit 2; }
    for name in $ENVS; do
        environment "$name" || { echo "unknown environment: $name (known: $ENVIRONMENTS)" >&2; exit 2; }
    done
    docker_setup

    CID=""
    TMP_OUT=""
    cleanup() {
        if [ -n "$CID" ]; then "${DOCKER_CMD[@]}" rm -f "$CID" > /dev/null 2>&1 || true; fi
        if [ -n "$TMP_OUT" ]; then rm -rf -- "$TMP_OUT"; fi
    }
    trap cleanup EXIT
    # Ctrl-C reaches the docker client following the container's output, which then
    # ends; this stops the run there, and the EXIT trap removes the container.
    trap 'echo; echo "Interrupted: removing the running container."; exit 130' INT

    # Each environment's output lands under --out if one was given, or somewhere
    # temporary that goes when the run ends.
    BASE_OUT="$OUT"
    if [ -z "$BASE_OUT" ]; then
        TMP_OUT="$(mktemp -d)"
        BASE_OUT="$TMP_OUT"
    fi

    passed=0
    total=0
    failed=""
    # Why an environment has no summary, for the table at the end.
    declare -A WHY=()
    for name in $ENVS; do
        environment "$name"
        total=$((total + 1))
        dest="$BASE_OUT/$name"
        # Cleared before anything else, so whatever happens below, nothing from an
        # earlier run is left to pass for this one.
        mkdir -p "$dest"
        clear_outputs "$dest"
        WHY[$name]="the run stopped before it wrote one"
        echo
        echo "=== $TITLE ($name)"

        # Pulled every run, so the environment is what a user installing it today gets. A
        # pull that brings a newer image leaves the old one untagged; it is removed, and
        # never forced, so an image something else still uses stays.
        old_id="$("${DOCKER_CMD[@]}" image inspect -f '{{.Id}}' "$IMAGE" 2> /dev/null || true)"
        if ! "${DOCKER_CMD[@]}" pull "$IMAGE"; then
            if [ -z "$old_id" ]; then
                echo "  FAIL  could not pull $IMAGE, so nothing was tested in it"
                WHY[$name]="could not pull $IMAGE"
                failed="$failed $name"
                continue
            fi
            echo "could not pull $IMAGE; using the copy already here"
        fi
        new_id="$("${DOCKER_CMD[@]}" image inspect -f '{{.Id}}' "$IMAGE" 2> /dev/null || true)"
        if [ -n "$old_id" ] && [ -n "$new_id" ] && [ "$old_id" != "$new_id" ]; then
            "${DOCKER_CMD[@]}" image rm "$old_id" > /dev/null 2>&1 || true
        fi

        # Root inside, which is what the distributions' installers and TeX in these
        # images expect. The repository is mounted read-only.
        if ! CID="$("${DOCKER_CMD[@]}" create \
                -e RESUME_SUITE_CONTAINER=1 -e SUITE_NAME="$TITLE" \
                -v "$ROOT":/src:ro "$IMAGE" \
                bash /src/dev/tests/run.sh --install "$SETUP" --out /out)"; then
            echo "  FAIL  could not create a container from $IMAGE"
            WHY[$name]="could not create a container from $IMAGE"
            CID=""
            failed="$failed $name"
            continue
        fi

        # Started, then followed rather than attached, so Ctrl-C ends the follower and the
        # trap above removes the container, instead of the signal being handed into it.
        status=125
        if "${DOCKER_CMD[@]}" start "$CID" > /dev/null; then
            "${DOCKER_CMD[@]}" logs -f "$CID" 2>&1 || true
            status="$("${DOCKER_CMD[@]}" wait "$CID" 2> /dev/null || echo 125)"
        else
            echo "  FAIL  the container did not start"
            WHY[$name]="the container did not start"
        fi
        if [ "$status" = "$INSTALL_FAILED" ]; then
            WHY[$name]="TeX Live could not be installed; the installation's output is in setup.log"
        fi

        # The output comes out as a tar stream unpacked by you, so the files are yours
        # whether Docker runs as root, through sudo, or rootless.
        if ! "${DOCKER_CMD[@]}" cp "$CID":/out - 2> /dev/null \
                | tar -x -C "$dest" --strip-components=1 2> /dev/null; then
            echo "(the run wrote no output)"
        fi

        # Removing the container removes the TeX Live installed in it.
        "${DOCKER_CMD[@]}" rm "$CID" > /dev/null 2>&1 || true
        CID=""

        # A pass needs the suite's own verdict and its summary: a container that exited
        # cleanly without running the suite has not passed anything.
        if [ "$status" = 0 ] && [ -f "$dest/summary.md" ]; then
            passed=$((passed + 1))
        else
            if [ "$status" = 0 ]; then
                WHY[$name]="the container exited cleanly without writing one"
            fi
            failed="$failed $name"
        fi
    done

    echo
    echo "=== Summary"
    echo
    for name in $ENVS; do
        if [ -f "$BASE_OUT/$name/summary.md" ]; then
            cat "$BASE_OUT/$name/summary.md"
        else
            environment "$name"
            printf '### %s\n\nNo summary: %s.\n\n' "$TITLE" "${WHY[$name]}"
        fi
    done
    echo "$passed of $total environments passed${failed:+; failed:$failed}"
    if [ -n "$OUT" ]; then echo "PDFs and logs: $OUT/<environment>/<engine>/"; fi
    if [ -n "$failed" ]; then exit 1; fi
    exit 0
fi

# ---------------------------------------------------------------------------------------
# --install: inside a container that --env started, install TeX Live before the suite.

if [ -n "$INSTALL" ]; then
    if [ "${RESUME_SUITE_CONTAINER:-}" != 1 ]; then
        echo "--install runs only inside a container that --env started" >&2
        exit 2
    fi
    case "$INSTALL" in
        apt|pacman|ctan) ;;
        *) echo "--install needs apt, pacman or ctan, not $INSTALL" >&2; exit 2 ;;
    esac
    [ -n "$OUT" ] || { echo "--install needs --out, for setup.log" >&2; exit 2; }
    mkdir -p "$OUT"
    echo "Installing TeX Live ($INSTALL). The output is kept in setup.log."
    if ! install_texlive "$INSTALL" 2>&1 | tee "$OUT/setup.log"; then
        echo
        echo "  FAIL  TeX Live could not be installed, so the suite did not run"
        exit "$INSTALL_FAILED"
    fi
    echo
    # A login shell reads /etc/profile, and some distributions put programs on PATH only
    # there: Arch installs Perl programs, biber among them, in /usr/bin/vendor_perl, which
    # /etc/profile.d/perlbin.sh adds. A user's shell has it; this one, started by Docker
    # rather than by a login, does not. Read after the install, because the install is
    # what puts those scripts there. They are written for interactive shells, so they are
    # not held to -e and -u.
    if [ -r /etc/profile ]; then
        set +eu
        . /etc/profile
        set -eu
    fi
fi

# ---------------------------------------------------------------------------------------
# This machine's TeX Live. Inside a container, --env runs exactly this.

for tool in $ENGINES latexmk biber; do
    command -v "$tool" > /dev/null || { echo "$tool not found: no TeX installation to test" >&2; exit 2; }
done

# Which documents have a bibliography, so biber must have run for them. Declared here
# rather than read from the build: a compile that stopped early writes no .bcf, and the
# biber check would then pass by never applying.
BIBER_DOCS=" Resume "

# The packages whose versions are printed for each document, because they are the ones
# that have changed under this template: moderncv, the icon and font packages it loads,
# and biblatex, which has to match biber.
WATCH="moderncv fontawesome5 fontawesome6 sourcesanspro sourcesans biblatex"

# Before compiling, so a run that dies halfway leaves nothing from an earlier one.
if [ -n "$OUT" ]; then
    mkdir -p "$OUT"
    clear_outputs "$OUT"
fi

WORK="$(mktemp -d)"
if [ "$KEEP" -eq 1 ]; then
    trap 'echo "scratch directory kept: $WORK"' EXIT
else
    trap 'rm -rf -- "$WORK"' EXIT
fi

# Only what a user compiles from: the documents, the classes, the bibliography. One
# directory per engine, so no engine reads what another wrote.
for engine in $ENGINES; do
    mkdir -p "$WORK/$engine"
    for doc in "${DOCS[@]}"; do cp "$ROOT/$doc.tex" "$WORK/$engine/"; done
    cp "$ROOT"/*.cls "$ROOT"/*.bib "$WORK/$engine/"
done

PASSED=0
FAILED=0
pass()      { echo "  ok    $1"; PASSED=$((PASSED + 1)); }
fail()      { echo "  FAIL  $1"; FAILED=$((FAILED + 1)); }
unchecked() { echo "  FAIL  $1 -- could not check: $2"; FAILED=$((FAILED + 1)); }
note()      { echo "        $1"; }
indent()    { sed 's/^/          /'; }

# latexmk's option for each engine.
engine_flag() {
    case "$1" in
        pdflatex) echo "-pdf" ;;
        lualatex) echo "-lualatex" ;;
        *) echo "no latexmk option known for engine $1" >&2; exit 2 ;;
    esac
}

# Every error in a log, each with the lines TeX printed under it, which is where an
# undefined command's name appears. -file-line-error writes errors as file:line:
# message; "! " catches any that are not tied to a line.
errors_in() {
    awk '
        function flush() {
            if (msg != "") { print msg; printf "%s", ctx; }
            msg = ""; ctx = ""; n = 0;
        }
        /^[^ ]+:[0-9]+: / || /^! / { flush(); msg = $0; grab = 1; next; }
        grab && ($0 == "" || n == 3) { grab = 0; }
        grab { ctx = ctx "    " $0 "\n"; n++; }
        END { flush(); }
    ' "$1"
}

# Warnings from every package and class but ours, each once, with how often it came up.
other_warnings() {
    grep -E '^(Package|Class) [^ ]+ Warning|^LaTeX( Font)? Warning' "$1" \
        | grep -vE '^Class drevo(resumecv|cover) Warning|(Reference|Citation) .*undefined|There were undefined' \
        | sed -E 's/ on input line [0-9]+\.?$//' \
        | sort | uniq -c | sort -rn || true
}

# "name version (date)" for one package or class, from the line LaTeX writes to the
# log when it loads it. Read from the log rather than asked of kpsewhich, so what is
# printed is what this compile actually used.
loaded() {
    sed -n -E "s/^(Package|Document Class): $1 ([^ ]+)( (v[0-9][^ ]*))?.*/$1 \4 (\2)/p" "$2" \
        | sed 's/  / /' | head -n 1
}

TEXLINES=""
for engine in $ENGINES; do
    line="$("$engine" --version | head -n 1)"
    printf '%-9s %s\n' "$engine:" "$line"
    TEXLINES="${TEXLINES}\`$line\`"$'\n\n'
done
echo "latexmk:  $(latexmk -v 2>/dev/null | grep -m1 -oE 'Version [^ ]+' || echo unknown)"
echo "biber:    $(biber --version 2>/dev/null | head -n 1)"

SUMMARY=""
for engine in $ENGINES; do
    cd "$WORK/$engine"
    for doc in "${DOCS[@]}"; do
        echo
        echo "$doc, $engine"
        log="$doc.log"
        before=$FAILED

        # max_print_line stops TeX from wrapping its log at 79 columns, which would split
        # a long file name from the line number of the error in it.
        status=0
        max_print_line=10000 latexmk "$(engine_flag "$engine")" -f -file-line-error \
            -interaction=nonstopmode "$doc.tex" > "$doc.latexmk.txt" 2>&1 || status=$?

        have_log=0
        complete=0
        why="no log was written"
        if [ -f "$log" ]; then
            have_log=1
            why="the compile stopped before the end"
            # Both engines write this only when they got to the end and shipped pages.
            if grep -q '^Output written on' "$log"; then complete=1; fi
        fi

        versions=""
        if [ "$have_log" -eq 1 ]; then
            for name in $WATCH; do
                v="$(loaded "$name" "$log")"
                if [ -n "$v" ]; then versions="${versions:+$versions, }$v"; fi
            done
        fi
        note "loaded: ${versions:-none of the watched packages}"

        # Any error at all.
        nerr="-"
        if [ "$have_log" -eq 0 ]; then
            unchecked "no errors" "$why"
        else
            nerr="$(grep -cE '^[^ ]+:[0-9]+: |^! ' "$log" || true)"
            if [ "$nerr" -eq 0 ]; then
                pass "no errors"
            else
                fail "no errors -- $nerr in the log:"
                errors_in "$log" > errors.txt
                head -n 60 errors.txt | indent
                if [ "$(wc -l < errors.txt)" -gt 60 ]; then
                    note "  ... the rest is in the log, which --out keeps as $engine/$log"
                fi
                if grep -qE "File \`[^']+' not found" "$log"; then
                    note "  a file is missing from this TeX installation, not from the template"
                fi
            fi
        fi

        # latexmk's own verdict, which also covers a failure outside the engine.
        if [ "$status" -eq 0 ]; then
            pass "latexmk finished cleanly"
        else
            fail "latexmk finished cleanly -- exit status $status"
            sed -n '/^Collected error summary/,$p' "$doc.latexmk.txt" | indent
        fi

        pages="-"
        if [ "$have_log" -eq 1 ]; then
            p="$(sed -n -E 's/^Output written on .*\(([0-9]+) pages?, .*/\1/p' "$log" | tail -n 1)"
            if [ -n "$p" ]; then pages="$p"; fi
        fi
        unit="pages"
        if [ "$pages" = 1 ]; then unit="page"; fi
        if [ -s "$doc.pdf" ]; then
            pass "produces a PDF ($pages $unit)"
        else
            fail "produces a PDF"
        fi

        if [ "$complete" -eq 0 ]; then
            unchecked "no undefined references or citations" "$why"
        elif grep -nE 'undefined (references|citations)|(Reference|Citation) .* undefined' "$log" > undefined.txt; then
            fail "no undefined references or citations:"
            indent < undefined.txt
        else
            pass "no undefined references or citations"
        fi

        case "$BIBER_DOCS" in
            *" $doc "*)
                if [ ! -f "$doc.blg" ]; then
                    unchecked "no biber errors" "biber never ran"
                elif grep -E 'ERROR - ' "$doc.blg" > biber.txt; then
                    fail "no biber errors:"
                    indent < biber.txt
                else
                    pass "no biber errors"
                    if grep -E 'WARN - ' "$doc.blg" > biber.txt; then
                        note "biber warnings, reported and not failed:"
                        indent < biber.txt
                    fi
                fi
                ;;
        esac

        if [ "$complete" -eq 0 ]; then
            unchecked "no warnings from our classes" "$why"
        elif grep -qE '^Class drevo(resumecv|cover) Warning' "$log"; then
            fail "no warnings from our classes:"
            # Each warning with its continuation lines, which LaTeX starts with the class
            # name in parentheses.
            awk '
                /^Class drevo(resumecv|cover) Warning/ { print; more = 1; next; }
                more && /^\(drevo(resumecv|cover)\)/ { print; next; }
                { more = 0; }
            ' "$log" | indent
        else
            pass "no warnings from our classes"
        fi

        nwarn="-"
        if [ "$have_log" -eq 1 ]; then
            others="$(other_warnings "$log")"
            nwarn="$(printf '%s\n' "$others" | grep -c . || true)"
            if [ "$nwarn" -gt 0 ]; then
                note "warnings from other packages, reported and not failed:"
                printf '%s\n' "$others" | indent
            fi
            overfull="$(grep -c '^Overfull \\hbox' "$log" || true)"
            if [ "$overfull" -gt 0 ]; then
                note "$overfull overfull line(s): text running into the margin"
            fi
        fi

        result="pass"
        if [ "$FAILED" -gt "$before" ]; then result="FAIL"; fi
        SUMMARY+="| $doc | $engine | $result | $pages | $nerr | $nwarn | ${versions:--} |"$'\n'
    done
done

# One table per run, printed at the end of an --env run so the environments can be read
# side by side.
SUMMARY_MD="$(
    echo "### ${SUITE_NAME:-This machine}"
    echo
    printf '%s' "$TEXLINES"
    echo "| Document | Engine | Result | Pages | Errors | Other warnings | Loaded |"
    echo "|---|---|---|---|---|---|---|"
    printf '%s' "$SUMMARY"
)"

if [ -n "$OUT" ]; then
    for engine in $ENGINES; do
        mkdir -p "$OUT/$engine"
        for doc in "${DOCS[@]}"; do
            for f in "$doc.pdf" "$doc.log" "$doc.blg" "$doc.latexmk.txt"; do
                if [ -f "$WORK/$engine/$f" ]; then cp "$WORK/$engine/$f" "$OUT/$engine/"; fi
            done
        done
    done
    printf '%s\n\n' "$SUMMARY_MD" > "$OUT/summary.md"
fi

echo
echo "$PASSED passed, $FAILED failed"
[ "$FAILED" -eq 0 ]
