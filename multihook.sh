#!/bin/sh

# It looks for scripts in the multihook/<hook-name>.d directory and executes them in order,
# passing along stdin. If any script exits with a non-zero status, this script exits.

script_dir=$(dirname "$0")
hook_name=$(basename "$0")

hook_dir="$script_dir/$hook_name.d"

if [ -d "$hook_dir" ]; then
  stdin=$(cat /dev/stdin)

  for hook in "$hook_dir"/*; do
    echo "Running $hook"
    echo "$stdin" | $hook "$@"

    exit_code=$?

    if [ $exit_code != 0 ]; then
      exit $exit_code
    fi
  done
fi

exit 0
