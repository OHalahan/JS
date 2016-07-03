document.getElementById("removeItemBtn").addEventListener("click", removeItem);

function removeItem() {
    var item = document.getElementById("colorSelect");
    item.remove(item.selectedIndex);
}
