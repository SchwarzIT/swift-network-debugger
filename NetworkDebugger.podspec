Pod::Spec.new do |s|
    s.name = "NetworkDebugger"
    s.version = "1.0.2"
    s.summary = "A Swift package designed to view your App's networking activity with minimal setup."

    s.homepage = "https://github.com/schwarzit/swift-network-debugger"
    s.license = {
        :type => "Apache",
        :file => "LICENSE"
    }
    s.author = {
        "Asmeili" => "michael.artes@mail.schwarz"
    }
    s.source = {
        :git => "https://github.com/schwarzit/swift-network-debugger.git",
        :tag => s.version.to_s
    }

    s.ios.deployment_target = "14.0"
    s.swift_version = "5.0"

    s.source_files = "Sources/NetworkDebugger/**/*.{swift}"
end
