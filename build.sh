rm -rf ~/Library/Developer/Xcode/DerivedData/Sime-*/Build/Products/Release/Sime.app
xcodebuild -project Sime.xcodeproj -scheme Sime -configuration Release build

# [install]
pkill Sime
rm -rf ~/Library/Input\ Methods/Sime.app
mv ~/Library/Developer/Xcode/DerivedData/Sime-*/Build/Products/Release/Sime.app ~/Library/Input\ Methods/Sime.app
