/*
    SPDX-FileCopyrightText: 2022 Kyle McGrath <dualitykyle@pm.me>

    SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick 2.15
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.kquickcontrolsaddons 2.0 as KQuickControlsAddonsComponents
import org.kde.plasma.private.pager 2.0

GridLayout {
    id: root

    rows: pagerModel.layoutRows
    columns: Math.ceil(pagerModel.count / pagerModel.layoutRows)
    columnSpacing: 0
    rowSpacing: 0

    Plasmoid.preferredRepresentation: Plasmoid.fullRepresentation

    PagerModel {
        id: pagerModel

        enabled: root.visible
        screenGeometry: plasmoid.screenGeometry

        pagerType: PagerModel.VirtualDesktops
    }

    Repeater {
        id: indicatorRepeater
        model: pagerModel.count

        Rectangle {
            id: indicatorContainer
            
            color: "transparent"
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumWidth: PlasmaCore.Theme.defaultFont.pixelSize

            // TODO: Clean up and refactor this horrible, horrible mess
            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: {
                    if (mouse.button === Qt.LeftButton && Plasmoid.configuration.leftClickAction != 0) {
                        if (Plasmoid.configuration.leftClickAction == 1) {
                            if (pagerModel.currentPage < pagerModel.count - 1) {
                                pagerModel.changePage(pagerModel.currentPage + 1);
                            } else if (Plasmoid.configuration.desktopWrapOn) {
                                pagerModel.changePage(0);
                            }
                        } else if (Plasmoid.configuration.leftClickAction == 2) {
                            if (pagerModel.currentPage > 0) {
                                pagerModel.changePage(pagerModel.currentPage - 1);
                            } else if (Plasmoid.configuration.desktopWrapOn) {
                                pagerModel.changePage(pagerModel.count - 1);
                            }
                        }
                    } else if (mouse.button === Qt.RightButton && Plasmoid.configuration.rightClickAction != 0) {
                        if (Plasmoid.configuration.rightClickAction == 1) {
                            if (pagerModel.currentPage < pagerModel.count - 1) {
                                pagerModel.changePage(pagerModel.currentPage + 1);
                            } else if (Plasmoid.configuration.desktopWrapOn) {
                                pagerModel.changePage(0);
                            }
                        } else if (Plasmoid.configuration.rightClickAction == 2) {
                            if (pagerModel.currentPage > 0) {
                                pagerModel.changePage(pagerModel.currentPage - 1);
                            } else if (Plasmoid.configuration.desktopWrapOn) {
                                pagerModel.changePage(pagerModel.count -1);
                            }
                        }
                    }
                }
            }
            
            PlasmaComponents.Label {
                id: inidicatorDot
                
                anchors.centerIn: parent
                text: {
                    if (index == pagerModel.currentPage) {
                        return "●";
                    } else {
                        return "○";
                    }
                }
            }
        }
    }
}
