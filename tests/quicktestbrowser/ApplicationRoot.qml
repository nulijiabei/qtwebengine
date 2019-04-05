/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the QtWebEngine module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:GPL-EXCEPT$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3 as published by the Free Software
** Foundation with exceptions as appearing in the file LICENSE.GPL3-EXCEPT
** included in the packaging of this file. Please review the following
** information to ensure the GNU General Public License requirements will
** be met: https://www.gnu.org/licenses/gpl-3.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.1
import QtWebEngine 1.1

QtObject {
    id: root

    property bool thirdPartyCookiesEnabled: true

    property QtObject testProfile: WebEngineProfile {
        storageName: "Test"
    }

    property QtObject otrProfile: WebEngineProfile {
        offTheRecord: true
    }

    property Component browserWindowComponent: BrowserWindow {
        applicationRoot: root
        onClosing: destroy()
    }
    property Component browserDialogComponent: BrowserDialog {
        onClosing: destroy()
    }
    function createWindow(profile) {
        var newWindow = browserWindowComponent.createObject(root)
        newWindow.currentWebView.profile = profile
        profile.downloadRequested.connect(newWindow.onDownloadRequested)
        profile.presentNotification.connect(newWindow.onPresentNotification)
        return newWindow
    }
    function createDialog(profile) {
        var newDialog = browserDialogComponent.createObject(root)
        newDialog.currentWebView.profile = profile
        return newDialog
    }
    function load(url) {
        var browserWindow = createWindow(testProfile)
        browserWindow.currentWebView.url = url
    }
}
