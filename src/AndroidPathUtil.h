#ifdef Q_OS_ANDROID
#include <QAndroidJniObject>
#include <QtAndroid>
#endif

#ifndef ANDROIDSELECTOR_H
#define ANDROIDSELECTOR_H
#include <QtQml>

class AndroidPathUtil : public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    Q_INVOKABLE QString contentUriToPath(QString fileUrl);

    explicit AndroidPathUtil() {}
};

#endif // ANDROIDSELECTOR_H
