class Libkrun < Formula
  desc "Dynamic library providing KVM-based process isolation capabilities"
  homepage "https://github.com/containers/libkrun"
  url "https://github.com/containers/libkrun/releases/download/v0.1.7/v0.1.7-with_prebuilts.tar.gz"
  sha256 "243a7e60dbe3c07eb6b0d74b0853806d2c27e987de225b7fd941a6841613c31f"
  license "Apache-2.0"

  bottle do
    root_url "https://dl.bintray.com/slp/bottles-krun"
    sha256 cellar: :any, arm64_big_sur: "fb6400a6be6aa7da3f96873f5a5e895dfb9e8f05ffb484dbb4524ea9cc6936ae"
  end

  depends_on "rust" => :build
  depends_on "dtc"
  depends_on "libkrunfw"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libkrun.h>
      int main()
      {
         int c = krun_create_ctx();
         return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lkrun", "-o", "test"
    system "./test"
  end
end
