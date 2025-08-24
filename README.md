## Build:
```
docker build -t apk-builder .
```
### build with other versions:
```
docker build -t apk-builder \
  --build-arg ANDROID_PLATFORM=android-34 \
  --build-arg ANDROID_BUILD_TOOLS=34.0.0 \
  --build-arg ANDROID_CMDTOOLS_VERSION=10406996 .
```

## Usage:
```bash
docker run --rm -v $(pwd)/apk-project:/workspace -w /workspace apk-builder ./gradlew assembleDebug
```
```bash
docker run --rm -v $(pwd)/apk-project:/workspace -w /workspace apk-builder gradle assembleDebug
```
```bash
docker run -u 0:0 --rm -v $(pwd):/workspace -w /workspace apk-builder gradle clean build
```


