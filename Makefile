.PHONY: all build clean

release:
	xcodebuild archive \
        -scheme pbadd \
        -project ./pbadd.xcodeproj \
        -archivePath Release/App.xcarchive

all: release

clean:
	rm -r ./Release
