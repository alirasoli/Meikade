import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import AsemanQml.Viewport 2.0
import views 1.0
import globals 1.0
import models 1.0

PoetView {
    width: Constants.width
    height: Constants.height

    property string url
    property variant properties
    property alias id: catsModel.poetId
    property alias navigData: navigModel.data

    AsemanListModel {
        id: navigModel
        data: [
            {
                "title": title,
                "link": url,
                "properties": Tools.jsonToVariant( Tools.variantToJson(properties) )
            }
        ]
    }

    bioBtn.onClicked: Viewport.controller.trigger("popup:/poet/bio")
    menuBtn.onClicked: ViewportType.open = false

    gridView {
        onLinkRequest: {
            var navigData = navigModel.data;
            navigData[navigData.length] = {
                "title": properties.title,
                "link": link,
                "properties": Tools.jsonToVariant( Tools.variantToJson(properties) )
            };
            properties["navigData"] = navigData;

            Viewport.controller.trigger(link, properties)
        }
        model: CatsModel {
            id: catsModel
            cachePath: AsemanGlobals.cachePath + "/poet-" + poetId + ".cache"
        }
    }
}
