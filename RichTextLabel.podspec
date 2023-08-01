
Pod::Spec.new do |spec|
  spec.name          = 'RichTextLabel'
  spec.version       = '0.1'
  spec.license       = 'MIT'
  spec.homepage      = 'https://github.com/fffonoff/RichTextLabel'
  spec.author        = { 'Roman Trifonov' => 'roman1trifonoff@gmail.com' }
  spec.summary       = 'Subclass of UILabel that simplifies work with rich text'
  spec.source        = { :git => 'https://github.com/fffonoff/RichTextLabel.git' }
  spec.swift_version = '5.7'

  spec.ios.deployment_target = '12.0'

  spec.source_files  = 'Sources/**/*.{swift}'
  spec.exclude_files = 'Sources/DTTextProcessor/NSAttributedString+Helper.swift'
  spec.frameworks    = 'Foundation', 'UIKit'

  spec.default_subspecs = 'WithDTTextProcessor'

  spec.subspec 'Core' do |subspec|
    subspec.source_files = 'Sources/Core/**/*.{swift}'
  end

  spec.subspec 'WithDTTextProcessor' do |subspec|
    subspec.source_files  = 'Sources/DTTextProcessor/**/*.{swift}'
    subspec.exclude_files = 'Sources/DTTextProcessor/NSAttributedString+Helper.swift'
    subspec.dependency 'RichTextLabel/Core'
    subspec.dependency 'DTCoreText', '~> 1.6'
  end

end
