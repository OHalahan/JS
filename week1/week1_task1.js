document.getElementById("conv").addEventListener("click", returnConverted);

function returnConverted(){
    var temp = document.getElementById("temp").value;
    if ( document.getElementById("scaleC").checked ) {
        document.getElementById("out1").innerHTML = temp + "C is " + ( ( ( temp / 5 ) * 9 ) + 32 ) + "F";
    }
    else {
        document.getElementById("out1").innerHTML = temp + "F is " + ( ( ( temp - 32 ) / 9 ) * 5 ) + "C";
    }
}
