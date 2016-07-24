function goodNewsAdd() {
    var target = document.getElementById("alerts");

    var myDiv = document.createElement("DIV");
    myDiv.className = "alert alert-success";
    myDiv.innerHTML += '<span class="glyphicon glyphicon-ok" aria-hidden="true"></span>';
    myDiv.innerHTML += '<a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>';
    myDiv.innerHTML += '  Book was succesfully added.';

    target.appendChild(myDiv);

    setTimeout(function() {
        myDiv.parentNode.removeChild(myDiv);
    }, 4000);

}

function badNewsAdd() {
    var target = document.getElementById("alerts");

    var myDiv = document.createElement("DIV");
    myDiv.className = "alert alert-danger";
    myDiv.innerHTML += '<span class="glyphicon glyphicon-exclamation-sign" aria-hidden="true"></span>';
    myDiv.innerHTML += '<a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>';
    myDiv.innerHTML += '  Failed to add book.';

    target.appendChild(myDiv);
    setTimeout(function() {
        myDiv.parentNode.removeChild(myDiv);
    }, 4000);

}

function goodNewsDelete() {
    var target = document.getElementById("alerts");

    var myDiv = document.createElement("DIV");
    myDiv.className = "alert alert-success";
    myDiv.innerHTML += '<span class="glyphicon glyphicon-ok" aria-hidden="true"></span>';
    myDiv.innerHTML += '<a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>';
    myDiv.innerHTML += '  Books were succesfully deleted.';

    target.appendChild(myDiv);

    setTimeout(function() {
        myDiv.parentNode.removeChild(myDiv);
    }, 4000);

}

function badNewsDelete() {
    var target = document.getElementById("alerts");

    var myDiv = document.createElement("DIV");
    myDiv.className = "alert alert-danger";
    myDiv.innerHTML += '<span class="glyphicon glyphicon-exclamation-sign" aria-hidden="true"></span>';
    myDiv.innerHTML += '<a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>';
    myDiv.innerHTML += '  Failed to delete book(s).';
    target.appendChild(myDiv);
    setTimeout(function() {
        myDiv.parentNode.removeChild(myDiv);
    }, 4000);

}

function goodNewsSave() {
    var target = document.getElementById("alerts");

    var myDiv = document.createElement("DIV");
    myDiv.className = "alert alert-success";
    myDiv.innerHTML += '<span class="glyphicon glyphicon-ok" aria-hidden="true"></span>';
    myDiv.innerHTML += '<a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>';
    myDiv.innerHTML += '  Books were succesfully Saved.';

    target.appendChild(myDiv);

    setTimeout(function() {
        myDiv.parentNode.removeChild(myDiv);
    }, 4000);

}

function badNewsSave() {
    var target = document.getElementById("alerts");

    var myDiv = document.createElement("DIV");
    myDiv.className = "alert alert-danger";
    myDiv.innerHTML += '<span class="glyphicon glyphicon-exclamation-sign" aria-hidden="true"></span>';
    myDiv.innerHTML += '<a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>';
    myDiv.innerHTML += '  Failed to save books.';

    target.appendChild(myDiv);
    setTimeout(function() {
        myDiv.parentNode.removeChild(myDiv);
    }, 4000);

}

function addWarn() {
    var target = document.getElementById("alerts");
    var isWarning = document.getElementById("notSaved");
    if (isWarning) {
        isWarning.parentNode.removeChild(isWarning);
    }

    var myDiv = document.createElement("DIV");
    myDiv.className = "alert alert-warning";
    myDiv.id = "notSaved";
    myDiv.innerHTML += '<span class="glyphicon glyphicon-warning-sign" aria-hidden="true"></span>';
    myDiv.innerHTML += "  Save changes or they will be lost after server restart.";

    target.appendChild(myDiv);

}

function removeWarn() {
    var isWarning = document.getElementById("notSaved");
    if (isWarning) {
        isWarning.parentNode.removeChild(isWarning);
    }
}
