import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.2
import Qt.labs.folderlistmodel 2.1
import Qt.labs.settings 1.0

import MuseScore 3.0


MuseScore {
	menuPath: "Plugins.Daily Log.Configure"
	description: "Configuration for the daily log function."
	version: "1.0.0"
	pluginType: "dialog"
	requiresScore: false
	id: 'pluginId'

	width:  600
	height: 160

	onRun: {
		templateSelectDialog.folder = ((Qt.platform.os == "windows")? "file:///" : "file://") + templateScore.text;
		directorySelectDialog.folder = ((Qt.platform.os == "windows")? "file:///" : "file://") + logDirectory.text;
	}

	Component.onDestruction: {
		settings.logDirectory = logDirectory.text;
		settings.templateScore = templateScore.text;
	}

	Settings {
		id: settings
		category: "Plugin-DailyLog"
		property alias logDirectory: logDirectory.text
		property alias templateScore: templateScore.text
	}

	FileDialog {
		id: directorySelectDialog
		title: qsTranslate("MS::PathListDialog", "Choose a directory")
		selectFolder: true
		visible: false
		onAccepted: {
			logDirectory.text = this.folder.toString().replace("file://", "").replace(/^\/(.:\/)(.*)$/, "$1$2");
		}
		Component.onCompleted: visible = false
	}

	FileDialog {
		id: templateSelectDialog
		title: qsTranslate("Ms::NewWizardTemplatePage", "Choose template file:")
		selectFolder: false
		visible: false
		nameFilters: [ "MuseScore files (*.mscz *.mscx)", "All files (*)" ]
		onAccepted: {
			templateScore.text = this.fileUrl.toString().replace("file://", "").replace(/^\/(.:\/)(.*)$/, "$1$2");
		}
		Component.onCompleted: visible = false
	}

	GridLayout {
		columns: 3
		anchors.fill: parent
		anchors.margins: 10

		Label {
			text: qsTranslate("Ms::NewWizardTemplatePage", "Choose template file:")
		}
		Button {
			id: selectTemplate
			text: qsTranslate("PrefsDialogBase", "Browse...")
			onClicked: {
				templateSelectDialog.open();
			}
		}
		Label {
			id: templateScore
			text: ""
			Layout.fillWidth: true
		}

		Label {
			text: qsTranslate("PrefsDialogBase", "Score folder")
		}
		Button {
			id: selectDirectory
			text: qsTranslate("PrefsDialogBase", "Browse...")
			onClicked: {
				directorySelectDialog.open();
			}
		}
		Label {
			id: logDirectory
			text: ""
		}

		Button {
			id: closeButton
			Layout.columnSpan: 3
			text: qsTranslate("action", "Close")
			onClicked: {
				//settings.logDirectory = logDirectory.text;
				//settings.templateScore = templateScore.text;
				pluginId.parent.Window.window.close();
			}
		}
	}
}
