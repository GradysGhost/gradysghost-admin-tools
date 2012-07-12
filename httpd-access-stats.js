// Requires
var fs = require("fs");

// Config object - change values to suit your needs
var config = {
	contentSplitDelim : "\n",
	ipPattern : /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/,
	filesPattern : /^.*\"GET (.*) HTTP\/1\.1"/g,
	logFileRoot : "/home/ryan/Desktop/gradysghost-admin-tools/",
	logFiles : [ "test-data.log" ],
	logFileEncoding : "utf-8",
	documentRoot : "/var/www/vhosts/",
	showSourceCounts : true,
	showFileRequestCounts : false,
	checkFileSizes : false
};

// Empty dataset to store results in
var results = {
	content : "",
	ips : {},
	files : {}
};

// Init
console.log("Initializing...");

for (var f in config.logFiles) {
	console.log("Reading file " + config.logFileRoot + config.logFiles[f]);
	results.content += fs.readFileSync(config.logFileRoot + config.logFiles[f], config.logFileEncoding);
}
results.content = results.content.split(config.contentSplitDelim);
console.log("Initialized.");

if (config.showSourceCounts) {
	// Enumerate IP addresses
	for (var line in results.content) {
		var ip = results.content[line].match(config.ipPattern);
		if (ip != null) {
			ip = ip[0];
			if (!results.ips[ip]) {
				results.ips[ip] = 0;
			}
			++results.ips[ip];
		}
	}

	// Sort IPs by count
	dummy = [];
	for (var i in results.ips)
		dummy.push([i, results.ips[i]]);
	results.ips = {};
	dummy.sort(function (a, b) { return b[1] - a[1]; });
	for (var i = 0; i < dummy.length; ++i)
		results.ips[dummy[i][0]] = dummy[i][1];
}

if (config.showFileRequestCounts) {
	// Enumerate accessed files
	for (var line in results.content) {
		var file = config.filesPattern.exec(results.content[line]);
		
		if (file != null) {
			file = file[1];
			if (!results.files[file]) {
				results.files[file] = { count : 0, size : 0 };
				if (config.checkFileSizes) results.files[file].size = fs.statSync(config.documentRoot + file).size;
			}
			++results.files[file].count;
		}
	}

	// Sort files by count
	dummy = [];
	for (var i in results.files)
		dummy.push([i, results.files[i].count, results.files[i].size]);
	results.files = {};
	dummy.sort(function (a, b) { return b[1] - a[1]; });
	for (var i = 0; i < dummy.length; ++i)
		results.files[dummy[i][0]] = {
			count : dummy[i][1],
			size : dummy[i][2]
		};
}


// Output

if (config.showSourceCounts) {
	console.log(" * * * CLIENT ADDRESSES * * *");
	for (var i in results.ips) {
		console.log(i + " : " + results.ips[i] + " requests");
	}
}

if (config.showFileRequestCounts) {
	console.log("\n * * * FILES REQUESTED * * *");
	for (var i in results.files) {
		console.log(i + " : " + results.files[i].count);
	}
}
