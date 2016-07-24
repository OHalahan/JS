window.addEventListener("load", callbackSearchBooks);
document.getElementById("checker").addEventListener("change", checkAll);
document.getElementById("search").addEventListener("click", callbackSearchBooks);
document.getElementById("delete").addEventListener("click", callbackDeleteSelectedFromDB);
document.getElementById("orderBy").addEventListener("change", callbackSearchBooks);
document.getElementById("saveNewBook").addEventListener("click", addBook);
document.getElementById("save").addEventListener("click", saveDB);
