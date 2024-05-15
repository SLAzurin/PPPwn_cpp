#!/bin/bash
export TOOL_SUFFIX='musl'
export TOOL_UPX='upx --lzma'
export TOOL_STRIP="llvm-strip"
export TOOL_CMAKE=''
case $TARGETOS in
    linux)
        export TOOL_CMAKE='-DUSE_SYSTEM_PCAP=OFF'
        export TOOL_OS='linux'
        case $TARGETARCH in
            amd64)
                export TOOL_ARCH='x86_64'
                ;;
            arm64)
                export TOOL_ARCH='aarch64'
                ;;
            arm)
                export TOOL_ARCH='arm'
                export TOOL_SUFFIX='musleabi'
                case $TARGETVARIANT in
                    v7)
                        export TOOL_SUFFIX='musleabi'
                        export TOOL_CMAKE="-DUSE_SYSTEM_PCAP=OFF -DZIG_COMPILE_OPTION='-mcpu=cortex_a7'"
                        ;;
                    v6)
                        export TOOL_SUFFIX='musleabi'
                        export TOOL_CMAKE="-DUSE_SYSTEM_PCAP=OFF -DZIG_COMPILE_OPTION='-mcpu=arm1176jzf_s'"
                        ;;
                esac
                ;;
            mipsle)
                export TOOL_ARCH='mipsel'
                export TOOL_CMAKE="-DUSE_SYSTEM_PCAP=OFF -DZIG_COMPILE_OPTION='-msoft-float'"
                ;;
        esac
        ;;
    darwin)
        export TOOL_OS='macos'
        export TOOL_SUFFIX='none'
        export TOOL_UPX='ls'
        export TOOL_STRIP='strip'
        case $TARGETARCH in
            amd64)
                export TOOL_ARCH='x86_64'
                ;;
            arm64)
                export TOOL_ARCH='aarch64'
                ;;
        esac
        ;;
    windows)
        export TOOL_ARCH='x86_64'
        export TOOL_OS='windows'
        export TOOL_SUFFIX='gnu'
        export TOOL_CMAKE='-DUSE_SYSTEM_PCAP=OFF -DPacket_ROOT=/tmp/sdk'
        export TOOL_EXT='.exe'
        ;;
esac

export TOOL_TARGET="${TOOL_ARCH}-${TOOL_OS}-${TOOL_SUFFIX}"