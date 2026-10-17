
#!/usr/bin/env bash
#
# Clean Jekyll cache, run Jekyll serve, and launch the site.

set -e

prod=false
command=(bundle exec jekyll s -l)
host="127.0.0.1"

help() {
  echo "Usage:"
  echo
  echo "  bash tools/clean_run.sh [options]"
  echo
  echo "Options:"
  echo "  -H, --host HOST   Host to bind to."
  echo "  -p, --production  Run Jekyll in production mode."
  echo "  -h, --help        Print this help information."
}

while (($#)); do
  case "$1" in
    -H|--host)
      if [[ -z "${2:-}" ]]; then
        echo "Error: --host requires a hostname or IP address."
        exit 1
      fi
      host="$2"
      shift 2
      ;;
    -p|--production)
      prod=true
      shift
      ;;
    -h|--help)
      help
      exit 0
      ;;
    *)
      echo "Unknown option: '$1'"
      help
      exit 1
      ;;
  esac
done

# Always run from the repository root.
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.."

# Remove Jekyll cache if it exists, then recreate it.
echo
echo "> Removing .jekyll-cache if it exists"

if [[ -e .jekyll-cache || -L .jekyll-cache ]]; then
  rm -rf -- .jekyll-cache
fi

mkdir -p .jekyll-cache

# Clean generated site files.
echo
echo "> bundle exec jekyll clean"
bundle exec jekyll clean

# Configure the server command.
command+=(-H "$host" --disable-disk-cache)

if [[ "$prod" == true ]]; then
  export JEKYLL_ENV=production
fi

# Preserve Docker polling support.
if [[ -e /proc/1/cgroup ]] && grep -q docker /proc/1/cgroup; then
  command+=(--force_polling)
fi

# Start Jekyll.
echo
printf '> '
printf '%q ' "${command[@]}"
echo
echo

"${command[@]}"
