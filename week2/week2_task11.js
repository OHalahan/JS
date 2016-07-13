document.getElementById("convertCallBtn").addEventListener("click", convertCall);

function convertCall() {
    document.getElementById("out11").innerHTML = convert(student);
}

function convert(obj) {
    var pairs = [];
    for (var prop in obj) {
        pairs.push("[" + prop + ", " + obj[prop] + "]");
    }
    return pairs;
}
