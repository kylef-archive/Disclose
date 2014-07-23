Pod::Spec.new do |spec|
  spec.name = 'Disclose'
  spec.version = '0.1.0'
  spec.summary = 'A way to expose and view your managed objects in Core Data.'
  spec.homepage = 'http://cocode.org/'
  spec.authors = { 'Kyle Fuller' => 'inbox@kylefuller.co.uk' }
  spec.source = { :git => 'https://github.com/cocodedev/Disclose', :tag => spec.version }
  spec.requires_arc = true
  spec.frameworks = 'CoreData'
  spec.source_files = 'Disclose/*.{h,m}'
  spec.public_header_files = 'Disclose/{Disclose,CCLEntityListViewController,NSManagedObject+Disclose}.h'
  spec.platform = :ios, '5.0'
end

