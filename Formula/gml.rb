class Gml < Formula
  desc "CLI for provisioning and managing GPU machines across cloud providers"
  homepage "https://salazar-99.github.io/gml/"
  version "0.1.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/Salazar-99/gml/releases/download/v0.1.0/gml-aarch64-apple-darwin.tar.xz"
    sha256 "b940f37dd7fb776a17c210a97f453b196a0cb89282be55b949d55e68a984d6dc"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Salazar-99/gml/releases/download/v0.1.0/gml-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "308443ddecefc6e4950f3d656e0385463dad4768eb6655301b9794c838caed35"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Salazar-99/gml/releases/download/v0.1.0/gml-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a83a8fc3c90175808d8ce6ded079e9458e67c2ce087e106331dce7f6663f00b0"
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
    bin.install "gml" if OS.mac? && Hardware::CPU.arm?
    bin.install "gml" if OS.linux? && Hardware::CPU.arm?
    bin.install "gml" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
