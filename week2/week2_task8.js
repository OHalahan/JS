document.getElementById("objLnCallBtn").addEventListener("click", objLnCall);

function objLnCall() {
    document.getElementById("out8").innerHTML = "Length: " + objLn(student);
}

function objLn(obj) {
    var arr = [];
    for (var prop in obj) {
        arr.push(prop);
    }
    return arr.length;
}
