// Requires
var fs = require("fs");

// Config object - change values to suit your needs
var config = {
	contentSplitDelim : "\n",
	ipPattern : /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/,
	filesPattern : /^.*\"GET (.*) HTTP\/1\.1"/g,
	logFileRoot : "/var/log/httpd/",
	logFiles : [ "access_log" ],
	logFileEncoding : "utf-8",
	documentRoot : "/var/www/vhosts/",
	ipForAccess : "127.0.0.1",
	showSourceCounts : true,
	showFileRequestCounts : true,
	checkFileSizes : false, /* Only enable when running this script on the web server itself, and do so with extreme caution */
	showAccessByIp : true
};

// Empty dataset to store results in
var results = {
	content : "",
	ips : {},
	files : {},
	requests : {}
};

// Init
console.log("Initializing...");

for (var f in config.logFiles) {
	console.log("Scanning file " + config.logFileRoot + config.logFiles[f]);
	results.content += fs.readFileSync(config.logFileRoot + config.logFiles[f], config.logFileEncoding);
	results.content = results.content.split(config.contentSplitDelim);

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

	if (config.showAccessByIp) {
		for (var i = 0; i < results.content.length; ++i)
			if (results.content[i].search(config.ipForAccess) >= 0)
				results.requests[i] = results.content[i];
	}
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

if (config.showAccessByIp) {
	console.log(" * * * ACCESS ENTRIES FOR " + config.ipForAccess + " * * *");
	for (var i in results.requests)
		console.log(results.requests[i]);
}
