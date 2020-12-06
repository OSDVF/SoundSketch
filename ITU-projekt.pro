QT += quick multimedia widgets

CONFIG += c++11

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        src/audiofile.cpp \
        src/audiolevel.cpp \
        src/main.cpp \
        src/recorder.cpp \
        src/waveformplot.cpp \
        src/recorder.cpp

RESOURCES += \
        src/qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    src/WaveformGenerator.h \
    src/audiofile.h \
    src/audiolvel.h \
    src/recorder.h \
    src/waveformplot.h \
    src/recorder.h

INCLUDEPATH += $$PWD/include
DEPENDPATH += $$PWD/include

win32:CONFIG(release, debug|release): LIBS += -L$$PWD/lib/ -lffmpeg-cpp
else:win32:CONFIG(debug, debug|release): LIBS += -L$$PWD/lib/ -lffmpeg-cppd
else:unix: LIBS += -L$$PWD/lib/ -lffmpeg-cpp

DISTFILES += \
    images/backward.jpg \
    images/cut.jpg \
    images/del.jpg \
    images/forward.jpg \
    images/play.jpg \
    images/record.jpg

FORMS +=
