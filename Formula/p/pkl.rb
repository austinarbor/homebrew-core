class Pkl < Formula
  desc "Configuration as code language with rich validation and tooling"
  homepage "https://pkl-lang.org"
  url "https://github.com/apple/pkl/archive/refs/tags/0.25.1.tar.gz"
  sha256 "f60412679a9a8a1740e81cbed89a3ca9ddc9aa2cf0c487ff8a8a9fce70c0bf4a"
  license "Apache-2.0"

  depends_on "openjdk@17" => :build


  def install
    ENV["JAVA_HOME"] = Formula["openjdk@17"].opt_prefix
    task_os = OS.mac? ? "mac" : "linux"
    task_arch = Hardware::CPU.arm? ? "Aarch64" : "Amd64"
    task_name = ":pkl-cli:#{task_os}Executable#{task_arch}"

    system "git", "apply", "patches/graalVm23.patch" if OS.mac? && Hardware::CPU.arm?

    system "./gradlew", task_name
    os = OS.mac? ? "macos" : "linux"
    arch = Hardware::CPU.arm? ? "aarch64" : "amd64"
    bin.install "pkl-cli/build/executable/pkl-#{os}-#{arch}" => "pkl"
  end

  test do
    assert_equal "1", pipe_output("#{bin}/pkl eval -x bar -", "bar = 1")
  end
end
