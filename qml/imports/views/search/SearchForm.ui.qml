import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import AsemanQml.Controls 2.0
import AsemanQml.Models 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.IOSStyle 2.0
import globals 1.0
import micros 1.0
import models 1.0

Rectangle {
    id: searchForm
    width: Constants.width
    height: Constants.height
    clip: true
    color: Colors.deepBackground

    readonly property bool lightToolbar: Colors.lightHeader

    property alias keywordField: keywordField
    property alias listView: listView
    property alias headerItem: headerItem
    property alias poetsList: poetsList
    property alias listsList: listsList
    property alias poetsFilterArea: poetsFilterArea
    property alias domainText: domainText
    property alias busyIndicator: busyIndicator
    property alias resultHeaderLabel: resultHeaderLabel
    property alias closeBtn: closeBtn

    signal clicked(string link, int index)
    signal moreRequest()

    Label {
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 50 * Devices.density
        font.family: MaterialIcons.family
        font.pixelSize: 70 * Devices.fontDensity
        text: MaterialIcons.mdi_magnify
        opacity: 0.1
        visible: !busyIndicator.running && listView.count == 0
    }

    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        visible: listView.count == 0
    }

    ColumnLayout {
        id: headerColumn
        parent: listView.headerItem
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: 4 * Devices.density
        spacing: 4 * Devices.density

        Rectangle {
            Layout.fillWidth: true
            Layout.margins: 10 * Devices.density
            Layout.preferredHeight: Math.max(domainText.height + 20 * Devices.density, 40 * Devices.density)
            radius: Constants.radius
            color: Colors.lightBackground

            MouseArea {
                id: poetsFilterArea
                anchors.fill: parent
            }

            RowLayout {
                anchors.right: parent.right
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 20 * Devices.density
                spacing: 10 * Devices.density

                Label {
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 9 * Devices.fontDensity
                    color: Colors.accent
                    text: qsTr("Search domain:") + Translations.refresher
                }

                Label {
                    id: domainText
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    font.pixelSize: 9 * Devices.fontDensity
                    Layout.fillWidth: true
                }
            }
        }

        Label {
            id: resultHeaderLabel
            Layout.fillWidth: true
            Layout.leftMargin: 10 * Devices.density
            Layout.rightMargin: 10 * Devices.density
            Layout.preferredHeight: 20 * Devices.density
            Layout.bottomMargin: 20 * Devices.density
            font.pixelSize: 10 * Devices.fontDensity
            horizontalAlignment: Text.AlignLeft
        }

        Label {
            Layout.fillWidth: true
            Layout.leftMargin: 10 * Devices.density
            Layout.rightMargin: 10 * Devices.density
            Layout.preferredHeight: 20 * Devices.density
            font.pixelSize: 9 * Devices.fontDensity
            horizontalAlignment: Text.AlignLeft
            visible: poetsList.visible
            text: qsTr("Poets") + Translations.refresher
        }

        FlexiList {
            id: poetsList
            Layout.fillWidth: true
            Layout.bottomMargin: 30 * Devices.density
            Layout.preferredHeight: 100 * Devices.density
            interactive: false
        }

        Label {
            Layout.fillWidth: true
            Layout.leftMargin: 10 * Devices.density
            Layout.rightMargin: 10 * Devices.density
            Layout.preferredHeight: 20 * Devices.density
            font.pixelSize: 9 * Devices.fontDensity
            horizontalAlignment: Text.AlignLeft
            visible: listsList.visible
            text: qsTr("Public lists") + Translations.refresher
        }

        FlexiList {
            id: listsList
            Layout.fillWidth: true
            Layout.bottomMargin: 10 * Devices.density
            Layout.preferredHeight: 100 * Devices.density
            interactive: false
        }

        Label {
            Layout.fillWidth: true
            Layout.leftMargin: 10 * Devices.density
            Layout.rightMargin: 10 * Devices.density
            Layout.bottomMargin: 10 * Devices.density
            Layout.preferredHeight: 20 * Devices.density
            font.pixelSize: 9 * Devices.fontDensity
            horizontalAlignment: Text.AlignLeft
            visible: listView.count
            text: qsTr("Poems Texts") + Translations.refresher
        }
    }

    AsemanListView {
        id: listView
        anchors.bottom: parent.bottom
        anchors.top: headerItem.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        bottomMargin: 58 * Devices.density + Devices.navigationBarHeight

        onDragStarted: keywordField.focus = false
        onCountChanged: if (count == 0) initializeState = true

        property bool initializeState: true

        header: Item {
            width: listView.width
            height: headerColumn.height
        }

        footer: Item {
            width: listView.width
            height: 100 * Devices.density

            BusyIndicator {
                anchors.centerIn: parent
                running: !busyIndicator.visible && busyIndicator.running
            }
        }

        delegate: Rectangle {
            id: item
            width: listView.width
            height: column.height + 60 * Devices.density
            color: Colors.lightBackground

            Component.onCompleted: inited = true;

            property bool inited: false

            Connections {
                target: item
                onInitedChanged: if (model.index == listView.count - 10) moreRequest();
            }

            ItemDelegate {
                id: itemDel
                anchors.fill: parent

                Connections {
                    target: itemDel
                    onClicked: searchForm.clicked(model.link, model.index)
                }
            }

            ColumnLayout {
                id: column
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 20 * Devices.density
                y: 20 * Devices.density
                spacing: 6 * Devices.density

                Repeater {
                    model: AsemanListModel { data: verses }

                    Label {
                        Layout.fillWidth: true
                        text: model.text
                        font.pixelSize: 10 * Devices.fontDensity
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        horizontalAlignment: model.position === PoemVersesModel.PositionRight? Text.AlignRight : (model.position === PoemVersesModel.PositionLeft? Text.AlignLeft
                                             : (model.position === PoemVersesModel.PositionCenteredVerse1 || model.position === PoemVersesModel.PositionCenteredVerse2? Text.AlignHCenter
                                             : Text.AlignRight))

                        LayoutMirroring.enabled: false
                        LayoutMirroring.childrenInherit: true
                    }
                }
            }

            Rectangle {
                id: itemFooter
                height: 20 * Devices.density
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                color: Qt.lighter(Colors.primary)

                RowLayout {
                    anchors.right: parent.right
                    anchors.margins: 10 * Devices.density
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 4 * Devices.density

                    Label {
                        Layout.alignment: Qt.AlignLeft
                        text: model.poet.name
                        color: "#fff"
                        font.pixelSize: 8 * Devices.fontDensity
                    }

                    Label {
                        Layout.alignment: Qt.AlignVCenter
                        font.family: MaterialIcons.family
                        text: LayoutMirroring.enabled? MaterialIcons.mdi_chevron_left : MaterialIcons.mdi_chevron_right
                        color: "#fff"
                        font.pixelSize: 12 * Devices.fontDensity
                    }

                    Repeater {
                        model: AsemanListModel { data: categories }

                        RowLayout {
                            spacing: 4 * Devices.density

                            Label {
                                Layout.alignment: Qt.AlignLeft
                                text: model.title
                                color: "#fff"
                                font.pixelSize: 8 * Devices.fontDensity
                            }

                            Label {
                                Layout.alignment: Qt.AlignVCenter
                                font.family: MaterialIcons.family
                                text: LayoutMirroring.enabled? MaterialIcons.mdi_chevron_left : MaterialIcons.mdi_chevron_right
                                color: "#fff"
                                font.pixelSize: 12 * Devices.fontDensity
                            }
                        }
                    }

                    Label {
                        Layout.alignment: Qt.AlignLeft
                        Layout.fillWidth: true
                        text: model.poem.title
                        color: "#fff"
                        font.pixelSize: 8 * Devices.fontDensity
                    }

                }
            }
        }
    }

    HScrollBar {
        anchors.right: parent.right
        anchors.bottom: listView.bottom
        anchors.top: listView.top
        anchors.bottomMargin: listView.bottomMargin
        color: Colors.primary
        scrollArea: listView
    }

    Header {
        id: headerItem
        color: Colors.headerColor
        light: !Colors.lightHeader
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        shadow: Devices.isAndroid

        Rectangle {
            anchors.fill: parent
            anchors.rightMargin: (closeBtn.visible? closeBtn.width : 10 * Devices.density)
            anchors.leftMargin: 10 * Devices.density
            anchors.bottomMargin: 8 * Devices.density
            anchors.topMargin: 8 * Devices.density + Devices.statusBarHeight
            radius: Constants.radius
            color: "#000"
            opacity: Colors.lightHeader? 0.1 : 0.3
        }

        RowLayout {
            id: searchRow
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: Devices.statusBarHeight/2 - 2 * Devices.density
            spacing: 10 * Devices.density
            anchors.rightMargin: (closeBtn.visible? closeBtn.width : 20 * Devices.density)
            anchors.leftMargin: 20 * Devices.density

            Label {
                text: MaterialIcons.mdi_magnify
                font.family: MaterialIcons.family
                font.pixelSize: 16 * Devices.fontDensity
                color: Colors.headerTextColor
            }

            TextField {
                id: keywordField
                bottomPadding: Devices.isAndroid? 1 * Devices.density : 8 * Devices.density
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignLeft
                placeholderText: qsTr("Search") + Translations.refresher
                selectByMouse: true
                Material.theme: Colors.lightHeader? Material.Light : Material.Dark
                IOSStyle.theme: Colors.lightHeader? IOSStyle.Light : IOSStyle.Dark
                font.pixelSize: 9 * Devices.fontDensity
                inputMethodHints: Qt.ImhNoPredictiveText
                color: Colors.headerTextColor
                background: Item {}

                SamsungInputBugFixer {}
            }
        }

        RoundButton {
            id: closeBtn
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: Devices.statusBarHeight/2
            anchors.right: parent.right
            text: qsTr("Close") + Translations.refresher
            radius: 6 * Devices.density
            font.pixelSize: 8 * Devices.fontDensity
            IOSStyle.foreground: Colors.foreground
            IOSStyle.background: Colors.deepBackground
            Material.foreground: Colors.foreground
            Material.background: Colors.deepBackground
            visible: false
            Material.theme: Material.Dark
            Material.elevation: 0
        }

        RoundButton {
            anchors.right: searchRow.right
            anchors.rightMargin: -10 * Devices.density
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -1 * Devices.density + Devices.statusBarHeight / 2
            width: 40 * Devices.density
            height: width
            radius: width / 2
            flat: true
            font.family: MaterialIcons.family
            font.pixelSize: 16 * Devices.density
            text: MaterialIcons.mdi_close
            IOSStyle.foreground: Colors.headerTextColor
            Material.foreground: Colors.headerTextColor
            visible: keywordField.text.length
            onClicked: keywordField.text = ""
        }
    }
}
