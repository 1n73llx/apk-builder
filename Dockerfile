# Ubuntu base
FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

# Versions (قابل تغییر هنگام build)
ARG GRADLE_VERSION=6.7
ARG ANDROID_CMDTOOLS_VERSION=10406996
ARG ANDROID_PLATFORM=android-33
ARG ANDROID_BUILD_TOOLS=33.0.2

# Env
ENV LANG=C.UTF-8
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV GRADLE_HOME=/opt/gradle
ENV PATH=${PATH}:${GRADLE_HOME}/bin:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools

# Packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    openjdk-11-jdk curl unzip wget git zip ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# Gradle 6.7
RUN mkdir -p /opt \
 && curl -fsSL -o /tmp/gradle.zip https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip \
 && curl -fsSL -o /tmp/gradle.zip.sha256 https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip.sha256 \
 && echo "$(cat /tmp/gradle.zip.sha256)  /tmp/gradle.zip" | sha256sum -c - \
 && unzip -q /tmp/gradle.zip -d /opt \
 && ln -s /opt/gradle-${GRADLE_VERSION} ${GRADLE_HOME} \
 && rm -f /tmp/gradle.zip /tmp/gradle.zip.sha256

# Android SDK cmdline-tools
RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools \
 && cd /tmp \
 && curl -fsSL -o cmdline-tools.zip https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_CMDTOOLS_VERSION}_latest.zip \
 && unzip -q cmdline-tools.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools \
 && mv ${ANDROID_SDK_ROOT}/cmdline-tools/cmdline-tools ${ANDROID_SDK_ROOT}/cmdline-tools/latest \
 && rm -f cmdline-tools.zip

# نصب پکیج‌های لازم SDK و قبول لایسنس‌ها
RUN yes | sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --licenses \
 && yes | sdkmanager --sdk_root=${ANDROID_SDK_ROOT} \
    "platform-tools" \
    "platforms;${ANDROID_PLATFORM}" \
    "build-tools;${ANDROID_BUILD_TOOLS}"

# کاربر غیر روت
RUN useradd -m -s /bin/bash builder \
 && mkdir -p /workspace \
 && chown -R builder:builder /workspace ${ANDROID_SDK_ROOT}
WORKDIR /workspace
USER builder

# پیش‌فرض: شل
CMD ["bash"]
