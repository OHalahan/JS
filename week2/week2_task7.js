document.getElementById("callDelBtn").addEventListener("click", callDel);
document.getElementById("out71").innerHTML = "Before: " + listObj(student);

function callDel() {
    delProp(student, "rollno");
    document.getElementById("out72").innerHTML = "After: " + listObj(student);
}

function delProp(obj, prop) {
    if (obj[prop]) {
        delete obj[prop];
    }
    else {
        console.log("No such property");
    }
}
