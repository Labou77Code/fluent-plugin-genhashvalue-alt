# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-genhashvalue-alt"
  spec.version       = "1.1.0"
  spec.authors       = ["Labou77Code"]

  spec.summary       = %q{generate hash value}
  spec.description   = %q{generate hash(md5/sha1/sha256/sha512) value}
  spec.homepage      = "https://github.com/Labou77Code/fluent-plugin-genhashvalue-alt"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features|\.vscode)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.1"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_runtime_dependency "fluentd", [">= 0.14.0", "< 2"]
  spec.add_runtime_dependency "base91", '>= 0.0.1'
end
