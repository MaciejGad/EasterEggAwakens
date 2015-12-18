Pod::Spec.new do |s|
  s.name         = "EasterEggAwakens"
  s.version      = "0.1"
  s.summary      = "Simple easter egg, for all fans of galaxy far, far away"
  s.homepage     = "https://github.com/MaciejGad/EasterEggAwakens"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Maciej Gad" => "https://github.com/MaciejGad" }
  s.social_media_url   = "https://twitter.com/maciej_gad"
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/MaciejGad/EasterEggAwakens.git", :tag => 'v0.1' }
  s.source_files  =  "Classes/*.{h,m}"
  s.resources = ["Supports/*.m4a", "Supports/*.png"]
  s.requires_arc = true
  s.dependency "AIMNotificationObserver", "~> 0.3"
end