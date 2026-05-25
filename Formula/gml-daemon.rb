class GmlDaemon < Formula
  desc "Background daemon for the gml GPU machine management CLI"
  homepage "https://salazar-99.github.io/gml/"
  version "0.1.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/Salazar-99/gml/releases/download/v0.1.0/gml-daemon-aarch64-apple-darwin.tar.xz"
    sha256 "7a76ab40d5ea97334d606e82af7fdfc0c32288bb757464af8badb5dd02db56e3"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Salazar-99/gml/releases/download/v0.1.0/gml-daemon-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5318b21b32c6e11b20f59a7104aad7b2086bcace2c1893154c416c7eb03643e4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Salazar-99/gml/releases/download/v0.1.0/gml-daemon-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "08f5686d04e1b8f290d38e09e76bb1f2396274f70c883007bd957ced906612a3"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "gmld" if OS.mac? && Hardware::CPU.arm?
    bin.install "gmld" if OS.linux? && Hardware::CPU.arm?
    bin.install "gmld" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
