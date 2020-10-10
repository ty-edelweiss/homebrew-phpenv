class Phpenv < Formula
  desc "Simple PHP version management"
  homepage "https://github.com/phpenv/phpenv"
  # url "https://github.com/phpenv/phpenv/archive/master.tar.gz"
  # sha256 "b2b8671006ed27609cc389fedc5e6096e767b60e8fb2712d24a1fa357ef32a87"
  license "MIT"
  head "https://github.com/ty-edelweiss/phpenv.git"

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
    if build.head?
      # Record exact git revision for `phpbenv --version` output
      git_revision = `git rev-parse --short HEAD`.chomp
      inreplace "libexec/phpenv---version", /^(version=)"([^"]+)"/,
                                            %Q(\\1"\\2-g#{git_revision}")
    end

    opt = "#{HOMEBREW_PREFIX}/opt"
    inreplace "plugins/php-build/default_configure_options" do |s|
      s.gsub! /^(--with-zlib-dir).*$/, %Q(\\1=#{opt}/zlib)
      s.gsub! /^(--with-bz2).*$/, %Q(\\1=#{opt}/bzip2)
      s.gsub! /^(--with-curl).*$/, %Q(\\1=#{opt}/curl)
      s.gsub! /\z/, %Q(--with-iconv=#{opt}/libiconv)
    end

    inreplace "plugins/php-build/bin/php-build" do |s|
      s.gsub! /^\s*configure_option "--with-([^"]+)"$/, %Q(\\0 "$(brew --prefix \\1)")
      s.gsub! /^(\s*)(\.\/configure.+)$/, %Q(\\1YACC="$(brew --prefix bison)/bin/bison" \\2)
    end

    prefix.install ["bin", "completions", "libexec"]
  end

  test do
    shell_output("eval \"$(#{bin}/phpenv init -)\" && phpenv versions")
  end
end
