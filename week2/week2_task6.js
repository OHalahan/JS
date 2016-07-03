document.getElementById("callPrintBtn").addEventListener("click", callPrint);

var student = {
    name : "David Rayy",
    sclass : "VI",
    rollno : 12
};

function callPrint() {
    document.getElementById("out6").innerHTML = listObj(student);
}

function listObj(obj) {
    var arr = [];
    for (var prop in obj) {
        arr.push(prop);
    }

    return arr;
}
