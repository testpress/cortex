"""Regression checks for first-run setup and pre-Gradle Java validation."""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

REPO = Path(__file__).resolve().parents[1]


class AndroidEnvironmentTest(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="cortex-jdk-")
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name).resolve()
        (self.root / "tool").mkdir()
        (self.root / "app/android").mkdir(parents=True)
        (self.root / ".java-version").write_text("21\n")
        for relative in ("tool/setup.sh", "app/android/gradlew"):
            shutil.copyfile(REPO / relative, self.root / relative)
        self.log = self.root / "calls"
        self.bin = self.root / "bin"
        self.bin.mkdir()
        self.executable(self.bin / "flutter", '#!/bin/bash\nprintf "%s\\n" "$*" >> "$CALL_LOG"\n')
        self.env = dict(os.environ, CALL_LOG=str(self.log), JAVA_HOME="",
                        PATH=f"{self.bin}:/usr/bin:/bin", JAVA_OPTS="", GRADLE_OPTS="")

    def executable(self, path, text):
        path.write_text(text)
        path.chmod(0o755)

    def jdk(self, version, compiler="21"):
        home = self.root / f"JDK {version}"
        (home / "bin").mkdir(parents=True)
        self.executable(home / "bin/java", f'''#!/bin/bash
if [[ "$1" == -version ]]; then
  echo 'openjdk version "{version}"' >&2
else
  printf '%s\\n' "$@" >> "$CALL_LOG"
fi
''')
        self.executable(home / "bin/javac", f'#!/bin/bash\necho "javac {compiler}.0.1"\n')
        return home

    def run_script(self, relative, *args, **updates):
        return subprocess.run(["/bin/bash", str(self.root / relative), *map(str, args)],
                              env=dict(self.env, **updates), cwd=self.root / "app",
                              text=True, capture_output=True)

    def test_wrapper_rejects_unsupported_and_unreadable_versions(self):
        for version in ("17.0.1", "25.0.3", "26.0.2", "unreadable"):
            with self.subTest(version=version):
                result = self.run_script("app/android/gradlew", "--version",
                                         JAVA_HOME=str(self.jdk(version)))
                self.assertNotEqual(result.returncode, 0)
                self.assertIn("require Java 21", result.stdout)
                self.assertIn("bash tool/setup.sh", result.stdout)
                self.assertFalse(self.log.exists(), "Gradle must not start")

    def test_wrapper_forwards_arguments_with_supported_java(self):
        result = self.run_script("app/android/gradlew", "--version", "argument with spaces",
                                 JAVA_HOME=str(self.jdk("21.0.11")))
        self.assertEqual(result.returncode, 0, result.stderr)
        args = self.log.read_text().splitlines()
        self.assertIn("org.gradle.wrapper.GradleWrapperMain", args)
        self.assertEqual(args[-2:], ["--version", "argument with spaces"])

    def test_wrapper_checks_java_on_path(self):
        home = self.jdk("26.0.2")
        result = self.run_script("app/android/gradlew", PATH=f"{home / 'bin'}:{self.env['PATH']}")
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("selected 26.0.2", result.stdout)

    def test_setup_discovers_supported_java_home(self):
        home = self.jdk("21.0.11")
        result = self.run_script("tool/setup.sh", JAVA_HOME=str(home))
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("machine-wide", result.stdout)
        self.assertEqual(self.log.read_text().splitlines(),
                         [f"config --jdk-dir={home}", "pub get"])

    def test_setup_accepts_explicit_home(self):
        home = self.jdk("21.0.11")
        result = self.run_script("tool/setup.sh", home, JAVA_HOME="/invalid")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn(f"config --jdk-dir={home}", self.log.read_text())

    def test_setup_rejects_unsupported_or_incomplete_explicit_jdk(self):
        for version, compiler in (("26.0.2", "26"), ("21.0.11", "17")):
            with self.subTest(version=version):
                result = self.run_script("tool/setup.sh", self.jdk(version, compiler))
                self.assertNotEqual(result.returncode, 0)
                self.assertIn("Expected a Java 21 JDK", result.stderr)
                self.assertFalse(self.log.exists())

    def test_setup_handles_broken_java_on_path(self):
        (self.root / ".java-version").write_text("99\n")
        self.executable(self.bin / "java", '#!/bin/bash\necho "No JVM found" >&2\nexit 1\n')
        result = self.run_script("tool/setup.sh")
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("Java 99 JDK not found", result.stderr)
        self.assertFalse(self.log.exists())

    def test_setup_reports_missing_jdk_without_configuring_flutter(self):
        # An unavailable major prevents discovery of a real host JDK in this fixture.
        (self.root / ".java-version").write_text("99\n")
        result = self.run_script("tool/setup.sh", JAVA_HOME="/invalid")
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("Java 99 JDK not found", result.stderr)
        self.assertIn("brew install openjdk@99", result.stderr)
        self.assertFalse(self.log.exists())


if __name__ == "__main__":
    unittest.main()
