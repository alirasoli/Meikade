import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import AsemanQml.Controls 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.IOSStyle 2.0
import globals 1.0
import micros 1.0

Item {
    id: searchForm
    width: Constants.width
    height: Constants.height
    property alias keywordField: keywordField
    property alias domainBtn: domainBtn
    property alias gridView: gridView

    property alias headerItem: headerItem
    property alias filtersLabel: filtersLabel

    signal clicked(string link)

    ColumnLayout {
        id: headerColumn
        parent: gridView.headerItem
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: 4 * Devices.density
        spacing: 14 * Devices.density

        RoundedItem {
            Layout.fillWidth: true
            Layout.topMargin: 20 * Devices.density
            Layout.preferredHeight: rowLayout.height + 24 * Devices.density
            radius: Constants.radius

            Rectangle {
                anchors.fill: parent
                color: Colors.background
            }

            RowLayout {
                id: rowLayout
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 15 * Devices.density

                Label {
                    Material.foreground: Material.accent
                    text: qsTr("Search domain:") + Translations.refresher
                    font.pixelSize: 8 * Devices.fontDensity
                }

                Label {
                    id: filtersLabel
                    Layout.fillWidth: true
                    text: "filter 1 | filter 2"
                    font.pixelSize: 8 * Devices.fontDensity
                }
            }

            ItemDelegate {
                id: domainBtn
                anchors.fill: parent
                hoverEnabled: false
            }
        }

        Label {
            Layout.fillWidth: true
            Layout.bottomMargin: 4 * Devices.density
            font.pixelSize: 10 * Devices.fontDensity
            text: qsTr("Frequently Poets:") + Translations.refresher
        }
    }

    FlexiList {
        id: gridView
        anchors.bottom: parent.bottom
        anchors.top: tabBar.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.leftMargin: 10 * Devices.density
        anchors.rightMargin: 10 * Devices.density

        header: Item {
            width: gridView.width
            height: headerColumn.height
        }
    }

    HScrollBar {
        anchors.right: parent.right
        anchors.bottom: gridView.bottom
        anchors.top: gridView.top
        color: Colors.primary
        scrollArea: gridView
    }

    Rectangle {
        anchors.fill: tabBar
        color: Colors.deepBackground
    }

    TabBar {
        id: tabBar
        anchors.top: headerItem.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        Material.accent: Material.primary

        TabButton {
            text: qsTr("Poem") + Translations.refresher
            font.pixelSize: 9 * Devices.fontDensity
        }
        TabButton {
            text: qsTr("Poet") + Translations.refresher
            font.pixelSize: 9 * Devices.fontDensity
        }
    }

    Header {
        id: headerItem
        color: Colors.primary
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        shadow: Devices.isAndroid

        RowLayout {
            anchors.left: parent.left
            anchors.right: parent.right
            height: Devices.standardTitleBarHeight
            spacing: 10 * Devices.density
            anchors.rightMargin: 10 * Devices.density
            anchors.leftMargin: 10 * Devices.density
            anchors.bottom: parent.bottom

            Label {
                text: MaterialIcons.mdi_magnify
                font.family: MaterialIcons.family
                font.pixelSize: 18 * Devices.fontDensity
                color: "#fff"
            }

            TextField {
                id: keywordField
                bottomPadding: 8 * Devices.density
                Layout.fillWidth: true
                placeholderText: qsTr("Search") + Translations.refresher
                Material.theme: Material.Dark
                IOSStyle.theme: IOSStyle.Dark
                font.pixelSize: 9 * Devices.fontDensity
                background: Item {}
            }
        }
    }
}