#!/usr/bin/env bash
# Configure the JDK Flutter actually uses, then fetch app dependencies.
set -euo pipefail
repo_dir="$(cd "$(dirname "$0")/.." && pwd)"
required_java="$(tr -d '\r\n' < "$repo_dir/.java-version")"

is_supported_jdk() {
  local candidate="$1" version compiler
  [[ -x "$candidate/bin/java" && -x "$candidate/bin/javac" ]] || return 1
  version="$("$candidate/bin/java" -version 2>&1)" || return 1
  compiler="$("$candidate/bin/javac" -version 2>&1)" || return 1
  [[ "$version" =~ version\ \"${required_java}[.\"] ]] &&
    [[ "$compiler" =~ javac\ ${required_java}([.+-]|$) ]]
}

jdk_dir=""
if [[ $# -gt 1 ]]; then
  echo "Usage: $0 [JDK_HOME]" >&2
  exit 1
elif [[ $# -eq 1 ]]; then
  if ! is_supported_jdk "$1"; then
    echo "Expected a Java $required_java JDK at: $1" >&2
    exit 1
  fi
  jdk_dir="$1"
else
  candidates=("${JAVA_HOME:-}")
  if [[ "$(uname -s)" == Darwin ]]; then
    candidates+=("$(/usr/libexec/java_home -v "$required_java" 2>/dev/null || true)")
    candidates+=(/opt/homebrew/opt/openjdk@"$required_java"/libexec/openjdk.jdk/Contents/Home
      /usr/local/opt/openjdk@"$required_java"/libexec/openjdk.jdk/Contents/Home)
  fi
  candidates+=(/usr/lib/jvm/* /opt/java/*)
  if command -v java >/dev/null 2>&1; then
    path_home="$(java -XshowSettings:properties -version 2>&1 | sed -n 's/^[[:space:]]*java.home = //p' || true)"
    candidates+=("$path_home")
  fi
  for candidate in "${candidates[@]}"; do
    if is_supported_jdk "$candidate"; then
      jdk_dir="$candidate"
      break
    fi
  done
fi

if [[ -z "$jdk_dir" ]]; then
  cat >&2 <<HELP
Java $required_java JDK not found. Install a Java $required_java JDK (for example Eclipse Temurin).
On macOS with Homebrew: brew install openjdk@$required_java
Then rerun: bash tool/setup.sh
For a custom installation: bash tool/setup.sh "/path/to/jdk-$required_java"
HELP
  exit 1
fi
command -v flutter >/dev/null 2>&1 || { echo 'Flutter is not on PATH. Install Flutter and retry.' >&2; exit 1; }
jdk_dir="$(cd "$jdk_dir" && pwd -P)"
echo "Using Java $required_java: $jdk_dir"
echo "This sets Flutter's machine-wide JDK path, including for IDE launches and other Flutter projects."
flutter config --jdk-dir="$jdk_dir"
(cd "$repo_dir/app" && flutter pub get)
echo 'Setup complete. Run from app/: flutter run --dart-define=API_BASE_URL=https://lmsdemo.testpress.in/'
