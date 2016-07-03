document.getElementById("separateNum").addEventListener("click", separate);

function separate() {
    var solid = document.getElementById("solid").value;
    var groups = solid.toString().split(".");
    groups[0] = groups[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");

    document.getElementById("out12").innerHTML = groups.join(".");
}
