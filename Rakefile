APP_NAME = 'Contrast'
TEAM_ID = 'UP9C8XM22A'

desc 'Create a beta build'
task :build do
  # Start with a clean state
  build_dir = 'build'
  system %(rm -rf #{build_dir})

  # Build
  system %(mkdir -p #{build_dir})
  archive_path = "#{build_dir}/#{APP_NAME}.xcarchive"
  system %(xcodebuild archive -scheme "#{APP_NAME}" -archivePath "#{archive_path}")

  # Create export options
  export_options = "#{build_dir}/export-options.plist"
  File.open(export_options, 'w') do |f|
    f.write <<~PLIST
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>teamID</key>
        <string>#{TEAM_ID}</string>
        <key>method</key>
        <string>developer-id</string>
      </dict>
      </plist>
    PLIST
  end

  # Export archive
  system %(xcodebuild -exportArchive -archivePath "#{archive_path}"" -exportOptionsPlist #{export_options} -exportPath #{build_dir})

  # Check code signing
  app = "#{build_dir}/#{APP_NAME}.app"
  result = `codesign -vvvv "#{app}" 2>&1`
  unless result.include?('satisfies its Designated Requirement')
    puts "Failed codesign check:\n\n"
    puts result
    exit
  end

  # Get version
  version = `/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "#{app}/Contents/Info.plist"`.chomp

  # Compress
  zip = "#{APP_NAME.gsub(/\w/, '')}-#{version}.zip"
  system %Q{ditto -c -k --sequesterRsrc --keepParent "#{app}" "#{zip}"}

  # Clean up
  system 'rm -rf build'

  # Done!
  puts "\n\nSuccess! Created #{zip}\n\n"
end

task :default => :build


desc 'Clean up builds'
task :clean do
  system 'rm -rf build *.zip'
end
