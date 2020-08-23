class PhpBuild < Formula
  desc "Builds PHP so that multiple versions can be used side by side."
  homepage "https://php-build.github.io/"
  # url "https://github.com/php-build/php-build/archive/v0.10.0.tar.gz"
  # sha256 "9f3f842608ee7cb3a6a9fcf592a469151fc1e73068d1c2bd6dbd15cac379857c"
  license "MIT"
  head "https://github.com/php-build/php-build.git"

  bottle :unneeded

  depends_on "autoconf"
  depends_on "pkg-config"
  depends_on "readline"
  depends_on "openssl"
  depends_on "zlib"
  depends_on "bzip2"
  depends_on "curl"
  depends_on "icu4c"
  depends_on "re2c"
  depends_on "bison"
  depends_on "libzip"
  depends_on "mcrypt"
  depends_on "libxml2"
  depends_on "libiconv"
  depends_on "libedit"

  def install
    opt = "#{HOMEBREW_PREFIX}/opt"
    inreplace "share/php-build/default_configure_options" do |s|
      s.gsub! /^(--with-zlib-dir).*$/, %Q(\\1=#{opt}/zlib)
      s.gsub! /^(--with-bz2).*$/, %Q(\\1=#{opt}/bzip2)
      s.gsub! /^(--with-curl).*$/, %Q(\\1=#{opt}/curl)
      s.gsub! /\z/, %Q(--with-iconv=#{opt}/libiconv)
    end

    inreplace "bin/php-build" do |s|
      s.gsub! /^\s*configure_option "--with-([^"]+)"$/, %Q(\\0 "$(brew --prefix \\1)")
      s.gsub! /^(\s*)(\.\/configure.+)$/, %Q(\\1YACC="$(brew --prefix bison)/bin/bison" \\2)
    end

    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  test do
    assert_match "7.0.0", shell_output("#{bin}/php-build --definitions")
  end
end
