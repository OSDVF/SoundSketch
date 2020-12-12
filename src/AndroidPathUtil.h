#ifndef ANDROIDSELECTOR_H
#define ANDROIDSELECTOR_H
#include <QtQml>
#include <QAndroidJniObject>
#include <QtAndroid>

class AndroidPathUtil : public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    Q_INVOKABLE QString contentUriToPath(QString fileUrl)
    {
        QAndroidJniObject uri = QAndroidJniObject::callStaticObjectMethod(
            "android/net/Uri", "parse", "(Ljava/lang/String;)Landroid/net/Uri;",
            QAndroidJniObject::fromString(fileUrl).object<jstring>());
        QString filename =
            QAndroidJniObject::callStaticObjectMethod(
                "itu/project/PathUtil", "getRealPathFromURI",
                "(Landroid/net/Uri;Landroid/content/Context;)Ljava/lang/String;",
                uri.object(), QtAndroid::androidContext().object())
                .toString();
        return filename;
    }

    explicit AndroidPathUtil() {}
};

#endif // ANDROIDSELECTOR_H
