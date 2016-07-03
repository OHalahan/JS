function isDate() {
    var string = document.getElementById("date").value;
    var parse= /^(3[01]|[12][0-9]|0?[1-9])-(1[0-2]|0?[1-9])-(?:[0-9]{2})?[0-9]{2}$/;

    if (parse.test(string)) {
        document.getElementById("out10").innerHTML = "Date is valid";
    }
    else {
        document.getElementById("out10").innerHTML = "Date is not valid. The date should be like: 22-06-2016";
    }
}
