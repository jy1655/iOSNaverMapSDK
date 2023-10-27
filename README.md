# NaverMapSDK


## Studying How to Use NaverMap and GPS in iOS

sudo gem install cocoapods로 해당 프로젝트에 CocoaPods 설치하고 pod init 으로 Podfile을 생성...하려고 했으나 Ruby버전이 2.6.0이라 설치가 안되서 일단 Ruby 버전을 3.2.2로 업데이트</br>
CocoaPods 설치 후 pod init 으로 Profile 생성 프로파일 내부에 pod 'NMapsMap' 추가 뒤 pod install로 의존성 파일들 설치 - 의존성 파일 디렉토리는 .gitignore에 추가함</br>
CocoaPods를 통해 의존성이 설치된 후, .xcworkspace 파일을 사용하여 프로젝트를 열라는데 이러면 원래 폴더의 파일들이 안보이는데?? 일단 .xcworkspace 사용안하고 진행</br>
일정시간이 지나고 다시 여니까 원래 폴더의 파일들이 보임;;<br>
Info.plist에 Privacy - Location Always and When In Use Usage Description 랑 Privacy - Location When In Use Usage Description 추가<br>
일단 뷰에다가 지도만 넣고 실행함<br>
"
Sandbox: rsync.samba(62927) deny(1) file-read-data /Users/jyh/Library/Developer/Xcode/DerivedData/NaverMapSDK-evkfqgmmhjozcuczodmrhfdlyabc/Build/Products/Debug-iphonesimulator/XCFrameworkIntermediates/NMapsGeometry/NMapsGeometry.framework/Info.plist
"<br>
이런 류의 오류가 4개 발생 구글링으로 BuildSettings -> Build Option 의 user script sandboxing을 no로 변경하니 화면에 지도가 뜬다!<br>




