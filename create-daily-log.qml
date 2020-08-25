import QtQuick 2.2
import Qt.labs.settings 1.0

import MuseScore 3.0


MuseScore {
	menuPath: "Plugins.Daily Log.Create New Entry"
	description: "Create a new daily log according to the provided configuration.\nTimestamp is in the format YYYYMMDD-HHMMSS."
	version: "1.0.0"
//	pluginType: undefined
	requiresScore: false
	id: 'pluginId'

	Settings {
		id: settings
		category: "Plugin-DailyLog"
		property string logDirectory
		property string templateScore
	}

	onRun: {
		// Generate file name
		var timestamp = (new Date()).toISOString(); //format ISO 8601 YYYY-MM-DDTHH:MM:SS.mmmZ
		var timestampFilter = /(\d+)\-(\d+)\-(\d+)T(\d+):(\d+):(\d+)\.\d+Z/;
		var timestampReformat = '$1$2$3-$4$5$6';
		var newFileName = settings.logDirectory + "//" + timestamp.replace(timestampFilter, timestampReformat);
		// Open the template
		var templateScore = readScore(settings.templateScore);
		// 'Save As' the template
		writeScore(templateScore, newFileName, 'mscz');
		closeScore(templateScore);
		// Load the newly created copy
		var todayScore = readScore(newFileName + '.mscz');
		// Update information
		todayScore.setMetaTag("creationDate", timestamp.replace(timestampFilter, '$1-$2-$3'));
		todayScore.setMetaTag("workTitle", 'Daily Log ' + timestamp.replace(timestampFilter, '$1-$2-$3'));
		writeScore(todayScore, newFileName, 'mscz');
	}
}
