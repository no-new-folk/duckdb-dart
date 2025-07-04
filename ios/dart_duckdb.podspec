#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint duckdb.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  # ... (name, version, summary などは変更なし) ...
  s.name             = 'dart_duckdb'
  s.version          = File.read(File.join('..', 'pubspec.yaml')).match(/version:\s+(\d+\.\d+\.\d+)/)[1]
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'https://tigereye.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Tigereye' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'Flutter'

  s.platform = :ios, '11.0'
  s.swift_version = '5.0'

  # --- ここからが重要な変更点 ---

  # 1. vendored_frameworks は削除するかコメントアウトします
  # s.vendored_frameworks = 'Libraries/release/duckdb.framework'

  # 2. pod_target_xcconfig を使ってリンカフラグを追加します
  s.pod_target_xcconfig = { 
    'DEFINES_MODULE' => 'YES',
    # OTHER_LDFLAGS (その他のリンカフラグ) を設定
    # -F はフレームワークの検索パスを追加するフラグ
    # -framework はリンクするフレームワーク名を指定するフラグ
    'OTHER_LDFLAGS' => '-F "${PODS_ROOT}/dart_duckdb/Libraries/release" -framework "duckdb"'
  }

  # --- ここまでが重要な変更点 ---

  s.script_phases = [
    {
      :name => 'Download DuckDB Framework',
      :script => <<-SCRIPT
        set -e
        # 実行時のカレントディレクトリは ${PODS_ROOT}/dart_duckdb になります
        FRAMEWORK_DIR="Libraries/release/duckdb.framework"
        if [ ! -d "$FRAMEWORK_DIR" ]; then
          echo "Downloading DuckDB library..."
          mkdir -p Libraries/release
          curl -L -o duckdb-framework-ios.zip "https://github.com/TigerEyeLabs/duckdb-dart/releases/download/v1.2.0/duckdb-framework-ios.zip"
          unzip -o duckdb-framework-ios.zip -d Libraries/release/
          rm duckdb-framework-ios.zip
        else
          echo "DuckDB library already exists."
        fi
      SCRIPT
    }
  ]
end
