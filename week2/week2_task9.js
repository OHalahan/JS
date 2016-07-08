document.getElementById("callListBtn").addEventListener("click", callList);
var library = [{
    author: 'Bill Gates',
    title: 'The Road Ahead',
    readingStatus: true
}, {
    author: 'Steve Jobs',
    title: 'Walter Isaacson',
    readingStatus: true
}, {
    author: 'Suzanne Collins',
    title: 'Mockingjay: The Final Book of The Hunger Games',
    readingStatus: false
}];

function callList() {
    document.getElementById("out9").innerHTML = list(library);
}

function list(arr) {
    var full = [];
    for (var i = 0; i < arr.length; i++) {
        var status = '';
        if (arr[i]["readingStatus"]) {
            status = "was read.";
        } else {
            status = "was not read.\n";
        }
        full.push("Title: " + arr[i]["title"] + "; Author: " + arr[i]["author"] + "; Status: " + status);
    }
    return full = full.toString().split(',').join("<br />");
}
