# SPFKMetadata

SPFKMetadata wraps Core Audio, [TagLib](https://github.com/taglib/taglib) (v2.0.2) and [libsndfile](https://github.com/libsndfile/libsndfile) (v1.2.2) metadata C/C++ frameworks for Swift compatibility. It embeds binary xcframeworks for both libraries and uses an intuitive Swift API to access metadata functions from each. The current state of metadata parsing means that no one single framework is a do-it-all solution, so this framework covers the topics that I need myself.
