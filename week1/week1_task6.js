document.getElementById("sortOut").addEventListener("click", sortString);

function sortString() {
    var string = document.getElementById("sorting").value;
    document.getElementById("out6").innerHTML = string.split('').sort().join('');
}
