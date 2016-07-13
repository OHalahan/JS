document.getElementById("binaryConvert").addEventListener("click", binToDec);

function binToDec() {
    var bin = document.getElementById("binary").value;
    document.getElementById("out8").innerHTML = parseInt(bin, 2);
}
