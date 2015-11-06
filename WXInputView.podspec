

Pod::Spec.new do |s|



  s.name         = 'WXInputView'
  s.version      = '1.0.2'
  s.summary      = 'this is weixin inputView '
  s.description  = <<-DESC
                   A longer description of WXInputView in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC

  s.homepage     = 'https://github.com/wenboma/WXInputView'

  s.license      = 'MIT'

  s.author             = { '马文铂' => 'luoyi@uoko.com' }

#  s.compiler_flags = '-fmodules'
  s.platform     = :ios, '5.0'


  s.source       = { :git => 'https://github.com/wenboma/WXInputView.git', :tag => '1.0.2' }


  s.source_files  = "WXInputView", "WXInputView/*"
  s.dependency 'ReactiveCocoa'


  s.frameworks = 'UIKit', 'Foundation'

  s.compiler_flags = '-fmodules'
  s.requires_arc = true
  # cs.dependency 'ReactiveCocoa/RACEXTScope'

#  s.subspec 'ReactiveCocoa' do |cs|
#    cs.dependency 'ReactiveCocoa/ReactiveCocoa'
#    cs.dependency 'ReactiveCocoa/RACEXTScope'
#  end

end
