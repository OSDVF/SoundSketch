#include "AndroidPathUtil.h"

QString AndroidPathUtil::contentUriToPath(QString fileUrl)
{
    {
#ifdef Q_OS_ANDROID
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
#else
        return fileUrl;
#endif
    }
}
