TEAM_ID = 'UP9C8XM22A'
APP_NAME = 'Contrast'
SCHEME_NAME = APP_NAME

desc 'Create a beta build'
task :build do
  # Ensure clean git state
  unless system 'git diff-index --quiet HEAD --'
    abort 'Failed. You have uncommitted changes.'
  end

  # Start with a clean state
  build_dir = 'build'
  system %(rm -rf #{build_dir})

  # Build
  system %(mkdir -p #{build_dir})
  archive_path = "#{build_dir}/#{APP_NAME}.xcarchive"
  system %(xcodebuild archive -scheme "#{SCHEME_NAME}" -archivePath "#{archive_path}")

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
  short_version = `/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "#{app}/Contents/Info.plist"`.chomp

  # Compress
  zip = "#{APP_NAME.gsub(/\w/, '')}-#{version}.zip"
  system %Q{ditto -c -k --sequesterRsrc --keepParent "#{app}" "#{zip}"}

  # Clean up
  system 'rm -rf build'

  # Tag
  latest_tag = `git describe --tags --abbrev=0`.chomp
  tag_name = "v#{short_version}-#{version}"
  system %(git tag #{tag_name})

  # Done!
  puts "\n\nSuccess! Created #{zip}. Created git tag '#{tag_name}'.\n\n"

  recent_changes(latest_tag)
end

task :default => :build

desc 'Print changes since latest tag'
task :log do
  recent_changes
end

desc 'Clean up builds'
task :clean do
  system 'rm -rf build *.zip'
end

private

def recent_changes(latest_tag = `git describe --tags --abbrev=0`.chomp)
  # Find latest tag
  scope = if latest_tag
    puts "Changes since #{latest_tag}:\n\n"
    "#{latest_tag}..HEAD"
  else
    puts "No tags yet. All changes since the project started:\n\n"
    ''
  end

  # Print changes since last tag
  log = `git log #{scope} --pretty=format:'%s' --abbrev-commit`.chomp
  puts log.gsub(/^([\w])/, '• \1') + "\n\n"
end
