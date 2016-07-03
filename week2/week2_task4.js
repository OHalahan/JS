document.getElementById("hTrigger").addEventListener("mouseover", highlight);
document.getElementById("hTrigger").addEventListener("mouseout", goBlack);

var bold = document.getElementById("highlightHere").getElementsByTagName("b");

function highlight() {
    for (var i = 0; i < bold.length; i++) {
        bold[i].style.color = "#1976D2";
    }
}

function goBlack() {
    for (var i = 0; i < bold.length; i++) {
        bold[i].style.color = "black";
    }
}
