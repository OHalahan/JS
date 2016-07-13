document.getElementById("makeCallBtn").addEventListener("click", makeCall);

var call = new XMLHttpRequest();
call.onreadystatechange = function() {
    if (this.readyState === 4 && this.status === 200) {
        var data = JSON.parse(this.response);
        logMessage(data.school);
    }
}
call.addEventListener("readystatechange", call.onreadystatechange);

function logMessage(msg) {
    document.getElementById("out12").innerHTML = msg + "<br>";
}

function makeCall() {
    call.open("GET", "http://courses.dce.harvard.edu/~cscie3/ajax.php");
    call.send();
}
