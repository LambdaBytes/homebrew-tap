# Homebrew formula for sping. .github/workflows/publish.yml renders it when a
# release is published (LambdaBytes/sping, 1.8.0 and ba8508109bab003b5d5fd3333f188ab4ecb46a2d281ef78767fbea7c4a6a8ad4 are that
# release's) and writes it to the tap, <owner>/homebrew-tap.
#
# The source is the tag's archive. GitHub keeps its contents, not
# necessarily its compressed bytes: if the checksum ever stops matching, the
# formula needs the new one.
class Sping < Formula
  desc "Terminal-native real-time connectivity monitor"
  homepage "https://github.com/LambdaBytes/sping"
  url "https://github.com/LambdaBytes/sping/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "ba8508109bab003b5d5fd3333f188ab4ecb46a2d281ef78767fbea7c4a6a8ad4"
  license "MIT"

  depends_on "rust" => :build

  def install
    # build.rs writes the man page and the shell completions here.
    ENV["SPING_ASSETS_DIR"] = (buildpath/"assets").to_s
    system "cargo", "install", *std_cargo_args
    man1.install "assets/man/sping.1"
    bash_completion.install "assets/completions/sping.bash" => "sping"
    zsh_completion.install "assets/completions/_sping"
    fish_completion.install "assets/completions/sping.fish"
  end

  test do
    assert_match "sping #{version}", shell_output("#{bin}/sping --version")
  end
end
