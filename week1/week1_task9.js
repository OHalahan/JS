document.getElementById("genRand").addEventListener("click", randomInterval);

function randomInterval() {
    var min = document.getElementById("min").value;
    var max = document.getElementById("max").value;
    if (Number(min) > Number(max)) {
        min = [max, max = min][0];
        //*show whether values were swapped if min > max
        console.log("min " + min);
        console.log("max " + max);
    }

    document.getElementById("out9").innerHTML = Math.floor(Math.random() * (max - min + 1)) + Number(min);
}
