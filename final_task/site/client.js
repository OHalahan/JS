function makeAjax(destination) {
    var xhr = new XMLHttpRequest();
    // Destination
    xhr.open('POST', '/api/' + destination);
    // Content will be in JSON format, utf-8 charset
    xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
    return xhr;
}

//should be called with a callback function to synchronise output
function callBooks(callback) {
    var request = makeAjax('get_books');
    request.send();
    request.onreadystatechange = function() {
        if (this.readyState === 4 && this.status === 200) {
            //console.log(this.response); // See console to see response
            var response = JSON.parse(this.response || "{}");
            if (response.success) {
                callback(response["books"]);
            }
        }
    }
}

function callbackSearchBooks() {
    searchBooks(createTableBody);
}

//should be called with a callback function to synchronise output
function searchBooks(callback) {
    var request = makeAjax('search');

    var title = (document.getElementById("title").value || ".*");
    var author = (document.getElementById("author").value || ".*");
    var section = (document.getElementById("section").value || ".*");
    var shelf = (document.getElementById("shelf").value || ".*");
    var taken = (document.getElementById("taken").value || ".*");

    var groupped = new Array(["title", title], ["author", author], ["section", section], ["shelf", shelf], ["taken", taken]);

    request.send(JSON.stringify({
        queries: groupped
    }));
    request.onreadystatechange = function() {
        if (this.readyState === 4 && this.status === 200) {
            //console.log(this.response); // See console to see response
            var response = JSON.parse(this.response || "{}");
            if (response.success) {
                callback(response["books"]);
            }
            else {
                callback([]);
            }
        }
    }
}

//called via callbacks and fills the table based on the provided array of "books"
function createTableBody(books) {
    var tableBody = document.getElementById("booksTable");
    while (tableBody.firstChild) {
        tableBody.removeChild(tableBody.firstChild);
    }
    var options = new Array("id", "title", "author", "section", "shelf", "taken");
    console.log(books);

    ordering(books);

    for (i = 0; i < books.length; i++) {

        var chk = document.createElement('INPUT');
        chk.type = "checkbox";
        chk.id = books[i]["id"];

        var tr = document.createElement('TR');
        for (j = -1; j < options.length; j++) {
            var td = document.createElement('TD');
            if (j === -1) {
                td.appendChild(chk);
            } else {
                td.appendChild(document.createTextNode(books[i][options[j]]));
            }
            tr.appendChild(td);
        }
        tableBody.appendChild(tr);
    }
}

function ordering(books) {
    var options = new Array("id", "title", "author", "section", "shelf", "taken");
    var strategy = options[document.getElementById("orderBy").selectedIndex];
    console.log(strategy);

    function sortByStrategy(x, y) {
        var xInt = parseInt(x[strategy], 10) ,
            yInt = parseInt(y[strategy], 10) ;

        if (Number.isInteger(parseInt(x[strategy], 10))) {
            xInt = parseInt(x[strategy], 10);
            yInt = parseInt(y[strategy], 10);
        } else {
            xInt = x[strategy];
            yInt = y[strategy];
        }

        if (xInt < yInt) {
            return -1;
        }
        if (xInt > yInt) {
            return 1;
        } else {
            return 0;
        }
    }
    books.sort(sortByStrategy);

}

function saveDB() {
    var request = makeAjax('save_db');
    request.send();
    request.onreadystatechange = function() {
        if (this.readyState === 4 && this.status === 200) {
            console.log(this.response); // See console to see response
            var response = JSON.parse(this.response || "{}");
            if (response.success) {
                return response.success;
            }
        }
    }
}

function checkAll() {
    var mainCheckbox = document.getElementById("checker");
    var checkboxes = document.getElementsByTagName('INPUT');
    if (mainCheckbox.checked) {
        for (var i = 0; i < checkboxes.length; i++) {
            if (checkboxes[i].type == 'checkbox') {
                checkboxes[i].checked = true;
            }
        }
    } else {
        for (var i = 0; i < checkboxes.length; i++) {
            console.log(i);
            if (checkboxes[i].type == 'checkbox') {
                checkboxes[i].checked = false;
            }
        }
    }
}

//find selected rows and send a list to backend
//call function to delete selected rows from table if success
function callbackDeleteSelectedFromDB() {
    deleteSelectedFromDB(deleteSelectedFromTable);
}
function deleteSelectedFromDB(callback) {

    var table = document.getElementById("booksTable");;
    var rowCount = table.rows.length;
    var foundIDs = new Array();

    for (var i = 0; i < rowCount; i++) {
        var row = table.rows[i];
        var chkbox = row.cells[0].childNodes[0];
        if (chkbox.checked) {
            foundIDs.push(chkbox["id"]);
        }
    }

    console.log("Selected books: " + foundIDs);

    var request = makeAjax('delete_books');
    request.send(JSON.stringify({
        books: foundIDs
    }));
    request.onreadystatechange = function() {
        if (this.readyState === 4 && this.status === 200) {
            console.log(this.response); // See console to see response
            var response = JSON.parse(this.response || "{}");
            if (response.success) {
                callback();
            } else {
                console.log("Failed to delete books: " + response.failed);
                callBooks(createTableBody);
            }
        }
    }
}

//deletes rows directly from table
//called via callback if backend confirms that selected rows were deleted
function deleteSelectedFromTable() {

    var table = document.getElementById("booksTable");
    var rowCount = table.rows.length;

    for (var i = 0; i < rowCount; i++) {
        var row = table.rows[i];
        var chkbox = row.cells[0].childNodes[0];
        if (chkbox.checked) {
            table.deleteRow(i);
            rowCount--;
            i--;
        }
    }
}

/*
function getServerLocalTime() {
    var xhr = new XMLHttpRequest();

    // Pay attention, that our server knows how to work with such destination
    // This is good practice
    xhr.open('POST', '/api/get_server_localtime');

    // Content will be in JSON format, utf-8 charset
    xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");

    xhr.onreadystatechange = function() {
        if (this.readyState === 4 && this.status === 200) {
            console.log(this.response); // See console to see response

            var response = JSON.parse(this.response || "{}");

            // Our internal checks. Maybe some backend task has been failed and response data is wrong
            if (response.success && response.localtime) {
                document.getElementById('localtime').value = response.localtime;
            }
        }
    }

    xhr.send(JSON.stringify({call: 'new'}));
}

function onFormSubmit(form) {
    var owner = form.owner.value || '',
        sn = form.sn.value || '';

    makeAjaxCall({
        owner: owner,
        serialNumber: sn,
        method: 'get_owner_info' // We will send this method as argument, however it's bad practice
    });

    alert('See browser console -> network to see the request');
}
*/
