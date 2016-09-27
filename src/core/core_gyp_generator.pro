# This is a dummy .pro file used to extract some aspects of the used configuration and feed them to gyp
# We want the gyp generation step to happen after all the other config steps. For that we need to prepend
# our gyp_generator.prf feature to the CONFIG variable since it is processed backwards
CONFIG = gyp_generator $$CONFIG
GYPFILE = $$OUT_PWD/core_generated.gyp
GYPINCLUDES += $$PWD/qtwebengine.gypi
GYPSRCDIR = $$PWD

TEMPLATE = lib

include(core_common.pri)

# Defining keywords such as 'signal' clashes with the chromium code base.
DEFINES += QT_NO_KEYWORDS \
           QT_USE_QSTRINGBUILDER \
           Q_FORWARD_DECLARE_OBJC_CLASS=QT_FORWARD_DECLARE_CLASS \
           QTWEBENGINECORE_VERSION_STR=\\\"$$MODULE_VERSION\\\" \
           BUILDING_CHROMIUM

# Ensure that response files, generated by qtbase/mkspecs/features/moc.prf, are found by moc.
MOC_DIR = $$OUT_PWD/$$getConfigDir()/.moc
RCC_DIR = $$OUT_PWD/$$getConfigDir()/.rcc

# Assume that we want mobile touch and low-end hardware behaviors
# whenever we are cross compiling.
cross_compile: DEFINES += QTWEBENGINE_EMBEDDED_SWITCHES

contains(QT_CONFIG, egl): CONFIG += egl
else: DEFINES += QT_NO_EGL

RESOURCES += devtools.qrc

INCLUDEPATH += $$PWD $$PWD/api

SOURCES = \
        access_token_store_qt.cpp \
        authentication_dialog_controller.cpp \
        browser_accessibility_manager_qt.cpp \
        browser_accessibility_qt.cpp \
        browser_context_adapter.cpp \
        browser_context_qt.cpp \
        browser_message_filter_qt.cpp \
        certificate_error_controller.cpp \
        chromium_gpu_helper.cpp \
        chromium_overrides.cpp \
        clipboard_qt.cpp \
        color_chooser_qt.cpp \
        color_chooser_controller.cpp \
        common/qt_ipc_logging.cpp \
        common/qt_messages.cpp \
        common/user_script_data.cpp \
        content_client_qt.cpp \
        content_browser_client_qt.cpp \
        content_main_delegate_qt.cpp \
        cookie_monster_delegate_qt.cpp \
        custom_protocol_handler.cpp \
        delegated_frame_node.cpp \
        desktop_screen_qt.cpp \
        dev_tools_http_handler_delegate_qt.cpp \
        download_manager_delegate_qt.cpp \
        favicon_manager.cpp \
        file_picker_controller.cpp \
        gl_context_qt.cpp \
        gl_surface_qt.cpp \
        javascript_dialog_controller.cpp \
        javascript_dialog_manager_qt.cpp \
        media_capture_devices_dispatcher.cpp \
        native_web_keyboard_event_qt.cpp \
        network_delegate_qt.cpp \
        ozone_platform_eglfs.cpp \
        permission_manager_qt.cpp \
        process_main.cpp \
        proxy_config_service_qt.cpp \
        qrc_protocol_handler_qt.cpp \
        render_view_observer_host_qt.cpp \
        render_widget_host_view_qt.cpp \
        renderer/content_renderer_client_qt.cpp \
        renderer/pepper/pepper_flash_browser_host_qt.cpp \
        renderer/pepper/pepper_flash_clipboard_message_filter_qt.cpp \
        renderer/pepper/pepper_flash_renderer_host_qt.cpp \
        renderer/pepper/pepper_host_factory_qt.cpp \
        renderer/pepper/pepper_isolated_file_system_message_filter.cpp \
        renderer/pepper/pepper_renderer_host_factory_qt.cpp \
        renderer/render_frame_observer_qt.cpp \
        renderer/render_view_observer_qt.cpp \
        renderer/user_resource_controller.cpp \
        renderer/web_channel_ipc_transport.cpp \
        resource_bundle_qt.cpp \
        resource_context_qt.cpp \
        resource_dispatcher_host_delegate_qt.cpp \
        ssl_host_state_delegate_qt.cpp \
        stream_video_node.cpp \
        surface_factory_qt.cpp \
        type_conversion.cpp \
        url_request_context_getter_qt.cpp \
        url_request_custom_job.cpp \
        url_request_custom_job_delegate.cpp \
        url_request_qrc_job_qt.cpp \
        user_resource_controller_host.cpp \
        user_script.cpp \
        web_channel_ipc_transport_host.cpp \
        web_contents_adapter.cpp \
        web_contents_delegate_qt.cpp \
        web_contents_view_qt.cpp \
        web_engine_context.cpp \
        web_engine_error.cpp \
        web_engine_library_info.cpp \
        web_engine_settings.cpp \
        web_engine_visited_links_manager.cpp \
        web_event_factory.cpp \
        yuv_video_node.cpp

