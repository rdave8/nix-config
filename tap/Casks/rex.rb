cask "rex" do
  version :latest
  sha256 :no_check

  url "https://blob.superlogical.com/download/rex-app/preview/latest.dmg"
  name "Rex"
  desc "Terminal and multiplexer by Superlogical"
  homepage "https://www.superlogical.com/"

  auto_updates true
  depends_on macos: :sequoia

  app "Rex.app"
end
