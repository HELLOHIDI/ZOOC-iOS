#  Configuration 정보

## Configuration은 총 4개의 파일이 존재한다.
- Config Docs
- Debug-GoogleService-Info.plist
- Release-GoogleService-Info.plist
- Debug.xcconfig
- Release.xcconfig

### Config Docs
- 현재 보고 있는 파일

### GoogleService-Info.plist
- Firebase를 사용하기 위해 필요한 파일
- Debug용과 Release용이 있다.
- Firebase는 파일명이 GoogleService-Info.plist 을 따라가기에 
  Target > Build phases > Firebase plist에 Debug/Release여부에 따라 
  파일명을 Release-GoogleService-Info -> GoogleService-Info.plist 로 바꿔주는 작업을 거친다.

### Debug.xcconfig, Release.xcconfig
- Debug / Release 빌드를 나누기 위해 존재하는 파일

### 각 파일이 담고있는 Key-Value
- App Name
- Base URL
- Kakao App Key


