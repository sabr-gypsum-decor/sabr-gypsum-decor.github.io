#!/usr/bin/env bash
#
# Run jekyll serve and then launch the site

prod=false
incremental=true  # Standart holatda tezkor inkremental rejim yoqiladi
clean_cache=false # Har safar tozalash o'chiriladi
command="bundle exec jekyll s -l"
host="127.0.0.1"

help() {
  echo "Usage:"
  echo
  echo "    bash /path/to/run [options]"
  echo
  echo "Options:"
  echo "      -H, --host [HOST]     Host to bind to."
  echo "      -p, --production      Run Jekyll in 'production' mode."
  echo "      -i, --incremental     Enable incremental rebuild (default)."
  echo "      -c, --clean           Run jekyll clean before serving."
  echo "      -h, --help            Print this help information."
}

while (($#)); do
  opt="$1"
  case $opt in
  -H | --host)
    host="$2"
    shift 2
    ;;
  -p | --production)
    prod=true
    incremental=false # Productionda clean/full build yaxshiroq
    shift
    ;;
  -i | --incremental)
    incremental=true
    shift
    ;;
  -c | --clean)
    clean_cache=true
    shift
    ;;
  -h | --help)
    help
    exit 0
    ;;
  *)
    echo -e "> Unknown option: '$opt'\n"
    help
    exit 1
    ;;
  esac
done

command="$command -H $host"

# Agar incremental yoqilgan bo'lsa, bayroqni qo'shamiz
if $incremental; then
  command="$command --incremental"
fi

if $prod; then
  command="JEKYLL_ENV=production $command"
fi

if [ -e /proc/1/cgroup ] && grep -q docker /proc/1/cgroup; then
  command="$command --force_polling"
fi

# Faqat talab qilinsa yoki -c berilsagina clean qiladi
if $clean_cache; then
  echo -e "\n> bundle exec jekyll clean"
  bundle exec jekyll clean
fi

# Keyin ishga tushirish
echo -e "\n> $command\n"
eval "$command"