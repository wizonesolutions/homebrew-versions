class Physfs1 < Formula
  desc "Library to provide abstract access to various archives"
  homepage "https://icculus.org/physfs/"
  url "https://icculus.org/physfs/downloads/physfs-1.1.1.tar.gz"
  sha256 "994b65066657d49002509c9d84a9b0d2f5c0c1dab0457e9fe21ffa40f2205f63"

  conflicts_with "physfs", :because => "Differing versions of the same formula"

  head "https://hg.icculus.org/icculus/physfs/", :using => :hg

  depends_on "cmake" => :build
  depends_on "readline" => :test

  def install
    mkdir "macbuild" do
      args = std_cmake_args
      args << "-DPHYSFS_BUILD_TEST=TRUE"
      args << "-DPHYSFS_BUILD_WX_TEST=FALSE" unless build.head?
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.txt").write "homebrew"
    system "zip", "test.zip", "test.txt"
    (testpath/"test").write <<-EOS.undent
      addarchive test.zip 1
      cat test.txt
      EOS
    assert_match /Successful\.\nhomebrew/, shell_output("#{bin}/test_physfs < test 2>&1")
  end
end
