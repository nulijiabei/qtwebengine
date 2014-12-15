/****************************************************************************
**
** Copyright (C) 2014 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the QtWebEngine module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia.  For licensing terms and
** conditions see http://qt.digia.com/licensing.  For further information
** use the contact form at http://qt.digia.com/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPLv3 included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 3 requirements
** will be met: https://www.gnu.org/licenses/lgpl.html.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 2.0 or later as published by the Free
** Software Foundation and appearing in the file LICENSE.GPL included in
** the packaging of this file.  Please review the following information to
** ensure the GNU General Public License version 2.0 requirements will be
** met: http://www.gnu.org/licenses/gpl-2.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

#include "browser_context_adapter.h"

#include "browser_context_qt.h"
#include "content_client_qt.h"
#include "web_engine_context.h"
#include "web_engine_visited_links_manager.h"
#include "url_request_context_getter_qt.h"

#include "net/proxy/proxy_service.h"

#include <QCoreApplication>
#include <QDir>
#include <QString>
#include <QStringBuilder>
#include <QStandardPaths>

namespace {
inline QString buildLocationFromStandardPath(const QString &standardPath, const QString &name) {
    QString location = standardPath;
    if (location.isEmpty())
        location = QDir::homePath() % QLatin1String("/.") % QCoreApplication::applicationName();

    location.append(QLatin1String("/QtWebEngine/") % name);
    return location;
}
}

BrowserContextAdapter::BrowserContextAdapter(bool offTheRecord)
    : m_offTheRecord(offTheRecord)
    , m_browserContext(new BrowserContextQt(this))
    , m_httpCacheType(DiskHttpCache)
    , m_persistentCookiesPolicy(AllowPersistentCookies)
    , m_httpCacheMaxSize(0)
{
}

BrowserContextAdapter::BrowserContextAdapter(const QString &storageName)
    : m_name(storageName)
    , m_offTheRecord(false)
    , m_browserContext(new BrowserContextQt(this))
    , m_httpCacheType(DiskHttpCache)
    , m_persistentCookiesPolicy(AllowPersistentCookies)
    , m_httpCacheMaxSize(0)
{
}

BrowserContextAdapter::~BrowserContextAdapter()
{
}

void BrowserContextAdapter::setStorageName(const QString &storageName)
{
    if (storageName == m_name)
        return;
    m_name = storageName;
    if (m_browserContext->url_request_getter_)
        m_browserContext->url_request_getter_->updateStorageSettings();
}

void BrowserContextAdapter::setOffTheRecord(bool offTheRecord)
{
    if (offTheRecord == m_offTheRecord)
        return;
    m_offTheRecord = offTheRecord;
    if (m_browserContext->url_request_getter_)
        m_browserContext->url_request_getter_->updateStorageSettings();
}

BrowserContextQt *BrowserContextAdapter::browserContext()
{
    return m_browserContext.data();
}

WebEngineVisitedLinksManager *BrowserContextAdapter::visitedLinksManager()
{
    if (!m_visitedLinksManager)
        m_visitedLinksManager.reset(new WebEngineVisitedLinksManager(this));
    return m_visitedLinksManager.data();
}

BrowserContextAdapter* BrowserContextAdapter::defaultContext()
{
    return WebEngineContext::current()->defaultBrowserContext();
}

BrowserContextAdapter* BrowserContextAdapter::offTheRecordContext()
{
    return WebEngineContext::current()->offTheRecordBrowserContext();
}

QString BrowserContextAdapter::dataPath() const
{
    if (m_offTheRecord)
        return QString();
    if (!m_dataPath.isEmpty())
        return m_dataPath;
    if (!m_name.isNull())
        return buildLocationFromStandardPath(QStandardPaths::writableLocation(QStandardPaths::DataLocation), m_name);
    return QString();
}

void BrowserContextAdapter::setDataPath(const QString &path)
{
    if (m_dataPath == path)
        return;
    m_dataPath = path;
    if (m_browserContext->url_request_getter_)
        m_browserContext->url_request_getter_->updateStorageSettings();
}

QString BrowserContextAdapter::cachePath() const
{
    if (m_offTheRecord)
        return QString();
    if (!m_cachePath.isEmpty())
        return m_cachePath;
    if (!m_name.isNull())
        return buildLocationFromStandardPath(QStandardPaths::writableLocation(QStandardPaths::CacheLocation), m_name);
    return QString();
}

void BrowserContextAdapter::setCachePath(const QString &path)
{
    if (m_cachePath == path)
        return;
    m_cachePath = path;
    if (m_browserContext->url_request_getter_)
        m_browserContext->url_request_getter_->updateHttpCache();
}

QString BrowserContextAdapter::cookiesPath() const
{
    if (m_offTheRecord)
        return QString();
    QString basePath = dataPath();
    if (!basePath.isEmpty())
        return basePath % QLatin1String("/Coookies");
    return QString();
}

QString BrowserContextAdapter::httpCachePath() const
{
    if (m_offTheRecord)
        return QString();
    QString basePath = cachePath();
    if (!basePath.isEmpty())
        return basePath % QLatin1String("/Cache");
    return QString();
}

QString BrowserContextAdapter::httpUserAgent() const
{
    if (m_httpUserAgent.isNull())
        return QString::fromStdString(ContentClientQt::getUserAgent());
    return m_httpUserAgent;
}

void BrowserContextAdapter::setHttpUserAgent(const QString &userAgent)
{
    if (m_httpUserAgent == userAgent)
        return;
    m_httpUserAgent = userAgent;
    if (m_browserContext->url_request_getter_)
        m_browserContext->url_request_getter_->updateUserAgent();
}

BrowserContextAdapter::HttpCacheType BrowserContextAdapter::httpCacheType() const
{
    if (isOffTheRecord() || httpCachePath().isEmpty())
        return MemoryHttpCache;
    return m_httpCacheType;
}

void BrowserContextAdapter::setHttpCacheType(BrowserContextAdapter::HttpCacheType newhttpCacheType)
{
    BrowserContextAdapter::HttpCacheType oldCacheType = httpCacheType();
    m_httpCacheType = newhttpCacheType;
    if (oldCacheType == httpCacheType())
        return;
    if (m_browserContext->url_request_getter_)
        m_browserContext->url_request_getter_->updateHttpCache();
}

BrowserContextAdapter::PersistentCookiesPolicy BrowserContextAdapter::persistentCookiesPolicy() const
{
    if (isOffTheRecord() || cookiesPath().isEmpty())
        return NoPersistentCookies;
    return m_persistentCookiesPolicy;
}

void BrowserContextAdapter::setPersistentCookiesPolicy(BrowserContextAdapter::PersistentCookiesPolicy newPersistentCookiesPolicy)
{
    BrowserContextAdapter::PersistentCookiesPolicy oldPolicy = persistentCookiesPolicy();
    m_persistentCookiesPolicy = newPersistentCookiesPolicy;
    if (oldPolicy == persistentCookiesPolicy())
        return;
    if (m_browserContext->url_request_getter_)
        m_browserContext->url_request_getter_->updateCookieStore();
}

int BrowserContextAdapter::httpCacheMaxSize() const
{
    return m_httpCacheMaxSize;
}

void BrowserContextAdapter::setHttpCacheMaxSize(int maxSize)
{
    if (m_httpCacheMaxSize == maxSize)
        return;
    m_httpCacheMaxSize = maxSize;
    if (m_browserContext->url_request_getter_)
        m_browserContext->url_request_getter_->updateHttpCache();
}
