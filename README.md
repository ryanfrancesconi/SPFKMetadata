# SPFKMetadata

[![build](https://github.com/ryanfrancesconi/SPFKMetadata/actions/workflows/swift.yml/badge.svg?branch=main)](https://github.com/ryanfrancesconi/SPFKMetadata/actions/workflows/swift.yml)

SPFKMetadata wraps Core Audio, [TagLib](https://github.com/taglib/taglib) (v2.0.2) and [libsndfile](https://github.com/libsndfile/libsndfile) (v1.2.2) metadata C/C++ frameworks for Swift compatibility. It embeds binary xcframeworks for both libraries and uses an intuitive Swift API to access metadata functions from each. The current state of metadata parsing via Swift means that no one single framework is a do-it-all solution, so this framework covers some missing functionalities from AVFoundation such as RIFF Audio Markers, Chaptering, Broadcast Wave and writing tags to file.
