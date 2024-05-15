FROM --platform=$BUILDPLATFORM ubuntu:24.04 AS builder

RUN apt-get update && \
    apt-get install -y build-essential cmake git libssl-dev pkg-config flex bison llvm ca-certificates wget unzip tar --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://npcap.com/dist/npcap-sdk-1.13.zip -O /tmp/sdk.zip && \
    unzip /tmp/sdk.zip -d /tmp/sdk && \
    mkdir -p /tmp/sdk/lib/x64 && \
    cp /tmp/sdk/Lib/x64/*lib /tmp/sdk/lib/x64 && \
    cp /tmp/sdk/Lib/x64/*lib /tmp/sdk/lib

RUN wget https://github.com/upx/upx/releases/download/v4.2.4/upx-4.2.4-amd64_linux.tar.xz -O /tmp/upx.tar.xz && \
    tar -xf /tmp/upx.tar.xz -C /tmp && \
    cp /tmp/upx-4.2.4-amd64_linux/upx /usr/local/bin

RUN rm -rf /usr/lib/x86_64-linux-gnu/pkgconfig/openssl.pc

ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT

WORKDIR /pppwn

COPY .clang-format CMakeLists.txt source-docker-vars.sh /pppwn/
COPY cmake /pppwn/cmake/
COPY include /pppwn/include/
COPY src /pppwn/src/
COPY tests /pppwn/tests/

RUN cd /pppwn && \
    . ./source-docker-vars.sh && \
    cmake -B build -DCMAKE_BUILD_TYPE=MinSizeRel -DZIG_TARGET=${TOOL_TARGET} ${TOOL_CMAKE} && \
    cmake --build build -t pppwn -- -j$(nproc) && \
    ${TOOL_STRIP} build/pppwn* && \
    ${TOOL_UPX} build/pppwn*

FROM scratch as bin
COPY --from=builder /pppwn/build/pppwn* /