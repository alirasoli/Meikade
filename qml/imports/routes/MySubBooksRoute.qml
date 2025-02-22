import QtQuick 2.12
import globals 1.0
import logics 1.0
import AsemanQml.Viewport 2.0
import AsemanQml.Base 2.0

MySubBooksPage {
    id: dis
    ViewportType.maximumWidth: Viewport.viewport.width > Viewport.viewport.height && !Devices.isMobile? Viewport.viewport.height * 3 / 5 : 0
    ViewportType.touchToClose: true
    width: Constants.width
    height: Constants.height

    onAddBookRequest: Viewport.controller.trigger("dialog:/mypoems/add", {"bookId": bookId})
    onAddPoemRequest: Viewport.controller.trigger("dialog:/mypoems/poem/add", {"bookId": bookId})
    onPublishRequest: {
        if (AsemanGlobals.accessToken.length == 0) {
            Viewport.controller.trigger("float:/auth/float", {})
            return;
        }
        Viewport.controller.trigger("float:/mypoems/publish", {"bookId": bookId, "name": dis.title})
    }
}
