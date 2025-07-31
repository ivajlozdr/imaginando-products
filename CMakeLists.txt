cmake_minimum_required(VERSION 3.16)

project(imaginando VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)
find_package(Qt6 REQUIRED COMPONENTS QuickControls2)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(imgpp
    main.cpp
    Images.qrc
)

qt_add_qml_module(imgpp
    URI imaginando
    VERSION 1.0
    QML_FILES
        Main.qml
        Styles.qml
        ProductCard.qml
        ModuleCard.qml
        SidebarItem.qml
        Login.qml
        DownloadingOverlay.qml
        Settings.qml
    SOURCES
        controller.cpp
        controller.h
        product.h
        product.cpp
        modules.h
        modules.cpp
    RESOURCES
        Images.qrc
        icon.rc
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(imgpp PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.imgpp
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

if(WIN32)
    target_sources(imgpp PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/icon.rc)
endif()

target_link_libraries(imgpp PRIVATE Qt6::Quick)
target_link_libraries(imgpp PRIVATE Qt6::QuickControls2)

include(GNUInstallDirs)
install(TARGETS imgpp
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
