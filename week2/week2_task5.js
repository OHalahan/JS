window.addEventListener("resize", getSize);
window.addEventListener("load", getSize);

function getSize() {
    var width = document.documentElement.clientWidth;
    var heigth  = document.documentElement.clientHeight;
    document.getElementById("out5").innerHTML = "Heigth: " + heigth + " Width: " + width;
}