HEADERS = \
        access_token_store_qt.h \
        authentication_dialog_controller_p.h \
        authentication_dialog_controller.h \
        browser_accessibility_manager_qt.h \
        browser_accessibility_qt.h \
        browser_context_adapter.h \
        browser_context_adapter_client.h \
        browser_context_qt.h \
        browser_message_filter_qt.h \
        certificate_error_controller_p.h \
        certificate_error_controller.h \
        chromium_overrides.h \
        clipboard_qt.h \
        color_chooser_qt.h \
        color_chooser_controller_p.h \
        color_chooser_controller.h \
        common/qt_messages.h \
        common/user_script_data.h \
        content_client_qt.h \
        content_browser_client_qt.h \
        content_main_delegate_qt.h \
        cookie_monster_delegate_qt.h \
        custom_protocol_handler.h \
        delegated_frame_node.h \
        desktop_screen_qt.h \
        dev_tools_http_handler_delegate_qt.h \
        download_manager_delegate_qt.h \
        chromium_gpu_helper.h \
        favicon_manager_p.h \
        favicon_manager.h \
        file_picker_controller.h \
        gl_context_qt.h \
        gl_surface_qt.h \
        javascript_dialog_controller_p.h \
        javascript_dialog_controller.h \
        javascript_dialog_manager_qt.h \
        media_capture_devices_dispatcher.h \
        network_delegate_qt.h \
        ozone_platform_eglfs.h \
        permission_manager_qt.h \
        process_main.h \
        proxy_config_service_qt.h \
        qrc_protocol_handler_qt.h \
        render_view_observer_host_qt.h \
        render_widget_host_view_qt.h \
        render_widget_host_view_qt_delegate.h \
        renderer/content_renderer_client_qt.h \
        renderer/pepper/pepper_flash_browser_host_qt.h \
        renderer/pepper/pepper_flash_clipboard_message_filter_qt.h \
        renderer/pepper/pepper_flash_renderer_host_qt.h \
        renderer/pepper/pepper_host_factory_qt.h \
        renderer/pepper/pepper_isolated_file_system_message_filter.h \
        renderer/pepper/pepper_renderer_host_factory_qt.h \
        renderer/render_frame_observer_qt.h \
        renderer/render_view_observer_qt.h \
        renderer/user_resource_controller.h \
        renderer/web_channel_ipc_transport.h \
        resource_context_qt.h \
        resource_dispatcher_host_delegate_qt.h \
        ssl_host_state_delegate_qt.h \
        stream_video_node.h \
        surface_factory_qt.h \
        type_conversion.h \
        url_request_context_getter_qt.h \
        url_request_custom_job.h \
        url_request_custom_job_delegate.h \
        url_request_qrc_job_qt.h \
        user_resource_controller_host.h \
        user_script.h \
        web_channel_ipc_transport_host.h \
        web_contents_adapter.h \
        web_contents_adapter_client.h \
        web_contents_adapter_p.h \
        web_contents_delegate_qt.h \
        web_contents_view_qt.h \
        web_engine_context.h \
        web_engine_error.h \
        web_engine_library_info.h \
        web_engine_settings.h \
        web_engine_visited_links_manager.h \
        web_event_factory.h \
        yuv_video_node.h

qtHaveModule(positioning) {
    SOURCES += location_provider_qt.cpp
    HEADERS += location_provider_qt.h
    DEFINES += QT_USE_POSITIONING=1
}